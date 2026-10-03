import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart' show SheetHandle;
import '../../recipes/providers/recipes_provider.dart';
import '../screens/recipe_actions_screen.dart' show recipeActionsProvider;
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
            borderRadius: BorderRadius.circular(12),
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
    backgroundColor: context.appCard,
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
              showDialog(
                  context: context,
                  builder: (_) => _ShareDialog(recipe: recipe));
            }),
            tile(Icons.data_object_rounded, l.recipeExportJson, () {
              Navigator.pop(sheetCtx);
              _export(context, ref, recipe, 'raw', 'json');
            }),
            tile(Icons.folder_zip_rounded, l.recipeExportZip, () {
              Navigator.pop(sheetCtx);
              _export(context, ref, recipe, 'zip', 'zip');
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
                              color: context.appFgSub,
                              fontWeight: FontWeight.w700)),
                    ),
                    for (final a in list)
                      tile(
                          a['actionType'] == 'post'
                              ? Icons.send_rounded
                              : Icons.open_in_new_rounded,
                          a['title']?.toString() ?? '', () {
                        Navigator.pop(sheetCtx);
                        _runAction(context, ref, recipe, a, multiplier);
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

Future<void> _duplicate(
    BuildContext context, WidgetRef ref, RecipeDetail recipe) async {
  final l = AppLocalizations.of(context)!;
  final ctrl = TextEditingController(text: recipe.name);
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
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
    final bytes = await ref
        .read(apiServiceProvider)
        .exportRecipeFile(recipe.slug, template);
    if (await saveBytesWithDialog(bytes, '${recipe.slug}.$ext') &&
        context.mounted) {
      showToolMessage(context, l.fileSaved);
    }
  } catch (e) {
    if (context.mounted) showToolError(context, l.downloadFailed, e);
  }
}

/// Wie `execute` der Webapp: Link → URL mit Platzhaltern öffnen,
/// Post → Server sendet das Rezept.
Future<void> _runAction(BuildContext context, WidgetRef ref,
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

    final url = (action['url']?.toString() ?? '')
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

class _ShareDialog extends ConsumerStatefulWidget {
  final RecipeDetail recipe;
  const _ShareDialog({required this.recipe});

  @override
  ConsumerState<_ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends ConsumerState<_ShareDialog> {
  List<Map<String, dynamic>>? _tokens;
  DateTime _expires = DateTime.now().add(const Duration(days: 30));
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list =
          await ref.read(apiServiceProvider).fetchShareTokens(widget.recipe.id);
      if (mounted) setState(() => _tokens = list);
    } catch (e) {
      if (!mounted) return;
      setState(() => _tokens ??= const []);
      showToolError(context, AppLocalizations.of(context)!.loadFailed, e);
    }
  }

  String _link(String tokenId) => '${_webBase(ref)}/shared/r/$tokenId';

  Future<void> _guard(String fail, Future<void> Function() op) async {
    setState(() => _busy = true);
    try {
      await op();
    } catch (e) {
      if (mounted) showToolError(context, fail, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final tokens = _tokens;
    return AlertDialog(
      backgroundColor: context.appCard,
      title: Text(l.recipeShareLink),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.recipeShareDescription,
                  style: TextStyle(color: context.appFgSub, fontSize: 13)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.event_rounded),
                    title: Text(l.recipeShareExpiration),
                    subtitle: Text(
                        MaterialLocalizations.of(context)
                            .formatMediumDate(_expires),
                        style: TextStyle(color: context.appFg)),
                    onTap: () async {
                      final now = DateTime.now();
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _expires,
                        firstDate: now,
                        lastDate: DateTime(now.year + 10),
                      );
                      if (d != null) setState(() => _expires = d);
                    },
                  ),
                ),
                FilledButton.icon(
                  onPressed: _busy
                      ? null
                      : () => _guard(l.createFailed, () async {
                            await ref
                                .read(apiServiceProvider)
                                .createShareToken(widget.recipe.id, _expires);
                            await _load();
                          }),
                  icon: const Icon(Icons.add_link_rounded),
                  label: Text(l.recipeShareCreate),
                ),
              ]),
              const Divider(),
              if (tokens == null)
                const ToolEmpty('', loading: true)
              else if (tokens.isEmpty)
                ToolEmpty(l.recipeShareEmpty)
              else
                for (final t in tokens)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.link_rounded),
                    title: SelectableText(_link(t['id'].toString()),
                        style: TextStyle(color: context.appFg, fontSize: 13)),
                    subtitle: Text(
                        l.recipeShareExpiresAt(formatToolDate(
                            context, t['expiresAt'], time: false)),
                        style:
                            TextStyle(color: context.appFgSub, fontSize: 12)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: l.copy,
                          icon: const Icon(Icons.copy_rounded),
                          onPressed: () async {
                            await Clipboard.setData(
                                ClipboardData(text: _link(t['id'].toString())));
                            if (context.mounted) {
                              showToolMessage(context, l.recipeShareCopied);
                            }
                          },
                        ),
                        IconButton(
                          tooltip: l.delete,
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed: _busy
                              ? null
                              : () => _guard(l.deleteFailed, () async {
                                    await ref
                                        .read(apiServiceProvider)
                                        .deleteShareToken(t['id'].toString());
                                    await _load();
                                  }),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(l.close)),
      ],
    );
  }
}
