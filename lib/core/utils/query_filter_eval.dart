import '../models/recipe_detail.dart';
import 'cookbook_query_filter.dart';
import 'server_time.dart';

// ---------------------------------------------------------------------------
// Lokale Auswertung eines (einfachen, AND-verknüpften) Mealie-Query-Filters
// gegen ein Rezept aus dem Cache — damit die Rezept-Suche offline dieselben
// „Anderen Filter" anwenden kann wie der Server. Semantik wie Mealies
// QueryFilterBuilder: IN = irgendeines, NOT IN = keines, CONTAINS ALL = alle;
// fehlende Werte (kein Rating, nie gekocht, keine Zeit) erfüllen wie in SQL
// keinen Vergleich.
// ---------------------------------------------------------------------------

bool recipeMatchesQueryRows(
  RecipeDetail r,
  List<CookbookFilterRow> rows, {
  Map<String, String> foodLabelIds = const {},
  Map<String, double> ownRatings = const {},
  DateTime? now,
}) {
  final t = now ?? DateTime.now();
  // Wie Mealie (_get_rating_col_alias): eigene Bewertung, sonst der
  // Durchschnitt; 0 = keine.
  final mine = ownRatings[r.id];
  final avg = r.rating;
  final rating = (mine != null && mine > 0)
      ? mine
      : ((avg == null || avg == 0) ? null : avg);
  for (final row in rows) {
    if (!_matchesRow(r, row, foodLabelIds, t, rating)) return false;
  }
  return true;
}

bool _matchesRow(RecipeDetail r, CookbookFilterRow row,
    Map<String, String> foodLabelIds, DateTime now, double? effRating) {
  if (row.isDate) {
    final day = row.date;
    if (day == null) return true; // leere Zeile wird auch nicht gesendet
    // Der Cache kennt nur dateAdded/dateUpdated — bei Mealie decken sie sich
    // mit created_at/updated_at (Tag bzw. Zeitstempel).
    final raw = row.field == CookbookFilterField.createdAt
        ? r.dateAdded
        : r.dateUpdated;
    final have = parseMealieTime(raw) ?? DateTime.tryParse(raw ?? '');
    if (have == null) return false;
    return _compare(have.compareTo(day), row.op);
  }
  if (row.isScalar && row.isNullCheck) {
    final value = switch (row.field) {
      CookbookFilterField.lastMade => parseMealieTime(r.lastMade),
      CookbookFilterField.rating => effRating,
      CookbookFilterField.totalTime => r.totalTime,
      _ => null,
    };
    return (value == null) == (row.op == CookbookFilterOp.isNull);
  }
  if (row.isScalar) {
    final n = row.number;
    if (n == null) return true; // leere Zeile wird auch nicht gesendet
    switch (row.field) {
      case CookbookFilterField.lastMade:
        // Wie Mealie ≥ 3.29 (repository_recipes._get_last_made_col_alias):
        // nie gekocht = 1.1.1900 → zählt bei „älter als" mit, bei „neuer
        // als" nicht. Vorher fiel es offline bei beiden heraus.
        final lm =
            parseMealieTime(r.lastMade) ?? DateTime.utc(1900, 1, 1);
        final threshold = now.subtract(Duration(days: n));
        return _compare(lm.compareTo(threshold), row.op);
      case CookbookFilterField.rating:
        final rating = effRating;
        if (rating == null) return false;
        return _compare(rating.compareTo(n), row.op);
      case CookbookFilterField.totalTime:
        final minutes = r.totalTime;
        if (minutes == null) return false;
        return _compare(minutes.compareTo(n), row.op);
      default:
        return true;
    }
  }
  final have = _values(r, row.field, foodLabelIds);
  final wanted = row.valueIds.toSet();
  if (wanted.isEmpty) return true;
  return switch (row.op) {
    CookbookFilterOp.isOneOf => wanted.any(have.contains),
    CookbookFilterOp.isNotOneOf => !wanted.any(have.contains),
    CookbookFilterOp.containsAll => wanted.every(have.contains),
    _ => true,
  };
}

bool _compare(int c, CookbookFilterOp op) => switch (op) {
      CookbookFilterOp.eq => c == 0,
      CookbookFilterOp.ne => c != 0,
      CookbookFilterOp.gt => c > 0,
      CookbookFilterOp.gte => c >= 0,
      CookbookFilterOp.lt => c < 0,
      CookbookFilterOp.lte => c <= 0,
      _ => true,
    };

Set<String> _values(RecipeDetail r, CookbookFilterField f,
        Map<String, String> foodLabelIds) =>
    switch (f) {
      CookbookFilterField.category => {for (final c in r.recipeCategory) c.id},
      CookbookFilterField.tag => {for (final x in r.tags) x.id},
      CookbookFilterField.tool => {for (final x in r.tools) x.id},
      CookbookFilterField.food => {
          for (final i in r.recipeIngredient)
            if ((i.food?.id ?? '').isNotEmpty) i.food!.id!,
        },
      CookbookFilterField.foodLabel => {
          for (final i in r.recipeIngredient)
            if (foodLabelIds[i.food?.id] case final label?) label,
        },
      CookbookFilterField.household => {
          if ((r.householdId ?? '').isNotEmpty) r.householdId!,
        },
      CookbookFilterField.user => {
          if ((r.userId ?? '').isNotEmpty) r.userId!,
        },
      _ => const {},
    };
