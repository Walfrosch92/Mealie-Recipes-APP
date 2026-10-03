import 'package:json_annotation/json_annotation.dart';

part 'recipe_detail.g.dart';

// ---------------------------------------------------------------------------
// Top-level model
// ---------------------------------------------------------------------------

/// Aktuelle Version des lokalen Rezept-Cache-Formats. Hochzählen, wenn das
/// Modell ein Server-Feld NEU einliest: Cache-Einträge mit kleinerer Version
/// fehlt es noch, der automatische Abgleich lädt sie deshalb einmalig neu
/// (siehe `_reconcileWithServer`).
///   1 = alles vor 2026-09-26
///   2 = Zutaten-Abschnitte (`Ingredient.title`)
///   3 = Schritt-Überschriften (`Instruction.summary`)
///   4 = verlinkte Rezepte (`Ingredient.referencedRecipe`)
///   5 = Kommentare (`RecipeDetail.comments`)
///   6 = Zeiten korrekt aus Freitext („1 Stunde 55 Minuten" war 55 statt 115)
///   7 = Portionen/Ergibt getrennt + Zutaten-originalText (Editor-Speichern)
///   8 = Nährwerte (kamen als Objekt, wurden als Liste gelesen → leer)
///   9 = Anhänge (`RecipeDetail.assets`)
///  10 = Ersteller/Haushalt (`userId`, `householdId`) für Rechte-Prüfung
///  11 = Ursprüngliche URL (`orgURL`)
const int kRecipeCacheSchema = 11;

// Disable factory generation — we write our own robust fromJson below.
@JsonSerializable(explicitToJson: true, createFactory: false)
class RecipeDetail {
  final String id;
  final String slug;
  final String name;
  final String? description;
  final String? image;
  final String? dateAdded;
  final String? dateUpdated;

  /// „Zuletzt gekocht" (Mealie `lastMade`, ISO-8601-UTC-Timestamp). Wird in
  /// der Detailansicht angezeigt und beim Kochmodus-Abschluss (Toggle)
  /// über PATCH /recipes/{slug}/last-made aktualisiert.
  final String? lastMade;

  @JsonKey(fromJson: parseDuration, toJson: durationToString)
  final int? prepTime;
  @JsonKey(fromJson: parseDuration, toJson: durationToString)
  final int? cookTime;
  @JsonKey(fromJson: parseDuration, toJson: durationToString)
  final int? totalTime;

  @JsonKey(fromJson: _parseDouble)
  final double? rating;

  /// Anzeige-Wert „Portionen": der Ergibt-Text, sonst die Portionenzahl.
  final String? recipeYield;

  /// Rohwerte vom Server, getrennt gehalten, damit der Editor beide
  /// unverändert zurückschreiben kann: `recipeServings` (Zahl) und
  /// `recipeYield` (Freitext wie „ca. 500 ml"). Vorher wurden sie zu
  /// [recipeYield] verschmolzen — Speichern setzte dann bei Freitext die
  /// Portionen auf 0 bzw. kopierte die Zahl ins Ergibt-Feld.
  final double? servings;
  final String? rawYield;
  final RecipeSettings? settings;

  final List<Ingredient> recipeIngredient;
  final List<Instruction> recipeInstructions;

  /// Nährwerte pro Portion (Mealie `nutrition`, ein OBJEKT mit 11 Feldern,
  /// Werte als Text ohne Einheit). Nur gesetzte Felder, in [kNutritionKeys]-
  /// Reihenfolge. Vorher als Liste erwartet → kamen nie an.
  final Map<String, String> nutrition;
  final List<RecipeNote> notes;
  final List<CategorySummary> recipeCategory;
  final List<TagSummary> tags;
  final List<RecipeTool> tools;

  /// Mealie-Kommentare (mit Verfasser), älteste zuerst. Kommen im Rezept-
  /// Detail mit → auch offline sichtbar.
  final List<RecipeComment> comments;

  /// Rezept-Anhänge (Mealie `assets`: PDFs, Bilder, Textdateien). Die Datei
  /// liegt unter /api/media/recipes/{id}/assets/{fileName}.
  final List<RecipeAsset> assets;

  /// Ersteller und dessen Haushalt (Mealie `userId`/`householdId`) — für
  /// die Rechte-Prüfung (nur Ersteller/Admin dürfen löschen, gesperrte
  /// Rezepte nur der Ersteller bearbeiten). `null` bei alten Cache-Einträgen.
  final String? userId;
  final String? householdId;

  /// Ursprüngliche URL (Mealie `orgURL`) — Quelle, von der das Rezept
  /// importiert wurde. Detailansicht zeigt sie als Knopf.
  final String? orgUrl;

  /// Nur lokal (kein Mealie-Feld): mit welcher [kRecipeCacheSchema]-Version
  /// dieses Rezept vom Server eingelesen wurde. Gestempelt in
  /// `ApiService.fetchRecipeDetail`; ältere Cache-Einträge ohne Feld = 1.
  final int cacheSchema;

  const RecipeDetail({
    required this.id,
    required this.slug,
    required this.name,
    this.description,
    this.image,
    this.dateAdded,
    this.dateUpdated,
    this.lastMade,
    this.prepTime,
    this.cookTime,
    this.totalTime,
    this.rating,
    this.recipeYield,
    this.servings,
    this.rawYield,
    this.settings,
    this.recipeIngredient = const [],
    this.recipeInstructions = const [],
    this.nutrition = const {},
    this.notes = const [],
    this.recipeCategory = const [],
    this.tags = const [],
    this.tools = const [],
    this.comments = const [],
    this.assets = const [],
    this.userId,
    this.householdId,
    this.orgUrl,
    this.cacheSchema = 1,
  });

  /// Vollständig eigener Decoder — toleriert alle Typen die Mealie zurückgeben kann.
  /// Modelliert nach dem Swift-Decoder in RecipeDetail.swift.
  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    // cookTime: Mealie v3 sendet "performTime", v2.8 "cookTime"
    final cookRaw = json['performTime'] ?? json['cookTime'];

    // Zutaten: v3 → recipeIngredient, v2.8 → ingredientStrings
    final ingredientsRaw =
        json['recipeIngredient'] ?? json['ingredientStrings'];

    return RecipeDetail(
      id: _req(json['id']),
      slug: _req(json['slug']),
      name: _req(json['name']),
      description: _safeString(json['description']),
      image: _safeString(json['image']),
      dateAdded: _safeString(json['dateAdded']),
      dateUpdated: _safeString(json['dateUpdated']),
      lastMade: _safeString(json['lastMade']),
      // Neuere Mealie-Versionen speichern Zeiten strukturiert in Sekunden
      // (der Text ist dann nur ein Zusatz wie „plus über Nacht").
      prepTime: _secondsOr(json['prepTimeSeconds'], json['prepTime']),
      cookTime: _secondsOr(json['performTimeSeconds'], cookRaw),
      totalTime: _secondsOr(json['totalTimeSeconds'], json['totalTime']),
      rating: _parseDouble(json['rating']),
      recipeYield: _yieldOrServings(json),
      servings: (json['recipeServings'] as num?)?.toDouble(),
      // Cache speichert den Rohwert extra (recipeYield dort = Anzeige-Wert).
      rawYield: json.containsKey('rawRecipeYield')
          ? _safeString(json['rawRecipeYield'])
          : _safeString(json['recipeYield']),
      settings: _safeMap(json['settings'], RecipeSettings.fromJson),
      recipeIngredient: _parseIngredients(ingredientsRaw),
      recipeInstructions: _parseInstructions(json['recipeInstructions']),
      nutrition: _parseNutrition(json['nutrition']),
      notes: _parseList(json['notes'], _parseNote),
      recipeCategory: _parseList(json['recipeCategory'], _parseCategory),
      tags: _parseList(json['tags'], _parseTag),
      tools: _parseList(json['tools'], _parseTool),
      comments: _parseList(json['comments'], RecipeComment.tryParse)
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
      assets: _parseList(json['assets'], RecipeAsset.tryParse),
      userId: _safeString(json['userId']),
      householdId: _safeString(json['householdId']),
      orgUrl: _safeString(json['orgURL'] ?? json['orgUrl']),
      cacheSchema: (json['cacheSchema'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() => _$RecipeDetailToJson(this);

  RecipeDetail copyWith({
    String? name,
    String? description,
    int? prepTime,
    int? cookTime,
    int? totalTime,
    double? rating,
    String? recipeYield,
    RecipeSettings? settings,
    List<Ingredient>? recipeIngredient,
    List<Instruction>? recipeInstructions,
    List<RecipeNote>? notes,
    List<CategorySummary>? recipeCategory,
    List<TagSummary>? tags,
    List<RecipeTool>? tools,
    List<RecipeComment>? comments,
    List<RecipeAsset>? assets,
    String? lastMade,
    int? cacheSchema,
  }) {
    return RecipeDetail(
      id: id,
      slug: slug,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image,
      dateAdded: dateAdded,
      dateUpdated: dateUpdated,
      lastMade: lastMade ?? this.lastMade,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      totalTime: totalTime ?? this.totalTime,
      rating: rating ?? this.rating,
      recipeYield: recipeYield ?? this.recipeYield,
      servings: servings,
      rawYield: rawYield,
      settings: settings ?? this.settings,
      recipeIngredient: recipeIngredient ?? this.recipeIngredient,
      recipeInstructions: recipeInstructions ?? this.recipeInstructions,
      nutrition: nutrition,
      notes: notes ?? this.notes,
      recipeCategory: recipeCategory ?? this.recipeCategory,
      tags: tags ?? this.tags,
      tools: tools ?? this.tools,
      comments: comments ?? this.comments,
      assets: assets ?? this.assets,
      userId: userId,
      householdId: householdId,
      orgUrl: orgUrl,
      cacheSchema: cacheSchema ?? this.cacheSchema,
    );
  }
}

// ---------------------------------------------------------------------------
// Duration helpers (ISO-8601 PT1H30M or plain "90")
// ---------------------------------------------------------------------------

int? parseDuration(dynamic raw) {
  if (raw == null) return null;
  if (raw is int) return raw;
  var s = raw.toString().trim();
  if (s.isEmpty) return null;
  s = _replaceFractionGlyphs(s);

  // ISO 8601 duration
  if (s.startsWith('P') || s.startsWith('p')) {
    int total = 0;
    final hoursMatch = RegExp(r'(\d+)H').firstMatch(s);
    final minsMatch = RegExp(r'(\d+)M').firstMatch(s);
    if (hoursMatch != null) total += int.parse(hoursMatch.group(1)!) * 60;
    if (minsMatch != null) total += int.parse(minsMatch.group(1)!);
    return total == 0 ? null : total;
  }

  // Reine Zahl = Minuten (so speichert die App selbst im Cache).
  final plain = int.tryParse(raw.toString().trim());
  if (plain != null) return plain;

  // „1:30" = Stunden:Minuten
  final colon = RegExp(r'^(\d+):(\d{1,2})$').firstMatch(s);
  if (colon != null) {
    return int.parse(colon.group(1)!) * 60 + int.parse(colon.group(2)!);
  }

  // Freitext, wie ihn Mealie in der Sprache des Servers speichert:
  // „1 Stunde 55 Minuten", „1 hour 30 min", „1h30", „1,5 Stunden",
  // „2 heures", „1 óra 20 perc" … Vorher wurden Stunden nur als „h" direkt
  // hinter der Zahl erkannt — „1 Stunde 55 Minuten" ergab 55 statt 115.
  var total = 0.0;
  var found = false;
  for (final m
      in RegExp(r'(\d+(?:[.,]\d+)?)\s*([^\d\s.,:;/()-]*)').allMatches(s)) {
    final value = double.parse(m.group(1)!.replaceAll(',', '.'));
    final unit = m.group(2)!.toLowerCase();
    final factor = _durationUnitMinutes(unit);
    if (factor == null) continue;
    total += value * factor;
    found = true;
    // „1h30": Minuten ohne eigene Einheit direkt hinter den Stunden
    if (factor == 60) {
      final rest = s.substring(m.end);
      final tail = RegExp(r'^\s*(\d{1,2})\s*$').firstMatch(rest);
      if (tail != null) {
        total += int.parse(tail.group(1)!);
        break;
      }
    }
  }
  if (!found) return null;
  final minutes = total.round();
  return minutes == 0 ? null : minutes;
}

/// „1 ½ Stunden" → „1.5 Stunden", „½ Stunde" → „0.5 Stunde".
String _replaceFractionGlyphs(String s) {
  const glyphs = {'½': .5, '¼': .25, '¾': .75, '⅓': 1 / 3, '⅔': 2 / 3};
  return s.replaceAllMapped(RegExp(r'(\d+)?\s*([½¼¾⅓⅔])'), (m) {
    final whole = m.group(1) == null ? 0 : int.parse(m.group(1)!);
    final v = whole + glyphs[m.group(2)]!;
    return v.toStringAsFixed(3);
  });
}

/// Minuten pro Einheit eines Zeitworts (null = keine Zeiteinheit). Präfix-
/// basiert über die App-Sprachen + Englisch: Tage, Stunden, Minuten.
int? _durationUnitMinutes(String unit) {
  if (unit.isEmpty) return null;
  bool any(List<String> prefixes) => prefixes.any(unit.startsWith);
  // Tage (Tag, day, jour, día/dia, dag, dzień/dni, nap, dan)
  if (unit == 'd' ||
      any([
        'tag',
        'day',
        'jour',
        'día',
        'dia',
        'dag',
        'dzie',
        'dni',
        'nap',
        'dan'
      ])) {
    return 1440;
  }
  // Stunden (Stunde/Std/h, hour/hr, heure, hora, uur/uren, ora/ore,
  // godz(ina), óra, ura/uri/ure/ur (sl), time/timer)
  if (any([
    'h',
    'std',
    'stund',
    'heure',
    'hora',
    'uur',
    'uren',
    'ora',
    'ore',
    'godz',
    'óra',
    'ur',
    'tim'
  ])) {
    return 60;
  }
  // Minuten (min, minute/n, minuto, minut, minutter, mn, perc, m)
  if (any(['m', 'perc'])) return 1;
  return null;
}

String? durationToString(int? minutes) => minutes?.toString();

/// Minuten aus `…TimeSeconds` (falls gesetzt), sonst aus dem Zeittext.
int? _secondsOr(dynamic seconds, dynamic text) {
  if (seconds is num && seconds > 0) {
    final m = (seconds / 60).round();
    return m == 0 ? 1 : m;
  }
  return parseDuration(text);
}

double? _parseDouble(dynamic raw) {
  if (raw == null) return null;
  if (raw is num) return raw.toDouble();
  return double.tryParse(raw.toString());
}

// Required string — throws if missing (id/slug/name must always exist)
String _req(dynamic v) => v?.toString() ?? '';

// Safe nullable string — converts numbers to string, returns null for null/empty
String? _safeString(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

/// Portionen-Anzeige: bevorzugt den String `recipeYield`; ist der leer (so wie
/// es moderne Mealie-Versionen liefern), fällt auf die Zahl `recipeServings`
/// zurück. Damit zeigt die App die Portionen auch dann, wenn der Server sie nur
/// noch numerisch in `recipeServings` führt.
String? _yieldOrServings(Map<String, dynamic> json) {
  final y = _safeString(json['recipeYield']);
  if (y != null) return y;
  final s = json['recipeServings'];
  if (s is num && s > 0) {
    return s == s.truncate() ? s.truncate().toString() : s.toString();
  }
  return null;
}

// Generic safe list parser — skips entries that throw
List<T> _parseList<T>(dynamic raw, T? Function(dynamic) parse) {
  if (raw == null || raw is! List) return [];
  final result = <T>[];
  for (final e in raw) {
    try {
      final v = parse(e);
      if (v != null) result.add(v);
    } catch (_) {}
  }
  return result;
}

// Safe map decoder helper
T? _safeMap<T>(dynamic raw, T Function(Map<String, dynamic>) parse) {
  if (raw == null || raw is! Map) return null;
  try {
    return parse(Map<String, dynamic>.from(raw));
  } catch (_) {
    return null;
  }
}

/// Mealie-Nährwertfelder in Anzeige-Reihenfolge (wie im Mealie-Web).
const List<String> kNutritionKeys = [
  'calories',
  'fatContent',
  'saturatedFatContent',
  'transFatContent',
  'unsaturatedFatContent',
  'cholesterolContent',
  'sodiumContent',
  'carbohydrateContent',
  'fiberContent',
  'sugarContent',
  'proteinContent',
];

Map<String, String> _parseNutrition(dynamic raw) {
  // Älterer App-Cache hatte hier eine (immer leere) Liste.
  if (raw is! Map) return const {};
  final result = <String, String>{};
  for (final key in kNutritionKeys) {
    final v = _safeString(raw[key]);
    if (v != null) result[key] = v;
  }
  return result;
}

RecipeNote? _parseNote(dynamic e) {
  if (e is! Map) return null;
  final m = Map<String, dynamic>.from(e);
  final title = _safeString(m['title']) ?? '';
  final text = _safeString(m['text']) ?? '';
  if (title.isEmpty && text.isEmpty) return null;
  return RecipeNote(title: title, text: text);
}

CategorySummary? _parseCategory(dynamic e) {
  if (e is! Map) return null;
  final m = Map<String, dynamic>.from(e);
  final id = _safeString(m['id']);
  final name = _safeString(m['name']);
  if (id == null || name == null) return null;
  return CategorySummary(
    id: id,
    name: name,
    slug: _safeString(m['slug']) ?? '',
  );
}

TagSummary? _parseTag(dynamic e) {
  if (e is! Map) return null;
  final m = Map<String, dynamic>.from(e);
  final id = _safeString(m['id']);
  final name = _safeString(m['name']);
  if (id == null || name == null) return null;
  return TagSummary(
    id: id,
    name: name,
    slug: _safeString(m['slug']) ?? '',
  );
}

RecipeTool? _parseTool(dynamic e) {
  if (e is! Map) return null;
  final m = Map<String, dynamic>.from(e);
  final id = _safeString(m['id']) ?? '';
  final name = _safeString(m['name']) ?? '';
  return RecipeTool(
    id: id,
    name: name,
    onHand: m['onHand'] as bool? ?? false,
    slug: _safeString(m['slug']) ?? '',
  );
}

// ---------------------------------------------------------------------------
// Ingredient parsing — tolerates String or Object for unit/food
// ---------------------------------------------------------------------------

List<Ingredient> _parseIngredients(dynamic raw) {
  if (raw == null || raw is! List) return [];
  final result = <Ingredient>[];
  for (final e in raw) {
    try {
      if (e is String) {
        if (e.isNotEmpty) result.add(Ingredient(note: e));
      } else if (e is Map) {
        result.add(Ingredient.fromJson(Map<String, dynamic>.from(e)));
      }
    } catch (_) {}
  }
  return result;
}

List<Instruction> _parseInstructions(dynamic raw) {
  if (raw == null || raw is! List) return [];
  final result = <Instruction>[];
  // Reine Überschrift-Schritte (Titel ohne Text) werden nicht als leere
  // Schritte angezeigt — ihr Titel wandert an den nächsten Schritt, sonst
  // ginge der Abschnitt verloren.
  String? pendingTitle;
  for (final e in raw) {
    try {
      if (e is String && e.isNotEmpty) {
        result.add(Instruction(text: e, title: pendingTitle));
        pendingTitle = null;
      } else if (e is Map) {
        final m = Map<String, dynamic>.from(e);
        final rawText = _safeString(m['text']) ?? '';
        final rawSummary = _safeString(m['summary']);
        // Schritt nur mit Überschrift und ohne Text: die Überschrift IST dann
        // der Inhalt (wie bisher), statt einen leeren Schritt zu zeigen.
        final text = rawText.isNotEmpty ? rawText : (rawSummary ?? '');
        final summary = rawText.isNotEmpty ? rawSummary : null;
        final title = _safeString(m['title'])?.trim();
        if (text.isNotEmpty) {
          result.add(Instruction(
            id: _safeString(m['id']),
            text: text,
            summary: summary,
            title: (title == null || title.isEmpty) ? pendingTitle : title,
            ingredientRefs: _parseIngredientRefs(m['ingredientReferences']),
          ));
          pendingTitle = null;
        } else if (title != null && title.isNotEmpty) {
          pendingTitle = title;
        }
      }
    } catch (_) {}
  }
  return result;
}

/// Zutaten-Verknüpfungen eines Schritts: der Server liefert Objekte
/// `{referenceId: uuid}`, der eigene Cache (toJson) nackte Strings — beides
/// wird zu einer String-Liste der referenceIds. Sie zeigen auf die
/// `referenceId`s in `recipeIngredient` und müssen beim Bearbeiten erhalten
/// bleiben (sonst verliert Mealie die Schritt↔Zutat-Zuordnung).
List<String> _parseIngredientRefs(dynamic raw) {
  if (raw == null || raw is! List) return [];
  final refs = <String>[];
  for (final e in raw) {
    if (e is String) {
      if (e.isNotEmpty) refs.add(e);
    } else if (e is Map) {
      final id = _safeString(e['referenceId']) ?? _safeString(e['id']);
      if (id != null) refs.add(id);
    }
  }
  return refs;
}

// ---------------------------------------------------------------------------
// Ingredient
// ---------------------------------------------------------------------------

@JsonSerializable(explicitToJson: true)
class Ingredient {
  /// Stable ID used for PATCH operations — must be preserved.
  final String? referenceId;
  @JsonKey(fromJson: _parseDouble)
  final double? quantity;

  @JsonKey(fromJson: _parseIngredientUnit, toJson: _ingredientUnitToJson)
  final IngredientUnit? unit;

  @JsonKey(fromJson: _parseIngredientFood, toJson: _ingredientFoodToJson)
  final IngredientFood? food;

  final String? note;
  final bool? isFood;
  final bool? disableAmount;

  /// Abschnittsüberschrift (Mealie „Abschnitt hinzufügen", z. B.
  /// „Knusperboden"). Steht an der ERSTEN Zutat eines Abschnitts und gilt bis
  /// zur nächsten Zutat mit Titel. Kann auch an einer sonst leeren Zutat
  /// hängen (reine Überschriftzeile, siehe [hasContent]).
  final String? title;

  /// Verlinktes Unterrezept (Mealie `referencedRecipe`, z. B. „Béchamelsauce"
  /// in der Lasagne). Mealie liefert das KOMPLETTE Rezept mit; gespeichert
  /// wird nur die Referenz (id/slug/name) — der Inhalt steht als eigenes
  /// Rezept ohnehin im Cache.
  @JsonKey(fromJson: _parseReferencedRecipe, toJson: _referencedRecipeToJson)
  final ReferencedRecipe? referencedRecipe;

  /// Ursprünglicher Import-Text der Zutat (Mealie `originalText`). Wird nur
  /// durchgereicht, damit Speichern im Editor ihn nicht löscht.
  final String? originalText;

  // Completion state (local only — not from API)
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isCompleted;

  const Ingredient({
    this.referenceId,
    this.quantity,
    this.unit,
    this.food,
    this.note,
    this.isFood,
    this.disableAmount,
    this.title,
    this.referencedRecipe,
    this.originalText,
    this.isCompleted = false,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  Ingredient copyWith({bool? isCompleted}) => Ingredient(
        referenceId: referenceId,
        quantity: quantity,
        unit: unit,
        food: food,
        note: note,
        isFood: isFood,
        disableAmount: disableAmount,
        title: title,
        referencedRecipe: referencedRecipe,
        originalText: originalText,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  /// Getrimmter Abschnittstitel, `null` wenn keiner gesetzt ist.
  String? get sectionTitle {
    final t = title?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  /// false = reine Überschriftzeile ohne Menge/Zutat/Notiz. Die wird nur als
  /// Abschnittstitel angezeigt, nicht als (leere) Zutat, und landet nie auf
  /// der Einkaufsliste.
  bool get hasContent => displayText.trim().isNotEmpty;

  String get displayText {
    final parts = <String>[];
    if (quantity != null && quantity! > 0) {
      parts.add(_formatQuantity(quantity!));
    }
    if (unit?.name != null && unit!.name!.isNotEmpty) parts.add(unit!.name!);
    if (food?.name != null && food!.name!.isNotEmpty) {
      parts.add(food!.name!);
    } else if (referencedRecipe != null) {
      parts.add(referencedRecipe!.name);
    }
    if (note != null && note!.isNotEmpty) parts.add(note!);
    return parts.join(' ');
  }
}

/// Mealie-Rezeptkommentar (RecipeCommentOut). Gespeichert wird dieselbe Form,
/// die der Server liefert, damit Cache und Server-JSON gleich geparst werden.
/// Rezept-Anhang (Mealie `RecipeAsset`): Anzeigename, mdi-Iconname aus der
/// Webapp und der serverseitige Dateiname.
class RecipeAsset {
  final String name;
  final String icon;
  final String fileName;

  const RecipeAsset(
      {required this.name, required this.icon, required this.fileName});

  static RecipeAsset? tryParse(dynamic raw) {
    if (raw is! Map) return null;
    final fileName = _safeString(raw['fileName'] ?? raw['file_name']);
    if (fileName == null || fileName.isEmpty) return null;
    return RecipeAsset(
      name: _safeString(raw['name']) ?? fileName,
      icon: _safeString(raw['icon']) ?? 'mdi-file',
      fileName: fileName,
    );
  }

  /// Dateiendung in Kleinbuchstaben (ohne Punkt).
  String get extension {
    final dot = fileName.lastIndexOf('.');
    return dot < 0 ? '' : fileName.substring(dot + 1).toLowerCase();
  }

  bool get isImage => const {'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'avif'}
      .contains(extension);

  bool get isPdf => extension == 'pdf';

  bool get isText => const {'txt', 'md', 'csv', 'json'}.contains(extension);

  Map<String, dynamic> toJson() =>
      {'name': name, 'icon': icon, 'fileName': fileName};
}

class RecipeComment {
  final String id;
  final String text;

  /// ISO-8601 (UTC) wie vom Server.
  final String createdAt;
  final String userId;

  /// Anzeigename: voller Name, sonst Benutzername.
  final String userName;

  const RecipeComment({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.userId,
    required this.userName,
  });

  static RecipeComment? tryParse(dynamic raw) {
    if (raw is! Map) return null;
    final id = _safeString(raw['id']);
    final text = _safeString(raw['text']);
    if (id == null || text == null) return null;
    final user = raw['user'] is Map ? raw['user'] as Map : const {};
    final full = _safeString(user['fullName'])?.trim() ?? '';
    final username = _safeString(user['username'])?.trim() ?? '';
    return RecipeComment(
      id: id,
      text: text,
      createdAt: _safeString(raw['createdAt']) ?? '',
      userId: _safeString(raw['userId']) ?? _safeString(user['id']) ?? '',
      userName: full.isNotEmpty ? full : username,
    );
  }

  DateTime? get createdAtLocal => DateTime.tryParse(createdAt.isEmpty ||
              createdAt.endsWith('Z') ||
              createdAt.contains('+')
          ? createdAt
          : '${createdAt}Z')
      ?.toLocal();

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'createdAt': createdAt,
        'userId': userId,
        'user': {'id': userId, 'fullName': userName},
      };
}

/// Verweis auf ein anderes Rezept (Mealie „Rezept als Zutat").
class ReferencedRecipe {
  final String id;
  final String slug;
  final String name;

  const ReferencedRecipe(
      {required this.id, required this.slug, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'slug': slug, 'name': name};
}

ReferencedRecipe? _parseReferencedRecipe(dynamic raw) {
  if (raw is! Map) return null;
  final id = _safeString(raw['id']);
  if (id == null || id.isEmpty) return null;
  return ReferencedRecipe(
    id: id,
    slug: _safeString(raw['slug']) ?? '',
    name: _safeString(raw['name']) ?? '',
  );
}

Map<String, dynamic>? _referencedRecipeToJson(ReferencedRecipe? r) =>
    r?.toJson();

String _formatQuantity(double q) {
  if (q == q.truncateToDouble()) return q.truncate().toString();
  // Common fractions
  final fractions = <double, String>{
    0.25: '¼',
    0.5: '½',
    0.75: '¾',
    0.33: '⅓',
    0.67: '⅔',
    0.125: '⅛',
    0.375: '⅜',
    0.625: '⅝',
    0.875: '⅞',
  };
  final whole = q.truncate();
  final frac = q - whole;
  for (final entry in fractions.entries) {
    if ((frac - entry.key).abs() < 0.01) {
      return whole > 0 ? '$whole${entry.value}' : entry.value;
    }
  }
  return q
      .toStringAsFixed(2)
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll(RegExp(r'\.$'), '');
}

// unit field can be null, String, or {id, name}
IngredientUnit? _parseIngredientUnit(dynamic raw) {
  if (raw == null) return null;
  if (raw is String) return IngredientUnit(id: null, name: raw);
  if (raw is Map<String, dynamic>) return IngredientUnit.fromJson(raw);
  return null;
}

Map<String, dynamic>? _ingredientUnitToJson(IngredientUnit? u) => u?.toJson();

IngredientFood? _parseIngredientFood(dynamic raw) {
  if (raw == null) return null;
  if (raw is String) return IngredientFood(id: null, name: raw);
  if (raw is Map<String, dynamic>) return IngredientFood.fromJson(raw);
  return null;
}

Map<String, dynamic>? _ingredientFoodToJson(IngredientFood? f) => f?.toJson();

@JsonSerializable()
class IngredientUnit {
  final String? id;
  final String? name;
  final String? pluralName;
  final String? abbreviation;

  const IngredientUnit(
      {this.id, this.name, this.pluralName, this.abbreviation});

  factory IngredientUnit.fromJson(Map<String, dynamic> json) =>
      _$IngredientUnitFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientUnitToJson(this);
}

@JsonSerializable()
class IngredientFood {
  final String? id;
  final String? name;
  final String? pluralName;

  const IngredientFood({this.id, this.name, this.pluralName});

  factory IngredientFood.fromJson(Map<String, dynamic> json) =>
      _$IngredientFoodFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientFoodToJson(this);
}

// ---------------------------------------------------------------------------
// Instruction
// ---------------------------------------------------------------------------

@JsonSerializable()
class Instruction {
  final String? id;
  final String text;

  /// Abschnittstitel (Mealie „Abschnitt", gilt bis zum nächsten Titel).
  final String? title;

  /// Überschrift DIESES Schritts (Mealie-Web zeigt sie statt „Schritt 1").
  final String? summary;
  @JsonKey(name: 'ingredientReferences')
  final List<String> ingredientRefs;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isCompleted;

  const Instruction({
    this.id,
    required this.text,
    this.title,
    this.summary,
    this.ingredientRefs = const [],
    this.isCompleted = false,
  });

  factory Instruction.fromJson(Map<String, dynamic> json) =>
      _$InstructionFromJson(json);

  Map<String, dynamic> toJson() => _$InstructionToJson(this);

  Instruction copyWith({bool? isCompleted}) => Instruction(
        id: id,
        text: text,
        title: title,
        summary: summary,
        ingredientRefs: ingredientRefs,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  /// Getrimmte Schritt-Überschrift, `null` wenn keine.
  String? get heading {
    final s = summary?.trim();
    return (s == null || s.isEmpty) ? null : s;
  }

  /// Getrimmter Abschnittstitel (Mealie „Abschnitt"), `null` wenn keiner.
  String? get sectionTitle {
    final t = title?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}

/// Abschnitt, zu dem Schritt [index] gehört: der letzte Titel an oder vor
/// diesem Schritt (in Mealie gilt ein Titel bis zum nächsten). `null`, wenn
/// davor keiner gesetzt ist.
String? instructionSectionAt(List<Instruction> steps, int index) {
  for (var i = index; i >= 0 && i < steps.length; i--) {
    final t = steps[i].sectionTitle;
    if (t != null) return t;
  }
  return null;
}

// ---------------------------------------------------------------------------
// Supporting types
// ---------------------------------------------------------------------------

@JsonSerializable()
class RecipeSettings {
  final bool public;
  final bool showNutrition;
  final bool showAssets;
  final bool landscapeView;
  final bool disableComments;
  final bool disableAmount;
  final bool locked;

  const RecipeSettings({
    this.public = false,
    this.showNutrition = false,
    this.showAssets = false,
    this.landscapeView = false,
    this.disableComments = true,
    this.disableAmount = false,
    this.locked = false,
  });

  factory RecipeSettings.fromJson(Map<String, dynamic> json) =>
      _$RecipeSettingsFromJson(json);

  RecipeSettings copyWith({bool? showAssets}) => RecipeSettings(
        public: public,
        showNutrition: showNutrition,
        showAssets: showAssets ?? this.showAssets,
        landscapeView: landscapeView,
        disableComments: disableComments,
        disableAmount: disableAmount,
        locked: locked,
      );

  Map<String, dynamic> toJson() => _$RecipeSettingsToJson(this);
}

@JsonSerializable()
class RecipeNote {
  final String title;
  final String text;

  const RecipeNote({required this.title, required this.text});

  factory RecipeNote.fromJson(Map<String, dynamic> json) =>
      _$RecipeNoteFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeNoteToJson(this);
}

@JsonSerializable()
class RecipeTool {
  final String id;
  final String name;
  final bool onHand;

  /// Mealie verlangt den Slug, wenn Utensilien am Rezept gespeichert werden.
  /// Ältere Cache-Einträge haben ihn nicht (leer) — der Editor löst ihn dann
  /// über die Utensilien-Liste auf.
  final String slug;

  const RecipeTool(
      {required this.id,
      required this.name,
      this.onHand = false,
      this.slug = ''});

  factory RecipeTool.fromJson(Map<String, dynamic> json) =>
      _$RecipeToolFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToolToJson(this);
}

@JsonSerializable()
class CategorySummary {
  final String id;
  final String name;
  final String slug;

  const CategorySummary({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory CategorySummary.fromJson(Map<String, dynamic> json) =>
      _$CategorySummaryFromJson(json);

  Map<String, dynamic> toJson() => _$CategorySummaryToJson(this);
}

@JsonSerializable()
class TagSummary {
  final String id;
  final String name;
  final String slug;

  const TagSummary({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory TagSummary.fromJson(Map<String, dynamic> json) =>
      _$TagSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$TagSummaryToJson(this);
}
