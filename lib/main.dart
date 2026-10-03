import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/api/api_service.dart';
import 'core/services/local_cache.dart';
import 'core/services/log_manager.dart';
import 'core/services/recipe_image_store.dart';
import 'features/auth/providers/biometric_lock_provider.dart';
import 'features/cooking_mode/providers/cooking_session_provider.dart';
import 'features/timer/providers/timer_provider.dart';
import 'features/timer/services/notification_service.dart';
import 'features/timer/services/timer_foreground_service.dart';
import 'features/recipes/providers/detail_sections.dart';
import 'features/recipes/providers/recipes_provider.dart'
    show initialRecipeSortProvider, kRecipeSortKey, recipeSortFromName;

void main() {
  // Run inside a guarded zone so print()/errors are captured by LogManager.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    LogManager.shared.attach();
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
    // Preload des gecachten Mealie-Users vor dem ersten Frame: damit der
    // Home-Screen das „Willkommen {Name}, …"-Greeting ab Frame 1 zeigt,
    // ohne dass SharedPreferences / settingsProvider erst async aufgelöst
    // werden müssen.
    final cachedUser = await LocalCache.loadCurrentUser();
    // Einmalig die alten Rezept-Keys aus SharedPreferences werfen (siehe
    // LocalCache.purgeLegacyRecipeCaches). Bewusst nicht awaited: das darf den
    // ersten Frame nicht aufhalten.
    unawaited(LocalCache.purgeLegacyRecipeCaches());
    // Offline-Rezeptbilder indexieren (nur Dateinamen lesen, schnell), damit
    // sie schon im ersten Frame statt eines Platzhalters erscheinen, auch
    // ganz ohne Netz.
    await RecipeImageStore.shared.init();
    // Preload der Biometric-Lock-Einstellung: damit der Lock-Screen direkt
    // beim Start (Cold-Launch) als Overlay drüberliegt, OHNE dass der User
    // die Home/Recipe-View kurz aufblitzen sieht bevor die async Settings
    // den Lock zünden. Direkter SharedPreferences-Read mit demselben Key
    // wie settings_provider._kBiometricLock.
    final prefs = await SharedPreferences.getInstance();
    final biometricLockEnabled =
        prefs.getBool('isBiometricLockEnabled') ?? false;
    // Start-Route SYNCHRON bestimmen, damit ein nicht eingerichtetes Gerät
    // sofort im Setup landet (kein kurzes Home-Aufblitzen / Hängenbleiben, das
    // sonst vom async Settings-Load + refreshListenable-Timing abhing). Sowohl
    // serverUrl als auch apiToken liegen in den SharedPreferences (siehe
    // settings_provider.save) → isConfigured ist hier direkt ablesbar.
    final isConfigured = (prefs.getString('serverUrl') ?? '').isNotEmpty &&
        (prefs.getString('apiToken') ?? '').isNotEmpty;

    // Persistierte Kochsession(en) + Timer wiederherstellen. Beide leben sonst
    // nur im Speicher → ein vom System abgeräumter Hintergrund-Prozess
    // (gesperrtes Gerät, abgelaufener Timer ohne laufenden Foreground-Service)
    // würde den Kochmodus beim Kaltstart „beenden". Mit der Wiederherstellung
    // ist nach dem Tippen auf die Timer-Benachrichtigung alles wieder da
    // (aktueller Schritt, abgehakte Zutaten/Schritte, klingelnder Timer).
    final cookingSessions = await CookingSessionsNotifier.loadPersisted();
    final timers = await TimerNotifier.loadPersisted();

    // Wurde die App DURCH Tippen auf eine Timer-Benachrichtigung gestartet?
    // Dann direkt zurück in den Kochmodus der passenden (sonst ersten) Session,
    // statt auf /home zu landen. Der Tap beendet nichts.
    final timerTapRecipeId = await NotificationService.launchTimerPayload();

    String startLocation = isConfigured ? '/home' : '/setup';
    if (isConfigured &&
        timerTapRecipeId != null &&
        cookingSessions.isNotEmpty) {
      CookingSession? match;
      for (final s in cookingSessions) {
        if (s.slug == timerTapRecipeId) {
          match = s;
          break;
        }
      }
      match ??= cookingSessions.first;
      startLocation = '/cooking/${match.slug}';
    }

    runApp(ProviderScope(
      overrides: [
        initialCachedUserProvider.overrideWithValue(cachedUser),
        initialBiometricLockProvider.overrideWithValue(biometricLockEnabled),
        initialLocationProvider.overrideWithValue(startLocation),
        initialCookingSessionsProvider.overrideWithValue(cookingSessions),
        initialCollapsedDetailSectionsProvider.overrideWithValue(
            (prefs.getStringList(kCollapsedDetailSectionsKey) ?? const [])
                .toSet()),
        initialTimersProvider.overrideWithValue(timers),
        initialRecipeSortProvider.overrideWithValue(
            recipeSortFromName(prefs.getString(kRecipeSortKey))),
      ],
      child: const MealieApp(),
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
