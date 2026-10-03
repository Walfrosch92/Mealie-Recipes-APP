import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../widgets/tool_widgets.dart';

// ---------------------------------------------------------------------------
// Haushalt → Benachrichtigungen (Mealie /household/notifiers): Apprise-
// Ziele, die bei gewählten Ereignissen benachrichtigt werden. Wie die Webapp:
// Anlegen mit Name + Apprise-URL (alle Ereignisse aus), dann Ereignisse
// wählen. Die Apprise-URL liefert der Server nie zurück — leer lassen beim
// Bearbeiten behält die gespeicherte (`appriseUrl: null`).
// ---------------------------------------------------------------------------

/// Ereignis-Gruppen wie die Webapp (notifiers.vue): Titel + (Option, Label).
List<(String, List<(String, String)>)> _eventGroups(AppLocalizations l) => [
      (
        l.notifierRecipeEvents,
        [
          ('recipeCreated', l.notifierCreate),
          ('recipeUpdated', l.notifierUpdate),
          ('recipeDeleted', l.notifierDelete),
        ]
      ),
      (l.notifierUserEvents, [('userSignup', l.notifierUserSignup)]),
      (
        l.notifierMealplanEvents,
        [
          ('mealplanEntryCreated', l.notifierCreate),
          ('mealplanEntryUpdated', l.notifierUpdate),
          ('mealplanEntryDeleted', l.notifierDelete),
        ]
      ),
      (
        l.notifierShoppingListEvents,
        [
          ('shoppingListCreated', l.notifierCreate),
          ('shoppingListUpdated', l.notifierUpdate),
          ('shoppingListDeleted', l.notifierDelete),
        ]
      ),
      (
        l.notifierCookbookEvents,
        [
          ('cookbookCreated', l.notifierCreate),
          ('cookbookUpdated', l.notifierUpdate),
          ('cookbookDeleted', l.notifierDelete),
        ]
      ),
      (
        l.notifierTagEvents,
        [
          ('tagCreated', l.notifierCreate),
          ('tagUpdated', l.notifierUpdate),
          ('tagDeleted', l.notifierDelete),
        ]
      ),
      (
        l.notifierCategoryEvents,
        [
          ('categoryCreated', l.notifierCreate),
          ('categoryUpdated', l.notifierUpdate),
          ('categoryDeleted', l.notifierDelete),
        ]
      ),
      (
        l.notifierLabelEvents,
        [
          ('labelCreated', l.notifierCreate),
          ('labelUpdated', l.notifierUpdate),
          ('labelDeleted', l.notifierDelete),
        ]
      ),
    ];

class NotifiersScreen extends ConsumerStatefulWidget {
  const NotifiersScreen({super.key});

  @override
  ConsumerState<NotifiersScreen> createState() => _NotifiersScreenState();
}

class _NotifiersScreenState extends ConsumerState<NotifiersScreen> {
  List<Map<String, dynamic>>? _items;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await ref.read(apiServiceProvider).fetchNotifiers();
      list.sort((a, b) => (a['name']?.toString() ?? '')
          .toLowerCase()
          .compareTo((b['name']?.toString() ?? '').toLowerCase()));
      if (mounted) setState(() => _items = list);
    } catch (e) {
      if (!mounted) return;
      setState(() => _items ??= const []);
      showToolError(context, AppLocalizations.of(context)!.loadFailed, e);
    }
  }

  Future<void> _guard(String fail, Future<void> Function() op,
      {String? success}) async {
    setState(() => _busy = true);
    try {
      await op();
      if (mounted && success != null) showToolMessage(context, success);
    } catch (e) {
      if (mounted) showToolError(context, fail, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _create() async {
    final l = AppLocalizations.of(context)!;
    final name = TextEditingController();
    final url = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.appCard,
        title: Text(l.notifierNew),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.notifierDescription,
                  style: TextStyle(color: ctx.appFgSub, fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                  controller: name,
                  autofocus: true,
                  decoration: InputDecoration(labelText: l.name)),
              const SizedBox(height: 8),
              TextField(
                  controller: url,
                  autocorrect: false,
                  decoration: InputDecoration(labelText: l.notifierAppriseUrl)),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true), child: Text(l.add)),
        ],
      ),
    );
    final n = name.text.trim(), u = url.text.trim();
    name.dispose();
    url.dispose();
    if (ok != true || n.isEmpty || u.isEmpty) return;
    Map<String, dynamic>? created;
    await _guard(l.createFailed, () async {
      created = await ref.read(apiServiceProvider).createNotifier(n, u);
      await _load();
    });
    // Neu angelegt sind alle Ereignisse aus → gleich zur Auswahl.
    if (created != null && mounted) await _edit(created!);
  }

  Future<void> _edit(Map<String, dynamic> item) async {
    final l = AppLocalizations.of(context)!;
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _NotifierDialog(item: item),
    );
    if (result == null) return;
    await _guard(l.saveFailed, () async {
      await ref.read(apiServiceProvider).updateNotifier(result);
      await _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final items = _items;
    return ToolPage(
      title: l.notifiersTitle,
      description: l.notifiersDescription,
      busy: _busy,
      onRefresh: _load,
      actions: [
        IconButton(
          tooltip: l.notifierNew,
          icon: const Icon(Icons.add_rounded),
          onPressed: _busy ? null : _create,
        ),
      ],
      children: [
        if (items == null)
          const ToolEmpty('', loading: true)
        else if (items.isEmpty)
          ToolEmpty(l.notifiersEmpty)
        else
          for (final n in items)
            ToolCard(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.notifications_active_rounded,
                      color: n['enabled'] == true
                          ? AppTokens.accentDeep
                          : context.appFgTertiary),
                  title: Text(n['name']?.toString() ?? '',
                      style: TextStyle(
                          color: context.appFg, fontWeight: FontWeight.w700)),
                  subtitle: Text(
                      n['enabled'] == true
                          ? l.notifierEventCount(_activeCount(n))
                          : l.disabledLabel,
                      style:
                          TextStyle(color: context.appFgSub, fontSize: 12.5)),
                  onTap: () => _edit(n),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: l.testAction,
                        icon: const Icon(Icons.send_rounded),
                        onPressed: _busy
                            ? null
                            : () => _guard(
                                l.notifierTestFailed,
                                () => ref
                                    .read(apiServiceProvider)
                                    .testNotifier(n['id'].toString()),
                                success: l.notifierTestSent),
                      ),
                      IconButton(
                        tooltip: l.delete,
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: _busy
                            ? null
                            : () async {
                                if (!await confirmTool(context,
                                    message: l.notifierDeleteConfirm(
                                        n['name']?.toString() ?? ''))) {
                                  return;
                                }
                                await _guard(l.deleteFailed, () async {
                                  await ref
                                      .read(apiServiceProvider)
                                      .deleteNotifier(n['id'].toString());
                                  await _load();
                                });
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
      ],
    );
  }

  int _activeCount(Map<String, dynamic> n) {
    final o = n['options'];
    if (o is! Map) return 0;
    return o.entries
        .where((e) => e.key != 'id' && e.key != 'notifierId' && e.value == true)
        .length;
  }
}

class _NotifierDialog extends StatefulWidget {
  final Map<String, dynamic> item;
  const _NotifierDialog({required this.item});

  @override
  State<_NotifierDialog> createState() => _NotifierDialogState();
}

class _NotifierDialogState extends State<_NotifierDialog> {
  late final _name =
      TextEditingController(text: widget.item['name']?.toString() ?? '');
  final _url = TextEditingController();
  late bool _enabled = widget.item['enabled'] as bool? ?? true;
  late final Map<String, dynamic> _options = Map<String, dynamic>.from(
      widget.item['options'] is Map ? widget.item['options'] as Map : {});

  @override
  void dispose() {
    _name.dispose();
    _url.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: context.appCard,
      title: Text(l.notifierEdit),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                  controller: _name,
                  decoration: InputDecoration(labelText: l.name)),
              const SizedBox(height: 8),
              TextField(
                controller: _url,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: l.notifierAppriseUrlSkipped,
                  helperText: l.notifierAppriseUrlBlankHint,
                  helperMaxLines: 4,
                ),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _enabled,
                onChanged: (v) => setState(() => _enabled = v),
                title: Text(l.notifierEnable),
              ),
              const SizedBox(height: 4),
              Text(l.notifierWhatEvents,
                  style: TextStyle(
                      color: context.appFg, fontWeight: FontWeight.w700)),
              for (final (title, options) in _eventGroups(l)) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 2),
                  child: Text(title,
                      style: TextStyle(
                          color: context.appFgSub,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700)),
                ),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final (key, label) in options)
                      FilterChip(
                        label: Text(label),
                        selected: _options[key] == true,
                        onSelected: (v) => setState(() => _options[key] = v),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(
          onPressed: () {
            if (_name.text.trim().isEmpty) return;
            final opts = Map<String, dynamic>.from(_options)
              ..remove('id')
              ..remove('notifierId');
            Navigator.pop(context, {
              'id': widget.item['id'],
              'name': _name.text.trim(),
              'appriseUrl': _url.text.trim().isEmpty ? null : _url.text.trim(),
              'enabled': _enabled,
              'groupId': widget.item['groupId'],
              'householdId': widget.item['householdId'],
              'options': opts,
            });
          },
          child: Text(l.save),
        ),
      ],
    );
  }
}
