import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/models/shopping_item.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/utils/search_match.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/apple_icon.dart';
import '../../../shared/widgets/read_only_banner.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../../shopping_list/providers/shopping_list_provider.dart'
    show shoppingLabelsProvider;
import '../../shopping_list/screens/shopping_list_screen.dart'
    show shoppingCategoryColor;
import '../providers/foods_units_admin_provider.dart';
import '../widgets/food_unit_edit_sheet.dart';

// ---------------------------------------------------------------------------
// Lebensmittel / Einheiten verwalten — wie „Daten verwalten" der Mealie-
// Webapp: Suchen, Anlegen, Bearbeiten (alle Felder, siehe
// food_unit_edit_sheet.dart), Zusammenführen, Löschen, Mehrfachauswahl
// (Löschen, bei Lebensmitteln „Abteilung zuweisen"), Standarddaten laden
// und Export. Tippen → Bearbeiten, Wischen nach links → Zusammenführen/
// Löschen, ⋮ → Auswählen / Standarddaten / Export.
// ---------------------------------------------------------------------------

extension FoodUnitKindUi on FoodUnitKind {
  String title(AppLocalizations l) =>
      this == FoodUnitKind.food ? l.foodsTitle : l.unitsTitle;
  String newTitle(AppLocalizations l) =>
      this == FoodUnitKind.food ? l.newFood : l.newUnit;
  IconData get icon =>
      this == FoodUnitKind.food ? kAppleIcon : kMeasuringCupIcon;

  /// Wie viele geladene Rezepte den Eintrag in ihren Zutaten verwenden.
  int usage(List<RecipeDetail> recipes, String id) => recipes
      .where((r) => r.recipeIngredient.any((i) =>
          this == FoodUnitKind.food ? i.food?.id == id : i.unit?.id == id))
      .length;
}

/// Mealie-Seeder-Sprachen (validate_locale) je App-Sprache.
const _kSeedLocales = {
  'de': 'de-DE',
  'en': 'en-US',
  'es': 'es-ES',
  'fr': 'fr-FR',
  'hu': 'hu-HU',
  'nb': 'no-NO',
  'nl': 'nl-NL',
  'pl': 'pl-PL',
  'pt': 'pt-BR',
  'sl': 'sl-SI',
};

/// Sprachnamen bewusst nicht übersetzt (wie überall in der App).
const _kSeedLanguageNames = {
  'de': 'Deutsch',
  'en': 'English',
  'es': 'Español',
  'fr': 'Français',
  'hu': 'Magyar',
  'nb': 'Norsk (bokmål)',
  'nl': 'Nederlands',
  'pl': 'Polski',
  'pt': 'Português (Brasil)',
  'sl': 'Slovenščina',
};

/// Suchbegriffe gegen Name, Plural, Abkürzungen und Aliase.
bool _matches(Map<String, dynamic> m, List<String> terms) {
  if (terms.isEmpty) return true;
  final hay = normalizeForSearch([
    m['name'],
    m['pluralName'],
    m['abbreviation'],
    m['pluralAbbreviation'],
    for (final a in (m['aliases'] as List?) ?? const [])
      if (a is Map) a['name'],
  ].whereType<String>().join(' '));
  return terms.every(hay.contains);
}

String _subtitle(Map<String, dynamic> m) {
  final parts = <String>[
    for (final k in ['pluralName', 'abbreviation', 'pluralAbbreviation'])
      if (((m[k] as String?) ?? '').trim().isNotEmpty) (m[k] as String).trim(),
  ];
  return parts.join(' · ');
}

class FoodsUnitsScreen extends ConsumerStatefulWidget {
  final FoodUnitKind kind;
  const FoodsUnitsScreen({super.key, required this.kind});

  @override
  ConsumerState<FoodsUnitsScreen> createState() => _FoodsUnitsScreenState();
}

class _FoodsUnitsScreenState extends ConsumerState<FoodsUnitsScreen> {
  String _query = '';
  bool _selecting = false;
  final Set<String> _selected = {};
  bool _busy = false;

  FoodUnitKind get kind => widget.kind;
  FoodsUnitsAdminNotifier get _notifier =>
      ref.read(foodsUnitsAdminProvider(kind).notifier);
  List<Map<String, dynamic>> get _items =>
      ref.read(foodsUnitsAdminProvider(kind)).valueOrNull ?? const [];

  void _error(String fallback, Object e) {
    if (!mounted) return;
    final detail = mealieErrorMessage(e);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(detail == null ? fallback : '$fallback: $detail')));
  }

  void _endSelection() => setState(() {
        _selecting = false;
        _selected.clear();
      });

  Future<void> _edit(Map<String, dynamic>? item) async {
    final l = AppLocalizations.of(context)!;
    final data = await showFoodUnitEditSheet(context,
        kind: kind, item: item, allItems: _items);
    if (data == null) return;
    try {
      await _notifier.save(data);
      HapticFeedback.lightImpact();
    } catch (e) {
      _error(item == null ? l.createFailed : l.saveFailed, e);
    }
  }

  Future<bool> _confirm(String text,
      {String? confirm, bool danger = true}) async {
    final l = AppLocalizations.of(context)!;
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: ctx.appCard,
            content: Text(text, style: TextStyle(color: ctx.appFg)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l.cancel)),
              FilledButton(
                style: danger
                    ? FilledButton.styleFrom(backgroundColor: Colors.red)
                    : null,
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(confirm ?? l.delete),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _merge(Map<String, dynamic> from) async {
    final l = AppLocalizations.of(context)!;
    final target = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.appCard,
      builder: (_) => _MergeTargetSheet(
        title: l.mergeIntoTitle(foodUnitName(from)),
        items: _items.where((m) => m['id'] != from['id']).toList(),
      ),
    );
    if (target == null || !mounted) return;
    final ok = await _confirm(
        l.mergeConfirm(foodUnitName(from), foodUnitName(target)),
        confirm: l.mergeAction,
        danger: false);
    if (!ok) return;
    try {
      await _notifier.merge(from, target);
      HapticFeedback.lightImpact();
    } catch (e) {
      _error(l.mergeFailed, e);
    }
  }

  Future<void> _delete(Map<String, dynamic> item) async {
    final l = AppLocalizations.of(context)!;
    if (!await _confirm(l.foodUnitDeleteConfirm(foodUnitName(item)))) return;
    try {
      await _notifier.delete(item);
    } catch (e) {
      _error(l.deleteFailed, e);
    }
  }

  List<Map<String, dynamic>> get _selectedItems =>
      _items.where((m) => _selected.contains(m['id'])).toList();

  Future<void> _deleteSelected() async {
    final l = AppLocalizations.of(context)!;
    final items = _selectedItems;
    if (items.isEmpty) return;
    if (!await _confirm(l.deleteSelectedConfirm(items.length))) return;
    setState(() => _busy = true);
    Object? failure;
    for (final m in items) {
      try {
        await _notifier.delete(m);
      } catch (e) {
        failure = e;
      }
    }
    if (!mounted) return;
    setState(() => _busy = false);
    _endSelection();
    if (failure != null) _error(l.deleteFailed, failure);
  }

  Future<void> _assignLabelToSelected() async {
    final l = AppLocalizations.of(context)!;
    final items = _selectedItems;
    if (items.isEmpty) return;
    final labels = ref.read(shoppingLabelsProvider).valueOrNull ?? const [];
    // Rückgabe: Label-id, '' = keine Abteilung, null = abgebrochen.
    final picked = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.appCard,
      builder: (ctx) => ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.75),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            ListTile(
              title: Text(l.assignLabelAction,
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: ctx.appFg,
                      fontSize: 17,
                      fontWeight: FontWeight.w800)),
              subtitle: Text(
                  '${l.selectedCount(items.length)} · ${l.assignLabelOverwriteHint}',
                  style: TextStyle(color: ctx.appFgSub)),
            ),
            ListTile(
              leading: Icon(Icons.label_off_outlined, color: ctx.appFgSub),
              title: Text(l.foodNoLabel),
              onTap: () => Navigator.pop(ctx, ''),
            ),
            for (final lb in labels)
              ListTile(
                leading: CircleAvatar(
                    radius: 8,
                    backgroundColor: shoppingCategoryColor(lb.color, lb.name)),
                title: Text(lb.name),
                onTap: () => Navigator.pop(ctx, lb.id),
              ),
          ],
        ),
      ),
    );
    if (picked == null || !mounted) return;
    setState(() => _busy = true);
    Object? failure;
    for (final m in items) {
      try {
        final data = {...m, 'labelId': picked.isEmpty ? null : picked}
          ..remove('label');
        await _notifier.save(data);
      } catch (e) {
        failure = e;
      }
    }
    if (!mounted) return;
    setState(() => _busy = false);
    _endSelection();
    if (failure != null) _error(l.saveFailed, failure);
  }

  Future<void> _seed() async {
    final l = AppLocalizations.of(context)!;
    final appLang =
        ref.read(settingsProvider).valueOrNull?.selectedLanguage ?? 'de';
    var lang = _kSeedLocales.containsKey(appLang) ? appLang : 'en';
    final hasItems = _items.isNotEmpty;
    final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => StatefulBuilder(
            builder: (ctx, setD) => AlertDialog(
              backgroundColor: ctx.appCard,
              title: Text(l.seedDataAction),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      kind == FoodUnitKind.food
                          ? l.seedFoodsHint
                          : l.seedUnitsHint,
                      style: TextStyle(color: ctx.appFg)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: lang,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l.seedLanguageLabel),
                    items: [
                      for (final e in _kSeedLanguageNames.entries)
                        DropdownMenuItem(value: e.key, child: Text(e.value)),
                    ],
                    onChanged: (v) => setD(() => lang = v ?? lang),
                  ),
                  if (hasItems) ...[
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(l.seedDuplicateWarning,
                              style:
                                  TextStyle(color: ctx.appFgSub, fontSize: 13)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(l.cancel)),
                FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(l.seedDataAction)),
              ],
            ),
          ),
        ) ??
        false;
    if (!ok || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(apiServiceProvider)
          .seedFoodsOrUnits(kind.path, _kSeedLocales[lang]!);
      await _notifier.refresh();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.seedDone)));
      }
    } catch (e) {
      _error(l.seedFailed, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _export() async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/mealie_${kind.path}.json');
    await file
        .writeAsString(const JsonEncoder.withIndent('  ').convert(_items));
    await Share.shareXFiles([XFile(file.path)]);
  }

  PopupMenuItem<String> _menuItem(String v, IconData icon, String label) =>
      PopupMenuItem(
        value: v,
        child: Row(children: [
          Icon(icon, size: 20, color: context.appFg),
          const SizedBox(width: 12),
          Flexible(child: Text(label)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final async = ref.watch(foodsUnitsAdminProvider(kind));
    final recipes = ref.watch(recipesProvider).valueOrNull ?? const [];
    final labels = ref.watch(shoppingLabelsProvider).valueOrNull ??
        const <ShoppingLabel>[];
    final labelById = {for (final lb in labels) lb.id: lb};
    // Lebensmittel ändern braucht in Mealie `can_organize`; Einheiten
    // prüft der Server nicht.
    final mayEdit = kind == FoodUnitKind.unit ||
        ref.watch(userPermissionsProvider).mayOrganize;

    final appBar = _selecting
        ? AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              tooltip: l.cancel,
              onPressed: _busy ? null : _endSelection,
            ),
            title: Text(l.selectedCount(_selected.length)),
            actions: [
              if (kind == FoodUnitKind.food)
                IconButton(
                  icon: const Icon(Icons.label_rounded),
                  tooltip: l.assignLabelAction,
                  onPressed: _busy || _selected.isEmpty
                      ? null
                      : _assignLabelToSelected,
                ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: l.delete,
                onPressed: _busy || _selected.isEmpty ? null : _deleteSelected,
              ),
            ],
          )
        : AppBar(
            title: Text(kind.title(l)),
            actions: [
              if (mayEdit)
                IconButton(
                  icon: Icon(Icons.add_rounded, color: context.appFg),
                  tooltip: kind.newTitle(l),
                  onPressed: () => _edit(null),
                ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, color: context.appFg),
                color: context.appCard,
                onSelected: (v) {
                  switch (v) {
                    case 'select':
                      setState(() => _selecting = true);
                    case 'seed':
                      _seed();
                    case 'export':
                      _export();
                  }
                },
                itemBuilder: (_) => [
                  if (mayEdit)
                    _menuItem(
                        'select', Icons.checklist_rounded, l.selectAction),
                  _menuItem(
                      'seed', Icons.playlist_add_rounded, l.seedDataAction),
                  _menuItem('export', Icons.ios_share_rounded, l.exportAction),
                ],
              ),
            ],
          );

    return PopScope(
      canPop: !_selecting,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _selecting) _endSelection();
      },
      child: Scaffold(
        backgroundColor: context.appBg,
        appBar: appBar,
        body: WithCookingModeFAB(
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                if (_busy) const LinearProgressIndicator(minHeight: 2),
                Expanded(
                  child: async.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(mealieErrorMessage(e) ?? e.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: context.appFgSub)),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: () =>
                                  ref.invalidate(foodsUnitsAdminProvider(kind)),
                              child: Text(l.retry),
                            ),
                          ],
                        ),
                      ),
                    ),
                    data: (items) {
                      final terms = searchTerms(_query);
                      final shown =
                          items.where((m) => _matches(m, terms)).toList();
                      return Column(
                        children: [
                          if (!mayEdit)
                            ReadOnlyBanner(text: l.organizeReadOnlyHint),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                            child: TextField(
                              onChanged: (v) => setState(() => _query = v),
                              onTapOutside: (_) =>
                                  FocusScope.of(context).unfocus(),
                              style: TextStyle(color: context.appFg),
                              decoration: InputDecoration(
                                hintText: l.search,
                                prefixIcon: Icon(Icons.search_rounded,
                                    color: context.appFgSub),
                                filled: true,
                                fillColor: context.appCard,
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppTokens.rSm),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: _notifier.refresh,
                              child: items.isEmpty
                                  ? ListView(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(32),
                                        child: Text(l.foodsUnitsEmpty,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: context.appFgSub,
                                                fontSize: 15)),
                                      ),
                                    ])
                                  : ListView.builder(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 8, 16, 24),
                                      itemCount: shown.length,
                                      itemBuilder: (_, i) {
                                        final m = shown[i];
                                        final id = m['id'] as String? ?? '';
                                        return EntranceOnce(
                                          id: 'fu-${kind.path}-$id',
                                          index: i,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: _FoodUnitCard(
                                              kind: kind,
                                              item: m,
                                              label: labelById[m['labelId']],
                                              usage: kind.usage(recipes, id),
                                              selecting: _selecting,
                                              selected: _selected.contains(id),
                                              onTap: _selecting
                                                  ? () => setState(() =>
                                                      _selected.contains(id)
                                                          ? _selected.remove(id)
                                                          : _selected.add(id))
                                                  : (mayEdit
                                                      ? () => _edit(m)
                                                      : () {}),
                                              readOnly: !mayEdit,
                                              onMerge: () => _merge(m),
                                              onDelete: () => _delete(m),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FoodUnitCard extends StatelessWidget {
  final FoodUnitKind kind;
  final Map<String, dynamic> item;
  final ShoppingLabel? label;
  final int usage;
  final bool selecting;
  final bool selected;

  /// Ohne Recht: kein Wischen (Zusammenführen/Löschen), kein Pfeil.
  final bool readOnly;
  final VoidCallback onTap;
  final VoidCallback onMerge;
  final VoidCallback onDelete;

  const _FoodUnitCard({
    required this.kind,
    required this.item,
    required this.label,
    required this.usage,
    required this.selecting,
    required this.selected,
    this.readOnly = false,
    required this.onTap,
    required this.onMerge,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final sub = _subtitle(item);
    final card = BounceTap(
      onTap: onTap,
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: context.appCard,
          borderRadius: BorderRadius.circular(AppTokens.rMd),
          border: Border.all(
              color: selected ? AppTokens.accent : context.appSeparator,
              width: selected ? 1.5 : 1),
          boxShadow: context.appShadowSm,
        ),
        child: Row(
          children: [
            if (selecting)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? AppTokens.accent : context.appFgTertiary,
                ),
              )
            else
              Container(
                width: 38,
                height: 38,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  gradient: AppTokens.accentGradient,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: iconOrApple(kind.icon, color: Colors.white, size: 20),
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(foodUnitName(item),
                      style: TextStyle(
                          color: context.appFg,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                      [if (sub.isNotEmpty) sub, l.organizerRecipeCount(usage)]
                          .join('  ·  '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: context.appFgSub, fontSize: 12)),
                  if (label != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(children: [
                        CircleAvatar(
                            radius: 5,
                            backgroundColor: shoppingCategoryColor(
                                label!.color, label!.name)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(label!.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: context.appFgSub, fontSize: 12)),
                        ),
                      ]),
                    ),
                ],
              ),
            ),
            if (!selecting && !readOnly)
              Icon(Icons.chevron_right_rounded, color: context.appFgTertiary),
          ],
        ),
      ),
    );
    if (selecting || readOnly) return card;
    return Slidable(
      key: ValueKey(item['id']),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.55,
        children: [
          SlidableAction(
            onPressed: (_) => onMerge(),
            backgroundColor: const Color(0xFF0A84FF),
            foregroundColor: Colors.white,
            icon: Icons.call_merge_rounded,
            label: l.mergeAction,
          ),
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: l.delete,
          ),
        ],
      ),
      child: card,
    );
  }
}

/// Ziel für das Zusammenführen wählen (mit Suche).
class _MergeTargetSheet extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  const _MergeTargetSheet({required this.title, required this.items});

  @override
  State<_MergeTargetSheet> createState() => _MergeTargetSheetState();
}

class _MergeTargetSheetState extends State<_MergeTargetSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final terms = searchTerms(_query);
    final shown = widget.items.where((m) => _matches(m, terms)).toList();
    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: l.search,
                prefixIcon: const Icon(Icons.search_rounded),
                isDense: true,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: shown.length,
                itemBuilder: (_, i) {
                  final m = shown[i];
                  final sub = _subtitle(m);
                  return ListTile(
                    title: Text(foodUnitName(m),
                        style: TextStyle(color: context.appFg)),
                    subtitle: sub.isEmpty
                        ? null
                        : Text(sub, style: TextStyle(color: context.appFgSub)),
                    onTap: () => Navigator.pop(context, m),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
