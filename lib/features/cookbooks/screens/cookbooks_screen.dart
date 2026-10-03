import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/cookbook_summary.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../providers/cookbooks_provider.dart';

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
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(e.toString(),
                      style: TextStyle(color: context.appFgSub),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () =>
                        ref.read(cookbooksProvider.notifier).reload(),
                    child: Text(l.retry),
                  ),
                ],
              ),
            ),
            data: (books) => books.isEmpty
                ? _EmptyState(message: l.cookbooksEmpty)
                : RefreshIndicator(
                    onRefresh: () =>
                        ref.read(cookbooksProvider.notifier).reload(),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                      itemCount: books.length,
                      itemBuilder: (ctx, i) => EntranceOnce(
                        id: 'cookbook-${books[i].id}',
                        index: i,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CookbookCard(cookbook: books[i]),
                        ),
                      ),
                    ),
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
            backgroundColor: context.appCard,
            content: Text(l.deleteOrganizerConfirm(cookbook.name),
                style: TextStyle(color: context.appFg)),
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
    final description = cookbook.description?.trim() ?? '';
    return Slidable(
      key: ValueKey(cookbook.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          SlidableAction(
            onPressed: (_) => context.push('/cookbooks/${cookbook.id}/edit'),
            backgroundColor: const Color(0xFF0A84FF),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: l.edit,
          ),
          SlidableAction(
            onPressed: (_) => _confirmDelete(context, ref),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: l.delete,
          ),
        ],
      ),
      child: BounceTap(
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
                  borderRadius: BorderRadius.circular(13),
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
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_rounded,
                size: 56, color: context.appFgTertiary),
            const SizedBox(height: 14),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: context.appFgSub, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
