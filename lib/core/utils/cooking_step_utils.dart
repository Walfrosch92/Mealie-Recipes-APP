// ---------------------------------------------------------------------------
// Hilfen für den Schritt-fokussierten Kochmodus:
//   • extractStepTimers — erkennt ALLE Zeitangaben in einem Schritt-Text
//     (alle 23 App-Sprachen) → Liste von Minuten, in Text-Reihenfolge.
//   • stepImageUrl — Schrittbild aus einem eingebetteten Bild im Schritt-Text
//     (Mealie hat KEIN dediziertes Step-Image-Feld; Bilder stecken als
//     `![](…)`, `<img>` oder nackte URL-Zeile im `text`). Liefert null →
//     Caller fällt aufs Rezept-Bild zurück.
// ---------------------------------------------------------------------------

import '../models/recipe_detail.dart';
import 'markdown_parse.dart';

class StepTimer {
  /// Dauer in Minuten.
  final int minutes;

  /// Start-Offset im Text (zum Sortieren in Lesereihenfolge).
  final int position;

  const StepTimer(this.minutes, this.position);

  /// Kompakte Anzeige, z. B. „5 Min", „1 h 30".
  /// Beschriftung mit übersetzter Minuten-Abkürzung ([minUnit], z. B.
  /// `l.minutesShort`: „Min.", „min", „perc"). Vorher stand fest „Min" —
  /// auch in Englisch, Ungarisch usw.
  String labelFor(String minUnit) {
    if (minutes < 60) return '$minutes $minUnit';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h $m';
  }

  String get label {
    if (minutes < 60) return '$minutes Min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h $m';
  }
}

// Einheit-Wörter aller 23 App-Sprachen (inkl. gängiger Beugungen: „10
// minut", „po 10 minutách", „10 percig", „2 часа"). Längere Varianten zuerst
// (Regex-Alternation ist geordnet), damit z. B. „minutes" nicht vorzeitig bei
// „min" abbricht. Buchstaben-Wörter brauchen danach eine Wortgrenze (sonst
// träfe „5 mince" auf „min"); `\b` kennt in Dart nur ASCII, daher die
// Unicode-Lookahead-Variante [_wordEnd]. CJK-Einheiten stehen ohne Leerzeichen
// direkt im Fließtext („煮10分钟后") und bekommen deshalb keine Grenze.
const _hourAlpha = [
  // de, en, fr, es/pt, nl, it
  'stunden', 'stunde', 'hours', 'hour', 'heures', 'heure', 'horas', 'hora',
  'uren', 'uur', 'ore', 'ora',
  // nb/da/sv
  'timmar', 'timme', 'timer', 'timen', 'time', 'tim',
  // fi, hu, tr
  'tuntia', 'tunnin', 'tunti', 'óráig', 'órán', 'órát', 'órás', 'óra',
  'saatte', 'saat',
  // pl, cs, sl
  'godzinach', 'godziny', 'godzinę', 'godzina', 'godzin', 'godz',
  'hodinách', 'hodinami', 'hodiny', 'hodinu', 'hodina', 'hodin', 'hod',
  'urah', 'uri', 'ure', 'uro', 'ura', 'ur',
  // ru, uk
  // kein „ч“: „1 ч. л.“ ist ein Teelöffel, kein Stunden-Timer
  'часов', 'часа', 'час',
  'годин', 'години', 'година', 'годину', 'год',
  // Abkürzungen
  'std', 'hrs', 'hr', 'h',
];
const _minAlpha = [
  // nb/da/sv, de/nl, en, es/pt, it, fr
  'minutter', 'minutt', 'minuter', 'minuten', 'minuut', 'minutes', 'minute',
  'minutos', 'minuto', 'minuti',
  // fi, hu, tr
  'minuuttia', 'minuutin', 'minuutti', 'percig', 'percen', 'percet', 'perces',
  'perc', 'dakikada', 'dakika', 'dk',
  // pl, cs, sl (minute/minuto/minuti/minut s. o. bzw. hier)
  'minutach', 'minutami', 'minutách', 'minutah', 'minuty', 'minutę', 'minutu',
  'minut', 'minuta',
  // ru, uk
  'минутами', 'минуты', 'минуту', 'минута', 'минут', 'мин',
  'хвилинами', 'хвилини', 'хвилину', 'хвилина', 'хвилин', 'хв',
  // Abkürzungen
  'mins', 'min', 'mn',
];
// ja (時間/分間/分), zh-Hans (小时/分钟), zh-Hant (小時/分鐘), ko (시간/분간/분).
const _hourCjk = ['小时', '小時', '時間', '时间', '시간'];
const _minCjk = ['分钟', '分鐘', '分間', '분간', '分', '분'];

const _wordEnd = r'(?![\p{L}\p{M}])';

String _alt(List<String> words) => words.join('|');

/// Einheiten-Teil eines Musters: Buchstaben-Wort mit Wortgrenze ODER
/// CJK-Einheit, optional mit Abkürzungspunkt.
String _unit(List<String> alpha, List<String> cjk) =>
    '(?:(?:${_alt(alpha)})$_wordEnd|(?:${_alt(cjk)}))\\.?';

final _hourUnit = _unit(_hourAlpha, _hourCjk);
final _minUnit = _unit(_minAlpha, _minCjk);

// Verbindungswörter zwischen Stunden und Minuten („1 Stunde und 30 Minuten",
// „1 час 30 минут", „1時間30分").
const _join = r'(?:\s*(?:und|and|et|y|en|og|och|e|i|in|a|és|ja|ve|и|і|та)?\s*)';
// Zahl mit optionaler Dezimalstelle (Punkt ODER Komma), z. B. „1", „1.5",
// „1,5". Die Dezimalgruppe greift NUR mit Ziffer NACH dem Trennzeichen, damit
// ein Satzpunkt/Komma hinter der Zahl („koche 20, dann …") nicht mitgezogen
// wird. Davor keine Ziffer und kein lateinischer/kyrillischer Buchstabe
// („A4" zählt nicht) — CJK-Zeichen dürfen direkt davor stehen („煮10分钟").
const _number = r'(?<![0-9A-Za-z\u00C0-\u024F\u0400-\u04FF])(\d+(?:[.,]\d+)?)';

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
    '$_number\\s*$_hourUnit$_join$_number\\s*$_minUnit',
    caseSensitive: false,
    unicode: true,
  );
  for (final m in combined.allMatches(text)) {
    final mins = (_parseNum(m.group(1)!) * 60 + _parseNum(m.group(2)!)).round();
    result.add(StepTimer(mins, m.start));
    mark(m.start, m.end);
  }

  // 2) Eigenständige Stunden.
  final hours = RegExp(
    '$_number\\s*$_hourUnit',
    caseSensitive: false,
    unicode: true,
  );
  for (final m in hours.allMatches(text)) {
    if (overlaps(m.start, m.end)) continue;
    result.add(StepTimer((_parseNum(m.group(1)!) * 60).round(), m.start));
    mark(m.start, m.end);
  }

  // 3) Eigenständige Minuten.
  final mins = RegExp(
    '$_number\\s*$_minUnit',
    caseSensitive: false,
    unicode: true,
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

/// Timer eines Schritts: die im Text erkannten plus — Mealie ≥ 3.30 — die
/// am Schritt hinterlegte Dauer (`durationSeconds`), sofern sie nicht schon
/// im Text steht. Die hinterlegte Dauer kommt zuerst (Ein-Tipp-Timer).
List<StepTimer> timersForStep(Instruction step) {
  final found = extractStepTimers(step.text);
  final secs = step.durationSeconds;
  if (secs == null || secs <= 0) return found;
  final minutes = (secs / 60).ceil();
  if (found.any((t) => t.minutes == minutes)) return found;
  return [StepTimer(minutes, -1), ...found];
}

/// Hinterlegte Schritt-Dauer lesbar: „45 s“, „10 Min.“, „1 h 30“.
String formatStepDuration(int seconds, String minUnit) {
  if (seconds < 60) return '$seconds s';
  final minutes = (seconds / 60).round();
  return StepTimer(minutes, 0).labelFor(minUnit);
}
