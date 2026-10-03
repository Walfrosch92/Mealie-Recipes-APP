import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import 'animations.dart';

// ---------------------------------------------------------------------------
// Primär-Button für asynchrone Aktionen (Premium-Verlaufs-Optik). Sobald
// getippt, gibt er SOFORT Feedback (Haptik + Scale) und zeigt — solange die
// Aktion läuft — einen Inline-Spinner anstelle von Icon/Label und deaktiviert
// sich selbst. So weiß der Nutzer ohne Zweifel, dass sein Tap angekommen ist.
//
// `onPressed` MUSS das Future der Aktion zurückgeben; der Button blendet den
// Spinner solange ein, bis dieses Future abgeschlossen ist. `null` = inaktiv.
// Ohne `color` rendert der Button mit dem Orange-Akzent-Verlauf; mit `color`
// als einfarbiger Button (z. B. rot für destruktive Aktionen).
// ---------------------------------------------------------------------------

class AsyncActionButton extends StatefulWidget {
  final Future<void> Function()? onPressed;
  final String label;
  final IconData? icon;
  final Color? color;
  final Color? foregroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  /// Volle Breite (für Formular-Buttons).
  final bool expand;

  const AsyncActionButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.color,
    this.foregroundColor,
    this.padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
    this.borderRadius = AppTokens.rMd,
    this.expand = false,
  });

  @override
  State<AsyncActionButton> createState() => _AsyncActionButtonState();
}

class _AsyncActionButtonState extends State<AsyncActionButton> {
  bool _busy = false;

  Future<void> _handle() async {
    if (_busy || widget.onPressed == null) return;
    // Sofortiges taktiles Feedback noch vor der eigentlichen Arbeit.
    HapticFeedback.lightImpact();
    setState(() => _busy = true);
    try {
      await widget.onPressed!();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final useGradient = widget.color == null;
    final fg = widget.foregroundColor ?? Colors.white;
    final enabled = widget.onPressed != null && !_busy;
    final radius = BorderRadius.circular(widget.borderRadius);

    final Widget? leading = _busy
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        : (widget.icon != null ? Icon(widget.icon, size: 18, color: fg) : null);

    final content = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[
          leading,
          const SizedBox(width: 9),
        ],
        Flexible(
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(color: fg, fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );

    final body = Opacity(
      opacity: enabled || _busy ? 1 : 0.5,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          gradient: useGradient ? AppTokens.accentGradient : null,
          color: useGradient ? null : widget.color,
          borderRadius: radius,
          boxShadow:
              (enabled || _busy) && useGradient ? context.appAccentGlow : null,
        ),
        child: content,
      ),
    );

    final button = BounceTap(
      onTap: enabled ? _handle : null,
      scale: 0.97,
      child: body,
    );

    return widget.expand
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
