import '../models/recipe_detail.dart';
import 'cookbook_query_filter.dart';

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
  DateTime? now,
}) {
  final t = now ?? DateTime.now();
  for (final row in rows) {
    if (!_matchesRow(r, row, foodLabelIds, t)) return false;
  }
  return true;
}

bool _matchesRow(RecipeDetail r, CookbookFilterRow row,
    Map<String, String> foodLabelIds, DateTime now) {
  if (row.isScalar) {
    final n = row.number;
    if (n == null) return true; // leere Zeile wird auch nicht gesendet
    switch (row.field) {
      case CookbookFilterField.lastMade:
        final lm = DateTime.tryParse(r.lastMade ?? '');
        if (lm == null) return false;
        final threshold = now.subtract(Duration(days: n));
        return _compare(lm.compareTo(threshold), row.op);
      case CookbookFilterField.rating:
        final rating = r.rating;
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
