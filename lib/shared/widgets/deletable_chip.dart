import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// DeletableChip — umschließt einen Chip (Tag/Kategorie/Label). Langer Druck
// versetzt den Chip in den „Wackel-Modus" (iOS-Home-Screen-Stil): er wackelt
// und zeigt oben rechts ein rotes „×". Tippt man das ×, wird `onDelete`
// ausgelöst (der Aufrufer zeigt die Bestätigung + löscht serverseitig).
//
//   • Normaler Tap (kein Wackeln) → `onTap` (z. B. Auswahl umschalten).
//   • Langer Druck                → Wackel-Modus an.
//   • Tap auf Chip-Body im Modus  → Wackel-Modus aus.
//   • Tap auf ×                    → onDelete() + Modus aus.
// ---------------------------------------------------------------------------
class DeletableChip extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  /// `null` = nicht löschbar (z. B. fehlendes Recht) → kein Wackel-Modus.
  final VoidCallback? onDelete;

  const DeletableChip({
    super.key,
    required this.child,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<DeletableChip> createState() => _DeletableChipState();
}

class _DeletableChipState extends State<DeletableChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 130),
  );
  bool _wiggling = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _start() {
    // Kleine Vibration als Feedback, dass der Lösch-/Wackel-Modus aktiv ist.
    HapticFeedback.mediumImpact();
    setState(() => _wiggling = true);
    _ctrl.repeat(reverse: true);
  }

  void _stop() {
    if (!_wiggling) return;
    setState(() => _wiggling = false);
    _ctrl.stop();
    _ctrl.value = 0;
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    // Nach OBEN wischen (negative Geschwindigkeit) → Löschen anstoßen.
    if ((details.primaryVelocity ?? 0) < -120) {
      _stop();
      widget.onDelete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _wiggling ? _stop : widget.onTap,
      onLongPress: (_wiggling || widget.onDelete == null) ? null : _start,
      // Swipe-up nur im Wackel-Modus aktiv — sonst bleibt der vertikale Drag
      // beim umgebenden Scrollable (Liste scrollen statt Chip löschen).
      onVerticalDragEnd: _wiggling ? _onVerticalDragEnd : null,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          final angle = _wiggling ? (_ctrl.value - 0.5) * 0.10 : 0.0;
          return Transform.translate(
            // Beim Wackeln leicht anheben + wackeln, als Hinweis aufs Hochwischen.
            offset: _wiggling ? const Offset(0, -1) : Offset.zero,
            child: Transform.rotate(angle: angle, child: child),
          );
        },
        child: widget.child,
      ),
    );
  }
}
