import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../core/utils/platform_features.dart';
import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Liquid-Glass-Bausteine (Premium-Redesign).
//
// Flutter hat kein natives iOS-26-„Liquid Glass". Wir approximieren es:
// BackdropFilter-Blur (Inhalt dahinter wird durchscheinend verschwommen) +
// transluzenter Verlaufs-Fill + heller Rand-Highlight oben (simuliert die
// Lichtkante von Glas). Sieht auf beiden Plattformen edel & einheitlich aus.
// ---------------------------------------------------------------------------

/// Allgemeines frosted-glass-Panel. `blur` = Stärke der Unschärfe.
class LiquidGlass extends StatelessWidget {
  final Widget child;
  final double blur;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? tint;

  const LiquidGlass({
    super.key,
    required this.child,
    this.blur = 18,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppTokens.rLg)),
    this.padding,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDark;
    // Transluzenter Fill: hell = milchiges Weiß, dunkel = warmes Dunkel.
    final fill = tint ??
        (dark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.55));
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: dark
                  ? [
                      Colors.white.withValues(alpha: 0.10),
                      Colors.white.withValues(alpha: 0.03),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.70),
                      Colors.white.withValues(alpha: 0.45),
                    ],
            ),
            color: fill,
            border: Border.all(
              color: dark
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.7),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// GlassTabBar — schwebende Liquid-Glass-Bottom-Navigation.
//
// Nutzung: im Scaffold `extendBody: true` setzen und
// `bottomNavigationBar: const GlassTabBar(current: GlassTab.home)`.
// Der Body-Inhalt scheint dann unter dem Blur durch. Scroll-Inhalte sollten
// unten ~`GlassTabBar.height` Platz lassen.
// ---------------------------------------------------------------------------

enum GlassTab { home, recipes, shopping, plan, settings }

class GlassTabBar extends StatelessWidget {
  final GlassTab current;
  const GlassTabBar({super.key, required this.current});

  /// Höhe des sichtbaren Balkens (ohne untere SafeArea) — für Body-Padding.
  static const double height = 50;

  static String _routeFor(GlassTab t) {
    switch (t) {
      case GlassTab.home:
        return '/home';
      case GlassTab.recipes:
        return '/recipes';
      case GlassTab.shopping:
        return '/shopping';
      case GlassTab.plan:
        return '/mealplan';
      case GlassTab.settings:
        return '/settings';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final items = <(GlassTab, IconData, String)>[
      (GlassTab.home, Icons.home_rounded, l.navHome),
      (GlassTab.recipes, Icons.restaurant_menu_rounded, l.recipes),
      (GlassTab.shopping, Icons.shopping_cart_rounded, l.shopping),
      (GlassTab.plan, Icons.event_rounded, l.planning),
      (GlassTab.settings, Icons.settings_rounded, l.navSettings),
    ];

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: context.isDark
                  ? [
                      const Color(0xFF1A1714).withValues(alpha: 0.80),
                      const Color(0xFF0E0C0A).withValues(alpha: 0.92),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.78),
                      Colors.white.withValues(alpha: 0.90),
                    ],
            ),
            border: Border(
              top: BorderSide(
                color: context.isDark
                    ? Colors.white.withValues(alpha: 0.10)
                    : Colors.white.withValues(alpha: 0.9),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: height,
              // Große Anzeige (Windows/macOS): Tabs mittig gebündelt statt über
              // die ganze Fensterbreite verteilt.
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth:
                          LargeScreen.isWide(context) ? 640 : double.infinity),
                  child: Row(
                    children: [
                      for (final (tab, icon, label) in items)
                        Expanded(
                          child: _GlassTabItem(
                            icon: icon,
                            label: label,
                            active: tab == current,
                            onTap: () {
                              if (tab == current) return;
                              HapticFeedback.selectionClick();
                              context.go(_routeFor(tab));
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassTabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _GlassTabItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: 21, color: active ? Colors.white : context.appFgTertiary),
          const SizedBox(height: 1),
          // FittedBox(scaleDown): lange Labels (z. B. „Einstellungen") werden
          // verkleinert statt abgeschnitten — bekommt die Tab-Breite als
          // Constraint (crossAxis ist hier zentriert, Breite = Expanded).
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                color: active ? Colors.white : context.appFgTertiary,
              ),
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: active
          // Aktiver Tab: Icon+Label mit Orange-Verlauf eingefärbt.
          ? ShaderMask(
              shaderCallback: (r) => AppTokens.accentGradient.createShader(r),
              blendMode: BlendMode.srcIn,
              child: content,
            )
          : content,
    );
  }
}
