// ---------------------------------------------------------------------------
// Mahlzeitenplan-Regel (Mealie PlanRulesOut): „an [day] für [entryType] nur
// Rezepte, die [queryFilterString] erfüllen". `unset` = jeder Tag / jede
// Mahlzeit. Der Server verknüpft ALLE Regeln, die auf Tag+Mahlzeit passen,
// mit UND (QueryFilterBuilder.combine_filters) — siehe [combinedRuleFilter].
// ---------------------------------------------------------------------------

/// Mealie-Wochentage in Server-Schreibweise (Montag = Index 0).
const kRuleDays = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
];

/// Mealie-Mahlzeitentypen der Regeln (PlanRulesType ohne `unset`).
const kRuleEntryTypes = [
  'breakfast',
  'lunch',
  'dinner',
  'side',
  'snack',
  'drink',
  'dessert',
];

class MealPlanRule {
  final String id;

  /// Wochentag (`monday` … `sunday`) oder `unset`.
  final String day;

  /// Mahlzeit (`breakfast` …) oder `unset`.
  final String entryType;
  final String queryFilterString;

  const MealPlanRule({
    required this.id,
    this.day = 'unset',
    this.entryType = 'unset',
    this.queryFilterString = '',
  });

  static MealPlanRule? tryParse(dynamic raw) {
    if (raw is! Map) return null;
    final id = raw['id']?.toString();
    if (id == null || id.isEmpty) return null;
    return MealPlanRule(
      id: id,
      day: raw['day']?.toString() ?? 'unset',
      entryType: raw['entryType']?.toString() ?? 'unset',
      queryFilterString: raw['queryFilterString']?.toString() ?? '',
    );
  }

  /// Gilt diese Regel für [date] + Mahlzeit [entryType]? (wie
  /// RepositoryMealPlanRules.get_rules: passender Tag ODER unset, passende
  /// Mahlzeit ODER unset).
  bool appliesTo(DateTime date, String entryType) {
    final dayOk =
        day == 'unset' || day.isEmpty || day == kRuleDays[date.weekday - 1];
    final typeOk = this.entryType == 'unset' ||
        this.entryType.isEmpty ||
        this.entryType == entryType;
    return dayOk && typeOk;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'day': day,
        'entryType': entryType,
        'queryFilterString': queryFilterString,
      };

  /// Nutzlast für POST/PUT (PlanRulesCreate).
  Map<String, dynamic> toCreateJson() => {
        'day': day,
        'entryType': entryType,
        'queryFilterString': queryFilterString,
      };
}

/// Kombinierter Filter aller Regeln für [date]/[entryType] — genau wie der
/// Server beim Zufallsrezept: nicht-leere Filter in Klammern, mit AND
/// verbunden. `null`, wenn keine Regel mit Filter greift.
String? combinedRuleFilter(
    List<MealPlanRule> rules, DateTime date, String entryType) {
  final parts = [
    for (final r in rules)
      if (r.appliesTo(date, entryType) && r.queryFilterString.trim().isNotEmpty)
        '(${r.queryFilterString.trim()})',
  ];
  return parts.isEmpty ? null : parts.join(' AND ');
}
