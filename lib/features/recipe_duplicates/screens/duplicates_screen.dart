import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/recipe_image.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../services/duplicate_finder.dart';
import '../services/recipe_merger.dart';

// ---------------------------------------------------------------------------
// Duplikatsfinder (Kachel in „Weiteres") — findet doppelte oder sehr ähnliche
// Rezepte (gleiche Quelle, gleicher Name, ähnliche Zutaten) im lokalen
// Rezept-Cache. Pro Gruppe: antippen, welches Rezept bleibt → „Zusammen-
// führen" übernimmt Kategorien/Schlagworte/Utensilien/Notizen/geplante
// Mahlzeiten/Favorit und löscht die anderen (recipe_merger.dart). „Kein
// Duplikat" merkt sich die Paare dauerhaft auf diesem Gerät.
// ---------------------------------------------------------------------------

const _kIgnoredPairs = 'duplicate_ignored_pairs';

class DuplicatesScreen extends ConsumerStatefulWidget {
  const DuplicatesScreen({super.key});

  @override
  ConsumerState<DuplicatesScreen> createState() => _DuplicatesScreenState();
}

class _DuplicatesScreenState extends ConsumerState<DuplicatesScreen> {
  List<DuplicateGroup>? _groups;
  bool _scanning = false;
  Set<String> _ignored = {};

  /// „Kein Duplikat"-Paare geladen — vorher nicht suchen, sonst blitzen
  /// ausgeblendete Gruppen kurz auf.
  bool _ready = false;

  /// Gewähltes „bleibt"-Rezept je Gruppe (Schlüssel = erste ID der Gruppe).
  final Map<String, String> _keep = {};
  final Set<String> _busy = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _ignored = (prefs.getStringList(_kIgnoredPairs) ?? const []).toSet();
    } catch (_) {}
    _ready = true;
    await _scan();
  }

  Future<void> _saveIgnored() async {
    try {
      await (await SharedPreferences.getInstance())
          .setStringList(_kIgnoredPairs, _ignored.toList());
    } catch (_) {}
  }

  Future<void> _scan() async {
    final recipes = ref.read(recipesProvider).valueOrNull;
    if (recipes == null) return; // Liste lädt noch → build() stößt neu an
    setState(() => _scanning = true);
    final input = DuplicateSearchInput(
      [for (final r in recipes) DuplicateInput.fromRecipe(r)],
      Set.of(_ignored),
    );
    // Große Bibliotheken im Hintergrund-Isolate durchsuchen (kein Ruckeln).
    final groups = recipes.length > 400
        ? await compute(findDuplicates, input)
        : findDuplicates(input);
    if (!mounted) return;
    setState(() {
      _groups = groups;
      _scanning = false;
    });
  }

  String _groupKey(DuplicateGroup g) => g.ids.first;

  /// Vorschlag, welches Rezept bleibt: eines, das der Nutzer nicht löschen
  /// darf, sonst das „gepflegteste" (gekocht, bewertet, Bild, Inhalt),
  /// bei Gleichstand das älteste.
  String _defaultKeep(List<RecipeDetail> rs, UserPermissions perms) {
    final locked = rs.where((r) => !canDeleteRecipe(perms, r)).toList();
    if (locked.isNotEmpty) return locked.first.id;
    // Bearbeitbar zählt viel: nur dann landen Kategorien, Schlagworte,
    // Utensilien und Notizen der anderen im Rezept, das bleibt.
    double score(RecipeDetail r) =>
        (canSurelyEditRecipe(perms, r) ? 10 : 0) +
        (r.lastMade != null ? 4 : 0) +
        ((r.rating ?? 0) > 0 ? 2 : 0) +
        ((r.image ?? '').isNotEmpty ? 1 : 0) +
        r.comments.length +
        r.notes.length +
        r.recipeIngredient.length * 0.1 +
        r.recipeInstructions.length * 0.1;
    final sorted = [...rs]..sort((a, b) {
        final s = score(b).compareTo(score(a));
        if (s != 0) return s;
        return (a.dateAdded ?? '').compareTo(b.dateAdded ?? '');
      });
    return sorted.first.id;
  }

  void _ignore(DuplicateGroup g) {
    HapticFeedback.selectionClick();
    setState(() {
      for (var i = 0; i < g.ids.length; i++) {
        for (var j = i + 1; j < g.ids.length; j++) {
          _ignored.add(duplicatePairKey(g.ids[i], g.ids[j]));
        }
      }
      _groups = [...?_groups]..remove(g);
    });
    _saveIgnored();
  }

  Future<void> _resetIgnored() async {
    setState(() => _ignored = {});
    await _saveIgnored();
    await _scan();
  }

  Future<void> _merge(DuplicateGroup g, List<RecipeDetail> rs) async {
    final l = AppLocalizations.of(context)!;
    final keepId = _keep[_groupKey(g)]!;
    final keep = rs.firstWhere((r) => r.id == keepId);
    final remove = rs.where((r) => r.id != keepId).toList();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        backgroundColor: context.appCard,
        title: Text(l.duplicatesMergeTitle,
            style: TextStyle(color: context.appFg)),
        content: Text(
            [
              l.duplicatesMergeMessage(keep.name, remove.length),
              // Fremdes/gesperrtes Rezept bleibt → nichts hinein übernehmen.
              if (!canSurelyEditRecipe(ref.read(userPermissionsProvider), keep))
                l.duplicatesMergeNoEditHint,
            ].join('\n\n'),
            style: TextStyle(color: context.appFgSub)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.duplicatesMerge),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _busy.add(_groupKey(g)));
    try {
      await mergeDuplicateRecipes(ref, keep: keep, remove: remove);
      if (!mounted) return;
      setState(() => _groups = [...?_groups]..remove(g));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.duplicatesMerged)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e is DuplicateMergeNotAllowed
              ? l.recipeDeleteOwnerOnlyHint
              : userErrorMessage(e, l.deleteFailed))));
      // Teilweise gelöscht? Lieber neu suchen als einen alten Stand zeigen.
      await _scan();
    } finally {
      if (mounted) setState(() => _busy.remove(_groupKey(g)));
    }
  }

  Future<void> _deleteOne(DuplicateGroup g, RecipeDetail r) async {
    final l = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        backgroundColor: context.appCard,
        title:
            Text(l.confirmDeleteTitle, style: TextStyle(color: context.appFg)),
        content: Text('${r.name}\n\n${l.confirmDeleteMessage}',
            style: TextStyle(color: context.appFgSub)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(apiServiceProvider).deleteRecipe(r.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(userErrorMessage(e, l.deleteFailed))));
      }
      return;
    }
    ref.read(recipesProvider.notifier).removeById(r.id);
    if (!mounted) return;
    setState(() {
      final rest = g.ids.where((id) => id != r.id).toList();
      final list = [...?_groups];
      final i = list.indexOf(g);
      if (i >= 0) {
        if (rest.length >= 2) {
          list[i] = DuplicateGroup(
              ids: rest,
              reason: g.reason,
              ingredientOverlap: g.ingredientOverlap);
        } else {
          list.removeAt(i);
        }
      }
      _groups = list;
      _keep.remove(_groupKey(g));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final recipesAsync = ref.watch(recipesProvider);
    final all = recipesAsync.valueOrNull;
    // Rezeptliste kam erst nach dem Öffnen an → jetzt suchen.
    if (_ready && all != null && _groups == null && !_scanning) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _groups == null && !_scanning) _scan();
      });
    }
    final byId = {for (final r in all ?? const <RecipeDetail>[]) r.id: r};
    final perms = ref.watch(userPermissionsProvider);
    final settings = ref.watch(settingsProvider).valueOrNull;

    // Gruppen gegen den aktuellen Cache auflösen (gelöschte fallen weg).
    final visible = <(DuplicateGroup, List<RecipeDetail>)>[];
    for (final g in _groups ?? const <DuplicateGroup>[]) {
      final rs = [
        for (final id in g.ids)
          if (byId[id] != null) byId[id]!,
      ];
      if (rs.length >= 2) visible.add((g, rs));
    }

    Widget body;
    if (_groups == null) {
      body = Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 14),
          Text(l.duplicatesScanning, style: TextStyle(color: context.appFgSub)),
        ]),
      );
    } else {
      body = ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Text(
            visible.isEmpty
                ? l.duplicatesNone
                : '${l.duplicatesFound(visible.length)}\n${l.duplicatesIntro}',
            style: TextStyle(color: context.appFgSub, height: 1.4),
          ),
          if (_ignored.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _resetIgnored,
                icon: const Icon(Icons.restore_rounded, size: 18),
                label: Text(l.duplicatesResetIgnored(_ignored.length)),
              ),
            ),
          const SizedBox(height: 12),
          for (final (g, rs) in visible)
            _groupCard(context, l, g, rs, perms, settings?.serverUrl ?? '',
                settings?.apiToken ?? ''),
        ],
      );
    }

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Text(l.duplicatesTitle),
        actions: [
          IconButton(
            tooltip: l.duplicatesRescan,
            onPressed: _scanning ? null : _scan,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: WithCookingModeFAB(
        child: SafeArea(top: false, child: body),
      ),
    );
  }

  Widget _groupCard(
    BuildContext context,
    AppLocalizations l,
    DuplicateGroup g,
    List<RecipeDetail> rs,
    UserPermissions perms,
    String baseUrl,
    String token,
  ) {
    final key = _groupKey(g);
    var keepId = _keep[key];
    if (keepId == null || !rs.any((r) => r.id == keepId)) {
      keepId = _keep[key] = _defaultKeep(rs, perms);
    }
    final busy = _busy.contains(key);
    final blocked = rs
        .where((r) => r.id != keepId && !canDeleteRecipe(perms, r))
        .isNotEmpty;
    final (icon, reason) = switch (g.reason) {
      DuplicateReason.sameSource => (
          Icons.link_rounded,
          l.duplicatesReasonSource
        ),
      DuplicateReason.sameName => (Icons.title_rounded, l.duplicatesReasonName),
      DuplicateReason.similar => (
          Icons.compare_arrows_rounded,
          l.duplicatesReasonSimilar((g.ingredientOverlap * 100).round())
        ),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(AppTokens.rLg),
        border: Border.all(color: context.appSeparator, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Row(children: [
              Icon(icon, size: 18, color: AppTokens.accentDeep),
              const SizedBox(width: 6),
              Expanded(
                child: Text(reason,
                    style: TextStyle(
                        color: AppTokens.accentDeep,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
          for (final r in rs)
            _recipeRow(context, l, g, r, r.id == keepId, perms, baseUrl, token,
                enabled: !busy),
          if (blocked)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
              child: Text(l.recipeDeleteOwnerOnlyHint,
                  style: TextStyle(color: context.appFgSub, fontSize: 12)),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 12, 10),
            child: Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                TextButton(
                  onPressed: busy ? null : () => _ignore(g),
                  child: Text(l.duplicatesNotDuplicate),
                ),
                FilledButton.icon(
                  style:
                      FilledButton.styleFrom(backgroundColor: AppTokens.accent),
                  onPressed: busy || blocked ? null : () => _merge(g, rs),
                  icon: busy
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.merge_rounded),
                  label: Text(l.duplicatesMerge),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recipeRow(
    BuildContext context,
    AppLocalizations l,
    DuplicateGroup g,
    RecipeDetail r,
    bool kept,
    UserPermissions perms,
    String baseUrl,
    String token, {
    required bool enabled,
  }) {
    final locale = Localizations.localeOf(context).toString();
    final added = DateTime.tryParse(r.dateAdded ?? '');
    final host = normalizeSourceUrl(r.orgUrl)?.split('/').first;
    final meta = [
      l.duplicatesIngredientCount(r.recipeIngredient.length),
      if (added != null) DateFormat.yMd(locale).format(added),
      if (host != null) host,
    ].join(' · ');

    return InkWell(
      onTap: enabled
          ? () {
              HapticFeedback.selectionClick();
              setState(() => _keep[_groupKey(g)] = r.id);
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
        child: Row(children: [
          Icon(
            kept ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: kept ? AppTokens.accent : context.appFgTertiary,
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 52,
              height: 52,
              child: RecipeImage(
                recipeId: r.id,
                imageUrl:
                    '$baseUrl/api/media/recipes/${r.id}/images/original.webp',
                httpHeaders: {'Authorization': 'Bearer $token'},
                placeholder: (_) => Container(
                  color: context.appSurface2,
                  child: Icon(Icons.restaurant_menu_rounded,
                      color: context.appFgTertiary, size: 22),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: context.appFg,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                const SizedBox(height: 2),
                Text(meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.appFgSub, fontSize: 12)),
                const SizedBox(height: 2),
                Text(kept ? l.duplicatesKeeps : l.duplicatesWillBeDeleted,
                    style: TextStyle(
                        color: kept
                            ? AppTokens.accentDeep
                            : Theme.of(context).colorScheme.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          PopupMenuButton<String>(
            enabled: enabled,
            icon: Icon(Icons.more_vert_rounded, color: context.appFgSub),
            onSelected: (v) {
              if (v == 'open') context.push('/recipes/${r.id}');
              if (v == 'delete') _deleteOne(g, r);
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'open',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.open_in_new_rounded),
                  title: Text(l.duplicatesOpenRecipe),
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                enabled: canDeleteRecipe(perms, r),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.delete_outline_rounded),
                  title: Text(l.delete),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
