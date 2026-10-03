import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bonsoir/bonsoir.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/local_cache.dart';
import '../../../core/services/log_manager.dart';
import '../../cook_friends/services/cook_friends_service.dart'
    show bindDualStack;
import 'recipe_mailbox.dart';

// ---------------------------------------------------------------------------
// SendTo-Pipeline für Mealie-Rezepte.
//
// Transport-Architektur:
//   • LAN/mDNS+TCP — beide Plattformen, sofortige Lieferung im selben WLAN.
//   • Android-only: lokale Outgoing-Queue (Variante B). Wenn das Ziel zur
//     Sendezeit offline ist, wird die Lieferung persistiert und beim
//     nächsten mDNS-Resolve dieses Peers automatisch nachgeholt. TTL 7d.
//   • Mealie-Postfach (beide Plattformen, siehe RecipeMailbox): ist das Ziel
//     nicht direkt erreichbar, landet die Sendung in einer versteckten
//     Einkaufsliste auf dem Mealie-Server und wird beim nächsten Öffnen der
//     App auf dem Zielgerät abgeholt. Bekannte Geräte erscheinen darüber
//     auch offline in der Auswahl.
//   • iOS-only: CloudKit-Bridge (1:1 zur Swift-App). Zusätzlich zum
//     TCP-Push wird bei jedem Send ein CKRecord erzeugt, damit das Ziel
//     auch bei geschlossener App via Silent-Push geweckt wird und beim
//     Öffnen Pending-Recipes liefert. Payload: nur recipeId+recipeName
//     (volles Rezept wird aus Mealie nachgeladen, wie im Swift-Original).
//
// Empfänger-seitige Dedupe via sendId — verhindert dass derselbe Send
// durch mehrere Transporte (CloudKit + TCP, Sender-Retry) doppelt landet.
// Persistente Sheet: empfangene Rezepte überleben App-Neustarts.
// ---------------------------------------------------------------------------

const _serviceType = '_mealiesend._tcp';
const _servicePort = 54322;
const _deviceIdPrefsKey = 'recipe_send_device_id';
const _deviceSincePrefsKey = 'recipe_send_device_since';
const _txtDeviceIdKey = 'mealieDeviceId';

// MethodChannel/EventChannel-Namen — beide Seiten (Dart + iOS-Swift)
// müssen identisch sein, sonst kein Traffic. Android wird die Channels
// nie ansprechen; MissingPluginException wird gefangen.
const _ckMethodChannel = MethodChannel('mealie/cloudkit');
const _ckEventChannel = EventChannel('mealie/cloudkit/events');

// Obergrenze für eine empfangene Sendung (Zeichen) — Schutz vor Fluten.
const _maxReceiveChars = 5 * 1024 * 1024;

// Max-Bound für den persistenten Dedupe-Set; ältester sendId wird verdrängt.
const _maxProcessedSendIds = 200;
// TTL für Android-Outgoing-Queue. Ältere Einträge werden beim Laden verworfen.
const _outgoingTtl = Duration(days: 7);

// ---------------------------------------------------------------------------
// Datenmodelle
// ---------------------------------------------------------------------------

class RecipePeer {
  /// Persistente Device-ID des Peers (aus dem TXT-Record). Wird als
  /// Dedupe-Schlüssel verwendet und überlebt Umbenennungen des Geräts.
  final String deviceId;
  final String name;
  final String host;
  final int port;

  /// Nur aus dem Mealie-Postfach bekannt, gerade nicht erreichbar —
  /// Zustellung beim nächsten Öffnen der App auf dem Gerät.
  final bool remembered;

  const RecipePeer({
    required this.deviceId,
    required this.name,
    required this.host,
    required this.port,
    this.remembered = false,
  });
}

/// Ergebnis eines Sendevorgangs (für die Rückmeldung in der UI).
enum SendOutcome {
  /// Direkt zugestellt (LAN) bzw. an CloudKit übergeben.
  delivered,

  /// Im Mealie-Postfach abgelegt — kommt an, sobald das Ziel die App öffnet.
  mailbox,

  /// Weder Ziel noch Server erreichbar — wird automatisch nachgeholt.
  queued,
}

class PendingRecipe {
  /// Eindeutige Send-ID (UUID v4). Erzeugt vom Sender, im Wire-Protokoll
  /// mitgegeben — Empfänger nutzt sie für Dedupe (gleicher Send via TCP
  /// UND CloudKit, oder Sender-Retry weil er Zustellung nicht bestätigt
  /// bekam).
  final String sendId;
  final String senderName;
  final RecipeDetail recipe;

  const PendingRecipe({
    required this.sendId,
    required this.senderName,
    required this.recipe,
  });

  Map<String, dynamic> toJson() => {
        'sendId': sendId,
        'senderName': senderName,
        'recipe': recipe.toJson(),
      };

  factory PendingRecipe.fromJson(Map<String, dynamic> json) => PendingRecipe(
        sendId: json['sendId'] as String? ?? '',
        senderName: json['senderName'] as String? ?? '',
        recipe: RecipeDetail.fromJson(
            (json['recipe'] as Map).cast<String, dynamic>()),
      );
}

class PendingOutgoingSend {
  final String sendId;
  final String targetDeviceId;
  final String targetName;
  final Map<String, dynamic> recipeJson;
  final DateTime queuedAt;

  /// Liegt schon im Mealie-Postfach — bleibt nur für die direkte
  /// LAN-Nachlieferung gemerkt (Ziel evtl. in einem anderen Haushalt, wo das
  /// Postfach nie ankommt). Empfänger entdoppelt per sendId.
  final bool mailboxed;

  const PendingOutgoingSend({
    required this.sendId,
    required this.targetDeviceId,
    required this.targetName,
    required this.recipeJson,
    required this.queuedAt,
    this.mailboxed = false,
  });

  Map<String, dynamic> toJson() => {
        'sendId': sendId,
        'targetDeviceId': targetDeviceId,
        'targetName': targetName,
        'recipe': recipeJson,
        'queuedAt': queuedAt.toIso8601String(),
        'mailboxed': mailboxed,
      };

  factory PendingOutgoingSend.fromJson(Map<String, dynamic> json) =>
      PendingOutgoingSend(
        sendId: json['sendId'] as String? ?? '',
        targetDeviceId: json['targetDeviceId'] as String? ?? '',
        targetName: json['targetName'] as String? ?? '',
        recipeJson: (json['recipe'] as Map).cast<String, dynamic>(),
        queuedAt: DateTime.tryParse(json['queuedAt'] as String? ?? '') ??
            DateTime.now(),
        mailboxed: json['mailboxed'] as bool? ?? false,
      );
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final recipeSendProvider =
    AsyncNotifierProvider<RecipeSendNotifier, List<RecipePeer>>(
        RecipeSendNotifier.new);

final pendingRecipesProvider =
    NotifierProvider<PendingRecipesNotifier, List<PendingRecipe>>(
        PendingRecipesNotifier.new);

// ---------------------------------------------------------------------------
// PendingRecipesNotifier — persistente Empfänger-Sheet-State
// ---------------------------------------------------------------------------

class PendingRecipesNotifier extends Notifier<List<PendingRecipe>> {
  @override
  List<PendingRecipe> build() {
    // Build ist sync — Hydrate läuft asynchron und ersetzt state sobald da.
    // Der app.dart-Listener triggert auf die empty→nonempty Transition und
    // öffnet das Sheet automatisch beim App-Start wenn was persistiert ist.
    _hydrate();
    return [];
  }

  Future<void> _hydrate() async {
    try {
      final raw = await LocalCache.loadPendingReceivedRecipes();
      if (raw.isEmpty) return;
      final loaded = raw.map(PendingRecipe.fromJson).toList();
      if (loaded.isEmpty) return;
      // MERGEN statt ersetzen: ein Rezept, das während des async Loads schon
      // via TCP/CloudKit reinkam (checkOnLaunch läuft genau beim App-Start),
      // fehlt im gerade geladenen Persist-Stand — ein Overwrite würfe es aus
      // dem State, und da seine sendId bereits als processed markiert ist,
      // würde auch keine erneute Zustellung mehr angenommen.
      final current = state;
      state = [
        ...loaded.where((l) => !current.any((c) => c.sendId == l.sendId)),
        ...current,
      ];
      if (current.isNotEmpty) _persist();
    } catch (_) {}
  }

  /// Fügt ein Rezept hinzu. Dedupe per sendId — wenn schon vorhanden, no-op.
  void add(PendingRecipe r) {
    if (r.sendId.isNotEmpty &&
        state.any((existing) => existing.sendId == r.sendId)) {
      return;
    }
    state = [...state, r];
    _persist();
  }

  /// Entfernt nach Recipe-Name. Behält die Signatur des alten APIs.
  void remove(String name) {
    state = state.where((r) => r.recipe.name != name).toList();
    _persist();
  }

  void clear() {
    state = [];
    _persist();
  }

  void _persist() {
    unawaited(LocalCache.savePendingReceivedRecipes(
        state.map((r) => r.toJson()).toList()));
  }
}

// ---------------------------------------------------------------------------
// RecipeSendNotifier — Discovery + Send + Receive + persistente Queues
// ---------------------------------------------------------------------------

class RecipeSendNotifier extends AsyncNotifier<List<RecipePeer>> {
  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;
  StreamSubscription? _discoverySub;
  ServerSocket? _server;
  StreamSubscription? _ckEventSub;

  /// Laufender Teardown des VORHERIGEN Builds (Rebuild bei Settings-Change).
  /// Der nächste build() wartet darauf, bevor er den TCP-Server neu bindet —
  /// sonst racet der neue bind gegen den noch offenen alten Socket
  /// („Address already in use" → Empfangspfad tot bis zum nächsten Rebuild).
  Future<void>? _cleanupFuture;
  _AppResumeObserver? _resumeObserver;

  /// Einmal-Observer: mDNS nach einem Bonsoir-Fehler erst beim nächsten
  /// Vordergrund neu starten (siehe [_onMDnsError]).
  _AppResumeObserver? _mdnsRestartObserver;
  bool _restartingMDns = false;
  DateTime? _lastMDnsRestart;
  // iOS: aktiver CloudKit-Poll solange die App im Vordergrund ist (s.
  // _startCkForegroundPoll). Holt wartende Rezepte in Sekunden statt erst mit
  // dem von APNs gedrosselten Silent-Push (~30 s).
  Timer? _ckForegroundPoll;
  String _deviceName = 'Device';
  String _deviceId = '';

  /// Seit wann es [_deviceId] gibt (für das Postfach, s. RecipeMailbox).
  DateTime _deviceSince = DateTime.now();

  /// FIFO-Set der bereits verarbeiteten sendIds — verhindert dass eine
  /// zweite Lieferung desselben Sends (Sender-Retry, CloudKit+TCP-Doppel)
  /// nochmal als Pending auftaucht. Max 200 Einträge.
  final List<String> _processedSendIds = [];

  /// Android-Outgoing-Queue: TCP-Sends die fehlgeschlagen sind, weil das
  /// Ziel kurz offline war. Beim nächsten mDNS-Resolve des Ziel-Peers
  /// wird automatisch nachgeliefert.
  final List<PendingOutgoingSend> _pendingOutgoing = [];

  /// Apple-ID-Peers aus iCloud KV-Store-Registry (iOS-only). Erscheinen
  /// sofort beim App-Start ohne mDNS-Resolve — Voraussetzung: gleicher
  /// iCloud-Account, App installiert. Keine host/port-Felder, Zustellung
  /// läuft über CloudKit.
  final List<RecipePeer> _applePeers = [];

  /// Per mDNS entdeckte Peers (beide Plattformen). Werden über die
  /// LAN-TCP-Transport-Strecke beliefert. Wenn ein Peer in beiden Listen
  /// auftaucht (Apple-ID + LAN), gewinnt der mDNS-Eintrag im Merge weil
  /// LAN sofortig zustellt.
  final List<RecipePeer> _mDnsPeers = [];

  /// Aus dem Mealie-Postfach bekannte Geräte (auch offline auswählbar).
  final List<RecipePeer> _mailboxPeers = [];
  RecipeMailbox? _mailbox;
  Timer? _mailboxPoll;
  _AppResumeObserver? _mailboxObserver;
  bool _mailboxSyncing = false;

  @override
  Future<List<RecipePeer>> build() async {
    ref.onDispose(() {
      _cleanupFuture = _cleanup();
    });
    final settings = ref.watch(settingsProvider).valueOrNull;
    if (settings == null || !settings.isConfigured) {
      return const [];
    }

    // Teardown des vorherigen Builds abwarten (siehe _cleanupFuture-Doku).
    final pendingCleanup = _cleanupFuture;
    if (pendingCleanup != null) {
      await pendingCleanup;
      _cleanupFuture = null;
    }

    // Schneller lokaler Init — überlebt ein paar ms.
    _deviceId = await _loadOrCreateDeviceId();
    await _loadProcessedSendIds();
    await _loadPendingOutgoing();
    await _resolveDeviceName();

    // iOS: iCloud-Peers SOFORT seeden (KV-Store ist lokal gecached, der
    // erste Read ist instant). mDNS läuft parallel im Hintergrund weiter.
    if (Platform.isIOS) {
      _applePeers
        ..clear()
        ..addAll(await _initCloudKitAndSeed());
      // Bei jedem App-Vordergrund (z.B. Tippen auf die CloudKit-Banner-
      // Notification eines gesperrten/geschlossenen Geräts) wartende Rezepte
      // nachziehen — der RecipeSendNotifier baut bei einem Warm-Resume nicht
      // neu, daher hier ein Lifecycle-Observer.
      _resumeObserver = _AppResumeObserver(
        onResume: () {
          // Sofort einmal prüfen (z. B. nach Tippen auf die Banner-Notification)
          // UND den Vordergrund-Poll wieder anwerfen.
          _ckMethodChannel.invokeMethod('checkOnLaunch').catchError((_) {});
          _startCkForegroundPoll();
        },
        onBackground: _stopCkForegroundPoll,
      );
      WidgetsBinding.instance.addObserver(_resumeObserver!);
      // Service wird im Vordergrund aufgebaut → Poll sofort starten.
      _startCkForegroundPoll();
    }

    // Mealie-Postfach: beim Start, bei jeder Rückkehr in die App und im
    // Vordergrund jede Minute abholen.
    _mailbox = RecipeMailbox(
      api: ref.read(apiServiceProvider),
      deviceId: _deviceId,
      deviceName: _deviceName,
      userId: () => ref.read(currentUserProvider)?['id']?.toString(),
      deviceSince: _deviceSince,
    );
    _mailboxObserver = _AppResumeObserver(
      onResume: () {
        unawaited(_syncMailbox());
        _startMailboxPoll();
      },
      onBackground: _stopMailboxPoll,
    );
    WidgetsBinding.instance.addObserver(_mailboxObserver!);
    _startMailboxPoll();
    unawaited(_syncMailbox());

    // mDNS fire-and-forget — wenn Bonsoir hängt (Local-Network-Permission
    // verweigert, Router-Bug), blockt das NICHT mehr die ganze Sheet.
    // Discovery-Events updaten state asynchron via _publishMergedPeers.
    unawaited(_startMDns());

    return _mergedPeers();
  }

  // ── Identity ──────────────────────────────────────────────────────────────

  Future<String> _loadOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    // Zeitpunkt der ID merken; IDs von vor dieser Version bekommen „jetzt".
    final since =
        DateTime.tryParse(prefs.getString(_deviceSincePrefsKey) ?? '');
    _deviceSince = since ?? DateTime.now().toUtc();
    if (since == null) {
      await prefs.setString(
          _deviceSincePrefsKey, _deviceSince.toIso8601String());
    }
    final existing = prefs.getString(_deviceIdPrefsKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final id = _newUuidV4();
    await prefs.setString(_deviceIdPrefsKey, id);
    return id;
  }

  // ── Persistenz: processed sendIds ─────────────────────────────────────────

  Future<void> _loadProcessedSendIds() async {
    try {
      final loaded = await LocalCache.loadProcessedSendIds();
      _processedSendIds
        ..clear()
        ..addAll(loaded.take(_maxProcessedSendIds));
    } catch (_) {}
  }

  Future<void> _persistProcessedSendIds() async {
    await LocalCache.saveProcessedSendIds(List<String>.from(_processedSendIds));
  }

  void _markSendIdProcessed(String sendId) {
    if (sendId.isEmpty) return;
    if (_processedSendIds.contains(sendId)) return;
    _processedSendIds.add(sendId);
    // FIFO-Eviction.
    while (_processedSendIds.length > _maxProcessedSendIds) {
      _processedSendIds.removeAt(0);
    }
    unawaited(_persistProcessedSendIds());
  }

  // ── Persistenz: Android Outgoing-Queue ────────────────────────────────────

  Future<void> _loadPendingOutgoing() async {
    try {
      final raw = await LocalCache.loadPendingOutgoingSends();
      final now = DateTime.now();
      final fresh = raw
          .map(PendingOutgoingSend.fromJson)
          .where((s) => now.difference(s.queuedAt) < _outgoingTtl)
          .toList();
      _pendingOutgoing
        ..clear()
        ..addAll(fresh);
      if (fresh.length != raw.length) {
        await _persistPendingOutgoing();
      }
    } catch (_) {}
  }

  Future<void> _persistPendingOutgoing() async {
    await LocalCache.savePendingOutgoingSends(
        _pendingOutgoing.map((s) => s.toJson()).toList());
  }

  // ── Startup ───────────────────────────────────────────────────────────────

  Future<void> _resolveDeviceName() async {
    try {
      final info = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await info.androidInfo;
        _deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        final iosInfo = await info.iosInfo;
        _deviceName = iosInfo.name;
      } else if (Platform.isWindows) {
        // Windows: Computername (z. B. „Küchen-PC") statt „Device".
        final win = await info.windowsInfo;
        _deviceName = win.computerName.isNotEmpty
            ? win.computerName
            : Platform.localHostname;
      } else if (Platform.isMacOS) {
        // macOS: Computername aus den Systemeinstellungen (z. B. „Küchen-Mac").
        final mac = await info.macOsInfo;
        _deviceName = mac.computerName.isNotEmpty
            ? mac.computerName
            : Platform.localHostname;
      }
    } catch (_) {}
  }

  /// mDNS-Setup als eigene async-Funktion — wird aus build() per
  /// unawaited() gestartet damit die Sheet sofort iCloud-Peers anzeigen
  /// kann, auch wenn Bonsoir wegen Local-Network-Permission-Denied oder
  /// einem Router-Bug hängt.
  Future<void> _startMDns() async {
    // Jeder Schritt EIGENES try/catch: schlägt z.B. das Advertising fehl
    // (Local-Network-Prompt noch offen / Router-Bug), sollen TCP-Server UND
    // Discovery trotzdem laufen. Vorher kippte ein Fehler den ganzen Block →
    // Empfänger lauschte nicht. Logs landen im In-App-Viewer (Einstellungen ▸ Logs).
    try {
      // IPv4 + IPv6 (siehe bindDualStack) — Android 14+ löst Peers oft
      // per IPv6 auf.
      _server = await bindDualStack(_servicePort);
      _server!.listen(_onIncomingConnection);
      LogManager.shared.log('📥 SendTo: TCP-Server lauscht auf :$_servicePort');
    } catch (e) {
      LogManager.shared.log('❌ SendTo: TCP-Server bind fehlgeschlagen: $e');
    }

    try {
      final service = BonsoirService(
        name: _deviceName,
        type: _serviceType,
        port: _servicePort,
        attributes: {_txtDeviceIdKey: _deviceId},
      );
      _broadcast = BonsoirBroadcast(service: service);
      await _broadcast!.ready;
      await _broadcast!.start();
      LogManager.shared
          .log('📡 SendTo: Advertising „$_deviceName" ($_serviceType)');
    } catch (e) {
      LogManager.shared.log('❌ SendTo: Advertising fehlgeschlagen: $e');
    }

    try {
      _discovery = BonsoirDiscovery(type: _serviceType);
      await _discovery!.ready;
      await _discovery!.start();
      _discoverySub = _discovery!.eventStream!
          .listen(_onDiscoveryEvent, onError: _onMDnsError);
      LogManager.shared.log('🔎 SendTo: Discovery gestartet');
    } catch (e) {
      LogManager.shared.log('❌ SendTo: Discovery fehlgeschlagen: $e');
    }
  }

  /// Bonsoir meldet native Fehler als Fehler-Event im `eventStream`. Ohne
  /// Handler landete das als unbehandelter Zone-Fehler im Log, und die
  /// Gerätesuche blieb bis zum nächsten App-Start tot. Typisch unter iOS nach
  /// dem Standby: `-65569 DefunctConnection`, die Verbindung zum
  /// mDNS-Dienst des Systems ist abgerissen. Das trifft Suche UND Werbung,
  /// daher werden beide neu gestartet, und zwar nur im Vordergrund
  /// (im Hintergrund würde der Neustart sofort wieder scheitern).
  void _onMDnsError(Object error) {
    LogManager.shared.log('⚠️ SendTo: mDNS-Fehler: $error');
    if (_discovery == null) return; // Service bereits abgebaut
    final foreground =
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    final last = _lastMDnsRestart;
    // Höchstens ein Neustart pro 30 s, sonst droht bei dauerhaft kaputtem
    // mDNS eine Endlosschleife aus Fehler → Neustart → Fehler.
    final tooSoon = last != null &&
        DateTime.now().difference(last) < const Duration(seconds: 30);
    if (foreground && !tooSoon) {
      unawaited(_restartMDns());
      return;
    }
    if (_mdnsRestartObserver != null) return; // wartet schon
    _mdnsRestartObserver = _AppResumeObserver(
      onResume: () {
        _removeMDnsRestartObserver();
        unawaited(_restartMDns());
      },
      onBackground: () {},
    );
    WidgetsBinding.instance.addObserver(_mdnsRestartObserver!);
  }

  void _removeMDnsRestartObserver() {
    final o = _mdnsRestartObserver;
    if (o == null) return;
    WidgetsBinding.instance.removeObserver(o);
    _mdnsRestartObserver = null;
  }

  Future<void> _restartMDns() async {
    if (_restartingMDns || _discovery == null) return;
    _restartingMDns = true;
    _lastMDnsRestart = DateTime.now();
    try {
      await _discoverySub?.cancel();
      _discoverySub = null;
      try {
        await _broadcast?.stop();
      } catch (_) {}
      try {
        await _discovery?.stop();
      } catch (_) {}
      if (_discovery == null) return; // zwischenzeitlich abgebaut (_cleanup)

      final broadcast = BonsoirBroadcast(
        service: BonsoirService(
          name: _deviceName,
          type: _serviceType,
          port: _servicePort,
          attributes: {_txtDeviceIdKey: _deviceId},
        ),
      );
      final discovery = BonsoirDiscovery(type: _serviceType);
      _broadcast = broadcast;
      _discovery = discovery;
      await broadcast.ready;
      await broadcast.start();
      await discovery.ready;
      // Während der awaits abgebaut? Dann die frischen Instanzen gleich
      // wieder stoppen statt sie zu verwaisen.
      if (!identical(_discovery, discovery)) {
        await broadcast.stop();
        await discovery.stop();
        return;
      }
      _discoverySub = discovery.eventStream!
          .listen(_onDiscoveryEvent, onError: _onMDnsError);
      await discovery.start();
      LogManager.shared.log('🔎 SendTo: mDNS nach Fehler neu gestartet');
    } catch (e) {
      LogManager.shared.log('❌ SendTo: mDNS-Neustart fehlgeschlagen: $e');
    } finally {
      _restartingMDns = false;
    }
  }

  // ── CloudKit (iOS) ────────────────────────────────────────────────────────

  /// Init der CloudKit-Bridge + initialer Peer-Pull. Liefert die aktuell
  /// in der iCloud KV-Store-Registry eingetragenen Geräte (ohne sich
  /// selbst). Subscription für CK-Pushes wird gleichzeitig registriert,
  /// EventChannel-Listener angeschlossen.
  Future<List<RecipePeer>> _initCloudKitAndSeed() async {
    try {
      await _ckMethodChannel.invokeMethod('init', {
        'deviceId': _deviceId,
        'deviceName': _deviceName,
      });
      _ckEventSub = _ckEventChannel
          .receiveBroadcastStream()
          .listen(_onCloudKitEvent, onError: (_) {});
      // checkOnLaunch fetched offline-empfangene Recipes nach (App war zu).
      unawaited(
          _ckMethodChannel.invokeMethod('checkOnLaunch').catchError((_) {}));
      // Sync-fetch der Apple-Peers aus dem KV-Store. Auf einem frisch
      // installierten Gerät liefert das die andere Apple-Geräte instant.
      final raw =
          await _ckMethodChannel.invokeMethod<List<dynamic>>('fetchApplePeers');
      return _parseApplePeers(raw);
    } catch (_) {
      // CloudKit nicht verfügbar (Sim ohne iCloud-Login, Entitlement
      // fehlt, etc.) — App läuft auf TCP-only-Pfad weiter.
      return const [];
    }
  }

  List<RecipePeer> _parseApplePeers(List<dynamic>? raw) {
    if (raw == null) return const [];
    return raw
        .whereType<Map>()
        .map((m) => m.cast<String, dynamic>())
        .where((m) =>
            (m['deviceId'] as String? ?? '').isNotEmpty &&
            (m['deviceId'] as String) != _deviceId)
        .map((m) => RecipePeer(
              deviceId: m['deviceId'] as String,
              name: m['name'] as String? ?? '',
              host: '', // iCloud-only: keine LAN-Adresse
              port: 0,
            ))
        .toList();
  }

  // ── Peer-Merge ────────────────────────────────────────────────────────────
  // mDNS-Peers gewinnen gegenüber iCloud-Peers gleicher deviceId —
  // wenn das Gerät im selben WLAN ist, soll Send über LAN-TCP gehen
  // (sofortig, kein Apple-Server-Roundtrip).

  List<RecipePeer> _mergedPeers() {
    final merged = <String, RecipePeer>{};
    // Reihenfolge = Priorität (spätere gewinnen): Postfach < CloudKit < LAN.
    for (final p in _mailboxPeers) {
      merged[p.deviceId] = p;
    }
    for (final p in _applePeers) {
      merged[p.deviceId] = p;
    }
    for (final p in _mDnsPeers) {
      merged[p.deviceId] = p;
    }
    // Zusätzlich nach Anzeigenamen entdoppeln: DASSELBE Gerät kann via CloudKit
    // (Apple-Peer, ohne Host) UND mDNS (mit Host) mit UNTERSCHIEDLICHEN
    // deviceIds auftauchen → sonst doppelt in der Liste. Pro Name den besten
    // Eintrag behalten: einen mit echtem Host/Port (direkt per TCP sendbar)
    // bevorzugen.
    final byName = <String, RecipePeer>{};
    for (final p in merged.values) {
      final key = p.name.trim().toLowerCase();
      if (key.isEmpty) {
        byName[p.deviceId] = p; // namenlos: nicht zusammenfassen
        continue;
      }
      final existing = byName[key];
      // Direkt sendbar (LAN) > CloudKit > nur aus dem Postfach bekannt.
      int rank(RecipePeer x) => x.host.isNotEmpty && x.port > 0
          ? 2
          : x.remembered
              ? 0
              : 1;
      if (existing == null || rank(p) > rank(existing)) byName[key] = p;
    }
    return byName.values.toList();
  }

  void _publishMergedPeers() {
    state = AsyncData(_mergedPeers());
  }

  /// Wird vom Swift-CloudKitBridge gefeuert. Zwei Event-Typen:
  ///   • {type: "applePeers", peers: [{deviceId, name}, …]}
  ///     → iCloud KV-Store-Registry hat sich geändert (anderes Gerät kam
  ///       dazu oder verschwand). _applePeers neu seeden + merged-State.
  ///   • {type: "recipe", sendId, recipeId, recipeName, senderName,
  ///                       senderDeviceId}
  ///     → Silent-Push hat ein Recipe für uns geliefert. Volles Rezept
  ///       wird aus Mealie nachgeladen (1:1 zu Swift).
  Future<void> _onCloudKitEvent(dynamic event) async {
    if (event is! Map) return;
    final map = event.cast<String, dynamic>();
    final type = map['type'] as String? ?? 'recipe';
    LogManager.shared.log('☁️ SendTo: CloudKit-Event „$type"');

    if (type == 'applePeers') {
      final raw = map['peers'];
      _applePeers
        ..clear()
        ..addAll(_parseApplePeers(raw is List ? raw : null));
      _publishMergedPeers();
      return;
    }

    // Default: recipe-delivery
    final sendId = map['sendId'] as String? ?? '';
    final recipeId = map['recipeId'] as String?;
    final senderName = map['senderName'] as String? ?? '';
    if (recipeId == null || recipeId.isEmpty) return;
    if (sendId.isNotEmpty && _processedSendIds.contains(sendId)) return;

    try {
      final api = ref.read(apiServiceProvider);
      final detail = await api.fetchRecipeDetail(recipeId);
      if (sendId.isNotEmpty) _markSendIdProcessed(sendId);
      ref.read(pendingRecipesProvider.notifier).add(
            PendingRecipe(
              sendId: sendId.isEmpty ? _newUuidV4() : sendId,
              senderName: senderName,
              recipe: detail,
            ),
          );
      LogManager.shared.log(
          '✅ SendTo: Rezept „${detail.name}" via CloudKit empfangen → Sheet');
    } catch (e) {
      LogManager.shared
          .log('❌ SendTo: CloudKit-Rezept-Fetch fehlgeschlagen: $e');
      // Fetch fehlgeschlagen (offline, Recipe gelöscht, ...) — CKRecord
      // bleibt liegen, nächster Launch versucht's wieder.
    }
  }

  // ── mDNS Discovery + Retry-Trigger ────────────────────────────────────────

  void _onDiscoveryEvent(BonsoirDiscoveryEvent event) {
    // Nach _cleanup() (Rebuild bei Settings-Change) kann noch ein spätes
    // Event eintreffen — _discovery ist dann null und `_discovery!` würfe
    // eine unhandled Exception.
    final discovery = _discovery;
    if (discovery == null) return;
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
      event.service?.resolve(discovery.serviceResolver);
      return;
    }
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
      final svc = event.service as ResolvedBonsoirService;
      // TXT-Keys sind laut DNS-SD case-insensitiv, aber bonsoir liefert sie je
      // nach Plattform unterschiedlich (iOS NetService vs Android/iPad
      // NsdManager). Exakt nach 'mealieDeviceId' zu suchen lässt iOS↔Android-
      // Peers durchs Raster fallen → case-insensitiv lesen.
      final remoteId = _txtAttr(svc.attributes, _txtDeviceIdKey);
      // Selbst-Filter: per deviceId wenn vorhanden, sonst best-effort per Name.
      if (remoteId != null && remoteId.isNotEmpty) {
        if (remoteId == _deviceId) return;
      } else if (svc.name == _deviceName) {
        return;
      }
      final host = svc.host;
      if (host == null || host.isEmpty) {
        LogManager.shared
            .log('🔎 SendTo: Peer ohne Host verworfen (${svc.name})');
        return;
      }
      // Identität: deviceId bevorzugt; fehlt das TXT-Attribut (cross-platform),
      // stabil über den Namen identifizieren — so erscheint der Peer trotzdem
      // ZUVERLÄSSIG in der Liste statt verworfen zu werden.
      final identity = (remoteId != null && remoteId.isNotEmpty)
          ? remoteId
          : 'name:${svc.name}';
      final peer = RecipePeer(
        deviceId: identity,
        name: svc.name,
        host: host,
        port: svc.port,
      );
      LogManager.shared.log(
          '🔎 SendTo: Peer „${svc.name}" @ $host:${svc.port} (id=$identity)');
      final idx = _mDnsPeers.indexWhere((p) => p.deviceId == peer.deviceId);
      if (idx == -1) {
        _mDnsPeers.add(peer);
      } else {
        _mDnsPeers[idx] = peer;
      }
      _publishMergedPeers();
      // Auto-Retry für Android-Outgoing-Queue: jeder Resolve dieses
      // Peers ist eine neue Lieferchance, auch wenn der Peer schon in
      // state war.
      unawaited(_retryOutgoingForPeer(peer));
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
      final svc = event.service;
      if (svc == null) return;
      final lostId = svc is ResolvedBonsoirService
          ? _txtAttr(svc.attributes, _txtDeviceIdKey)
          : null;
      if (lostId != null && lostId.isNotEmpty) {
        _mDnsPeers.removeWhere((p) => p.deviceId == lostId);
      } else {
        // Name-basierte Identität (Fallback oben) wieder entfernen.
        _mDnsPeers.removeWhere(
            (p) => p.name == svc.name || p.deviceId == 'name:${svc.name}');
      }
      _publishMergedPeers();
    }
  }

  /// Liest ein TXT-Attribut case-insensitiv (DNS-SD-Keys sind laut Spec
  /// case-insensitiv, bonsoir normalisiert sie aber plattformabhängig).
  String? _txtAttr(Map<String, String> attrs, String key) {
    final lower = key.toLowerCase();
    for (final e in attrs.entries) {
      if (e.key.toLowerCase() == lower) return e.value;
    }
    return null;
  }

  Future<void> _retryOutgoingForPeer(RecipePeer peer) async {
    final forPeer = _pendingOutgoing
        .where((s) => s.targetDeviceId == peer.deviceId)
        .toList();
    if (forPeer.isEmpty) return;
    bool changed = false;
    for (final pending in forPeer) {
      try {
        await _sendOverTcp(
          host: peer.host,
          port: peer.port,
          sendId: pending.sendId,
          recipeJson: pending.recipeJson,
        );
        _pendingOutgoing.removeWhere((s) => s.sendId == pending.sendId);
        changed = true;
      } catch (_) {
        // Bleibt in der Queue, beim nächsten Resolve wieder versuchen.
      }
    }
    if (changed) await _persistPendingOutgoing();
  }

  // ── UUID v4 (kein neues Paket) ────────────────────────────────────────────

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

  // ── Receive (TCP) ─────────────────────────────────────────────────────────

  void _onIncomingConnection(Socket socket) {
    LogManager.shared.log(
        '📥 SendTo: eingehende Verbindung von ${socket.remoteAddress.address}');
    final buffer = StringBuffer();
    late final StreamSubscription<String> sub;
    sub = socket.cast<List<int>>().transform(utf8.decoder).listen((data) {
      buffer.write(data);
      // Jedes Gerät im WLAN kann hierher senden — ohne Obergrenze ließe
      // sich der Speicher fluten. Ein Rezept (nur JSON, ohne Bild) bleibt
      // weit darunter.
      if (buffer.length > _maxReceiveChars) {
        LogManager.shared.log('⚠️ SendTo: Empfang zu groß — abgebrochen');
        sub.cancel();
        socket.destroy();
      }
    }, onDone: () {
      try {
        final json = jsonDecode(buffer.toString()) as Map<String, dynamic>;
        // sendId fehlt bei pre-v3-Wire-Format → lokale UUID, kein Dedupe.
        final sendId = (json['sendId'] as String?) ?? '';
        if (sendId.isNotEmpty && _processedSendIds.contains(sendId)) {
          LogManager.shared
              .log('📥 SendTo: Duplikat (sendId schon verarbeitet) ignoriert');
          socket.destroy();
          return;
        }
        final senderName = json['senderName'] as String? ?? 'Unknown';
        final recipeJson = json['recipe'] as Map<String, dynamic>;
        final recipe = RecipeDetail.fromJson(recipeJson);
        if (sendId.isNotEmpty) _markSendIdProcessed(sendId);
        ref.read(pendingRecipesProvider.notifier).add(
              PendingRecipe(
                sendId: sendId.isEmpty ? _newUuidV4() : sendId,
                senderName: senderName,
                recipe: recipe,
              ),
            );
        LogManager.shared.log(
            '✅ SendTo: Rezept „${recipe.name}" von „$senderName" empfangen → Sheet');
      } catch (e) {
        LogManager.shared.log('❌ SendTo: Empfang-Parse fehlgeschlagen: $e');
      }
      socket.destroy();
    }, onError: (e) {
      // Abbruch während der Übertragung (Sender gekillt, WLAN weg) kommt als
      // Stream-ERROR an — ohne Handler flöge er als unhandled Exception hoch.
      LogManager.shared.log('❌ SendTo: Empfang abgebrochen: $e');
      socket.destroy();
    });
  }

  // ── Send ──────────────────────────────────────────────────────────────────

  Future<SendOutcome> sendRecipe({
    required RecipePeer peer,
    required RecipeDetail recipe,
  }) async {
    final sendId = _newUuidV4();
    final recipeJson = recipe.toJson();

    // TCP-Ziel bestimmen: getippter Peer-Host, sonst per deviceId/Name aus den
    // mDNS-Peers (falls die UI-Auswahl ein CloudKit-Eintrag ohne Host war).
    var tcpHost = peer.host;
    var tcpPort = peer.port;
    if (tcpHost.isEmpty) {
      for (final p in _mDnsPeers) {
        if (p.host.isEmpty) continue;
        if (p.deviceId == peer.deviceId ||
            p.name.trim().toLowerCase() == peer.name.trim().toLowerCase()) {
          tcpHost = p.host;
          tcpPort = p.port;
          break;
        }
      }
    }

    // Ist das Ziel ein Apple-Gerät mit DERSELBEN Apple ID? Nur solche stehen in
    // der iCloud-KV-Registry (_applePeers) — der KV-Store ist pro Apple-ID. Ein
    // CKRecord an ein fremdes/Android-Gerät würde nie abgeholt, deshalb ist
    // CloudKit ausschließlich für diese Geräte sinnvoll. Match per deviceId,
    // ersatzweise per Anzeigename (CloudKit- und mDNS-Eintrag desselben Geräts
    // können unterschiedliche deviceIds tragen). deviceId-Treffer hat Vorrang.
    final peerName = peer.name.trim().toLowerCase();
    String? appleMatchId;
    if (Platform.isIOS) {
      for (final p in _applePeers) {
        if (p.deviceId == peer.deviceId ||
            (peerName.isNotEmpty && p.name.trim().toLowerCase() == peerName)) {
          appleMatchId = p.deviceId;
          if (p.deviceId == peer.deviceId) break; // exakter Treffer gewinnt
        }
      }
    }
    final isSameAppleIdPeer = appleMatchId != null;

    // 1) Apple-Gerät mit GLEICHER Apple ID → direkt CloudKit, KEIN TCP-Versuch.
    //    Zuverlässig auch bei gesperrtem/geschlossenem Ziel (CKRecord + sichtbare
    //    Notification, Tippen öffnet die App → Sheet). Bewusst Apple-Server-Weg
    //    statt LAN-TCP — auf Wunsch deterministisch über CloudKit.
    if (isSameAppleIdPeer) {
      LogManager.shared
          .log('📤 SendTo: „${peer.name}" (gleiche Apple ID) → CloudKit');
      unawaited(_pushViaCloudKit(
        sendId: sendId,
        recipeId: recipe.id,
        recipeName: recipe.name,
        targetDeviceId: appleMatchId,
      ));
      return SendOutcome.delivered;
    }

    // 2) Sonst (Android-/Fremd-Apple-ID-Gerät) → lokaler TCP-Pfad.
    if (tcpHost.isNotEmpty) {
      try {
        LogManager.shared.log(
            '📤 SendTo: sende „${recipe.name}" via TCP an $tcpHost:$tcpPort („${peer.name}")');
        await _sendOverTcp(
          host: tcpHost,
          port: tcpPort,
          sendId: sendId,
          recipeJson: recipeJson,
        );
        LogManager.shared.log('✅ SendTo: TCP-Zustellung an „${peer.name}" ok');
        return SendOutcome.delivered;
      } catch (e) {
        LogManager.shared.log(
            '❌ SendTo: TCP an „${peer.name}" fehlgeschlagen → Fallback: $e');
        // weiter unten
      }
    }

    // 3) Kein lokaler Host ODER TCP fehlgeschlagen → Mealie-Postfach: kommt
    //    an, sobald das Zielgerät die App öffnet.
    try {
      await _sendViaMailbox(
        sendId: sendId,
        targetDeviceId: peer.deviceId,
        targetName: peer.name,
        recipeId: recipe.id,
        recipeName: recipe.name,
      );
      LogManager.shared
          .log('📨 SendTo: „${recipe.name}" für „${peer.name}" ins Postfach');
      // Im WLAN gesehenes Gerät: zusätzlich für die direkte Nachlieferung
      // merken — gehört es zu einem anderen Mealie-Haushalt, erreicht es
      // das Postfach nie.
      if (!peer.remembered && peer.host.isNotEmpty) {
        await _enqueueOutgoing(peer, sendId, recipeJson, mailboxed: true);
      }
      return SendOutcome.mailbox;
    } catch (e) {
      LogManager.shared.log('❌ SendTo: Postfach nicht erreichbar: $e');
    }

    // 4) Auch der Server ist nicht erreichbar (offline) → merken und beim
    //    nächsten Postfach-Abgleich bzw. mDNS-Fund automatisch nachholen.
    //    Vorhandene Einträge für dasselbe (Ziel, Rezept) ersetzen.
    LogManager.shared
        .log('📤 SendTo: „${peer.name}" nicht erreichbar → in Queue (Retry)');
    await _enqueueOutgoing(peer, sendId, recipeJson);
    return SendOutcome.queued;
  }

  Future<void> _enqueueOutgoing(
      RecipePeer peer, String sendId, Map<String, dynamic> recipeJson,
      {bool mailboxed = false}) async {
    // Vorhandene Einträge für dasselbe (Ziel, Rezept) ersetzen.
    _pendingOutgoing.removeWhere((s) =>
        s.targetDeviceId == peer.deviceId &&
        (s.recipeJson['id'] as String?) == (recipeJson['id'] as String?));
    _pendingOutgoing.add(PendingOutgoingSend(
      sendId: sendId,
      targetDeviceId: peer.deviceId,
      targetName: peer.name,
      recipeJson: recipeJson,
      queuedAt: DateTime.now(),
      mailboxed: mailboxed,
    ));
    await _persistPendingOutgoing();
  }

  Future<void> _sendViaMailbox({
    required String sendId,
    required String targetDeviceId,
    required String targetName,
    required String recipeId,
    required String recipeName,
  }) async {
    final mailbox = _mailbox;
    if (mailbox == null) throw StateError('Postfach nicht initialisiert');
    await mailbox.send(
      sendId: sendId,
      targetDeviceId: targetDeviceId,
      targetName: targetName,
      recipeId: recipeId,
      recipeName: recipeName,
    );
  }

  // ── Mealie-Postfach: Abholen + Nachliefern ────────────────────────────────

  void _startMailboxPoll() {
    if (_mailboxPoll != null) return;
    _mailboxPoll = Timer.periodic(
        const Duration(minutes: 1), (_) => unawaited(_syncMailbox()));
  }

  void _stopMailboxPoll() {
    _mailboxPoll?.cancel();
    _mailboxPoll = null;
  }

  Future<void> _syncMailbox() async {
    final mailbox = _mailbox;
    if (mailbox == null || _mailboxSyncing) return;
    _mailboxSyncing = true;
    try {
      final snap = await mailbox.sync();
      // Neueste zuerst: bei gleichem Namen behält der Namens-Abgleich in
      // _mergedPeers den ersten — also das zuletzt aktive Gerät.
      final devices = List.of(snap.devices)
        ..sort((a, b) => b.seen.compareTo(a.seen));
      _mailboxPeers
        ..clear()
        ..addAll(devices.map((d) => RecipePeer(
              deviceId: d.id,
              name: d.name,
              host: '',
              port: 0,
              remembered: true,
            )));
      if (identical(_mailbox, mailbox)) _publishMergedPeers();

      for (final d in snap.deliveries) {
        if (d.sendId.isNotEmpty && _processedSendIds.contains(d.sendId)) {
          await mailbox.remove(d.itemId); // schon per LAN/CloudKit da
          continue;
        }
        try {
          final detail =
              await ref.read(apiServiceProvider).fetchRecipeDetail(d.recipeId);
          if (d.sendId.isNotEmpty) _markSendIdProcessed(d.sendId);
          ref.read(pendingRecipesProvider.notifier).add(PendingRecipe(
                sendId: d.sendId.isEmpty ? _newUuidV4() : d.sendId,
                senderName: d.fromName,
                recipe: detail,
              ));
          await mailbox.remove(d.itemId);
          LogManager.shared.log(
              '✅ SendTo: Rezept „${detail.name}" aus dem Postfach empfangen');
        } catch (e) {
          // Rezept nicht ladbar (offline/gelöscht) — Eintrag bleibt liegen
          // und wird beim nächsten Abgleich erneut versucht bzw. verfällt.
          LogManager.shared.log(
              '❌ SendTo: Postfach-Rezept „${d.recipeName}" nicht ladbar: $e');
        }
      }

      // Offline gemerkte Sendungen jetzt (Server wieder erreichbar) ablegen.
      final toMailbox = _pendingOutgoing.where((p) => !p.mailboxed).toList();
      if (toMailbox.isNotEmpty) {
        for (final p in toMailbox) {
          final id = p.recipeJson['id'] as String? ?? '';
          if (id.isEmpty) continue;
          await _sendViaMailbox(
            sendId: p.sendId,
            targetDeviceId: p.targetDeviceId,
            targetName: p.targetName,
            recipeId: id,
            recipeName: p.recipeJson['name'] as String? ?? '',
          );
          // Bleibt für die direkte LAN-Nachlieferung gemerkt (s. oben).
          final i = _pendingOutgoing.indexWhere((x) => x.sendId == p.sendId);
          if (i != -1) {
            _pendingOutgoing[i] = PendingOutgoingSend(
              sendId: p.sendId,
              targetDeviceId: p.targetDeviceId,
              targetName: p.targetName,
              recipeJson: p.recipeJson,
              queuedAt: p.queuedAt,
              mailboxed: true,
            );
          }
          await _persistPendingOutgoing();
        }
      }
    } catch (e) {
      LogManager.shared.log('⚠️ SendTo: Postfach-Abgleich fehlgeschlagen: $e');
    } finally {
      _mailboxSyncing = false;
    }
  }

  Future<void> _sendOverTcp({
    required String host,
    required int port,
    required String sendId,
    required Map<String, dynamic> recipeJson,
  }) async {
    final socket =
        await Socket.connect(host, port, timeout: const Duration(seconds: 5));
    final payload = jsonEncode({
      'senderName': _deviceName,
      'senderDeviceId': _deviceId,
      'sendId': sendId,
      'recipe': recipeJson,
    });
    socket.write(payload);
    await socket.flush();
    await socket.close();
  }

  Future<void> _pushViaCloudKit({
    required String sendId,
    required String recipeId,
    required String recipeName,
    required String targetDeviceId,
  }) async {
    try {
      await _ckMethodChannel.invokeMethod('send', {
        'sendId': sendId,
        'recipeId': recipeId,
        'recipeName': recipeName,
        'targetDeviceId': targetDeviceId,
        'senderName': _deviceName,
        'senderDeviceId': _deviceId,
      });
      LogManager.shared
          .log('✅ SendTo: CloudKit-Record gespeichert → $targetDeviceId');
    } catch (e) {
      // Save fehlgeschlagen (Schema/Permission/Container) → ins Log, damit der
      // Grund sichtbar ist (TCP-Pfad ist ohnehin der Primary).
      LogManager.shared.log('❌ SendTo: CloudKit-Save fehlgeschlagen: $e');
    }
  }

  // iOS: Die CloudKit-Subscription ist ein reiner Silent-Push
  // (content-available) — den drosselt APNs systematisch, ein gesendetes Rezept
  // kann sonst ~30 s bis zur Zustellung brauchen. Solange die Empfänger-App im
  // VORDERGRUND ist, fragen wir CloudKit deshalb zusätzlich aktiv ab
  // (checkOnLaunch = CKQuery nach wartenden Records für dieses Gerät) → das
  // Rezept (und das Auto-Sheet) erscheint in wenigen Sekunden statt erst mit dem
  // gedrosselten Push. Im Hintergrund wird NICHT gepollt (Akku/CloudKit-Limits;
  // dort liefert der Push + checkOnLaunch beim Resume). Doppel-Verarbeitung
  // verhindert der _processedSendIds-Dedupe in _onCloudKitEvent.
  void _startCkForegroundPoll() {
    if (!Platform.isIOS) return;
    if (_ckForegroundPoll != null) return; // läuft schon
    _ckForegroundPoll = Timer.periodic(const Duration(seconds: 5), (_) {
      _ckMethodChannel.invokeMethod('checkOnLaunch').catchError((_) {});
    });
  }

  void _stopCkForegroundPoll() {
    _ckForegroundPoll?.cancel();
    _ckForegroundPoll = null;
  }

  // ── Cleanup ───────────────────────────────────────────────────────────────

  Future<void> _cleanup() async {
    await _discoverySub?.cancel();
    _discoverySub = null;
    await _broadcast?.stop();
    await _discovery?.stop();
    await _server?.close();
    await _ckEventSub?.cancel();
    _stopCkForegroundPoll();
    _stopMailboxPoll();
    if (_mailboxObserver != null) {
      WidgetsBinding.instance.removeObserver(_mailboxObserver!);
      _mailboxObserver = null;
    }
    _mailbox = null;
    if (_resumeObserver != null) {
      WidgetsBinding.instance.removeObserver(_resumeObserver!);
      _resumeObserver = null;
    }
    _removeMDnsRestartObserver();
    _broadcast = null;
    _discovery = null;
    _server = null;
    _ckEventSub = null;
  }
}

/// Ruft [onResume] bei jedem App-Vordergrund (resumed) und [onBackground] beim
/// Wechsel in den Hintergrund (paused/detached). Genutzt um nach dem Tippen auf
/// die CloudKit-Banner-Notification wartende SendTo-Rezepte nachzuziehen
/// (checkOnLaunch) und den Vordergrund-Poll an-/abzuschalten.
class _AppResumeObserver extends WidgetsBindingObserver {
  final VoidCallback onResume;
  final VoidCallback onBackground;
  _AppResumeObserver({required this.onResume, required this.onBackground});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      onBackground();
    }
  }
}
