import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Einheitlicher Chip im App-Stil (statt der Material-Standard-Chips):
// runde Pille, 38 px hoch. Aktiv = orange getönt + oranger Rand + kräftige
// Schrift, sonst Kartenfarbe mit feinem Rand. Optional Symbol vorn und ✕ zum
// Entfernen ([onRemove]).
// ---------------------------------------------------------------------------

class AppChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final String? removeTooltip;

  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
    this.onRemove,
    this.removeTooltip,
  });

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppTokens.accentDeep : context.appFg;
    return Semantics(
      button: onTap != null,
      selected: selected,
      child: Material(
        color: selected
            ? AppTokens.accent.withValues(alpha: 0.16)
            : context.appCard,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected
                ? AppTokens.accent.withValues(alpha: 0.5)
                : context.appSeparator,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 38,
            padding:
                EdgeInsets.only(left: 14, right: onRemove != null ? 4 : 14),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: fg),
                const SizedBox(width: 6),
              ],
              // Feste Höchstbreite statt Flexible: Chips stehen auch in seitlich
              // scrollbaren Reihen (unbegrenzte Breite) — Flexible würfe dort
              // einen Layout-Fehler.
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 240),
                child: Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: fg,
                        fontSize: 14,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w600)),
              ),
              if (onRemove != null)
                IconButton(
                  tooltip: removeTooltip,
                  visualDensity: VisualDensity.compact,
                  iconSize: 16,
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints.tightFor(width: 30, height: 30),
                  icon: Icon(Icons.close_rounded, color: fg),
                  onPressed: onRemove,
                ),
            ]),
          ),
        ),
      ),
    );
  }
}
