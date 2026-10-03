import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Premium-Redesign Design-Tokens.
//
// Warme Food-App-Identität: weiches Off-White / warmes Dunkel statt kühlem
// iOS-Grau, ein Orange-Verlauf als Akzent, große Radien, geschichtete weiche
// Schatten. Die bisherigen Getter-Namen (appBg/appCard/…) bleiben erhalten,
// damit bestehende Screens unverändert weiterlaufen — nur die Werte sind neu.
// ---------------------------------------------------------------------------

class AppTokens {
  // Akzent (Orange-Verlauf)
  static const accent = Color(0xFFFF8A00);
  static const accentDeep = Color(0xFFFF6A00);
  static const accentLight = Color(0xFFFFB23E);
  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB23E), Color(0xFFFF8A00), Color(0xFFFF6A00)],
    stops: [0.0, 0.45, 1.0],
  );

  // Radien
  static const rSm = 14.0;
  static const rMd = 18.0;
  static const rLg = 22.0;
  static const rXl = 26.0;

  // Spacing-Skala
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0;
  static const s5 = 24.0;
  static const s6 = 32.0;
}

extension AppColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // ── Flächen ──────────────────────────────────────────────────────────────
  Color get appBg => isDark ? const Color(0xFF0E0C0A) : const Color(0xFFF6F3EE);

  Color get appCard => isDark ? const Color(0xFF1A1714) : Colors.white;

  Color get appSurface2 =>
      isDark ? const Color(0xFF231F1B) : const Color(0xFFEFEAE2);

  Color get appSeparator =>
      isDark ? const Color(0xFF2A2521) : const Color(0xFFECE6DD);

  // ── Text ─────────────────────────────────────────────────────────────────
  Color get appFg => isDark ? const Color(0xFFF5F1EA) : const Color(0xFF15110C);

  Color get appFgSub =>
      isDark ? const Color(0xFFB6AB9C) : const Color(0xFF6B6258);

  Color get appFgTertiary =>
      isDark ? const Color(0xFF7D7468) : const Color(0xFFA39A8E);

  // ── Akzent ─────────────────────────────────────────────────────────────────
  Color get appAccent => AppTokens.accent;
  Color get appAccentDeep => AppTokens.accentDeep;
  Gradient get appAccentGradient => AppTokens.accentGradient;

  // ── Schatten (weich, geschichtet) ──────────────────────────────────────────
  List<BoxShadow> get appShadowSm => isDark
      ? const [
          BoxShadow(
              color: Color(0x33000000), blurRadius: 12, offset: Offset(0, 4)),
        ]
      : const [
          BoxShadow(
              color: Color(0x0D281C0C), blurRadius: 2, offset: Offset(0, 1)),
          BoxShadow(
              color: Color(0x10281C0C), blurRadius: 12, offset: Offset(0, 4)),
        ];

  List<BoxShadow> get appShadowMd => isDark
      ? const [
          BoxShadow(
              color: Color(0x4D000000), blurRadius: 28, offset: Offset(0, 12)),
        ]
      : const [
          BoxShadow(
              color: Color(0x14281C0C), blurRadius: 16, offset: Offset(0, 6)),
          BoxShadow(
              color: Color(0x1A281C0C), blurRadius: 40, offset: Offset(0, 18)),
        ];

  /// Glühender Schatten für den primären Verlaufs-Akzent (CTAs, Counts).
  List<BoxShadow> get appAccentGlow => const [
        BoxShadow(
            color: Color(0x59FF7800), blurRadius: 24, offset: Offset(0, 10)),
      ];
}
