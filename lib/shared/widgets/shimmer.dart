import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Shimmer-Skeletons (Premium-Ladezustand).
//
// `Shimmer` legt einen wandernden Glanz über beliebige opake Platzhalter-
// Formen (mit `BlendMode.srcATop`). Die Formen selbst baust du aus
// `ShimmerBox` (abgerundete Rechtecke in Basisfarbe).
// ---------------------------------------------------------------------------

class Shimmer extends StatefulWidget {
  final Widget child;
  const Shimmer({super.key, required this.child});

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = context.isDark;
    final base = dark ? const Color(0xFF231F1B) : const Color(0xFFEFEAE2);
    final hi = dark ? const Color(0xFF332E29) : Colors.white;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = _c.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 - 2 * (1 - t), 0),
              end: Alignment(1.0 + 2 * t, 0),
              colors: [base, hi, base],
              stops: const [0.35, 0.5, 0.65],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Ein abgerundetes Platzhalter-Rechteck in Basisfarbe (für Shimmer).
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;
  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.appSurface2,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
