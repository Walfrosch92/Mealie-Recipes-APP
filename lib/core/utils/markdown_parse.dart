// ---------------------------------------------------------------------------
// Leichter Markdown-Parser für Rezept-Texte (Schritte, ggf. später Notizen).
//
// Mealie erlaubt Markdown in Schritt-Texten („Recipe steps as well as other
// fields support markdown syntax"). Wir rendern das selbst im Premium-Design
// statt ein Paket zu ziehen (flutter_markdown ist discontinued, und unser
// Bedarf ist klein): Inline-Styles, Links, Bilder und einfache Blöcke.
//
// Bewusst NICHT unterstützt (in Rezepten praktisch nicht vorkommend):
// Tabellen, verschachtelte Listen, HTML, Fußnoten, Einzel-Unterstrich-Kursiv
// (`_kursiv_` — zu viele False-Positives bei Wörtern mit Unterstrich).
// ---------------------------------------------------------------------------

/// Ein Stück Fließtext mit einheitlichem Stil. Blöcke bestehen aus Segmenten.
class MdSegment {
  final String text;
  final bool bold;
  final bool italic;
  final bool strike;
  final bool code;

  /// Ziel-URL, wenn das Segment Teil eines `[Label](url)`-Links ist.
  final String? linkUrl;

  const MdSegment(
    this.text, {
    this.bold = false,
    this.italic = false,
    this.strike = false,
    this.code = false,
    this.linkUrl,
  });

  bool get isPlain => !bold && !italic && !strike && !code && linkUrl == null;
}

/// Block-Elemente in Dokument-Reihenfolge.
sealed class MdBlock {
  const MdBlock();
}

class MdParagraph extends MdBlock {
  final List<MdSegment> segments;
  const MdParagraph(this.segments);
}

class MdHeading extends MdBlock {
  /// 1–6 (`#` bis `######`).
  final int level;
  final List<MdSegment> segments;
  const MdHeading(this.level, this.segments);
}

class MdListItem extends MdBlock {
  /// null → Bullet („- "/„* "/„+ "), sonst die Nummer („1." / „2)").
  final int? number;
  final List<MdSegment> segments;
  const MdListItem(this.segments, {this.number});
}

class MdQuote extends MdBlock {
  final List<MdSegment> segments;
  const MdQuote(this.segments);
}

class MdImage extends MdBlock {
  final String url;
  final String alt;
  const MdImage(this.url, this.alt);
}

class MdCodeBlock extends MdBlock {
  final String text;
  const MdCodeBlock(this.text);
}

class MdDivider extends MdBlock {
  const MdDivider();
}

// ---------------------------------------------------------------------------
// Inline-Parsing
// ---------------------------------------------------------------------------

// Alternation-Reihenfolge = Priorität: Code schluckt alles Innere, Bilder vor
// Links (gleiches Klammer-Muster mit `!`), *** vor ** vor *. `.+?` non-greedy,
// Kursiv ohne Zeilenumbruch, damit ein einzelner `*` am Zeilenanfang der
// Folgezeile (Bullet) nicht als Emphasis-Ende missdeutet wird.
final _inlineRe = RegExp(
  r'`([^`\n]+)`' //                               1: Code
  r'|!\[([^\]]*)\]\(\s*([^)\s]*)(?:\s+"[^"]*")?\s*\)' // 2,3: Bild (Alt, URL)
  r'|\[([^\]]+)\]\(\s*([^)\s]*)(?:\s+"[^"]*")?\s*\)' //  4,5: Link (Label, URL)
  r'|\*\*\*(.+?)\*\*\*' //                        6: fett+kursiv
  r'|___(.+?)___' //                              7: fett+kursiv
  r'|\*\*(.+?)\*\*' //                            8: fett
  r'|__(.+?)__' //                                9: fett
  r'|\*([^*\n]+)\*' //                            10: kursiv
  r'|~~(.+?)~~', //                               11: durchgestrichen
);

/// Zerlegt [text] in Segmente. Verschachtelung („**fett mit [Link](u)**")
/// wird bis Tiefe 4 aufgelöst; Bilder werden hier zu ihrem Alt-Text (Bilder
/// als eigene Blöcke extrahiert `parseMarkdownBlocks`).
List<MdSegment> parseInlineMarkdown(String text) =>
    _parseInline(text, const MdSegment(''), 0);

List<MdSegment> _parseInline(String text, MdSegment inherit, int depth) {
  final result = <MdSegment>[];

  void plain(String t) {
    if (t.isEmpty) return;
    result.add(MdSegment(
      t,
      bold: inherit.bold,
      italic: inherit.italic,
      strike: inherit.strike,
      code: inherit.code,
      linkUrl: inherit.linkUrl,
    ));
  }

  if (depth > 4) {
    plain(text);
    return result;
  }

  var last = 0;
  for (final m in _inlineRe.allMatches(text)) {
    plain(text.substring(last, m.start));
    last = m.end;

    void nested(String inner,
        {bool bold = false,
        bool italic = false,
        bool strike = false,
        String? linkUrl}) {
      result.addAll(_parseInline(
        inner,
        MdSegment(
          '',
          bold: inherit.bold || bold,
          italic: inherit.italic || italic,
          strike: inherit.strike || strike,
          code: inherit.code,
          linkUrl: linkUrl ?? inherit.linkUrl,
        ),
        depth + 1,
      ));
    }

    if (m.group(1) != null) {
      // Inline-Code: Inhalt wörtlich, keine weitere Verschachtelung.
      result.add(MdSegment(
        m.group(1)!,
        bold: inherit.bold,
        italic: inherit.italic,
        strike: inherit.strike,
        code: true,
        linkUrl: inherit.linkUrl,
      ));
    } else if (m.group(3) != null) {
      // Bild mitten im Fließtext → Alt-Text anzeigen (Block-Extraktion hat
      // Bilder normalerweise schon vorher herausgelöst).
      plain(m.group(2) ?? '');
    } else if (m.group(5) != null) {
      final url = m.group(5)!.trim();
      nested(m.group(4)!, linkUrl: url.isEmpty ? null : url);
    } else if (m.group(6) != null) {
      nested(m.group(6)!, bold: true, italic: true);
    } else if (m.group(7) != null) {
      nested(m.group(7)!, bold: true, italic: true);
    } else if (m.group(8) != null) {
      nested(m.group(8)!, bold: true);
    } else if (m.group(9) != null) {
      nested(m.group(9)!, bold: true);
    } else if (m.group(10) != null) {
      nested(m.group(10)!, italic: true);
    } else if (m.group(11) != null) {
      nested(m.group(11)!, strike: true);
    }
  }
  plain(text.substring(last));
  return result;
}

// ---------------------------------------------------------------------------
// Block-Parsing
// ---------------------------------------------------------------------------

// Eingebettete Bilder in allen Formen, die in Mealie-Schritten vorkommen:
//   1. Markdown `![alt](url)` bzw. `![alt](url "titel")`
//   2. HTML `<img src="url" …>` (Mealie-Editor/HTML-Importe)
// Nackte Bild-URLs auf eigener Zeile (Nutzer fügt einfach die Asset-Adresse
// ein, z. B. `https://…/api/media/recipes/…/assets/foto.jpeg`) behandelt
// [_bareImageLineRe] auf Zeilenebene.
final _imageRe = RegExp(
  r'!\[([^\]]*)\]\(\s*([^)\s]*)(?:\s+"[^"]*")?\s*\)'
  r'''|<img\b[^>]*\bsrc\s*=\s*["']([^"']+)["'][^>]*>''',
  caseSensitive: false,
);
final _bareImageLineRe = RegExp(
  r'^[ \t]*((?:https?://|/)\S+\.(?:jpe?g|png|webp|gif|bmp|heic|avif)(?:\?\S*)?)[ \t]*$',
  caseSensitive: false,
  multiLine: true,
);
final _headingRe = RegExp(r'^\s{0,3}(#{1,6})\s+(.*)$');
final _bulletRe = RegExp(r'^\s{0,6}[-*+]\s+(.*)$');
final _orderedRe = RegExp(r'^\s{0,6}(\d{1,3})[.)]\s+(.*)$');
final _quoteRe = RegExp(r'^\s{0,3}>\s?(.*)$');
final _dividerRe = RegExp(r'^\s*(?:-{3,}|\*{3,}|_{3,})\s*$');
final _fenceRe = RegExp(r'^\s*```');

/// Zerlegt [text] in Blöcke. Bilder werden — egal wo sie im Text stehen — als
/// eigene [MdImage]-Blöcke in Dokument-Reihenfolge herausgelöst (Flutter kann
/// Netzwerkbilder nicht sinnvoll inline im Satz rendern).
///
/// Einzelne Zeilenumbrüche innerhalb eines Absatzes bleiben erhalten (`\n` im
/// Segment-Text) — so bricht der Text exakt wie bisher bei plain `Text`.
List<MdBlock> parseMarkdownBlocks(String text) {
  final blocks = <MdBlock>[];

  // 1) Bilder herauslösen → Sequenz aus Text-Chunks und Bild-Blöcken.
  //    Gruppe 2 = Markdown-URL, Gruppe 3 = HTML-`src`.
  var last = 0;
  final pending = <(String?, MdImage?)>[];
  for (final m in _imageRe.allMatches(text)) {
    pending.add((text.substring(last, m.start), null));
    final url = (m.group(2) ?? m.group(3) ?? '').trim();
    if (url.isNotEmpty) {
      pending.add((null, MdImage(url, m.group(1)?.trim() ?? '')));
    }
    last = m.end;
  }
  pending.add((text.substring(last), null));

  // 2) Text-Chunks zeilenweise in Blöcke übersetzen.
  for (final (chunk, image) in pending) {
    if (image != null) {
      blocks.add(image);
      continue;
    }
    blocks.addAll(_parseTextChunk(chunk!));
  }
  return blocks;
}

List<MdBlock> _parseTextChunk(String chunk) {
  final blocks = <MdBlock>[];
  final para = <String>[];
  final quote = <String>[];
  final fence = <String>[];
  var inFence = false;

  void flushPara() {
    if (para.isEmpty) return;
    final segs = parseInlineMarkdown(para.join('\n'));
    if (segs.isNotEmpty) blocks.add(MdParagraph(segs));
    para.clear();
  }

  void flushQuote() {
    if (quote.isEmpty) return;
    final segs = parseInlineMarkdown(quote.join('\n'));
    if (segs.isNotEmpty) blocks.add(MdQuote(segs));
    quote.clear();
  }

  for (final line in chunk.split('\n')) {
    if (inFence) {
      if (_fenceRe.hasMatch(line)) {
        blocks.add(MdCodeBlock(fence.join('\n')));
        fence.clear();
        inFence = false;
      } else {
        fence.add(line);
      }
      continue;
    }

    final q = _quoteRe.firstMatch(line);
    if (q != null) {
      flushPara();
      quote.add(q.group(1)!);
      continue;
    }
    flushQuote();

    if (_fenceRe.hasMatch(line)) {
      flushPara();
      inFence = true;
      continue;
    }
    if (line.trim().isEmpty) {
      flushPara();
      continue;
    }
    if (_dividerRe.hasMatch(line)) {
      flushPara();
      blocks.add(const MdDivider());
      continue;
    }
    // Nackte Bild-URL auf eigener Zeile → eigenes Bild (Nutzer fügen oft nur
    // die Asset-Adresse ein, ohne Markdown-Syntax drumherum).
    final img = _bareImageLineRe.firstMatch(line);
    if (img != null) {
      flushPara();
      blocks.add(MdImage(img.group(1)!, ''));
      continue;
    }
    final h = _headingRe.firstMatch(line);
    if (h != null) {
      flushPara();
      final segs = parseInlineMarkdown(h.group(2)!.trim());
      if (segs.isNotEmpty) blocks.add(MdHeading(h.group(1)!.length, segs));
      continue;
    }
    final b = _bulletRe.firstMatch(line);
    if (b != null) {
      flushPara();
      final segs = parseInlineMarkdown(b.group(1)!.trim());
      if (segs.isNotEmpty) blocks.add(MdListItem(segs));
      continue;
    }
    final o = _orderedRe.firstMatch(line);
    if (o != null) {
      flushPara();
      final segs = parseInlineMarkdown(o.group(2)!.trim());
      if (segs.isNotEmpty) {
        blocks.add(MdListItem(segs, number: int.parse(o.group(1)!)));
      }
      continue;
    }
    para.add(line);
  }

  // Offene Puffer schließen (unbeendeter Fence → als Code-Block ausgeben).
  flushPara();
  flushQuote();
  if (fence.isNotEmpty) blocks.add(MdCodeBlock(fence.join('\n')));
  return blocks;
}

/// True, wenn [blocks] nur ein einziger Absatz aus reinem Text ist — dann kann
/// der Aufrufer den Fast-Path (plain `Text`) nehmen.
bool isPlainParagraph(List<MdBlock> blocks) =>
    blocks.length == 1 &&
    blocks.first is MdParagraph &&
    (blocks.first as MdParagraph).segments.every((s) => s.isPlain);

/// Erste eingebettete Bild-URL im Text — Markdown `![](…)`, HTML `<img>` oder
/// nackte Bild-URL-Zeile —, relativ aufgelöst gegen [baseUrl]. Für das große
/// Schrittbild im Kochmodus. Liefert null, wenn der Text kein Bild enthält.
String? firstEmbeddedImageUrl(String text, String baseUrl) {
  final md = _imageRe.firstMatch(text);
  final bare = _bareImageLineRe.firstMatch(text);
  String? url;
  if (md != null && (bare == null || md.start <= bare.start)) {
    url = md.group(2) ?? md.group(3);
  } else if (bare != null) {
    url = bare.group(1);
  }
  if (url == null) return null;
  return resolveMarkdownUrl(url, baseUrl);
}

/// Entfernt alle eingebetteten Bilder (Markdown, HTML-`<img>`, nackte
/// Bild-URL-Zeilen) aus dem Anzeigetext.
String stripEmbeddedImages(String text) {
  return text.replaceAll(_imageRe, '').replaceAll(_bareImageLineRe, '').trim();
}

/// Reduziert Block-Syntax auf Klartext für kompakte Anzeigen (Kochmodus, der
/// kein eigenes Block-Layout hat): `#`-Überschriften ohne Marker, Bullets als
/// „•", Zitate ohne `>`; Trennlinien und Code-Fences fliegen raus.
/// Inline-Syntax (fett/kursiv/Links) bleibt unangetastet.
String flattenMarkdownBlockMarkers(String text) {
  final out = <String>[];
  for (final line in text.split('\n')) {
    if (_dividerRe.hasMatch(line) || _fenceRe.hasMatch(line)) continue;
    final h = _headingRe.firstMatch(line);
    if (h != null) {
      out.add(h.group(2)!.trim());
      continue;
    }
    final b = _bulletRe.firstMatch(line);
    if (b != null) {
      out.add('• ${b.group(1)!}');
      continue;
    }
    final q = _quoteRe.firstMatch(line);
    if (q != null) {
      out.add(q.group(1)!);
      continue;
    }
    out.add(line);
  }
  return out.join('\n');
}

/// Löst eine Markdown-URL auf: absolute http(s)-URLs unverändert, relative
/// Pfade (Mealie-Assets wie `/api/media/...`) gegen [serverUrl]. Liefert null,
/// wenn keine brauchbare URL entsteht.
String? resolveMarkdownUrl(String url, String? serverUrl) {
  final u = url.trim();
  if (u.isEmpty) return null;
  if (u.startsWith('http://') || u.startsWith('https://')) return u;
  final base = (serverUrl ?? '').trim();
  if (base.isEmpty) return null;
  final b = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
  return u.startsWith('/') ? '$b$u' : '$b/$u';
}
