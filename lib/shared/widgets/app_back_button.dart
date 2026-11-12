import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Zurück-Symbol der App — dasselbe in jeder AppBar (auch für den
/// automatischen Zurück-Knopf, siehe `actionIconTheme` in app.dart).
const kAppBackIcon = Icons.chevron_left_rounded;
const kAppBackIconSize = 28.0;

/// Zurück-Knopf mit eigenem Ziel (z. B. Rezeptdetail ohne Navigator-Eintrag).
class AppBackButton extends StatelessWidget {
  final VoidCallback onTap;
  const AppBackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: Icon(kAppBackIcon, size: kAppBackIconSize, color: context.appFg),
        onPressed: onTap,
      );
}
