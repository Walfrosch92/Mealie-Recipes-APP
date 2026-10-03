import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../cooking_mode/widgets/cooking_mode_fab.dart';

import '../../../core/models/shopping_item.dart';
import '../../../shared/theme/app_colors.dart';
import '../providers/shopping_list_provider.dart';

// ---------------------------------------------------------------------------
// Archivierte Einkäufe — beim „Einkauf abschließen" abgelegte erledigte
// Artikel, neueste zuerst, mit Datum und Listenname (dauerhaft gespeichert,
// siehe ArchivedShoppingListsNotifier).
// ---------------------------------------------------------------------------

class ArchivedShoppingListsScreen extends ConsumerWidget {
  const ArchivedShoppingListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final lists = ref.watch(archivedShoppingListsProvider);

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Text(l.archivedLists),
        actions: [
          // "Alle löschen" — only when there are archived lists
          if (lists.isNotEmpty)
            TextButton(
              onPressed: () => _confirmDeleteAll(context, ref, l),
              child: Text(l.allDeleteConfirm),
            ),
        ],
      ),
      body: WithCookingModeFAB(
        child: SafeArea(
          top: false,
          child: lists.isEmpty
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(l.archivedEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.appFgSub, height: 1.4)),
                ))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: lists.length,
                  itemBuilder: (ctx, index) {
                    final p = lists[index];
                    final locale = Localizations.localeOf(context).toString();
                    final when =
                        '${DateFormat.yMMMEd(locale).format(p.date)}, ${DateFormat.Hm(locale).format(p.date)}';
                    return _ArchivedListSection(
                      key: ValueKey(p.id),
                      id: p.id,
                      title: when,
                      subtitle: p.listName,
                      items: p.items,
                      onDelete: () => ref
                          .read(archivedShoppingListsProvider.notifier)
                          .remove(p.id),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _confirmDeleteAll(
      BuildContext context, WidgetRef ref, AppLocalizations l) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.appCard,
        title: Text(l.deleteAllConfirmTitle,
            style: TextStyle(color: context.appFg)),
        content: Text(l.deleteAllConfirmMessage,
            style: TextStyle(color: context.appFgSub)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              ref.read(archivedShoppingListsProvider.notifier).deleteAll();
            },
            child: Text(l.delete),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Archived list section — mirrors iOS Section { Liste {n} } + swipe to delete
// ---------------------------------------------------------------------------

class _ArchivedListSection extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final List<ShoppingItem> items;
  final VoidCallback onDelete;

  const _ArchivedListSection({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // Eindeutige ID statt Datum/Liste/Anzahl (zwei Einkäufe in derselben
      // Minute kollidierten sonst).
      key: ValueKey('dismiss-$id'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header — mirrors iOS Section header "Liste {n}"
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Icon(Icons.inventory_2_outlined,
                    size: 16, color: context.appFgSub),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title,
                      style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: context.appFg,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2)),
                ),
                if (subtitle.isNotEmpty)
                  Flexible(
                    child: Text(subtitle,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: context.appFgSub, fontSize: 13)),
                  ),
              ],
            ),
          ),
          // Items grouped in a rounded premium card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: context.appCard,
              borderRadius: BorderRadius.circular(AppTokens.rLg),
              border: Border.all(color: context.appSeparator, width: 1),
              boxShadow: context.appShadowSm,
            ),
            child: Column(
              children: List.generate(items.length, (i) {
                final item = items[i];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            item.checked
                                ? Icons.check_circle_rounded
                                : Icons.circle_outlined,
                            size: 18,
                            color: item.checked
                                ? AppTokens.accentDeep
                                : context.appFgTertiary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              // Menge + Einheit + Name (vorher nur die
                              // Notiz → Lebensmittel-Artikel zeigten „-").
                              item.displayText.trim().isEmpty
                                  ? item.displayName
                                  : item.displayText,
                              style: TextStyle(
                                color: item.checked
                                    ? context.appFgTertiary
                                    : context.appFg,
                                fontSize: 16,
                                decoration: item.checked
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: context.appFgTertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i < items.length - 1)
                      Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: context.appSeparator),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
