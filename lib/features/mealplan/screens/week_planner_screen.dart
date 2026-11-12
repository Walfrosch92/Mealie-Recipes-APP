import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_service.dart'
    show apiServiceProvider, userErrorMessage;
import '../../../core/models/mealplan_entry.dart';
import '../../../core/models/organizer_item.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/utils/meal_types.dart';
import '../../../core/utils/server_time.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/multi_select_sheet.dart';
import '../../organizers/providers/organizers_provider.dart';
import '../../recipe_match/screens/recipe_match_screen.dart'
    show RecipeMatchThumb;
import '../../recipe_match/providers/recipe_match_provider.dart';
import '../../recipe_match/screens/recipe_match_shopping_screen.dart';
import '../../recipes/providers/favorites_provider.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../providers/mealplan_provider.dart';
import '../services/week_planner.dart';
import '../providers/mealplan_rules_provider.dart';
import '../../../core/models/mealplan_rule.dart';
import 'add_meal_entry_screen.dart' show recipeMatchesDiceFilter;
import '../../../shared/widgets/app_chip.dart';

// ---------------------------------------------------------------------------
// „Woche planen" (Essensplan-Knopf + Kachel in „Weiteres") — drei Schritte:
//   1. Tage & Mahlzeiten im Wochenraster wählen (Geplantes bleibt gesperrt,
//      vergangene Tage sind aus),
//   2. Vorlieben (alles optional, wird lokal gemerkt),
//   3. Vorschau: je Platz ein Vorschlag, Würfel tauscht, Schloss behält.
// Eintragen über MealplanNotifier.addEntry, danach optional dieselbe
// Zutaten-Auswahl wie bei Rezept-Match. Logik: [WeekPlanner].
// ---------------------------------------------------------------------------

const _kPrefsKey = 'week_planner_prefs';
const _kBaseTypes = ['breakfast', 'lunch', 'dinner'];

class WeekPlannerScreen extends ConsumerStatefulWidget {
  /// Erster Tag der zu planenden Woche; ohne = die im Essensplan gezeigte.
  final DateTime? weekStart;

  /// Rezepte, die zuerst verteilt werden (vom Rezept-Match-Tablett). Was
  /// eingetragen wird, verlässt danach das Tablett.
  final List<RecipeDetail> preferred;
  const WeekPlannerScreen(
      {super.key, this.weekStart, this.preferred = const []});

  @override
  ConsumerState<WeekPlannerScreen> createState() => _WeekPlannerScreenState();
}

class _WeekPlannerScreenState extends ConsumerState<WeekPlannerScreen> {
  late DateTime _weekStart;
  int _step = 0;
  bool _extraTypes = false;

  /// Gewählte Plätze (Schlüssel → Platz); `null` = noch nicht vorbelegt.
  Map<String, PlanSlot>? _selected;

  WeekPlanPrefs _prefs = const WeekPlanPrefs();
  Map<String, PlanPick?> _picks = {};
  final Set<String> _locked = {};
  bool _thenShopping = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final today = startOfDay(DateTime.now());
    final start =
        startOfDay(widget.weekStart ?? ref.read(currentWeekStartProvider));
    // Vergangene Woche → aktuelle Woche planen.
    _weekStart = start.isBefore(addDays(today, -6))
        ? startOfWeek(today, ref.read(weekStartWeekdayProvider))
        : start;
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(_kPrefsKey);
      if (raw == null) return;
      final j = jsonDecode(raw);
      if (j is Map<String, dynamic> && mounted) {
        setState(() => _prefs = WeekPlanPrefs.fromJson(j));
      }
    } catch (_) {}
  }

  Future<void> _setPrefs(WeekPlanPrefs p) async {
    setState(() => _prefs = p);
    try {
      await (await SharedPreferences.getInstance())
          .setString(_kPrefsKey, jsonEncode(p.toJson()));
    } catch (_) {}
  }

  // ── Daten ──────────────────────────────────────────────────────────────

  List<DateTime> get _days =>
      [for (var i = 0; i < 7; i++) addDays(_weekStart, i)];

  List<String> get _types => _extraTypes ? kMealTypes : _kBaseTypes;

  Map<DateTime, List<MealplanEntry>> get _plan =>
      ref.read(mealplanProvider).valueOrNull ?? const {};

  bool _isPlanned(DateTime day, String type) =>
      (_plan[startOfDay(day)] ?? const [])
          .any((e) => e.entryType.toLowerCase() == type);

  bool _isPast(DateTime day) =>
      startOfDay(day).isBefore(startOfDay(DateTime.now()));

  bool _isOpen(DateTime day, String type) =>
      !_isPast(day) && !_isPlanned(day, type);

  /// Letztes Koch- oder Plan-Datum je Rezept (Mealie „Zuletzt gekocht" und
  /// vergangene Essensplan-Einträge — „Zuletzt gekocht" fehlt oft).
  Map<String, DateTime> _lastCooked(List<RecipeDetail> recipes) {
    final today = startOfDay(DateTime.now());
    final map = <String, DateTime>{};
    void note(String id, DateTime d) {
      final old = map[id];
      if (old == null || d.isAfter(old)) map[id] = d;
    }

    for (final r in recipes) {
      final lm = parseMealieTime(r.lastMade);
      if (lm != null) note(r.id, lm);
    }
    _plan.forEach((day, list) {
      if (day.isAfter(today)) return;
      for (final e in list) {
        final id = e.recipe?.id ?? e.recipeId;
        if (id != null && id.isNotEmpty) note(id, day);
      }
    });
    return map;
  }

  WeekPlanner _planner(List<RecipeDetail> recipes) => WeekPlanner(
        recipes: recipes,
        prefs: _prefs,
        favorites: ref.read(favoritesProvider).valueOrNull ?? const {},
        lastCooked: _lastCooked(recipes),
        diceFilters:
            ref.read(settingsProvider).valueOrNull?.mealDiceFilters ?? const {},
        matchesDice: recipeMatchesDiceFilter,
        ruleMatches: _ruleMatches,
        today: startOfDay(DateTime.now()),
      );

  /// Treffer der Mealie-Regeln je Platz, siehe [WeekPlanner.ruleMatches].
  /// Vorher nutzte der Wochenplaner IMMER die App-Auswahl, auch wenn im
  /// Zahnrad „Mealie-Regeln" gewählt war — nur der Einzel-Würfel hielt sich
  /// daran (Support-Mail 2026-11-10).
  Map<String, Set<String>>? _ruleMatches;

  bool get _useMealieRules =>
      ref.read(settingsProvider).valueOrNull?.mealDiceUseMealieRules ?? false;

  /// Lädt [_ruleMatches] für [slots], wenn Würfel-Regeln beachtet werden und
  /// das System „Mealie-Regeln" gewählt ist. Wie der Einzel-Würfel: der
  /// Server wertet den kombinierten Filter aus, Treffer werden gespeichert
  /// und offline wiederverwendet. Gleiche Filter nur einmal abfragen. Fehlen
  /// offline für einen Filter Treffer → App-Auswahl mit Hinweis.
  Future<void> _loadRuleMatches(List<PlanSlot> slots) async {
    if (!_prefs.useDiceRules || !_useMealieRules) {
      _ruleMatches = null;
      return;
    }
    List<MealPlanRule> rules;
    try {
      rules = await ref.read(mealplanRulesProvider.future);
    } catch (_) {
      rules = const [];
    }
    final api = ref.read(apiServiceProvider);
    final byFilter = <String, Set<String>?>{};
    final result = <String, Set<String>>{};
    for (final slot in slots) {
      final filter = combinedRuleFilter(rules, slot.date, slot.type);
      if (filter == null) continue; // keine Regel → alle Rezepte
      if (!byFilter.containsKey(filter)) {
        Set<String>? ids;
        try {
          ids = (await api.fetchRecipeSummariesByQueryFilter(filter))
              .map((r) => r.id)
              .toSet();
          unawaited(saveMealRuleMatches(filter, ids));
        } catch (_) {
          ids = await loadMealRuleMatches(filter);
        }
        byFilter[filter] = ids;
      }
      final ids = byFilter[filter];
      if (ids == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.mealRulesOffline)));
        }
        _ruleMatches = null;
        return;
      }
      result[slot.key] = ids;
    }
    _ruleMatches = result;
  }

  Set<String> get _plannedThisWeek => {
        for (final d in _days)
          for (final e in _plan[startOfDay(d)] ?? const <MealplanEntry>[])
            if ((e.recipe?.id ?? e.recipeId) != null)
              (e.recipe?.id ?? e.recipeId)!,
      };

  /// Gewählte Plätze, die noch frei sind (der Essensplan kann nach dem
  /// Vorbelegen noch nachgeladen haben), chronologisch.
  List<PlanSlot> get _slots {
    final list =
        _selected!.values.where((s) => _isOpen(s.date, s.type)).toList()
          ..sort((a, b) {
            final d = a.date.compareTo(b.date);
            return d != 0
                ? d
                : mealTypeOrder(a.type).compareTo(mealTypeOrder(b.type));
          });
    return list;
  }

  // ── Auswahl ────────────────────────────────────────────────────────────

  /// Schnellwahl, zwei kombinierbare Reihen: welche Tage × welche Mahlzeit.
  _DayGroup _dayGroup = _DayGroup.all;
  _MealGroup _mealGroup = _MealGroup.dinner;

  Map<String, PlanSlot> _presetSlots() {
    final days = _days.where((d) => switch (_dayGroup) {
          _DayGroup.all => true,
          _DayGroup.weekdays => d.weekday <= DateTime.friday,
          _DayGroup.weekend => d.weekday >= DateTime.saturday,
        });
    final types = switch (_mealGroup) {
      _MealGroup.dinner => const ['dinner'],
      _MealGroup.lunch => const ['lunch'],
      _MealGroup.all => _types,
    };
    return {
      for (final d in days)
        for (final t in types)
          if (_isOpen(d, t)) PlanSlot(d, t).key: PlanSlot(d, t),
    };
  }

  void _applyPreset({_DayGroup? days, _MealGroup? meals}) {
    HapticFeedback.selectionClick();
    setState(() {
      _dayGroup = days ?? _dayGroup;
      _mealGroup = meals ?? _mealGroup;
      _selected = _presetSlots();
    });
  }

  void _toggleCell(DateTime day, String type) {
    if (!_isOpen(day, type)) return;
    HapticFeedback.selectionClick();
    final s = PlanSlot(day, type);
    setState(() {
      if (_selected!.remove(s.key) == null) _selected![s.key] = s;
    });
  }

  void _shiftWeek(int delta) {
    final next = addDays(_weekStart, 7 * delta);
    if (delta < 0 && addDays(next, 6).isBefore(startOfDay(DateTime.now()))) {
      return;
    }
    setState(() {
      _weekStart = next;
      _selected = null; // neu vorbelegen
    });
  }

  // ── Vorschau ───────────────────────────────────────────────────────────

  bool _loadingRules = false;

  Future<void> _suggest() async {
    if (_loadingRules) return;
    setState(() => _loadingRules = true);
    try {
      await _loadRuleMatches(_slots);
    } finally {
      if (mounted) setState(() => _loadingRules = false);
    }
    if (!mounted) return;
    final recipes = ref.read(recipesProvider).valueOrNull ?? const [];
    final planner = _planner(recipes);
    setState(() {
      _locked.clear();
      _picks = planner.planAll(_slots,
          alreadyPlanned: _plannedThisWeek, preferred: widget.preferred);
      _step = 2;
    });
  }

  Future<void> _rerollAll() async {
    HapticFeedback.mediumImpact();
    // Regeln können sich inzwischen geändert haben (oder Netz ist zurück).
    await _loadRuleMatches(_slots);
    if (!mounted) return;
    final recipes = ref.read(recipesProvider).valueOrNull ?? const [];
    setState(() {
      _picks = _planner(recipes).planAll(
        _slots,
        locked: {for (final k in _locked) k: _picks[k]},
        alreadyPlanned: _plannedThisWeek,
        preferred: [
          for (final r in widget.preferred)
            if (!_locked.any((k) => _picks[k]?.recipe.id == r.id)) r,
        ],
      );
    });
  }

  void _rerollOne(PlanSlot slot) {
    HapticFeedback.selectionClick();
    final recipes = ref.read(recipesProvider).valueOrNull ?? const [];
    final slots = _slots;
    final i = slots.indexWhere((s) => s.key == slot.key);
    final previous = i > 0 ? _picks[slots[i - 1].key]?.recipe : null;
    final used = {
      ..._plannedThisWeek,
      for (final e in _picks.entries)
        if (e.value != null) e.value!.recipe.id,
    };
    setState(() {
      _picks[slot.key] =
          _planner(recipes).pickFor(slot, used: used, previous: previous) ??
              _picks[slot.key];
    });
  }

  /// Halten & Ziehen in der Vorschau: Gerichte zweier Plätze tauschen
  /// (das Schloss wandert mit dem Gericht).
  void _swap(String a, String b) {
    if (a == b) return;
    HapticFeedback.mediumImpact();
    setState(() {
      final pa = _picks[a];
      _picks[a] = _picks[b];
      _picks[b] = pa;
      final la = _locked.contains(a);
      final lb = _locked.contains(b);
      _locked.remove(a);
      _locked.remove(b);
      if (la) _locked.add(b);
      if (lb) _locked.add(a);
    });
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _save() async {
    if (_saving) return;
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final notifier = ref.read(mealplanProvider.notifier);
    setState(() => _saving = true);
    final created = <MealplanEntry>[];
    final recipes = <RecipeDetail>[];
    Object? error;
    for (final s in _slots) {
      final pick = _picks[s.key];
      if (pick == null) continue;
      try {
        created.add(await notifier.addEntry(
          date: _fmtDate(s.date),
          entryType: s.type,
          recipeId: pick.recipe.id,
        ));
        if (!recipes.any((r) => r.id == pick.recipe.id)) {
          recipes.add(pick.recipe);
        }
      } catch (e) {
        error ??= e;
      }
    }
    // Eingetragene Tablett-Rezepte verlassen das Tablett.
    if (widget.preferred.isNotEmpty) {
      final planned = {for (final r in recipes) r.id};
      ref.read(recipeMatchProvider.notifier).removeManyFromTray(
          widget.preferred.map((r) => r.id).where(planned.contains));
    }
    if (!mounted) return;
    setState(() => _saving = false);
    if (error != null && created.isEmpty) {
      messenger.showSnackBar(
          SnackBar(content: Text(userErrorMessage(error, l.saveFailed))));
      return;
    }
    messenger.showSnackBar(SnackBar(
      content: Text(error == null
          ? l.recipeMatchMealsAdded(created.length)
          : userErrorMessage(error, l.saveFailed)),
      persist: false,
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: l.undo,
        onPressed: () async {
          for (final e in created) {
            try {
              await notifier.deleteEntry(e.id);
            } catch (_) {}
          }
        },
      ),
    ));
    if (_thenShopping && recipes.isNotEmpty) {
      nav.pushReplacement(MaterialPageRoute(
          builder: (_) => RecipeMatchShoppingScreen(recipes: recipes)));
    } else {
      nav.pop();
    }
  }

  // ── UI ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    ref.watch(mealplanProvider);
    final recipes = ref.watch(recipesProvider).valueOrNull ?? const [];
    // Vorbelegung nach der Schnellwahl (Standard: alle Tage, abends).
    _selected ??= _presetSlots();

    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _step--);
      },
      child: Scaffold(
        backgroundColor: context.appBg,
        appBar: AppBar(title: Text(l.weekPlannerTitle)),
        body: SafeArea(
          top: false,
          child: Column(children: [
            _StepChips(
              step: _step,
              onTap: (i) {
                if (i < _step) setState(() => _step = i);
              },
            ),
            Expanded(
              child: switch (_step) {
                0 => _buildDays(context),
                1 => _buildPrefs(context, recipes),
                _ => _buildPreview(context),
              },
            ),
            _buildFooter(context, recipes),
          ]),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, List<RecipeDetail> recipes) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final count = _slots.length;
    final range = '${DateFormat.MMMd(locale).format(_days.first)} – '
        '${DateFormat.MMMd(locale).format(_days.last)}';

    if (_step == 2) {
      final filled = _slots.where((s) => _picks[s.key] != null).length;
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: context.appSeparator)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CheckboxListTile(
            value: _thenShopping,
            onChanged: (v) => setState(() => _thenShopping = v ?? false),
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppTokens.accent,
            title: Text(l.weekPlannerThenShopping,
                style: TextStyle(color: context.appFg, fontSize: 14)),
          ),
          GradientButton(
            label: l.recipeMatchAddMeals(filled),
            icon: Icons.event_available_rounded,
            busy: _saving,
            onTap: filled == 0 ? null : _save,
          ),
        ]),
      );
    }

    final subtitle = _step == 0 ? range : l.weekPlannerForMeals(count);
    final title = _step == 0
        ? l.weekPlannerMealCount(count)
        : l.weekPlannerMatching(_planner(recipes).pool.length);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.appSeparator)),
      ),
      child: Row(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: TextStyle(
                      color: context.appFg,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
              Text(subtitle,
                  style: TextStyle(color: context.appFgSub, fontSize: 12)),
            ],
          ),
        ),
        SizedBox(
          width: 170,
          child: GradientButton(
            label: _step == 0 ? l.next : l.weekPlannerSuggest,
            icon: _step == 0 ? null : Icons.casino_rounded,
            height: 52,
            onTap: count == 0 || _loadingRules
                ? null
                : () {
                    if (_step == 0) {
                      setState(() => _step = 1);
                    } else {
                      _suggest();
                    }
                  },
          ),
        ),
      ]),
    );
  }

  // Schritt 1 ───────────────────────────────────────────────────────────

  Widget _buildDays(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final days = _days;
    final types = _types;
    final wide = types.length > 3;
    const dayW = 58.0;
    final cellW = wide ? 74.0 : null;
    final canGoBack =
        !addDays(_weekStart, -1).isBefore(startOfDay(DateTime.now()));

    Widget cell(DateTime d, String t) {
      final planned = _isPlanned(d, t);
      final past = _isPast(d);
      final on = _selected!.containsKey(PlanSlot(d, t).key);
      final label =
          '${DateFormat.EEEE(locale).format(d)} ${mealTypeLabel(t, l)}';
      Widget child;
      if (planned) {
        child = Text(l.weekPlannerPlanned,
            style: TextStyle(color: context.appFgSub, fontSize: 11));
      } else if (on) {
        child = const Icon(Icons.check_rounded, color: Colors.white, size: 20);
      } else {
        child = const SizedBox.shrink();
      }
      final box = Semantics(
        button: !planned && !past,
        selected: on,
        label: label,
        // Eigene (durchsichtige) Material-Ebene: Ink malt auf das nächste
        // Material darunter — ohne diese lag das Orange UNTER der Karte mit
        // dem Raster und war unsichtbar.
        // Schatten außen (in Ink würde er am Rechteck abgeschnitten).
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTokens.rSm),
            boxShadow: on
                ? const [
                    BoxShadow(
                        color: Color(0x40FF7800),
                        blurRadius: 8,
                        offset: Offset(0, 3)),
                  ]
                : null,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppTokens.rSm),
              onTap: planned || past ? null : () => _toggleCell(d, t),
              child: Ink(
                height: 42,
                decoration: BoxDecoration(
                  gradient: on ? AppTokens.accentGradient : null,
                  color: on
                      ? null
                      : planned
                          ? context.appSeparator
                          : past
                              ? context.appBg
                              : context.appSurface2,
                  borderRadius: BorderRadius.circular(AppTokens.rSm),
                  border: on ? null : Border.all(color: context.appSeparator),
                ),
                child: Center(child: child),
              ),
            ),
          ),
        ),
      );
      return Padding(
        padding: const EdgeInsets.all(3),
        child: cellW == null ? box : SizedBox(width: cellW, child: box),
      );
    }

    final grid = Column(children: [
      Row(children: [
        const SizedBox(width: dayW),
        for (final t in types)
          cellW == null
              ? Expanded(child: _ColHeader(mealTypeLabel(t, l)))
              : SizedBox(
                  width: cellW + 6, child: _ColHeader(mealTypeLabel(t, l))),
      ]),
      for (final d in days)
        Row(children: [
          SizedBox(
            width: dayW,
            child: Text('${DateFormat.E(locale).format(d)} ${d.day}',
                style: TextStyle(
                    color: _isPast(d) ? context.appFgTertiary : context.appFg,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
          for (final t in types)
            cellW == null ? Expanded(child: cell(d, t)) : cell(d, t),
        ]),
    ]);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      children: [
        Text(l.weekPlannerDaysTitle,
            style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: context.appFg,
                fontSize: 18,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(l.weekPlannerDaysHint,
            style:
                TextStyle(color: context.appFgSub, fontSize: 13, height: 1.4)),
        const SizedBox(height: 10),
        Row(children: [
          IconButton(
            tooltip: l.previousWeek,
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: canGoBack ? () => _shiftWeek(-1) : null,
          ),
          Expanded(
            child: Text(
                '${DateFormat.MMMd(locale).format(days.first)} – '
                '${DateFormat.MMMd(locale).format(days.last)}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: context.appFg,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ),
          IconButton(
            tooltip: l.nextWeek,
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: () => _shiftWeek(1),
          ),
        ]),
        Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (g, label) in [
                (_DayGroup.all, l.weekPlannerAllDays),
                (_DayGroup.weekdays, l.weekPlannerPresetWeekdays),
                (_DayGroup.weekend, l.weekPlannerWeekend),
              ])
                _Chip(
                    label: label,
                    selected: _dayGroup == g,
                    onTap: () => _applyPreset(days: g)),
            ]),
        const SizedBox(height: 8),
        Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (g, label) in [
                (_MealGroup.dinner, l.weekPlannerDinners),
                (_MealGroup.lunch, l.weekPlannerLunches),
                (_MealGroup.all, l.weekPlannerAllMeals),
              ])
                _Chip(
                    label: label,
                    selected: _mealGroup == g,
                    onTap: () => _applyPreset(meals: g)),
            ]),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.appCard,
            borderRadius: BorderRadius.circular(AppTokens.rLg),
            border: Border.all(color: context.appSeparator),
          ),
          child: wide
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicWidth(child: grid))
              : grid,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() {
              _extraTypes = !_extraTypes;
              if (!_extraTypes) {
                _selected!.removeWhere((_, s) => !_kBaseTypes.contains(s.type));
              }
            }),
            icon: Icon(_extraTypes ? Icons.remove_rounded : Icons.add_rounded),
            label: Text(
                _extraTypes ? l.weekPlannerFewerMeals : l.weekPlannerMoreMeals),
          ),
        ),
      ],
    );
  }

  // Schritt 2 ───────────────────────────────────────────────────────────

  Future<void> _pickOrganizers(OrganizerKind kind) async {
    final l = AppLocalizations.of(context)!;
    final isCat = kind == OrganizerKind.category;
    final res = await showMultiSelectSheet(
      context,
      title: isCat ? l.categories : l.tags,
      initial: isCat ? _prefs.categories : _prefs.tags,
      items: (r) => [
        for (final o in r.watch(organizersProvider(kind)).valueOrNull ??
            const <OrganizerItem>[])
          (id: o.id, name: o.name),
      ],
      loading: (r) => r.watch(organizersProvider(kind)).isLoading,
    );
    if (res == null) return;
    _setPrefs(isCat
        ? _prefs.copyWith(categories: res.selected)
        : _prefs.copyWith(tags: res.selected));
  }

  Widget _buildPrefs(BuildContext context, List<RecipeDetail> recipes) {
    final l = AppLocalizations.of(context)!;
    Widget toggle(IconData icon, String title, String sub, bool value,
            ValueChanged<bool> onChanged) =>
        SwitchListTile.adaptive(
          value: value,
          onChanged: (v) {
            HapticFeedback.selectionClick();
            onChanged(v);
          },
          activeTrackColor: AppTokens.accent,
          secondary: Icon(icon, color: AppTokens.accentDeep),
          title: Text(title,
              style: TextStyle(
                  color: context.appFg,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          subtitle: Text(sub,
              style: TextStyle(color: context.appFgSub, fontSize: 13)),
        );

    Widget removable(SelectItem item, VoidCallback onRemove) => AppChip(
          label: item.name,
          selected: true,
          onRemove: onRemove,
          removeTooltip: l.delete,
        );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      children: [
        Text(l.weekPlannerPrefsTitle,
            style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: context.appFg,
                fontSize: 18,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(l.weekPlannerPrefsHint,
            style:
                TextStyle(color: context.appFgSub, fontSize: 13, height: 1.4)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: context.appCard,
            borderRadius: BorderRadius.circular(AppTokens.rLg),
            border: Border.all(color: context.appSeparator),
          ),
          child: Column(children: [
            toggle(
                Icons.schedule_rounded,
                l.weekPlannerQuick,
                l.weekPlannerQuickSub(kWeekPlannerQuickMinutes),
                _prefs.quickWeekdays,
                (v) => _setPrefs(_prefs.copyWith(quickWeekdays: v))),
            toggle(
                Icons.history_rounded,
                l.weekPlannerStale,
                l.weekPlannerStaleSub,
                _prefs.preferStale,
                (v) => _setPrefs(_prefs.copyWith(preferStale: v))),
            toggle(
                Icons.favorite_rounded,
                l.weekPlannerFavorites,
                l.weekPlannerFavoritesSub,
                _prefs.preferFavorites,
                (v) => _setPrefs(_prefs.copyWith(preferFavorites: v))),
            toggle(
                Icons.grid_view_rounded,
                l.weekPlannerVariety,
                l.weekPlannerVarietySub,
                _prefs.variety,
                (v) => _setPrefs(_prefs.copyWith(variety: v))),
          ]),
        ),
        const SizedBox(height: 18),
        Text(l.weekPlannerOnlyFrom.toUpperCase(),
            style: TextStyle(
                color: context.appFgSub,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final c in _prefs.categories)
            removable(
                c,
                () => _setPrefs(_prefs.copyWith(categories: [
                      for (final x in _prefs.categories)
                        if (x.id != c.id) x
                    ]))),
          for (final t in _prefs.tags)
            removable(
                t,
                () => _setPrefs(_prefs.copyWith(tags: [
                      for (final x in _prefs.tags)
                        if (x.id != t.id) x
                    ]))),
          AppChip(
            icon: Icons.add_rounded,
            label: l.categories,
            onTap: () => _pickOrganizers(OrganizerKind.category),
          ),
          AppChip(
            icon: Icons.add_rounded,
            label: l.tags,
            onTap: () => _pickOrganizers(OrganizerKind.tag),
          ),
        ]),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: context.appCard,
            borderRadius: BorderRadius.circular(AppTokens.rLg),
            border: Border.all(color: context.appSeparator),
          ),
          child: toggle(
              Icons.casino_rounded,
              l.weekPlannerDiceRules,
              _useMealieRules
                  ? l.weekPlannerDiceRulesMealieSub
                  : l.weekPlannerDiceRulesSub,
              _prefs.useDiceRules,
              (v) => _setPrefs(_prefs.copyWith(useDiceRules: v))),
        ),
      ],
    );
  }

  // Schritt 3 ───────────────────────────────────────────────────────────

  String _reasonText(AppLocalizations l, PlanReason r) => switch (r) {
        PlanReason.neverCooked => l.weekPlannerReasonNever,
        PlanReason.stale => l.weekPlannerReasonStale,
        PlanReason.favorite => l.weekPlannerReasonFavorite,
        PlanReason.fromTray => l.weekPlannerReasonTray,
        PlanReason.none => '',
      };

  Widget _buildPreview(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final slots = _slots;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 12, 6),
        child: Row(children: [
          Expanded(
            child: Text(l.weekPlannerPreviewHint,
                style: TextStyle(color: context.appFgSub, fontSize: 13)),
          ),
          OutlinedButton.icon(
            onPressed: _rerollAll,
            icon: const Icon(Icons.casino_rounded, size: 18),
            label: Text(l.weekPlannerRerollAll),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.appFg,
              side: BorderSide(color: context.appSeparator),
              shape: const StadiumBorder(),
            ),
          ),
        ]),
      ),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          itemCount: slots.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (ctx, i) {
            final s = slots[i];
            final pick = _picks[s.key];
            final locked = _locked.contains(s.key);
            final r = pick?.recipe;
            final meta = <String>[
              mealTypeLabel(s.type, l),
              if ((r?.totalTime ?? 0) > 0) '${r!.totalTime} ${l.minutesShort}',
              if (pick != null && pick.reason != PlanReason.none)
                _reasonText(l, pick.reason),
            ].join(' · ');
            Widget thumb(double size) => r != null
                ? RecipeMatchThumb(recipe: r, size: size)
                : Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: context.appSurface2,
                      borderRadius: BorderRadius.circular(size * 0.25),
                    ),
                    child: Icon(Icons.search_off_rounded,
                        color: context.appFgTertiary),
                  );
            final dish = Row(children: [
              thumb(52),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r?.name ?? l.weekPlannerNoMatch,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: r == null ? context.appFgSub : context.appFg,
                            fontSize: 14,
                            height: 1.25,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(meta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: context.appFgSub, fontSize: 12)),
                  ],
                ),
              ),
            ]);
            // Ganze Zeile = Ablageziel UND ziehbar (lange drücken) → auf
            // einen anderen Tag ziehen tauscht die beiden Gerichte.
            return DragTarget<String>(
              onWillAcceptWithDetails: (d) => d.data != s.key,
              onAcceptWithDetails: (d) => _swap(d.data, s.key),
              builder: (ctx, candidates, _) {
                final hovered = candidates.isNotEmpty;
                final card = AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                  decoration: BoxDecoration(
                    color: hovered
                        ? AppTokens.accent.withValues(alpha: 0.16)
                        : locked
                            ? AppTokens.accent.withValues(alpha: 0.08)
                            : context.appCard,
                    borderRadius: BorderRadius.circular(AppTokens.rMd),
                    border: Border.all(
                        width: hovered ? 2 : 1,
                        color: hovered
                            ? AppTokens.accent
                            : locked
                                ? AppTokens.accent.withValues(alpha: 0.45)
                                : context.appSeparator),
                  ),
                  child: Row(children: [
                    SizedBox(
                      width: 38,
                      child: Column(children: [
                        Text('${s.date.day}',
                            style: TextStyle(
                                color: context.appFg,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                        Text(DateFormat.E(locale).format(s.date),
                            style: TextStyle(
                                color: context.appFgSub, fontSize: 11)),
                      ]),
                    ),
                    const SizedBox(width: 6),
                    Expanded(child: dish),
                    IconButton(
                      tooltip: locked ? l.weekPlannerUnlock : l.weekPlannerLock,
                      icon: Icon(
                          locked ? Icons.lock_rounded : Icons.lock_open_rounded,
                          size: 20,
                          color: locked
                              ? AppTokens.accentDeep
                              : context.appFgTertiary),
                      onPressed: r == null
                          ? null
                          : () {
                              HapticFeedback.selectionClick();
                              setState(() {
                                if (!_locked.remove(s.key)) _locked.add(s.key);
                              });
                            },
                    ),
                    IconButton(
                      tooltip: l.weekPlannerReroll,
                      icon: Icon(Icons.casino_rounded,
                          size: 21,
                          color: locked
                              ? context.appSeparator
                              : AppTokens.accentDeep),
                      onPressed: locked ? null : () => _rerollOne(s),
                    ),
                  ]),
                );
                // Die GANZE Karte ist ziehbar (lange drücken), nicht nur
                // Bild/Name. Würfel und Schloss reagieren weiter auf Tippen.
                return LongPressDraggable<String>(
                  data: s.key,
                  maxSimultaneousDrags: r == null ? 0 : 1,
                  hapticFeedbackOnStart: true,
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
                        thumb(44),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(r?.name ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: context.appFg,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ]),
                    ),
                  ),
                  childWhenDragging: Opacity(opacity: 0.3, child: card),
                  child: card,
                );
              },
            );
          },
        ),
      ),
    ]);
  }
}

class _StepChips extends StatelessWidget {
  final int step;
  final ValueChanged<int> onTap;
  const _StepChips({required this.step, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final labels = [
      l.weekPlannerStepDays,
      l.weekPlannerStepPrefs,
      l.weekPlannerStepPreview,
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(children: [
        for (var i = 0; i < 3; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: Material(
              color: i == step
                  ? AppTokens.accent.withValues(alpha: 0.18)
                  : context.appCard,
              shape: StadiumBorder(
                side: BorderSide(
                  color: i == step
                      ? AppTokens.accent.withValues(alpha: 0.5)
                      : context.appSeparator,
                ),
              ),
              child: InkWell(
                customBorder: const StadiumBorder(),
                onTap: i < step ? () => onTap(i) : null,
                child: SizedBox(
                  height: 36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i < step
                              ? const Color(0xFF2E9E57)
                              : i == step
                                  ? AppTokens.accent
                                  : context.appSeparator,
                        ),
                        child: i < step
                            ? const Icon(Icons.check_rounded,
                                size: 13, color: Colors.white)
                            : Text('${i + 1}',
                                style: TextStyle(
                                    color: i == step
                                        ? Colors.white
                                        : context.appFgSub,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(labels[i],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: i == step
                                    ? AppTokens.accentDeep
                                    : context.appFgSub,
                                fontSize: 13,
                                fontWeight: i == step
                                    ? FontWeight.w700
                                    : FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ]),
    );
  }
}

class _ColHeader extends StatelessWidget {
  final String text;
  const _ColHeader(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(text,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.appFgSub, fontSize: 12)),
      );
}

enum _DayGroup { all, weekdays, weekend }

enum _MealGroup { dinner, lunch, all }

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) =>
      AppChip(label: label, selected: selected, onTap: onTap);
}
