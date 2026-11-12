import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart' show userErrorMessage;
import '../../../core/models/recipe_detail.dart';
import '../../../core/utils/meal_types.dart';
import '../../../core/utils/mealie_version.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../mealplan/providers/mealplan_provider.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../providers/recipe_match_provider.dart';
import 'recipe_match_screen.dart' show RecipeMatchThumb;
import '../../../shared/widgets/app_chip.dart';

// ---------------------------------------------------------------------------
// Rezept-Match → Essensplan: pro Tablett-Rezept Tag + Mahlzeit wählen.
// Eingetragene Rezepte verlassen das Tablett, Rezepte ohne Tag bleiben
// liegen. Wochenbeginn folgt Mealie (weekStartWeekdayProvider).
// ---------------------------------------------------------------------------

class RecipeMatchMealplanScreen extends ConsumerStatefulWidget {
  const RecipeMatchMealplanScreen({super.key});

  @override
  ConsumerState<RecipeMatchMealplanScreen> createState() =>
      _RecipeMatchMealplanScreenState();
}

class _RecipeMatchMealplanScreenState
    extends ConsumerState<RecipeMatchMealplanScreen> {
  int _weekOffset = 0;
  final Map<String, DateTime> _dates = {};
  final Map<String, String> _types = {};

  /// Mealie ≥ 3.30: Rezepte, die für die ganze (angezeigte) Woche geplant
  /// werden statt für einen Tag.
  final Set<String> _weekly = {};
  bool _saving = false;

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _submit(List<RecipeDetail> recipes, DateTime weekStart) async {
    if (_saving) return;
    final l = AppLocalizations.of(context)!;
    final notifier = ref.read(mealplanProvider.notifier);
    setState(() => _saving = true);
    final done = <String>[];
    Object? error;
    for (final r in recipes) {
      final week = _weekly.contains(r.id);
      final date = week ? weekStart : _dates[r.id];
      if (date == null) continue;
      try {
        await notifier.addEntry(
          date: _fmtDate(date),
          entryType: _types[r.id] ?? 'dinner',
          recipeId: r.id,
          week: week,
        );
        done.add(r.id);
      } catch (e) {
        error ??= e;
      }
    }
    ref.read(recipeMatchProvider.notifier).removeManyFromTray(done);
    if (!mounted) return;
    setState(() {
      _saving = false;
      for (final id in done) {
        _dates.remove(id);
        _weekly.remove(id);
      }
    });
    final messenger = ScaffoldMessenger.of(context);
    if (error != null) {
      messenger.showSnackBar(
          SnackBar(content: Text(userErrorMessage(error, l.saveFailed))));
      return;
    }
    Navigator.of(context).pop();
    messenger.showSnackBar(
        SnackBar(content: Text(l.recipeMatchMealsAdded(done.length))));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final all =
        ref.watch(recipesProvider).valueOrNull ?? const <RecipeDetail>[];
    final recipes = ref.watch(recipeMatchProvider).trayRecipes(all);
    final firstWeekday = ref.watch(weekStartWeekdayProvider);
    final weekStart = startOfWeek(DateTime.now(), firstWeekday)
        .add(Duration(days: 7 * _weekOffset));
    // Über Tage addieren statt Duration: Zeitumstellung verschiebt sonst
    // die Uhrzeit und damit ggf. das Datum.
    final days = [
      for (var i = 0; i < 7; i++)
        DateTime(weekStart.year, weekStart.month, weekStart.day + i),
    ];
    final range = '${DateFormat.MMMd(locale).format(days.first)} – '
        '${DateFormat.MMMd(locale).format(days.last)}';
    final v330 = ref.watch(mealie330Provider);
    final count = recipes
        .where((r) => _dates[r.id] != null || _weekly.contains(r.id))
        .length;

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(title: Text(l.recipeMatchToMealplan)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed:
                  _weekOffset > 0 ? () => setState(() => _weekOffset--) : null,
            ),
            Expanded(
              child: Text(range,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: context.appFg,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: () => setState(() => _weekOffset++),
            ),
          ]),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            itemCount: recipes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final r = recipes[i];
              final picked = _dates[r.id];
              final weekly = _weekly.contains(r.id);
              final type = _types[r.id] ?? 'dinner';
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.appCard,
                  borderRadius: BorderRadius.circular(AppTokens.rMd),
                  border: Border.all(color: context.appSeparator),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: [
                      RecipeMatchThumb(recipe: r, size: 40),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: context.appFg,
                                    fontSize: 15,
                                    height: 1.25,
                                    fontWeight: FontWeight.w700)),
                            if (picked == null && !weekly)
                              Text(l.recipeMatchNoDay,
                                  style: TextStyle(
                                      color: context.appFgSub, fontSize: 13)),
                          ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      for (final d in days)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: _DayChip(
                              weekday: DateFormat.E(locale).format(d),
                              day: d.day,
                              // Ganze Woche gewählt → alle Tage markiert.
                              selected: weekly ||
                                  (picked != null &&
                                      DateUtils.isSameDay(picked, d)),
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _weekly.remove(r.id);
                                  if (picked != null &&
                                      DateUtils.isSameDay(picked, d)) {
                                    _dates.remove(r.id);
                                  } else {
                                    _dates[r.id] = d;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                    ]),
                    // Mealie ≥ 3.30: statt eines Tages die ganze Woche.
                    if (v330) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: AppChip(
                          icon: Icons.date_range_rounded,
                          label: l.mealplanPlanWholeWeek,
                          selected: weekly,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              if (weekly) {
                                _weekly.remove(r.id);
                              } else {
                                _weekly.add(r.id);
                                _dates.remove(r.id);
                              }
                            });
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        for (final t in kMealTypes)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: AppChip(
                              label: mealTypeLabel(t, l),
                              selected: type == t,
                              onTap: () => setState(() => _types[r.id] = t),
                            ),
                          ),
                      ]),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: GradientButton(
              label: l.recipeMatchAddMeals(count),
              icon: Icons.event_available_rounded,
              busy: _saving,
              onTap: count == 0 ? null : () => _submit(recipes, weekStart),
            ),
          ),
        ),
      ]),
    );
  }
}

class _DayChip extends StatelessWidget {
  final String weekday;
  final int day;
  final bool selected;
  final VoidCallback onTap;
  const _DayChip({
    required this.weekday,
    required this.day,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppTokens.accentDeep : context.appFg;
    return Material(
      color: selected
          ? AppTokens.accent.withValues(alpha: 0.2)
          : context.appSurface2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTokens.rSm),
        side: BorderSide(
            color: selected ? AppTokens.accent : context.appSeparator),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.rSm),
        onTap: onTap,
        child: SizedBox(
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(weekday,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      color: selected ? fg : context.appFgSub, fontSize: 11)),
              Text('$day',
                  style: TextStyle(
                      color: fg, fontSize: 14, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
