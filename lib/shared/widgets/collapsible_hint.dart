import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Einklappbarer Erklärtext (TestFlight-Feedback: „gut, aber nur am Anfang —
// danach nimmt er viel Platz weg"). Antippen klappt ihn auf eine Zeile
// zusammen bzw. wieder auf; der Zustand wird je [prefsKey] lokal gemerkt.
// Für Einleitungstexte oben auf Bildschirmen/Sheets — NICHT für Warnungen
// (fehlende Rechte o. ä.), die sollen sichtbar bleiben. Passt der Text
// ohnehin in EINE Zeile, gibt es nichts einzuklappen: dann ohne Pfeil und
// ohne Tipp-Funktion (User-Wunsch).
// ---------------------------------------------------------------------------

class CollapsibleHint extends StatefulWidget {
  final String text;

  /// SharedPreferences-Schlüssel für den eingeklappten Zustand.
  final String prefsKey;
  final IconData icon;

  /// Kompakt (kleineres Symbol, weniger Innenabstand) — z. B. in Sheets.
  final bool dense;

  const CollapsibleHint({
    super.key,
    required this.text,
    required this.prefsKey,
    this.icon = Icons.lightbulb_outline_rounded,
    this.dense = false,
  });

  @override
  State<CollapsibleHint> createState() => _CollapsibleHintState();
}

class _CollapsibleHintState extends State<CollapsibleHint> {
  bool _collapsed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final v =
          (await SharedPreferences.getInstance()).getBool(widget.prefsKey);
      if (v != null && mounted) setState(() => _collapsed = v);
    } catch (_) {}
  }

  Future<void> _toggle() async {
    HapticFeedback.selectionClick();
    setState(() => _collapsed = !_collapsed);
    try {
      await (await SharedPreferences.getInstance())
          .setBool(widget.prefsKey, _collapsed);
    } catch (_) {}
  }

  TextStyle _textStyle(BuildContext context) => TextStyle(
      color: context.appFgSub, fontSize: widget.dense ? 13 : 14, height: 1.4);

  /// Passt der Text in eine Zeile der verfügbaren Breite (ohne Pfeil)?
  bool _fitsOneLine(BuildContext context, double maxWidth) {
    final pad = widget.dense ? 12.0 : 16.0;
    final icon = widget.dense ? 32.0 : 44.0;
    final textWidth = maxWidth - 2 * pad - 2 - icon - 12;
    if (textWidth <= 0) return false;
    final tp = TextPainter(
      text: TextSpan(text: widget.text, style: _textStyle(context)),
      maxLines: 1,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: textWidth);
    return !tp.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, box) {
      if (_fitsOneLine(context, box.maxWidth)) return _plain(context);
      return _collapsible(context);
    });
  }

  /// Kurzer Hinweis: einfach anzeigen.
  Widget _plain(BuildContext context) {
    final big = !widget.dense;
    return Container(
      padding: EdgeInsets.all(big ? 16 : 12),
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(AppTokens.rLg),
        border: Border.all(color: context.appSeparator),
      ),
      child: Row(children: [
        Container(
          width: big ? 44 : 32,
          height: big ? 44 : 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(big ? 13 : 10),
            gradient: AppTokens.accentGradient,
          ),
          child: Icon(widget.icon, color: Colors.white, size: big ? 23 : 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(widget.text, style: _textStyle(context))),
      ]),
    );
  }

  Widget _collapsible(BuildContext context) {
    final big = !widget.dense && !_collapsed;
    final iconSize = big ? 44.0 : 32.0;
    return Semantics(
      button: true,
      expanded: !_collapsed,
      child: Material(
        color: context.appCard,
        borderRadius: BorderRadius.circular(AppTokens.rLg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTokens.rLg),
          onTap: _toggle,
          child: Container(
            padding: EdgeInsets.all(big ? 16 : 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTokens.rLg),
              border: Border.all(color: context.appSeparator),
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: Row(
                crossAxisAlignment: _collapsed
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(big ? 13 : 10),
                      gradient: AppTokens.accentGradient,
                    ),
                    child: Icon(widget.icon,
                        color: Colors.white, size: big ? 23 : 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(widget.text,
                        maxLines: _collapsed ? 1 : null,
                        overflow: _collapsed ? TextOverflow.ellipsis : null,
                        style: _textStyle(context)),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _collapsed
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    color: context.appFgSub,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
