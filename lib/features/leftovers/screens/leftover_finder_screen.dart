import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/organizer_item.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/apple_icon.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/multi_select_sheet.dart';
import '../../../shared/widgets/query_filter_editor.dart';
import '../../../core/utils/cookbook_query_filter.dart';
import '../../../shared/widgets/recipe_image.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../../organizers/providers/organizers_provider.dart';
import '../../shopping_list/providers/foods_units_provider.dart';
import '../providers/leftover_finder_provider.dart';

// ---------------------------------------------------------------------------
// Rezept-Suche — Aufbau wie die Mealie-Webapp-Seite (Lebensmittel/Utensilien
// wählen, Einstellungen, „Ausgewählte Zutaten", Treffer in „Bereit zu
// Machen" / „Fast bereit zu Machen" mit „Fehlend"-Chips zum Antippen).
// Logik siehe [RecipeFinderNotifier].
// ---------------------------------------------------------------------------

class LeftoverFinderScreen extends ConsumerWidget {
  const LeftoverFinderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final st = ref.watch(recipeFinderProvider);
    final n = ref.read(recipeFinderProvider.notifier);
    final p = st.prefs;
    final ready = st.results.where((r) => r.readyToMake).toList();
    final almost = st.results.where((r) => !r.readyToMake).toList();

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(title: Text(l.leftoverFinder)),
      body: WithCookingModeFAB(
        child: SafeArea(
          top: false,
          child: RefreshIndicator(
            onRefresh: n.refresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              children: [
                // ── Beschreibung ─────────────────────────────────────
                PremiumCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          gradient: AppTokens.accentGradient,
                          boxShadow: context.appAccentGlow,
                        ),
                        child: const Icon(Icons.search_rounded,
                            color: Colors.white, size: 23),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(l.finderDescription,
                            style: TextStyle(
                                color: context.appFgSub,
                                fontSize: 14,
                                height: 1.4)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Lebensmittel / Utensilien / Einstellungen ────────
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _FilterButton(
                      icon: kAppleIcon, // Apfel wie die Lebensmittel-Kachel
                      label: l.foodsTitle,
                      count: p.foods.length,
                      onTap: () => _pickFoods(context, ref),
                    ),
                    _FilterButton(
                      icon: Icons.soup_kitchen_rounded,
                      label: l.toolsTitle,
                      count: p.tools.length,
                      onTap: () => _pickTools(context, ref),
                    ),
                    _FilterButton(
                      icon: Icons.filter_alt_rounded,
                      label: l.finderOtherFilters,
                      count: _otherFilterCount(p.queryFilter),
                      onTap: () => _openOtherFilters(context),
                    ),
                    _FilterButton(
                      icon: Icons.tune_rounded,
                      label: l.finderSettings,
                      onTap: () => _showSettings(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Ausgewählte Zutaten / Utensilien ─────────────────
                _SectionTitle(l.finderSelectedIngredients),
                const SizedBox(height: 8),
                if (p.foods.isEmpty)
                  Text(l.finderNoIngredientsSelected,
                      style: TextStyle(color: context.appFgSub))
                else
                  _ChipWrap(
                    items: p.foods,
                    onRemove: n.removeFood,
                  ),
                if (p.tools.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _SectionTitle(l.finderSelectedTools),
                  const SizedBox(height: 8),
                  _ChipWrap(items: p.tools, onRemove: n.removeTool),
                ],
                if (p.hasSelection)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: n.clearSelection,
                      icon: const Icon(Icons.close_rounded, size: 18),
                      label: Text(l.finderClearSelection),
                    ),
                  ),
                Divider(height: 28, color: context.appSeparator),

                // ── Ergebnisse ───────────────────────────────────────
                if (st.offline && !st.loading) ...[
                  _OfflineHint(text: l.finderOfflineHint),
                  const SizedBox(height: 14),
                ],
                if (st.offline && st.filterIgnored && !st.loading) ...[
                  _OfflineHint(text: l.filterOfflineIgnored),
                  const SizedBox(height: 14),
                ],
                if (!p.hasSelection)
                  const SizedBox.shrink()
                else if (st.loading && st.results.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12),
                      Text(l.finderLoadingRecipes,
                          style: TextStyle(color: context.appFgSub)),
                    ]),
                  )
                else if (st.results.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(children: [
                      Text(l.finderNoRecipesFound,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: context.appFg,
                              fontSize: 17,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(l.finderNoRecipesFoundDescription,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.appFgSub)),
                    ]),
                  )
                else ...[
                  if (st.loading)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: LinearProgressIndicator(),
                    ),
                  if (ready.isNotEmpty) ...[
                    _SectionTitle(l.finderReadyToMake),
                    const SizedBox(height: 10),
                    for (final s in ready) _SuggestionCard(suggestion: s),
                  ],
                  if (almost.isNotEmpty) ...[
                    if (ready.isNotEmpty) const SizedBox(height: 10),
                    _SectionTitle(l.finderAlmostReadyToMake),
                    const SizedBox(height: 10),
                    for (final s in almost) _SuggestionCard(suggestion: s),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickFoods(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final res = await showMultiSelectSheet(
      context,
      title: l.foodsTitle,
      initial: [
        for (final f in ref.read(recipeFinderProvider).prefs.foods)
          (id: f.id, name: f.name),
      ],
      items: (r) => [
        for (final f in r.watch(foodsCatalogProvider).valueOrNull ?? const [])
          if ((f.id ?? '').isNotEmpty)
            (
              id: f.id!,
              name: ((f.pluralName ?? '').trim().isNotEmpty
                      ? f.pluralName!
                      : f.name ?? '')
                  .trim(),
            ),
      ],
      loading: (r) => r.watch(foodsCatalogProvider).isLoading,
    );
    if (res != null) {
      ref
          .read(recipeFinderProvider.notifier)
          .setFoods([for (final i in res.selected) FinderItem(i.id, i.name)]);
    }
  }

  Future<void> _pickTools(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final res = await showMultiSelectSheet(
      context,
      title: l.toolsTitle,
      initial: [
        for (final t in ref.read(recipeFinderProvider).prefs.tools)
          (id: t.id, name: t.name),
      ],
      items: (r) => [
        for (final t
            in r.watch(organizersProvider(OrganizerKind.tool)).valueOrNull ??
                const <OrganizerItem>[])
          (id: t.id, name: t.name),
      ],
      loading: (r) => r.watch(organizersProvider(OrganizerKind.tool)).isLoading,
    );
    if (res != null) {
      ref
          .read(recipeFinderProvider.notifier)
          .setTools([for (final i in res.selected) FinderItem(i.id, i.name)]);
    }
  }

  /// Anzahl der Filter-Bedingungen (Roh-Text zählt als eine).
  int _otherFilterCount(String q) {
    if (q.trim().isEmpty) return 0;
    return tryParseCookbookQueryFilter(q)?.length ?? 1;
  }

  void _openOtherFilters(BuildContext context) =>
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const _OtherFiltersPage(),
      ));

  void _showSettings(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: context.appCard,
        builder: (_) => const _SettingsSheet(),
      );
}

// ---------------------------------------------------------------------------
// Bausteine
// ---------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          color: context.appFg,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2));
}

class _FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final VoidCallback onTap;

  const _FilterButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    final active = count > 0;
    return Material(
      color: active
          ? AppTokens.accent.withValues(alpha: 0.14)
          : context.appSurface2,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            iconOrApple(icon,
                size: 18,
                color: active ? AppTokens.accentDeep : context.appFgSub),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: active ? AppTokens.accentDeep : context.appFg,
                    fontWeight: FontWeight.w600)),
            if (active) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                decoration: BoxDecoration(
                  gradient: AppTokens.accentGradient,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('$count',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}

class _ChipWrap extends StatelessWidget {
  final List<FinderItem> items;
  final void Function(FinderItem) onRemove;

  const _ChipWrap({required this.items, required this.onRemove});

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final item in items)
            Container(
              padding: const EdgeInsets.fromLTRB(11, 6, 6, 6),
              decoration: BoxDecoration(
                color: AppTokens.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Flexible(
                  child: Text(item.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppTokens.accentDeep,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => onRemove(item),
                  child: const Icon(Icons.close_rounded,
                      size: 16, color: AppTokens.accentDeep),
                ),
              ]),
            ),
        ],
      );
}

class _OfflineHint extends StatelessWidget {
  final String text;
  const _OfflineHint({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.appSurface2,
          borderRadius: BorderRadius.circular(AppTokens.rSm),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.cloud_off_rounded, size: 18, color: context.appFgSub),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: context.appFgSub, fontSize: 13, height: 1.35)),
          ),
        ]),
      );
}

// ---------------------------------------------------------------------------
// Treffer-Karte — wie Mealie RecipeSuggestion: Rezept + „Fehlend:"-Chips
// (antippen = zur Auswahl hinzufügen bzw. wieder entfernen) + „Ersetzt:".
// ---------------------------------------------------------------------------

class _SuggestionCard extends ConsumerWidget {
  final FinderSuggestion suggestion;
  const _SuggestionCard({required this.suggestion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider).valueOrNull;
    final showImage = settings?.showRecipeImages ?? true;
    final prefs = ref.watch(recipeFinderProvider.select((s) => s.prefs));
    final n = ref.read(recipeFinderProvider.notifier);
    final s = suggestion;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => context.push('/recipes/${s.recipeId}'),
        child: PremiumCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                if (showImage) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: RecipeImage(
                        recipeId: s.recipeId,
                        imageUrl: '${settings?.serverUrl ?? ''}/api/media/'
                            'recipes/${s.recipeId}/images/original.webp',
                        httpHeaders: {
                          'Authorization': 'Bearer ${settings?.apiToken ?? ''}'
                        },
                        placeholder: (c) => Container(
                          color: c.appSurface2,
                          child: Icon(Icons.restaurant_rounded,
                              size: 20, color: c.appFgTertiary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(s.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: context.appFg,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2)),
                ),
                Icon(Icons.chevron_right_rounded, color: context.appFgTertiary),
              ]),
              if (s.missingFoods.isNotEmpty || s.missingTools.isNotEmpty) ...[
                const SizedBox(height: 10),
                _LabeledChips(
                  label: '${l.finderMissing}:',
                  children: [
                    for (final f in s.missingFoods)
                      _ToggleChip(
                        label: f.name,
                        selected: prefs.foods.contains(f),
                        onTap: () => prefs.foods.contains(f)
                            ? n.removeFood(f)
                            : n.addFood(f),
                      ),
                    for (final t in s.missingTools)
                      _ToggleChip(
                        label: t.name,
                        selected: prefs.tools.contains(t),
                        onTap: () => prefs.tools.contains(t)
                            ? n.removeTool(t)
                            : n.addTool(t),
                      ),
                  ],
                ),
              ],
              if (s.substitutedFoods.isNotEmpty) ...[
                const SizedBox(height: 8),
                _LabeledChips(
                  label: '${l.finderSubstituting}:',
                  children: [
                    for (final sub in s.substitutedFoods)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: context.appSurface2,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.swap_horiz_rounded,
                              size: 15, color: context.appFgSub),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                                l.finderSubstituteForFood(
                                    sub.substitute.name, sub.food.name),
                                style: TextStyle(
                                    color: context.appFg, fontSize: 12.5)),
                          ),
                        ]),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LabeledChips extends StatelessWidget {
  final String label;
  final List<Widget> children;
  const _LabeledChips({required this.label, required this.children});

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 6,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(label,
              style: TextStyle(
                  color: context.appFgSub,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          ...children,
        ],
      );
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ToggleChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        color: selected
            ? AppTokens.accent.withValues(alpha: 0.16)
            : context.appSurface2,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 5, 10, 5),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                  selected
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  size: 16,
                  color: selected ? AppTokens.accentDeep : context.appFgSub),
              const SizedBox(width: 4),
              Flexible(
                child: Text(label,
                    style: TextStyle(
                        color: selected ? AppTokens.accentDeep : context.appFg,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
        ),
      );
}

// ---------------------------------------------------------------------------
// „Andere Filter" — Mealies Query-Filter-Baukasten mit den Feldern der
// Rezept-Suche (Kategorien, Schlagworte, Zutaten, Bezeichnung, Haushalte,
// Benutzer, zuletzt gemacht, Bewertung, Gesamtzeit).
// ---------------------------------------------------------------------------

class _OtherFiltersPage extends ConsumerStatefulWidget {
  const _OtherFiltersPage();

  @override
  ConsumerState<_OtherFiltersPage> createState() => _OtherFiltersPageState();
}

class _OtherFiltersPageState extends ConsumerState<_OtherFiltersPage> {
  final _ctrl = QueryFilterEditorController();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final initial = ref.read(recipeFinderProvider).prefs.queryFilter;
    final n = ref.read(recipeFinderProvider.notifier);
    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(title: Text(l.finderOtherFilters)),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                QueryFilterEditor(
                  controller: _ctrl,
                  initialFilter: initial,
                  fields: kFinderFilterFields,
                  startWithRow: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    n.setQueryFilter('');
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close_rounded, size: 18),
                  label: Text(l.finderClearSelection),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GradientButton(
                  label: l.apply,
                  icon: Icons.check_rounded,
                  onTap: () {
                    n.setQueryFilter(_ctrl.compose());
                    Navigator.pop(context);
                  },
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Einstellungen (Mealie-Zahnrad-Menü) — Änderungen gelten sofort.
// ---------------------------------------------------------------------------

class _SettingsSheet extends ConsumerWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final p = ref.watch(recipeFinderProvider.select((s) => s.prefs));
    final n = ref.read(recipeFinderProvider.notifier);

    Widget stepper(String label, int value, void Function(int) set) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(children: [
            Expanded(
                child: Text(label, style: TextStyle(color: context.appFg))),
            IconButton(
              onPressed: value > 0 ? () => set(value - 1) : null,
              icon: const Icon(Icons.remove_circle_outline_rounded),
            ),
            SizedBox(
              width: 32,
              child: Text('$value',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: context.appFg,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ),
            IconButton(
              onPressed: () => set(value + 1),
              icon: const Icon(Icons.add_circle_outline_rounded),
            ),
          ]),
        );

    Widget toggle(String label, bool value, void Function(bool) set) =>
        SwitchListTile(
          title: Text(label, style: TextStyle(color: context.appFg)),
          value: value,
          activeTrackColor: AppTokens.accent,
          onChanged: set,
        );

    return SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SheetHandle(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(l.finderSettings,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
          ),
        ),
        stepper(l.finderMaxMissingIngredients, p.maxMissingFoods,
            (v) => n.updateSettings((x) => x.copyWith(maxMissingFoods: v))),
        stepper(l.finderMaxMissingTools, p.maxMissingTools,
            (v) => n.updateSettings((x) => x.copyWith(maxMissingTools: v))),
        toggle(l.finderIncludeFoodsOnHand, p.includeFoodsOnHand,
            (v) => n.updateSettings((x) => x.copyWith(includeFoodsOnHand: v))),
        toggle(l.finderIncludeToolsOnHand, p.includeToolsOnHand,
            (v) => n.updateSettings((x) => x.copyWith(includeToolsOnHand: v))),
        toggle(
            l.finderIncludeSubstitutions,
            p.includeSubstitutions,
            (v) =>
                n.updateSettings((x) => x.copyWith(includeSubstitutions: v))),
        const SizedBox(height: 8),
      ]),
    );
  }
}
