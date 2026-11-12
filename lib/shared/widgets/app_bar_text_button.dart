import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Text-Knopf in der AppBar — überall gleich:
//   • neutral (Abbrechen, Verwerfen): Textfarbe, normales Gewicht
//   • primary (Speichern, Fertig): Akzentfarbe, kräftig
// Rot bleibt dem Löschen vorbehalten. [busy] zeigt statt des Textes einen
// kleinen Spinner (Speichern läuft).
// ---------------------------------------------------------------------------

class AppBarTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool primary;
  final bool busy;

  const AppBarTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.primary = false,
    this.busy = false,
  });

  /// Breite für `AppBar.leadingWidth`, wenn der Knopf links sitzt.
  static const leadingWidth = 104.0;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;
    final color = !enabled
        ? context.appFgTertiary
        : primary
            ? AppTokens.accentDeep
            : context.appFg;
    return TextButton(
      onPressed: enabled ? onPressed : null,
      child: busy
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2))
          : Text(label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: TextStyle(
                  color: color,
                  fontWeight: primary ? FontWeight.w700 : FontWeight.w500)),
    );
  }
}
