import 'dart:io';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// iOS Live Activity (cooking timer) bridge.
//
// Mirrors the Android TimerForegroundService API. All calls are silent
// no-ops on non-iOS platforms or older iOS versions — the native side
// returns nil if ActivityKit isn't available or the user disabled Live
// Activities for the app.
// ---------------------------------------------------------------------------

class LiveActivityService {
  static const _channel = MethodChannel('mealie_recipes/live_activity');
  static bool _running = false;

  static Future<void> start({
    required String timerName,
    required String recipeName,
    required int remainingSeconds,
    required int totalSeconds,
    required bool isPaused,
    required int extraCount,
  }) async {
    if (!Platform.isIOS) return;
    final endMillis = DateTime.now()
        .add(Duration(seconds: remainingSeconds))
        .millisecondsSinceEpoch;
    try {
      await _channel.invokeMethod('start', {
        'timerName': timerName,
        'recipeName': recipeName,
        'endDateMillis': endMillis,
        'totalSeconds': totalSeconds,
        'isPaused': isPaused,
        'extraCount': extraCount,
      });
      _running = true;
    } catch (_) {/* best-effort */}
  }

  static Future<void> update({
    required String timerName,
    required String recipeName,
    required int remainingSeconds,
    required int totalSeconds,
    required bool isPaused,
    required int extraCount,
  }) async {
    if (!Platform.isIOS) return;
    if (!_running) {
      return start(
        timerName: timerName,
        recipeName: recipeName,
        remainingSeconds: remainingSeconds,
        totalSeconds: totalSeconds,
        isPaused: isPaused,
        extraCount: extraCount,
      );
    }
    final endMillis = DateTime.now()
        .add(Duration(seconds: remainingSeconds))
        .millisecondsSinceEpoch;
    try {
      await _channel.invokeMethod('update', {
        'timerName': timerName,
        'recipeName': recipeName,
        'endDateMillis': endMillis,
        'totalSeconds': totalSeconds,
        'isPaused': isPaused,
        'extraCount': extraCount,
      });
    } catch (_) {/* best-effort */}
  }

  static Future<void> stop() async {
    if (!Platform.isIOS) return;
    if (!_running) return;
    try {
      await _channel.invokeMethod('stop');
    } catch (_) {/* best-effort */}
    _running = false;
  }

  static bool get isRunning => _running;
}
