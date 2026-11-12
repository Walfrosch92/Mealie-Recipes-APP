import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'apple_icon.dart';

// ---------------------------------------------------------------------------
// Einheitlicher Leer-Zustand für Listen: Symbol im getönten Kreis, optional
// ein Titel, der Erklärtext und — wo sinnvoll — EINE passende Aktion.
// Als ListView gebaut, damit Pull-to-Refresh (RefreshIndicator) weiter
// funktioniert; [scrollable] = false liefert nur die zentrierte Spalte.
// ---------------------------------------------------------------------------

class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? title;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final bool scrollable;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.message,
    this.title,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTokens.accent.withValues(alpha: 0.14),
            ),
            child: Center(
              child: iconOrApple(icon, color: AppTokens.accentDeep, size: 40),
            ),
          ),
          const SizedBox(height: 18),
          if (title != null) ...[
            Text(title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2)),
            const SizedBox(height: 6),
          ],
          Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: context.appFgSub, fontSize: 15, height: 1.45)),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: AppTokens.accent,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              icon: Icon(actionIcon ?? Icons.arrow_forward_rounded, size: 18),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
    if (!scrollable) return Center(child: content);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [const SizedBox(height: 72), content],
    );
  }
}
