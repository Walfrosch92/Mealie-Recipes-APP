import '../../../core/utils/platform_features.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _timerChannelId = 'mealie_timer';
  static const _timerChannelName = 'Timer';
  static const _timerChannelDesc = 'Recipe timer notifications';

  static const _cookingChannelId = 'mealie_cooking';
  static const _cookingChannelName = 'Cooking Mode';
  static const _cookingChannelDesc = 'Active cooking session';

  static Future<void> init() async {
    // Windows/Desktop: keine Benachrichtigungen (siehe PlatformFeatures).
    if (!PlatformFeatures.notifications) return;
    // Timezone-Daten initialisieren — Pflicht für zonedSchedule (das wir für
    // iOS-Background-Timer-Notifications brauchen). Wir nutzen UTC für
    // relative Trigger, deshalb genügt die Standard-Initialisierung; die
    // tatsächliche Device-Timezone müssen wir nicht abfragen.
    tzdata.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestCriticalPermission: true,
    );
    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    if (Platform.isAndroid) {
      // High-importance channel for timer alarms.
      // On Android 8+ the sound is defined at the CHANNEL level, so the custom
      // alarm (res/raw/alarm) must be set here, not just on the notification.
      const timerChannel = AndroidNotificationChannel(
        _timerChannelId,
        _timerChannelName,
        description: _timerChannelDesc,
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('alarm'),
        audioAttributesUsage: AudioAttributesUsage.alarm,
        enableVibration: true,
        enableLights: true,
      );
      // Ongoing channel for cooking foreground service
      const cookingChannel = AndroidNotificationChannel(
        _cookingChannelId,
        _cookingChannelName,
        description: _cookingChannelDesc,
        importance: Importance.low,
      );
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(timerChannel);
      await androidPlugin?.createNotificationChannel(cookingChannel);
    }
  }

  // -------------------------------------------------------------------------
  // Timer finished alarm
  // -------------------------------------------------------------------------

  // Payload-Präfix für Timer-„fertig"-Benachrichtigungen. Ein Tap darf NICHTS
  // beenden — er bringt nur die App in den Vordergrund und führt zurück in den
  // Kochmodus (siehe `onTimerTap` + `launchTimerPayload`). Der Timer selbst
  // bleibt erhalten und wird erst durch Tippen auf den grünen Chip beendet.
  static const _cookingPayloadPrefix = 'cooking:';

  /// Wird von der App gesetzt (app.dart): Tap auf eine Timer-Benachrichtigung
  /// während die App läuft → zurück in den Kochmodus der passenden (oder ersten
  /// aktiven) Kochsession navigieren. Argument = recipeId (kann leer sein).
  static void Function(String recipeId)? onTimerTap;

  static Future<void> showTimerFinished({
    required int id,
    required String timerName,
    required String recipeName,
    String? recipeId,
  }) async {
    // Windows/Desktop: keine Benachrichtigungen (siehe PlatformFeatures).
    if (!PlatformFeatures.notifications) return;
    const androidDetails = AndroidNotificationDetails(
      _timerChannelId,
      _timerChannelName,
      channelDescription: _timerChannelDesc,
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      sound: RawResourceAndroidNotificationSound('alarm'),
      playSound: true,
      enableVibration: true,
    );
    const iosDetails = DarwinNotificationDetails(
      sound: 'alarm.caf',
      // Vordergrund-Darstellung erzwingen (Banner + Ton), sonst zeigt iOS bei
      // offener App nichts/keinen Ton.
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      // .timeSensitive statt .critical: Critical-Alerts brauchen ein
      // Apple-Sonder-Entitlement (nicht vorhanden) — ohne das kann iOS die
      // Notification verschlucken/stumm zustellen. timeSensitive braucht kein
      // Entitlement und wird normal MIT Ton zugestellt (bei Klingel an).
      interruptionLevel: InterruptionLevel.timeSensitive,
    );
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(
      id,
      timerName,
      recipeName,
      details,
      payload: '$_cookingPayloadPrefix${recipeId ?? ''}',
    );
  }

  // -------------------------------------------------------------------------
  // iOS: pre-scheduled timer-finished alarm.
  //
  // Auf iOS pausiert das System den Dart-Event-Loop sobald die App suspended
  // ist — `Timer.periodic` im TimerNotifier feuert dann nicht mehr und der
  // Live-Foreground-Pfad (`showTimerFinished` im _tick) wird nie erreicht.
  // Mit `zonedSchedule` registrieren wir die Notification direkt beim
  // System (UNTimeIntervalNotificationTrigger), die feuert dann auch wenn
  // die App suspended oder gekillt ist.
  //
  // Wird beim Start/Resume des Timers aufgerufen; cancel via `cancel(id)`
  // beim Pause/Stop/Remove (gleicher `id` wie zur Foreground-Notification).
  // -------------------------------------------------------------------------

  static Future<void> scheduleTimerFinished({
    required int id,
    required String timerName,
    required String recipeName,
    required int inSeconds,
    String? recipeId,
  }) async {
    // Windows/Desktop: keine Benachrichtigungen (siehe PlatformFeatures).
    if (!PlatformFeatures.notifications) return;
    if (!Platform.isIOS) return; // Android nutzt den Foreground-Service-Pfad.
    if (inSeconds <= 0) return;
    const iosDetails = DarwinNotificationDetails(
      sound: 'alarm.caf',
      // Vordergrund-Darstellung erzwingen (Banner + Ton), sonst zeigt iOS bei
      // offener App nichts/keinen Ton.
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      // .timeSensitive statt .critical: Critical-Alerts brauchen ein
      // Apple-Sonder-Entitlement (nicht vorhanden) — ohne das kann iOS die
      // Notification verschlucken/stumm zustellen. timeSensitive braucht kein
      // Entitlement und wird normal MIT Ton zugestellt (bei Klingel an).
      interruptionLevel: InterruptionLevel.timeSensitive,
    );
    const details = NotificationDetails(iOS: iosDetails);
    // Relativ in UTC ausreichend: iOS triggert nach absoluter Zeit, eine
    // explizite Device-Timezone-Auflösung ist hier nicht nötig.
    final fireAt = tz.TZDateTime.now(tz.UTC).add(Duration(seconds: inSeconds));
    await _plugin.zonedSchedule(
      id,
      timerName,
      recipeName,
      fireAt,
      details,
      payload: '$_cookingPayloadPrefix${recipeId ?? ''}',
      androidScheduleMode: AndroidScheduleMode.inexact,
      // Pflicht-Parameter in flutter_local_notifications 17.x — bestimmt
      // wie das DateTime auf iOS-System-Triggern interpretiert wird.
      // `absoluteTime` = exakte Wall-Clock-Zeit (richtig für unsere
      // relative „in X Sekunden"-Logik).
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // -------------------------------------------------------------------------
  // Cooking foreground notification (Android ongoing)
  // -------------------------------------------------------------------------

  static Future<void> showCookingOngoing({
    required String text,
  }) async {
    // Windows/Desktop: keine Benachrichtigungen (siehe PlatformFeatures).
    if (!PlatformFeatures.notifications) return;
    const androidDetails = AndroidNotificationDetails(
      _cookingChannelId,
      _cookingChannelName,
      channelDescription: _cookingChannelDesc,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
    );
    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(9999, 'Mealie Recipes', text, details);
  }

  static Future<void> cancelCookingOngoing() async {
    // Windows/Desktop: keine Benachrichtigungen (siehe PlatformFeatures).
    if (!PlatformFeatures.notifications) return;
    await _plugin.cancel(9999);
  }

  static Future<void> cancel(int id) async {
    // Windows/Desktop: keine Benachrichtigungen (siehe PlatformFeatures).
    if (!PlatformFeatures.notifications) return;
    await _plugin.cancel(id);
  }

  static Future<void> cancelAll() async {
    // Windows/Desktop: keine Benachrichtigungen (siehe PlatformFeatures).
    if (!PlatformFeatures.notifications) return;
    await _plugin.cancelAll();
  }

  static void _onNotificationTap(NotificationResponse response) {
    // Warmer Tap (App läuft schon): Payload auswerten und zurück in den
    // Kochmodus navigieren. Beendet NICHTS — weder Timer noch Kochmodus.
    final payload = response.payload;
    if (payload != null && payload.startsWith(_cookingPayloadPrefix)) {
      onTimerTap?.call(payload.substring(_cookingPayloadPrefix.length));
    }
  }

  /// Kaltstart-Pfad: Wurde die App durch Tippen auf eine Timer-Benachrichtigung
  /// gestartet, liefert das die recipeId (ggf. leer) zurück, sonst null. Wird in
  /// `main()` ausgewertet, um direkt in den Kochmodus statt auf /home zu starten.
  static Future<String?> launchTimerPayload() async {
    // Windows/Desktop: keine Benachrichtigungen (siehe PlatformFeatures).
    if (!PlatformFeatures.notifications) return null;
    try {
      final details = await _plugin.getNotificationAppLaunchDetails();
      if (details?.didNotificationLaunchApp != true) return null;
      final payload = details!.notificationResponse?.payload;
      if (payload != null && payload.startsWith(_cookingPayloadPrefix)) {
        return payload.substring(_cookingPayloadPrefix.length);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Dürfen Mitteilungen angezeigt werden? (Nur prüfen, nicht fragen.)
  static Future<bool> notificationsAllowed() async {
    // Windows/Desktop: keine Benachrichtigungen (siehe PlatformFeatures).
    if (!PlatformFeatures.notifications) return true;
    try {
      if (Platform.isAndroid) {
        return await _plugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>()
                ?.areNotificationsEnabled() ??
            true;
      }
      if (Platform.isIOS) {
        final opts = await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.checkPermissions();
        return opts?.isEnabled ?? true;
      }
    } catch (_) {}
    return true;
  }

  static Future<bool> requestPermissions() async {
    // Windows/Desktop: keine Benachrichtigungen (siehe PlatformFeatures).
    if (!PlatformFeatures.notifications) return true;
    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await androidPlugin?.requestNotificationsPermission() ?? false;
    }
    if (Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      return await iosPlugin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: true,
          ) ??
          false;
    }
    return true;
  }
}
