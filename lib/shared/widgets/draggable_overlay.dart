import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// DraggableOverlay — macht ein in einem Stack platziertes Overlay-Element
// (z. B. den globalen Timer-Chip oder den Kochmodus-FAB) per Drag frei
// beweglich.
//
// Das Element bleibt an seinem Standard-Anker (left/right/top/bottom)
// positioniert; die vom Nutzer erzeugte Verschiebung wird als reine
// Translation (`Transform.translate`) angewandt. Dadurch ist der gespeicherte
// Wert ein koordinatensystem-unabhängiger Delta-Offset und funktioniert
// identisch, egal ob der umgebende Stack am Bildschirmursprung sitzt (globaler
// Builder) oder unterhalb einer AppBar (Scaffold-Body).
//
// [offset]  — der persistierte Delta-Offset (null = noch nicht verschoben).
// [onMoved] — meldet den neuen (geclampten) Delta-Offset nach dem Loslassen.
// Der Tap des Kind-Widgets bleibt erhalten: ein reiner Tap gewinnt im Gesten-
// Arena gegen den Pan-Recognizer, ein Drag gegen den Tap.
// ---------------------------------------------------------------------------

class DraggableOverlay extends StatefulWidget {
  final Offset? offset;
  final ValueChanged<Offset> onMoved;
  final Widget child;

  // Standard-Anker (genau wie bei Positioned — nur die genutzten setzen).
  final double? defaultLeft;
  final double? defaultRight;
  final double? defaultTop;
  final double? defaultBottom;

  const DraggableOverlay({
    super.key,
    required this.offset,
    required this.onMoved,
    required this.child,
    this.defaultLeft,
    this.defaultRight,
    this.defaultTop,
    this.defaultBottom,
  });

  @override
  State<DraggableOverlay> createState() => _DraggableOverlayState();
}

class _DraggableOverlayState extends State<DraggableOverlay> {
  final _key = GlobalKey();
  late Offset _delta = widget.offset ?? Offset.zero;
  bool _dragging = false;

  @override
  void didUpdateWidget(DraggableOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Persistierten Offset übernehmen, wenn er sich von außen ändert (z. B. ein
    // anderer Screen mit demselben FAB-Offset-Provider). Nicht während eines
    // aktiven Drags, sonst springt es.
    if (!_dragging && widget.offset != null && widget.offset != _delta) {
      _delta = widget.offset!;
    }
  }

  void _onUpdate(DragUpdateDetails d) {
    var next = _delta + d.delta;
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      // Position bei Delta = 0 (aktueller Origin minus bisheriger Delta).
      final origin = box.localToGlobal(Offset.zero) - _delta;
      final size = box.size;
      final screen = MediaQuery.of(context).size;
      final pad = MediaQuery.of(context).padding;
      final minDx = (pad.left + 4) - origin.dx;
      final maxDx = (screen.width - pad.right - 4 - size.width) - origin.dx;
      final minDy = (pad.top + 4) - origin.dy;
      final maxDy = (screen.height - pad.bottom - 4 - size.height) - origin.dy;
      next = Offset(
        maxDx >= minDx ? next.dx.clamp(minDx, maxDx) : next.dx,
        maxDy >= minDy ? next.dy.clamp(minDy, maxDy) : next.dy,
      );
    }
    setState(() => _delta = next);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.defaultLeft,
      right: widget.defaultRight,
      top: widget.defaultTop,
      bottom: widget.defaultBottom,
      child: Transform.translate(
        offset: _delta,
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onPanStart: (_) => _dragging = true,
          onPanUpdate: _onUpdate,
          onPanEnd: (_) {
            _dragging = false;
            widget.onMoved(_delta);
          },
          child: KeyedSubtree(key: _key, child: widget.child),
        ),
      ),
    );
  }
}
