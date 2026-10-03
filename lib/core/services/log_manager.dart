import 'package:flutter/foundation.dart';

// ---------------------------------------------------------------------------
// LogManager — captures print/debugPrint output and framework errors into an
// in-memory ring buffer so they can be viewed in Settings for debugging.
// Mirrors iOS LogManager.
// ---------------------------------------------------------------------------

class LogManager {
  LogManager._();
  static final LogManager shared = LogManager._();

  static const int _maxLines = 500;
  final List<String> _lines = [];
  // Off by default — turned on by the settings provider after it has loaded
  // the persisted `enableLogging` flag. Defaulting to true would record
  // startup output for users who had logging disabled.
  bool _enabled = false;
  bool _attached = false;
  // Solange „gepinnt" (z. B. während der Ersteinrichtung), bleibt Logging an
  // und kann durch zwischenzeitliche `enabled = false` (etwa ein Settings-Save
  // beim Sprachwechsel) NICHT abgeschaltet werden — sonst wären die Setup-Logs
  // wieder leer. Siehe LogManager.pinOn()/unpin().
  bool _pinnedOn = false;

  bool get enabled => _enabled;
  set enabled(bool v) {
    if (_pinnedOn) {
      _enabled = true;
      return;
    }
    _enabled = v;
    // When disabling, also drop any lines captured before this turn so the
    // log view does not surface old entries the user thought were off.
    if (!v) _lines.clear();
  }

  /// Logging erzwingen (an) und gegen Abschalten sperren. Wird beim Betreten
  /// des Setup-Screens aufgerufen, damit ALLE Fehler der Ersteinrichtung
  /// erfasst werden — auch wenn der Logging-Schalter (noch) aus ist.
  void pinOn() {
    _pinnedOn = true;
    _enabled = true;
  }

  /// Pin aufheben — danach gilt wieder die normale (persistierte) Einstellung.
  void unpin() => _pinnedOn = false;

  int get count => _lines.length;
  double get sizeKB => _lines.fold<int>(0, (s, l) => s + l.length) / 1024.0;

  /// Append a line with a timestamp.
  void log(String message) {
    if (!_enabled) return;
    final ts = DateTime.now().toIso8601String().substring(11, 19);
    _lines.add('[$ts] $message');
    if (_lines.length > _maxLines) {
      _lines.removeRange(0, _lines.length - _maxLines);
    }
  }

  String getLogs() => _lines.join('\n');

  void clear() => _lines.clear();

  /// Hook into debugPrint + Flutter framework errors. Call once at startup.
  void attach() {
    if (_attached) return;
    _attached = true;

    final originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) log(message);
      originalDebugPrint(message, wrapWidth: wrapWidth);
    };

    final priorOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      log('❌ FlutterError: ${details.exceptionAsString()}');
      priorOnError?.call(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      log('❌ Uncaught: $error');
      return false;
    };
  }
}
