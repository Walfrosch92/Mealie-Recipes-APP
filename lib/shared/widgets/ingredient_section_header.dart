import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Überschrift eines Zutaten-Abschnitts (Mealie „Abschnitt hinzufügen",
/// Feld `title` an der ersten Zutat des Abschnitts). Gleiche Optik in
/// Detailansicht und Kochmodus: Akzentfarbe, fett, wie in der Mealie-Web-UI.
class IngredientSectionHeader extends StatelessWidget {
  const IngredientSectionHeader({
    super.key,
    required this.title,
    this.isFirst = false,
    this.horizontalPadding = 16,
  });

  final String title;

  /// Erster Eintrag der Liste: weniger Abstand nach oben.
  final bool isFirst;

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          horizontalPadding, isFirst ? 8 : 20, horizontalPadding, 6),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTokens.accentDeep,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
