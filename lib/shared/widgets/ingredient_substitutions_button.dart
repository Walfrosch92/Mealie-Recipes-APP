import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../core/models/recipe_detail.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/utils/ingredient_display.dart';
import '../theme/app_colors.dart';
import 'markdown_text.dart';
import 'tap_area.dart';

// ---------------------------------------------------------------------------
// Ersatzzutaten einer Zutat (Mealie 3.28) — wie die Webapp
// (RecipeIngredientSubstitutions.vue): ein ⇄-Knopf an der Zeile öffnet die
// Liste. Zuerst „Alternativen“ dieses Rezepts (volle Stärke), danach die
// allgemeinen des Lebensmittels („Kann ersetzt werden durch“, gedimmt).
// Ersatz-Lebensmittel werden wie die Zeile gebeugt; Notizen sind Markdown.
// ---------------------------------------------------------------------------

class IngredientSubstitutionsButton extends StatelessWidget {
  final Ingredient ingredient;
  final double multiplier;

  /// Zeilentext für die Überschrift des Sheets (z. B. „200 g Butter“).
  final String lineText;

  const IngredientSubstitutionsButton({
    super.key,
    required this.ingredient,
    required this.multiplier,
    required this.lineText,
  });

  @override
  Widget build(BuildContext context) {
    if (!ingredient.hasSubstitutions) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    return Semantics(
      button: true,
      label: l.recipeSubstitutionsTitle,
      child: TapArea(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.selectionClick();
          showIngredientSubstitutions(context,
              ingredient: ingredient,
              multiplier: multiplier,
              lineText: lineText);
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 8, top: 1),
          child: Icon(Icons.swap_horiz_rounded,
              size: 22, color: AppTokens.accentDeep),
        ),
      ),
    );
  }
}

Future<void> showIngredientSubstitutions(
  BuildContext context, {
  required Ingredient ingredient,
  required double multiplier,
  required String lineText,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => _SubstitutionsSheet(
        ingredient: ingredient, multiplier: multiplier, lineText: lineText),
  );
}

class _SubstitutionsSheet extends ConsumerWidget {
  final Ingredient ingredient;
  final double multiplier;
  final String lineText;
  const _SubstitutionsSheet(
      {required this.ingredient,
      required this.multiplier,
      required this.lineText});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider).valueOrNull;
    final plural = ingredientFoodPlural(ingredient, multiplier);
    final sections = [
      (l.recipeSubstitutionsTitle, ingredient.substitutions, false),
      (
        l.ingredientCommonlySubstitutedWith,
        ingredient.food?.substitutions ?? const <IngredientSubstitute>[],
        true
      ),
    ].where((s) => s.$2.isNotEmpty).toList();

    Widget item(IngredientSubstitute s) {
      final food = s.foodLabel(plural: plural);
      final note = s.note;
      final strong = TextStyle(
          color: context.appFg, fontSize: 15, fontWeight: FontWeight.w700);
      final sub = TextStyle(color: context.appFgSub, fontSize: 14);
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2, right: 10),
              child: Icon(Icons.swap_horiz_rounded,
                  size: 18, color: AppTokens.accentDeep),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (food != null) Text(food, style: strong),
                  // Ohne Lebensmittel IST die Notiz der Ersatz → kräftig,
                  // wie in der Webapp.
                  if (note != null)
                    MarkdownText(
                      text: note,
                      serverUrl: settings?.serverUrl,
                      apiToken: settings?.apiToken,
                      showImages: false,
                      style: food == null ? strong : sub,
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(lineText,
                style: TextStyle(
                    color: context.appFg,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            for (final (i, (title, items, dimmed)) in sections.indexed) ...[
              if (i > 0) const SizedBox(height: 14),
              Opacity(
                opacity: dimmed ? 0.7 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title.toUpperCase(),
                        style: TextStyle(
                            color: context.appFgTertiary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8)),
                    Divider(color: context.appSeparator, height: 14),
                    for (final s in items) item(s),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
