import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'animations.dart';

// ---------------------------------------------------------------------------
// Wiederverwendbare Premium-Buttons (Verlaufs-CTA + sekundär).
// ---------------------------------------------------------------------------

/// Primärer Verlaufs-Button (Orange-Gradient + Glow). Für die wichtigste
/// Aktion eines Screens.
///
/// `busy`: während die App im Hintergrund arbeitet (z. B. Zutaten mehrerer
/// Rezepte werden zur Einkaufsliste hinzugefügt), fährt ein Warenkorb
/// wiederholt von links nach rechts durch den Button statt Label/Icon zu
/// zeigen — mirrors RecipeDetail._ActionButton (dieselbe Animation, hier
/// zentral für alle GradientButton-Aufrufer verfügbar).
class GradientButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final double height;
  final bool busy;
  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.height = 54,
    this.busy = false,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  // Eager in initState erzeugen (nicht `late`-lazy) — sonst würde der
  // Controller bei einem nie „busy" gewesenen Button erst in dispose()
  // erzeugt; das vsync/TickerMode-Lookup am bereits deaktivierten Widget
  // wirft dann „Looking up a deactivated widget's ancestor is unsafe".
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100));
    if (widget.busy) _ctrl.repeat();
  }

  @override
  void didUpdateWidget(covariant GradientButton old) {
    super.didUpdateWidget(old);
    if (widget.busy && !_ctrl.isAnimating) {
      _ctrl.repeat();
    } else if (!widget.busy && _ctrl.isAnimating) {
      _ctrl.stop();
      _ctrl.reset();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null || widget.busy;
    return BounceTap(
      onTap: widget.busy ? null : widget.onTap,
      scale: 0.97,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Container(
          height: widget.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: AppTokens.accentGradient,
            borderRadius: BorderRadius.circular(AppTokens.rMd),
            boxShadow: enabled ? context.appAccentGlow : null,
          ),
          child: widget.busy
              ? LayoutBuilder(
                  builder: (context, c) {
                    const cartSize = 24.0;
                    return AnimatedBuilder(
                      animation: _ctrl,
                      builder: (context, _) {
                        final dx =
                            (c.maxWidth + cartSize) * _ctrl.value - cartSize;
                        return Stack(
                          children: [
                            Positioned(
                              left: dx,
                              top: 0,
                              bottom: 0,
                              child: const Center(
                                child: Icon(Icons.shopping_cart,
                                    color: Colors.white, size: cartSize),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: Colors.white, size: 21),
                      const SizedBox(width: 9),
                    ],
                    Flexible(
                      child: Text(
                        widget.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Sekundärer Button (umrandet, warme Karten-Optik).
class SecondaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final double height;
  const SecondaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      onTap: onTap,
      scale: 0.97,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: context.appCard,
          borderRadius: BorderRadius.circular(AppTokens.rMd),
          border: Border.all(color: context.appSeparator, width: 1),
          boxShadow: context.appShadowSm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: context.appFg, size: 20),
              const SizedBox(width: 9),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: context.appFg,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grip-Indikator oben in einem Bottom-Sheet.
class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 5,
      margin: const EdgeInsets.only(top: 10, bottom: 8),
      decoration: BoxDecoration(
        color: context.appSeparator,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

/// Premium-Karte (warme Fläche, Radius, weicher Schatten).
class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(AppTokens.rLg),
        border: Border.all(color: context.appSeparator, width: 1),
        boxShadow: context.appShadowSm,
      ),
      child: child,
    );
  }
}
