import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/utils/mealie_version.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart' show SheetHandle;
import '../../recipes/providers/recipes_provider.dart';
import '../screens/recipe_actions_screen.dart' show recipeActionsProvider;
import '../../recipes/widgets/recipe_share_link_dialog.dart';
import 'tool_widgets.dart';

// ---------------------------------------------------------------------------
// Webapp-Funktionen eines Rezepts (Desktop): Duplizieren, Freigabe-Link,
// Export als JSON/ZIP und die Rezept-Aktionen des Haushalts. Eigenes Sheet,
// damit das „Mehr"-Menü der Detailansicht unverändert bleibt.
// ---------------------------------------------------------------------------

/// Link der Webapp zu diesem Rezept bzw. Freigabe-Token
/// (`{server}/g/{groupSlug}/…`, wie RecipeDialogShare).
String _webBase(WidgetRef ref) {
  final server = (ref.read(settingsProvider).valueOrNull?.serverUrl ?? '')
      .replaceAll(RegExp(r'/+$'), '');
  final group = ref.read(currentUserProvider)?['groupSlug']?.toString() ?? '';
  return '$server/g/$group';
}

Future<void> showRecipeWebToolsSheet(BuildContext context, WidgetRef ref,
    RecipeDetail recipe, double multiplier) {
  final l = AppLocalizations.of(context)!;
  final actions = ref.read(recipeActionsProvider.future);
  Widget tile(IconData icon, String title, VoidCallback onTap) => ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTokens.rSm),
            color: AppTokens.accent.withValues(alpha: 0.12),
          ),
          child: Icon(icon, color: AppTokens.accentDeep, size: 20),
        ),
        title: Text(title,
            style:
                TextStyle(color: context.appFg, fontWeight: FontWeight.w600)),
        onTap: onTap,
      );

  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (sheetCtx) => SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SheetHandle(),
            tile(Icons.copy_all_rounded, l.recipeDuplicate, () {
              Navigator.pop(sheetCtx);
              _duplicate(context, ref, recipe);
            }),
            tile(Icons.link_rounded, l.recipeShareLink, () {
              Navigator.pop(sheetCtx);
              showRecipeShareLinkDialog(context, recipe);
            }),
            tile(Icons.data_object_rounded, l.recipeExportJson, () {
              Navigator.pop(sheetCtx);
              _export(context, ref, recipe, 'raw', 'json');
            }),
            tile(Icons.folder_zip_rounded, l.recipeExportZip, () {
              Navigator.pop(sheetCtx);
              _export(context, ref, recipe, 'zip', 'zip');
            }),
            // PDF im Mealie-Layout, vom Server gerendert (≥ 3.31) — neben
            // dem eigenen PDF der App („Als PDF exportieren"/Drucken).
            if (ref.read(mealie331Provider))
              tile(Icons.picture_as_pdf_rounded, l.recipeDownloadPdfMealie,
                  () {
                Navigator.pop(sheetCtx);
                _export(context, ref, recipe, 'pdf', 'pdf');
              }),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: actions,
              builder: (_, snap) {
                final list = snap.data ?? const [];
                if (list.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                      child: Text(l.recipeActionsTitle,
                          style: TextStyle(
                              color: sheetCtx.appFgSub,
                              fontWeight: FontWeight.w700)),
                    ),
                    for (final a in list)
                      tile(
                          a['actionType'] == 'post'
                              ? Icons.send_rounded
                              : Icons.open_in_new_rounded,
                          a['title']?.toString() ?? '', () {
                        Navigator.pop(sheetCtx);
                        runRecipeAction(context, ref, recipe, a, multiplier);
                      }),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

/// iOS/Android (#42): Auswahl der Rezept-Aktionen des Haushalts aus dem
/// Rezept-Optionen-Sheet — gleiche Kacheln wie der Aktionen-Abschnitt des
/// Desktop-Webapp-Sheets, gleiche Ausführung ([runRecipeAction]).
Future<void> showRecipeActionsPickerSheet(BuildContext context, WidgetRef ref,
    RecipeDetail recipe, double multiplier, List<Map<String, dynamic>> list) {
  final l = AppLocalizations.of(context)!;
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (sheetCtx) => SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetHandle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              child: Text(l.recipeActionsTitle,
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: sheetCtx.appFg,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3)),
            ),
            for (final a in list)
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTokens.rSm),
                    color: AppTokens.accent.withValues(alpha: 0.12),
                  ),
                  child: Icon(
                      a['actionType'] == 'post'
                          ? Icons.send_rounded
                          : Icons.open_in_new_rounded,
                      color: AppTokens.accentDeep,
                      size: 20),
                ),
                title: Text(a['title']?.toString() ?? '',
                    style: TextStyle(
                        color: sheetCtx.appFg, fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  runRecipeAction(context, ref, recipe, a, multiplier);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

Future<void> _duplicate(
    BuildContext context, WidgetRef ref, RecipeDetail recipe) async {
  final l = AppLocalizations.of(context)!;
  final ctrl = TextEditingController(text: recipe.name);
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      // Querformat/Tastatur: Inhalt scrollt, Knöpfe bleiben sichtbar.
      scrollable: true,
      backgroundColor: ctx.appCard,
      title: Text(l.recipeDuplicate),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        decoration: InputDecoration(labelText: l.recipeName),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
        FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.recipeDuplicateAction)),
      ],
    ),
  );
  final name = ctrl.text;
  ctrl.dispose();
  if (ok != true || !context.mounted) return;
  try {
    final api = ref.read(apiServiceProvider);
    final created = await api.duplicateRecipe(recipe.slug, name: name);
    final slug = created['slug']?.toString() ?? '';
    final detail = await api.fetchRecipeDetail(slug);
    await ref.read(recipesProvider.notifier).upsertOne(detail);
    if (!context.mounted) return;
    showToolMessage(context, l.recipeDuplicated);
    context.push('/recipes/${detail.id}');
  } catch (e) {
    if (context.mounted) showToolError(context, l.createFailed, e);
  }
}

Future<void> _export(BuildContext context, WidgetRef ref, RecipeDetail recipe,
    String template, String ext) async {
  final l = AppLocalizations.of(context)!;
  try {
    final api = ref.read(apiServiceProvider);
    final bytes = template == 'pdf'
        ? await api.exportRecipePdf(recipe.slug)
        : await api.exportRecipeFile(recipe.slug, template);
    if (await saveBytesWithDialog(bytes, '${recipe.slug}.$ext') &&
        context.mounted) {
      showToolMessage(context, l.fileSaved);
    }
  } catch (e) {
    if (context.mounted) showToolError(context, l.downloadFailed, e);
  }
}

final _shareLinkField = RegExp(r'\$\{share-link-expires-seconds-(\d+)\}');

/// Wie `execute` der Webapp: Link → URL mit Platzhaltern öffnen,
/// Post → Server sendet das Rezept.
Future<void> runRecipeAction(BuildContext context, WidgetRef ref,
    RecipeDetail recipe, Map<String, dynamic> action, double scale) async {
  final l = AppLocalizations.of(context)!;
  final api = ref.read(apiServiceProvider);
  try {
    if (action['actionType'] == 'post') {
      await api.triggerRecipeAction(
          action['id'].toString(), recipe.slug, scale);
      if (context.mounted) showToolMessage(context, l.recipeActionSent);
      return;
    }
    final raw = await api.fetchRecipeRaw(recipe.slug);
    String scaled(dynamic v) {
      final d = ((v is num && v > 0) ? v.toDouble() : 1.0) * scale;
      return d == d.roundToDouble() ? d.toInt().toString() : d.toString();
    }

    // Mealie ≥ 3.31: `${share-link-expires-seconds-<x>}` → befristeter
    // Freigabe-Link, damit der Zieldienst auch ein privates Rezept lesen
    // kann. Wie die Webapp: je Platzhalter EIN Link (auch bei mehrfachem
    // Vorkommen), 0 Sekunden bleibt unersetzt, und scheitert das Anlegen,
    // wird die Aktion abgebrochen statt eine kaputte URL zu öffnen.
    var template = action['url']?.toString() ?? '';
    final shareFields = <String, int>{
      for (final m in _shareLinkField.allMatches(template))
        if ((int.tryParse(m.group(1)!) ?? 0) > 0)
          m.group(0)!: int.parse(m.group(1)!),
    };
    for (final MapEntry(key: field, value: seconds) in shareFields.entries) {
      final token = await api.createShareToken(
          recipe.id, DateTime.now().add(Duration(seconds: seconds)));
      final tokenId = token['id']?.toString() ?? '';
      if (tokenId.isEmpty) throw StateError('Share token without id');
      template =
          template.replaceAll(field, '${_webBase(ref)}/shared/r/$tokenId');
    }

    final url = template
        .replaceAll(r'${url}', '${_webBase(ref)}/r/${recipe.slug}')
        .replaceAll(r'${id}', recipe.id)
        .replaceAll(r'${slug}', recipe.slug)
        .replaceAll(r'${servings}', scaled(raw['recipeServings']))
        .replaceAll(r'${yieldQuantity}', scaled(raw['recipeYieldQuantity']))
        .replaceAll(r'${yieldText}', raw['recipeYield']?.toString() ?? '');
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) showToolMessage(context, l.invalidUrl);
    }
  } catch (e) {
    if (context.mounted) showToolError(context, l.recipeActionFailed, e);
  }
}
