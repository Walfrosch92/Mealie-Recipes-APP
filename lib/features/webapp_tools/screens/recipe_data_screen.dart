import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/organizer_item.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../../core/utils/search_match.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/multi_select_sheet.dart';
import '../../organizers/providers/organizers_provider.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../widgets/tool_widgets.dart';

// ---------------------------------------------------------------------------
// Rezeptdaten (Mealie /group/data/recipes): Rezepte auswählen und per
// Massenaktion verschlagworten, kategorisieren, Einstellungen setzen,
// exportieren oder löschen — dazu die Liste der fertigen Exporte
// (herunterladen, alle löschen). Schemas: recipe_bulk_actions.py.
// Hinweis Mealie: Schlagworte/Kategorien werden HINZUGEFÜGT (nicht ersetzt);
// Einstellungen ersetzen alle außer „Gesperrt".
// ---------------------------------------------------------------------------

class RecipeDataScreen extends ConsumerStatefulWidget {
  const RecipeDataScreen({super.key});

  @override
  ConsumerState<RecipeDataScreen> createState() => _RecipeDataScreenState();
}

class _RecipeDataScreenState extends ConsumerState<RecipeDataScreen> {
  final Set<String> _selected = {}; // Rezept-IDs
  String _query = '';
  bool _busy = false;
  List<Map<String, dynamic>>? _exports;

  @override
  void initState() {
    super.initState();
    _loadExports();
  }

  Future<void> _loadExports() async {
    try {
      final list = await ref.read(apiServiceProvider).fetchRecipeExports();
      if (mounted) setState(() => _exports = list);
    } catch (e) {
      if (!mounted) return;
      setState(() => _exports ??= const []);
      showToolError(context, AppLocalizations.of(context)!.loadFailed, e);
    }
  }

  List<RecipeDetail> _selectedRecipes(List<RecipeDetail> all) =>
      all.where((r) => _selected.contains(r.id)).toList();

  Future<void> _run(String failText, Future<void> Function() op,
      {String? success}) async {
    setState(() => _busy = true);
    try {
      await op();
      if (mounted && success != null) showToolMessage(context, success);
    } catch (e) {
      if (mounted) showToolError(context, failText, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<List<Map<String, dynamic>>?> _pickOrganizers(
      OrganizerKind kind, String title) async {
    final res = await showMultiSelectSheet(
      context,
      title: title,
      initial: const [],
      items: (ref) => [
        for (final o in ref.watch(organizersProvider(kind)).valueOrNull ??
            const <OrganizerItem>[])
          (id: o.id, name: o.name)
      ],
      loading: (ref) => ref.watch(organizersProvider(kind)).isLoading,
    );
    if (res == null || res.selected.isEmpty) return null;
    final ids = {for (final s in res.selected) s.id};
    return [
      for (final o in ref.read(organizersProvider(kind)).valueOrNull ??
          const <OrganizerItem>[])
        if (ids.contains(o.id)) {'id': o.id, 'name': o.name, 'slug': o.slug}
    ];
  }

  Future<void> _tag(List<RecipeDetail> sel) async {
    final l = AppLocalizations.of(context)!;
    final tags = await _pickOrganizers(OrganizerKind.tag, l.recipeDataTagTitle);
    if (tags == null) return;
    await _run(l.saveFailed, () async {
      await ref
          .read(apiServiceProvider)
          .bulkTagRecipes(sel.map((r) => r.slug).toList(), tags);
      await ref.read(recipesProvider.notifier).reconcileNow();
    }, success: l.recipeDataUpdated(sel.length));
  }

  Future<void> _categorize(List<RecipeDetail> sel) async {
    final l = AppLocalizations.of(context)!;
    final cats = await _pickOrganizers(
        OrganizerKind.category, l.recipeDataCategorizeTitle);
    if (cats == null) return;
    await _run(l.saveFailed, () async {
      await ref
          .read(apiServiceProvider)
          .bulkCategorizeRecipes(sel.map((r) => r.slug).toList(), cats);
      await ref.read(recipesProvider.notifier).reconcileNow();
    }, success: l.recipeDataUpdated(sel.length));
  }

  Future<void> _settings(List<RecipeDetail> sel) async {
    final l = AppLocalizations.of(context)!;
    final values = <String, bool>{
      'public': false,
      'showNutrition': false,
      'showAssets': false,
      'landscapeView': false,
      'disableComments': false,
      'locked': false,
    };
    final labels = {
      'public': l.settingPublicRecipe,
      'showNutrition': l.settingShowNutrition,
      'showAssets': l.settingShowAssets,
      'landscapeView': l.settingLandscapeView,
      'disableComments': l.settingDisableComments,
    };
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          backgroundColor: ctx.appCard,
          title: Text(l.recipeDataSettingsTitle),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.recipeDataSettingsExplanation,
                    style: TextStyle(color: ctx.appFgSub, fontSize: 13)),
                const SizedBox(height: 8),
                for (final e in labels.entries)
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: values[e.key]!,
                    onChanged: (v) => setLocal(() => values[e.key] = v),
                    title: Text(e.value, style: TextStyle(color: ctx.appFg)),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l.cancel)),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true), child: Text(l.save)),
          ],
        ),
      ),
    );
    if (ok != true) return;
    await _run(l.saveFailed, () async {
      await ref
          .read(apiServiceProvider)
          .bulkSetRecipeSettings(sel.map((r) => r.slug).toList(), values);
      await ref.read(recipesProvider.notifier).reconcileNow();
    }, success: l.recipeDataUpdated(sel.length));
  }

  Future<void> _export(List<RecipeDetail> sel) async {
    final l = AppLocalizations.of(context)!;
    if (!await confirmTool(context,
        title: l.recipeDataExportTitle,
        message: l.recipeDataExportConfirm(sel.length),
        confirmLabel: l.recipeDataExportAction,
        destructive: false)) {
      return;
    }
    await _run(l.recipeDataExportFailed, () async {
      await ref
          .read(apiServiceProvider)
          .bulkExportRecipes(sel.map((r) => r.slug).toList());
      await _loadExports();
    }, success: l.recipeDataExportDone);
  }

  Future<void> _delete(List<RecipeDetail> sel) async {
    final l = AppLocalizations.of(context)!;
    final perms = ref.read(userPermissionsProvider);
    final forbidden = sel.where((r) => !canDeleteRecipe(perms, r)).length;
    if (forbidden > 0) {
      showToolMessage(context, l.recipeDataDeleteForbidden(forbidden));
      return;
    }
    if (!await confirmTool(context,
        title: l.recipeDataDeleteTitle,
        message: l.recipeDataDeleteConfirm(sel.length))) {
      return;
    }
    await _run(l.deleteFailed, () async {
      await ref
          .read(apiServiceProvider)
          .bulkDeleteRecipes(sel.map((r) => r.slug).toList());
      final notifier = ref.read(recipesProvider.notifier);
      for (final r in sel) {
        notifier.removeById(r.id);
      }
      if (mounted) setState(_selected.clear);
    }, success: l.recipeDataDeleted(sel.length));
  }

  Future<void> _download(Map<String, dynamic> export) async {
    final l = AppLocalizations.of(context)!;
    await _run(l.downloadFailed, () async {
      final bytes = await ref
          .read(apiServiceProvider)
          .downloadRecipeExport(export['id'].toString());
      final name = export['filename']?.toString().isNotEmpty == true
          ? export['filename'].toString()
          : 'mealie-export.zip';
      if (await saveBytesWithDialog(bytes, name) && mounted) {
        showToolMessage(context, l.fileSaved);
      }
    });
  }

  Future<void> _purge() async {
    final l = AppLocalizations.of(context)!;
    if (!await confirmTool(context, message: l.recipeDataPurgeConfirm)) {
      return;
    }
    await _run(l.deleteFailed, () async {
      await ref.read(apiServiceProvider).purgeRecipeExports();
      await _loadExports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final all = [
      ...ref.watch(recipesProvider).valueOrNull ?? const <RecipeDetail>[]
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    final terms = searchTerms(_query);
    final shown = all
        .where((r) => terms.every(normalizeForSearch(r.name).contains))
        .toList();
    // Ausgewählte, die es nicht mehr gibt (gelöscht), stillschweigend weg.
    _selected.removeWhere((id) => !all.any((r) => r.id == id));
    final sel = _selectedRecipes(all);
    final allShownSelected =
        shown.isNotEmpty && shown.every((r) => _selected.contains(r.id));
    final exports = _exports;

    return ToolPage(
      title: l.recipeDataTitle,
      description: l.recipeDataDescription,
      busy: _busy,
      children: [
        // ── Aktionen ────────────────────────────────────────────────────
        ToolCard(
          title: l.selectedCount(sel.length),
          icon: Icons.checklist_rounded,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ActionButton(Icons.sell_rounded, l.recipeDataTagTitle,
                    sel.isEmpty || _busy ? null : () => _tag(sel)),
                _ActionButton(
                    Icons.category_rounded,
                    l.recipeDataCategorizeTitle,
                    sel.isEmpty || _busy ? null : () => _categorize(sel)),
                _ActionButton(Icons.tune_rounded, l.recipeDataSettingsTitle,
                    sel.isEmpty || _busy ? null : () => _settings(sel)),
                _ActionButton(Icons.archive_rounded, l.recipeDataExportTitle,
                    sel.isEmpty || _busy ? null : () => _export(sel)),
                _ActionButton(
                    Icons.delete_outline_rounded,
                    l.recipeDataDeleteTitle,
                    sel.isEmpty || _busy ? null : () => _delete(sel),
                    danger: true),
              ],
            ),
          ],
        ),

        // ── Rezeptauswahl ───────────────────────────────────────────────
        ToolCard(
          title: l.recipes,
          icon: Icons.restaurant_menu_rounded,
          trailing: TextButton(
            onPressed: shown.isEmpty
                ? null
                : () => setState(() {
                      if (allShownSelected) {
                        _selected.removeAll(shown.map((r) => r.id));
                      } else {
                        _selected.addAll(shown.map((r) => r.id));
                      }
                    }),
            child: Text(allShownSelected ? l.deselectAllAction : l.selectAll),
          ),
          children: [
            TextField(
              onChanged: (v) => setState(() => _query = v),
              style: TextStyle(color: context.appFg),
              decoration: InputDecoration(
                hintText: l.search,
                isDense: true,
                prefixIcon: Icon(Icons.search_rounded, color: context.appFgSub),
                filled: true,
                fillColor: context.appSurface2,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.rSm),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (all.isEmpty)
              ToolEmpty(l.loading,
                  loading: ref.watch(recipesProvider).isLoading)
            else
              // Feste Höhe mit eigenem Scroll: Bibliotheken mit tausenden
              // Rezepten bauen so nur die sichtbaren Zeilen.
              SizedBox(
                height: 460,
                child: ListView.builder(
                  itemCount: shown.length,
                  itemExtent: 52,
                  itemBuilder: (_, i) {
                    final r = shown[i];
                    final on = _selected.contains(r.id);
                    return CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: on,
                      onChanged: (v) => setState(() => v == true
                          ? _selected.add(r.id)
                          : _selected.remove(r.id)),
                      title: Text(r.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: context.appFg, fontSize: 14)),
                      subtitle: Text(
                          [
                            ...r.recipeCategory.map((c) => c.name),
                            ...r.tags.map((t) => '#${t.name}'),
                          ].join('  '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: context.appFgSub, fontSize: 11.5)),
                    );
                  },
                ),
              ),
          ],
        ),

        // ── Exporte ─────────────────────────────────────────────────────
        ToolCard(
          title: l.recipeDataExportsTitle,
          subtitle: l.recipeDataExportsDescription,
          icon: Icons.download_rounded,
          trailing: IconButton(
            tooltip: l.reload,
            icon: Icon(Icons.refresh_rounded, color: context.appFgSub),
            onPressed: _loadExports,
          ),
          children: [
            if (exports == null)
              const ToolEmpty('', loading: true)
            else if (exports.isEmpty)
              ToolEmpty(l.recipeDataExportsEmpty)
            else ...[
              for (final e in exports)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.folder_zip_rounded),
                  title: Text(e['name']?.toString() ?? '',
                      style: TextStyle(color: context.appFg)),
                  subtitle: Text(
                      '${e['size'] ?? ''} · ${l.recipeDataExportExpires(formatToolDate(context, e['expires']))}',
                      style:
                          TextStyle(color: context.appFgSub, fontSize: 12.5)),
                  trailing: IconButton(
                    tooltip: l.downloadAction,
                    icon: const Icon(Icons.download_rounded),
                    onPressed: _busy ? null : () => _download(e),
                  ),
                ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: _busy ? null : _purge,
                  icon: const Icon(Icons.delete_sweep_rounded),
                  label: Text(l.recipeDataPurgeExports),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool danger;
  const _ActionButton(this.icon, this.label, this.onPressed,
      {this.danger = false});

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        style: danger
            ? OutlinedButton.styleFrom(foregroundColor: Colors.red)
            : null,
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
      );
}
