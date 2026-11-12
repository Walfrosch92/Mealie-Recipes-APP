import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Tippfläche ohne Material-Effekt (Ersatz für nackte GestureDetector):
//   • meldet sich Screenreadern als Schaltfläche, optional mit [semanticLabel]
//     (Pflicht bei reinen Symbolen ohne Text)
//   • [minSize] zieht kleine Ziele (16–20-px-Symbole) auf die empfohlene
//     Mindestgröße von 44 × 44 und macht die ganze Fläche tippbar
// ---------------------------------------------------------------------------

class TapArea extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final HitTestBehavior? behavior;
  final String? semanticLabel;
  final bool minSize;
  final Widget? child;

  const TapArea({
    super.key,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.behavior,
    this.semanticLabel,
    this.minSize = false,
    this.child,
  });

  static const kMinTarget = 44.0;

  @override
  Widget build(BuildContext context) {
    Widget? content = child;
    if (minSize && content != null) {
      content = ConstrainedBox(
        constraints:
            const BoxConstraints(minWidth: kMinTarget, minHeight: kMinTarget),
        child: Center(widthFactor: 1, heightFactor: 1, child: content),
      );
    }
    final enabled = onTap != null || onLongPress != null || onDoubleTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      // Maus (Windows/macOS): Hand-Zeiger zeigt, dass die Fläche klickbar ist.
      child: MouseRegion(
          cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
          child: GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            onDoubleTap: onDoubleTap,
            behavior: minSize ? HitTestBehavior.opaque : behavior,
            child: content,
          )),
    );
  }
}
