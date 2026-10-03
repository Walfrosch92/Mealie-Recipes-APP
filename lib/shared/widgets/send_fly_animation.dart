import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// SendTo-Bestätigungsanimation. Legt einen kurzen Overlay-Effekt mittig über
// den Bildschirm: ein Umschlag schrumpft zur Mitte zusammen und verwandelt
// sich in ein grünes Häkchen-Badge, das mit elastischem Pop erscheint
// (elasticOut) — begleitet von einem Haptik-Impuls genau im Moment des Pop.
// Klares „erledigt"-Gefühl statt nur „weggeflogen".
//
// Eine einzige AnimationController-Instanz treibt alles (Scale + Opacity) →
// günstig, kein Lag.
//
// Aufruf: `showSendFlyAnimation(Overlay.of(context, rootOverlay: true))`.
// Den OverlayState VOR einem evtl. Navigator.pop() abgreifen, damit der
// Effekt das schließende BottomSheet überlebt.
// ---------------------------------------------------------------------------

Future<void> showSendFlyAnimation(OverlayState overlay) {
  final completer = Completer<void>();
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _SendFly(
      onDone: () {
        if (entry.mounted) entry.remove();
        if (!completer.isCompleted) completer.complete();
      },
    ),
  );
  overlay.insert(entry);
  return completer.future;
}

class _SendFly extends StatefulWidget {
  final VoidCallback onDone;
  const _SendFly({required this.onDone});

  @override
  State<_SendFly> createState() => _SendFlyState();
}

class _SendFlyState extends State<_SendFly>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1050),
  );

  /// Grenze zwischen Umschlag-Phase und Häkchen-Pop.
  static const double _split = 0.42;

  /// Haptik nur einmal feuern (im Moment, in dem das Häkchen poppt).
  bool _poppedHaptic = false;

  @override
  void initState() {
    super.initState();
    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onDone();
    });
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value;

          // Umschlag: sichtbar bis `_split`, schrumpft zur Mitte und verblasst.
          final envT = Curves.easeIn.transform((t / _split).clamp(0.0, 1.0));
          final envScale = lerpDouble(1.0, 0.25, envT)!;
          final envOpacity = (1.0 - envT).clamp(0.0, 1.0);

          // Häkchen-Badge: poppt nach `_split` rein (elasticOut), hält kurz,
          // fadet ganz am Ende aus.
          final chkT = ((t - _split) / (1 - _split)).clamp(0.0, 1.0);
          final chkScale =
              chkT == 0.0 ? 0.0 : Curves.elasticOut.transform(chkT);
          final chkOpacity = (t > 0.82 ? 1 - (t - 0.82) / 0.18 : 1.0)
              .clamp(0.0, 1.0)
              .toDouble();

          // Glow-Ring expandiert mit dem Pop und verblasst.
          final ring = chkT == 0.0 ? 0.0 : Curves.easeOut.transform(chkT);

          // Haptik genau im Moment des Pop.
          if (!_poppedHaptic && t >= _split) {
            _poppedHaptic = true;
            HapticFeedback.mediumImpact();
          }

          return Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (ring > 0 && chkOpacity > 0)
                    Opacity(
                      opacity: (1 - ring) * chkOpacity,
                      child: Container(
                        width: 64 + 56 * ring,
                        height: 64 + 56 * ring,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _green.withValues(alpha: 0.18),
                        ),
                      ),
                    ),
                  if (envOpacity > 0)
                    Opacity(
                      opacity: envOpacity,
                      child: Transform.scale(
                        scale: envScale,
                        child: _envelope(context),
                      ),
                    ),
                  if (chkScale > 0)
                    Opacity(
                      opacity: chkOpacity,
                      child: Transform.scale(
                        scale: chkScale,
                        child: _checkBadge(),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static const Color _green = Color(0xFF34C759); // iOS system green

  Widget _envelope(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent, Color.lerp(accent, Colors.black, 0.18)!],
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.45),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(Icons.mail_rounded, color: Colors.white, size: 32),
    );
  }

  Widget _checkBadge() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _green,
        boxShadow: [
          BoxShadow(
            color: _green.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(Icons.check_rounded, color: Colors.white, size: 38),
    );
  }
}
