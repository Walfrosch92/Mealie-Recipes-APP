import 'package:flutter/material.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../features/recipes/providers/recipes_provider.dart';
import '../theme/app_colors.dart';
import 'gradient_button.dart' show SheetHandle;

// ---------------------------------------------------------------------------
// RecipeSortSheet — die 8 Sortieroptionen der Rezeptliste (recipe_list_screen)
// als eigenständiges, wiederverwendbares Bottom-Sheet. Extrahiert, damit die
// Rezeptsuche in der Mahlzeitenplanung (add_meal_entry_screen) dieselben
// Optionen anbieten kann, OHNE den globalen recipeFilterProvider der
// Hauptliste mitzubenutzen — [onSelect] entkoppelt die Auswahl vom
// jeweiligen Aufrufer-State (globaler Provider vs. lokaler Screen-State).
// ---------------------------------------------------------------------------

class RecipeSortSheet extends StatelessWidget {
  final RecipeSort current;
  final ValueChanged<RecipeSort> onSelect;

  const RecipeSortSheet({
    super.key,
    required this.current,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final options = [
      (RecipeSort.nameAZ, l.sortNameAZ, Icons.arrow_upward_rounded),
      (RecipeSort.nameZA, l.sortNameZA, Icons.arrow_downward_rounded),
      (RecipeSort.dateNewest, l.sortDateNewest, Icons.event_available_rounded),
      (RecipeSort.dateOldest, l.sortDateOldest, Icons.event_rounded),
      (RecipeSort.prepTimeShort, l.sortPrepTimeShort, Icons.schedule_rounded),
      (RecipeSort.prepTimeLong, l.sortPrepTimeLong, Icons.history_rounded),
      (RecipeSort.ratingHighest, l.sortRatingHighest, Icons.star_rounded),
      (RecipeSort.ratingLowest, l.sortRatingLowest, Icons.star_border_rounded),
    ];

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetHandle(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
            child: Text(l.sortRecipes,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3)),
          ),
          // Scrollable so the 8 options never overflow on small screens.
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: options
                  .map((opt) => ListTile(
                        leading: Icon(opt.$3,
                            color: opt.$1 == current
                                ? AppTokens.accentDeep
                                : context.appFgSub),
                        title: Text(opt.$2,
                            style: TextStyle(
                                color: context.appFg,
                                fontWeight: opt.$1 == current
                                    ? FontWeight.w700
                                    : FontWeight.w500)),
                        trailing: opt.$1 == current
                            ? const Icon(Icons.check_circle_rounded,
                                color: AppTokens.accentDeep)
                            : null,
                        onTap: () => onSelect(opt.$1),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
