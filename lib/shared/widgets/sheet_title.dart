import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'gradient_button.dart' show SheetHandle;

// ---------------------------------------------------------------------------
// Kopf eines Bottom-Sheets — überall gleich:
//   SheetHandle (Griff, mittig)  +  SheetTitle (Display-Schrift, 18, fett)
//
// SheetTitle ist nur der Text (Abstände bestimmt das Sheet); SheetHeader
// bündelt Griff + Titel + optionale Aktion rechts für Sheets ohne eigenes
// Kopf-Layout.
// ---------------------------------------------------------------------------

class SheetTitle extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const SheetTitle(this.text, {super.key, this.textAlign});

  @override
  Widget build(BuildContext context) => Text(text,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          color: context.appFg,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3));
}

class SheetHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const SheetHeader({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 8, 8),
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetHandle(),
          Padding(
            padding: padding,
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: AppTokens.accent),
                  const SizedBox(width: 8),
                ],
                Expanded(child: SheetTitle(title)),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ],
      );
}
