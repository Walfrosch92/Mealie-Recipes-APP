import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/app_settings.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/utils/platform_features.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/dice_widgets.dart';
import '../../../shared/widgets/liquid_glass.dart';
import '../../../shared/widgets/recipe_sort_sheet.dart';
import '../../../shared/widgets/shimmer.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../providers/favorites_provider.dart';
import '../providers/recipes_provider.dart';
import '../widgets/recipe_filter_sheet.dart';
import '../../../shared/widgets/recipe_image.dart';

// Akzent für Tag-Tints (Orange, Premium-Redesign).
const _accent = Color(0xFFFF8A00);

// ---------------------------------------------------------------------------
// Recipe List — 1:1 clone of iOS RecipeListView
// ---------------------------------------------------------------------------

class RecipeListScreen extends ConsumerStatefulWidget {
  const RecipeListScreen({super.key});

  @override
  ConsumerState<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends ConsumerState<RecipeListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Reset the search query each time the list is opened, so reopening shows
    // all recipes again instead of the previous search results.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recipeFilterProvider.notifier).setQuery('');
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final recipesAsync = ref.watch(recipesProvider);
    final filter = ref.watch(recipeFilterProvider);
    final filtered = ref.watch(filteredRecipesProvider);
    final categories = ref.watch(allCategoriesProvider);
    final tags = ref.watch(allTagsProvider);
    final settings = ref.watch(settingsProvider).valueOrNull;
    final hasFilters = filter.hasFilters;

    // Progress (0–1) während Cold-Start / Refresh. Wenn voll oder 0 → kein
    // Balken anzeigen.
    final progress = ref.watch(recipeListProgressProvider);
    final showProgress = progress > 0 && progress < 1;

    return Scaffold(
      backgroundColor: context.appBg,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // `canPop()` wird hier beim BUILD ausgewertet (Button zeigen?), der Tap
        // feuert aber später. Ändert sich der Navigator-Stack dazwischen (z.B.
        // Tab-Wechsel via go), wäre der Button noch da, aber pop() würfe
        // „There is nothing to pop". Darum im onTap nochmal prüfen.
        leading: context.canPop()
            ? _BackButton(onTap: () {
                if (context.canPop()) context.pop();
              })
            : null,
        title: Text(l.recipeListTitle),
        // Alle Aktionen in EINEM ⋮-Menü (wie die Einkaufsliste). Der Punkt
        // am Symbol zeigt aktive Filter an.
        actions: [
          PopupMenuButton<String>(
            icon: Badge(
              isLabelVisible: filter.hasFilters,
              smallSize: 8,
              backgroundColor: AppTokens.accentDeep,
              child: Icon(Icons.more_vert_rounded, color: context.appFg),
            ),
            color: context.appCard,
            onSelected: (v) {
              switch (v) {
                case 'filter':
                  showRecipeFilterSheet(context);
                case 'sort':
                  _showSortSheet(context, filter.sort);
                case 'friends':
                  context.push('/cook-friends');
                case 'refresh':
                  ref.read(recipesProvider.notifier).refresh();
              }
            },
            itemBuilder: (_) => [
              _menuItem(
                  context,
                  'filter',
                  Icons.tune_rounded,
                  filter.hasFilters
                      ? '${l.recipeFilterTitle} (${filter.activeCount})'
                      : l.recipeFilterTitle,
                  highlight: filter.hasFilters),
              _menuItem(
                  context, 'sort', Icons.swap_vert_rounded, l.sortRecipes),
              _menuItem(
                  context, 'friends', Icons.group_add_rounded, l.cookFriends),
              _menuItem(context, 'refresh', Icons.refresh, l.refreshRecipes),
            ],
          ),
        ],
        bottom: showProgress
            ? PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 2,
                  backgroundColor: context.appSurface2,
                ),
              )
            : null,
      ),
      body: WithCookingModeFAB(
        bottomInset: GlassTabBar.height + 24,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Suchleiste (oben, wie im Premium-Mockup)
              _TopSearchBar(
                controller: _searchCtrl,
                hint: l.searchRecipe,
                onChanged: (v) =>
                    ref.read(recipeFilterProvider.notifier).setQuery(v),
                onClear: () {
                  _searchCtrl.clear();
                  ref.read(recipeFilterProvider.notifier).setQuery('');
                },
                // Würfel: 3 zufällige Rezepte aus der AKTUELL gezeigten Liste
                // (Suche + Filter gelten) — ohne die Frühstück/Mittag/Abend-
                // Gewichtung des Mahlzeitenplans.
                trailing: DiceButton(
                  tooltip: l.diceModeButton,
                  onTap: () => _rollDice(context, filtered, settings),
                ),
              ),

              // Category filter chips (multi-select) — mirrors iOS usedCategories
              if (categories.isNotEmpty)
                _FilterRow(
                  children: [
                    _FilterChip(
                      title: l.allCategories,
                      icon: Icons.grid_view_rounded,
                      selected: filter.categoryIds.isEmpty,
                      onTap: () => ref
                          .read(recipeFilterProvider.notifier)
                          .clearCategories(),
                    ),
                    ...categories.map((c) => _FilterChip(
                          title: c.name,
                          icon: Icons.sell_rounded,
                          selected: filter.categoryIds.contains(c.id),
                          onTap: () => ref
                              .read(recipeFilterProvider.notifier)
                              .toggleCategory(c.id),
                        )),
                  ],
                ),

              // Tag filter chips (multi-select) — mirrors iOS allTags
              if (tags.isNotEmpty)
                _FilterRow(
                  children: [
                    _FilterChip(
                      title: l.all,
                      icon: Icons.label_outline_rounded,
                      selected: filter.tagIds.isEmpty,
                      onTap: () =>
                          ref.read(recipeFilterProvider.notifier).clearTags(),
                    ),
                    ...tags.map((t) => _FilterChip(
                          title: t.name,
                          icon: Icons.label_rounded,
                          selected: filter.tagIds.contains(t.id),
                          onTap: () => ref
                              .read(recipeFilterProvider.notifier)
                              .toggleTag(t.id),
                        )),
                  ],
                ),

              // Recipe list
              Expanded(
                child: recipesAsync.when(
                  loading: () => const _RecipeListSkeleton(),
                  error: (e, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l.errorLoadingRecipes(e.toString()),
                            style: TextStyle(color: context.appFgSub),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () =>
                              ref.read(recipesProvider.notifier).refresh(),
                          child: Text(l.retry),
                        ),
                      ],
                    ),
                  ),
                  data: (_) {
                    // Empty + active filters → tray empty state with reset button
                    if (filtered.isEmpty && hasFilters) {
                      return _FilterEmptyState(
                        onReset: () =>
                            ref.read(recipeFilterProvider.notifier).reset(),
                      );
                    }
                    Widget card(int i) => RecipeCard(
                          recipe: filtered[i],
                          showImage: settings?.showRecipeImages ?? true,
                          baseUrl: settings?.serverUrl ?? '',
                          token: settings?.apiToken ?? '',
                        );
                    const listPadding = EdgeInsets.fromLTRB(
                        16, 10, 16, GlassTabBar.height + 24);
                    return RefreshIndicator(
                      onRefresh: () =>
                          ref.read(recipesProvider.notifier).refresh(),
                      // Große Anzeige (Windows/macOS): Karten mehrspaltig statt
                      // einer endlos breiten Zeile.
                      child: LargeScreen.isWide(context)
                          ? GridView.builder(
                              padding: listPadding,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 560,
                                mainAxisExtent: 150,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (ctx, i) => EntranceOnce(
                                id: 'recipe-${filtered[i].id}',
                                index: i,
                                child: card(i),
                              ),
                            )
                          : ListView.builder(
                              padding: listPadding,
                              itemCount: filtered.length,
                              itemBuilder: (ctx, i) => EntranceOnce(
                                id: 'recipe-${filtered[i].id}',
                                index: i,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: card(i),
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _menuItem(
          BuildContext context, String value, IconData icon, String label,
          {bool highlight = false}) =>
      PopupMenuItem(
        value: value,
        child: Row(children: [
          Icon(icon,
              size: 20,
              color: highlight ? AppTokens.accentDeep : context.appFg),
          const SizedBox(width: 12),
          Flexible(child: Text(label)),
        ]),
      );

  void _rollDice(
      BuildContext context, List<RecipeDetail> pool, AppSettings? settings) {
    if (pool.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.diceNotEnoughRecipes)));
      return;
    }
    showRandomRecipesSheet(
      context,
      pool: pool,
      baseUrl: settings?.serverUrl ?? '',
      token: settings?.apiToken ?? '',
      onOpen: (r) => context.push('/recipes/${r.id}'),
    );
  }

  void _showSortSheet(BuildContext context, RecipeSort current) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      backgroundColor: context.appCard,
      isScrollControlled: true,
      // Root-Navigator: die Rezeptliste liegt als Tab in einem Branch-
      // Navigator — ohne das Flag lag das Sheet HINTER der fixen GlassTabBar
      // und „Niedrigste Bewertung" war verdeckt (im Mahlzeitenplan, einem
      // Vollbild ohne Tab-Leiste, fiel das nie auf).
      useRootNavigator: true,
      builder: (sheetContext) => RecipeSortSheet(
        current: current,
        onSelect: (sort) {
          ref.read(recipeFilterProvider.notifier).setSort(sort);
          Navigator.of(sheetContext).pop();
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter row + chip — mirrors iOS FilterChip
// ---------------------------------------------------------------------------

class _FilterRow extends StatelessWidget {
  final List<Widget> children;
  const _FilterRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Höher, damit die Chip-Schrift (inkl. Descender) nicht beschnitten wird.
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        children: children
            .map((c) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: c,
                ))
            .toList(),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          gradient: selected ? AppTokens.accentGradient : null,
          color: selected ? null : context.appCard,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? Colors.transparent : context.appSeparator,
            width: 1,
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                      color: Color(0x40FF7800),
                      blurRadius: 10,
                      offset: Offset(0, 3))
                ]
              : context.appShadowSm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 14, color: selected ? Colors.white : context.appFgSub),
            const SizedBox(width: 6),
            Text(
              title,
              maxLines: 1,
              strutStyle: const StrutStyle(
                  fontSize: 13, height: 1.1, forceStrutHeight: true),
              style: TextStyle(
                color: selected ? Colors.white : context.appFg,
                fontSize: 13,
                height: 1.1,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter empty state — mirrors iOS tray empty view
// ---------------------------------------------------------------------------

class _FilterEmptyState extends StatelessWidget {
  final VoidCallback onReset;
  const _FilterEmptyState({required this.onReset});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: context.appFgTertiary),
          const SizedBox(height: 16),
          Text(l.noRecipesForCategory,
              style: TextStyle(
                  color: context.appFgSub,
                  fontSize: 17,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(l.resetFilter),
            style: FilledButton.styleFrom(
              backgroundColor: _accent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Top search bar (Premium-Redesign)
// ---------------------------------------------------------------------------

class _TopSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  /// Rechts neben dem Suchfeld (Würfel), optional.
  final Widget? trailing;

  const _TopSearchBar({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onClear,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Expanded(child: _field(context)),
          if (trailing != null) ...[const SizedBox(width: 10), trailing!],
        ],
      ),
    );
  }

  Widget _field(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(AppTokens.rSm),
        border: Border.all(color: context.appSeparator, width: 1),
        boxShadow: context.appShadowSm,
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: context.appFg, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: context.appFgTertiary, fontSize: 15),
          prefixIcon:
              Icon(Icons.search_rounded, color: context.appFgSub, size: 21),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded,
                      color: context.appFgSub, size: 19),
                  onPressed: onClear,
                )
              : null,
          filled: false,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Recipe card — Premium-Redesign: Foto-Karte mit Titel/Meta/Tags.
// Public (statt _RecipeCard), damit die Cookbook-Rezeptliste dieselbe Karte
// wiederverwendet statt sie zu duplizieren.
// ---------------------------------------------------------------------------

class RecipeCard extends ConsumerWidget {
  final RecipeDetail recipe;
  final bool showImage;
  final String baseUrl;
  final String token;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.showImage,
    required this.baseUrl,
    required this.token,
  });

  String get _imageUrl =>
      '$baseUrl/api/media/recipes/${recipe.id}/images/original.webp';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider
        .select((s) => s.valueOrNull?.contains(recipe.id) ?? false));
    return BounceTap(
      onTap: () {
        HapticFeedback.selectionClick();
        context.push('/recipes/${recipe.id}');
      },
      child: Container(
        // Feste, EINHEITLICHE Höhe für alle Karten.
        height: 150,
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
              if (showImage)
                Hero(
                  // Gleiches Tag wie das große Bild im Detail → fliegt hoch.
                  tag: 'recipe-image-${recipe.id}',
                  child: SizedBox(
                    width: 120,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        RecipeImage(
                          recipeId: recipe.id,
                          imageUrl: _imageUrl,
                          httpHeaders: {'Authorization': 'Bearer $token'},
                          placeholder: _imgPlaceholder,
                        ),
                        Positioned(
                          top: 6,
                          left: 6,
                          child: _FavoriteHeart(
                            isFavorite: isFav,
                            onTap: () => ref
                                .read(favoritesProvider.notifier)
                                .toggle(id: recipe.id, slug: recipe.slug),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        recipe.name,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: context.appFg,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                          height: 1.15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 7),
                      // Zeile 1: alle drei Zeiten nebeneinander
                      _TimesRow(recipe: recipe),
                      // Zeile 2: Bewertung immer UNTER den Zeiten
                      if ((recipe.rating ?? 0) > 0) ...[
                        const SizedBox(height: 4),
                        _RatingMeta(rating: recipe.rating!),
                      ],
                      if (recipe.tags.isNotEmpty ||
                          recipe.recipeCategory.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _TagsRow(
                          tags: [
                            ...recipe.recipeCategory.map((c) => c.name),
                            ...recipe.tags.map((t) => t.name),
                          ],
                        ),
                      ],
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

  Widget _imgPlaceholder(BuildContext context) => Container(
        color: context.appSurface2,
        child: Icon(Icons.restaurant_rounded,
            size: 30, color: context.appFgTertiary),
      );
}

// Herz-Overlay auf der Rezept-Karte (Favorit an/aus)
class _FavoriteHeart extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  const _FavoriteHeart({required this.isFavorite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.28),
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: TweenAnimationBuilder<double>(
              key: ValueKey(isFavorite),
              tween: Tween(begin: 0.7, end: 1.0),
              duration: const Duration(milliseconds: 280),
              curve: Curves.elasticOut,
              builder: (_, s, child) => Transform.scale(scale: s, child: child),
              child: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 17,
                color: isFavorite ? const Color(0xFFFF4D6D) : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Zeiten-Zeile: prep / cook / total nebeneinander (eine Zeile)
class _TimesRow extends StatelessWidget {
  final RecipeDetail recipe;
  const _TimesRow({required this.recipe});

  String _fmt(int min) {
    if (min < 60) return '$min min';
    final h = min ~/ 60;
    final m = min % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  @override
  Widget build(BuildContext context) {
    final sub = context.appFgSub;
    final items = <Widget>[];
    if ((recipe.prepTime ?? 0) > 0) {
      items.add(_item(Icons.restaurant_outlined, _fmt(recipe.prepTime!), sub));
    }
    if ((recipe.cookTime ?? 0) > 0) {
      items.add(_item(
          Icons.local_fire_department_outlined, _fmt(recipe.cookTime!), sub));
    }
    if ((recipe.totalTime ?? 0) > 0) {
      items.add(_item(Icons.schedule, _fmt(recipe.totalTime!), sub));
    }
    if (items.isEmpty) return const SizedBox.shrink();
    return Row(children: [
      for (var i = 0; i < items.length; i++) ...[
        if (i > 0) const SizedBox(width: 12),
        Flexible(child: items[i]),
      ],
    ]);
  }

  Widget _item(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color, fontSize: 12)),
        ),
      ],
    );
  }
}

// Bewertung (eigene Zeile unter den Zeiten)
class _RatingMeta extends StatelessWidget {
  final double rating;
  const _RatingMeta({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, size: 13, color: Colors.orange),
        const SizedBox(width: 4),
        Text(rating.toStringAsFixed(1),
            style: const TextStyle(color: Colors.orange, fontSize: 12)),
      ],
    );
  }
}

// Tag/Kategorie-Chips — IMMER eine Zeile (horizontal geclippt, nie unten
// abgeschnitten). Bei Überzahl 2 Chips + „+N".
class _TagsRow extends StatelessWidget {
  final List<String> tags;
  const _TagsRow({required this.tags});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();
    final hasExtra = tags.length > 3;
    final maxVisible = hasExtra ? 2 : tags.length;
    final visible = tags.take(maxVisible).toList();
    final extra = tags.length - visible.length;

    return SizedBox(
      height: 24,
      child: ClipRect(
        child: OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < visible.length; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                _chip(visible[i]),
              ],
              if (extra > 0) ...[
                const SizedBox(width: 6),
                Text('+$extra',
                    style: TextStyle(
                        color: context.appFgSub,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(name,
          maxLines: 1,
          strutStyle: const StrutStyle(
              fontSize: 11.5, height: 1.0, forceStrutHeight: true),
          style: const TextStyle(
              color: _accent,
              fontSize: 11.5,
              height: 1.0,
              fontWeight: FontWeight.w600)),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared back button widget
// ---------------------------------------------------------------------------

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Icon(Icons.chevron_left, color: context.appFg, size: 22),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shimmer-Skeleton während des Ladens
// ---------------------------------------------------------------------------

class _RecipeListSkeleton extends StatelessWidget {
  const _RecipeListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, GlassTabBar.height + 24),
        itemCount: 6,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: 116, height: 116, radius: AppTokens.rLg),
              SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 180, height: 16),
                      SizedBox(height: 12),
                      ShimmerBox(width: 120, height: 12),
                      SizedBox(height: 10),
                      ShimmerBox(width: 90, height: 20, radius: 999),
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
}
