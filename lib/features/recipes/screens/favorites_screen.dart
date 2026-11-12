import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../providers/favorites_provider.dart';
import '../providers/recipes_provider.dart';
import 'recipe_list_screen.dart' show RecipeCard;
import '../../../shared/widgets/empty_state_view.dart';

// ---------------------------------------------------------------------------
// Favoriten (Kachel) — nur die „geherzten" Rezepte des angemeldeten Nutzers
// (Mealie: pro Benutzer, GET /api/users/self/favorites). Aufgelöst gegen den
// lokalen Rezept-Cache → auch offline; alphabetisch sortiert. Herz im Rezept
// abwählen entfernt es hier sofort.
// ---------------------------------------------------------------------------

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider).valueOrNull;
    final favIds = ref.watch(favoritesProvider).valueOrNull ?? const <String>{};
    final all = ref.watch(recipesProvider).valueOrNull ?? const [];
    final loading = ref.watch(favoritesProvider).isLoading && favIds.isEmpty;
    final recipes = all.where((r) => favIds.contains(r.id)).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(title: Text(l.favoritesTitle)),
      body: WithCookingModeFAB(
        child: SafeArea(
          top: false,
          child: RefreshIndicator(
            onRefresh: () => ref.read(favoritesProvider.notifier).refresh(),
            child: loading
                ? ListView(children: const [
                    SizedBox(height: 120),
                    Center(child: CircularProgressIndicator()),
                  ])
                : recipes.isEmpty
                    ? EmptyStateView(
                        icon: Icons.favorite_rounded,
                        message: l.favoritesEmpty,
                        actionLabel: l.emptyBrowseRecipes,
                        actionIcon: Icons.restaurant_menu_rounded,
                        onAction: () => context.go('/recipes'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                        itemCount: recipes.length,
                        itemBuilder: (ctx, i) => EntranceOnce(
                          id: 'favorite-${recipes[i].id}',
                          index: i,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: RecipeCard(
                              recipe: recipes[i],
                              showImage: settings?.showRecipeImages ?? true,
                              baseUrl: settings?.serverUrl ?? '',
                              token: settings?.apiToken ?? '',
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
