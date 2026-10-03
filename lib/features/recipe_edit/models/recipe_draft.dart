import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../core/models/recipe_detail.dart';

// ---------------------------------------------------------------------------
// Bearbeitungs-Entwurf eines Rezepts — „nichts vergessen":
//
// Der Entwurf behält das ROHE Server-JSON des Rezepts und jedes Listen-
// Eintrags (Zutat, Schritt, Notiz) und legt beim Speichern nur die Felder
// darüber, die der Editor kennt. Alles andere — auch Felder, die es erst in
// künftigen Mealie-Versionen gibt — geht unverändert zurück. Vorher baute die
// App jede Zutat neu zusammen; Felder wie die Ersatzzutaten (Mealie 3.28)
// gingen dadurch bei jedem Speichern verloren.
//
// Oberste Ebene: Mealie-PATCH übernimmt nur mitgeschickte Felder
// (`exclude_unset`), daher gehen nur geänderte Felder raus — Listen (Zutaten,
// Schritte, Notizen, Kategorien …) werden vollständig ersetzt und deshalb
// immer aus Roh-Eintrag + Bearbeitung zusammengesetzt.
// ---------------------------------------------------------------------------

/// Client-generierte UUID v4 (referenceId neuer Zutaten/Notizen).
String newUuid() {
  final rnd = math.Random.secure();
  final b = List<int>.generate(16, (_) => rnd.nextInt(256));
  b[6] = (b[6] & 0x0f) | 0x40;
  b[8] = (b[8] & 0x3f) | 0x80;
  String hex(int s, int e) =>
      b.sublist(s, e).map((x) => x.toRadixString(16).padLeft(2, '0')).join();
  return '${hex(0, 4)}-${hex(4, 6)}-${hex(6, 8)}-${hex(8, 10)}-${hex(10, 16)}';
}

/// Mealie-Version „v3.28.0" / „3.28.0-beta" → (3, 28); unbekannt → null.
(int, int)? parseMealieVersion(String? v) {
  final m = RegExp(r'(\d+)\.(\d+)').firstMatch(v ?? '');
  if (m == null) return null;
  return (int.parse(m.group(1)!), int.parse(m.group(2)!));
}

bool _atLeast(String? version, int major, int minor) {
  final v = parseMealieVersion(version);
  if (v == null) return false;
  return v.$1 > major || (v.$1 == major && v.$2 >= minor);
}

/// Was Server und Rezept können — abgeleitet aus den Rohdaten (ein Feld,
/// das der Server kennt, liefert er immer mit, notfalls leer) und der
/// Server-Version für Rezepte ohne Zutaten/Schritte.
class DraftCaps {
  /// Zeiten strukturiert in Sekunden + Zusatztext (Mealie-Entwicklungsstand).
  final bool timeSeconds;

  /// Ertrag als Menge + Text (`recipeYieldQuantity`).
  final bool yieldQuantity;

  /// Ersatzzutaten je Zutat (Mealie 3.28).
  final bool substitutions;

  /// Notizen an Schritte verknüpfen (Mealie 3.28).
  final bool noteReferences;

  /// Vor Mealie 3.28: `settings.disableAmount` + `isFood`/`disableAmount`
  /// an jeder Zutat.
  final bool legacyAmountFlags;

  const DraftCaps({
    this.timeSeconds = false,
    this.yieldQuantity = false,
    this.substitutions = false,
    this.noteReferences = false,
    this.legacyAmountFlags = false,
  });

  factory DraftCaps.fromRaw(Map<String, dynamic> raw, {String? version}) {
    final ings = _maps(raw['recipeIngredient']);
    final steps = _maps(raw['recipeInstructions']);
    final notes = _maps(raw['notes']);
    final settings = raw['settings'];
    final new328 = _atLeast(version, 3, 28);
    return DraftCaps(
      timeSeconds: raw.containsKey('totalTimeSeconds'),
      yieldQuantity: raw.containsKey('recipeYieldQuantity'),
      substitutions: ings.any((i) => i.containsKey('substitutions')) || new328,
      noteReferences: steps.any((s) => s.containsKey('noteReferences')) ||
          notes.any((n) => n.containsKey('referenceId')) ||
          new328,
      legacyAmountFlags:
          settings is Map && settings.containsKey('disableAmount'),
    );
  }

  /// Nur was BEIDE können: der Entwurf (was er beim Öffnen kannte) und der
  /// aktuelle Server-Stand beim Speichern.
  DraftCaps and(DraftCaps o) => DraftCaps(
        timeSeconds: timeSeconds && o.timeSeconds,
        yieldQuantity: yieldQuantity && o.yieldQuantity,
        substitutions: substitutions && o.substitutions,
        noteReferences: noteReferences && o.noteReferences,
        legacyAmountFlags: legacyAmountFlags && o.legacyAmountFlags,
      );
}

List<Map<String, dynamic>> _maps(dynamic raw) => raw is List
    ? [
        for (final e in raw)
          if (e is Map) Map<String, dynamic>.from(e)
      ]
    : const [];

String? _str(dynamic v) {
  if (v == null) return null;
  final s = v.toString();
  return s;
}

String _name(dynamic obj) {
  if (obj is Map) return (obj['name'] ?? '').toString().trim();
  if (obj is String) return obj.trim();
  return '';
}

/// Menge fürs Eingabefeld: ganze Zahlen ohne „.0", sonst bis 3 Stellen.
String formatDraftQuantity(num? q) {
  if (q == null || q == 0) return '';
  if (q == q.truncate()) return q.truncate().toString();
  return q
      .toStringAsFixed(3)
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll(RegExp(r'\.$'), '');
}

/// „1,5" / „1.5" / „1 1/2" / „½" → Zahl; leer → null; unlesbar → null.
double? parseDraftQuantity(String text) {
  var t = text.trim().replaceAll(',', '.');
  if (t.isEmpty) return null;
  const glyphs = {'½': .5, '¼': .25, '¾': .75, '⅓': 1 / 3, '⅔': 2 / 3};
  var sum = 0.0;
  for (final g in glyphs.entries) {
    if (t.contains(g.key)) {
      sum += g.value;
      t = t.replaceAll(g.key, ' ').trim();
    }
  }
  final mixed =
      RegExp(r'^(?:(\d+(?:\.\d+)?)\s+)?(\d+)\s*/\s*(\d+)$').firstMatch(t);
  if (mixed != null) {
    final whole = double.tryParse(mixed.group(1) ?? '0') ?? 0;
    final den = double.parse(mixed.group(3)!);
    if (den == 0) return null;
    return whole + double.parse(mixed.group(2)!) / den + sum;
  }
  if (t.isEmpty) return sum == 0 ? null : sum;
  final v = double.tryParse(t);
  return v == null ? null : v + sum;
}

// ---------------------------------------------------------------------------
// Zeiten
// ---------------------------------------------------------------------------

/// Eine Rezeptzeit (Vorbereitung/Zubereitung/Gesamt): Stunden + Minuten und
/// — nur bei Servern mit Sekunden-Feldern — ein Zusatztext („plus über
/// Nacht"). Ältere Server kennen nur den Text; der wird nur neu geschrieben,
/// wenn Stunden/Minuten geändert wurden.
class DraftTime {
  /// Mealie-Feldname des Texts: prepTime / performTime / totalTime.
  final String key;
  final TextEditingController hours = TextEditingController();
  final TextEditingController minutes = TextEditingController();
  final TextEditingController extra = TextEditingController();

  /// Ursprüngliche Sekunden (auch „krumme" Rest-Sekunden bleiben erhalten).
  final int? _origSeconds;
  late final String _initHours;
  late final String _initMinutes;
  late final String _initExtra;

  DraftTime(this.key, Map<String, dynamic> raw,
      {required bool seconds, int? fallbackMinutes})
      : _origSeconds =
            seconds ? (raw['${key}Seconds'] as num?)?.toInt() : null {
    int? totalMinutes;
    if (seconds) {
      final s = _origSeconds;
      totalMinutes = s == null ? null : s ~/ 60;
      extra.text = _str(raw[key]) ?? '';
    } else {
      final text = raw[key] ?? (key == 'performTime' ? raw['cookTime'] : null);
      totalMinutes = parseDuration(text) ?? fallbackMinutes;
    }
    if (totalMinutes != null && totalMinutes > 0) {
      final h = totalMinutes ~/ 60;
      final m = totalMinutes % 60;
      hours.text = h > 0 ? '$h' : '';
      minutes.text = m > 0 ? '$m' : '';
    }
    _initHours = hours.text;
    _initMinutes = minutes.text;
    _initExtra = extra.text;
  }

  int get totalMinutes =>
      (int.tryParse(hours.text.trim()) ?? 0) * 60 +
      (int.tryParse(minutes.text.trim()) ?? 0);

  bool get durationChanged =>
      hours.text.trim() != _initHours.trim() ||
      minutes.text.trim() != _initMinutes.trim();

  bool get extraChanged => extra.text.trim() != _initExtra.trim();

  /// Felder für die PATCH-Payload (leer = nichts geändert).
  Map<String, dynamic> payload(
      DraftCaps caps, String Function(int minutes) formatDuration) {
    if (caps.timeSeconds) {
      return {
        if (durationChanged)
          '${key}Seconds': () {
            final leftover = (_origSeconds ?? 0) % 60;
            final total = totalMinutes * 60 + leftover;
            return total > 0 ? total : null;
          }(),
        if (extraChanged) key: extra.text.trim(),
      };
    }
    if (!durationChanged) return const {};
    final m = totalMinutes;
    return {key: m > 0 ? formatDuration(m) : ''};
  }

  String get signature => '${hours.text}|${minutes.text}|${extra.text}';

  void dispose() {
    hours.dispose();
    minutes.dispose();
    extra.dispose();
  }
}

// ---------------------------------------------------------------------------
// Zutaten
// ---------------------------------------------------------------------------

/// Ersatzzutat („kann ersetzt werden durch", Mealie 3.28): vorhandenes
/// Lebensmittel und/oder Notiz.
class DraftSubstitution {
  Map<String, dynamic> raw;
  final TextEditingController food;
  final TextEditingController note;
  final String _initFood;

  DraftSubstitution({Map<String, dynamic>? raw})
      : raw = raw ?? {},
        food = TextEditingController(
            text: raw?['substituteFood'] is Map
                ? _name(raw!['substituteFood'])
                : ''),
        note = TextEditingController(text: _str(raw?['note']) ?? ''),
        _initFood =
            raw?['substituteFood'] is Map ? _name(raw!['substituteFood']) : '';

  String? get _origFoodId => _str(raw['substituteFoodId'] ??
      (raw['substituteFood'] is Map ? raw['substituteFood']['id'] : null));

  /// Ersatz-Lebensmittel: unverändert → bisherige id; sonst per Name aus
  /// den VORHANDENEN Lebensmitteln (wie die Webapp: hier wird nichts neu
  /// angelegt — dafür ist die Notiz da).
  String? foodId(Map<String, dynamic>? Function(String name) findFood) {
    final name = food.text.trim();
    if (name == _initFood.trim()) return name.isEmpty ? null : _origFoodId;
    if (name.isEmpty) return null;
    return _str(findFood(name)?['id']);
  }

  Map<String, dynamic> payload(
      Map<String, dynamic>? Function(String name) findFood) {
    final m = Map<String, dynamic>.from(raw);
    final id = foodId(findFood);
    if (id != _origFoodId) m.remove('substituteFood');
    m['substituteFoodId'] = id;
    final n = note.text.trim();
    m['note'] = n.isEmpty ? null : n;
    return m;
  }

  bool get isEmpty => food.text.trim().isEmpty && note.text.trim().isEmpty;

  String get signature => '${food.text}|${note.text}';

  void dispose() {
    food.dispose();
    note.dispose();
  }
}

class DraftIngredient {
  /// Roher Server-Eintrag (leer bei neuen Zutaten).
  Map<String, dynamic> raw;

  /// Stabil pro Zutat — Ziel der Schritt-Verknüpfungen.
  final String referenceId;

  final TextEditingController quantity;
  final TextEditingController unit;
  final TextEditingController food;
  final TextEditingController note;

  /// Abschnittstitel (Mealie „Abschnitt"), gilt ab dieser Zutat.
  final TextEditingController title;
  bool showTitle;

  /// Verknüpftes Unterrezept (roh, mind. id/slug/name) statt Lebensmittel.
  Map<String, dynamic>? linkedRecipe;

  final List<DraftSubstitution> substitutions;
  bool showSubstitutions;

  /// Vom Parser/Autocomplete bereits aufgelöste Server-Objekte (mit id) —
  /// gelten, solange der Feldtext noch deren Namen trägt.
  Map<String, dynamic>? resolvedFood;
  Map<String, dynamic>? resolvedUnit;

  /// Lokaler Schlüssel (Umsortieren) — unabhängig von der referenceId.
  final String uid = newUuid();

  late final String _initQuantity;
  late final String _initUnit;
  late final String _initFood;
  late final String _initNote;

  DraftIngredient._({
    required this.raw,
    required this.referenceId,
    required this.quantity,
    required this.unit,
    required this.food,
    required this.note,
    required this.title,
    required this.showTitle,
    required this.linkedRecipe,
    required this.substitutions,
  }) : showSubstitutions = substitutions.isNotEmpty {
    _initQuantity = quantity.text;
    _initUnit = unit.text;
    _initFood = food.text;
    _initNote = note.text;
  }

  factory DraftIngredient.fromRaw(Map<String, dynamic> raw) {
    final foodObj = raw['food'];
    final linked = foodObj == null && raw['referencedRecipe'] is Map
        ? Map<String, dynamic>.from(raw['referencedRecipe'] as Map)
        : null;
    final t = _str(raw['title'])?.trim() ?? '';
    return DraftIngredient._(
      raw: raw,
      referenceId: _str(raw['referenceId']) ?? newUuid(),
      quantity: TextEditingController(
          text: formatDraftQuantity(raw['quantity'] as num?)),
      unit: TextEditingController(text: _name(raw['unit'])),
      food: TextEditingController(text: linked != null ? '' : _name(foodObj)),
      note: TextEditingController(text: _str(raw['note']) ?? ''),
      title: TextEditingController(text: t),
      showTitle: t.isNotEmpty,
      linkedRecipe: linked,
      substitutions: [
        for (final s in _maps(raw['substitutions'])) DraftSubstitution(raw: s)
      ],
    );
  }

  factory DraftIngredient.empty({bool section = false, String note = ''}) =>
      DraftIngredient._(
        raw: {},
        referenceId: newUuid(),
        quantity: TextEditingController(),
        unit: TextEditingController(),
        food: TextEditingController(),
        note: TextEditingController(text: note),
        title: TextEditingController(),
        showTitle: section,
        linkedRecipe: null,
        substitutions: [],
      );

  bool get isNew => raw.isEmpty;

  String get linkedName => _name(linkedRecipe);

  /// Unstrukturiert = kein Lebensmittel und kein Unterrezept (Freitext in
  /// der Notiz) — Kandidat für den Zutaten-Parser.
  bool get isUnparsed =>
      linkedRecipe == null &&
      food.text.trim().isEmpty &&
      note.text.trim().isNotEmpty;

  /// Lesbare Zeile (Verknüpfen-Sheet, Parser-Eingabe).
  String get displayText => [
        quantity.text.trim(),
        unit.text.trim(),
        linkedRecipe != null ? linkedName : food.text.trim(),
        note.text.trim(),
      ].where((p) => p.isNotEmpty).join(' ');

  /// Text für den Zutaten-Parser — wie die Webapp: der Import-Originaltext,
  /// bei unstrukturierten Zutaten sonst nur die Notiz (die Menge davor
  /// ergäbe „1 200 g Mehl"). Nach eigener Bearbeitung zählt der neue Text.
  String get parserInput {
    final edited = quantity.text != _initQuantity ||
        unit.text != _initUnit ||
        food.text != _initFood ||
        note.text != _initNote;
    final original = (_str(raw['originalText']) ?? '').trim();
    if (original.isNotEmpty && !edited) return original;
    if (unit.text.trim().isEmpty && food.text.trim().isEmpty) {
      return note.text.trim();
    }
    return displayText;
  }

  bool get foodChanged => food.text.trim() != _initFood.trim();
  bool get unitChanged => unit.text.trim() != _initUnit.trim();

  /// Schreibt die Payload das Lebensmittel/die Einheit neu (statt den
  /// Roh-Wert zu behalten)? Dann muss der Name auf dem Server existieren.
  bool get writesFood =>
      linkedRecipe == null &&
      (foodChanged || !raw.containsKey('food') || raw['food'] == null);
  bool get writesUnit => unitChanged || !raw.containsKey('unit');

  bool get isEmpty =>
      displayText.isEmpty &&
      title.text.trim().isEmpty &&
      substitutions.every((s) => s.isEmpty);

  String get signature => [
        referenceId,
        quantity.text,
        unit.text,
        food.text,
        note.text,
        showTitle ? title.text : '',
        linkedRecipe?['id'] ?? '',
        for (final s in substitutions) s.signature,
      ].join('¦');

  /// Payload-Eintrag: Roh-Eintrag + bearbeitete Felder.
  Map<String, dynamic> payload({
    required DraftCaps caps,
    required bool noteOnly,
    required Map<String, dynamic>? Function(String name) findFood,
    required Map<String, dynamic>? Function(String name) findUnit,
  }) {
    final m = Map<String, dynamic>.from(raw)
      // Anzeige-Text berechnet Mealie neu — ein alter Wert bliebe sonst
      // trotz geänderter Menge stehen.
      ..remove('display');
    m['referenceId'] = referenceId;
    final t = showTitle ? title.text.trim() : '';
    m['title'] = t.isEmpty ? null : t;
    m['note'] = note.text.trim();

    if (noteOnly) {
      // Alte Server, „Zutatenmengen deaktivieren": nur die Notiz zählt.
      if (caps.legacyAmountFlags) {
        m['disableAmount'] = true;
        m['isFood'] = false;
      }
      return m;
    }

    // Menge: unverändert → Rohwert behalten (keine Rundungsdrift).
    if (quantity.text != _initQuantity || !raw.containsKey('quantity')) {
      m['quantity'] = parseDraftQuantity(quantity.text) ?? 0;
    }
    final unitName = unit.text.trim();
    if (writesUnit) {
      m['unit'] = unitName.isEmpty
          ? null
          : (resolvedUnit != null && _name(resolvedUnit) == unitName
              ? resolvedUnit
              : findUnit(unitName) ?? {'name': unitName});
    }
    if (linkedRecipe != null) {
      m['food'] = null;
      m['referencedRecipe'] = linkedRecipe;
    } else {
      m['referencedRecipe'] = null;
      final foodName = food.text.trim();
      if (writesFood) {
        m['food'] = foodName.isEmpty
            ? null
            : (resolvedFood != null && _name(resolvedFood) == foodName
                ? resolvedFood
                : findFood(foodName) ?? {'name': foodName});
      }
    }
    if (caps.substitutions) {
      m['substitutions'] = [
        for (final s in substitutions)
          if (!s.isEmpty) s.payload(findFood)
      ];
    }
    if (caps.legacyAmountFlags) {
      m['isFood'] = m['food'] != null;
      m['disableAmount'] = false;
    }
    return m;
  }

  void dispose() {
    quantity.dispose();
    unit.dispose();
    food.dispose();
    note.dispose();
    title.dispose();
    for (final s in substitutions) {
      s.dispose();
    }
  }
}

// ---------------------------------------------------------------------------
// Schritte
// ---------------------------------------------------------------------------

class DraftStep {
  Map<String, dynamic> raw;

  /// Lokaler Schlüssel (Umsortieren) — die Server-id bleibt im Roh-Eintrag.
  final String uid = newUuid();
  final TextEditingController text;
  final TextEditingController title;
  final TextEditingController summary;
  bool showTitle;
  bool preview = false;

  /// Verknüpfte Zutaten / Notizen (referenceIds).
  final List<String> ingredientRefs;
  final List<String> noteRefs;

  DraftStep._({
    required this.raw,
    required this.text,
    required this.title,
    required this.summary,
    required this.showTitle,
    required this.ingredientRefs,
    required this.noteRefs,
  });

  factory DraftStep.fromRaw(Map<String, dynamic> raw) {
    final t = _str(raw['title'])?.trim() ?? '';
    return DraftStep._(
      raw: raw,
      text: TextEditingController(text: _str(raw['text']) ?? ''),
      title: TextEditingController(text: t),
      summary: TextEditingController(text: _str(raw['summary']) ?? ''),
      showTitle: t.isNotEmpty,
      ingredientRefs: _refIds(raw['ingredientReferences']),
      noteRefs: _refIds(raw['noteReferences']),
    );
  }

  factory DraftStep.empty({bool section = false, String text = ''}) =>
      DraftStep._(
        raw: {},
        text: TextEditingController(text: text),
        title: TextEditingController(),
        summary: TextEditingController(),
        showTitle: section,
        ingredientRefs: [],
        noteRefs: [],
      );

  String? get serverId => _str(raw['id']);

  bool get isEmpty =>
      text.text.trim().isEmpty &&
      summary.text.trim().isEmpty &&
      (!showTitle || title.text.trim().isEmpty);

  String get signature => [
        serverId ?? uid,
        text.text,
        summary.text,
        showTitle ? title.text : '',
        ingredientRefs.join(','),
        noteRefs.join(','),
      ].join('¦');

  Map<String, dynamic> payload({
    required DraftCaps caps,
    required Set<String> ingredientIds,
    required Set<String> noteIds,
  }) {
    final m = Map<String, dynamic>.from(raw);
    m['text'] = text.text.trim();
    final t = showTitle ? title.text.trim() : '';
    m['title'] = t;
    m['summary'] = summary.text.trim();
    m['ingredientReferences'] =
        _refPayload(raw['ingredientReferences'], ingredientRefs, ingredientIds);
    if (caps.noteReferences) {
      m['noteReferences'] =
          _refPayload(raw['noteReferences'], noteRefs, noteIds);
    }
    return m;
  }

  void dispose() {
    text.dispose();
    title.dispose();
    summary.dispose();
  }
}

List<String> _refIds(dynamic raw) {
  if (raw is! List) return [];
  final out = <String>[];
  for (final e in raw) {
    final id = e is Map ? _str(e['referenceId']) : _str(e);
    if (id != null && id.isNotEmpty && !out.contains(id)) out.add(id);
  }
  return out;
}

/// Verknüpfungen: Roh-Einträge behalten (mögliche Zusatzfelder), neue als
/// `{referenceId}` — nur auf Ziele, die mitgespeichert werden.
List<Map<String, dynamic>> _refPayload(
    dynamic raw, List<String> ids, Set<String> valid) {
  final byId = <String, Map<String, dynamic>>{};
  if (raw is List) {
    for (final e in raw) {
      if (e is Map && e['referenceId'] != null) {
        byId[e['referenceId'].toString()] = Map<String, dynamic>.from(e);
      }
    }
  }
  return [
    for (final id in ids)
      if (valid.contains(id)) byId[id] ?? {'referenceId': id}
  ];
}

// ---------------------------------------------------------------------------
// Notizen
// ---------------------------------------------------------------------------

class DraftNote {
  Map<String, dynamic> raw;
  final String uid = newUuid();

  /// Ziel der Notiz-Verknüpfungen an Schritten (Mealie 3.28).
  final String referenceId;
  final TextEditingController title;
  final TextEditingController text;

  DraftNote._(this.raw, this.referenceId, this.title, this.text);

  factory DraftNote.fromRaw(Map<String, dynamic> raw) => DraftNote._(
        raw,
        _str(raw['referenceId']) ?? newUuid(),
        TextEditingController(text: _str(raw['title']) ?? ''),
        TextEditingController(text: _str(raw['text']) ?? ''),
      );

  factory DraftNote.empty() => DraftNote._(
      {}, newUuid(), TextEditingController(), TextEditingController());

  bool get isEmpty => title.text.trim().isEmpty && text.text.trim().isEmpty;

  String get label {
    final t = title.text.trim();
    return t.isNotEmpty ? t : text.text.trim();
  }

  String get signature => '$referenceId|${title.text}|${text.text}';

  Map<String, dynamic> payload(DraftCaps caps) {
    final m = Map<String, dynamic>.from(raw);
    m['title'] = title.text.trim();
    m['text'] = text.text.trim();
    if (caps.noteReferences) m['referenceId'] = referenceId;
    return m;
  }

  void dispose() {
    title.dispose();
    text.dispose();
  }
}

// ---------------------------------------------------------------------------
// Einstellungen & Nährwerte
// ---------------------------------------------------------------------------

/// Rezept-Einstellungen in Webapp-Reihenfolge. `disableAmount` gibt es nur
/// bei Servern vor Mealie 3.28.
const kRecipeSettingKeys = [
  'public',
  'showNutrition',
  'showAssets',
  'landscapeView',
  'disableComments',
  'disableAmount',
  'locked',
];

/// Mealie-Defaults, falls ein Server ein Feld nicht mitliefert.
const _kSettingDefaults = {
  'public': false,
  'showNutrition': false,
  'showAssets': false,
  'landscapeView': false,
  'disableComments': true,
  'disableAmount': false,
  'locked': false,
};

// ---------------------------------------------------------------------------
// Der Entwurf
// ---------------------------------------------------------------------------

class RecipeDraft {
  /// Roh-JSON des Rezepts (vom Server; ohne Verbindung aus dem Cache).
  Map<String, dynamic> raw;

  /// true = Rohdaten vom Server; false = aus dem lokalen Cache abgeleitet
  /// (dann fehlen neue Felder wie Ersatzzutaten → die bleiben unangetastet).
  final bool complete;
  final DraftCaps caps;

  /// Mealie-Version des Servers (Fähigkeiten bei leeren Listen).
  final String? serverVersion;

  final TextEditingController name;
  final TextEditingController description;
  final TextEditingController orgUrl;
  final TextEditingController servings;
  final TextEditingController yieldQuantity;
  final TextEditingController yieldText;
  final DraftTime prep;
  final DraftTime perform;
  final DraftTime total;

  final List<DraftIngredient> ingredients;
  final List<DraftStep> steps;
  final List<DraftNote> notes;

  /// Kategorien / Schlagworte / Utensilien als Roh-Objekte (id, name, slug …).
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> tags;
  final List<Map<String, dynamic>> tools;

  final Map<String, TextEditingController> nutrition;
  final Map<String, bool> settings;
  String? userId;

  /// API-Extras (Schlüssel/Wert, nur „Erweitert").
  final List<(TextEditingController, TextEditingController)> extras;

  late final String _initialSignature;
  late final Map<String, bool> _initSettings;
  late final String? _initUserId;
  late final String _initExtras;
  late final Map<String, String> _initNutrition;
  late final String _initServings;
  late final String _initYieldQty;
  late final String _initYieldText;
  late final String _initOrgUrl;

  RecipeDraft._({
    required this.raw,
    required this.complete,
    required this.caps,
    required this.serverVersion,
    required this.name,
    required this.description,
    required this.orgUrl,
    required this.servings,
    required this.yieldQuantity,
    required this.yieldText,
    required this.prep,
    required this.perform,
    required this.total,
    required this.ingredients,
    required this.steps,
    required this.notes,
    required this.categories,
    required this.tags,
    required this.tools,
    required this.nutrition,
    required this.settings,
    required this.userId,
    required this.extras,
  }) {
    _initialSignature = signature;
    _initSettings = Map.of(settings);
    _initUserId = userId;
    _initExtras = _extrasSignature;
    _initNutrition = {for (final e in nutrition.entries) e.key: e.value.text};
    _initServings = servings.text;
    _initYieldQty = yieldQuantity.text;
    _initYieldText = yieldText.text;
    _initOrgUrl = orgUrl.text;
  }

  /// Entwurf aus Server-Rohdaten ([complete]) bzw. Cache-JSON.
  factory RecipeDraft.fromRaw(Map<String, dynamic> raw,
      {bool complete = true, String? serverVersion}) {
    final caps = DraftCaps.fromRaw(raw, version: serverVersion);
    final s = raw['settings'] is Map
        ? Map<String, dynamic>.from(raw['settings'] as Map)
        : <String, dynamic>{};
    final nutritionRaw = raw['nutrition'] is Map
        ? Map<String, dynamic>.from(raw['nutrition'] as Map)
        : <String, dynamic>{};
    final extrasRaw = raw['extras'] is Map
        ? Map<String, dynamic>.from(raw['extras'] as Map)
        : <String, dynamic>{};
    final servingsNum = raw['recipeServings'] as num?;
    return RecipeDraft._(
      raw: raw,
      complete: complete,
      caps: caps,
      serverVersion: serverVersion,
      name: TextEditingController(text: _str(raw['name']) ?? ''),
      description: TextEditingController(text: _str(raw['description']) ?? ''),
      orgUrl: TextEditingController(
          text: _str(raw['orgURL'] ?? raw['orgUrl']) ?? ''),
      servings: TextEditingController(text: formatDraftQuantity(servingsNum)),
      yieldQuantity: TextEditingController(
          text: formatDraftQuantity(raw['recipeYieldQuantity'] as num?)),
      yieldText: TextEditingController(text: _str(raw['recipeYield']) ?? ''),
      prep: DraftTime('prepTime', raw,
          seconds: caps.timeSeconds,
          fallbackMinutes: (raw['prepTimeMinutes'] as num?)?.toInt()),
      perform: DraftTime('performTime', raw,
          seconds: caps.timeSeconds,
          fallbackMinutes: (raw['performTimeMinutes'] as num?)?.toInt()),
      total: DraftTime('totalTime', raw,
          seconds: caps.timeSeconds,
          fallbackMinutes: (raw['totalTimeMinutes'] as num?)?.toInt()),
      ingredients: [
        for (final i in _ingredientMaps(raw['recipeIngredient']))
          DraftIngredient.fromRaw(i)
      ],
      steps: [
        for (final st in _maps(raw['recipeInstructions'])) DraftStep.fromRaw(st)
      ],
      notes: [for (final n in _maps(raw['notes'])) DraftNote.fromRaw(n)],
      categories: _maps(raw['recipeCategory']),
      tags: _maps(raw['tags']),
      tools: _maps(raw['tools']),
      nutrition: {
        for (final k in kNutritionKeys)
          k: TextEditingController(text: _str(nutritionRaw[k]) ?? ''),
      },
      settings: {
        for (final k in kRecipeSettingKeys)
          if (s.containsKey(k) || k != 'disableAmount')
            k: s[k] is bool ? s[k] as bool : _kSettingDefaults[k]!,
      },
      userId: _str(raw['userId']),
      extras: [
        for (final e in extrasRaw.entries)
          (
            TextEditingController(text: e.key),
            TextEditingController(text: e.value?.toString() ?? '')
          )
      ],
    );
  }

  /// Ohne Verbindung: Entwurf aus dem Cache-Rezept. Neue Felder fehlen dort
  /// und werden beim Speichern nicht angefasst ([complete] = false).
  factory RecipeDraft.fromCache(RecipeDetail r, {String? serverVersion}) {
    final j = r.toJson();
    final raw = <String, dynamic>{
      'id': r.id,
      'slug': r.slug,
      'name': r.name,
      'description': r.description,
      'recipeServings': r.servings ?? 0,
      'recipeYield': r.rawYield,
      'prepTimeMinutes': r.prepTime,
      'performTimeMinutes': r.cookTime,
      'totalTimeMinutes': r.totalTime,
      'orgURL': r.orgUrl,
      'userId': r.userId,
      'recipeIngredient': j['recipeIngredient'],
      'recipeInstructions': [
        for (final st in r.recipeInstructions)
          {
            if (st.id != null) 'id': st.id,
            'text': st.text,
            'title': st.title ?? '',
            'summary': st.summary ?? '',
            'ingredientReferences': [
              for (final id in st.ingredientRefs) {'referenceId': id}
            ],
          }
      ],
      'notes': [
        for (final n in r.notes) {'title': n.title, 'text': n.text}
      ],
      'recipeCategory': [for (final c in r.recipeCategory) c.toJson()],
      'tags': [for (final t in r.tags) t.toJson()],
      'tools': [
        for (final t in r.tools) {'id': t.id, 'name': t.name, 'slug': t.slug}
      ],
      'nutrition': r.nutrition,
      if (r.settings != null)
        'settings': r.settings!.toJson()..remove('disableAmount'),
    };
    return RecipeDraft.fromRaw(raw,
        complete: false, serverVersion: serverVersion);
  }

  static List<Map<String, dynamic>> _ingredientMaps(dynamic raw) {
    if (raw is! List) return const [];
    return [
      for (final e in raw)
        if (e is Map)
          Map<String, dynamic>.from(e)
        else if (e is String && e.trim().isNotEmpty)
          {'note': e.trim()}
    ];
  }

  String get id => _str(raw['id']) ?? '';
  String get slug => _str(raw['slug']) ?? '';

  /// Alte Server mit „Zutatenmengen deaktivieren": nur Notiz-Felder.
  bool get noteOnlyIngredients =>
      caps.legacyAmountFlags && (settings['disableAmount'] ?? false);

  String get _extrasSignature => [
        for (final (k, v) in extras) '${k.text}=${v.text}',
      ].join('¦');

  /// Fingerabdruck aller Eingaben — für „Änderungen verwerfen?".
  String get signature => [
        name.text,
        description.text,
        orgUrl.text,
        servings.text,
        yieldQuantity.text,
        yieldText.text,
        prep.signature,
        perform.signature,
        total.signature,
        for (final i in ingredients) i.signature,
        '#',
        for (final s in steps) s.signature,
        '#',
        for (final n in notes) n.signature,
        '#',
        for (final c in categories) c['id'],
        '#',
        for (final t in tags) t['id'],
        '#',
        for (final t in tools) t['id'],
        for (final e in nutrition.entries) '${e.key}=${e.value.text}',
        jsonEncode(settings),
        userId ?? '',
        _extrasSignature,
      ].join('\n');

  bool get isDirty => signature != _initialSignature;

  /// Vor dem Speichern: aktuellen Server-Stand als Basis übernehmen, damit
  /// auch zwischenzeitliche Server-Änderungen an unbearbeiteten Feldern
  /// (und — bei Cache-Entwürfen — alle unbekannten Felder) erhalten bleiben.
  void rebase(Map<String, dynamic> fresh) {
    raw = fresh;
    final ingById = {
      for (final i in _ingredientMaps(fresh['recipeIngredient']))
        if (i['referenceId'] != null) i['referenceId'].toString(): i
    };
    for (final i in ingredients) {
      final f = ingById[i.referenceId];
      if (f != null) i.raw = f;
    }
    final stepById = {
      for (final s in _maps(fresh['recipeInstructions']))
        if (s['id'] != null) s['id'].toString(): s
    };
    for (final s in steps) {
      final id = s.serverId;
      final f = id == null ? null : stepById[id];
      if (f != null) s.raw = f;
    }
    final noteById = {
      for (final n in _maps(fresh['notes']))
        if (n['referenceId'] != null) n['referenceId'].toString(): n
    };
    for (final n in notes) {
      final f = noteById[n.referenceId];
      if (f != null) {
        n.raw = f;
      } else if (!complete && n.raw.isNotEmpty) {
        // Cache-Notizen kennen keine referenceId: per Inhalt zuordnen.
        for (final c in _maps(fresh['notes'])) {
          if (c['title'] == n.raw['title'] && c['text'] == n.raw['text']) {
            n.raw = c;
            break;
          }
        }
      }
    }
  }

  /// Kategorien/Schlagworte/Utensilien: Roh-Objekt behalten, wenn es schon
  /// am Rezept hing (enthält evtl. mehr Felder), sonst das neue.
  List<Map<String, dynamic>> _organizers(
      List<Map<String, dynamic>> selected, String key) {
    final rawById = {
      for (final o in _maps(raw[key]))
        if (o['id'] != null) o['id'].toString(): o
    };
    return [for (final o in selected) rawById[o['id']?.toString()] ?? o];
  }

  /// PATCH-Payload. [formatDuration] = Zeittext für ältere Server
  /// (App-Sprache); [findFood]/[findUnit] lösen Namen in Server-Objekte auf.
  Map<String, dynamic> buildPayload({
    required String Function(int minutes) formatDuration,
    required Map<String, dynamic>? Function(String name) findFood,
    required Map<String, dynamic>? Function(String name) findUnit,
  }) {
    final server = DraftCaps.fromRaw(raw, version: serverVersion);
    final c = complete
        ? server.and(caps)
        : server.and(DraftCaps(
            // Cache-Entwurf: nur, was er wirklich kennt. Zeiten schreibt er
            // im Format des Servers (Sekunden ohne Zusatztext, sonst Text).
            timeSeconds: true,
            yieldQuantity: caps.yieldQuantity,
            legacyAmountFlags: true,
          ));
    final noteOnly =
        c.legacyAmountFlags && (settings['disableAmount'] ?? false);

    final ingPayload = [
      for (final i in ingredients)
        if (!i.isEmpty)
          i.payload(
              caps: c,
              noteOnly: noteOnly,
              findFood: findFood,
              findUnit: findUnit)
    ];
    final notePayload = [
      for (final n in notes)
        if (!n.isEmpty) n.payload(c)
    ];
    final ingIds = {
      for (final i in ingPayload) i['referenceId'].toString(),
    };
    final noteIds = {
      for (final n in notePayload)
        if (n['referenceId'] != null) n['referenceId'].toString(),
    };

    final p = <String, dynamic>{
      'id': raw['id'],
      'slug': raw['slug'],
      'name': name.text.trim(),
      'description': description.text.trim(),
      'recipeIngredient': ingPayload,
      'recipeInstructions': [
        for (final s in steps)
          if (!s.isEmpty)
            s.payload(caps: c, ingredientIds: ingIds, noteIds: noteIds)
      ],
      'notes': notePayload,
      'recipeCategory': _organizers(categories, 'recipeCategory'),
      'tags': _organizers(tags, 'tags'),
      'tools': _organizers(tools, 'tools'),
      ...prep.payload(c, formatDuration),
      ...perform.payload(c, formatDuration),
      ...total.payload(c, formatDuration),
    };

    if (orgUrl.text != _initOrgUrl) {
      final u = orgUrl.text.trim();
      p['orgURL'] = u.isEmpty ? null : u;
    }
    if (servings.text != _initServings) {
      p['recipeServings'] = parseDraftQuantity(servings.text) ?? 0;
    }
    if (c.yieldQuantity && yieldQuantity.text != _initYieldQty) {
      p['recipeYieldQuantity'] = parseDraftQuantity(yieldQuantity.text) ?? 0;
    }
    if (yieldText.text != _initYieldText) {
      p['recipeYield'] = yieldText.text.trim();
    }

    final nutritionChanged =
        nutrition.entries.any((e) => e.value.text != _initNutrition[e.key]);
    if (nutritionChanged) {
      final base = raw['nutrition'] is Map
          ? Map<String, dynamic>.from(raw['nutrition'] as Map)
          : <String, dynamic>{};
      for (final e in nutrition.entries) {
        final v = e.value.text.trim();
        base[e.key] = v.isEmpty ? null : v;
      }
      p['nutrition'] = base;
    }

    // Einstellungen: nur bei Änderung (Sperren darf nur der Ersteller —
    // unverändert mitgeschickt wäre harmlos, aber unnötig).
    final settingsChanged =
        settings.entries.any((e) => _initSettings[e.key] != e.value);
    if (settingsChanged) {
      final base = raw['settings'] is Map
          ? Map<String, dynamic>.from(raw['settings'] as Map)
          : <String, dynamic>{};
      for (final e in settings.entries) {
        if (e.key == 'disableAmount' && !c.legacyAmountFlags) continue;
        base[e.key] = e.value;
      }
      p['settings'] = base;
    }

    if (userId != _initUserId && userId != null) p['userId'] = userId;

    if (complete && _extrasSignature != _initExtras) {
      p['extras'] = {
        for (final (k, v) in extras)
          if (k.text.trim().isNotEmpty) k.text.trim(): v.text,
      };
    }
    return p;
  }

  void dispose() {
    for (final ctrl in [
      name,
      description,
      orgUrl,
      servings,
      yieldQuantity,
      yieldText,
      ...nutrition.values,
    ]) {
      ctrl.dispose();
    }
    prep.dispose();
    perform.dispose();
    total.dispose();
    for (final i in ingredients) {
      i.dispose();
    }
    for (final s in steps) {
      s.dispose();
    }
    for (final n in notes) {
      n.dispose();
    }
    for (final (k, v) in extras) {
      k.dispose();
      v.dispose();
    }
  }
}
