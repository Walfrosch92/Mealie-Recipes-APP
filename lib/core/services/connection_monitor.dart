import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Erreichbarkeit des eigenen Mealie-Servers — gespeist vom Dio-Interceptor
// in ApiService (kein extra Paket, keine Extra-Anfragen im Normalbetrieb):
// - Antwort vom Server (auch 4xx/5xx) → online, „zuletzt verbunden" = jetzt
// - keine Antwort (offline, Zeitüberschreitung, DNS) → offline
// Die App ist offline-first und zeigt dann still den Cache; der Hinweis
// „Offline · Stand …" macht das sichtbar (OfflinePill auf den Haupt-Tabs).
// ---------------------------------------------------------------------------

class ConnectionMonitor extends ChangeNotifier {
  ConnectionMonitor._();
  static final ConnectionMonitor instance = ConnectionMonitor._();

  static const _kLastContact = 'lastServerContact';

  bool _offline = false;
  DateTime? _lastContact;
  DateTime? _lastPersisted;
  bool _loaded = false;

  bool get offline => _offline;

  /// Letzte erfolgreiche Server-Antwort (überlebt Neustarts).
  DateTime? get lastContact => _lastContact;

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    _loaded = true;
    try {
      final raw =
          (await SharedPreferences.getInstance()).getString(_kLastContact);
      final parsed = raw == null ? null : DateTime.tryParse(raw);
      if (parsed != null &&
          (_lastContact == null || parsed.isAfter(_lastContact!))) {
        _lastContact = parsed;
        notifyListeners();
      }
    } catch (_) {}
  }

  void reportReachable() {
    final now = DateTime.now();
    final changed = _offline;
    _offline = false;
    _lastContact = now;
    // Höchstens einmal pro Minute speichern.
    if (_lastPersisted == null ||
        now.difference(_lastPersisted!) > const Duration(minutes: 1)) {
      _lastPersisted = now;
      SharedPreferences.getInstance()
          .then((p) => p.setString(_kLastContact, now.toIso8601String()))
          .catchError((_) => false);
    }
    if (changed) notifyListeners();
  }

  void reportUnreachable() {
    _ensureLoaded();
    if (_offline) return;
    _offline = true;
    notifyListeners();
  }

  /// Beim Abmelden/Server-Wechsel: Zustand zurücksetzen.
  void reset() {
    _offline = false;
    notifyListeners();
  }
}

final connectionMonitorProvider = ChangeNotifierProvider<ConnectionMonitor>(
    (_) => ConnectionMonitor.instance);
