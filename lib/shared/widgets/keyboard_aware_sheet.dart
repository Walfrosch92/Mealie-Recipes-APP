import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Höhe für Bottom-Sheets mit Suchfeld oben und Trefferliste darunter.
//
// Material-Bottom-Sheets weichen der Tastatur nicht aus: bei fester Höhe
// (z. B. 85 %) lag die Trefferliste samt „Fertig"-Knopf HINTER der
// Tastatur — man sah beim Tippen nicht, was gefunden wurde. Hier endet das
// Sheet immer über der Tastatur und nutzt bei offener Tastatur die volle
// verfügbare Höhe, damit möglichst viele Treffer sichtbar sind.
// Voraussetzung: `showModalBottomSheet(isScrollControlled: true)` und eine
// Trefferliste in `Expanded`.
// ---------------------------------------------------------------------------

class KeyboardAwareSheet extends StatelessWidget {
  /// Anteil der verfügbaren Höhe, solange die Tastatur zu ist.
  final double heightFactor;
  final Widget child;

  const KeyboardAwareSheet({
    super.key,
    required this.heightFactor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    // Ohne `useSafeArea` reicht das Sheet bis unter die Statusleiste.
    final topInset = MediaQuery.paddingOf(context).top;
    return LayoutBuilder(builder: (context, constraints) {
      final available = constraints.maxHeight - topInset - keyboard;
      final height = keyboard > 0
          ? available
          : (constraints.maxHeight - topInset) * heightFactor;
      return Padding(
        padding: EdgeInsets.only(bottom: keyboard),
        child: SizedBox(
          height: height.clamp(0.0, constraints.maxHeight),
          child: child,
        ),
      );
    });
  }
}
