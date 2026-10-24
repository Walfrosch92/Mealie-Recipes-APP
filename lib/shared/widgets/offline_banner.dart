import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../core/api/api_service.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/services/connection_monitor.dart';
import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// „Offline · Stand 14:32" als schmaler Streifen OBEN auf den Haupt-Tabs,
// solange der eigene Mealie-Server nicht antwortet. Er schiebt den Inhalt
// nach unten statt etwas zu verdecken (eine schwebende Pille lag über
// Listenenden/Sticky-Knöpfen). Die App zeigt offline ihre gespeicherten
// Daten — der Hinweis erklärt, warum Änderungen (noch) fehlen.
// Antippen prüft sofort neu; offline wird zusätzlich alle 30 s geprüft.

/// Wird der Streifen gerade angezeigt? (Shell nimmt dann das obere
/// Status-Leisten-Polster von den Tabs weg — der Streifen trägt es.)
bool offlineBannerVisible(WidgetRef ref) =>
    (ref.watch(settingsProvider).valueOrNull?.isConfigured ?? false) &&
    ref.watch(connectionMonitorProvider).offline;
// ---------------------------------------------------------------------------

class OfflineBanner extends ConsumerStatefulWidget {
  const OfflineBanner({super.key});

  @override
  ConsumerState<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends ConsumerState<OfflineBanner> {
  Timer? _timer;
  bool _checking = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _check() async {
    if (_checking) return;
    setState(() => _checking = true);
    try {
      // Erfolg/Fehler meldet der Interceptor an den ConnectionMonitor.
      await ref.read(apiServiceProvider).testConnection();
    } catch (_) {
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  void _syncTimer(bool offline) {
    if (offline && _timer == null) {
      _timer = Timer.periodic(const Duration(seconds: 30), (_) => _check());
    } else if (!offline && _timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  String _since(BuildContext context, DateTime? at) {
    final l = AppLocalizations.of(context)!;
    if (at == null) return l.offlineLabel;
    final loc = MaterialLocalizations.of(context);
    final time = loc.formatTimeOfDay(TimeOfDay.fromDateTime(at),
        alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context));
    final now = DateTime.now();
    final sameDay =
        at.year == now.year && at.month == now.month && at.day == now.day;
    return l
        .offlineSince(sameDay ? time : '${loc.formatShortMonthDay(at)}, $time');
  }

  @override
  Widget build(BuildContext context) {
    final monitor = ref.watch(connectionMonitorProvider);
    final show = offlineBannerVisible(ref);
    _syncTimer(show);
    final l = AppLocalizations.of(context)!;
    // Helle/dunkle Variante passend zu den Statusleisten-Symbolen des Themes.
    final bg =
        context.isDark ? const Color(0xFF3A2A12) : const Color(0xFFFFEBCC);
    final fg =
        context.isDark ? const Color(0xFFFFD9A0) : const Color(0xFF6B3A00);
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: !show
          ? const SizedBox(width: double.infinity)
          : Material(
              color: bg,
              child: InkWell(
                onTap: _check,
                child: SafeArea(
                  bottom: false,
                  child: Semantics(
                    button: true,
                    label:
                        '${_since(context, monitor.lastContact)}. ${l.retry}',
                    excludeSemantics: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _checking
                              ? SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: fg))
                              : Icon(Icons.cloud_off_rounded,
                                  size: 16, color: fg),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(_since(context, monitor.lastContact),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: fg,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.refresh_rounded, size: 16, color: fg),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
