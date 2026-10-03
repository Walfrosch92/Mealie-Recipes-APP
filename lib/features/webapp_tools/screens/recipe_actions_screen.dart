import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../widgets/tool_widgets.dart';

// ---------------------------------------------------------------------------
// Rezept-Aktionen (Mealie /group/data/recipe-actions): eigene Menüpunkte im
// Rezept. „Link" öffnet die URL (Platzhalter ${id} ${slug} ${servings}
// ${yieldQuantity} ${yieldText} ${url}), „Post" lässt den Server das Rezept
// an die URL senden. Mealie erlaubt nur http(s)-URLs.
// ---------------------------------------------------------------------------

/// Alle Rezept-Aktionen des Haushalts (für das Rezept-Menü).
final recipeActionsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>(
        (ref) => ref.watch(apiServiceProvider).fetchRecipeActions());

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
      ref.invalidate(recipeActionsProvider);
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
      onRefresh: () async => ref.refresh(recipeActionsProvider.future),
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
                      style:
                          TextStyle(color: context.appFgSub, fontSize: 12.5)),
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

class _ActionDialog extends StatefulWidget {
  final Map<String, dynamic>? action;
  const _ActionDialog({this.action});

  @override
  State<_ActionDialog> createState() => _ActionDialogState();
}

class _ActionDialogState extends State<_ActionDialog> {
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
                    r'${yieldText} ${url}',
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
