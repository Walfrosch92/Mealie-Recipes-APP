import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// Wiederverwendbare, leichtgewichtige Animations-Bausteine (nur Flutter-SDK,
// keine Fremdpakete). Jede nutzt genau einen impliziten Animator bzw. einen
// kurzlebigen Controller → performant, kein Dauer-Rebuild.
// ---------------------------------------------------------------------------

/// Einmaliges Einblenden (Fade + leichtes Hochgleiten) beim ersten Erscheinen.
/// Für statische Bereiche (nicht recycelte Listen).
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double offsetY;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 360),
    this.delay = Duration.zero,
    this.offsetY = 14,
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _a =
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _c.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _c.forward();
      });
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _a,
      builder: (context, child) => Opacity(
        opacity: _a.value,
        child: Transform.translate(
          offset: Offset(0, widget.offsetY * (1 - _a.value)),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

/// Wie [FadeSlideIn], aber spielt pro [id] nur EINMAL pro App-Sitzung — damit
/// Listen-Items beim Zur-Ansicht-Scrollen (ListView.builder recycelt!) nicht
/// jedes Mal neu animieren (das wirkt billig). `index` erzeugt einen kurzen
/// gestaffelten Versatz beim ersten Laden.
class EntranceOnce extends StatelessWidget {
  static final Set<String> _seen = <String>{};

  final String id;
  final int index;
  final Widget child;

  const EntranceOnce({
    super.key,
    required this.id,
    required this.child,
    this.index = 0,
  });

  /// Zurücksetzen (z. B. nach Pull-to-Refresh), damit die Liste neu einblendet.
  static void reset() => _seen.clear();

  @override
  Widget build(BuildContext context) {
    if (_seen.contains(id)) return child;
    _seen.add(id);
    // Versatz nur für die ersten ~12 Items, danach kein Delay (Performance +
    // kein „Nachzappeln" weit unten in langen Listen).
    final steps = index.clamp(0, 12);
    return FadeSlideIn(
      delay: Duration(milliseconds: steps * 35),
      child: child,
    );
  }
}

/// Drück-Feedback: skaliert beim Tippen kurz herunter (premium, taktil) und
/// gibt im selben Moment einen leichten Haptik-Impuls — so weiß der Nutzer
/// SOFORT (vor jeder evtl. Wartezeit der eigentlichen Aktion), dass sein Tap
/// erkannt wurde. `haptic` lässt sich abschalten, wo es zu viel wäre
/// (z. B. schnell wiederholte Taps).
class BounceTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scale;
  final bool haptic;
  final HitTestBehavior behavior;

  const BounceTap({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scale = 0.95,
    this.haptic = true,
    this.behavior = HitTestBehavior.opaque,
  });

  @override
  State<BounceTap> createState() => _BounceTapState();
}

class _BounceTapState extends State<BounceTap> {
  bool _down = false;

  bool get _enabled => widget.onTap != null || widget.onLongPress != null;

  void _press() {
    if (!_down) setState(() => _down = true);
    if (widget.haptic) HapticFeedback.lightImpact();
  }

  void _release() {
    if (_down) setState(() => _down = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: _enabled ? (_) => _press() : null,
      onTapUp: _enabled ? (_) => _release() : null,
      onTapCancel: _enabled ? _release : null,
      child: AnimatedScale(
        scale: _down ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
