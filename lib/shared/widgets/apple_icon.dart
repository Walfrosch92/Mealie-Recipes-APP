import 'package:flutter/material.dart';

/// Apfel-Symbol (Obst) für „Lebensmittel" — Material Icons hat keinen Apfel
/// (`Icons.apple` ist das Firmenlogo). Gefüllte Silhouette mit Stiel und
/// Blatt, verhält sich wie ein [Icon] ([size], [color]).
class AppleIcon extends StatelessWidget {
  final double size;
  final Color? color;
  const AppleIcon({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? IconTheme.of(context).color ?? Colors.black;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _ApplePainter(c)),
    );
  }
}

class _ApplePainter extends CustomPainter {
  final Color color;
  _ApplePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // Innenabstand so gewählt, dass die Farbfläche der von Material-Glyphen
    // wie kitchen/category/eco entspricht (gerendert verglichen 2026-09-30:
    // Kachel 23 px ≈ 170, Liste 20 px ≈ 128 — wie deren Mittelwert).
    final pad = size.width * 0.13;
    final w = size.width - 2 * pad;
    final h = size.height - 2 * pad;
    Offset p(double x, double y) => Offset(pad + x * w, pad + y * h);
    final fill = Paint()
      ..color = color
      ..isAntiAlias = true;

    // Körper: zwei Backen, oben und unten leicht eingezogen.
    final body = Path()
      ..moveTo(p(0.5, 0.30).dx, p(0.5, 0.30).dy)
      ..cubicTo(p(0.62, 0.20).dx, p(0.62, 0.20).dy, p(0.94, 0.22).dx,
          p(0.94, 0.22).dy, p(0.94, 0.54).dx, p(0.94, 0.54).dy)
      ..cubicTo(p(0.94, 0.82).dx, p(0.94, 0.82).dy, p(0.74, 1.0).dx,
          p(0.74, 1.0).dy, p(0.61, 0.98).dx, p(0.61, 0.98).dy)
      ..cubicTo(p(0.56, 0.97).dx, p(0.56, 0.97).dy, p(0.54, 0.94).dx,
          p(0.54, 0.94).dy, p(0.5, 0.94).dx, p(0.5, 0.94).dy)
      ..cubicTo(p(0.46, 0.94).dx, p(0.46, 0.94).dy, p(0.44, 0.97).dx,
          p(0.44, 0.97).dy, p(0.39, 0.98).dx, p(0.39, 0.98).dy)
      ..cubicTo(p(0.26, 1.0).dx, p(0.26, 1.0).dy, p(0.06, 0.82).dx,
          p(0.06, 0.82).dy, p(0.06, 0.54).dx, p(0.06, 0.54).dy)
      ..cubicTo(p(0.06, 0.22).dx, p(0.06, 0.22).dy, p(0.38, 0.20).dx,
          p(0.38, 0.20).dy, p(0.5, 0.30).dx, p(0.5, 0.30).dy)
      ..close();
    canvas.drawPath(body, fill);

    // Stiel.
    canvas.drawLine(
      p(0.5, 0.30),
      p(0.54, 0.06),
      Paint()
        ..color = color
        ..strokeWidth = w * 0.075
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true,
    );

    // Blatt.
    final leaf = Path()
      ..moveTo(p(0.56, 0.19).dx, p(0.56, 0.19).dy)
      ..quadraticBezierTo(p(0.62, 0.01).dx, p(0.62, 0.01).dy, p(0.84, 0.03).dx,
          p(0.84, 0.03).dy)
      ..quadraticBezierTo(p(0.78, 0.20).dx, p(0.78, 0.20).dy, p(0.56, 0.19).dx,
          p(0.56, 0.19).dy)
      ..close();
    canvas.drawPath(leaf, fill);
  }

  @override
  bool shouldRepaint(_ApplePainter old) => old.color != color;
}

/// Platzhalter für den Apfel: Kachel-Modelle speichern Icons als
/// [IconData] — dieser Wert wird von [iconOrApple] als [AppleIcon]
/// gezeichnet. Bewusst ein ECHTES, sonst ungenutztes Material-Icon (keine
/// erfundene Schriftart — die bräche das Icon-Tree-Shaking im App-Build).
const kAppleIcon = Icons.egg_alt_rounded;

/// Platzhalter für den Messbecher (Einheiten) — wie [kAppleIcon].
const kMeasuringCupIcon = Icons.straighten_rounded;

/// [Icon] bzw. die selbst gezeichneten Symbole (Apfel, Messbecher).
/// [appleScale] verkleinert nur den Apfel — seine gefüllte Fläche wirkt in
/// den großen Kacheln massiger als Material-Glyphen (User-Rückmeldung).
Widget iconOrApple(IconData icon,
    {Color? color, double size = 24, double appleScale = 1}) {
  if (icon == kAppleIcon) {
    return SizedBox.square(
      dimension: size,
      child: Center(child: AppleIcon(size: size * appleScale, color: color)),
    );
  }
  if (icon == kMeasuringCupIcon) {
    return SizedBox.square(
      dimension: size,
      child: Center(child: MeasuringCupIcon(size: size, color: color)),
    );
  }
  return Icon(icon, color: color, size: size);
}

/// Messbecher-Symbol für „Einheiten": Becher mit Ausguss, Henkel und drei
/// ausgesparten Skalenstrichen. Verhält sich wie ein [Icon].
class MeasuringCupIcon extends StatelessWidget {
  final double size;
  final Color? color;
  const MeasuringCupIcon({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? IconTheme.of(context).color ?? Colors.black;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _CupPainter(c)),
    );
  }
}

class _CupPainter extends CustomPainter {
  final Color color;
  _CupPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // Etwas weniger Innenabstand als der Apfel: der Becher ist schmal und
    // wirkte neben den Material-Glyphen sonst zu klein (Vergleich gerendert).
    final pad = size.width * 0.05;
    final w = size.width - 2 * pad;
    final h = size.height - 2 * pad;
    Offset p(double x, double y) => Offset(pad + x * w, pad + y * h);
    final fill = Paint()
      ..color = color
      ..isAntiAlias = true;

    canvas.saveLayer(Offset.zero & size, Paint());

    // Becher: oben breiter, links mit Ausguss, unten abgerundet.
    final body = Path()
      ..moveTo(p(0.04, 0.06).dx, p(0.04, 0.06).dy) // Ausguss-Spitze
      ..lineTo(p(0.70, 0.06).dx, p(0.70, 0.06).dy)
      ..lineTo(p(0.64, 0.90).dx, p(0.64, 0.90).dy)
      ..quadraticBezierTo(
          p(0.63, 1.0).dx, p(0.63, 1.0).dy, p(0.53, 1.0).dx, p(0.53, 1.0).dy)
      ..lineTo(p(0.27, 1.0).dx, p(0.27, 1.0).dy)
      ..quadraticBezierTo(
          p(0.17, 1.0).dx, p(0.17, 1.0).dy, p(0.16, 0.90).dx, p(0.16, 0.90).dy)
      ..lineTo(p(0.12, 0.24).dx, p(0.12, 0.24).dy)
      ..close();
    canvas.drawPath(body, fill);

    // Henkel rechts (Bogen).
    final handle = Path()
      ..moveTo(p(0.67, 0.26).dx, p(0.67, 0.26).dy)
      ..cubicTo(p(1.0, 0.24).dx, p(1.0, 0.24).dy, p(1.0, 0.72).dx,
          p(1.0, 0.72).dy, p(0.63, 0.70).dx, p(0.63, 0.70).dy);
    canvas.drawPath(
        handle,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.11
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true);

    // Skalenstriche als Aussparung (lang – kurz – lang).
    final clear = Paint()
      ..blendMode = BlendMode.clear
      ..strokeWidth = h * 0.075
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(p(0.28, 0.36), p(0.50, 0.36), clear);
    canvas.drawLine(p(0.28, 0.56), p(0.40, 0.56), clear);
    canvas.drawLine(p(0.28, 0.76), p(0.50, 0.76), clear);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CupPainter old) => old.color != color;
}
