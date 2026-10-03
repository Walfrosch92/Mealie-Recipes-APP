import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../cooking_mode/widgets/cooking_mode_fab.dart';

import '../../../core/api/api_service.dart';
import '../../../core/utils/platform_features.dart';
import '../../../core/models/mealplan_entry.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/liquid_glass.dart';
import '../../../shared/widgets/recipe_image.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../../shopping_list/providers/shopping_list_provider.dart';
import '../providers/mealplan_provider.dart';
import 'add_meal_entry_screen.dart';
import '../widgets/meal_dice_settings_sheet.dart';

// ---------------------------------------------------------------------------
// Meal Plan — mirrors iOS MealplanView 1:1
// ---------------------------------------------------------------------------

class MealplanScreen extends ConsumerStatefulWidget {
  const MealplanScreen({super.key});

  @override
  ConsumerState<MealplanScreen> createState() => _MealplanScreenState();
}

class _MealplanScreenState extends ConsumerState<MealplanScreen> {
  // Mehrfachauswahl-Modus: mehrere geplante Rezepte markieren und deren
  // Zutaten in EINEM Rutsch auf die Einkaufsliste setzen. Rein UI-lokaler
  // Zustand (kein Provider nötig) — verschwindet beim Verlassen des Screens,
  // genau wie die Suche im Add-Meal-Screen.
  bool _selectMode = false;
  final Set<String> _selectedIds = {};
  bool _addingIngredients = false;

  void _toggleSelectMode() {
    setState(() {
      _selectMode = !_selectMode;
      _selectedIds.clear();
    });
  }

  void _toggleEntrySelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<RecipeDetail?> _fetchDetailOrNull(ApiService api, String id) async {
    try {
      return await api.fetchRecipeDetail(id);
    } catch (_) {
      return null;
    }
  }

  // Summiert die Zutaten ALLER ausgewählten Rezepte und schiebt sie
  // nacheinander (bewusst SEQUENZIELL, nicht parallel) durch
  // ShoppingListNotifier.addIngredient — die Merge-Logik dort vergleicht
  // gegen den JEWEILS aktuellen Listen-Stand. Im Exakt-Modus addiert das
  // gleichnamige Zutaten mit gleicher Einheit automatisch über alle
  // Rezepte hinweg (150 g + 200 g → 350 g); im 1x-Modus verhindert dieselbe
  // Logik Duplikate rein über den Namen — unverändertes „so wie bisher".
  // Rezepte, die mehrfach in der Auswahl stehen (z. B. zweimal diese Woche
  // geplant), tragen ihre Zutaten dadurch korrekt DOPPELT bei.
  Future<void> _addSelectedIngredients() async {
    if (_addingIngredients) return;
    final l = AppLocalizations.of(context)!;
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings == null || settings.shoppingListId.isEmpty) return;

    final entries = ref
        .read(currentWeekEntriesProvider)
        .values
        .expand((list) => list)
        .where((e) => _selectedIds.contains(e.id) && e.recipe != null)
        .toList();
    if (entries.isEmpty) return;

    final cachedRecipes = ref.read(recipesProvider).valueOrNull ?? const [];
    final api = ref.read(apiServiceProvider);
    final notifier = ref.read(shoppingListProvider.notifier);

    setState(() => _addingIngredients = true);
    var failed = 0;
    // „Im Haushalt vorrätig" überspringen (Mealie-Web wählt sie ab).
    var skipped = 0;
    try {
      final onHand = await notifier.onHandChecker();
      bool skipIf(Ingredient ing) {
        final hit = onHand(ing);
        if (hit) skipped++;
        return hit;
      }

      for (final entry in entries) {
        final recipeId = entry.recipe!.id;
        RecipeDetail? detail;
        for (final r in cachedRecipes) {
          if (r.id == recipeId) {
            detail = r;
            break;
          }
        }
        detail ??= await _fetchDetailOrNull(api, recipeId);
        if (detail == null) {
          failed++;
          continue;
        }
        failed += await notifier.addRecipe(
          shoppingListId: settings.shoppingListId,
          recipe: detail,
          multiplier: 1,
          skipIf: skipIf,
        );
      }
      await notifier.refresh();
    } finally {
      if (mounted) setState(() => _addingIngredients = false);
    }
    if (!mounted) return;
    setState(() {
      _selectMode = false;
      _selectedIds.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failed > 0
            ? l.addIngredientsFailedCount(failed)
            : skipped > 0
                ? l.addIngredientsSkippedOnHand(skipped)
                : l.addIngredientsMessage),
        duration: Duration(seconds: skipped > 0 ? 3 : 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final weekStart = ref.watch(currentWeekStartProvider);
    final planAsync = ref.watch(mealplanProvider);
    final weekEntries = ref.watch(currentWeekEntriesProvider);
    final isCurrentWeek = startOfWeek(DateTime.now()) == startOfDay(weekStart);
    final hasSelectableEntries =
        weekEntries.values.expand((list) => list).any((e) => e.recipe != null);

    return Scaffold(
      backgroundColor: context.appBg,
      extendBody: true,
      appBar: AppBar(
        title: Text(_selectMode
            ? l.mealplanSelectedCount(_selectedIds.length)
            : l.mealplanTitle),
        actions: _selectMode
            ? [
                TextButton(
                  onPressed: _toggleSelectMode,
                  child: Text(l.cancel),
                ),
              ]
            : [
                // "Heute" — only when not on current week
                if (!isCurrentWeek)
                  TextButton(
                    onPressed: () => ref
                        .read(currentWeekStartProvider.notifier)
                        .state = startOfWeek(DateTime.now()),
                    child: Text(l.today),
                  ),
                // Mehrfachauswahl an
                if (hasSelectableEntries)
                  IconButton(
                    icon: const Icon(Icons.playlist_add_check_rounded),
                    tooltip: l.mealplanSelectMode,
                    onPressed: _toggleSelectMode,
                  ),
                // Calendar date picker
                IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  onPressed: () => _pickDate(context, ref, weekStart),
                ),
                // Würfel-Filter: Kategorien/Schlagworte pro Mahlzeit
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: l.mealDiceSettingsTitle,
                  onPressed: () => showMealDiceSettingsSheet(context),
                ),
                // Add meal
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 26),
                  onPressed: () => _openAddMeal(context, ref),
                ),
              ],
      ),
      body: WithCookingModeFAB(
        bottomInset: GlassTabBar.height + 24,
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              Column(
                children: [
                  // ── Calendar header ──────────────────────────────────
                  _CalendarHeader(
                    weekStart: weekStart,
                    isCurrentWeek: isCurrentWeek,
                    weekEntries: weekEntries,
                    onPrev: () =>
                        ref.read(currentWeekStartProvider.notifier).state =
                            startOfWeek(
                                weekStart.subtract(const Duration(days: 7))),
                    onNext: () =>
                        ref.read(currentWeekStartProvider.notifier).state =
                            startOfWeek(weekStart.add(const Duration(days: 7))),
                  ),

                  // ── Body ─────────────────────────────────────────────
                  Expanded(
                    child: planAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(
                          child: Text(e.toString(),
                              style: TextStyle(color: context.appFgSub))),
                      data: (_) {
                        if (weekEntries.isEmpty) {
                          return _EmptyState(
                              onAdd: () => _openAddMeal(context, ref));
                        }
                        final sortedDays = weekEntries.keys.toList()..sort();
                        final bottomReserve = GlassTabBar.height +
                            24 +
                            (_selectMode && _selectedIds.isNotEmpty ? 76 : 0);
                        return RefreshIndicator(
                          onRefresh: () =>
                              ref.read(mealplanProvider.notifier).refresh(),
                          child: ListView(
                            // Große Anzeige (Windows/macOS): zentrierte Spalte.
                            padding: EdgeInsets.fromLTRB(
                                LargeScreen.inset(context, base: 16),
                                16,
                                LargeScreen.inset(context, base: 16),
                                bottomReserve),
                            children: sortedDays
                                .map((day) => _DaySection(
                                      date: day,
                                      entries: weekEntries[day]!,
                                      selectMode: _selectMode,
                                      selectedIds: _selectedIds,
                                      onToggleSelect: _toggleEntrySelection,
                                    ))
                                .toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              // Sticky Aktion: „Alle Zutaten hinzufügen" für die Auswahl.
              if (_selectMode && _selectedIds.isNotEmpty)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: GlassTabBar.height + 12,
                  child: SafeArea(
                    top: false,
                    child: GradientButton(
                      label: l.addAllIngredients,
                      icon: Icons.shopping_cart_rounded,
                      busy: _addingIngredients,
                      onTap:
                          _addingIngredients ? null : _addSelectedIngredients,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(
      BuildContext context, WidgetRef ref, DateTime current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      ref.read(currentWeekStartProvider.notifier).state = startOfWeek(picked);
    }
  }

  void _openAddMeal(BuildContext context, WidgetRef ref) {
    // rootNavigator: sonst landet die Seite im Tab-Branch-Navigator und
    // liegt hinter der fixen GlassTabBar.
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const AddMealEntryScreen(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Calendar header — mirrors iOS calendarHeader + weekDayIndicators
// ---------------------------------------------------------------------------

class _CalendarHeader extends ConsumerWidget {
  final DateTime weekStart;
  final bool isCurrentWeek;
  final Map<DateTime, List<MealplanEntry>> weekEntries;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _CalendarHeader({
    required this.weekStart,
    required this.isCurrentWeek,
    required this.weekEntries,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final lang =
        ref.watch(settingsProvider).valueOrNull?.selectedLanguage ?? 'de';
    final accent = Theme.of(context).colorScheme.primary;
    final weekEnd = weekStart.add(const Duration(days: 6));
    final df = DateFormat('dd.MM');
    final headerText =
        '${l.weekAbbreviation} ${isoWeekNumber(weekStart)} (${df.format(weekStart)} – ${df.format(weekEnd)})';

    return Container(
      color: context.appBg,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              _NavCircle(icon: Icons.chevron_left_rounded, onTap: onPrev),
              Expanded(
                child: Column(
                  children: [
                    Text(headerText,
                        style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: context.appFg,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2)),
                    if (isCurrentWeek)
                      Text(l.currentWeek,
                          style: TextStyle(
                              color: accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              _NavCircle(icon: Icons.chevron_right_rounded, onTap: onNext),
              const SizedBox(width: 16),
            ],
          ),
          // Week day indicators (only if entries this week)
          if (weekEntries.isNotEmpty) ...[
            const SizedBox(height: 6),
            _WeekDayIndicators(
              weekStart: weekStart,
              weekEntries: weekEntries,
              lang: lang,
            ),
          ],
        ],
      ),
    );
  }
}

class _NavCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavCircle({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.appCard,
          border: Border.all(color: context.appSeparator, width: 1),
          boxShadow: context.appShadowSm,
        ),
        child: Icon(icon, color: AppTokens.accentDeep, size: 24),
      ),
    );
  }
}

class _WeekDayIndicators extends StatelessWidget {
  final DateTime weekStart;
  final Map<DateTime, List<MealplanEntry>> weekEntries;
  final String lang;

  const _WeekDayIndicators({
    required this.weekStart,
    required this.weekEntries,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final letterFmt = DateFormat('EEEEE', lang); // single-letter weekday
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: List.generate(7, (i) {
          final date = weekStart.add(Duration(days: i));
          final hasEntries = weekEntries.containsKey(startOfDay(date));
          final isToday = startOfDay(date) == startOfDay(now);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  Text(letterFmt.format(date).toUpperCase(),
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                          color: isToday ? accent : context.appFgSub)),
                  const SizedBox(height: 2),
                  Text('${date.day}',
                      style: TextStyle(
                          fontSize: 10,
                          color: isToday ? accent : context.appFgSub)),
                  const SizedBox(height: 3),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasEntries ? accent : Colors.transparent,
                      border: Border.all(
                          color: isToday ? accent : Colors.transparent,
                          width: 1),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state — mirrors iOS emptyStateView + available weeks
// ---------------------------------------------------------------------------

class _EmptyState extends ConsumerWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final otherWeeks = ref.watch(otherWeeksProvider);

    // Bottom-Reserve wie bei der befüllten Liste (siehe MealplanScreen) —
    // die GlassTabBar schwebt ÜBER dem Content statt ihn zu verdrängen.
    // Ohne Reserve landete der „Mahlzeit planen"-Button je nach Höhe des
    // Contents (z. B. mit/ohne „andere Wochen"-Karte) mal genau unter der
    // Bar — dort ohne weiteren Scroll-Spielraum unerreichbar/nicht tippbar.
    return ListView(
      padding: EdgeInsets.fromLTRB(LargeScreen.inset(context, base: 16), 16,
          LargeScreen.inset(context, base: 16), GlassTabBar.height + 24),
      children: [
        const SizedBox(height: 40),
        Center(
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTokens.accentGradient,
              boxShadow: context.appAccentGlow,
            ),
            child:
                const Icon(Icons.event_rounded, size: 44, color: Colors.white),
          ),
        ),
        const SizedBox(height: 18),
        Text(l.noMealsThisWeek,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: context.appFg,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3)),
        const SizedBox(height: 20),

        // Other weeks with entries
        if (otherWeeks.isNotEmpty) ...[
          PremiumCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppTokens.accentDeep, size: 16),
                    const SizedBox(width: 6),
                    Text(l.entriesInOtherWeeks,
                        style: TextStyle(
                            color: context.appFg,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(l.availableWeeks,
                    style: TextStyle(color: context.appFgSub, fontSize: 12)),
                const SizedBox(height: 10),
                ...otherWeeks.map((w) => _WeekButton(info: w)),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 8),
        GradientButton(
          label: l.planMeal,
          icon: Icons.add_rounded,
          onTap: onAdd,
        ),
      ],
    );
  }
}

class _WeekButton extends ConsumerWidget {
  final WeekInfo info;
  const _WeekButton({required this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final df = DateFormat('dd.MM');
    final weekEnd = info.weekStart.add(const Duration(days: 6));
    final entriesText = info.count == 1 ? l.entrySingular : l.entriesPlural;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () =>
            ref.read(currentWeekStartProvider.notifier).state = info.weekStart,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(AppTokens.rSm),
          ),
          child: Row(
            children: [
              Text('${l.weekAbbreviation} ${isoWeekNumber(info.weekStart)}',
                  style: TextStyle(
                      color: context.appFg, fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              Text('(${df.format(info.weekStart)} – ${df.format(weekEnd)})',
                  style: TextStyle(color: context.appFgSub, fontSize: 12)),
              const Spacer(),
              Text('${info.count} $entriesText',
                  style: TextStyle(color: context.appFgSub, fontSize: 12)),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: context.appFgSub, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Day section — mirrors iOS daySection
// ---------------------------------------------------------------------------

class _DaySection extends ConsumerWidget {
  final DateTime date;
  final List<MealplanEntry> entries;
  final bool selectMode;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleSelect;

  const _DaySection({
    required this.date,
    required this.entries,
    required this.selectMode,
    required this.selectedIds,
    required this.onToggleSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final lang =
        ref.watch(settingsProvider).valueOrNull?.selectedLanguage ?? 'de';
    final isToday = startOfDay(date) == startOfDay(DateTime.now());
    final dateFmt = DateFormat('EEEE, d. MMMM yyyy', lang);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(dateFmt.format(date),
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: context.appFg,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3)),
              ),
              if (isToday)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: AppTokens.accentGradient,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: context.appAccentGlow,
                  ),
                  child: Text(l.today,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...entries.map((e) => _MealEntryCard(
                entry: e,
                selectMode: selectMode,
                selected: selectedIds.contains(e.id),
                onToggleSelect: onToggleSelect,
              )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Meal entry card — mirrors iOS mealEntryCard
// ---------------------------------------------------------------------------

class _MealEntryCard extends ConsumerWidget {
  final MealplanEntry entry;
  final bool selectMode;
  final bool selected;
  final ValueChanged<String>? onToggleSelect;

  const _MealEntryCard({
    required this.entry,
    this.selectMode = false,
    this.selected = false,
    this.onToggleSelect,
  });

  String _slotEmoji(String slot) {
    switch (slot.toLowerCase()) {
      case 'breakfast':
        return '🍳';
      case 'lunch':
        return '🥪';
      case 'dinner':
        return '🍽';
      default:
        return '🍴';
    }
  }

  String _slotName(String slot, AppLocalizations l) {
    switch (slot.toLowerCase()) {
      case 'breakfast':
        return l.breakfast;
      case 'lunch':
        return l.lunch;
      case 'dinner':
        return l.dinner;
      default:
        return slot;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final accent = Theme.of(context).colorScheme.primary;
    final selectable = selectMode && entry.recipe != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: selectable ? () => onToggleSelect?.call(entry.id) : null,
        child: PremiumCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Rezeptbild wie in der Rezeptliste (Offline-Kopie bevorzugt);
              // ohne Bild, bei Ladefehler und bei Notiz-Einträgen der bisherige
              // Kreis mit dem Mahlzeiten-Emoji.
              _leading(context, ref, accent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_slotName(entry.entryType, l).toUpperCase(),
                        style: const TextStyle(
                            color: AppTokens.accentDeep,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3)),
                    const SizedBox(height: 3),
                    _entryTitle(context),
                  ],
                ),
              ),
              // Auswahlmodus: Häkchen für Rezept-Einträge statt Löschen (kein
              // Platz für beides, und Löschen mitten in der Auswahl wäre
              // ohnehin verwirrend). Freitext-Einträge bleiben unselektierbar
              // (keine Zutaten) und zeigen weiter ihr Löschen-Icon.
              if (selectable)
                _SelectionMark(selected: selected)
              else if (!selectMode)
                GestureDetector(
                  onTap: () =>
                      ref.read(mealplanProvider.notifier).deleteEntry(entry.id),
                  child: Icon(Icons.cancel_rounded,
                      color: context.appFgTertiary, size: 24),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slotBadge(Color accent) => Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accent.withValues(alpha: 0.12),
        ),
        child: Center(
          child: Text(_slotEmoji(entry.entryType),
              style: const TextStyle(fontSize: 22)),
        ),
      );

  Widget _leading(BuildContext context, WidgetRef ref, Color accent) {
    final recipe = entry.recipe;
    final settings = ref.watch(settingsProvider).valueOrNull;
    final showImages = settings?.showRecipeImages ?? true;
    final hasImage = recipe != null && (recipe.image?.isNotEmpty ?? false);
    if (!showImages || !hasImage) return _slotBadge(accent);
    final serverUrl = settings?.serverUrl ?? '';
    final token = settings?.apiToken ?? '';
    final image = ClipOval(
      child: SizedBox(
        width: 50,
        height: 50,
        child: RecipeImage(
          recipeId: recipe.id,
          imageUrl:
              '$serverUrl/api/media/recipes/${recipe.id}/images/original.webp',
          httpHeaders: {'Authorization': 'Bearer $token'},
          width: 50,
          height: 50,
          placeholder: (_) => _slotBadge(accent),
        ),
      ),
    );
    // Wie der Titel: Tippen öffnet das Rezept (nicht im Auswahlmodus).
    return GestureDetector(
      onTap: selectMode ? null : () => context.push('/recipes/${recipe.id}'),
      child: image,
    );
  }

  Widget _entryTitle(BuildContext context) {
    if (entry.recipe != null) {
      return GestureDetector(
        onTap: selectMode
            ? null
            : () => context.push('/recipes/${entry.recipe!.id}'),
        child: Text(entry.recipe!.name,
            style: TextStyle(
                color: context.appFg,
                fontSize: 16,
                fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis),
      );
    }
    final freeText = entry.title ?? entry.text;
    if (freeText != null) {
      return Row(
        children: [
          Icon(Icons.format_quote_rounded, size: 13, color: context.appFgSub),
          const SizedBox(width: 4),
          Expanded(
            child: Text(freeText,
                style: TextStyle(
                    color: context.appFg,
                    fontSize: 16,
                    fontStyle: FontStyle.italic),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      );
    }
    return Text('—', style: TextStyle(color: context.appFgSub));
  }
}

// ---------------------------------------------------------------------------
// Auswahl-Häkchen — mirrors die Checkbox-Optik der Mehrfachauswahl (kein
// Swift-Original, reine App-eigene Funktion für den Mehrfach-Zutaten-Import).
// ---------------------------------------------------------------------------

class _SelectionMark extends StatelessWidget {
  final bool selected;
  const _SelectionMark({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: selected ? AppTokens.accentGradient : null,
        border: Border.all(
          color: selected ? Colors.transparent : context.appSeparator,
          width: 1.5,
        ),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
          : null,
    );
  }
}
