import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/providers/cached_json_list.dart';
import '../../../core/utils/mealie_version.dart';
import '../../../shared/theme/app_colors.dart';
import '../widgets/tool_widgets.dart';

// ---------------------------------------------------------------------------
// Rezept-Aktionen (Mealie /group/data/recipe-actions): eigene Menüpunkte im
// Rezept. „Link" öffnet die URL (Platzhalter ${id} ${slug} ${servings}
// ${yieldQuantity} ${yieldText} ${url}, ab Mealie 3.31 auch
// ${share-link-expires-seconds-<x>}), „Post" lässt den Server das Rezept
// an die URL senden. Mealie erlaubt nur http(s)-URLs.
// ---------------------------------------------------------------------------

/// Alle Rezept-Aktionen des Haushalts (für das Rezept-Menü). Cache-first,
/// damit der Menüpunkt im Rezept-Optionen-Sheet (iOS/Android, #42) sofort
/// da ist statt nachträglich ins Sheet zu springen.
final recipeActionsProvider =
    AsyncNotifierProvider<_RecipeActionsNotifier, List<Map<String, dynamic>>>(
        _RecipeActionsNotifier.new);

class _RecipeActionsNotifier extends CachedJsonListNotifier {
  @override
  String get cacheKey => 'recipe_actions';
  @override
  Future<List<Map<String, dynamic>>> fetch(ApiService api) =>
      api.fetchRecipeActions();
}

class RecipeActionsScreen extends ConsumerStatefulWidget {
  const RecipeActionsScreen({super.key});

  @override
  ConsumerState<RecipeActionsScreen> createState() =>
      _RecipeActionsScreenState();
}

class _RecipeActionsScreenState extends ConsumerState<RecipeActionsScreen> {
  bool _busy = false;

  Future<void> _guard(String fail, Future<void> Function() op) async {
    setState(() => _busy = true);
    try {
      await op();
      await ref.read(recipeActionsProvider.notifier).refresh();
    } catch (e) {
      if (mounted) showToolError(context, fail, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _edit([Map<String, dynamic>? action]) async {
    final l = AppLocalizations.of(context)!;
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _ActionDialog(action: action),
    );
    if (result == null) return;
    await _guard(action == null ? l.createFailed : l.saveFailed, () async {
      await ref.read(apiServiceProvider).saveRecipeAction(
          action == null ? result : {...action, ...result},
          id: action?['id']?.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final async = ref.watch(recipeActionsProvider);
    final items = async.valueOrNull;
    return ToolPage(
      title: l.recipeActionsTitle,
      description: l.recipeActionsDescription,
      busy: _busy,
      onRefresh: () => ref.read(recipeActionsProvider.notifier).refresh(),
      actions: [
        IconButton(
          tooltip: l.recipeActionNew,
          icon: const Icon(Icons.add_rounded),
          onPressed: _busy ? null : () => _edit(),
        ),
      ],
      children: [
        if (items == null)
          ToolEmpty(
              async.hasError
                  ? (mealieErrorMessage(async.error!) ?? l.loadFailed)
                  : '',
              loading: !async.hasError)
        else if (items.isEmpty)
          ToolEmpty(l.recipeActionsEmpty)
        else
          for (final a in items)
            ToolCard(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                      a['actionType'] == 'post'
                          ? Icons.send_rounded
                          : Icons.open_in_new_rounded,
                      color: AppTokens.accentDeep),
                  title: Text(a['title']?.toString() ?? '',
                      style: TextStyle(
                          color: context.appFg, fontWeight: FontWeight.w700)),
                  subtitle: Text(
                      '${a['actionType'] == 'post' ? l.recipeActionTypePost : l.recipeActionTypeLink} · ${a['url'] ?? ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: context.appFgSub, fontSize: 13)),
                  onTap: () => _edit(a),
                  trailing: IconButton(
                    tooltip: l.delete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: _busy
                        ? null
                        : () async {
                            if (!await confirmTool(context,
                                message: l.recipeActionDeleteConfirm(
                                    a['title']?.toString() ?? ''))) {
                              return;
                            }
                            await _guard(
                                l.deleteFailed,
                                () => ref
                                    .read(apiServiceProvider)
                                    .deleteRecipeAction(a['id'].toString()));
                          },
                  ),
                ),
              ],
            ),
      ],
    );
  }
}

class _ActionDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic>? action;
  const _ActionDialog({this.action});

  @override
  ConsumerState<_ActionDialog> createState() => _ActionDialogState();
}

class _ActionDialogState extends ConsumerState<_ActionDialog> {
  late final _title =
      TextEditingController(text: widget.action?['title']?.toString() ?? '');
  late final _url =
      TextEditingController(text: widget.action?['url']?.toString() ?? '');
  late String _type = widget.action?['actionType']?.toString() ?? 'link';
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _url.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      // Querformat/Tastatur: Inhalt scrollt, Knöpfe bleiben sichtbar.
      scrollable: true,
      backgroundColor: context.appCard,
      title:
          Text(widget.action == null ? l.recipeActionNew : l.recipeActionEdit),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _title,
              autofocus: widget.action == null,
              decoration: InputDecoration(labelText: l.recipeActionTitleLabel),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _url,
              autocorrect: false,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: 'URL',
                // Platzhalter-Namen sind Mealie-Syntax → nicht übersetzt.
                helperText: '${l.recipeActionUrlHint}: '
                    r'${id} ${slug} ${servings} ${yieldQuantity} '
                    r'${yieldText} ${url}'
                    // Befristeter Freigabe-Link (Mealie ≥ 3.31), z. B. für
                    // Dienste, die ein privates Rezept abrufen sollen.
                    '${ref.watch(mealie331Provider) ? r' ${share-link-expires-seconds-600}' : ''}',
                helperMaxLines: 3,
              ),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                    value: 'link',
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: Text(l.recipeActionTypeLink)),
                ButtonSegment(
                    value: 'post',
                    icon: const Icon(Icons.send_rounded),
                    label: Text(l.recipeActionTypePost)),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(
          onPressed: () {
            final url = _url.text.trim();
            final lower = url.toLowerCase();
            if (_title.text.trim().isEmpty) {
              setState(() => _error = l.required);
              return;
            }
            if (!lower.startsWith('http://') && !lower.startsWith('https://')) {
              setState(() => _error = l.invalidUrl);
              return;
            }
            Navigator.pop(context, {
              'actionType': _type,
              'title': _title.text.trim(),
              'url': url,
            });
          },
          child: Text(widget.action == null ? l.add : l.save),
        ),
      ],
    );
  }
}
