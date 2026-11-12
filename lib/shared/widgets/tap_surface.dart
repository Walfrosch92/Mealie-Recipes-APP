import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Farbige Tipp-Fläche MIT sichtbarem Ripple. Typischer Fehler vorher:
// InkWell → Container(color: …) — die Farbe des Containers liegt ÜBER dem
// Ripple (der auf das Material darunter malt), Antippen gab also kein
// optisches Feedback. Hier liegt die Farbe auf einem eigenen Material
// unter dem InkWell, Schatten außen, Rahmen und Inhalt obenauf.
// ---------------------------------------------------------------------------

class TapSurface extends StatelessWidget {
  final Color color;
  final BorderRadius borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final Widget child;

  const TapSurface({
    super.key,
    required this.color,
    required this.borderRadius,
    required this.child,
    this.onTap,
    this.border,
    this.boxShadow,
    this.margin,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget surface = Material(
      color: color,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: border == null
              ? null
              : BoxDecoration(border: border, borderRadius: borderRadius),
          child: child,
        ),
      ),
    );
    if (boxShadow != null && boxShadow!.isNotEmpty) {
      surface = DecoratedBox(
        decoration:
            BoxDecoration(borderRadius: borderRadius, boxShadow: boxShadow),
        child: surface,
      );
    }
    return margin == null ? surface : Padding(padding: margin!, child: surface);
  }
}
