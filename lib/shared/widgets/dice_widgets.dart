import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../core/models/recipe_detail.dart';
import '../theme/app_colors.dart';
import 'animations.dart';
import 'gradient_button.dart' show SheetHandle;
import 'recipe_image.dart';

// ---------------------------------------------------------------------------
// Würfel — 3 zufällige Rezeptvorschläge. Gemeinsame Bausteine für die
// Mahlzeitenplanung (add_meal_entry_screen, dort mit Frühstück/Mittag/Abend-
// Gewichtung) und die Rezeptliste (reiner Zufall aus der aktuell gefilterten
// Liste). Vorher lagen Button und Karte privat im Mahlzeitenplan.
// ---------------------------------------------------------------------------

/// Bis zu [count] zufällige, verschiedene Rezepte aus [pool].
List<RecipeDetail> pickRandomRecipes(List<RecipeDetail> pool,
    {int count = 3, Random? random}) {
  final shuffled = List.of(pool)..shuffle(random ?? Random());
  return shuffled.take(count).toList();
}

class DiceButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String tooltip;
  final double size;

  const DiceButton(
      {super.key, required this.onTap, required this.tooltip, this.size = 46});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Tooltip(
      message: tooltip,
      child: BounceTap(
        onTap: onTap,
        scale: 0.92,
        child: Opacity(
          opacity: enabled ? 1 : 0.5,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: AppTokens.accentGradient,
              borderRadius: BorderRadius.circular(10),
              boxShadow: enabled ? context.appAccentGlow : null,
            ),
            child: Icon(Icons.casino_rounded,
                color: Colors.white, size: size * 0.48),
          ),
        ),
      ),
    );
  }
}

/// Würfel-Ergebniskarte — Foto + Name. [trailingIcon] zeigt, was ein Tap tut
/// (Mahlzeitenplan: einplanen, Rezeptliste: öffnen).
class DiceRecipeCard extends StatelessWidget {
  final RecipeDetail recipe;
  final String baseUrl;
  final String token;
  final VoidCallback onTap;
  final IconData trailingIcon;

  const DiceRecipeCard({
    super.key,
    required this.recipe,
    required this.baseUrl,
    required this.token,
    required this.onTap,
    this.trailingIcon = Icons.add_circle,
  });

  String get _imageUrl =>
      '$baseUrl/api/media/recipes/${recipe.id}/images/original.webp';

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      onTap: onTap,
      scale: 0.98,
      child: Container(
        height: 92,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: context.appCard,
          borderRadius: BorderRadius.circular(AppTokens.rLg),
          border: Border.all(color: context.appSeparator, width: 1),
          boxShadow: context.appShadowSm,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTokens.rLg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 92,
                child: RecipeImage(
                  recipeId: recipe.id,
                  imageUrl: _imageUrl,
                  httpHeaders: {'Authorization': 'Bearer $token'},
                  placeholder: _placeholder,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          recipe.name,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: context.appFg,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(trailingIcon,
                          color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) => Container(
        color: context.appSurface2,
        child: Icon(Icons.restaurant_rounded,
            size: 26, color: context.appFgTertiary),
      );
}

/// Bottom-Sheet mit 3 zufälligen Rezepten aus [pool] und einem Würfel zum
/// Neu-Würfeln. [onOpen] bekommt das gewählte Rezept (Sheet ist dann schon zu).
/// Liegt auf dem Root-Navigator, damit es die GlassTabBar überdeckt.
Future<void> showRandomRecipesSheet(
  BuildContext context, {
  required List<RecipeDetail> pool,
  required String baseUrl,
  required String token,
  required ValueChanged<RecipeDetail> onOpen,
}) async {
  final picked = await showModalBottomSheet<RecipeDetail>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: context.appCard,
    builder: (_) =>
        _RandomRecipesSheet(pool: pool, baseUrl: baseUrl, token: token),
  );
  if (picked != null) onOpen(picked);
}

class _RandomRecipesSheet extends StatefulWidget {
  final List<RecipeDetail> pool;
  final String baseUrl;
  final String token;

  const _RandomRecipesSheet(
      {required this.pool, required this.baseUrl, required this.token});

  @override
  State<_RandomRecipesSheet> createState() => _RandomRecipesSheetState();
}

class _RandomRecipesSheetState extends State<_RandomRecipesSheet> {
  final _random = Random();
  late List<RecipeDetail> _results;

  @override
  void initState() {
    super.initState();
    _results = pickRandomRecipes(widget.pool, random: _random);
  }

  void _reroll() => setState(
      () => _results = pickRandomRecipes(widget.pool, random: _random));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetHandle(),
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(l.diceModeTitle,
                        style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: context.appFg,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3)),
                  ),
                  DiceButton(
                      onTap: _reroll, tooltip: l.diceModeButton, size: 40),
                ],
              ),
            ),
            ..._results.map((r) => DiceRecipeCard(
                  recipe: r,
                  baseUrl: widget.baseUrl,
                  token: widget.token,
                  trailingIcon: Icons.chevron_right_rounded,
                  onTap: () => Navigator.of(context).pop(r),
                )),
          ],
        ),
      ),
    );
  }
}
