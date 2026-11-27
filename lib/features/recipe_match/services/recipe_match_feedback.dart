import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/services/log_manager.dart';
import '../../timeline/services/offline_cooked_queue.dart';
import '../../webapp_tools/screens/recipe_actions_screen.dart'
    show recipeActionsProvider;

// ---------------------------------------------------------------------------
// Rezept-Match-Rückmeldung (#53): beim Behalten/Überspringen optional eine
// „Post"-Rezept-Aktion des Haushalts auslösen (gleicher Endpoint + Portionen-
// Faktor wie die Rezept-Aktionen aus #42).
//
// Ein ausgelöster Trigger lässt sich nicht zurücknehmen — Mealie sendet das
// Rezept sofort an die Ziel-URL. Deshalb wartet jede Rückmeldung
// [kRecipeMatchFeedbackDelay] (= Dauer der „Rückgängig"-Snackbar); ein
// Rückgängig in diesem Fenster verwirft sie. Verlässt man den Screen oder
// die App, wird alles Ausstehende sofort gesendet, damit nichts verloren
// geht. Ohne Verbindung → Offline-Warteschlange (flushOfflineCooked).
// ---------------------------------------------------------------------------

const kRecipeMatchFeedbackDelay = Duration(seconds: 5);

class _Pending {
  final String actionId;
  final String slug;
  final double scale;
  final Timer timer;
  _Pending(this.actionId, this.slug, this.scale, this.timer);
}

class RecipeMatchFeedback {
  final ProviderContainer _container;
  RecipeMatchFeedback(this._container);

  /// Hinweis bei endgültigem Fehlschlag (z. B. Snackbar, solange der Screen
  /// offen ist).
  void Function()? onFailed;

  final _pending = <int, _Pending>{};
  int _nextToken = 0;

  /// Rückmeldung vormerken; liefert das Token fürs Rückgängig oder `null`,
  /// wenn keine (gültige) Aktion gewählt ist.
  int? schedule(String? actionId, String slug, double scale) {
    if (actionId == null || slug.isEmpty) return null;
    // Aktion inzwischen gelöscht oder kein „Post" mehr → still nichts tun.
    // Liste noch nicht geladen → trotzdem senden (Server prüft selbst).
    final list = _container.read(recipeActionsProvider).valueOrNull;
    if (list != null &&
        !list.any((a) =>
            a['id']?.toString() == actionId && a['actionType'] == 'post')) {
      return null;
    }
    final token = _nextToken++;
    _pending[token] = _Pending(actionId, slug, scale,
        Timer(kRecipeMatchFeedbackDelay, () => _fire(token)));
    return token;
  }

  /// Rückgängig innerhalb des Fensters: Rückmeldung verwerfen.
  void cancel(int? token) {
    if (token == null) return;
    _pending.remove(token)?.timer.cancel();
  }

  /// Alles Ausstehende sofort senden (Screen zu, App im Hintergrund).
  void flushAll() {
    for (final token in _pending.keys.toList()) {
      _fire(token);
    }
  }

  void _fire(int token) {
    final p = _pending.remove(token);
    if (p == null) return;
    p.timer.cancel();
    unawaited(_send(p));
  }

  Future<void> _send(_Pending p) async {
    try {
      await _container
          .read(apiServiceProvider)
          .triggerRecipeAction(p.actionId, p.slug, p.scale);
      LogManager.shared.log('⚡ Rezept-Match-Aktion gesendet (${p.slug})');
    } catch (e) {
      if (isConnectionError(e)) {
        await queueRecipeActionTrigger(p.actionId, p.slug, p.scale);
      } else {
        LogManager.shared.log('⚡ Rezept-Match-Aktion fehlgeschlagen: $e');
        onFailed?.call();
      }
    }
  }
}
