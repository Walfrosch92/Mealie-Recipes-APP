import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../../organizers/screens/organizers_screen.dart'
    show showOrganizerNameDialog;
import '../providers/shopping_lists_provider.dart';
import 'shopping_list_screen.dart' show shoppingCategoryColor;
import '../../foods_units/screens/labels_screen.dart'
    show createLabelInteractive;

// ---------------------------------------------------------------------------
// Einkaufslisten verwalten (Home-Kachel) — wie die Listenübersicht der
// Mealie-Webapp: anlegen („+"), umbenennen, löschen, aktive Liste wählen und
// die Abteilungs-Reihenfolge pro Liste festlegen. Tippen → Aktionen,
// Wischen nach links → Umbenennen/Löschen.
// ---------------------------------------------------------------------------

class ShoppingListsScreen extends ConsumerWidget {
  const ShoppingListsScreen({super.key});

  void _error(BuildContext context, String fallback, Object e) {
    if (!context.mounted) return;
    final detail = mealieErrorMessage(e);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(detail == null ? fallback : '$fallback: $detail')));
  }

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final name =
        await showOrganizerNameDialog(context, title: l.newShoppingList);
    if (name == null) return;
    try {
      await ref.read(shoppingListsProvider.notifier).create(name);
      HapticFeedback.lightImpact();
    } catch (e) {
      if (context.mounted) _error(context, l.createFailed, e);
    }
  }

  Future<void> _rename(
      BuildContext context, WidgetRef ref, Map<String, dynamic> list) async {
    final l = AppLocalizations.of(context)!;
    final name = await showOrganizerNameDialog(context,
        title: l.renameAction,
        initial: shoppingListName(list),
        confirmLabel: l.save);
    if (name == null || name == shoppingListName(list)) return;
    try {
      await ref
          .read(shoppingListsProvider.notifier)
          .rename(list['id'] as String, name);
    } catch (e) {
      if (context.mounted) _error(context, l.saveFailed, e);
    }
  }

  Future<void> _delete(
      BuildContext context, WidgetRef ref, Map<String, dynamic> list) async {
    final l = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: ctx.appCard,
            content: Text(l.shoppingListDeleteConfirm(shoppingListName(list)),
                style: TextStyle(color: ctx.appFg)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l.cancel)),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l.delete),
              ),
            ],
          ),
        ) ??
        false;
    if (!ok) return;
    try {
      await ref
          .read(shoppingListsProvider.notifier)
          .delete(list['id'] as String);
    } catch (e) {
      if (context.mounted) _error(context, l.deleteFailed, e);
    }
  }

  Future<void> _actions(BuildContext context, WidgetRef ref,
      Map<String, dynamic> list, bool active) async {
    final l = AppLocalizations.of(context)!;
    final action = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      backgroundColor: context.appCard,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Text(shoppingListName(list),
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: ctx.appFg,
                      fontSize: 17,
                      fontWeight: FontWeight.w800)),
            ),
            if (!active)
              ListTile(
                leading:
                    Icon(Icons.check_circle_outline_rounded, color: ctx.appFg),
                title: Text(l.useAsActiveList),
                onTap: () => Navigator.pop(ctx, 'select'),
              ),
            ListTile(
              leading: Icon(Icons.low_priority_rounded, color: ctx.appFg),
              title: Text(l.labelOrderTitle),
              onTap: () => Navigator.pop(ctx, 'labels'),
            ),
            ListTile(
              leading: Icon(Icons.edit_rounded, color: ctx.appFg),
              title: Text(l.renameAction),
              onTap: () => Navigator.pop(ctx, 'rename'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded,
                  color: Color(0xFFE53935)),
              title: Text(l.delete,
                  style: const TextStyle(color: Color(0xFFE53935))),
              onTap: () => Navigator.pop(ctx, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    switch (action) {
      case 'select':
        await ref.read(shoppingListsProvider.notifier).select(list);
      case 'labels':
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => LabelOrderScreen(listId: list['id'] as String)));
      case 'rename':
        await _rename(context, ref, list);
      case 'delete':
        await _delete(context, ref, list);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final async = ref.watch(shoppingListsProvider);
    final activeId =
        ref.watch(settingsProvider).valueOrNull?.shoppingListId ?? '';

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Text(l.listManagementTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded, color: context.appFg),
            tooltip: l.newShoppingList,
            onPressed: () => _create(context, ref),
          ),
        ],
      ),
      body: WithCookingModeFAB(
        child: SafeArea(
          top: false,
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
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
                      onPressed: () => ref.invalidate(shoppingListsProvider),
                      child: Text(l.retry),
                    ),
                  ],
                ),
              ),
            ),
            data: (lists) => RefreshIndicator(
              onRefresh: ref.read(shoppingListsProvider.notifier).refresh,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: lists.length,
                itemBuilder: (_, i) {
                  final m = lists[i];
                  final active = m['id'] == activeId;
                  return EntranceOnce(
                    id: 'slist-${m['id']}',
                    index: i,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Slidable(
                        key: ValueKey(m['id']),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.5,
                          children: [
                            SlidableAction(
                              onPressed: (_) => _rename(context, ref, m),
                              backgroundColor: const Color(0xFF0A84FF),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: l.renameAction,
                            ),
                            SlidableAction(
                              onPressed: (_) => _delete(context, ref, m),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: l.delete,
                            ),
                          ],
                        ),
                        child: BounceTap(
                          onTap: () => _actions(context, ref, m, active),
                          scale: 0.99,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: context.appCard,
                              borderRadius:
                                  BorderRadius.circular(AppTokens.rMd),
                              border: Border.all(
                                  color: active
                                      ? AppTokens.accent
                                      : context.appSeparator,
                                  width: active ? 1.5 : 1),
                              boxShadow: context.appShadowSm,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    gradient: AppTokens.accentGradient,
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  child: const Icon(Icons.shopping_cart_rounded,
                                      color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(shoppingListName(m),
                                      style: TextStyle(
                                          color: context.appFg,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700)),
                                ),
                                if (active)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppTokens.accent
                                          .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(l.activeListBadge,
                                        style: const TextStyle(
                                            color: AppTokens.accentDeep,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800)),
                                  ),
                                const SizedBox(width: 4),
                                Icon(Icons.chevron_right_rounded,
                                    color: context.appFgTertiary),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Abteilungs-Reihenfolge einer Liste (Mealie `labelSettings`) per Ziehen.
class LabelOrderScreen extends ConsumerStatefulWidget {
  final String listId;
  const LabelOrderScreen({super.key, required this.listId});

  @override
  ConsumerState<LabelOrderScreen> createState() => _LabelOrderScreenState();
}

class _LabelOrderScreenState extends ConsumerState<LabelOrderScreen> {
  List<Map<String, dynamic>>? _settings;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Frisch vom Server (Summary kann veraltet sein), sonst aus der Übersicht.
    Map<String, dynamic>? list;
    try {
      list =
          await ref.read(apiServiceProvider).fetchShoppingList(widget.listId);
    } catch (_) {
      for (final m in ref.read(shoppingListsProvider).valueOrNull ?? const []) {
        if (m['id'] == widget.listId) list = m;
      }
    }
    if (!mounted) return;
    setState(() => _settings = list == null ? [] : sortedLabelSettings(list));
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _saving = true);
    try {
      await ref
          .read(shoppingListsProvider.notifier)
          .saveLabelOrder(widget.listId, _settings!);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mealieErrorMessage(e) ?? l.saveFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final settings = _settings;
    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Text(l.labelOrderTitle),
        actions: [
          // Neue Bezeichnung — Mealie hängt sie automatisch ans Ende jeder
          // Liste an; danach die Reihenfolge frisch laden.
          IconButton(
            tooltip: l.newLabel,
            icon: const Icon(Icons.add_rounded),
            onPressed: _saving
                ? null
                : () async {
                    final created = await createLabelInteractive(context, ref);
                    if (created != null && mounted) {
                      setState(() => _settings = null);
                      await _load();
                    }
                  },
          ),
          TextButton(
            onPressed: (settings == null || settings.isEmpty || _saving)
                ? null
                : _save,
            child: Text(l.save),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: settings == null
            ? const Center(child: CircularProgressIndicator())
            : settings.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(l.labelOrderEmpty,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.appFgSub)),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text(l.labelOrderHint,
                            style: TextStyle(
                                color: context.appFgSub, fontSize: 13)),
                      ),
                      Expanded(
                        child: ReorderableListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: settings.length,
                          onReorder: (from, to) => setState(() {
                            if (to > from) to--;
                            settings.insert(to, settings.removeAt(from));
                          }),
                          itemBuilder: (_, i) {
                            final s = settings[i];
                            final label = s['label'] is Map
                                ? Map<String, dynamic>.from(s['label'] as Map)
                                : const <String, dynamic>{};
                            final name = (label['name'] as String?) ?? '—';
                            return Card(
                              key: ValueKey(s['id']),
                              margin: const EdgeInsets.only(bottom: 8),
                              color: context.appCard,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppTokens.rSm),
                                  side:
                                      BorderSide(color: context.appSeparator)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 7,
                                  backgroundColor: shoppingCategoryColor(
                                      label['color'] as String?, name),
                                ),
                                title: Text(name,
                                    style: TextStyle(color: context.appFg)),
                                trailing: ReorderableDragStartListener(
                                  index: i,
                                  child: Icon(Icons.drag_handle_rounded,
                                      color: context.appFgTertiary),
                                ),
                              ),
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
