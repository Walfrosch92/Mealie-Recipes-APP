// ---------------------------------------------------------------------------
// Hilfen für den Schritt-fokussierten Kochmodus:
//   • extractStepTimers — erkennt ALLE Zeitangaben in einem Schritt-Text
//     (mehrsprachig de/en/es/fr/nl) → Liste von Minuten, in Text-Reihenfolge.
//   • stepImageUrl — Schrittbild aus einem eingebetteten Bild im Schritt-Text
//     (Mealie hat KEIN dediziertes Step-Image-Feld; Bilder stecken als
//     `![](…)`, `<img>` oder nackte URL-Zeile im `text`). Liefert null →
//     Caller fällt aufs Rezept-Bild zurück.
// ---------------------------------------------------------------------------

import 'markdown_parse.dart';

class StepTimer {
  /// Dauer in Minuten.
  final int minutes;

  /// Start-Offset im Text (zum Sortieren in Lesereihenfolge).
  final int position;

  const StepTimer(this.minutes, this.position);

  /// Kompakte Anzeige, z. B. „5 Min", „1 h 30".
  String get label {
    if (minutes < 60) return '$minutes Min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h $m';
  }
}

// Einheit-Wörter (alle 5 Sprachen). Längere Varianten zuerst (Regex-Alternation
// ist geordnet), damit z. B. „minutes" nicht vorzeitig bei „min" abbricht.
const _hourWords =
    r'stunden|stunde|hours|hour|heures|heure|horas|hora|uren|uur|timer|timen|time|std|hrs|hr|h';
const _minWords =
    r'minutter|minutt|minuten|minute|minutes|minutos|minuto|minuut|minuti|mins|min|mn';
// Verbindungswörter zwischen Stunden und Minuten („1 Stunde und 30 Minuten").
const _join = r'(?:\s*(?:und|and|et|y|en|og)?\s*)';
// Zahl mit optionaler Dezimalstelle (Punkt ODER Komma), z. B. „1", „1.5",
// „1,5". Die Dezimalgruppe greift NUR mit Ziffer NACH dem Trennzeichen, damit
// ein Satzpunkt/Komma hinter der Zahl („koche 20, dann …") nicht mitgezogen
// wird.
const _number = r'(\d+(?:[.,]\d+)?)';

/// Parst eine erkannte Zahl (Punkt oder Komma als Dezimaltrennzeichen) zu
/// double — für „1,5 Stunden" → 1.5 → 90 Min statt fälschlich 5 Stunden.
double _parseNum(String s) => double.parse(s.replaceAll(',', '.'));

/// Erkennt alle Timer in [text]. Kombinierte „Xh Ymin"-Angaben werden als EINE
/// Dauer zusammengefasst; sonst zählt jede eigenständige Minuten-/Stunden-
/// Angabe als eigener Timer (→ mehrere Chips bei „5 Min … 20 Min …").
List<StepTimer> extractStepTimers(String text) {
  final result = <StepTimer>[];
  final consumed = <int>[]; // belegte Zeichenbereiche [start,end)

  bool overlaps(int s, int e) {
    for (var i = 0; i < consumed.length; i += 2) {
      if (s < consumed[i + 1] && e > consumed[i]) return true;
    }
    return false;
  }

  void mark(int s, int e) {
    consumed
      ..add(s)
      ..add(e);
  }

  // 1) Kombiniert: „X <Stunde> Y <Minute>" → eine Dauer.
  final combined = RegExp(
    _number +
        r'\s*(?:' +
        _hourWords +
        r')\.?' +
        _join +
        _number +
        r'\s*(?:' +
        _minWords +
        r')\.?',
    caseSensitive: false,
  );
  for (final m in combined.allMatches(text)) {
    final mins = (_parseNum(m.group(1)!) * 60 + _parseNum(m.group(2)!)).round();
    result.add(StepTimer(mins, m.start));
    mark(m.start, m.end);
  }

  // 2) Eigenständige Stunden.
  final hours = RegExp(
    _number + r'\s*(?:' + _hourWords + r')\b\.?',
    caseSensitive: false,
  );
  for (final m in hours.allMatches(text)) {
    if (overlaps(m.start, m.end)) continue;
    result.add(StepTimer((_parseNum(m.group(1)!) * 60).round(), m.start));
    mark(m.start, m.end);
  }

  // 3) Eigenständige Minuten.
  final mins = RegExp(
    _number + r'\s*(?:' + _minWords + r')\b\.?',
    caseSensitive: false,
  );
  for (final m in mins.allMatches(text)) {
    if (overlaps(m.start, m.end)) continue;
    result.add(StepTimer(_parseNum(m.group(1)!).round(), m.start));
    mark(m.start, m.end);
  }

  // In Lesereihenfolge sortieren, unsinnige 0-Werte raus.
  result.removeWhere((t) => t.minutes <= 0);
  result.sort((a, b) => a.position.compareTo(b.position));
  return result;
}

/// Extrahiert die erste eingebettete Bild-URL aus einem Schritt-Text —
/// Markdown `![](…)`, HTML `<img>` oder nackte Bild-URL-Zeile (geteilte
/// Erkennung in markdown_parse.dart). Relative Mealie-Asset-Pfade werden mit
/// [baseUrl] zu einer absoluten URL ergänzt. Liefert null ohne Bild.
String? stepImageUrl(String stepText, String baseUrl) =>
    firstEmbeddedImageUrl(stepText, baseUrl);

/// Entfernt eingebettete Bilder (alle Formen) aus dem Anzeigetext (das Bild
/// wird separat groß dargestellt).
String stripMarkdownImages(String text) => stripEmbeddedImages(text);
