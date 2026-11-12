import 'dart:async';

import 'package:flutter/material.dart';
import '../../../shared/widgets/shimmer.dart';
import '../../../shared/widgets/swipe_context_menu.dart';
import '../../../shared/widgets/tap_area.dart';
import '../../../shared/widgets/app_search_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
import '../../recipe_match/screens/recipe_match_shopping_screen.dart';
import '../providers/mealplan_provider.dart';
import 'add_meal_entry_screen.dart';
import '../widgets/meal_dice_settings_sheet.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../core/utils/meal_types.dart';
import '../../../core/utils/ingredient_display.dart' show formatQuantity;
import '../../../core/utils/mealie_version.dart';
import '../widgets/meal_type_chip_row.dart';
import '../../../shared/widgets/tap_surface.dart';
import '../../timeline/providers/cooked_marks_provider.dart';
import '../../recipe_match/screens/recipe_match_screen.dart'
    show RecipeMatchThumb;
import '../../../core/utils/search_match.dart';
import '../../../core/desktop/two_pane.dart';
import '../../../core/desktop/print_service.dart';

// ---------------------------------------------------------------------------
// Meal Plan — mirrors iOS MealplanView 1:1
// ---------------------------------------------------------------------------

class MealplanScreen extends ConsumerStatefulWidget {
  const MealplanScreen({super.key});

  @override
  ConsumerState<MealplanScreen> createState() => _MealplanScreenState();
}

class _MealplanScreenState extends ConsumerState<MealplanScreen> {
  /// Wochen, für die „Woche fast leer" weggeklickt wurde (nur diese Sitzung).
  static final Set<DateTime> _planHintDismissed = {};

  String _isoDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _openWeekPlanner(DateTime weekStart) =>
      context.push('/week-planner?start=${_isoDate(weekStart)}');

  // ── Verschieben per Halten & Ziehen ────────────────────────────────────
  // Eine Mahlzeit lange drücken und auf einen anderen Tag der Woche ziehen
  // (auch auf leere, grau dargestellte Tage). Es wird EINZELN verschoben,
  // nicht getauscht (anders als in „Woche planen"). Am oberen/unteren Rand
  // scrollt die Liste mit, solange gezogen wird.
  final _listController = ScrollController();
  final _listKey = GlobalKey();

  // Aktuelle Woche: beim Öffnen bzw. Wochenwechsel zum heutigen Tag
  // scrollen — seit alle 7 Tage angezeigt werden, stand sonst immer der
  // Montag oben. Je Woche nur einmal (danach scrollt der Nutzer selbst).
  final _todayKey = GlobalKey();
  DateTime? _scrolledToTodayWeek;

  void _scrollToTodayOnce(DateTime weekStart, bool isCurrentWeek) {
    final week = startOfDay(weekStart);
    if (!isCurrentWeek || _scrolledToTodayWeek == week) return;
    _scrolledToTodayWeek = week;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _todayKey.currentContext;
      if (!mounted || ctx == null) return;
      Scrollable.ensureVisible(ctx,
          alignment: 0.0, duration: const Duration(milliseconds: 250));
    });
  }

  Timer? _autoScroll;
  Offset? _dragPos;
  bool _dragging = false;

  @override
  void dispose() {
    _autoScroll?.cancel();
    _listController.dispose();
    super.dispose();
  }

  /// Woche beim Start des Ziehens — bei Abbruch springt die Ansicht dorthin
  /// zurück (falls unterwegs über die Pfeile geblättert wurde).
  DateTime? _dragStartWeek;

  void _onDragStarted() {
    _dragStartWeek = ref.read(currentWeekStartProvider);
    setState(() => _dragging = true);
    _autoScroll?.cancel();
    _autoScroll = Timer.periodic(
        const Duration(milliseconds: 16), (_) => _tickAutoScroll());
  }

  void _onDragUpdate(DragUpdateDetails d) => _dragPos = d.globalPosition;

  /// [accepted] = auf einem (anderen) Tag abgelegt. Alles andere — neben
  /// den Tagen, auf dem eigenen Tag oder auf einem Wochenpfeil loslassen —
  /// ist ein Abbruch: nichts wird verschoben, die Ausgangswoche kommt zurück.
  void _onDragEnded(bool accepted) {
    _autoScroll?.cancel();
    _autoScroll = null;
    _dragPos = null;
    final start = _dragStartWeek;
    _dragStartWeek = null;
    if (!mounted) return;
    if (!accepted && start != null) {
      ref.read(currentWeekStartProvider.notifier).state = start;
    }
    setState(() => _dragging = false);
  }

  void _tickAutoScroll() {
    final pos = _dragPos;
    final box = _listKey.currentContext?.findRenderObject() as RenderBox?;
    if (pos == null || box == null || !_listController.hasClients) return;
    final top = box.localToGlobal(Offset.zero).dy;
    // Unten liegt die schwebende Tab-Leiste über der Liste.
    final bottom = top + box.size.height - GlassTabBar.heightOf(context) - 24;
    const edge = 80.0;
    double delta = 0;
    if (pos.dy < top + edge) {
      delta = -14 * ((top + edge - pos.dy) / edge).clamp(0.0, 1.0);
    } else if (pos.dy > bottom - edge) {
      delta = 14 * ((pos.dy - (bottom - edge)) / edge).clamp(0.0, 1.0);
    }
    if (delta == 0) return;
    final p = _listController.position;
    final next = (p.pixels + delta).clamp(p.minScrollExtent, p.maxScrollExtent);
    if (next != p.pixels) _listController.jumpTo(next);
  }

  Future<void> _dropOnDay(MealplanEntry entry, DateTime day) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final notifier = ref.read(mealplanProvider.notifier);
    final lang =
        ref.read(settingsProvider).valueOrNull?.selectedLanguage ?? 'de';
    final target = _isoDate(day);
    if (target == entry.date && !entry.isWeekEntry) return;
    try {
      // Ein Wochen-Eintrag, der auf einen Tag gezogen wird, gilt danach nur
      // noch für diesen Tag (wie in der Mealie-Webapp).
      await notifier.moveEntry(entry,
          date: target,
          entryType: entry.entryType,
          week: entry.isWeekEntry ? false : null);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
              l.mealplanMovedTo(DateFormat('EEEE, d. MMMM', lang).format(day))),
          persist: false,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: l.undo,
            onPressed: () async {
              // Aktuellen Stand des Eintrags (nach dem Verschieben) holen.
              final moved = [
                for (final list
                    in ref.read(mealplanProvider).valueOrNull?.values ??
                        const <List<MealplanEntry>>[])
                  ...list,
                ...notifier.weekEntries,
              ].where((e) => e.id == entry.id).firstOrNull;
              if (moved == null) return;
              try {
                await notifier.moveEntry(moved,
                    date: entry.date,
                    entryType: entry.entryType,
                    week: entry.isWeekEntry);
              } catch (_) {}
            },
          ),
        ));
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(userErrorMessage(e, l.mealplanMoveFailed))));
    }
  }

  /// Tageseintrag aufs Wochen-Band ziehen → Eintrag für die ganze Woche
  /// (Mealie ≥ 3.30), bzw. Wochen-Eintrag in eine andere Woche.
  Future<void> _dropOnWeek(MealplanEntry entry, DateTime weekStart) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final notifier = ref.read(mealplanProvider.notifier);
    final target = _isoDate(weekStart);
    if (entry.isWeekEntry && entry.date == target) return;
    try {
      await notifier.moveEntry(entry,
          date: target, entryType: entry.entryType, week: true);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(l.mealplanMovedToWholeWeek),
          persist: false,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: l.undo,
            onPressed: () async {
              final moved = notifier.weekEntries
                  .where((e) => e.id == entry.id)
                  .firstOrNull;
              if (moved == null) return;
              try {
                await notifier.moveEntry(moved,
                    date: entry.date,
                    entryType: entry.entryType,
                    week: entry.isWeekEntry);
              } catch (_) {}
            },
          ),
        ));
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(userErrorMessage(e, l.mealplanMoveFailed))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final weekStart = ref.watch(currentWeekStartProvider);
    final planAsync = ref.watch(mealplanProvider);
    final weekEntries = ref.watch(currentWeekEntriesProvider);
    // Mealie ≥ 3.30: Einträge für die ganze (angezeigte) Woche.
    final wholeWeek =
        weekEntriesFor(ref.watch(mealplanWeekEntriesProvider), weekStart);
    final v330 = ref.watch(mealie330Provider);
    final firstWeekday = ref.watch(weekStartWeekdayProvider);
    final isCurrentWeek =
        startOfWeek(DateTime.now(), firstWeekday) == startOfDay(weekStart);
    final hasSelectableEntries = weekEntries.values
            .expand((list) => list)
            .any((e) => e.recipe != null) ||
        wholeWeek.any((e) => e.recipe != null);

    return Scaffold(
      backgroundColor: context.appBg,
      extendBody: true,
      appBar: AppBar(
        title: Text(l.mealplanTitle),
        actions: [
          // "Heute" — only when not on current week
          if (!isCurrentWeek)
            TextButton(
              onPressed: () => ref
                  .read(currentWeekStartProvider.notifier)
                  .state = startOfWeek(DateTime.now(), firstWeekday),
              child: Text(l.today),
            ),
          // Woche planen (Assistent in drei Schritten)
          IconButton(
            tooltip: l.weekPlannerTitle,
            icon: const Icon(Icons.auto_fix_high_rounded),
            onPressed: () => _openWeekPlanner(weekStart),
          ),
          // Alles Weitere im ⋮-Menü (Platz für den Titel): Mahlzeit
          // hinzufügen, Zutaten der Woche, Datum wählen, Einstellungen.
          // Einzelne Tage plant man auch per Tipp auf „Nichts geplant".
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: context.appFg),
            color: context.appCard,
            onSelected: (v) {
              switch (v) {
                case 'add':
                  _openAddMeal(context, ref);
                case 'date':
                  _pickDate(context, ref, weekStart);
                case 'settings':
                  showMealDiceSettingsSheet(context);
                case 'weekShopping':
                  _openWeekShopping({
                    ...weekEntries,
                    // Eigener Schlüssel — der Wochenbeginn würde Montag überschreiben.
                    if (wholeWeek.isNotEmpty) DateTime(0): wholeWeek
                  });
                case 'print':
                  _printWeek(weekStart, weekEntries);
              }
            },
            itemBuilder: (_) => [
              _menuItem(context, 'add', Icons.add_circle_outline_rounded,
                  l.addMealEntry),
              if (hasSelectableEntries)
                _menuItem(context, 'weekShopping',
                    Icons.add_shopping_cart_rounded, l.mealplanWeekShopping),
              if (PlatformFeatures.webAppTools)
                _menuItem(
                    context, 'print', Icons.print_rounded, l.mealplanPrintWeek),
              _menuItem(
                  context, 'date', Icons.calendar_today_outlined, l.selectDate),
              _menuItem(context, 'settings', Icons.settings_outlined,
                  l.mealplanSettingsTitle),
            ],
          ),
        ],
      ),
      // Fingerposition fürs Rand-Scrollen beim Ziehen — über den ganzen
      // Bildschirm, weil Flutter onDragUpdate nicht mehr meldet, sobald die
      // gezogene Karte (z. B. nach einem Wochenwechsel) verschwunden ist.
      body: _withRecipePanel(
          context,
          Listener(
            onPointerMove: (e) {
              if (_dragging) _dragPos = e.position;
            },
            child: WithCookingModeFAB(
              fullWidth: true,
              bottomInset: GlassTabBar.heightOf(context) + 24,
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
                          onPrev: () => ref
                                  .read(currentWeekStartProvider.notifier)
                                  .state =
                              startOfWeek(addDays(weekStart, -7), firstWeekday),
                          onNext: () => ref
                                  .read(currentWeekStartProvider.notifier)
                                  .state =
                              startOfWeek(addDays(weekStart, 7), firstWeekday),
                        ),

                        // ── „Woche fast leer" → Woche planen ────────────────
                        if (!_planHintDismissed.contains(startOfDay(weekStart)))
                          _PlanWeekHint(
                            weekStart: weekStart,
                            weekEntries: weekEntries,
                            onPlan: () => _openWeekPlanner(weekStart),
                            onDismiss: () => setState(() =>
                                _planHintDismissed.add(startOfDay(weekStart))),
                          ),

                        // ── Body ─────────────────────────────────────────────
                        Expanded(
                          child: planAsync.when(
                            loading: () => const ListSkeleton(
                                rows: 6,
                                thumbSize: 64,
                                thumbRadius: AppTokens.rMd,
                                spacing: 18),
                            error: (e, _) => ErrorRetryView(
                              error: e,
                              onRetry: () =>
                                  ref.read(mealplanProvider.notifier).refresh(),
                            ),
                            data: (_) {
                              // Auch eine leere Woche zeigt ihre 7 (grauen) Tage — Antippen
                              // plant dort eine Mahlzeit (statt der früheren Leer-Ansicht).
                              // Alle 7 Tage der Woche: leere grau, aber als Ziel
                              // zum Verschieben nutzbar.
                              final days = [
                                for (var i = 0; i < 7; i++)
                                  addDays(startOfDay(weekStart), i),
                              ];
                              final bottomReserve =
                                  GlassTabBar.heightOf(context) + 24;
                              final today = startOfDay(DateTime.now());
                              _scrollToTodayOnce(weekStart, isCurrentWeek);
                              Widget keyed(DateTime day, Widget child) => day ==
                                      today
                                  ? KeyedSubtree(key: _todayKey, child: child)
                                  : child;
                              return RefreshIndicator(
                                onRefresh: () => ref
                                    .read(mealplanProvider.notifier)
                                    .refresh(),
                                child: ListView(
                                  key: _listKey,
                                  controller: _listController,
                                  // Große Anzeige (Windows/macOS): zentrierte Spalte.
                                  padding: EdgeInsets.fromLTRB(
                                      LargeScreen.inset(context, base: 16),
                                      16,
                                      LargeScreen.inset(context, base: 16),
                                      bottomReserve),
                                  children: [
                                    if (weekEntries.isEmpty &&
                                        wholeWeek.isEmpty &&
                                        !_dragging)
                                      const _OtherWeeksCard(),
                                    // Band „Für die ganze Woche“ — beim Ziehen auch leer
                                    // sichtbar (Ablageziel).
                                    if (wholeWeek.isNotEmpty ||
                                        (_dragging && v330))
                                      _WholeWeekSection(
                                        weekStart: weekStart,
                                        entries: wholeWeek,
                                        onDrop: (e) =>
                                            _dropOnWeek(e, weekStart),
                                        onDragStarted: _onDragStarted,
                                        onDragUpdate: _onDragUpdate,
                                        onDragEnded: _onDragEnded,
                                      ),
                                    for (final day in days)
                                      keyed(
                                          day,
                                          (weekEntries[day] ?? const []).isEmpty
                                              ? _EmptyDaySection(
                                                  date: day,
                                                  dragging: _dragging,
                                                  onDrop: (e) =>
                                                      _dropOnDay(e, day),
                                                  onAdd: () => _openAddMeal(
                                                      context, ref,
                                                      date: day),
                                                )
                                              : _DaySection(
                                                  date: day,
                                                  entries: weekEntries[day]!,
                                                  onDrop: (e) =>
                                                      _dropOnDay(e, day),
                                                  onDragStarted: _onDragStarted,
                                                  onDragUpdate: _onDragUpdate,
                                                  onDragEnded: _onDragEnded,
                                                )),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  /// Desktop (Fenster ≥ 1100 px): rechts eine Rezeptliste zum Hineinziehen.
  /// Der Ablage-Handler gilt immer (Tage fragen ihn über _RecipeDropScope).
  Widget _withRecipePanel(BuildContext context, Widget body) {
    final content = !twoPaneAvailable(context)
        ? body
        : Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(child: body),
            VerticalDivider(width: 1, color: context.appSeparator),
            SizedBox(
              width: 340,
              child: Material(
                color: context.appBg,
                child: SafeArea(
                  left: false,
                  bottom: false,
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: GlassTabBar.heightOf(context)),
                    child: _RecipeSidePanel(
                      onDragStarted: _onDragStarted,
                      onDragEnded: _onDragEnded,
                    ),
                  ),
                ),
              ),
            ),
          ]);
    return _RecipeDropScope(onDrop: _dropRecipe, child: content);
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
      ref.read(currentWeekStartProvider.notifier).state =
          startOfWeek(picked, ref.read(weekStartWeekdayProvider));
    }
  }

  /// Alle Rezepte der angezeigten Woche → Zutaten-Auswahl (wie bei
  /// Rezept-Match: einzeln abwählbar, vorrätige schon abgewählt). Mehrfach
  /// geplante Rezepte erscheinen einmal, ihre Portionen werden addiert
  /// (Mealie ≥ 3.29: geplante Portionen je Eintrag, sonst 1).
  Future<void> _openWeekShopping(
      Map<DateTime, List<MealplanEntry>> weekEntries) async {
    final cached = {
      for (final r in ref.read(recipesProvider).valueOrNull ?? const []) r.id: r
    };
    final api = ref.read(apiServiceProvider);
    final recipes = <RecipeDetail>[];
    final scales = <String, double>{};
    for (final list in weekEntries.values) {
      for (final e in list) {
        final id = e.recipe?.id;
        if (id == null) continue;
        scales[id] = (scales[id] ?? 0) + (e.recipeScale ?? 1);
        if (recipes.any((r) => r.id == id)) continue;
        var r = cached[id];
        if (r == null) {
          try {
            r = await api.fetchRecipeDetail(id);
          } catch (_) {}
        }
        if (r != null) recipes.add(r);
      }
    }
    if (!mounted || recipes.isEmpty) return;
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (_) =>
            RecipeMatchShoppingScreen(recipes: recipes, scales: scales)));
  }

  /// Rezept aus der Desktop-Seitenleiste auf [day] abgelegt: Mahlzeit wählen
  /// (Menü an der Ablagestelle), dann eintragen — mit Rückgängig.
  Future<void> _dropRecipe(RecipeDetail recipe, DateTime day, Offset at) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final type = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
          Rect.fromLTWH(at.dx, at.dy, 1, 1), Offset.zero & overlay.size),
      items: [
        for (final t in kMealTypes)
          PopupMenuItem(
            value: t,
            child: Text('${mealTypeEmoji(t)}  ${mealTypeLabel(t, l)}'),
          ),
      ],
    );
    if (type == null || !mounted) return;
    try {
      final created = await ref
          .read(mealplanProvider.notifier)
          .addEntry(date: _isoDate(day), entryType: type, recipeId: recipe.id);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(l.recipeMatchMealsAdded(1)),
          persist: false,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: l.undo,
            onPressed: () => ref
                .read(mealplanProvider.notifier)
                .deleteEntry(created.id)
                .catchError((_) {}),
          ),
        ));
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(userErrorMessage(e, l.saveFailed))));
    }
  }

  /// Desktop: angezeigte Woche als Aushang drucken.
  void _printWeek(
      DateTime weekStart, Map<DateTime, List<MealplanEntry>> weekEntries) {
    final l = AppLocalizations.of(context)!;
    final lang =
        ref.read(settingsProvider).valueOrNull?.selectedLanguage ?? 'de';
    final dayFmt = DateFormat('EEEE, d. MMM', lang);
    final days = [
      for (var i = 0; i < 7; i++) addDays(startOfDay(weekStart), i),
    ];
    printWeekPlan(
      title: l.mealplanTitle.replaceFirst(RegExp(r'^\S+\s+'), ''),
      subtitle: '${DateFormat('d. MMM', lang).format(days.first)} – '
          '${DateFormat('d. MMM yyyy', lang).format(days.last)}',
      days: [
        for (final d in days) (dayFmt.format(d), weekEntries[d] ?? const []),
      ],
      mealLabel: (t) => mealTypeLabel(t, l),
      emptyLabel: l.mealplanDayEmpty,
    );
  }

  /// [date] = Tag vorauswählen (Tipp auf einen leeren Tag).
  void _openAddMeal(BuildContext context, WidgetRef ref, {DateTime? date}) {
    // rootNavigator: sonst landet die Seite im Tab-Branch-Navigator und
    // liegt hinter der fixen GlassTabBar.
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AddMealEntryScreen(defaultDate: date),
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
    final weekEnd = addDays(weekStart, 6);
    final df = DateFormat('dd.MM');
    final headerText =
        '${l.weekAbbreviation} ${isoWeekNumber(addDays(weekStart, 3))} (${df.format(weekStart)} – ${df.format(weekEnd)})';

    return Container(
      color: context.appBg,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              _WeekFlipTarget(
                  onFlip: onPrev,
                  child: (hovered) => _NavCircle(
                      icon: Icons.chevron_left_rounded,
                      onTap: onPrev,
                      highlighted: hovered)),
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
              _WeekFlipTarget(
                  onFlip: onNext,
                  child: (hovered) => _NavCircle(
                      icon: Icons.chevron_right_rounded,
                      onTap: onNext,
                      highlighted: hovered)),
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

  /// Eine gezogene Mahlzeit schwebt darüber → gleich Wochenwechsel.
  final bool highlighted;
  const _NavCircle(
      {required this.icon, required this.onTap, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return TapArea(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: highlighted ? 46 : 38,
        height: highlighted ? 46 : 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: highlighted ? AppTokens.accentGradient : null,
          color: highlighted ? null : context.appCard,
          border: highlighted
              ? null
              : Border.all(color: context.appSeparator, width: 1),
          boxShadow: highlighted ? context.appAccentGlow : context.appShadowSm,
        ),
        child: Icon(icon,
            color: highlighted ? Colors.white : AppTokens.accentDeep, size: 24),
      ),
    );
  }
}

/// Wochenpfeil als Ziel beim Verschieben: hält man eine gezogene Mahlzeit
/// darüber, blättert die Ansicht nach kurzer Zeit eine Woche weiter (und
/// solange man bleibt, weiter) — danach auf einem Tag ablegen. Loslassen
/// AUF dem Pfeil verschiebt nichts.
class _WeekFlipTarget extends StatefulWidget {
  final VoidCallback onFlip;
  final Widget Function(bool hovered) child;
  const _WeekFlipTarget({required this.onFlip, required this.child});

  @override
  State<_WeekFlipTarget> createState() => _WeekFlipTargetState();
}

class _WeekFlipTargetState extends State<_WeekFlipTarget> {
  Timer? _timer;

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _flip() {
    HapticFeedback.selectionClick();
    widget.onFlip();
    _timer = Timer(const Duration(milliseconds: 900), _flip);
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<Object>(
      // Nimmt nie an (false) → Loslassen auf dem Pfeil zählt als Abbruch.
      // Hervorgehoben wird trotzdem, solange etwas darüber schwebt.
      onWillAcceptWithDetails: (_) {
        _stop();
        _timer = Timer(const Duration(milliseconds: 600), _flip);
        return false;
      },
      onLeave: (_) => _stop(),
      builder: (ctx, candidates, rejected) => SizedBox(
        width: 48,
        height: 48,
        child: Center(
            child: widget.child(candidates.isNotEmpty || rejected.isNotEmpty)),
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
          final date = addDays(weekStart, i);
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

/// Karte über der Woche, wenn noch mindestens die Hälfte (≥ 3) der
/// verbleibenden Tage leer ist — führt zu „Woche planen".
PopupMenuItem<String> _menuItem(
        BuildContext context, String value, IconData icon, String label) =>
    PopupMenuItem<String>(
      value: value,
      child: Row(children: [
        Icon(icon, size: 20, color: context.appFgSub),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(color: context.appFg))),
      ]),
    );

class _PlanWeekHint extends StatelessWidget {
  final DateTime weekStart;
  final Map<DateTime, List<MealplanEntry>> weekEntries;
  final VoidCallback onPlan;
  final VoidCallback onDismiss;
  const _PlanWeekHint({
    required this.weekStart,
    required this.weekEntries,
    required this.onPlan,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final today = startOfDay(DateTime.now());
    final days = [
      for (var i = 0; i < 7; i++)
        if (!addDays(startOfDay(weekStart), i).isBefore(today))
          addDays(startOfDay(weekStart), i),
    ];
    final free = days
        .where((d) => (weekEntries[d] ?? const <MealplanEntry>[]).isEmpty)
        .length;
    if (days.length < 3 || free < 3 || free * 2 < days.length) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      // Ganze Karte antippbar; vorher stand ein Knopf in derselben Zeile —
      // auf schmalen Handys blieben dem Text nur ~50 px.
      child: TapSurface(
        onTap: onPlan,
        color: context.appCard,
        borderRadius: BorderRadius.circular(AppTokens.rLg),
        border: Border.all(color: context.appSeparator),
        padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTokens.rSm),
              gradient: AppTokens.accentGradient,
            ),
            child: const Icon(Icons.auto_fix_high_rounded,
                color: Colors.white, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.weekPlannerMostlyEmpty,
                    style: TextStyle(
                        color: context.appFg,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                Text(l.weekPlannerMostlyEmptySub(free, days.length),
                    style: TextStyle(
                        color: context.appFgSub, fontSize: 13, height: 1.3)),
                const SizedBox(height: 4),
                Text('${l.weekPlannerTitle} ›',
                    style: const TextStyle(
                        color: AppTokens.accentDeep,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          IconButton(
            tooltip: l.dismiss,
            icon: Icon(Icons.close_rounded,
                size: 18, color: context.appFgTertiary),
            onPressed: onDismiss,
          ),
        ]),
      ),
    );
  }
}

/// Leere Woche: ausklappbarer Hinweis auf Wochen mit Einträgen (Sprung per
/// Tipp). Steht über den grauen Tagen; ohne andere Einträge unsichtbar.
/// Eingeklappt nur eine Zeile; der Zustand gilt für die laufende Sitzung.
class _OtherWeeksCard extends ConsumerStatefulWidget {
  const _OtherWeeksCard();

  @override
  ConsumerState<_OtherWeeksCard> createState() => _OtherWeeksCardState();
}

class _OtherWeeksCardState extends ConsumerState<_OtherWeeksCard> {
  static bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final otherWeeks = ref.watch(otherWeeksProvider);
    if (otherWeeks.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: PremiumCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              button: true,
              expanded: _expanded,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppTokens.rLg),
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _expanded = !_expanded);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                  child: Row(children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppTokens.accentDeep, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                          '${l.entriesInOtherWeeks} (${otherWeeks.length})',
                          style: TextStyle(
                              color: context.appFg,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                    ),
                    Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: context.appFgSub),
                  ]),
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: !_expanded
                  ? const SizedBox(width: double.infinity)
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.availableWeeks,
                              style: TextStyle(
                                  color: context.appFgSub, fontSize: 12)),
                          const SizedBox(height: 10),
                          ...otherWeeks.map((w) => _WeekButton(info: w)),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
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
    final weekEnd = addDays(info.weekStart, 6);
    final entriesText = info.count == 1 ? l.entrySingular : l.entriesPlural;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TapArea(
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
              Text(
                  '${l.weekAbbreviation} ${isoWeekNumber(addDays(info.weekStart, 3))}',
                  style: TextStyle(
                      color: context.appFg, fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              Text('(${df.format(info.weekStart)} – ${df.format(weekEnd)})',
                  style: TextStyle(color: context.appFgSub, fontSize: 12)),
              const Spacer(),
              Text('${info.count} $entriesText',
                  style: TextStyle(color: context.appFgSub, fontSize: 12)),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded,
                  color: context.appFgSub, size: 16),
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

/// Mealie ≥ 3.30: Einträge, die für die ganze Woche gelten (z. B. „diese
/// Woche irgendwann Lasagne“) — als eigenes Band über den Tagen, wie in der
/// Webapp. Ablageziel: ein Tageseintrag hierher wird zum Wochen-Eintrag.
class _WholeWeekSection extends StatelessWidget {
  final DateTime weekStart;
  final List<MealplanEntry> entries;
  final ValueChanged<MealplanEntry> onDrop;
  final VoidCallback onDragStarted;
  final ValueChanged<DragUpdateDetails> onDragUpdate;
  final ValueChanged<bool> onDragEnded;

  const _WholeWeekSection({
    required this.weekStart,
    required this.entries,
    required this.onDrop,
    required this.onDragStarted,
    required this.onDragUpdate,
    required this.onDragEnded,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final start = startOfDay(weekStart);
    return DragTarget<MealplanEntry>(
      onWillAcceptWithDetails: (d) =>
          !d.data.isWeekEntry ||
          startOfDay(DateTime.tryParse(d.data.date) ?? start) != start,
      onAcceptWithDetails: (d) {
        HapticFeedback.mediumImpact();
        onDrop(d.data);
      },
      builder: (ctx, candidates, _) {
        final hovered = candidates.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 2),
          decoration: BoxDecoration(
            color: hovered
                ? AppTokens.accent.withValues(alpha: 0.12)
                : AppTokens.accent.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppTokens.rLg),
            border: Border.all(
                color: hovered
                    ? AppTokens.accent
                    : AppTokens.accent.withValues(alpha: 0.25),
                width: hovered ? 2 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                const Icon(Icons.date_range_rounded,
                    size: 18, color: AppTokens.accentDeep),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(l.mealplanWholeWeek,
                      style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: context.appFg,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2)),
                ),
              ]),
              const SizedBox(height: 10),
              if (entries.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(l.mealplanWholeWeekDropHint,
                      style: TextStyle(color: context.appFgSub, fontSize: 14)),
                ),
              for (final e in entries)
                _MealEntryCard(
                  entry: e,
                  onDragStarted: onDragStarted,
                  onDragUpdate: onDragUpdate,
                  onDragEnded: onDragEnded,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DaySection extends ConsumerWidget {
  final DateTime date;
  final List<MealplanEntry> entries;
  final ValueChanged<MealplanEntry> onDrop;
  final VoidCallback onDragStarted;
  final ValueChanged<DragUpdateDetails> onDragUpdate;
  final ValueChanged<bool> onDragEnded;

  const _DaySection({
    required this.date,
    required this.entries,
    required this.onDrop,
    required this.onDragStarted,
    required this.onDragUpdate,
    required this.onDragEnded,
  });

  /// Summe der Kalorien (pro Portion) aller Rezepte des Tages, deren
  /// Nährwerte hinterlegt und am Rezept eingeblendet sind. `partial` = nicht
  /// alle Rezepte haben Werte → „mindestens". `null` = keines hat Werte.
  ({String text, bool partial})? _dayKcal(WidgetRef ref) {
    final recipes = ref.watch(recipesProvider).valueOrNull ?? const [];
    final byId = {for (final r in recipes) r.id: r};
    var sum = 0.0;
    var known = 0;
    var withRecipe = 0;
    for (final e in entries) {
      final id = e.recipe?.id;
      if (id == null) continue;
      withRecipe++;
      final r = byId[id];
      if (r == null || !(r.settings?.showNutrition ?? true)) continue;
      final v = double.tryParse(
          (r.nutrition['calories'] ?? '').trim().replaceAll(',', '.'));
      if (v != null && v > 0) {
        sum += v;
        known++;
      }
    }
    if (known == 0) return null;
    final lang =
        ref.read(settingsProvider).valueOrNull?.selectedLanguage ?? 'de';
    return (
      text: NumberFormat.decimalPattern(lang).format(sum.round()),
      partial: known < withRecipe,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final lang =
        ref.watch(settingsProvider).valueOrNull?.selectedLanguage ?? 'de';
    final isToday = startOfDay(date) == startOfDay(DateTime.now());
    // Vergangene Tage treten zurück (graue Überschrift).
    final isPast = startOfDay(date).isBefore(startOfDay(DateTime.now()));
    final dateFmt = DateFormat('EEEE, d. MMMM yyyy', lang);
    final kcal = _dayKcal(ref);

    return _DayDropTarget(
      date: date,
      onDrop: onDrop,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(dateFmt.format(date),
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: isPast ? context.appFgTertiary : context.appFg,
                        fontSize: 20,
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
          // Kalorien des Tages (Summe pro Portion), wo Rezepte Nährwerte haben.
          if (kcal != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(children: [
                const Icon(Icons.local_fire_department_rounded,
                    size: 14, color: AppTokens.accentDeep),
                const SizedBox(width: 4),
                Text(
                    kcal.partial
                        ? l.mealplanDayKcalPartial(kcal.text)
                        : l.mealplanDayKcal(kcal.text),
                    style: TextStyle(color: context.appFgSub, fontSize: 13)),
              ]),
            ),
          const SizedBox(height: 12),
          ...entries.map((e) => _MealEntryCard(
                entry: e,
                onDragStarted: onDragStarted,
                onDragUpdate: onDragUpdate,
                onDragEnded: onDragEnded,
              )),
        ],
      ),
    );
  }
}

/// Ablageziel für einen ganzen Tag: leuchtet orange, solange eine Mahlzeit
/// eines ANDEREN Tages darüber gehalten wird.
class _DayDropTarget extends StatelessWidget {
  final DateTime date;
  final ValueChanged<MealplanEntry> onDrop;
  final Widget child;
  const _DayDropTarget(
      {required this.date, required this.onDrop, required this.child});

  bool _otherDay(MealplanEntry e) {
    if (e.isWeekEntry) return true; // Wochen- → Tageseintrag
    final d = DateTime.tryParse(e.date);
    return d == null || startOfDay(d) != startOfDay(date);
  }

  @override
  Widget build(BuildContext context) {
    // Desktop-Seitenleiste: Rezept auf einen Tag ziehen → einplanen.
    final recipeDrop = _RecipeDropScope.maybeOf(context);
    return DragTarget<RecipeDetail>(
      onWillAcceptWithDetails: (_) => recipeDrop != null,
      onAcceptWithDetails: (d) {
        HapticFeedback.mediumImpact();
        recipeDrop?.onDrop(d.data, date, d.offset);
      },
      builder: (ctx, recipeCandidates, _) => DragTarget<MealplanEntry>(
        onWillAcceptWithDetails: (d) => _otherDay(d.data),
        onAcceptWithDetails: (d) {
          HapticFeedback.mediumImpact();
          onDrop(d.data);
        },
        builder: (ctx, candidates, _) {
          final hovered = candidates.isNotEmpty || recipeCandidates.isNotEmpty;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            // Fester Abstand wie bisher; die Markierung liegt als Rahmen
            // DARÜBER, damit beim Darüberziehen nichts verrutscht.
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: hovered
                  ? AppTokens.accent.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppTokens.rLg),
            ),
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTokens.rLg),
              border: Border.all(
                  color: hovered ? AppTokens.accent : Colors.transparent,
                  width: 2),
            ),
            child: child,
          );
        },
      ),
    );
  }
}

/// Liefert den Ablage-Handler für Rezepte aus der Desktop-Seitenleiste.
class _RecipeDropScope extends InheritedWidget {
  final void Function(RecipeDetail recipe, DateTime day, Offset at) onDrop;
  const _RecipeDropScope({required this.onDrop, required super.child});

  static _RecipeDropScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_RecipeDropScope>();

  @override
  bool updateShouldNotify(_RecipeDropScope old) => false;
}

/// Desktop-Seitenleiste im Essensplan: Rezepte suchen und per Maus auf einen
/// Tag ziehen (beim Ablegen wird die Mahlzeit gewählt).
class _RecipeSidePanel extends ConsumerStatefulWidget {
  final VoidCallback onDragStarted;
  final ValueChanged<bool> onDragEnded;
  const _RecipeSidePanel(
      {required this.onDragStarted, required this.onDragEnded});

  @override
  ConsumerState<_RecipeSidePanel> createState() => _RecipeSidePanelState();
}

class _RecipeSidePanelState extends ConsumerState<_RecipeSidePanel> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final terms = searchTerms(_query);
    final recipes = [
      for (final r in ref.watch(recipesProvider).valueOrNull ?? const [])
        if (recipeMatchesSearch(r, terms, includeDescription: false)) r,
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
        child: AppSearchField(
          hintText: l.searchRecipe,
          fillColor: context.appSurface2,
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
        child: Text(l.mealplanDragRecipeHint,
            style: TextStyle(color: context.appFgSub, fontSize: 13)),
      ),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
          itemCount: recipes.length,
          itemBuilder: (ctx, i) {
            final r = recipes[i];
            final tile = ListTile(
              dense: true,
              leading: RecipeMatchThumb(recipe: r, size: 36),
              title: Text(r.name, maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: Icon(Icons.drag_indicator_rounded,
                  color: context.appFgTertiary),
              onTap: () => context.push('/recipes/${r.id}'),
            );
            return Draggable<RecipeDetail>(
              data: r,
              onDragStarted: widget.onDragStarted,
              onDragCompleted: () => widget.onDragEnded(true),
              onDraggableCanceled: (_, __) => widget.onDragEnded(false),
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.appCard,
                    borderRadius: BorderRadius.circular(AppTokens.rMd),
                    border: Border.all(color: AppTokens.accent, width: 2),
                    boxShadow: context.appShadowMd,
                  ),
                  child: Row(children: [
                    RecipeMatchThumb(recipe: r, size: 40),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(r.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: context.appFg,
                              fontWeight: FontWeight.w600)),
                    ),
                  ]),
                ),
              ),
              childWhenDragging: Opacity(opacity: 0.35, child: tile),
              child: tile,
            );
          },
        ),
      ),
    ]);
  }
}

/// Tag ohne Mahlzeiten: Datum grau, darunter ein grauer Platzhalter — dient
/// als Ziel zum Verschieben.
class _EmptyDaySection extends ConsumerWidget {
  final DateTime date;
  final bool dragging;
  final ValueChanged<MealplanEntry> onDrop;

  /// Tipp auf „Nichts geplant" → Mahlzeit für diesen Tag planen.
  final VoidCallback onAdd;
  const _EmptyDaySection({
    required this.date,
    required this.dragging,
    required this.onDrop,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final lang =
        ref.watch(settingsProvider).valueOrNull?.selectedLanguage ?? 'de';
    final isToday = startOfDay(date) == startOfDay(DateTime.now());
    return _DayDropTarget(
      date: date,
      onDrop: onDrop,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text(DateFormat('EEEE, d. MMMM yyyy', lang).format(date),
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: context.appFgTertiary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2)),
            ),
            if (isToday)
              Text(l.today,
                  style: const TextStyle(
                      color: AppTokens.accentDeep,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 8),
          Semantics(
            button: !dragging,
            label: dragging ? l.mealplanDropHere : l.planMeal,
            child: TapSurface(
              onTap: dragging ? null : onAdd,
              color: context.appSurface2.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppTokens.rMd),
              border: Border.all(color: context.appSeparator),
              height: 52,
              child: Center(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (!dragging) ...[
                    Icon(Icons.add_rounded,
                        size: 18, color: context.appFgTertiary),
                    const SizedBox(width: 6),
                  ],
                  Text(dragging ? l.mealplanDropHere : l.mealplanDayEmpty,
                      style: TextStyle(
                          color: dragging
                              ? context.appFgSub
                              : context.appFgTertiary,
                          fontSize: 14,
                          fontWeight:
                              dragging ? FontWeight.w600 : FontWeight.w400)),
                ]),
              ),
            ),
          ),
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
  final VoidCallback? onDragStarted;
  final ValueChanged<DragUpdateDetails>? onDragUpdate;
  final ValueChanged<bool>? onDragEnded;

  const _MealEntryCard({
    required this.entry,
    this.onDragStarted,
    this.onDragUpdate,
    this.onDragEnded,
  });

  // Alle Mealie-Mahlzeitentypen (meal_types.dart) — vorher erschienen
  // Beilage/Zwischenmahlzeit/Getränk/Nachspeise als Rohtext („side").
  String _slotEmoji(String slot) => mealTypeEmoji(slot);

  String _slotName(String slot, AppLocalizations l) => mealTypeLabel(slot, l);

  /// Gekocht = für das Rezept ist am geplanten Tag oder danach „Ich hab's
  /// gekocht“ eingetragen (Mealie `lastMade`), und der Tag ist nicht in der
  /// Zukunft.
  /// Nur echte „Ich hab's gemacht"-Einträge zählen — NICHT lastMade: das
  /// setzt Mealie nachts für jeden geplanten Eintrag, auch ungekocht.
  /// Gezählt wird ein Eintrag vom geplanten Tag bis 6 Tage danach.
  bool _isCooked(WidgetRef ref) {
    final id = entry.recipe?.id ?? entry.recipeId;
    final day = DateTime.tryParse(entry.date);
    if (id == null || day == null) return false;
    final planned = startOfDay(day);
    final today = startOfDay(DateTime.now());
    if (planned.isAfter(today)) return false;
    final weekStart = startOfWeek(planned, ref.watch(weekStartWeekdayProvider));
    final server =
        ref.watch(cookedMarksProvider(weekStart)).valueOrNull ?? const {};
    final local = ref.watch(localCookedMarksProvider);
    for (var i = 0; i < 7; i++) {
      final d = DateTime(planned.year, planned.month, planned.day + i);
      if (d.isAfter(today)) break;
      final key = cookedMarkKey(id, d);
      if (server.contains(key) || local.contains(key)) return true;
    }
    return false;
  }

  Future<void> _cookToday(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final t = DateTime.now();
    final today = '${t.year.toString().padLeft(4, '0')}-'
        '${t.month.toString().padLeft(2, '0')}-'
        '${t.day.toString().padLeft(2, '0')}';
    try {
      await ref.read(mealplanProvider.notifier).moveEntry(entry,
          date: today, entryType: entry.entryType, week: false);
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(userErrorMessage(e, l.mealplanMoveFailed))));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(mealplanProvider.notifier).deleteEntry(entry.id);
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(userErrorMessage(e, l.deleteFailed))));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final accent = Theme.of(context).colorScheme.primary;
    final cooked = _isCooked(ref);
    final recipe = entry.recipe;
    // Die ganze Karte öffnet das Rezept — nicht nur Bild und Name.
    final card = TapSurface(
      color: context.appCard,
      borderRadius: BorderRadius.circular(AppTokens.rLg),
      border: Border.all(color: context.appSeparator, width: 1),
      boxShadow: context.appShadowSm,
      padding: const EdgeInsets.all(14),
      // Notiz-Einträge: Antippen öffnet „Bearbeiten" (Issue #41).
      onTap: recipe == null
          ? () => showEditMealDialog(context, ref, entry)
          : () => context.push(_recipeRoute(recipe.id)),
      child: Row(
        children: [
          // Gekocht: Inhalt ausgegraut, statt ⋮ ein grüner Haken (Menü
          // dann per Wisch nach links).
          Expanded(
            child: Opacity(
              opacity: cooked ? 0.5 : 1,
              child: Row(
                children: [
                  // Rezeptbild wie in der Rezeptliste (Offline-Kopie
                  // bevorzugt); ohne Bild, bei Ladefehler und bei
                  // Notiz-Einträgen der Kreis mit dem Mahlzeiten-Emoji.
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
                        if (_note != null) _noteLine(context, _note!),
                        // Mealie ≥ 3.29: geplante Portionen je Eintrag.
                        if (recipe != null && ref.watch(mealie329Provider))
                          _ServingsPill(entry: entry, enabled: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (cooked)
            Tooltip(
              message: l.mealplanEntryCooked,
              child: Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 9),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF34C759),
                ),
                child: const Icon(Icons.check_rounded,
                    size: 19, color: Colors.white),
              ),
            )
          else
            // ⋮-Menü: Verschieben (Tag/Mahlzeit) + Löschen.
            PopupMenuButton<String>(
              tooltip: l.mealplanEntryActions,
              icon: Icon(Icons.more_vert_rounded, color: context.appFgTertiary),
              onSelected: (v) async {
                if (v == 'edit') {
                  await showEditMealDialog(context, ref, entry);
                } else if (v == 'move') {
                  await showMoveMealDialog(context, ref, entry);
                } else if (v == 'today') {
                  await _cookToday(context, ref);
                } else if (v == 'delete') {
                  await _delete(context, ref);
                }
              },
              itemBuilder: (_) => [
                // Wochen-Eintrag auf heute legen (wie „Heute kochen“ in der
                // Webapp) — danach ein normaler Eintrag für heute.
                if (entry.isWeekEntry)
                  PopupMenuItem(
                    value: 'today',
                    child: Row(children: [
                      const Icon(Icons.today_rounded, size: 20),
                      const SizedBox(width: 12),
                      Text(l.mealplanCookToday),
                    ]),
                  ),
                PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [
                    const Icon(Icons.edit_rounded, size: 20),
                    const SizedBox(width: 12),
                    Text(l.edit),
                  ]),
                ),
                PopupMenuItem(
                  value: 'move',
                  child: Row(children: [
                    const Icon(Icons.event_repeat_rounded, size: 20),
                    const SizedBox(width: 12),
                    Text(l.mealplanMoveAction),
                  ]),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    const Icon(Icons.delete_outline_rounded,
                        size: 20, color: Colors.red),
                    const SizedBox(width: 12),
                    Text(l.delete, style: const TextStyle(color: Colors.red)),
                  ]),
                ),
              ],
            ),
        ],
      ),
    );
    // Nach links wischen: Bearbeiten + Verschieben + Löschen (wie bei
    // Lebensmitteln) — auch bei gekochten Einträgen ohne ⋮-Menü.
    final swipeable = SwipeContextMenu(
        child: Slidable(
      key: ValueKey('meal-${entry.id}'),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: AppTokens.swipeExtent(3),
        children: [
          SlidableAction(
            onPressed: (_) => showEditMealDialog(context, ref, entry),
            backgroundColor: AppTokens.swipeEdit,
            foregroundColor: Colors.white,
            icon: Icons.edit_rounded,
            label: l.edit,
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppTokens.rLg)),
          ),
          SlidableAction(
            onPressed: (_) => showMoveMealDialog(context, ref, entry),
            backgroundColor: AppTokens.swipeSecondary,
            foregroundColor: Colors.white,
            icon: Icons.event_repeat_rounded,
            label: l.mealplanMoveAction,
          ),
          SlidableAction(
            onPressed: (_) => _delete(context, ref),
            backgroundColor: AppTokens.swipeDelete,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline_rounded,
            label: l.delete,
            borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(AppTokens.rLg)),
          ),
        ],
      ),
      child: card,
    ));
    const gap = EdgeInsets.only(bottom: 10);
    if (onDragStarted == null) return Padding(padding: gap, child: swipeable);
    return LayoutBuilder(
      builder: (ctx, box) => LongPressDraggable<MealplanEntry>(
        data: entry,
        hapticFeedbackOnStart: true,
        onDragStarted: onDragStarted,
        onDragUpdate: onDragUpdate,
        // Nicht onDragEnd: das meldet Flutter nur, solange diese Karte noch
        // existiert — nach einem Wochenwechsel ist sie weg.
        onDragCompleted: () => onDragEnded?.call(true),
        onDraggableCanceled: (_, __) => onDragEnded?.call(false),
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: box.maxWidth,
            child: Transform.scale(
              scale: 1.03,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTokens.rLg),
                  boxShadow: context.appShadowMd,
                ),
                child: card,
              ),
            ),
          ),
        ),
        childWhenDragging:
            Padding(padding: gap, child: Opacity(opacity: 0.3, child: card)),
        child: Padding(padding: gap, child: swipeable),
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
    final image = ClipOval(
      child: SizedBox(
        width: 50,
        height: 50,
        child: RecipeImage(
          recipeId: recipe.id,
          imageUrl:
              '$serverUrl/api/media/recipes/${recipe.id}/images/original.webp',
          width: 50,
          height: 50,
          placeholder: (_) => _slotBadge(accent),
        ),
      ),
    );
    return image;
  }

  /// Rezept in der geplanten Größe öffnen (wie die Webapp: `?scale=`).
  String _recipeRoute(String id) {
    final scale = entry.recipeScale ?? 1;
    return scale == 1 ? '/recipes/$id' : '/recipes/$id?scale=$scale';
  }

  Widget _entryTitle(BuildContext context) {
    if (entry.recipe != null) {
      return Text(entry.recipe!.name,
          style: TextStyle(
              color: context.appFg, fontSize: 16, fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis);
    }
    // Ohne Titel (z. B. in der Webapp nur als Text angelegt) zeigt der Text
    // die Notiz — dann nicht noch einmal darunter (siehe [_note]).
    final title = entry.title?.trim() ?? '';
    final freeText = title.isNotEmpty ? title : entry.text?.trim();
    if (freeText != null && freeText.isNotEmpty) {
      // Kursiv statt Anführungszeichen-Icon: unterscheidet eigene Mahlzeiten
      // dezent von Rezepten.
      return Text(freeText,
          style: TextStyle(
              color: context.appFg, fontSize: 16, fontStyle: FontStyle.italic),
          maxLines: 2,
          overflow: TextOverflow.ellipsis);
    }
    return Text('—', style: TextStyle(color: context.appFgSub));
  }

  /// Notiz (Mealie `text`) unter dem Titel — bei Rezepten immer, bei
  /// Notiz-Einträgen nur, wenn sie nicht schon als Titel dient.
  String? get _note {
    final text = entry.text?.trim() ?? '';
    if (text.isEmpty) return null;
    if (entry.recipe == null && (entry.title?.trim() ?? '').isEmpty) {
      return null;
    }
    return text;
  }

  Widget _noteLine(BuildContext context, String note) => Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(Icons.sticky_note_2_outlined,
                  size: 13, color: context.appFgSub),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(note,
                  style: TextStyle(
                      color: context.appFgSub, fontSize: 13, height: 1.3),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      );
}

// ---------------------------------------------------------------------------
// Eintrag bearbeiten (Issue #41): Titel (nur ohne Rezept) und Notiz.
// ---------------------------------------------------------------------------

Future<void> showEditMealDialog(
    BuildContext context, WidgetRef ref, MealplanEntry entry) async {
  final l = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  final result = await showDialog<({String title, String text})>(
    context: context,
    builder: (_) => _EditMealDialog(entry: entry),
  );
  if (result == null) return;
  try {
    await ref
        .read(mealplanProvider.notifier)
        .editEntry(entry, title: result.title, text: result.text);
  } catch (e) {
    messenger.showSnackBar(
        SnackBar(content: Text(userErrorMessage(e, l.saveFailed))));
  }
}

class _EditMealDialog extends StatefulWidget {
  final MealplanEntry entry;
  const _EditMealDialog({required this.entry});

  @override
  State<_EditMealDialog> createState() => _EditMealDialogState();
}

class _EditMealDialogState extends State<_EditMealDialog> {
  late final bool _isNote =
      widget.entry.recipe == null && (widget.entry.recipeId?.isEmpty ?? true);
  // Notiz-Eintrag nur mit `text` (z. B. aus der Webapp): der Text war bisher
  // der angezeigte Titel → als Titel vorbelegen, Notiz leer.
  late final bool _textAsTitle =
      _isNote && (widget.entry.title?.trim() ?? '').isEmpty;
  late final _titleCtrl = TextEditingController(
      text: _textAsTitle ? widget.entry.text ?? '' : widget.entry.title ?? '');
  late final _noteCtrl =
      TextEditingController(text: _textAsTitle ? '' : widget.entry.text ?? '');

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  bool get _canSave => !_isNote || _titleCtrl.text.trim().isNotEmpty;

  void _save() {
    if (!_canSave) return;
    Navigator.pop(context, (
      // Rezept-Einträge: Titel unverändert lassen.
      title: _isNote ? _titleCtrl.text.trim() : widget.entry.title ?? '',
      text: _noteCtrl.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final recipeName = widget.entry.recipe?.name;
    return AlertDialog(
      scrollable: true,
      backgroundColor: context.appCard,
      title: Text(l.mealplanEditTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (recipeName != null) ...[
            Text(recipeName,
                style: TextStyle(
                    color: context.appFg, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
          ],
          if (_isNote) ...[
            TextField(
              controller: _titleCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: l.mealplanEntryTitleLabel),
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: _noteCtrl,
            autofocus: !_isNote,
            minLines: 2,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l.mealplanEntryNoteLabel,
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: _canSave ? _save : null,
          child: Text(l.save),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Portionen eines Mahlzeitplan-Eintrags (Mealie `recipeScale`, ab 3.29).
// Angezeigt als Portionen (Rezept-Portionen × Faktor) wie in der Webapp;
// ohne bekannte Portionenzahl zählt das Rezept wie dort als 1 Portion.
// ---------------------------------------------------------------------------

class _ServingsPill extends ConsumerWidget {
  final MealplanEntry entry;
  final bool enabled;
  const _ServingsPill({required this.entry, required this.enabled});

  double _baseServings(WidgetRef ref) {
    final id = entry.recipe!.id;
    for (final r in ref.watch(recipesProvider).valueOrNull ?? const []) {
      if (r.id == id) {
        final s = r.servings ?? 0;
        return s > 0 ? s : 1;
      }
    }
    return 1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final base = _baseServings(ref);
    final scale = entry.recipeScale ?? 1;
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: TapSurface(
        onTap: enabled ? () => _edit(context, ref, base, scale) : null,
        color: AppTokens.accentDeep.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppTokens.rXs),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.people_alt_rounded,
              size: 14, color: AppTokens.accentDeep),
          const SizedBox(width: 5),
          Text('${formatQuantity(base * scale)} ${l.servings}',
              style: const TextStyle(
                  color: AppTokens.accentDeep,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Future<void> _edit(
      BuildContext context, WidgetRef ref, double base, double scale) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final servings = await showDialog<double>(
      context: context,
      builder: (_) => _ServingsDialog(initial: base * scale),
    );
    if (servings == null || servings <= 0) return;
    final newScale = servings / base;
    if ((newScale - scale).abs() < 1e-9) return;
    try {
      await ref.read(mealplanProvider.notifier).setRecipeScale(entry, newScale);
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(userErrorMessage(e, l.saveFailed))));
    }
  }
}

class _ServingsDialog extends StatefulWidget {
  final double initial;
  const _ServingsDialog({required this.initial});

  @override
  State<_ServingsDialog> createState() => _ServingsDialogState();
}

class _ServingsDialogState extends State<_ServingsDialog> {
  late double _value = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    Widget step(IconData icon, double delta) => IconButton.filledTonal(
          icon: Icon(icon),
          onPressed: _value + delta <= 0
              ? null
              : () => setState(() => _value = _value + delta),
        );
    return AlertDialog(
      backgroundColor: context.appCard,
      title: Text(l.mealplanServingsTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.mealplanServingsHint,
              style: TextStyle(color: context.appFgSub, fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              step(Icons.remove_rounded, -1),
              SizedBox(
                width: 72,
                child: Text(formatQuantity(_value),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: context.appFg,
                        fontSize: 26,
                        fontWeight: FontWeight.w700)),
              ),
              step(Icons.add_rounded, 1),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(
            onPressed: () => Navigator.pop(context, _value),
            child: Text(l.save)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Mahlzeit verschieben — Tag und Mahlzeit ändern (Mealie PUT), danach
// Hinweis mit Sprung in die Zielwoche, falls sie nicht angezeigt wird.
// ---------------------------------------------------------------------------

Future<void> showMoveMealDialog(
    BuildContext context, WidgetRef ref, MealplanEntry entry) async {
  final l = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  final result = await showDialog<({DateTime date, String type})>(
    context: context,
    builder: (_) => _MoveMealDialog(entry: entry),
  );
  if (result == null) return;
  // Wochen-Einträge wandern als ganze Woche (in die Woche des gewählten
  // Datums); auf einen einzelnen Tag geht es per Ziehen oder „Heute kochen“.
  final date = entry.isWeekEntry
      ? startOfWeek(result.date, ref.read(weekStartWeekdayProvider))
      : result.date;
  final dateStr = '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
  if (dateStr == entry.date && result.type == entry.entryType) return;
  try {
    await ref
        .read(mealplanProvider.notifier)
        .moveEntry(entry, date: dateStr, entryType: result.type);
    final targetWeek = startOfWeek(date, ref.read(weekStartWeekdayProvider));
    final shownWeek = startOfDay(ref.read(currentWeekStartProvider));
    final lang =
        ref.read(settingsProvider).valueOrNull?.selectedLanguage ?? 'de';
    messenger.showSnackBar(SnackBar(
      // Mit Knopf bleibt eine SnackBar seit Flutter 3.29 sonst STEHEN
      // (persist = action != null) — erst ein Neustart räumte sie weg.
      persist: false,
      duration: const Duration(seconds: 5),
      content: Text(
          l.mealplanMovedTo(DateFormat('EEEE, d. MMMM', lang).format(date))),
      action: targetWeek == shownWeek
          ? null
          : SnackBarAction(
              label: l.mealplanShowWeek,
              onPressed: () => ref
                  .read(currentWeekStartProvider.notifier)
                  .state = targetWeek,
            ),
    ));
  } catch (e) {
    messenger.showSnackBar(
        SnackBar(content: Text(userErrorMessage(e, l.mealplanMoveFailed))));
  }
}

class _MoveMealDialog extends ConsumerStatefulWidget {
  final MealplanEntry entry;
  const _MoveMealDialog({required this.entry});

  @override
  ConsumerState<_MoveMealDialog> createState() => _MoveMealDialogState();
}

class _MoveMealDialogState extends ConsumerState<_MoveMealDialog> {
  late DateTime _date = DateTime.tryParse(widget.entry.date) ?? DateTime.now();
  late String _type = widget.entry.entryType.toLowerCase();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final lang =
        ref.watch(settingsProvider).valueOrNull?.selectedLanguage ?? 'de';
    final name = widget.entry.recipe?.name ??
        widget.entry.title ??
        widget.entry.text ??
        '';
    return AlertDialog(
      scrollable: true,
      backgroundColor: context.appCard,
      title: Text(l.mealplanMoveTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (name.isNotEmpty)
            Text(name,
                style: TextStyle(
                    color: context.appFg, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_rounded),
            title: Text(l.mealplanMoveDate),
            subtitle: Text(DateFormat('EEEE, d. MMMM yyyy', lang).format(_date),
                style: TextStyle(
                    color: context.appFg, fontWeight: FontWeight.w600)),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(_date.year - 2),
                lastDate: DateTime(_date.year + 3),
              );
              if (picked != null && mounted) setState(() => _date = picked);
            },
          ),
          const SizedBox(height: 4),
          // Alle Mahlzeitentypen wie in Mealie-Web, seitlich wischbar; ein
          // unbekannter Typ des Eintrags bleibt wählbar.
          MealTypeChipRow(
            selected: _type,
            onChanged: (v) => setState(() => _type = v),
            includeUnknownSelected: true,
            sidePadding: 0,
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(
          onPressed: () => Navigator.pop(context, (date: _date, type: _type)),
          child: Text(l.mealplanMoveAction),
        ),
      ],
    );
  }
}
