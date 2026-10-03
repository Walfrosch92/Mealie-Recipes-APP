import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/markdown_parse.dart';
import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Markdown-Anzeige im Premium-Design.
//
// Rendert Rezept-Texte (Mealie erlaubt Markdown in Schritten): Fett/Kursiv/
// Durchgestrichen/Inline-Code, klickbare Links im Akzent-Orange, Bullets und
// nummerierte Listen, Überschriften (Plus Jakarta Sans), Zitate, Trennlinien
// und eingebettete Bilder als gerundete Karten (Mealie-Assets mit Bearer-
// Header, fremde Hosts ohne — der Token darf das Haus nicht verlassen).
// ---------------------------------------------------------------------------

/// Öffnet einen Markdown-Link im externen Browser/Mail-Client. Nur http(s)
/// und mailto — alles andere wird still ignoriert (kein Crash bei kaputten
/// URLs in Rezepttexten).
Future<void> openMarkdownLink(String url, {String? serverUrl}) async {
  final resolved = resolveMarkdownUrl(url, serverUrl) ?? url.trim();
  final uri = Uri.tryParse(resolved);
  if (uri == null) return;
  if (uri.scheme != 'http' && uri.scheme != 'https' && uri.scheme != 'mailto') {
    return;
  }
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {}
}

class MarkdownText extends StatefulWidget {
  /// Roher Markdown-Text.
  final String text;

  /// Basis-Stil für Fließtext — bestimmt Farbe/Größe/Zeilenhöhe wie das
  /// bisherige plain `Text`.
  final TextStyle style;

  /// Mealie-Server als Basis für relative Bild-/Link-URLs und als Grenze,
  /// bis zu der der [apiToken] als Auth-Header mitgeschickt wird.
  final String? serverUrl;
  final String? apiToken;

  /// false → Bilder unterdrücken (z. B. wenn der Aufrufer sie separat zeigt).
  final bool showImages;

  const MarkdownText({
    super.key,
    required this.text,
    required this.style,
    this.serverUrl,
    this.apiToken,
    this.showImages = true,
  });

  @override
  State<MarkdownText> createState() => _MarkdownTextState();
}

class _MarkdownTextState extends State<MarkdownText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();

    final blocks = parseMarkdownBlocks(widget.text);

    // Fast-Path: reiner Text ohne Markdown → identisch zu vorher.
    if (isPlainParagraph(blocks)) {
      return Text(widget.text, style: widget.style);
    }

    final children = <Widget>[];
    for (final block in blocks) {
      final w = _blockWidget(context, block);
      if (w == null) continue;
      if (children.isNotEmpty) {
        children.add(SizedBox(height: block is MdListItem ? 6 : 10));
      }
      children.add(w);
    }
    if (children.isEmpty) return const SizedBox.shrink();
    if (children.length == 1) return children.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget? _blockWidget(BuildContext context, MdBlock block) {
    switch (block) {
      case MdParagraph(:final segments):
        return Text.rich(
            TextSpan(style: widget.style, children: _spans(context, segments)));

      case MdHeading(:final level, :final segments):
        final base = widget.style.fontSize ?? 14;
        final size = base * switch (level) { 1 => 1.35, 2 => 1.2, _ => 1.08 };
        return Text.rich(
          TextSpan(
            style: widget.style.copyWith(
              fontFamily: 'PlusJakartaSans',
              color: context.appFg,
              fontSize: size,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
            children: _spans(context, segments),
          ),
        );

      case MdListItem(:final number, :final segments):
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number == null ? '•' : '$number.',
              style: widget.style.copyWith(
                color: AppTokens.accentDeep,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text.rich(TextSpan(
                  style: widget.style, children: _spans(context, segments))),
            ),
          ],
        );

      case MdQuote(:final segments):
        return Container(
          padding: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: AppTokens.accent.withValues(alpha: 0.6),
                width: 3,
              ),
            ),
          ),
          child: Text.rich(
            TextSpan(
              style: widget.style.copyWith(
                color: context.appFgSub,
                fontStyle: FontStyle.italic,
              ),
              children: _spans(context, segments),
            ),
          ),
        );

      case MdCodeBlock(:final text):
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(AppTokens.rSm),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'monospace',
              color: context.appFg,
              fontSize: (widget.style.fontSize ?? 14) - 1,
              height: 1.5,
            ),
          ),
        );

      case MdDivider():
        return Container(
          height: 1,
          margin: const EdgeInsets.symmetric(vertical: 2),
          color: context.appSeparator,
        );

      case MdImage(:final url, :final alt):
        if (!widget.showImages) return null;
        final resolved = resolveMarkdownUrl(url, widget.serverUrl);
        if (resolved == null) return null;
        return _StepImage(
          url: resolved,
          alt: alt,
          serverUrl: widget.serverUrl,
          apiToken: widget.apiToken,
        );
    }
  }

  List<InlineSpan> _spans(BuildContext context, List<MdSegment> segments) {
    return segments.map<InlineSpan>((s) {
      var style = const TextStyle();
      if (s.bold) style = style.copyWith(fontWeight: FontWeight.w700);
      if (s.italic) style = style.copyWith(fontStyle: FontStyle.italic);
      if (s.code) {
        style = style.copyWith(
          fontFamily: 'monospace',
          backgroundColor: context.appSurface2,
          color: context.appFg,
        );
      }
      final decorations = <TextDecoration>[
        if (s.strike) TextDecoration.lineThrough,
        if (s.linkUrl != null) TextDecoration.underline,
      ];
      if (decorations.isNotEmpty) {
        style = style.copyWith(
          decoration: TextDecoration.combine(decorations),
          decorationColor: s.linkUrl != null
              ? AppTokens.accent.withValues(alpha: 0.55)
              : null,
        );
      }

      TapGestureRecognizer? recognizer;
      if (s.linkUrl != null) {
        style = style.copyWith(
          color: AppTokens.accentDeep,
          fontWeight: s.bold ? FontWeight.w800 : FontWeight.w600,
        );
        final url = s.linkUrl!;
        recognizer = TapGestureRecognizer()
          ..onTap = () => openMarkdownLink(url, serverUrl: widget.serverUrl);
        _recognizers.add(recognizer);
      }

      return TextSpan(text: s.text, style: style, recognizer: recognizer);
    }).toList();
  }
}

/// Eingebettetes Schritt-Bild als gerundete Karte. Der Bearer-Token wird nur
/// an den eigenen Mealie-Server geschickt, nie an fremde Hosts.
class _StepImage extends StatelessWidget {
  final String url;
  final String alt;
  final String? serverUrl;
  final String? apiToken;

  const _StepImage({
    required this.url,
    required this.alt,
    this.serverUrl,
    this.apiToken,
  });

  @override
  Widget build(BuildContext context) {
    // Nur exakt der eigene Server bekommt den Token — mit Pfadgrenze, damit
    // z. B. „https://srv.de.evil.com" nicht als Präfix von „https://srv.de"
    // durchgeht; Trailing-Slash in den Settings wird normalisiert.
    var base = (serverUrl ?? '').trim();
    if (base.endsWith('/')) base = base.substring(0, base.length - 1);
    final sendAuth = base.isNotEmpty &&
        (apiToken ?? '').isNotEmpty &&
        (url == base || url.startsWith('$base/'));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTokens.rMd),
        child: CachedNetworkImage(
          imageUrl: url,
          httpHeaders: sendAuth ? {'Authorization': 'Bearer $apiToken'} : null,
          width: double.infinity,
          height: 190,
          fit: BoxFit.cover,
          placeholder: (_, __) => _placeholder(context),
          errorWidget: (_, __, ___) => _placeholder(context),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) => Container(
        height: 190,
        color: context.appSurface2,
        alignment: Alignment.center,
        child:
            Icon(Icons.image_rounded, color: context.appFgTertiary, size: 40),
      );
}
