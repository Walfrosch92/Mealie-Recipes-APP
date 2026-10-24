import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../providers/recently_viewed_provider.dart';
import '../providers/recipes_provider.dart';
import 'recipe_list_screen.dart' show RecipeCard;

// ---------------------------------------------------------------------------
// Zuletzt angesehen (Kachel in „Weiteres") — die zuletzt geöffneten Rezepte,
// neueste zuerst. Wischen entfernt einen Eintrag, das Symbol oben leert den
// Verlauf. Aufgelöst gegen den Rezept-Cache → auch offline.
// ---------------------------------------------------------------------------

class RecentlyViewedScreen extends ConsumerWidget {
  const RecentlyViewedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider).valueOrNull;
    final ids = ref.watch(recentlyViewedProvider);
    final all = ref.watch(recipesProvider).valueOrNull ?? const [];
    final byId = {for (final r in all) r.id: r};
    final recipes = [
      for (final id in ids)
        if (byId[id] != null) byId[id]!,
    ];

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Text(l.recentlyViewedTitle),
        actions: [
          if (recipes.isNotEmpty)
            IconButton(
              tooltip: l.recentlyViewedClear,
              icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: () => _confirmClear(context, ref),
            ),
        ],
      ),
      body: WithCookingModeFAB(
        child: SafeArea(
          top: false,
          child: recipes.isEmpty
              ? ListView(children: [
                  const SizedBox(height: 80),
                  Icon(Icons.history_rounded,
                      size: 56, color: context.appFgTertiary),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(l.recentlyViewedEmpty,
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: context.appFgSub, fontSize: 15)),
                  ),
                ])
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                  itemCount: recipes.length,
                  itemBuilder: (ctx, i) {
                    final r = recipes[i];
                    return EntranceOnce(
                      id: 'recent-${r.id}',
                      index: i,
                      child: Dismissible(
                        key: ValueKey('recent-${r.id}'),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => ref
                            .read(recentlyViewedProvider.notifier)
                            .remove(r.id),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: context.appSurface2,
                            borderRadius: BorderRadius.circular(AppTokens.rLg),
                          ),
                          child: Icon(Icons.history_toggle_off_rounded,
                              color: context.appFgSub),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: RecipeCard(
                            recipe: r,
                            showImage: settings?.showRecipeImages ?? true,
                            baseUrl: settings?.serverUrl ?? '',
                            token: settings?.apiToken ?? '',
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        backgroundColor: context.appCard,
        title:
            Text(l.recentlyViewedClear, style: TextStyle(color: context.appFg)),
        content: Text(l.recentlyViewedClearMessage,
            style: TextStyle(color: context.appFgSub)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(recentlyViewedProvider.notifier).clear();
            },
            child: Text(l.recentlyViewedClearConfirm),
          ),
        ],
      ),
    );
  }
}
