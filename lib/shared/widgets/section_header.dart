import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Abschnittsüberschrift der Rezeptdetailansicht (Utensilien, Notizen,
/// Kommentare): Verlaufs-Symbol wie die Home-Kacheln, Titel in der
/// Display-Schrift, optional eine Anzahl-Plakette und rechts eine Aktion.
/// Vorher hatte jeder Abschnitt seine eigene Optik (kleines graues Label vs.
/// fette Überschrift).
class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final int? count;
  final Widget? trailing;

  /// Aufklappbar: Tippen auf die Überschrift ruft [onToggle], rechts zeigt ein
  /// Pfeil den Zustand. `null` = nicht aufklappbar.
  final VoidCallback? onToggle;
  final bool expanded;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.count,
    this.trailing,
    this.onToggle,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final row = _row(context);
    if (onToggle == null) return row;
    return Semantics(
      button: true,
      expanded: expanded,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.rSm),
        onTap: onToggle,
        child: row,
      ),
    );
  }

  Widget _row(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: onToggle != null && !expanded ? 4 : 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              gradient: AppTokens.accentGradient,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: Colors.white, size: 17),
          ),
          const SizedBox(width: 10),
          // Titel + Anzahl nehmen den GANZEN freien Platz ein (Expanded),
          // der Pfeil sitzt dadurch immer ganz rechts. Vorher teilten sich
          // ein Flexible-Titel und ein Spacer den Platz je zur Hälfte → der
          // Pfeil stand je nach Titellänge unterschiedlich weit links.
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: context.appFg,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2)),
                ),
                if (count != null && count! > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTokens.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text('$count',
                        style: const TextStyle(
                            color: AppTokens.accentDeep,
                            fontSize: 12,
                            fontWeight: FontWeight.w800)),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null && expanded) trailing!,
          if (onToggle != null) ...[
            const SizedBox(width: 6),
            // Feste Breite: der Pfeil sitzt in jedem Bereich an derselben Stelle
            SizedBox(
              width: 24,
              child: AnimatedRotation(
                turns: expanded ? 0 : -0.25,
                duration: const Duration(milliseconds: 140),
                child: Icon(Icons.expand_more_rounded,
                    color: context.appFgTertiary, size: 24),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Kompakter Aktions-Button für [SectionHeader.trailing] („+ Notiz").
class SectionHeaderAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SectionHeaderAction(
      {super.key,
      required this.icon,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTokens.accent.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppTokens.accentDeep),
              const SizedBox(width: 4),
              Text(label,
                  style: const TextStyle(
                      color: AppTokens.accentDeep,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Einheitliche Karte der Detailansicht (Notiz, Kommentar): wie die übrigen
/// Karten der App mit Rand, Schatten und größerem Radius.
BoxDecoration detailCardDecoration(BuildContext context) => BoxDecoration(
      color: context.appCard,
      borderRadius: BorderRadius.circular(AppTokens.rMd),
      border: Border.all(color: context.appSeparator, width: 1),
      boxShadow: context.appShadowSm,
    );

/// Ein-/ausklappbarer Inhalt unter einer [SectionHeader] (weiche Höhen-
/// animation). [expanded] = false blendet [child] aus.
class CollapsibleBody extends StatelessWidget {
  final bool expanded;
  final Widget child;
  const CollapsibleBody(
      {super.key, required this.expanded, required this.child});

  @override
  Widget build(BuildContext context) {
    // Kurz und mit schnellem Auslauf; RepaintBoundary hält das Neuzeichnen
    // während der Animation auf diesen Bereich begrenzt.
    return AnimatedSize(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: expanded
          ? RepaintBoundary(child: child)
          : const SizedBox(width: double.infinity),
    );
  }
}

/// Hinzufügen-Knopf im Inhalt eines Detail-Abschnitts (wie „Notiz
/// hinzufügen"): volle Breite, dezent getönt. [busy] zeigt einen Lade-Kreis.
class SectionAddButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool busy;

  const SectionAddButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon = Icons.add_circle_outline_rounded,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTokens.accent.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(AppTokens.rMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.rMd),
        onTap: busy ? null : onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTokens.rMd),
            border: Border.all(
                color: AppTokens.accent.withValues(alpha: 0.35), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (busy)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppTokens.accentDeep),
                )
              else
                Icon(icon, size: 20, color: AppTokens.accentDeep),
              const SizedBox(width: 8),
              Flexible(
                child: Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppTokens.accentDeep,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
