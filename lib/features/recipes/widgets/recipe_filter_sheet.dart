import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/organizer_item.dart';
import '../../../core/providers/cached_json_list.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/apple_icon.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/multi_select_sheet.dart';
import '../../organizers/providers/organizers_provider.dart';
import '../../shopping_list/providers/foods_units_provider.dart';
import '../providers/recipes_provider.dart';

// ---------------------------------------------------------------------------
// Filter der Rezeptliste — wie Mealies Rezeptsuche (RecipeExplorerPage-
// SearchFilters): Kategorien, Schlagworte, Utensilien, Lebensmittel je mit
// „Irgendeines/Alle enthalten", Haushalte als Einfachauswahl (nur bei mehr
// als einem Haushalt).
// ---------------------------------------------------------------------------

void showRecipeFilterSheet(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.appCard,
      builder: (_) => const _RecipeFilterSheet(),
    );

class _RecipeFilterSheet extends ConsumerWidget {
  const _RecipeFilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final f = ref.watch(recipeFilterProvider);
    final n = ref.read(recipeFilterProvider.notifier);
    final households =
        ref.watch(householdsListProvider).valueOrNull ?? const [];

    List<SelectItem> organizers(WidgetRef r, OrganizerKind kind) => [
          for (final o in r.watch(organizersProvider(kind)).valueOrNull ??
              const <OrganizerItem>[])
            (id: o.id, name: o.name),
        ];
    bool orgLoading(WidgetRef r, OrganizerKind kind) =>
        r.watch(organizersProvider(kind)).isLoading;

    List<SelectItem> foods(WidgetRef r) => [
          for (final x in r.watch(foodsCatalogProvider).valueOrNull ?? const [])
            if ((x.id ?? '').isNotEmpty && (x.name ?? '').trim().isNotEmpty)
              (id: x.id!, name: x.name!.trim()),
        ];
    List<SelectItem> householdItems(WidgetRef r) => [
          for (final h
              in r.watch(householdsListProvider).valueOrNull ?? const [])
            if ((h['id'] as String? ?? '').isNotEmpty)
              (
                id: h['id'] as String,
                name: (h['name'] as String? ?? '').trim()
              ),
        ];

    Future<void> pick({
      required String title,
      required Set<String> current,
      required List<SelectItem> Function(WidgetRef) items,
      bool Function(WidgetRef)? loading,
      bool? requireAll,
      bool single = false,
      required void Function(Set<String> ids, bool? all) apply,
    }) async {
      // Bekannte Namen für die bereits gewählten IDs mitgeben.
      final known = {for (final i in items(ref)) i.id: i.name};
      final res = await showMultiSelectSheet(
        context,
        title: title,
        initial: [for (final id in current) (id: id, name: known[id] ?? id)],
        items: items,
        loading: loading,
        requireAll: requireAll,
        single: single,
      );
      if (res == null) return;
      apply({for (final i in res.selected) i.id}, res.requireAll);
    }

    Widget row({
      required Widget icon,
      required String title,
      required Set<String> ids,
      required List<SelectItem> names,
      bool? requireAll,
      required VoidCallback onTap,
    }) {
      final byId = {for (final i in names) i.id: i.name};
      final chosen = [for (final id in ids) byId[id] ?? '…'];
      final sub = chosen.isEmpty
          ? l.filterAny
          : '${requireAll == true ? '${l.searchHasAll}: ' : ''}'
              '${chosen.join(', ')}';
      return ListTile(
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: ids.isNotEmpty
                ? AppTokens.accent.withValues(alpha: 0.14)
                : context.appSurface2,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Center(child: icon),
        ),
        title: Text(title,
            style:
                TextStyle(color: context.appFg, fontWeight: FontWeight.w600)),
        subtitle: Text(sub,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: ids.isNotEmpty ? AppTokens.accentDeep : context.appFgSub,
                fontSize: 13)),
        trailing:
            Icon(Icons.chevron_right_rounded, color: context.appFgTertiary),
        onTap: onTap,
      );
    }

    Color iconColor(Set<String> ids) =>
        ids.isNotEmpty ? AppTokens.accentDeep : context.appFgSub;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SheetHandle(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
            child: Row(children: [
              Expanded(
                child: Text(l.recipeFilterTitle,
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: context.appFg,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
              ),
              if (f.hasFilters)
                TextButton(
                  onPressed: n.reset,
                  child: Text(l.filterResetAll),
                ),
            ]),
          ),
          row(
            icon: Icon(Icons.category_rounded,
                size: 20, color: iconColor(f.categoryIds)),
            title: l.categories,
            ids: f.categoryIds,
            names: organizers(ref, OrganizerKind.category),
            requireAll: f.requireAllCategories,
            onTap: () => pick(
              title: l.categories,
              current: f.categoryIds,
              items: (r) => organizers(r, OrganizerKind.category),
              loading: (r) => orgLoading(r, OrganizerKind.category),
              requireAll: f.requireAllCategories,
              apply: (ids, all) => n.apply((x) =>
                  x.copyWith(categoryIds: ids, requireAllCategories: all)),
            ),
          ),
          row(
            icon:
                Icon(Icons.label_rounded, size: 20, color: iconColor(f.tagIds)),
            title: l.tags,
            ids: f.tagIds,
            names: organizers(ref, OrganizerKind.tag),
            requireAll: f.requireAllTags,
            onTap: () => pick(
              title: l.tags,
              current: f.tagIds,
              items: (r) => organizers(r, OrganizerKind.tag),
              loading: (r) => orgLoading(r, OrganizerKind.tag),
              requireAll: f.requireAllTags,
              apply: (ids, all) =>
                  n.apply((x) => x.copyWith(tagIds: ids, requireAllTags: all)),
            ),
          ),
          row(
            icon: Icon(Icons.soup_kitchen_rounded,
                size: 20, color: iconColor(f.toolIds)),
            title: l.toolsTitle,
            ids: f.toolIds,
            names: organizers(ref, OrganizerKind.tool),
            requireAll: f.requireAllTools,
            onTap: () => pick(
              title: l.toolsTitle,
              current: f.toolIds,
              items: (r) => organizers(r, OrganizerKind.tool),
              loading: (r) => orgLoading(r, OrganizerKind.tool),
              requireAll: f.requireAllTools,
              apply: (ids, all) => n
                  .apply((x) => x.copyWith(toolIds: ids, requireAllTools: all)),
            ),
          ),
          row(
            icon:
                iconOrApple(kAppleIcon, size: 20, color: iconColor(f.foodIds)),
            title: l.foodsTitle,
            ids: f.foodIds,
            names: foods(ref),
            requireAll: f.requireAllFoods,
            onTap: () => pick(
              title: l.foodsTitle,
              current: f.foodIds,
              items: foods,
              loading: (r) => r.watch(foodsCatalogProvider).isLoading,
              requireAll: f.requireAllFoods,
              apply: (ids, all) => n
                  .apply((x) => x.copyWith(foodIds: ids, requireAllFoods: all)),
            ),
          ),
          // Wie Mealie: Haushalte nur, wenn es mehr als einen gibt.
          if (households.length > 1)
            row(
              icon: Icon(Icons.home_work_rounded,
                  size: 20, color: iconColor(f.householdIds)),
              title: l.householdsTitle,
              ids: f.householdIds,
              names: householdItems(ref),
              onTap: () => pick(
                title: l.householdsTitle,
                current: f.householdIds,
                items: householdItems,
                loading: (r) => r.watch(householdsListProvider).isLoading,
                single: true,
                apply: (ids, _) =>
                    n.apply((x) => x.copyWith(householdIds: ids)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: GradientButton(
              label: l.done,
              icon: Icons.check_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ]),
      ),
    );
  }
}
