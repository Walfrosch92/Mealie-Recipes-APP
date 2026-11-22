import '../../../core/providers/permissions_provider.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/shimmer.dart';
import '../../../shared/widgets/swipe_context_menu.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/cookbook_summary.dart';
import '../../../core/utils/markdown_parse.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../providers/cookbooks_provider.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/empty_state_view.dart';

// ---------------------------------------------------------------------------
// Cookbooks — Übersicht der Haushalts-Kochbücher (GET /api/households/
// cookbooks). Tap auf ein Kochbuch → CookbookRecipesScreen mit der über den
// gespeicherten queryFilter aufgelösten Rezeptliste. „+" (AppBar) legt ein
// neues Kochbuch an; Slidable-Aktionen je Karte bearbeiten/löschen ein
// bestehendes — mirrors die Mealie-Webapp-Verwaltung 1:1.
// ---------------------------------------------------------------------------

class CookbooksScreen extends ConsumerWidget {
  const CookbooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final cookbooksAsync = ref.watch(cookbooksProvider);

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Text(l.cookbooks),
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded, color: context.appFg),
            tooltip: l.cookbookCreateTitle,
            onPressed: () => context.push('/cookbooks/new'),
          ),
        ],
      ),
      body: WithCookingModeFAB(
        child: SafeArea(
          top: false,
          child: cookbooksAsync.when(
            loading: () => const ListSkeleton(),
            error: (e, _) => ErrorRetryView(
              error: e,
              onRetry: () => ref.read(cookbooksProvider.notifier).reload(),
            ),
            data: (books) => books.isEmpty
                ? EmptyStateView(
                    icon: Icons.menu_book_rounded,
                    message: l.cookbooksEmpty,
                    scrollable: false)
                : RefreshIndicator(
                    onRefresh: () =>
                        ref.read(cookbooksProvider.notifier).reload(),
                    child: Builder(builder: (context) {
                      final rows = _grouped(
                          books, ref.watch(userPermissionsProvider).householdId);
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                        itemCount: rows.length,
                        itemBuilder: (ctx, i) {
                          final row = rows[i];
                          if (row is String) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: i == 0 ? 0 : 8, bottom: 8, left: 4),
                              child: Text(row.toUpperCase(),
                                  style: TextStyle(
                                      color: context.appFgTertiary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8)),
                            );
                          }
                          final book = row as CookbookSummary;
                          return EntranceOnce(
                            id: 'cookbook-${book.id}',
                            index: i,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _CookbookCard(cookbook: book),
                            ),
                          );
                        },
                      );
                    }),
                  ),
          ),
        ),
      ),
    );
  }
}

class _CookbookCard extends ConsumerWidget {
  final CookbookSummary cookbook;
  const _CookbookCard({required this.cookbook});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: ctx.appCard,
            content: Text(l.deleteOrganizerConfirm(cookbook.name),
                style: TextStyle(color: ctx.appFg)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l.cancel)),
              FilledButton(
                style: AppTokens.dangerButton,
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l.delete),
              ),
            ],
          ),
        ) ??
        false;
    if (!ok) return;
    try {
      await ref.read(cookbooksProvider.notifier).delete(cookbook.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.deleteFailed)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    // Mealie ≥ 3.31 erlaubt Markdown in der Beschreibung — die Karte zeigt
    // sie als Klartext, die Kochbuch-Ansicht formatiert.
    final description = markdownToPlainText(cookbook.description ?? '');
    // Wie die Webapp (cookbooks/index.vue): bearbeiten/löschen nur bei
    // Kochbüchern des eigenen Haushalts — Mealie ändert fremde nicht (404).
    final own = ref.watch(userPermissionsProvider).householdId;
    final mine = cookbook.householdId == null ||
        own == null ||
        cookbook.householdId == own;
    final card = _card(context, description);
    if (!mine) return card;
    return SwipeContextMenu(
        child: Slidable(
      key: ValueKey(cookbook.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: AppTokens.swipeExtent(2),
        children: [
          SlidableAction(
            onPressed: (_) => context.push('/cookbooks/${cookbook.id}/edit'),
            backgroundColor: AppTokens.swipeEdit,
            foregroundColor: Colors.white,
            icon: Icons.edit_rounded,
            label: l.edit,
          ),
          SlidableAction(
            onPressed: (_) => _confirmDelete(context, ref),
            backgroundColor: AppTokens.swipeDelete,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline_rounded,
            label: l.delete,
          ),
        ],
      ),
      child: card,
    ));
  }

  Widget _card(BuildContext context, String description) => BounceTap(
        onTap: () {
          HapticFeedback.selectionClick();
          context.push('/cookbooks/${cookbook.id}');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.appCard,
            borderRadius: BorderRadius.circular(AppTokens.rLg),
            border: Border.all(color: context.appSeparator, width: 1),
            boxShadow: context.appShadowSm,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTokens.rSm),
                  gradient: AppTokens.accentGradient,
                  boxShadow: context.appAccentGlow,
                ),
                child: const Icon(Icons.menu_book_rounded,
                    color: Colors.white, size: 23),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cookbook.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: context.appFg,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2)),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: context.appFgSub,
                              fontSize: 13,
                              height: 1.3)),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded,
                  color: context.appFgTertiary, size: 22),
            ],
          ),
        ),
      );
}

/// Webapp-Ordnung (DefaultLayout.vue): eigene Kochbücher zuerst, dann die
/// anderen Haushalte alphabetisch, jeweils mit dem Haushaltsnamen als
/// Überschrift; innerhalb nach Position (kommt schon sortiert). Ohne
/// bekannten Haushalt bleibt die einfache Liste.
List<Object> _grouped(List<CookbookSummary> books, String? ownHousehold) {
  if (ownHousehold == null || books.every((b) => b.householdId == null)) {
    return books;
  }
  final own = <CookbookSummary>[];
  final others = <String, List<CookbookSummary>>{};
  for (final b in books) {
    if (b.householdId == null || b.householdId == ownHousehold) {
      own.add(b);
    } else {
      others.putIfAbsent(b.householdName ?? '', () => []).add(b);
    }
  }
  final names = others.keys.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return [
    ...own,
    for (final n in names) ...[if (n.isNotEmpty) n, ...others[n]!],
  ];
}
