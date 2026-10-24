import '../../../core/models/recipe_detail.dart';

// ---------------------------------------------------------------------------
// Doppelte Rezepte finden (Kachel „Doppelte Rezepte").
//
// Rein lokal über den Rezept-Cache, damit auch große Bibliotheken (2.500+)
// ohne Server-Last durchsucht werden. Drei Signale:
//   1. gleiche Quelle (orgURL ohne Schema/www/Query) — typisch Mehrfach-Import
//   2. gleicher Name (normalisiert: Groß/Klein, Akzente, Klammern, Satzzeichen)
//   3. ähnlich: Namen teilen Wörter UND die Zutaten-Wörter überschneiden sich
// Kandidaten-Paare entstehen nur über gemeinsame Namenswörter (invertierter
// Index), nicht über alle n² Paare. Läuft per `compute` im Hintergrund-Isolate,
// daher nur einfache Datenklassen.
// ---------------------------------------------------------------------------

enum DuplicateReason { sameSource, sameName, similar }

/// Schlanke, isolate-taugliche Sicht auf ein Rezept.
class DuplicateInput {
  final String id;
  final String name;
  final String? orgUrl;
  final List<String> ingredientTexts;

  const DuplicateInput({
    required this.id,
    required this.name,
    this.orgUrl,
    this.ingredientTexts = const [],
  });

  factory DuplicateInput.fromRecipe(RecipeDetail r) => DuplicateInput(
        id: r.id,
        name: r.name,
        orgUrl: r.orgUrl,
        ingredientTexts: [
          // Strukturierte Zutat: nur das Lebensmittel — Notizen wie
          // „festkochend" / „gerieben" verwässern den Vergleich nur.
          // Unstrukturiert: Notiz bzw. Original-Text (Mengen/Einheiten
          // filtert _ingredientWords heraus).
          for (final i in r.recipeIngredient)
            if ((i.food?.name ?? '').isNotEmpty)
              i.food!.name!
            else if ((i.note ?? '').isNotEmpty)
              i.note!
            else if ((i.originalText ?? '').isNotEmpty)
              i.originalText!,
        ],
      );
}

class DuplicateGroup {
  /// Rezept-IDs der Gruppe (≥ 2).
  final List<String> ids;
  final DuplicateReason reason;

  /// Bei [DuplicateReason.similar]: Anteil gemeinsamer Zutaten-Wörter (0–1).
  final double ingredientOverlap;

  const DuplicateGroup({
    required this.ids,
    required this.reason,
    this.ingredientOverlap = 0,
  });
}

/// Schlüssel eines Paares für die „Kein Duplikat"-Liste (Reihenfolge egal).
String duplicatePairKey(String a, String b) =>
    a.compareTo(b) < 0 ? '$a|$b' : '$b|$a';

class DuplicateSearchInput {
  final List<DuplicateInput> recipes;
  final Set<String> ignoredPairs;
  const DuplicateSearchInput(this.recipes, this.ignoredPairs);
}

/// Einstiegspunkt für `compute(findDuplicates, input)`.
List<DuplicateGroup> findDuplicates(DuplicateSearchInput input) =>
    findDuplicateGroups(input.recipes, ignoredPairs: input.ignoredPairs);

List<DuplicateGroup> findDuplicateGroups(List<DuplicateInput> recipes,
    {Set<String> ignoredPairs = const {}}) {
  final n = recipes.length;
  final names = [for (final r in recipes) normalizeRecipeName(r.name)];
  final nameTokens = [for (final s in names) _tokens(s)];
  // Ohne Leerzeichen: „Kartoffel-Gratin" = „Kartoffelgratin", und deutsche
  // Komposita („Cremiges Kartoffelgratin") lassen sich über Buchstaben-
  // Dreiergruppen vergleichen statt nur über ganze Wörter.
  final compact = [for (final s in names) s.replaceAll(' ', '')];
  final trigrams = [for (final c in compact) _trigrams(c)];
  final urls = [for (final r in recipes) normalizeSourceUrl(r.orgUrl)];
  final ingWords = [
    for (final r in recipes) _ingredientWords(r.ingredientTexts),
  ];

  // Kanten: Paar → (Grund, Zutaten-Überschneidung).
  final edges = <String, (int, int, DuplicateReason, double)>{};
  void addEdge(int a, int b, DuplicateReason reason, double overlap) {
    if (a == b) return;
    final key = duplicatePairKey(recipes[a].id, recipes[b].id);
    if (ignoredPairs.contains(key)) return;
    final prev = edges[key];
    // Stärkerer Grund gewinnt (Quelle > Name > ähnlich).
    if (prev == null || reason.index < prev.$3.index) {
      edges[key] = (a, b, reason, overlap);
    }
  }

  // 1 + 2: exakte Gleichheit über Hash-Gruppen.
  void groupBy(List<String?> keys, DuplicateReason reason) {
    final byKey = <String, List<int>>{};
    for (var i = 0; i < n; i++) {
      final k = keys[i];
      if (k == null || k.isEmpty) continue;
      (byKey[k] ??= []).add(i);
    }
    for (final idx in byKey.values) {
      for (var i = 1; i < idx.length; i++) {
        addEdge(idx[0], idx[i], reason, 1);
      }
    }
  }

  groupBy(urls, DuplicateReason.sameSource);
  groupBy(compact, DuplicateReason.sameName);

  // 3: ähnliche Rezepte. Kandidaten = Namen mit vielen gemeinsamen
  // Buchstaben-Dreiergruppen (invertierter Index statt aller n² Paare).
  final index = <String, List<int>>{};
  for (var i = 0; i < n; i++) {
    for (final t in trigrams[i]) {
      (index[t] ??= []).add(i);
    }
  }
  for (var a = 0; a < n; a++) {
    if (trigrams[a].isEmpty) continue;
    final shared = <int, int>{};
    for (final t in trigrams[a]) {
      final bucket = index[t]!;
      // Sehr häufige Dreiergruppen („ung", „che") sagen nichts und kosten
      // quadratisch — die seltenen reichen, um echte Paare zu finden.
      if (bucket.length > 400) continue;
      for (final b in bucket) {
        if (b > a) shared[b] = (shared[b] ?? 0) + 1;
      }
    }
    for (final e in shared.entries) {
      final b = e.key;
      final minT = trigrams[a].length < trigrams[b].length
          ? trigrams[a].length
          : trigrams[b].length;
      if (e.value < 3 || e.value < minT * 0.4) continue;
      if (compact[a] == compact[b]) continue; // schon „gleicher Name"
      final nameSim = _nameSimilarity(compact[a], compact[b], trigrams[a],
          trigrams[b], nameTokens[a], nameTokens[b]);
      final hasIng = ingWords[a].length >= 3 && ingWords[b].length >= 3;
      final ingSim =
          hasIng ? _ingredientOverlap(ingWords[a], ingWords[b]) : 0.0;
      if (_isSimilar(nameSim, hasIng, ingSim)) {
        addEdge(a, b, DuplicateReason.similar, ingSim);
      }
    }
  }

  // Zusammenhängende Gruppen (Union-Find).
  final parent = List<int>.generate(n, (i) => i);
  int find(int i) {
    while (parent[i] != i) {
      parent[i] = parent[parent[i]];
      i = parent[i];
    }
    return i;
  }

  for (final e in edges.values) {
    final ra = find(e.$1), rb = find(e.$2);
    if (ra != rb) parent[rb] = ra;
  }
  final members = <int, List<int>>{};
  final bestReason = <int, DuplicateReason>{};
  final bestOverlap = <int, double>{};
  for (final e in edges.values) {
    final root = find(e.$1);
    final r = bestReason[root];
    if (r == null || e.$3.index < r.index) bestReason[root] = e.$3;
    if (e.$4 > (bestOverlap[root] ?? 0)) bestOverlap[root] = e.$4;
  }
  for (var i = 0; i < n; i++) {
    final root = find(i);
    if (bestReason.containsKey(root)) (members[root] ??= []).add(i);
  }

  final groups = [
    for (final entry in members.entries)
      if (entry.value.length >= 2)
        DuplicateGroup(
          ids: [for (final i in entry.value) recipes[i].id],
          reason: bestReason[entry.key]!,
          ingredientOverlap: bestOverlap[entry.key] ?? 0,
        ),
  ];
  final nameById = {for (var i = 0; i < n; i++) recipes[i].id: names[i]};
  groups.sort((a, b) {
    final r = a.reason.index.compareTo(b.reason.index);
    if (r != 0) return r;
    return nameById[a.ids.first]!.compareTo(nameById[b.ids.first]!);
  });
  return groups;
}

// ── Normalisierung ──────────────────────────────────────────────────────────

const _diacritics = {
  'ä': 'ae',
  'ö': 'oe',
  'ü': 'ue',
  'ß': 'ss',
  'à': 'a',
  'á': 'a',
  'â': 'a',
  'ã': 'a',
  'å': 'a',
  'æ': 'ae',
  'ç': 'c',
  'č': 'c',
  'ć': 'c',
  'è': 'e',
  'é': 'e',
  'ê': 'e',
  'ë': 'e',
  'ě': 'e',
  'ę': 'e',
  'ì': 'i',
  'í': 'i',
  'î': 'i',
  'ï': 'i',
  'ñ': 'n',
  'ń': 'n',
  'ò': 'o',
  'ó': 'o',
  'ô': 'o',
  'õ': 'o',
  'ø': 'o',
  'ő': 'o',
  'œ': 'oe',
  'ù': 'u',
  'ú': 'u',
  'û': 'u',
  'ű': 'u',
  'ł': 'l',
  'ś': 's',
  'š': 's',
  'ź': 'z',
  'ż': 'z',
  'ž': 'z',
};

String _fold(String s) {
  final lower = s.toLowerCase();
  final b = StringBuffer();
  for (final ch in lower.split('')) {
    b.write(_diacritics[ch] ?? ch);
  }
  return b.toString();
}

/// „Omas Lasagne (2)" / „omas lasagne!" → „omas lasagne".
String normalizeRecipeName(String name) {
  var s = _fold(name);
  s = s.replaceAll(RegExp(r'\([^)]*\)|\[[^\]]*\]'), ' ');
  s = s.replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();
  // Angehängte Kopie-Nummern („lasagne 2", „lasagne copy 1") weg.
  s = s.replaceAll(
      RegExp(r'(\s+(copy|kopie|copie|copia|kopia))?(\s+\d+)?$'), '');
  return s.trim();
}

/// https://www.chefkoch.de/rezepte/123/?utm=x#top → chefkoch.de/rezepte/123
String? normalizeSourceUrl(String? url) {
  if (url == null) return null;
  var s = url.trim().toLowerCase();
  if (!s.startsWith('http')) return null;
  s = s.replaceFirst(RegExp(r'^https?://'), '');
  s = s.replaceFirst(RegExp(r'^www\.'), '');
  s = s.split('#').first.split('?').first;
  s = s.replaceAll(RegExp(r'/+$'), '');
  return s.contains('/') ? s : null; // nur Domain = keine Rezept-Quelle
}

const _stopWords = {
  'und',
  'mit',
  'ohne',
  'der',
  'die',
  'das',
  'vom',
  'von',
  'auf',
  'aus',
  'the',
  'and',
  'with',
  'for',
  'del',
  'con',
  'les',
  'des',
  'aux',
  'avec',
  'fuer',
  'zum',
  'zur',
  'oder',
  'pour',
  'van',
  'met',
  'een',
  'het',
  'med',
  'og',
  'til',
  'per',
  'para',
  'dos',
  'com',
  'meg',
  'es',
  'in',
  'im',
  'a',
  'al',
  'de',
  'la',
  'le',
  'el',
  'en',
  'et',
  'i',
  'z',
  'w',
  's',
  'na',
  'ze',
  'e',
  'o',
  'u',
  'au',
  'du',
};

/// Mengen-/Einheitenwörter, die zwischen Rezepten nichts aussagen.
const _unitWords = {
  'g',
  'kg',
  'mg',
  'ml',
  'l',
  'cl',
  'dl',
  'el',
  'tl',
  'tbsp',
  'tsp',
  'cup',
  'cups',
  'oz',
  'lb',
  'lbs',
  'prise',
  'pinch',
  'stueck',
  'stk',
  'pck',
  'packung',
  'dose',
  'bund',
  'zehe',
  'zehen',
  'scheibe',
  'scheiben',
  'etwas',
  'some',
  'nach',
  'belieben',
  'taste',
  'optional',
  'gross',
  'klein',
  'large',
  'small',
  'medium',
  'frisch',
  'fresh',
  'gehackt',
  'chopped',
  'gewuerfelt',
  'diced',
};

Set<String> _tokens(String normalized) => {
      for (final t in normalized.split(' '))
        if (t.isNotEmpty && !_stopWords.contains(t)) t,
    };

Set<String> _ingredientWords(List<String> texts) {
  final words = <String>{};
  for (final t in texts) {
    for (final w in _fold(t).split(RegExp(r'[^a-z]+'))) {
      if (w.length < 3 || _stopWords.contains(w) || _unitWords.contains(w)) {
        continue;
      }
      words.add(_stem(w));
    }
  }
  return words;
}

/// Grobe Grundform: Plural-/Beugungsendungen ab (kartoffeln → kartoffel,
/// knoblauchzehen/-zehe → knoblauchzeh, tomatoes → tomato). Bewusst simpel
/// und sprachübergreifend — es geht nur ums Wiedererkennen.
String _stem(String w) {
  if (w.length < 5) return w;
  for (final end in const ['es', 'en', 'er', 'n', 'e', 's']) {
    if (w.endsWith(end) && w.length - end.length >= 4) {
      return w.substring(0, w.length - end.length);
    }
  }
  return w;
}

Set<String> _trigrams(String s) {
  if (s.length < 3) return s.isEmpty ? const {} : {s};
  return {for (var i = 0; i + 3 <= s.length; i++) s.substring(i, i + 3)};
}

/// Namens-Ähnlichkeit 0–1: das Beste aus Wort-Überschneidung, Buchstaben-
/// Dreiergruppen (Komposita, Wortstellung) und Enthaltensein („Kartoffel-
/// gratin" steckt ganz in „Cremiges Kartoffelgratin").
double _nameSimilarity(String a, String b, Set<String> ta, Set<String> tb,
    Set<String> wa, Set<String> wb) {
  final inter = ta.where(tb.contains).length;
  final dice =
      (ta.isEmpty || tb.isEmpty) ? 0.0 : 2 * inter / (ta.length + tb.length);
  var sim = dice > _jaccard(wa, wb) ? dice : _jaccard(wa, wb);
  final shorter = a.length <= b.length ? a : b;
  final longer = a.length <= b.length ? b : a;
  if (shorter.length >= 6 && longer.contains(shorter) && sim < 0.75) {
    sim = 0.75;
  }
  return sim;
}

/// Anteil der Zutaten des KLEINEREN Rezepts, die sich im anderen
/// wiederfinden — gleiche Grundform oder enthalten („sahne" in
/// „schlagsahne", „muskat" in „muskatnuss"). Bewusst nicht Jaccard: die
/// „cremige" Variante hat oft ein, zwei Zutaten mehr.
double _ingredientOverlap(Set<String> a, Set<String> b) {
  final small = a.length <= b.length ? a : b;
  final large = a.length <= b.length ? b : a;
  if (small.isEmpty) return 0;
  var hits = 0;
  for (final w in small) {
    if (large.contains(w) ||
        large.any((x) =>
            (w.length >= 4 && x.contains(w)) ||
            (x.length >= 4 && w.contains(x)))) {
      hits++;
    }
  }
  return hits / small.length;
}

/// Ab wann zwei Rezepte als „ähnlich" gelten. Je ähnlicher der Name, desto
/// weniger gleiche Zutaten braucht es — und umgekehrt.
bool _isSimilar(double nameSim, bool hasIng, double ingSim) {
  if (!hasIng) return nameSim >= 0.85;
  return (nameSim >= 0.7 && ingSim >= 0.5) ||
      (nameSim >= 0.45 && ingSim >= 0.7) ||
      (nameSim >= 0.25 && ingSim >= 0.9);
}

double _jaccard(Set<String> a, Set<String> b) {
  if (a.isEmpty || b.isEmpty) return 0;
  final inter = a.where(b.contains).length;
  return inter / (a.length + b.length - inter);
}
