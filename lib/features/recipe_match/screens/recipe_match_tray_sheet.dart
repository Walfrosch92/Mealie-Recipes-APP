import 'package:flutter/material.dart';
import '../../../shared/widgets/sheet_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/recipe_detail.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../providers/recipe_match_provider.dart';
import '../../mealplan/screens/week_planner_screen.dart';
import 'recipe_match_mealplan_screen.dart';
import 'recipe_match_screen.dart' show RecipeMatchThumb;
import 'recipe_match_shopping_screen.dart';
import '../../../shared/widgets/collapsible_hint.dart';

// ---------------------------------------------------------------------------
// Tablett (Rezept-Match): gemerkte Rezepte. Von hier in den Essensplan oder
// mit Zutaten-Auswahl auf die Einkaufsliste. Bleibt erhalten, bis es
// geleert wird.
// ---------------------------------------------------------------------------

Future<void> showRecipeMatchTraySheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => const _TraySheet(),
    );

class _TraySheet extends ConsumerWidget {
  const _TraySheet();

  void _open(BuildContext context, Widget screen) {
    final nav = Navigator.of(context, rootNavigator: true);
    nav.pop();
    nav.push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final st = ref.watch(recipeMatchProvider);
    final all =
        ref.watch(recipesProvider).valueOrNull ?? const <RecipeDetail>[];
    final tray = st.trayRecipes(all);
    final n = ref.read(recipeMatchProvider.notifier);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (ctx, scroll) => Column(
        children: [
          const SheetHandle(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 8, 0),
            child: Row(children: [
              SheetTitle(l.recipeMatchTray),
              const SizedBox(width: 8),
              Text(l.recipeMatchTrayCount(tray.length),
                  style: TextStyle(color: context.appFgSub, fontSize: 13)),
              const Spacer(),
              if (tray.isNotEmpty)
                TextButton(
                  onPressed: n.clearTray,
                  child: Text(l.recipeMatchClear),
                ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: CollapsibleHint(
                text: l.recipeMatchTrayHint,
                prefsKey: 'hint_match_tray_collapsed',
                icon: Icons.move_to_inbox_rounded,
                dense: true),
          ),
          Expanded(
            child: tray.isEmpty
                ? ListView(controller: scroll, children: [
                    const SizedBox(height: 32),
                    EmptyStateView(
                      icon: Icons.move_to_inbox_rounded,
                      message: l.recipeMatchTrayEmpty,
                      scrollable: false,
                    ),
                  ])
                : ListView.separated(
                    controller: scroll,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    itemCount: tray.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) {
                      final r = tray[i];
                      return Material(
                        color: context.appSurface2,
                        borderRadius: BorderRadius.circular(AppTokens.rMd),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppTokens.rMd),
                          onTap: () {
                            final router = GoRouter.of(context);
                            Navigator.of(context, rootNavigator: true).pop();
                            router.push('/recipes/${r.id}');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(children: [
                              RecipeMatchThumb(recipe: r),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(r.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: context.appFg,
                                        fontSize: 15,
                                        height: 1.3,
                                        fontWeight: FontWeight.w600)),
                              ),
                              IconButton(
                                tooltip: l.recipeMatchRemove,
                                icon: Icon(Icons.close_rounded,
                                    color: context.appFgTertiary),
                                onPressed: () => n.removeFromTray(r.id),
                              ),
                            ]),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (tray.isNotEmpty)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Column(children: [
                  // Woche planen: Tablett-Rezepte zuerst verteilen, freie
                  // Plätze füllt der Planer mit eigenen Vorschlägen.
                  GradientButton(
                    label: l.recipeMatchPlanWeek,
                    icon: Icons.auto_fix_high_rounded,
                    onTap: () =>
                        _open(context, WeekPlannerScreen(preferred: tray)),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.appFg,
                        side: BorderSide(color: context.appSeparator),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTokens.rMd)),
                      ),
                      onPressed: () =>
                          _open(context, const RecipeMatchMealplanScreen()),
                      icon: const Icon(Icons.event_rounded),
                      label: Text(l.recipeMatchToMealplan),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.appFg,
                        side: BorderSide(color: context.appSeparator),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTokens.rMd)),
                      ),
                      onPressed: () =>
                          _open(context, const RecipeMatchShoppingScreen()),
                      icon: const Icon(Icons.shopping_cart_rounded),
                      label: Text(l.recipeMatchToShopping),
                    ),
                  ),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}
