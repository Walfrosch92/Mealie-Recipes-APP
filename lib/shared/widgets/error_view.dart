import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../core/api/api_service.dart';
import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Einheitliche Fehleransicht für Listen/Seiten, die nicht laden konnten:
// verständliche Meldung (userErrorMessage statt DioException-Rohtext),
// „Erneut versuchen" und — bei abgelaufener Anmeldung — „Einstellungen
// öffnen". Passendes Symbol je Ursache (Verbindung, Anmeldung, sonst).
// ---------------------------------------------------------------------------

class ErrorRetryView extends StatelessWidget {
  final Object error;

  /// Optionaler Kontext-Text über der Meldung (z. B. „Rezepte konnten nicht
  /// geladen werden").
  final String? title;
  final VoidCallback? onRetry;

  const ErrorRetryView({
    super.key,
    required this.error,
    this.title,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final auth = isAuthError(error);
    final connection = isConnectionError(error);
    final icon = auth
        ? Icons.lock_clock_rounded
        : connection
            ? Icons.cloud_off_rounded
            : Icons.error_outline_rounded;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: context.appFgTertiary),
            const SizedBox(height: 14),
            if (title != null) ...[
              Text(title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: context.appFg,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
            ],
            Text(userErrorMessage(error),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: context.appFgSub, fontSize: 14, height: 1.4)),
            const SizedBox(height: 18),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                if (onRetry != null)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                        backgroundColor: AppTokens.accent),
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l.retry),
                  ),
                if (auth)
                  OutlinedButton.icon(
                    onPressed: () => context.go('/settings'),
                    icon: const Icon(Icons.settings_rounded),
                    label: Text(l.openSettings),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
