import 'package:flutter/material.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/autocomplete_field.dart';
import '../models/recipe_draft.dart';
import 'edit_common.dart';

/// Aktionen im „⋯"-Menü einer Zutat (wie das Zutaten-Menü der Webapp).
enum IngredientAction {
  toggleSection,
  linkRecipe,
  useFood,
  toggleSubstitutions,
  insertAbove,
  insertBelow,
  moveTop,
  moveBottom,
  delete,
}

/// Eine Zutat im Editor: Ziehgriff, Menge | Einheit | Lebensmittel (oder
/// verknüpftes Rezept), Notiz, optional Abschnittstitel und Alternativen.
class IngredientEditRow extends StatelessWidget {
  final DraftIngredient item;
  final int index;
  final int count;
  final List<String> unitNames;
  final List<String> foodNames;

  /// Name eines vorhandenen Lebensmittels? (Alternativen nur daraus)
  final bool Function(String name) foodExists;

  /// Alte Server mit „Zutatenmengen deaktivieren": nur die Notiz.
  final bool noteOnly;
  final bool substitutionsSupported;
  final ValueChanged<IngredientAction> onAction;
  final VoidCallback onPickRecipe;
  final VoidCallback onChanged;

  const IngredientEditRow({
    super.key,
    required this.item,
    required this.index,
    required this.count,
    required this.unitNames,
    required this.foodNames,
    required this.foodExists,
    required this.noteOnly,
    required this.substitutionsSupported,
    required this.onAction,
    required this.onPickRecipe,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final handle = ReorderableDragStartListener(
      index: index,
      child: Padding(
        padding: const EdgeInsets.only(right: 4, top: 10, bottom: 10),
        child: Icon(Icons.drag_indicator_rounded,
            size: 20, color: context.appFgTertiary),
      ),
    );
    final menu = EditMenuButton<IngredientAction>(
      onSelected: onAction,
      items: [
        EditMenuItem(IngredientAction.toggleSection, Icons.segment_rounded,
            item.showTitle ? l.clearSection : l.addIngredientSection),
        if (!noteOnly)
          item.linkedRecipe == null
              ? EditMenuItem(IngredientAction.linkRecipe,
                  Icons.menu_book_rounded, l.linkRecipeAction)
              : EditMenuItem(
                  IngredientAction.useFood, Icons.eco_rounded, l.useFoodAction),
        if (substitutionsSupported && !noteOnly)
          EditMenuItem(
              IngredientAction.toggleSubstitutions,
              Icons.swap_horiz_rounded,
              item.showSubstitutions
                  ? l.clearSubstitutionsAction
                  : l.addSubstitutionsAction),
        null,
        EditMenuItem(IngredientAction.insertAbove,
            Icons.vertical_align_top_rounded, l.insertAboveAction),
        EditMenuItem(IngredientAction.insertBelow,
            Icons.vertical_align_bottom_rounded, l.insertBelowAction),
        EditMenuItem(IngredientAction.moveTop, Icons.keyboard_double_arrow_up,
            l.moveToTopAction,
            enabled: index > 0),
        EditMenuItem(IngredientAction.moveBottom,
            Icons.keyboard_double_arrow_down, l.moveToBottomAction,
            enabled: index < count - 1),
        null,
        EditMenuItem(IngredientAction.delete, Icons.delete_outline_rounded,
            l.removeIngredient,
            destructive: true),
      ],
    );

    final Widget mainRow;
    if (noteOnly) {
      mainRow = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          handle,
          Expanded(
            child: TextField(
              onTapOutside: unfocusOnTapOutside,
              controller: item.note,
              minLines: 1,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => onChanged(),
              decoration: outlinedEditDecoration(l.ingredientName),
            ),
          ),
          menu,
        ],
      );
    } else {
      mainRow = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              handle,
              SizedBox(
                width: 58,
                child: TextField(
                  onTapOutside: unfocusOnTapOutside,
                  controller: item.quantity,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => onChanged(),
                  decoration: outlinedEditDecoration(l.ingredientQuantity),
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 84,
                child: AutocompleteField(
                  onTapOutside: unfocusOnTapOutside,
                  controller: item.unit,
                  options: unitNames,
                  decoration: outlinedEditDecoration(l.ingredientUnit),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: item.linkedRecipe != null
                    ? _LinkedRecipeField(
                        name: item.linkedName, onTap: onPickRecipe)
                    : AutocompleteField(
                        onTapOutside: unfocusOnTapOutside,
                        controller: item.food,
                        options: foodNames,
                        decoration: outlinedEditDecoration(l.ingredientName),
                      ),
              ),
              menu,
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28, right: 40, top: 6),
            child: TextField(
              onTapOutside: unfocusOnTapOutside,
              controller: item.note,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => onChanged(),
              decoration: outlinedEditDecoration(l.ingredientNote),
            ),
          ),
          if (item.showSubstitutions && substitutionsSupported)
            Padding(
              padding: const EdgeInsets.only(left: 28, right: 40, top: 6),
              child: _SubstitutionsBlock(
                item: item,
                foodNames: foodNames,
                foodExists: foodExists,
                onChanged: onChanged,
              ),
            ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (item.showTitle)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8, right: 40),
              child: TextField(
                onTapOutside: unfocusOnTapOutside,
                controller: item.title,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => onChanged(),
                style: const TextStyle(
                    color: AppTokens.accentDeep, fontWeight: FontWeight.w700),
                decoration: outlinedEditDecoration(
                  l.sectionTitleLabel,
                  prefixIcon: const Icon(Icons.segment_rounded, size: 20),
                  suffixIcon: IconButton(
                    tooltip: l.clearSection,
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () => onAction(IngredientAction.toggleSection),
                  ),
                ),
              ),
            ),
          mainRow,
        ],
      ),
    );
  }
}

class _LinkedRecipeField extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  const _LinkedRecipeField({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: outlinedEditDecoration(
          l.linkedRecipeLabel,
          prefixIcon: const Icon(Icons.menu_book_rounded,
              size: 18, color: AppTokens.accentDeep),
        ),
        child: Text(name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.appFg)),
      ),
    );
  }
}

/// Alternativen („kann ersetzt werden durch"): vorhandenes Lebensmittel
/// und/oder Notiz je Zeile.
class _SubstitutionsBlock extends StatelessWidget {
  final DraftIngredient item;
  final List<String> foodNames;
  final bool Function(String name) foodExists;
  final VoidCallback onChanged;

  const _SubstitutionsBlock({
    required this.item,
    required this.foodNames,
    required this.foodExists,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 4, 4),
      decoration: BoxDecoration(
        color: context.appSurface2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            const Icon(Icons.swap_horiz_rounded,
                size: 16, color: AppTokens.accentDeep),
            const SizedBox(width: 6),
            Text(l.recipeSubstitutionsTitle,
                style: TextStyle(
                    color: context.appFgSub,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 8),
          for (final s in item.substitutions)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListenableBuilder(
                      listenable: s.food,
                      builder: (context, _) {
                        final t = s.food.text.trim();
                        final unknown = t.isNotEmpty && !foodExists(t);
                        return AutocompleteField(
                          onTapOutside: unfocusOnTapOutside,
                          controller: s.food,
                          options: foodNames,
                          decoration: outlinedEditDecoration(
                            l.substitutionFoodLabel,
                          ).copyWith(
                              errorText:
                                  unknown ? l.substitutionUnknownFood : null,
                              errorMaxLines: 2),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      onTapOutside: unfocusOnTapOutside,
                      controller: s.note,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (_) => onChanged(),
                      decoration:
                          outlinedEditDecoration(l.substitutionNoteLabel),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      item.substitutions.remove(s);
                      s.dispose();
                      onChanged();
                    },
                  ),
                ],
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 6)),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(l.substitutionAddHint,
                  style: const TextStyle(fontSize: 13)),
              onPressed: () {
                item.substitutions.add(DraftSubstitution());
                onChanged();
              },
            ),
          ),
        ],
      ),
    );
  }
}
