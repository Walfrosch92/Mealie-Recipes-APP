import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
// RecipeCard wird 1:1 aus der Rezeptliste wiederverwendet (public dort).
import '../../recipes/screens/recipe_list_screen.dart';
import '../providers/cookbooks_provider.dart';

// ---------------------------------------------------------------------------
// CookbookRecipesScreen — Rezepte EINES Kochbuchs. OFFLINE-FIRST: die
// gecachte ID-Liste rendert sofort (aufgelöst gegen den lokalen Rezept-
// Cache), der queryFilter wird im Hintergrund frisch aufgelöst; offline
// bleibt der Cache-Stand stehen. Nur beim allerersten Öffnen ohne Cache
// braucht es den Server (sonst Fehler + Retry).
//
// Sonderfälle (Webapp-Spiegel):
//   • queryFilterString leer → Server liefert ALLE Rezepte, wird so gezeigt.
//   • items:[] → eigener Empty-State „Keine Rezepte entsprechen diesem Filter".
// ---------------------------------------------------------------------------

class CookbookRecipesScreen extends ConsumerWidget {
  final String cookbookId;
  const CookbookRecipesScreen({super.key, required this.cookbookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider).valueOrNull;
    final recipesAsync = ref.watch(cookbookRecipesProvider(cookbookId));

    // Name für die AppBar aus der Kochbuch-Liste auflösen (deep-link-sicher:
    // der Screen bekommt nur die id über die Route).
    final books = ref.watch(cookbooksProvider).valueOrNull ?? const [];
    var title = l.cookbooks;
    for (final c in books) {
      if (c.id == cookbookId) {
        title = c.name;
        break;
      }
    }

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(title: Text(title)),
      body: WithCookingModeFAB(
        child: SafeArea(
          top: false,
          child: recipesAsync.when(
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
                        ref.invalidate(cookbookRecipeIdsProvider(cookbookId)),
                    child: Text(l.retry),
                  ),
                ],
              ),
            ),
            data: (recipes) => recipes.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.filter_alt_off_rounded,
                              size: 56, color: context.appFgTertiary),
                          const SizedBox(height: 14),
                          Text(l.cookbookNoMatches,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: context.appFgSub, fontSize: 15)),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    // Kein invalidate (würde die Liste in den Spinner
                    // kippen): reload() holt den Server-Stand und lässt bei
                    // Offline den aktuellen Cache-Stand stehen.
                    onRefresh: () => ref
                        .read(cookbookRecipeIdsProvider(cookbookId).notifier)
                        .reload(),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                      itemCount: recipes.length,
                      itemBuilder: (ctx, i) => EntranceOnce(
                        id: 'cookbook-recipe-${recipes[i].id}',
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
      ),
    );
  }
}
