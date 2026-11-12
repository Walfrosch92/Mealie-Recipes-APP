import 'core/services/bundled_licenses.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app_root.dart';
import 'core/accounts/account_scope.dart';
import 'core/accounts/account_storage.dart';
import 'core/services/local_cache.dart';
import 'core/services/log_manager.dart';
import 'core/services/user_ca_trust.dart';
import 'features/timer/services/notification_service.dart';
import 'features/timer/services/timer_foreground_service.dart';

void main() {
  // Run inside a guarded zone so print()/errors are captured by LogManager.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Lizenzen der mitgelieferten Schriften für die Lizenzseite anmelden.
    registerBundledLicenses();
    // Vor dem ersten SharedPreferences-Zugriff: Sperre für Konto-Schlüssel
    // während eines Kontowechsels (siehe AccountScope).
    AccountScope.installPrefsGuard();
    LogManager.shared.attach();
    // Android: vom Nutzer installierte CA-Zertifikate (Selfhosting mit
    // eigener CA) vor der ersten Anfrage in dart:io übernehmen.
    await UserCaTrust.install();
    // Edge-to-edge: opt in explicitly so MediaQuery.viewPadding reflects the
    // real gesture-nav / status-bar insets on every OEM (Samsung OneUI, MIUI,
    // OxygenOS, …) and on Android 15+ where edge-to-edge is mandatory.
    // Without this some devices report zero bottom inset and SafeArea has
    // nothing to pad, so the gesture pill overlaps app content.
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    ));
    // Initialize locale data for intl DateFormat (German weekday/month names).
    await initializeDateFormatting();
    await NotificationService.init();
    // Ask for notification permission up front so timer alarms can fire.
    await NotificationService.requestPermissions();
    // Android Live Activity (foreground service) — iOS uses Live Activity.
    if (Platform.isAndroid) {
      TimerForegroundService.init();
    }
    // Unterbrochenen Kontowechsel (App beendet mitten im Umräumen) zu Ende
    // führen, BEVOR irgendetwas Konto-Daten liest.
    try {
      await AccountScope.privileged(
          () async => (await AccountStorage.open()).recover());
    } catch (e) {
      LogManager.shared.log('⚠️ Konto-Wiederherstellung: $e');
    }
    // Einmalig die alten Rezept-Keys aus SharedPreferences werfen (siehe
    // LocalCache.purgeLegacyRecipeCaches). Bewusst nicht awaited: das darf den
    // ersten Frame nicht aufhalten.
    unawaited(LocalCache.purgeLegacyRecipeCaches());

    // Wurde die App DURCH Tippen auf eine Timer-Benachrichtigung gestartet?
    // Dann direkt zurück in den Kochmodus der passenden (sonst ersten) Session,
    // statt auf /home zu landen. Der Tap beendet nichts.
    final timerTapRecipeId = await NotificationService.launchTimerPayload();

    runApp(AppRoot(
      key: AppRoot.globalKey,
      initial: await buildAppScope(timerTapRecipeId: timerTapRecipeId),
    ));
  }, (error, stack) {
    LogManager.shared.log('❌ Zone error: $error');
  }, zoneSpecification: ZoneSpecification(
    print: (self, parent, zone, line) {
      LogManager.shared.log(line);
      parent.print(zone, line);
    },
  ));
}
