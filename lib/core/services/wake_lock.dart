import 'package:flutter/services.dart';

/// In-house replacement for the wakelock_plus pub package — talks to the
/// native WakeLockPlugin we ship for both iOS (Swift) and Android (Kotlin).
///
/// Dropped wakelock_plus because its iOS umbrella headers tripped Xcode 16's
/// strict module verifier and failed every build.
class WakeLock {
  static const _channel = MethodChannel('mealie_recipes/wakelock');

  static Future<void> enable() async {
    try {
      await _channel.invokeMethod('enable');
    } catch (_) {/* best-effort */}
  }

  static Future<void> disable() async {
    try {
      await _channel.invokeMethod('disable');
    } catch (_) {/* best-effort */}
  }
}
