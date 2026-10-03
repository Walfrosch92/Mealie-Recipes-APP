import '../../../core/utils/platform_features.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cook_friends/services/cook_friends_service.dart';
import '../services/live_activity_service.dart';
import '../services/notification_service.dart';
import '../services/timer_foreground_service.dart';
import '../../../core/services/watch_bridge.dart';

// ---------------------------------------------------------------------------
// Timer model
// ---------------------------------------------------------------------------

// Sentinel für copyWith, damit `endAt` explizit auf null gesetzt werden kann
// (Standard-copyWith-Nullsemantik kann „nicht ändern" nicht von „auf null
// setzen" unterscheiden).
const Object _unset = Object();

class RecipeTimer {
  final int id; // unique ID, used for notifications
  /// Cross-device UUID für Cook-with-Friends-Timer-Sharing. Wenn gesetzt,
  /// nutzen Host und Guest die GLEICHE shareId um denselben Timer auf
  /// beiden Seiten zu adressieren (lokale `id` ist je Device individuell).
  /// `null` = lokaler Timer, nicht geshared.
  final String? shareId;
  final String name;
  final String recipeName;
  final String? recipeId; // for tapping the timer → open the recipe
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final bool isFinished;

  /// Absolute Wanduhr-Endzeit, solange der Timer LÄUFT. `remainingSeconds`
  /// wird daraus berechnet (`_recompute`), damit der Countdown auch dann
  /// stimmt, wenn der Dart-Ticker im Hintergrund (iOS-App-Suspend) eingefroren
  /// war und beim Foreground-Kommen aufholt. `null` wenn pausiert/fertig.
  final DateTime? endAt;

  const RecipeTimer({
    required this.id,
    this.shareId,
    required this.name,
    required this.recipeName,
    this.recipeId,
    required this.totalSeconds,
    required this.remainingSeconds,
    this.isRunning = false,
    this.isFinished = false,
    this.endAt,
  });

  RecipeTimer copyWith({
    int? remainingSeconds,
    bool? isRunning,
    bool? isFinished,
    Object? endAt = _unset,
  }) {
    return RecipeTimer(
      id: id,
      shareId: shareId,
      name: name,
      recipeName: recipeName,
      recipeId: recipeId,
      totalSeconds: totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isFinished: isFinished ?? this.isFinished,
      endAt: identical(endAt, _unset) ? this.endAt : endAt as DateTime?,
    );
  }

  String get displayTime {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get progress => totalSeconds > 0 ? remainingSeconds / totalSeconds : 0;

  // Persistenz: Timer müssen einen Prozess-Kill überleben (gesperrtes Gerät,
  // App im Hintergrund vom System abgeräumt). Sonst wäre der Timer nach dem
  // Tippen auf die Benachrichtigung „beendet" — er darf aber erst durch Tippen
  // auf den grünen Chip enden. Wir speichern die absolute Endzeit (endAt), aus
  // der die Restzeit beim Wiederherstellen exakt neu berechnet wird.
  Map<String, dynamic> toJson() => {
        'id': id,
        'shareId': shareId,
        'name': name,
        'recipeName': recipeName,
        'recipeId': recipeId,
        'totalSeconds': totalSeconds,
        'remainingSeconds': remainingSeconds,
        'isRunning': isRunning,
        'isFinished': isFinished,
        'endAt': endAt?.millisecondsSinceEpoch,
      };

  factory RecipeTimer.fromJson(Map<String, dynamic> json) => RecipeTimer(
        id: json['id'] as int,
        shareId: json['shareId'] as String?,
        name: json['name'] as String? ?? '',
        recipeName: json['recipeName'] as String? ?? '',
        recipeId: json['recipeId'] as String?,
        totalSeconds: json['totalSeconds'] as int? ?? 0,
        remainingSeconds: json['remainingSeconds'] as int? ?? 0,
        isRunning: json['isRunning'] as bool? ?? false,
        isFinished: json['isFinished'] as bool? ?? false,
        endAt: json['endAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['endAt'] as int)
            : null,
      );
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

/// In `main()` mit den aus SharedPreferences vorab geladenen Timern
/// überschrieben (per ProviderScope.overrides). Default leer.
final initialTimersProvider = Provider<List<RecipeTimer>>((ref) => const []);

final timerProvider =
    NotifierProvider<TimerNotifier, List<RecipeTimer>>(TimerNotifier.new);

class TimerNotifier extends Notifier<List<RecipeTimer>> {
  static const _kKey = 'timers_v1';

  Timer? _ticker;
  int _nextId = 1;
  AudioPlayer? _alarm;

  /// Ersatz-Alarm ohne Audio-Paket (Windows).
  Timer? _desktopAlarm;

  /// Signatur des zuletzt an die Uhr gepushten Timer-Zustands — OHNE die
  /// laufenden Restsekunden. Verhindert Sekundentakt-Pushes an die Uhr: die
  /// Uhr tickt den Countdown selbst aus dem einmal übertragenen Endzeitpunkt
  /// herunter, ein Push pro Sekunde flutete sonst die WatchConnectivity-Session
  /// (`sendMessage`/`updateApplicationContext`) auf dem Platform-Thread — das
  /// würgte den In-App-Alarm (`just_audio`) ab und ließ die Uhr-Anzeige
  /// flackern/verschwinden. `null` = aktuell kein Timer auf der Uhr.
  String? _lastWatchSig;

  @override
  List<RecipeTimer> build() {
    // App-Lifecycle beobachten: beim Zurückkehren aus dem Hintergrund die
    // Restzeiten aus den absoluten Endzeiten neu berechnen (iOS friert den
    // Dart-Ticker im Suspend ein → ohne das zeigte das In-App-Badge eine
    // veraltete Restzeit, z.B. 27 s bei längst abgelaufenem Timer).
    final observer = _TimerLifecycleObserver(this);
    WidgetsBinding.instance.addObserver(observer);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(observer);
      _ticker?.cancel();
      _alarm?.dispose();
      _desktopAlarm?.cancel();
    });
    // Smartwatch: Steuer-Aktionen (pause/resume/stop) von der Uhr empfangen und
    // auf den lokalen Timer mit der jeweiligen id anwenden. Idempotent
    // installiert; No-op außerhalb Android/iOS.
    WatchBridge.ensureActionListener();
    WatchBridge.timerActionHandler = _handleWatchAction;

    // Persistierte Timer wiederherstellen (Kaltstart über die Timer-
    // Benachrichtigung). _nextId hinter die höchste gespeicherte id setzen,
    // damit neue Timer keine Kollisionen erzeugen. Die eigentliche Reconciliation
    // (Restzeit neu berechnen, im Hintergrund abgelaufene Timer finalisieren,
    // Dauerton wieder anwerfen) läuft als Microtask, NACHDEM `state` gesetzt ist.
    final restored = ref.read(initialTimersProvider);
    if (restored.isNotEmpty) {
      _nextId = restored.map((t) => t.id).reduce(max) + 1;
      Future.microtask(_restoreAfterColdStart);
    }
    return restored;
  }

  /// Lädt die persistierten Timer (Aufruf in `main()` vor runApp).
  static Future<List<RecipeTimer>> loadPersisted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kKey);
      if (raw == null || raw.isEmpty) return const [];
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => RecipeTimer.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  void _persist() {
    final snapshot = jsonEncode(state.map((t) => t.toJson()).toList());
    SharedPreferences.getInstance()
        .then((p) => p.setString(_kKey, snapshot))
        .catchError((_) => false);
  }

  /// Nach einem Kaltstart: laufende Timer aus ihrer Endzeit neu berechnen, im
  /// Hintergrund abgelaufene finalisieren und — falls ein Timer fertig ist —
  /// den Dauerton wieder anwerfen. So „klingelt" ein abgelaufener Timer nach
  /// dem Wieder-Öffnen weiter, bis der Nutzer den grünen Chip antippt.
  void _restoreAfterColdStart() {
    final now = DateTime.now();
    bool anyFinished = false;
    state = state.map((t) {
      if (t.isFinished) {
        anyFinished = true;
        return t;
      }
      if (!t.isRunning || t.endAt == null) return t;
      final remaining = _remainingFrom(t.endAt!, now);
      if (remaining <= 0) {
        anyFinished = true;
        return t.copyWith(
            remainingSeconds: 0,
            isRunning: false,
            isFinished: true,
            endAt: null);
      }
      return t.copyWith(remainingSeconds: remaining);
    }).toList();
    if (anyFinished) _startAlarm();
    _ensureTicker();
    _updateLiveActivity();
    _persist();
  }

  /// Vom Lifecycle-Observer bei App-Resume gerufen: Restzeiten sofort aus den
  /// Endzeiten neu berechnen und ggf. im Hintergrund abgelaufene Timer
  /// finalisieren.
  void onAppResumed() {
    _recompute();
    _ensureTicker();
  }

  /// Wendet eine von der Uhr (Apple Watch / Wear OS) empfangene Steuer-Aktion
  /// auf den lokalen Timer an. `id` ist die lokale RecipeTimer.id (die Uhr
  /// bekommt sie mitgesendet und schickt sie zurück).
  void _handleWatchAction(String action, int id) {
    switch (action) {
      case 'pause':
        pause(id);
        break;
      case 'resume':
        start(id);
        break;
      case 'stop':
        stop(id);
        break;
    }
  }

  void addTimer({
    required String name,
    required String recipeName,
    required int minutes,
    String? recipeId,
    String? shareId,
  }) {
    // Cook-with-Friends Timer-Sharing: wenn aktiv UND der Caller keine
    // shareId mitgibt (= lokal initiiert, nicht von Peer empfangen), eine
    // generieren + broadcasten. Wird shareId übergeben (von applyRemote*),
    // ist der Timer schon vom Peer — kein Re-Broadcast.
    final cf = ref.read(cookFriendsProvider);
    final bool shouldBroadcast =
        shareId == null && cf.role != CookFriendsRole.none;
    final String? effectiveShareId =
        shareId ?? (shouldBroadcast ? _newUuidV4() : null);
    final timer = RecipeTimer(
      id: _nextId++,
      shareId: effectiveShareId,
      name: name,
      recipeName: recipeName,
      recipeId: recipeId,
      totalSeconds: minutes * 60,
      remainingSeconds: minutes * 60,
      isRunning: true,
      endAt: DateTime.now().add(Duration(seconds: minutes * 60)),
    );
    state = [...state, timer];
    _ensureTicker();
    _updateLiveActivity();
    _persist();
    // iOS: System-Notification zum exakten Endzeitpunkt scheduln, damit der
    // Alarm auch feuert wenn die App suspended/killed ist (Dart-Ticker tickt
    // sonst nicht). Android nutzt den Foreground-Service-Pfad.
    NotificationService.scheduleTimerFinished(
      id: timer.id,
      timerName: timer.name,
      recipeName: timer.recipeName,
      inSeconds: timer.remainingSeconds,
      recipeId: timer.recipeId,
    );
    if (shouldBroadcast && effectiveShareId != null) {
      ref.read(cookFriendsProvider.notifier).sendMessage(
            PeerMessage.timerStarted(
              shareId: effectiveShareId,
              name: name,
              recipeName: recipeName,
              remainingSeconds: timer.remainingSeconds,
            ),
          );
    }
  }

  // mDNS-/UUID-Helper — wir vermeiden ein neues Paket (uuid) und bauen v4
  // aus dart:math.Random.secure selbst, identisch zur UUID-Erzeugung
  // im shopping_list_provider und recipe_send_service.
  String _newUuidV4() {
    final r = Random.secure();
    final b = List<int>.generate(16, (_) => r.nextInt(256));
    b[6] = (b[6] & 0x0f) | 0x40;
    b[8] = (b[8] & 0x3f) | 0x80;
    String hex(int n) => n.toRadixString(16).padLeft(2, '0');
    final h = b.map(hex).join();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-'
        '${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
  }

  // ── Cook-Friends: Empfänger-seitige Anwendung von Peer-Timer-Events ─────

  void applyRemoteTimerStarted({
    required String shareId,
    required String name,
    required String recipeName,
    required int remainingSeconds,
  }) {
    if (state.any((t) => t.shareId == shareId)) return; // Duplikat verhindern
    // remainingSeconds in Minuten umrechnen für die addTimer-Signatur.
    // Bei sub-minute-Resten (Test-Timer mit 30 s) runden wir auf, damit der
    // Timer überhaupt sichtbar wird; der echte Endzeitpunkt steuert eh die
    // Notification.
    final mins = (remainingSeconds / 60).ceil().clamp(1, 1 << 30);
    addTimer(
      name: name,
      recipeName: recipeName,
      minutes: mins,
      shareId: shareId,
    );
    // remainingSeconds exakt setzen damit der Counter sofort mit dem
    // tatsächlich übertragenen Wert weiterläuft (statt mit ceil-aufgerundet
    // sichtbar zu sein).
    state = state.map((t) {
      if (t.shareId != shareId) return t;
      return t.copyWith(
        remainingSeconds: remainingSeconds,
        endAt: DateTime.now().add(Duration(seconds: remainingSeconds)),
      );
    }).toList();
    // Auch die in addTimer geschedultete System-Notification auf den exakten
    // Endzeitpunkt korrigieren — sonst feuert der Alarm bis zu 59 s zu spät
    // (ceil-Minuten statt übertragener Restsekunden).
    final t = state.where((x) => x.shareId == shareId).firstOrNull;
    if (t != null) {
      NotificationService.scheduleTimerFinished(
        id: t.id,
        timerName: t.name,
        recipeName: t.recipeName,
        inSeconds: remainingSeconds,
        recipeId: t.recipeId,
      );
    }
    // Uhr-Push erzwingen: addTimer hat der Uhr oben die auf volle Minuten
    // AUFGERUNDETE Restzeit gepusht (bis zu 59 s zu viel) — und die eben
    // korrigierte exakte Restzeit ändert die Watch-Signatur bewusst nicht
    // (Restsekunden sind kein Sig-Bestandteil, siehe _updateLiveActivity).
    // Einmalig die Signatur invalidieren, damit genau EIN Korrektur-Push mit
    // dem echten Endzeitpunkt rausgeht; der Sekunden-Throttle bleibt intakt.
    _lastWatchSig = null;
    _updateLiveActivity();
    _persist();
  }

  void applyRemoteTimerPaused({
    required String shareId,
    required int remainingSeconds,
  }) {
    state = state.map((t) {
      if (t.shareId != shareId || t.isFinished) return t;
      return t.copyWith(
          isRunning: false, remainingSeconds: remainingSeconds, endAt: null);
    }).toList();
    // Notification canceln damit der Alarm nicht fälschlich feuert.
    final t = state.where((t) => t.shareId == shareId).firstOrNull;
    if (t != null) NotificationService.cancel(t.id);
    _updateLiveActivity();
    _persist();
  }

  void applyRemoteTimerResumed({
    required String shareId,
    required int remainingSeconds,
  }) {
    state = state.map((t) {
      if (t.shareId != shareId || t.isFinished) return t;
      return t.copyWith(
          isRunning: true,
          remainingSeconds: remainingSeconds,
          endAt: DateTime.now().add(Duration(seconds: remainingSeconds)));
    }).toList();
    _ensureTicker();
    _updateLiveActivity();
    final t = state.where((t) => t.shareId == shareId).firstOrNull;
    if (t != null) {
      NotificationService.scheduleTimerFinished(
        id: t.id,
        timerName: t.name,
        recipeName: t.recipeName,
        inSeconds: remainingSeconds,
        recipeId: t.recipeId,
      );
    }
    _persist();
  }

  void applyRemoteTimerStopped(String shareId) {
    final t = state.where((t) => t.shareId == shareId).firstOrNull;
    if (t == null) return;
    // stop(id) handhabt cancel/remove/alarm-stop sauber; wir umgehen aber
    // den Cook-Friends-Broadcast aus stop(), indem wir hier direkt das State-
    // Update + die NotificationService.cancel-Logik replizieren — sonst
    // würde der gerade empfangene Stop wieder rausgesendet werden.
    state = state.where((x) => x.id != t.id).toList();
    NotificationService.cancel(t.id);
    _stopAlarmIfNoneRinging();
    _stopIfIdle();
    _updateLiveActivity();
    _persist();
  }

  void start(int id) {
    state = state.map((t) {
      if (t.id != id || t.isFinished) return t;
      return t.copyWith(
        isRunning: true,
        endAt: DateTime.now().add(Duration(seconds: t.remainingSeconds)),
      );
    }).toList();
    _ensureTicker();
    _updateLiveActivity();
    // iOS: System-Alarm mit der verbleibenden Restzeit NEU scheduln. Sonst feuert
    // nach einem Resume (z.B. von der Uhr → _handleWatchAction → start) im
    // Hintergrund kein Alarm mehr, weil pause() die Notification gecancelt hat.
    final t = state.where((t) => t.id == id).firstOrNull;
    if (t != null && t.isRunning && !t.isFinished) {
      NotificationService.scheduleTimerFinished(
        id: t.id,
        timerName: t.name,
        recipeName: t.recipeName,
        inSeconds: t.remainingSeconds,
        recipeId: t.recipeId,
      );
      // Cook-with-Friends: Resume eines GETEILTEN Timers broadcasten. Der
      // Watch-Steuerpfad (_handleWatchAction) läuft über start()/pause()
      // statt togglePause() — ohne Broadcast liefen die Peer-Timer
      // auseinander (dort klingelt es, lokal nicht). applyRemoteTimerResumed
      // setzt den State direkt (ruft nicht start()) → keine Echo-Schleife.
      _broadcastSharedTimerState(t);
    }
    _persist();
  }

  void pause(int id) {
    final now = DateTime.now();
    state = state.map((t) {
      if (t.id != id) return t;
      // Restzeit aus der Endzeit einfrieren (falls der Ticker grad hinterher
      // hing) und endAt löschen — pausierte Timer laufen nicht mit der Uhr.
      final remaining =
          t.endAt != null ? _remainingFrom(t.endAt!, now) : t.remainingSeconds;
      return t.copyWith(
        isRunning: false,
        remainingSeconds: remaining,
        endAt: null,
      );
    }).toList();
    _updateLiveActivity();
    // iOS: gescheduletes System-Alarm canceln — Timer steht und soll nicht
    // alleine im Hintergrund weiterlaufen.
    NotificationService.cancel(id);
    // Cook-with-Friends: Pause eines GETEILTEN Timers broadcasten (Pendant
    // zum Resume-Broadcast in start(); Details siehe dort).
    final t = state.where((t) => t.id == id).firstOrNull;
    if (t != null && !t.isFinished) _broadcastSharedTimerState(t);
    _persist();
  }

  void stop(int id) {
    // shareId vor dem Entfernen sichern für den Broadcast unten.
    final removed = state.where((t) => t.id == id).firstOrNull;
    state = state.where((t) => t.id != id).toList();
    NotificationService.cancel(id);
    // War der quittierte Timer bereits fertig (grüner Chip im Kochmodus), der
    // Uhr sagen, dass sie ihr bereits zugestelltes „Timer fertig"-Banner
    // wegräumen soll. Ein evtl. weiterer noch laufender Timer bleibt davon
    // unberührt und läutet bei seinem Ablauf normal weiter.
    if (removed?.isFinished == true) {
      WatchBridge.dismissFinishedAlarm([removed!.id]);
    }
    _stopAlarmIfNoneRinging();
    _stopIfIdle();
    _updateLiveActivity();
    _persist();
    if (removed?.shareId != null) {
      final cf = ref.read(cookFriendsProvider);
      if (cf.role != CookFriendsRole.none) {
        ref
            .read(cookFriendsProvider.notifier)
            .sendMessage(PeerMessage.timerStopped(removed!.shareId!));
      }
    }
  }

  // mirrors iOS CookingSessionManager.stopTimer / matches CookingModeScreen usage
  void removeTimer(int id) => stop(id);

  // mirrors iOS CookingSessionManager.toggleTimerPause
  void togglePause(int id) {
    final now = DateTime.now();
    RecipeTimer? touched;
    state = state.map((t) {
      if (t.id != id || t.isFinished) return t;
      final willRun = !t.isRunning;
      final RecipeTimer next;
      if (willRun) {
        next = t.copyWith(
          isRunning: true,
          endAt: now.add(Duration(seconds: t.remainingSeconds)),
        );
      } else {
        final remaining = t.endAt != null
            ? _remainingFrom(t.endAt!, now)
            : t.remainingSeconds;
        next = t.copyWith(
          isRunning: false,
          remainingSeconds: remaining,
          endAt: null,
        );
      }
      touched = next;
      return next;
    }).toList();
    if (state.any((t) => t.isRunning)) _ensureTicker();
    _updateLiveActivity();
    if (touched == null) return;
    final t = touched!;
    // iOS: gescheduletes Alarm-Notification jeweils mit der noch verbliebenen
    // Restzeit neu setzen / canceln.
    if (t.isRunning) {
      NotificationService.scheduleTimerFinished(
        id: t.id,
        timerName: t.name,
        recipeName: t.recipeName,
        inSeconds: t.remainingSeconds,
        recipeId: t.recipeId,
      );
    } else {
      NotificationService.cancel(id);
    }
    // Cook-with-Friends Broadcast (nur wenn der Timer geshared ist).
    _broadcastSharedTimerState(t);
    _persist();
  }

  /// Broadcastet den Lauf-/Pause-Zustand eines GETEILTEN Timers an die
  /// Cook-with-Friends-Peers (timerResumed/timerPaused). No-op für lokale
  /// Timer (shareId == null) oder ohne aktive Session.
  void _broadcastSharedTimerState(RecipeTimer t) {
    if (t.shareId == null) return;
    final cf = ref.read(cookFriendsProvider);
    if (cf.role == CookFriendsRole.none) return;
    ref.read(cookFriendsProvider.notifier).sendMessage(
          t.isRunning
              ? PeerMessage.timerResumed(
                  shareId: t.shareId!,
                  remainingSeconds: t.remainingSeconds,
                )
              : PeerMessage.timerPaused(
                  shareId: t.shareId!,
                  remainingSeconds: t.remainingSeconds,
                ),
        );
  }

  // Beendet alle GETEILTEN Timer (shareId != null) lokal — OHNE Broadcast an
  // die Peers (anders als stop(id)). Genutzt wenn der Host die Cook-Friends-
  // Session beendet: die vom Host gesteuerten Timer sind dann beim Gast nutzlos
  // und sollen nicht weiterlaufen/alarmieren. Eigene, NICHT geteilte Timer
  // (shareId == null) eines Gasts MIT eigenem Server bleiben unangetastet.
  void stopShared() {
    final shared = state.where((t) => t.shareId != null).toList();
    if (shared.isEmpty) return;
    for (final t in shared) {
      NotificationService.cancel(t.id);
    }
    // War einer der beendeten geteilten Timer bereits fertig, der Uhr das
    // Wegräumen SEINES „Timer fertig"-Banners signalisieren.
    WatchBridge.dismissFinishedAlarm(
        shared.where((t) => t.isFinished).map((t) => t.id).toList());
    state = state.where((t) => t.shareId == null).toList();
    // Dieselbe Aufräum-Trias wie stop(id): Alarm stoppen falls keiner mehr
    // klingelt, Ticker/Foreground-Service beenden falls nichts mehr läuft,
    // Live-Activity/Watch aktualisieren.
    _stopAlarmIfNoneRinging();
    _stopIfIdle();
    _updateLiveActivity();
    _persist();
  }

  void stopAll() {
    final finishedIds =
        state.where((t) => t.isFinished).map((t) => t.id).toList();
    for (final t in state) {
      NotificationService.cancel(t.id);
    }
    state = [];
    _ticker?.cancel();
    _ticker = null;
    _alarm?.stop();
    if (Platform.isAndroid) TimerForegroundService.stop();
    if (Platform.isIOS) LiveActivityService.stop();
    // Kochmodus beendet → auch evtl. noch zugestellte „Timer fertig"-Banner
    // von der Uhr quittieren (clearTimers allein räumt nur die laufende
    // Anzeige, nicht schon gefeuerte Notifications).
    WatchBridge.dismissFinishedAlarm(finishedIds);
    _lastWatchSig = null;
    WatchBridge.clearTimers(); // Apple Watch / Wear OS
    _persist();
  }

  void _ensureTicker() {
    if (_ticker?.isActive == true) return;
    if (!state.any((t) => t.isRunning && !t.isFinished)) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _recompute());
  }

  /// Berechnet die Restzeit aller laufenden Timer aus ihrer absoluten Endzeit
  /// (`endAt`) statt einfach „minus 1 pro Tick". So bleibt der Countdown
  /// korrekt, selbst wenn der Ticker Sekunden verpasst hat (iOS-Hintergrund-
  /// Suspend) — beim ersten Tick/Resume springt die Anzeige direkt auf den
  /// wahren Wert und im Hintergrund abgelaufene Timer werden hier finalisiert.
  // Restsekunden bis [endAt], ceil-gerundet: zeigt im ersten Sekundenfenster
  // noch den vollen Wert (60 statt sofort 59) und erreicht bei endAt exakt 0.
  static int _remainingFrom(DateTime endAt, DateTime now) {
    final ms = endAt.difference(now).inMilliseconds;
    return ms <= 0 ? 0 : (ms / 1000).ceil();
  }

  void _recompute() {
    final now = DateTime.now();
    bool changed = false;
    final finished = <RecipeTimer>[];
    final updated = state.map((t) {
      if (!t.isRunning || t.isFinished || t.endAt == null) return t;
      final remaining = _remainingFrom(t.endAt!, now);
      if (remaining <= 0) {
        changed = true;
        finished.add(t);
        return t.copyWith(
            remainingSeconds: 0,
            isRunning: false,
            isFinished: true,
            endAt: null);
      }
      if (remaining != t.remainingSeconds) {
        changed = true;
        return t.copyWith(remainingSeconds: remaining);
      }
      return t;
    }).toList();

    if (changed) {
      state = updated;
      for (final t in finished) {
        _onFinished(t);
      }
      _updateLiveActivity(); // update Android foreground notification
      // Nur bei strukturellem Wechsel (Timer fertig) persistieren — NICHT im
      // Sekundentakt: die Restzeit wird beim Wiederherstellen ohnehin aus
      // `endAt` neu berechnet.
      if (finished.isNotEmpty) _persist();
    }
    _stopIfIdle();
  }

  void _onFinished(RecipeTimer t) {
    // iOS: Wenn die App im Foreground ist und der Ticker tickt, ist die
    // gescheduletete System-Notification ungefähr gleichzeitig dran — wir
    // sparen uns die Foreground-Show um Duplikat-Banner zu vermeiden.
    // Android: kein Schedule, also wie bisher direkt zeigen.
    if (!Platform.isIOS) {
      NotificationService.showTimerFinished(
        id: t.id,
        timerName: t.name,
        recipeName: t.recipeName,
        recipeId: t.recipeId,
      );
    }
    HapticFeedback.heavyImpact();
    _startAlarm();
    // Uhr (Apple Watch / Wear OS) läuten/vibrieren lassen.
    WatchBridge.timerFinished(t.id);
  }

  // Play the alarm sound on loop (foreground ring). Stops when no finished
  // timer remains (see _stopAlarmIfNoneRinging).
  Future<void> _startAlarm() async {
    // Windows/Desktop: kein just_audio → System-Hinweiston alle 2 s, bis der
    // Timer quittiert ist (siehe PlatformFeatures.alarmSound).
    if (!PlatformFeatures.alarmSound) {
      _desktopAlarm ??= Timer.periodic(const Duration(seconds: 2), (_) {
        SystemSound.play(SystemSoundType.alert);
      });
      SystemSound.play(SystemSoundType.alert);
      return;
    }
    try {
      _alarm ??= AudioPlayer();
      await _alarm!.setLoopMode(LoopMode.all);
      await _alarm!.setAsset('assets/audio/alarm.wav');
      await _alarm!.play();
    } catch (_) {/* sound is best-effort */}
  }

  void _stopAlarmIfNoneRinging() {
    if (!state.any((t) => t.isFinished)) {
      _alarm?.stop();
      _desktopAlarm?.cancel();
      _desktopAlarm = null;
    }
  }

  void _stopIfIdle() {
    if (state.every((t) => !t.isRunning)) {
      _ticker?.cancel();
      _ticker = null;
    }
    // Stop Android foreground service / iOS Live Activity when no active timers
    if (state.every((t) => t.isFinished || !t.isRunning)) {
      if (Platform.isAndroid) TimerForegroundService.stop();
      if (Platform.isIOS) LiveActivityService.stop();
    }
  }

  // Update the platform's persistent timer view:
  //   Android → foreground-service notification (TimerForegroundService)
  //   iOS     → Live Activity (LiveActivityService)
  void _updateLiveActivity() {
    // Phone (Foreground-Service / Live Activity): nur LAUFENDE Timer.
    final running = state.where((t) => t.isRunning && !t.isFinished).toList();
    if (running.isEmpty) {
      if (Platform.isAndroid) TimerForegroundService.stop();
      if (Platform.isIOS) LiveActivityService.stop();
    } else {
      final next = running
          .reduce((a, b) => a.remainingSeconds < b.remainingSeconds ? a : b);
      final extraCount = running.length - 1;
      if (Platform.isAndroid) {
        // Nur die Restsekunden + ein optionales Suffix übergeben — den
        // Countdown rendert der Foreground-Service-Isolate selbst aus der
        // absoluten Endzeit (hintergrund-sicher, friert nicht ein).
        final suffix = extraCount > 0 ? '(+$extraCount weitere)' : '';
        TimerForegroundService.start(
          title: next.name,
          remainingSeconds: next.remainingSeconds,
          suffix: suffix,
        );
      } else if (Platform.isIOS) {
        LiveActivityService.update(
          timerName: next.name,
          recipeName: next.recipeName,
          remainingSeconds: next.remainingSeconds,
          totalSeconds: next.totalSeconds,
          isPaused: !next.isRunning,
          extraCount: extraCount,
        );
      }
    }

    // Uhr (Apple Watch / Wear OS): AUCH pausierte Timer spiegeln — sonst
    // verschwindet ein auf der Uhr pausierter Timer und kann nur noch am Handy
    // fortgesetzt werden. ALLE nicht-fertigen Timer gehen raus (laufend ODER
    // pausiert) — die Uhr zeigt sie wischbar, ein Timer pro Seite.
    //
    // WICHTIG: NUR bei watch-relevanten Zustandswechseln pushen, NICHT im
    // Sekundentakt. `_recompute` ruft diese Methode jede Sekunde — die Uhr
    // tickt jeden Countdown aber selbst aus dem einmal übertragenen Endzeit-
    // punkt herunter. Ein Push pro Sekunde bedeutete bei erreichbarer Uhr ein
    // `WCSession.sendMessage` pro Sekunde: das staute den Platform-Thread und
    // würgte den In-App-Alarm (`just_audio`) ab (ohne erreichbare Uhr lief nur
    // das billige `transferUserInfo` → Ton spielte) und ließ die Uhr-Anzeige
    // flackern/verschwinden. Die laufenden Restsekunden gehen deshalb bewusst
    // NICHT in die Signatur ein.
    final watchable = state.where((t) => !t.isFinished).toList();
    if (watchable.isEmpty) {
      if (_lastWatchSig != null) {
        _lastWatchSig = null;
        WatchBridge.clearTimers();
      }
    } else {
      // Signatur = alles, was die Uhr für eine frische Anzeige braucht, OHNE
      // die laufenden Restsekunden: je Timer id/Lauf-Zustand/Dauer/Namen, in
      // der angezeigten Reihenfolge. Wechselt sie (Start/Pause/Resume/Stop/
      // neuer Timer), bekommt die Uhr genau EINEN Push mit den aktuellen
      // Endzeitpunkten; dazwischen Funkstille.
      final sig = watchable
          .map((t) =>
              '${t.id}|${t.isRunning}|${t.totalSeconds}|${t.name}|${t.recipeName}')
          .join(';');
      if (sig != _lastWatchSig) {
        _lastWatchSig = sig;
        WatchBridge.updateTimers(watchable
            .map((t) => {
                  'id': t.id,
                  'timerName': t.name,
                  'recipeName': t.recipeName,
                  'remainingSeconds': t.remainingSeconds,
                  'totalSeconds': t.totalSeconds,
                  'isPaused': !t.isRunning,
                })
            .toList());
      }
    }
  }
}

/// Reconciles timer remaining-times from their absolute end-times whenever the
/// app returns to the foreground. iOS suspends the Dart isolate (and thus the
/// `Timer.periodic` ticker) while backgrounded, so without this the in-app
/// timer badge would resume from a stale, frozen value.
class _TimerLifecycleObserver extends WidgetsBindingObserver {
  final TimerNotifier _notifier;
  _TimerLifecycleObserver(this._notifier);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _notifier.onAppResumed();
    }
  }
}
