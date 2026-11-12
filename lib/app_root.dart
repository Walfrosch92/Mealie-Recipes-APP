import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/accounts/account_storage.dart';
import 'core/accounts/account_transition.dart';
import 'core/api/api_service.dart';
import 'core/providers/settings_provider.dart' show initialThemeModeProvider;
import 'core/services/local_cache.dart';
import 'core/services/recipe_image_store.dart';
import 'features/auth/providers/biometric_lock_provider.dart';
import 'features/cooking_mode/providers/cooking_session_provider.dart';
import 'features/recipes/providers/detail_sections.dart';
import 'features/recipes/providers/recipes_provider.dart'
    show initialRecipeSortProvider, kRecipeSortKey, recipeSortFromName;
import 'features/timer/providers/timer_provider.dart';

/// Alles, was zum AKTIVEN Konto gehört und vor dem ersten Frame bereitstehen
/// muss, plus der ProviderScope darum. Läuft beim Start und nach jedem
/// Kontowechsel (dann mit frischem Scope — kein Provider-Zustand des alten
/// Kontos überlebt).
Future<Widget> buildAppScope(
    {String? timerTapRecipeId, bool afterSwitch = false}) async {
  // Preload des gecachten Mealie-Users vor dem ersten Frame: damit der
  // Home-Screen das „Willkommen {Name}, …"-Greeting ab Frame 1 zeigt,
  // ohne dass SharedPreferences / settingsProvider erst async aufgelöst
  // werden müssen.
  final cachedUser = await LocalCache.loadCurrentUser();
  // Offline-Rezeptbilder indexieren (nur Dateinamen lesen, schnell), damit
  // sie schon im ersten Frame statt eines Platzhalters erscheinen, auch
  // ganz ohne Netz.
  await RecipeImageStore.shared.init();
  // Preload der Biometric-Lock-Einstellung: damit der Lock-Screen direkt
  // beim Start (Cold-Launch) als Overlay drüberliegt, OHNE dass der User
  // die Home/Recipe-View kurz aufblitzen sieht bevor die async Settings
  // den Lock zünden. Direkter SharedPreferences-Read mit demselben Key
  // wie settings_provider._kBiometricLock. Nach einem Kontowechsel nicht:
  // der Nutzer ist gerade in der App (und hat sich ggf. eben angemeldet).
  final prefs = await SharedPreferences.getInstance();
  final biometricLockEnabled =
      !afterSwitch && (prefs.getBool('isBiometricLockEnabled') ?? false);
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

  String startLocation = isConfigured ? '/home' : '/setup';
  if (isConfigured && timerTapRecipeId != null && cookingSessions.isNotEmpty) {
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

  return ProviderScope(
    overrides: [
      initialCachedUserProvider.overrideWithValue(cachedUser),
      initialBiometricLockProvider.overrideWithValue(biometricLockEnabled),
      // Gleicher Key wie settings_provider._kThemeMode.
      initialThemeModeProvider
          .overrideWithValue(prefs.getString('themeMode') ?? 'system'),
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
  );
}

// ---------------------------------------------------------------------------
// AppRoot — hält den ProviderScope und kann ihn für einen Kontowechsel
// komplett austauschen: alten Scope aus dem Baum nehmen (alle Provider,
// Timer, Streams des alten Kontos werden entsorgt), Daten umräumen
// (AccountTransition), neuen Scope aufbauen.
// ---------------------------------------------------------------------------

class AppRoot extends StatefulWidget {
  const AppRoot({super.key, required this.initial});
  final Widget initial;

  static final globalKey = GlobalKey<AppRootState>();

  /// Kontowechsel mit Neustart aller App-Zustände. [work] läuft, während
  /// kein ProviderScope existiert.
  static Future<void> restart(Future<void> Function(AccountStorage) work) {
    final state = globalKey.currentState;
    if (state == null) throw StateError('AppRoot nicht gemountet');
    return state.restart(work);
  }

  @override
  State<AppRoot> createState() => AppRootState();
}

class AppRootState extends State<AppRoot> {
  late Widget _child = widget.initial;
  Key _key = UniqueKey();
  bool _busy = false;

  Future<void> restart(Future<void> Function(AccountStorage) work) async {
    if (_busy) return;
    _busy = true;
    setState(() {
      _child = const _SwitchingView();
      _key = UniqueKey();
    });
    // Ein Frame später ist der alte ProviderScope unmounted → Container
    // entsorgt.
    await WidgetsBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;
    Object? error;
    try {
      await AccountTransition.run(work);
    } catch (e) {
      error = e;
    }
    final next = await buildAppScope(afterSwitch: true);
    if (mounted) {
      setState(() {
        _child = next;
        _key = UniqueKey();
      });
    }
    _busy = false;
    if (error != null) throw error;
  }

  @override
  Widget build(BuildContext context) => KeyedSubtree(key: _key, child: _child);
}

/// Kurzer Übergang ohne App-Zustand (kein Theme/Provider verfügbar).
class _SwitchingView extends StatelessWidget {
  const _SwitchingView();

  @override
  Widget build(BuildContext context) {
    final dark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: dark ? const Color(0xFF0E0C0A) : const Color(0xFFFAF7F2),
        child: const Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
                strokeWidth: 3, color: Color(0xFFFF8A00)),
          ),
        ),
      ),
    );
  }
}
