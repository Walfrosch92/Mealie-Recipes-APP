import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

// ---------------------------------------------------------------------------
// BiometricLock — 1:1 zu Swifts `isAppLocked` State in MealieRecipesApp.swift.
//
// `state == true` bedeutet: die Lock-Overlay wird im app.dart-Builder über
// die gesamte App gelegt und blockiert jede Interaktion bis der User per
// Biometrie (oder Geräte-Passcode als Fallback) authentifiziert hat.
//
// Initialwert wird in main() vor runApp aus SharedPreferences gelesen und
// per ProviderScope.overrides eingespeist — damit der Lock-Screen ab Frame 1
// hochkommt (kein „App kurz sichtbar, dann lockt"-Flicker beim Cold-Start).
// ---------------------------------------------------------------------------

/// Wird in main() überschrieben mit `true` falls `isBiometricLockEnabled` in
/// SharedPreferences gesetzt ist. Default `false` damit die App ohne Override
/// startbar bleibt (Tests, ProviderScope ohne overrides).
final initialBiometricLockProvider = Provider<bool>((ref) => false);

final biometricLockProvider =
    NotifierProvider<BiometricLockNotifier, bool>(BiometricLockNotifier.new);

class BiometricLockNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(initialBiometricLockProvider);

  /// Vom Lifecycle-Observer aufgerufen wenn die App in den Background geht.
  /// Locked nur wenn der User Biometrie aktiviert hat — sonst no-op. Der
  /// Caller muss isBiometricLockEnabled selbst nicht prüfen, der Notifier
  /// macht das defensiv selber damit ein versehentlicher lock()-Call ohne
  /// aktive Einstellung nicht zur permanenten Sperre führt.
  void lock({required bool biometricLockEnabled}) {
    if (!biometricLockEnabled) return;
    if (!state) state = true;
  }

  /// Vom Lock-Screen nach erfolgreicher Auth aufgerufen.
  void unlock() {
    if (state) state = false;
  }

  /// Beim Toggle in den Settings nach erfolgreicher Auth-Confirmation: der
  /// State darf auf false zurückspringen damit der User die App wieder
  /// nutzen kann (er hat ja gerade biometrisch bestätigt).
  void forceUnlock() => state = false;
}

// ---------------------------------------------------------------------------
// Helper: ein einmaliger Biometric-Auth-Prompt für UI-Aktionen (z.B. den
// Settings-Toggle). Liefert true bei Erfolg, false sonst — inklusive Cancel
// und nicht verfügbarer Hardware. Mirrors Swifts LAContext.evaluatePolicy
// mit Fallback von biometrics auf device-passcode.
// ---------------------------------------------------------------------------

Future<bool> promptBiometricConfirmation({
  required String localizedReason,
}) async {
  final auth = LocalAuthentication();
  try {
    final canCheckBio = await auth.canCheckBiometrics;
    final isSupported = await auth.isDeviceSupported();
    if (!isSupported) return false;
    return await auth.authenticate(
      localizedReason: localizedReason,
      // biometricOnly=false → Fallback auf Geräte-Passcode wenn keine
      // Biometrie verfügbar/registriert ist (mirrors Swifts policy-Switch
      // zwischen deviceOwnerAuthenticationWithBiometrics und
      // deviceOwnerAuthentication).
      biometricOnly: canCheckBio ? false : false,
      persistAcrossBackgrounding: true,
    );
  } catch (_) {
    return false;
  }
}
