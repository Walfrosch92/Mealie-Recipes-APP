import 'package:flutter/widgets.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

// ---------------------------------------------------------------------------
// Android Live Activity equivalent — mirrors iOS TimerViewModel Live Activity
//
// Uses flutter_foreground_task to show a persistent, updating notification
// that works like iOS Live Activity: visible on lock screen, updates in
// real-time even when app is backgrounded.
//
// WICHTIG: Der Countdown wird vom EIGENEN Isolate des Foreground-Service
// getickt (onRepeatEvent, 1×/s), NICHT vom Main-Isolate. Android drosselt
// `Timer.periodic` im Main-Isolate sobald die App im Hintergrund ist → die
// Notification blieb sonst auf ihrem letzten Wert „hängen" (z.B. 00:27, obwohl
// der Timer längst durch war). Der Service-Isolate läuft im Hintergrund weiter
// und rechnet die Restzeit aus einem ABSOLUTEN Endzeitpunkt (`_kEndKey`), den
// der Main-Isolate über den geteilten Datastore (SharedPreferences) hinterlegt.
// ---------------------------------------------------------------------------

const String _kTitleKey = 'timer_fg_title';
const String _kEndKey = 'timer_fg_end_ms'; // absolute Endzeit in epoch-ms
const String _kSuffixKey = 'timer_fg_suffix';

String _formatRemaining(int endMs, String suffix) {
  final remaining =
      ((endMs - DateTime.now().millisecondsSinceEpoch) / 1000).round();
  final r = remaining < 0 ? 0 : remaining;
  final m = (r ~/ 60).toString().padLeft(2, '0');
  final s = (r % 60).toString().padLeft(2, '0');
  final time = '$m:$s';
  return suffix.isEmpty ? time : '$time $suffix';
}

// Top-level entry point required by flutter_foreground_task
@pragma('vm:entry-point')
void timerTaskEntryPoint() {
  FlutterForegroundTask.setTaskHandler(_TimerTaskHandler());
}

class _TimerTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    await _render();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    _render();
  }

  /// Liest den aktuellen Timer-Stand aus dem geteilten Datastore und schreibt
  /// die Restzeit in die Notification. Läuft im Service-Isolate, daher auch im
  /// Hintergrund verlässlich getickt.
  Future<void> _render() async {
    final title =
        await FlutterForegroundTask.getData<String>(key: _kTitleKey) ?? 'Timer';
    final endMs = await FlutterForegroundTask.getData<int>(key: _kEndKey) ?? 0;
    final suffix =
        await FlutterForegroundTask.getData<String>(key: _kSuffixKey) ?? '';
    FlutterForegroundTask.updateService(
      notificationTitle: title,
      notificationText: _formatRemaining(endMs, suffix),
    );
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}
}

// ---------------------------------------------------------------------------
// Public API used by TimerNotifier
// ---------------------------------------------------------------------------

class TimerForegroundService {
  static bool _running = false;

  /// Initialize foreground task options (call once at app start)
  static void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'mealie_timer_foreground',
        channelName: 'Timer',
        channelDescription: 'Aktiver Rezept-Timer',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        // Service-Isolate jede Sekunde aufwecken → er tickt den Countdown selbst
        // (s. _TimerTaskHandler), auch wenn der Main-Isolate-Ticker im
        // Hintergrund gedrosselt ist.
        eventAction: ForegroundTaskEventAction.repeat(1000),
        autoRunOnBoot: false,
        allowWakeLock: true,
        // KEIN Auto-Neustart durch das Plugin: beendet Android den Service
        // (Speicher, dataSync-Zeitlimit ab Android 15), würde das Plugin ihn
        // per Alarm im HINTERGRUND neu starten → Android 12+ verbietet das
        // (ForegroundServiceStartNotAllowedException, Play-Console Build 41).
        // Der Alarm „Timer fertig" hängt nicht am Service (zonedSchedule), die
        // Notification kommt beim nächsten Öffnen der App wieder.
        allowAutoRestart: false,
      ),
    );
  }

  /// Start (oder aktualisiert) den Foreground-Service für einen laufenden Timer.
  /// [remainingSeconds] ist die aktuelle Restzeit; daraus wird die absolute
  /// Endzeit berechnet, an der der Service-Isolate den Countdown ausrichtet.
  static Future<void> start({
    required String title,
    required int remainingSeconds,
    String suffix = '',
  }) async {
    await _writeState(
        title: title, remainingSeconds: remainingSeconds, suffix: suffix);

    if (_running) return;
    // Android 12+ erlaubt den Start eines Foreground-Service nur, solange die
    // App im Vordergrund ist (sonst ForegroundServiceStartNotAllowedException).
    // Aus dem Hintergrund (z. B. Timer per Uhr fortgesetzt) daher auslassen —
    // der Ticker ruft start() jede Sekunde, beim Zurückkehren in die App
    // startet der Service dann von selbst.
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (lifecycle != null && lifecycle != AppLifecycleState.resumed) return;
    // Läuft schon (z. B. vorheriges stop() noch nicht verarbeitet)? Dann nur
    // den Merker angleichen statt eines zweiten Starts.
    if (await FlutterForegroundTask.isRunningService) {
      _running = true;
      return;
    }

    final result = await FlutterForegroundTask.startService(
      serviceId: 100,
      notificationTitle: title,
      notificationText: _formatRemaining(
        DateTime.now().millisecondsSinceEpoch + remainingSeconds * 1000,
        suffix,
      ),
      callback: timerTaskEntryPoint,
    );

    _running = result is ServiceRequestSuccess;
  }

  /// Update the notification with new timer state.
  ///
  /// Schreibt nur den geteilten State neu; das eigentliche Rendern übernimmt
  /// der Service-Isolate per onRepeatEvent (hintergrund-sicher). Ein direkter
  /// updateService-Aufruf aus dem Main-Isolate würde im Hintergrund nicht mehr
  /// feuern und die Notification „einfrieren" lassen.
  static Future<void> update({
    required String title,
    required int remainingSeconds,
    String suffix = '',
  }) async {
    if (!_running) return;
    await _writeState(
        title: title, remainingSeconds: remainingSeconds, suffix: suffix);
  }

  static Future<void> _writeState({
    required String title,
    required int remainingSeconds,
    required String suffix,
  }) async {
    final endMs =
        DateTime.now().millisecondsSinceEpoch + remainingSeconds * 1000;
    await FlutterForegroundTask.saveData(key: _kTitleKey, value: title);
    await FlutterForegroundTask.saveData(key: _kEndKey, value: endMs);
    await FlutterForegroundTask.saveData(key: _kSuffixKey, value: suffix);
  }

  /// Stop the foreground service
  static Future<void> stop() async {
    if (!_running) return;
    _running = false;
    await FlutterForegroundTask.stopService();
    // Das Plugin legt Start/Update/Stopp als EINEN Status in den Prefs ab.
    // Schreibt der Service-Isolate (Tick 1×/s) genau jetzt sein Update, geht
    // das Stopp-Kommando verloren und der Service liefe verwaist weiter (bis
    // Android ihn nach dem dataSync-Limit hart beendet →
    // ForegroundServiceDidNotStopInTimeException). Daher kurz nachprüfen.
    Future.delayed(const Duration(milliseconds: 1500), () async {
      if (_running) return; // inzwischen neu gestartet
      if (await FlutterForegroundTask.isRunningService) {
        await FlutterForegroundTask.stopService();
      }
    });
  }

  static bool get isRunning => _running;
}
