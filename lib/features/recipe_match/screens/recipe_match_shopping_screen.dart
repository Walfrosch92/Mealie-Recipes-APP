import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/utils/ingredient_display.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../../shopping_list/providers/shopping_list_provider.dart';
import '../../shopping_list/providers/shopping_lists_provider.dart';
import '../providers/recipe_match_provider.dart';
import 'recipe_match_screen.dart' show RecipeMatchOnHandPill, RecipeMatchThumb;

// ---------------------------------------------------------------------------
// Rezept-Match → Einkaufsliste: alle Zutaten der Tablett-Rezepte einzeln
// abwählbar (sonst müllt die Liste zu). „Im Haushalt vorrätig" ist schon
// abgewählt. Übernommen wird wie überall über ShoppingListNotifier.addRecipe
// (Server-Weg mit Rezept-Verknüpfung, offline Warteschlange) in die aktive
// Einkaufsliste, mit dem Portionen-Faktor von der Kartenrückseite.
// ---------------------------------------------------------------------------

class RecipeMatchShoppingScreen extends ConsumerStatefulWidget {
  /// Feste Rezeptliste (z. B. aus „Woche planen", Faktor 1); ohne = die
  /// Rezepte auf dem Rezept-Match-Tablett mit ihrem Portionen-Faktor.
  final List<RecipeDetail>? recipes;

  /// Portionen-Faktor je Rezept-ID zu [recipes] (z. B. Summe der geplanten
  /// Portionen im Essensplan); fehlt ein Eintrag, gilt 1.
  final Map<String, double> scales;
  const RecipeMatchShoppingScreen(
      {super.key, this.recipes, this.scales = const {}});

  @override
  ConsumerState<RecipeMatchShoppingScreen> createState() =>
      _RecipeMatchShoppingScreenState();
}

class _RecipeMatchShoppingScreenState
    extends ConsumerState<RecipeMatchShoppingScreen> {
  bool Function(Ingredient)? _onHand;
  bool _ready = false;
  bool _adding = false;

  /// Abgewählte Zutaten je Rezept (Index in `recipeIngredient`). Abwahl
  /// statt Auswahl: neu aufs Tablett gelegte Rezepte sind dann komplett an.
  final Map<String, Set<int>> _deselected = {};

  @override
  void initState() {
    super.initState();
    ref
        .read(shoppingListProvider.notifier)
        .onHandChecker()
        .then((f) {
          _onHand = f;
        })
        .catchError((_) {})
        .whenComplete(() {
          if (!mounted) return;
          final all = ref.read(recipesProvider).valueOrNull ?? const [];
          for (final r in widget.recipes ??
              ref.read(recipeMatchProvider).trayRecipes(all)) {
            _deselected[r.id] = {
              for (var i = 0; i < r.recipeIngredient.length; i++)
                if (r.recipeIngredient[i].hasContent &&
                    (_onHand?.call(r.recipeIngredient[i]) ?? false))
                  i,
            };
          }
          setState(() => _ready = true);
        });
  }

  double _scaleOf(RecipeMatchState st, String id) =>
      widget.recipes != null ? (widget.scales[id] ?? 1) : st.scaleOf(id);

  List<int> _contentIndices(RecipeDetail r) => [
        for (var i = 0; i < r.recipeIngredient.length; i++)
          if (r.recipeIngredient[i].hasContent) i,
      ];

  bool _isSelected(RecipeDetail r, int i) =>
      !(_deselected[r.id]?.contains(i) ?? false);

  void _toggle(RecipeDetail r, int i) {
    HapticFeedback.selectionClick();
    setState(() {
      final set = _deselected.putIfAbsent(r.id, () => <int>{});
      if (!set.remove(i)) set.add(i);
    });
  }

  /// Rezept-Kopf antippen: alle an bzw. (wenn schon alle an) alle aus.
  void _toggleAll(RecipeDetail r) {
    HapticFeedback.selectionClick();
    final idx = _contentIndices(r);
    final allOn = idx.every((i) => _isSelected(r, i));
    setState(() => _deselected[r.id] = allOn ? idx.toSet() : <int>{});
  }

  Future<void> _submit(List<RecipeDetail> recipes, String listId) async {
    if (_adding) return;
    final l = AppLocalizations.of(context)!;
    final st = ref.read(recipeMatchProvider);
    final notifier = ref.read(shoppingListProvider.notifier);
    setState(() => _adding = true);
    var failed = 0;
    try {
      for (final r in recipes) {
        final picked = [
          for (final i in _contentIndices(r))
            if (_isSelected(r, i)) r.recipeIngredient[i],
        ];
        if (picked.isEmpty) continue;
        failed += await notifier.addRecipe(
          shoppingListId: listId,
          recipe: r,
          multiplier: _scaleOf(st, r.id),
          ingredients: picked,
        );
      }
      await notifier.refresh();
    } finally {
      if (mounted) setState(() => _adding = false);
    }
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(
      content: Text(failed > 0
          ? l.addIngredientsFailedCount(failed)
          : l.addIngredientsMessage),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final st = ref.watch(recipeMatchProvider);
    final all =
        ref.watch(recipesProvider).valueOrNull ?? const <RecipeDetail>[];
    final recipes = widget.recipes ?? st.trayRecipes(all);
    final listId =
        ref.watch(settingsProvider).valueOrNull?.shoppingListId ?? '';
    final lists = ref.watch(shoppingListsProvider).valueOrNull ?? const [];
    String listName = '';
    for (final m in lists) {
      if (m['id'] == listId) listName = (m['name'] as String?) ?? '';
    }

    var total = 0;
    var selected = 0;
    for (final r in recipes) {
      for (final i in _contentIndices(r)) {
        total++;
        if (_isSelected(r, i)) selected++;
      }
    }

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(title: Text(l.recipeMatchSelectIngredients)),
      body: !_ready
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: context.appCard,
                        borderRadius: BorderRadius.circular(AppTokens.rSm),
                        border: Border.all(color: context.appSeparator),
                      ),
                      child: Row(children: [
                        const Icon(Icons.shopping_cart_rounded,
                            size: 18, color: Color(0xFF2E9E57)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                              listId.isEmpty
                                  ? l.recipeMatchNoList
                                  : '${l.recipeMatchList}: $listName',
                              style: TextStyle(
                                  color: listId.isEmpty
                                      ? context.appFgSub
                                      : context.appFg,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 8),
                    Text(l.recipeMatchOnHandHint,
                        style: TextStyle(
                            color: context.appFgSub,
                            fontSize: 13,
                            height: 1.45)),
                    const SizedBox(height: 12),
                    for (final r in recipes) ...[
                      _RecipeBlock(
                        recipe: r,
                        scale: _scaleOf(st, r.id),
                        indices: _contentIndices(r),
                        isSelected: (i) => _isSelected(r, i),
                        isOnHand: (i) =>
                            _onHand?.call(r.recipeIngredient[i]) ?? false,
                        onToggle: (i) => _toggle(r, i),
                        onToggleAll: () => _toggleAll(r),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: GradientButton(
                    label: l.recipeMatchAddCount(selected, total),
                    icon: Icons.add_shopping_cart_rounded,
                    busy: _adding,
                    onTap: listId.isEmpty || selected == 0
                        ? null
                        : () => _submit(recipes, listId),
                  ),
                ),
              ),
            ]),
    );
  }
}

class _RecipeBlock extends StatelessWidget {
  final RecipeDetail recipe;
  final double scale;
  final List<int> indices;
  final bool Function(int) isSelected;
  final bool Function(int) isOnHand;
  final void Function(int) onToggle;
  final VoidCallback onToggleAll;
  const _RecipeBlock({
    required this.recipe,
    required this.scale,
    required this.indices,
    required this.isSelected,
    required this.isOnHand,
    required this.onToggle,
    required this.onToggleAll,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final picked = indices.where(isSelected).length;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(AppTokens.rMd),
        border: Border.all(color: context.appSeparator),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        InkWell(
          onTap: onToggleAll,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.appSeparator)),
            ),
            child: Row(children: [
              RecipeMatchThumb(recipe: recipe, size: 34),
              const SizedBox(width: 10),
              Expanded(
                child: Text(recipe.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: context.appFg,
                        fontSize: 14,
                        height: 1.25,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              Text('$picked / ${indices.length}',
                  style: TextStyle(color: context.appFgSub, fontSize: 12)),
            ]),
          ),
        ),
        if (indices.isEmpty)
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text('—', style: TextStyle(color: context.appFgTertiary)),
          ),
        for (final i in indices)
          Builder(builder: (ctx) {
            final parts =
                ingredientDisplayParts(recipe.recipeIngredient[i], scale);
            final on = isSelected(i);
            final text =
                [parts.amount, parts.name].where((s) => s.isNotEmpty).join(' ');
            return CheckboxListTile(
              value: on,
              onChanged: (_) => onToggle(i),
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppTokens.accent,
              contentPadding: const EdgeInsets.symmetric(horizontal: 6),
              title: Row(children: [
                Expanded(
                  child: Text(text,
                      style: TextStyle(
                          color: on ? context.appFg : context.appFgTertiary,
                          fontSize: 14)),
                ),
                if (isOnHand(i))
                  RecipeMatchOnHandPill(label: l.recipeMatchOnHand),
              ]),
            );
          }),
      ]),
    );
  }
}
