import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/mealplan_rule.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/dice_widgets.dart';
import '../../../shared/widgets/recipe_sort_sheet.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../providers/mealplan_provider.dart';
import '../providers/mealplan_rules_provider.dart';
import '../../../shared/widgets/recipe_image.dart';
import '../../../core/utils/search_match.dart';

// ---------------------------------------------------------------------------
// Essenstyp → Kategorie-Stichwörter (Issue: intelligente Würfel-Filterung).
// Mealie-Kategorien sind komplett freier, haushaltseigener Text — es gibt
// keinen festen Bezug zu Frühstück/Mittag/Abend. Enthält-Suche (case-
// insensitive) gegen eine Stichwortliste über alle 10 App-Sprachen, damit
// z. B. auch eine Kategorie "Kinder-Frühstück" als Frühstück zählt,
// unabhängig davon in welcher Sprache der Haushalt seine Kategorien pflegt.
// ---------------------------------------------------------------------------

const Map<String, List<String>> _mealTypeCategoryKeywords = {
  'breakfast': [
    'frühstück',
    'breakfast',
    'desayuno',
    'petit-déjeuner',
    'petit déjeuner',
    'reggeli',
    'ontbijt',
    'śniadanie',
    'pequeno-almoço',
    'pequeno almoço',
    'café da manhã',
    'zajtrk',
    'frokost',
  ],
  'lunch': [
    'mittagessen',
    'mittag',
    'lunch',
    'almuerzo',
    'déjeuner',
    'ebéd',
    'obiad',
    'almoço',
    'kosilo',
    'lunsj',
  ],
  'dinner': [
    'abendessen',
    'dinner',
    'supper',
    'cena',
    'dîner',
    'vacsora',
    'avondeten',
    'diner',
    'kolacja',
    'jantar',
    'večerja',
    'middag',
    'kveldsmat',
  ],
};

/// Eigene Würfel-Auswahl (Zahnrad im Mahlzeitenplan): ein Rezept passt, wenn
/// es MINDESTENS EINE der gewählten Kategorien/Schlagworte hat (`c:<id>`,
/// `t:<id>`, siehe AppSettings.mealDiceFilters).
bool recipeMatchesDiceFilter(RecipeDetail recipe, List<String> filter) =>
    filter.any((f) {
      final id = f.length > 2 ? f.substring(2) : '';
      if (f.startsWith('c:')) {
        return recipe.recipeCategory.any((c) => c.id == id);
      }
      if (f.startsWith('t:')) return recipe.tags.any((t) => t.id == id);
      return false;
    });

bool _matchesMealType(RecipeDetail recipe, String slot) {
  final keywords = _mealTypeCategoryKeywords[slot];
  if (keywords == null) return true; // unbekannter Slot -> kein Filter
  return recipe.recipeCategory.any((c) {
    final name = c.name.toLowerCase();
    return keywords.any((k) => name.contains(k));
  });
}

// ---------------------------------------------------------------------------
// Add Meal Entry — mirrors iOS AddMealEntryView 1:1
// ---------------------------------------------------------------------------

class AddMealEntryScreen extends ConsumerStatefulWidget {
  final DateTime? defaultDate;
  final String? defaultRecipeId;
  final String? defaultRecipeName;

  const AddMealEntryScreen({
    super.key,
    this.defaultDate,
    this.defaultRecipeId,
    this.defaultRecipeName,
  });

  @override
  ConsumerState<AddMealEntryScreen> createState() => _AddMealEntryScreenState();
}

class _AddMealEntryScreenState extends ConsumerState<AddMealEntryScreen> {
  late DateTime _selectedDate;
  String _selectedSlot = 'lunch';
  final _searchCtrl = TextEditingController();
  String _search = '';
  bool _submitting = false;

  // Würfelmodus — 3 zufällige Rezeptvorschläge statt der Suchliste. Datum
  // und Slot bleiben unverändert oben wählbar, der Würfel ersetzt nur den
  // unteren Auswahlbereich (Suche ↔ 3 Vorschläge).
  final _diceRandom = Random();
  List<RecipeDetail>? _diceResults;

  // Sortierung der normalen Suchliste — dieselben 8 Optionen wie in der
  // Rezeptliste (RecipeSort/applyRecipeSort), aber als eigener, lokaler
  // Screen-State statt über den globalen recipeFilterProvider: die Wahl
  // hier soll NICHT die Sortierung der Hauptliste verändern.
  RecipeSort _sort = RecipeSort.nameAZ;

  Future<void> _rollDice(List<RecipeDetail> allRecipes,
      {bool appSelection = false}) async {
    final l = AppLocalizations.of(context)!;
    final settings = ref.read(settingsProvider).valueOrNull;

    // Vom Nutzer gewähltes System (Zahnrad): Mealie-Regeln des Haushalts
    // statt der App-eigenen Auswahl.
    if (!appSelection && (settings?.mealDiceUseMealieRules ?? false)) {
      await _rollWithMealieRules(allRecipes);
      return;
    }

    final filter = settings?.mealDiceFilters[_selectedSlot] ?? const [];

    // Eigene Auswahl für diese Mahlzeit → NUR passende Rezepte, kein
    // Auffüllen mit fremden (der Nutzer hat bewusst eingeschränkt).
    if (filter.isNotEmpty) {
      final matching = allRecipes
          .where((r) => recipeMatchesDiceFilter(r, filter))
          .toList()
        ..shuffle(_diceRandom);
      if (matching.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.mealDiceNoMatches)));
        return;
      }
      if (matching.length < 3) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l.mealDiceFewMatches(matching.length))));
      }
      setState(() {
        _diceResults = matching.take(3).toList();
        _search = '';
        _searchCtrl.clear();
      });
      return;
    }

    // Keine eigene Auswahl: einmalig erklären, dass automatisch nach
    // Stichwörtern gewählt wird und wo man das einstellt.
    if (!(settings?.hideMealDiceAutoHint ?? false)) {
      final dontShow = await _showAutoHint();
      if (!mounted) return;
      if (dontShow && settings != null) {
        await ref
            .read(settingsProvider.notifier)
            .save(settings.copyWith(hideMealDiceAutoHint: true));
        if (!mounted) return;
      }
    }

    if (allRecipes.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.diceNotEnoughRecipes)),
      );
      return;
    }
    // Priorisiert Rezepte, deren Kategorie zum gewählten Essenstyp passt;
    // reicht die Trefferzahl nicht für 3 Vorschläge, füllt der Rest
    // zufällig aus allen übrigen Rezepten auf (statt eine Fehlermeldung zu
    // zeigen) — es gibt also immer 3 Vorschläge, sobald genug Rezepte
    // insgesamt vorhanden sind.
    final matching = allRecipes
        .where((r) => _matchesMealType(r, _selectedSlot))
        .toList()
      ..shuffle(_diceRandom);
    final others = allRecipes
        .where((r) => !_matchesMealType(r, _selectedSlot))
        .toList()
      ..shuffle(_diceRandom);
    final combined = [...matching, ...others].take(3).toList();
    setState(() {
      _diceResults = combined;
      _search = '';
      _searchCtrl.clear();
    });
  }

  /// Würfelt nach den Mealie-Regeln — wie der Zufallsknopf der Webapp:
  /// alle für Tag + Mahlzeit passenden Regeln UND-verknüpft, der Server wertet
  /// den Filter aus. Greift keine Regel, wählt der Würfel wie Mealie aus allen
  /// Rezepten. Cache-first: die Treffer je Filter werden gespeichert und
  /// offline wiederverwendet; gab es für den Filter noch nie Treffer vom
  /// Server, fällt der Würfel offline auf die App-Auswahl zurück.
  Future<void> _rollWithMealieRules(List<RecipeDetail> allRecipes) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    List<MealPlanRule> rules;
    try {
      rules = await ref.read(mealplanRulesProvider.future);
    } catch (_) {
      rules = const [];
    }
    final filter = combinedRuleFilter(rules, _selectedDate, _selectedSlot);
    var pool = allRecipes;
    var filtered = false;
    if (filter != null) {
      Set<String>? ids;
      try {
        ids = (await ref
                .read(apiServiceProvider)
                .fetchRecipeSummariesByQueryFilter(filter))
            .map((r) => r.id)
            .toSet();
        unawaited(saveMealRuleMatches(filter, ids));
      } catch (_) {
        ids = await loadMealRuleMatches(filter);
      }
      if (!mounted) return;
      if (ids == null) {
        messenger.showSnackBar(SnackBar(content: Text(l.mealRulesOffline)));
        await _rollDice(allRecipes, appSelection: true);
        return;
      }
      pool = allRecipes.where((r) => ids!.contains(r.id)).toList();
      filtered = true;
    }
    if (!mounted) return;
    if (pool.isEmpty) {
      messenger.showSnackBar(SnackBar(
          content:
              Text(filtered ? l.mealRulesNoMatches : l.diceNotEnoughRecipes)));
      return;
    }
    final picks = List.of(pool)..shuffle(_diceRandom);
    if (filtered && picks.length < 3) {
      messenger.showSnackBar(
          SnackBar(content: Text(l.mealDiceFewMatches(picks.length))));
    }
    setState(() {
      _diceResults = picks.take(3).toList();
      _search = '';
      _searchCtrl.clear();
    });
  }

  void _exitDiceMode() => setState(() => _diceResults = null);

  /// Hinweis „automatische Auswahl" mit „Nicht mehr anzeigen". Liefert true,
  /// wenn der Nutzer ihn abbestellt hat.
  Future<bool> _showAutoHint() async {
    var dontShow = false;
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        final l = AppLocalizations.of(ctx)!;
        return StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
            backgroundColor: ctx.appCard,
            title: Row(
              children: [
                const Icon(Icons.casino_rounded, color: AppTokens.accentDeep),
                const SizedBox(width: 10),
                Expanded(child: Text(l.mealDiceAutoHintTitle)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.mealDiceAutoHintBody,
                    style: TextStyle(color: ctx.appFgSub, height: 1.4)),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => setLocal(() => dontShow = !dontShow),
                  child: Row(
                    children: [
                      Checkbox(
                        value: dontShow,
                        onChanged: (v) => setLocal(() => dontShow = v ?? false),
                      ),
                      Expanded(child: Text(l.dontShowAgain)),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l.ok),
              ),
            ],
          ),
        );
      },
    );
    return dontShow;
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      backgroundColor: context.appCard,
      isScrollControlled: true,
      builder: (_) => RecipeSortSheet(
        current: _sort,
        onSelect: (sort) {
          setState(() => _sort = sort);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.defaultDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _add({String? recipeId, String? title}) async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      await ref.read(mealplanProvider.notifier).addEntry(
            date: _fmtDate(_selectedDate),
            entryType: _selectedSlot,
            recipeId: recipeId,
            title: title,
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final recipesAsync = ref.watch(recipesProvider);
    final hasLockedRecipe = widget.defaultRecipeId != null;
    final settings = ref.watch(settingsProvider).valueOrNull;
    final baseUrl = settings?.serverUrl ?? '';
    final token = settings?.apiToken ?? '';

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        leadingWidth: 100,
        title: Text(l.planMeal),
        centerTitle: true,
        actions: [
          if (!hasLockedRecipe)
            IconButton(
              icon: Icon(Icons.swap_vert_rounded, color: context.appFg),
              tooltip: l.sortRecipes,
              onPressed: () => _showSortSheet(context),
            ),
        ],
      ),
      body: WithCookingModeFAB(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Locked recipe (when pre-selected)
              if (hasLockedRecipe)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(l.selectedRecipe,
                            style: TextStyle(
                                color: context.appFgSub, fontSize: 14)),
                      ),
                      const SizedBox(height: 8),
                      PremiumCard(
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: AppTokens.accentGradient,
                                boxShadow: context.appAccentGlow,
                              ),
                              child: const Icon(Icons.restaurant_menu_rounded,
                                  color: Colors.white, size: 21),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(widget.defaultRecipeName ?? '',
                                  style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      color: context.appFg,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (hasLockedRecipe) const SizedBox(height: 16),

              // Date picker row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l.selectDate,
                        style: TextStyle(
                            color: context.appFg,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          color: context.appCard,
                          borderRadius: BorderRadius.circular(AppTokens.rSm),
                          border:
                              Border.all(color: context.appSeparator, width: 1),
                          boxShadow: context.appShadowSm,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                size: 15, color: AppTokens.accentDeep),
                            const SizedBox(width: 7),
                            Text(
                              DateFormat('dd.MM.yyyy').format(_selectedDate),
                              style: TextStyle(
                                  color: context.appFg,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Slot segmented picker
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SlotSegmented(
                  selected: _selectedSlot,
                  onChanged: (s) => setState(() => _selectedSlot = s),
                  l: l,
                ),
              ),
              const SizedBox(height: 16),

              // Locked recipe → confirm button; else → searchable recipe list
              if (hasLockedRecipe)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GradientButton(
                    label: l.confirmMeal,
                    icon: Icons.check_circle_rounded,
                    onTap: _submitting
                        ? null
                        : () => _add(recipeId: widget.defaultRecipeId),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      // Search field + Würfel-Button (3 zufällige Vorschläge)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchCtrl,
                                style: TextStyle(color: context.appFg),
                                onChanged: (v) => setState(() {
                                  _search = v;
                                  // Tippen beendet den Würfelmodus wieder —
                                  // Suche und Würfel-Vorschläge sind exklusiv.
                                  _diceResults = null;
                                }),
                                decoration: InputDecoration(
                                  hintText: l.searchRecipes,
                                  hintStyle: TextStyle(color: context.appFgSub),
                                  prefixIcon: Icon(Icons.search,
                                      color: context.appFgSub),
                                  filled: true,
                                  fillColor: context.appCard,
                                  isDense: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            DiceButton(
                              onTap: recipesAsync.valueOrNull == null
                                  ? null
                                  : () => _rollDice(recipesAsync.valueOrNull!),
                              tooltip: l.diceModeButton,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _diceResults != null
                            ? _diceResultsView(
                                context, _diceResults!, l, baseUrl, token)
                            : recipesAsync.when(
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                                error: (e, _) => Center(
                                    child: Text(e.toString(),
                                        style: TextStyle(
                                            color: context.appFgSub))),
                                data: (recipes) => _recipeList(
                                    context, recipes, l, baseUrl, token),
                              ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recipeList(BuildContext context, List<RecipeDetail> recipes,
      AppLocalizations l, String baseUrl, String token) {
    final terms = searchTerms(_search);
    final filtered = recipes
        .where((r) => recipeMatchesSearch(r, terms, includeDescription: false))
        .toList();
    applyRecipeSort(filtered, _sort);

    return ListView(
      children: [
        ...filtered.map((recipe) => ListTile(
              leading: _SearchThumbnail(
                  recipe: recipe, baseUrl: baseUrl, token: token),
              title: Text(recipe.name, style: TextStyle(color: context.appFg)),
              trailing: Icon(Icons.add_circle,
                  color: Theme.of(context).colorScheme.primary),
              onTap: () => _add(recipeId: recipe.id),
            )),
        // Custom meal option when search has no exact matches
        if (_search.isNotEmpty && filtered.isEmpty)
          ListTile(
            title: Text('➕ ${l.addCustomMeal} "$_search"',
                style: TextStyle(color: context.appFg)),
            onTap: () => _add(title: _search),
          ),
      ],
    );
  }

  // Würfelmodus-Ergebnis: Titel + Neu-würfeln/Zurück-Aktionen, darunter die
  // 3 vorgeschlagenen Rezepte inkl. Bild. Auswahl plant die Mahlzeit direkt
  // ein (Datum/Slot sind oben bereits gewählt).
  Widget _diceResultsView(BuildContext context, List<RecipeDetail> results,
      AppLocalizations l, String baseUrl, String token) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l.diceModeTitle,
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: context.appFg,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ),
            // Kein separater „Neu würfeln"-Button — der Würfel-Button oben
            // neben der Suche funktioniert jederzeit erneut, ein zweiter
            // Button dafür wäre redundant.
            IconButton(
              tooltip: l.diceBackToSearch,
              icon: Icon(Icons.close_rounded, color: context.appFgSub),
              onPressed: _exitDiceMode,
            ),
          ],
        ),
        const SizedBox(height: 4),
        ...results.map((recipe) => DiceRecipeCard(
              recipe: recipe,
              baseUrl: baseUrl,
              token: token,
              onTap: () => _add(recipeId: recipe.id),
            )),
      ],
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }
}

// ---------------------------------------------------------------------------
// Slot segmented control — mirrors iOS segmented Picker (🍳/🥪/🍽)
// ---------------------------------------------------------------------------

class _SlotSegmented extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  final AppLocalizations l;

  const _SlotSegmented({
    required this.selected,
    required this.onChanged,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    final slots = [
      ('breakfast', '🍳 ${l.breakfast}'),
      ('lunch', '🥪 ${l.lunch}'),
      ('dinner', '🍽 ${l.dinner}'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.appSeparator, width: 1),
        boxShadow: context.appShadowSm,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: slots.map((s) {
          final isSelected = selected == s.$1;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(s.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: isSelected ? AppTokens.accentGradient : null,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? const [
                          BoxShadow(
                              color: Color(0x40FF7800),
                              blurRadius: 10,
                              offset: Offset(0, 3))
                        ]
                      : null,
                ),
                child: Text(s.$2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: isSelected ? Colors.white : context.appFgSub,
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Würfel-Button — löst 3 zufällige Rezeptvorschläge aus. Kein Swift-Original,
// reine App-eigene Funktion (analog zu RecipePdfService, siehe
// [[project-flutter-migration]]).
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Kleines Vorschaubild für die normale Suchliste — dieselbe Bild-URL/Auth-
// Konvention wie RecipeCard (recipe_list_screen) und _DiceRecipeCard oben,
// nur kompakter (ListTile-leading statt volle Karte), da hier potenziell
// sehr viele Treffer untereinander stehen.
// ---------------------------------------------------------------------------

class _SearchThumbnail extends StatelessWidget {
  final RecipeDetail recipe;
  final String baseUrl;
  final String token;

  const _SearchThumbnail({
    required this.recipe,
    required this.baseUrl,
    required this.token,
  });

  String get _imageUrl =>
      '$baseUrl/api/media/recipes/${recipe.id}/images/original.webp';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 48,
        height: 48,
        child: RecipeImage(
          recipeId: recipe.id,
          imageUrl: _imageUrl,
          httpHeaders: {'Authorization': 'Bearer $token'},
          placeholder: _placeholder,
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) => Container(
        color: context.appSurface2,
        child: Icon(Icons.restaurant_rounded,
            size: 18, color: context.appFgTertiary),
      );
}
