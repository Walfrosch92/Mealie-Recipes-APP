import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/services/log_manager.dart';
import '../../cooking_mode/providers/cooking_session_provider.dart';
import '../../timer/providers/timer_provider.dart';

// Event-Trigger: wird inkrementiert wenn ein Guest die sessionEnded-Message
// vom Host empfängt. Screens (CookingMode, CookFriends) hören per ref.listen
// drauf und zeigen die Snackbar „Host hat Session beendet" plus poppen
// sich selbst aus dem Stack. Eine separate Provider statt eines Flags im
// CookFriendsState, weil der State ja nach sessionEnded gleichzeitig auf
// none-leer-zurücksetzt und ein boolean-Flag damit kollidieren würde.
final cookFriendsRemoteEndedTriggerProvider = StateProvider<int>((ref) => 0);

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const _serviceType = '_mealiecook._tcp';
const _servicePort = 54321;
const _codeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

/// Obergrenzen für eine empfangene Zeile (Zeichen): vom Gast nur kleine
/// Steuer-Nachrichten, vom Host der volle Zustand inkl. Bilder (base64).
const _maxGuestLineChars = 1024 * 1024;
const _maxHostLineChars = 60 * 1024 * 1024;

/// Host-Socket für IPv4 UND IPv6. Die Gerätesuche liefert dem Gast je nach
/// Plattform eine IPv6-Adresse (v. a. Android 14+ mit dem neuen mDNS-Stack)
/// — ein reiner IPv4-Server lehnte solche Gäste ab, unabhängig davon, ob der
/// Host ein iPhone oder ein Android-Gerät ist. Fallback: nur IPv4.
Future<ServerSocket> bindDualStack(int port) async {
  try {
    return await ServerSocket.bind(InternetAddress.anyIPv6, port,
        v6Only: false);
  } catch (e) {
    LogManager.shared.log('⚠️ Dual-Stack-Bind auf :$port nicht möglich ($e) '
        '→ nur IPv4');
    return ServerSocket.bind(InternetAddress.anyIPv4, port);
  }
}

/// Dienstname „Mealie-ABC123" — bei einem Namenskonflikt im WLAN hängen iOS
/// und Android unterschiedlich ein Suffix an („Mealie-ABC123 (2)"). Ein
/// `endsWith(code)` fand den Host dann nicht mehr.
bool _matchesCode(String serviceName, String code) =>
    code.isNotEmpty && serviceName.toUpperCase().contains('MEALIE-$code');

// ---------------------------------------------------------------------------
// Shared recipe state (per-recipe slice of a multi-recipe SharedSessionState).
// Host pusht eine Liste davon, Client materialisiert für jedes Item eine
// lokale CookingSession und kann frei zwischen ihnen navigieren.
// ---------------------------------------------------------------------------

class SharedRecipe {
  final String recipeId;
  final String recipeName;

  /// Full RecipeDetail JSON — Guest braucht das um das Recipe ohne API-Call
  /// zu rendern (Guest kann auch ohne eigenen Mealie-Server beitreten).
  final Map<String, dynamic>? recipeJson;
  final List<bool> completedIngredients;
  final List<bool> completedInstructions;
  final double quantityMultiplier;

  /// Base64-kodierte Original-Bildbytes (webp), vom Host mitgesendet. Nötig,
  /// damit ein Gast OHNE eigenen Server (Gastmodus) das Bild anzeigen kann —
  /// er kann es sonst nicht laden (keine Server-URL/kein Token). Optional &
  /// rückwärtskompatibel: alte Hosts senden es nicht, alte Gäste ignorieren es.
  final String? imageBase64;

  const SharedRecipe({
    required this.recipeId,
    required this.recipeName,
    this.recipeJson,
    this.completedIngredients = const [],
    this.completedInstructions = const [],
    this.quantityMultiplier = 1.0,
    this.imageBase64,
  });

  Map<String, dynamic> toJson() => {
        'recipeId': recipeId,
        'recipeName': recipeName,
        if (recipeJson != null) 'recipeJson': recipeJson,
        'completedIngredients': completedIngredients,
        'completedInstructions': completedInstructions,
        'quantityMultiplier': quantityMultiplier,
        if (imageBase64 != null && imageBase64!.isNotEmpty)
          'imageBase64': imageBase64,
      };

  factory SharedRecipe.fromJson(Map<String, dynamic> j) => SharedRecipe(
        recipeId: j['recipeId'] as String? ?? j['recipeSlug'] as String? ?? '',
        recipeName: j['recipeName'] as String? ?? '',
        recipeJson: j['recipeJson'] is Map
            ? Map<String, dynamic>.from(j['recipeJson'] as Map)
            : null,
        completedIngredients:
            (j['completedIngredients'] as List? ?? []).cast<bool>(),
        completedInstructions:
            (j['completedInstructions'] as List? ?? []).cast<bool>(),
        quantityMultiplier:
            (j['quantityMultiplier'] as num?)?.toDouble() ?? 1.0,
        imageBase64: j['imageBase64'] as String?,
      );

  SharedRecipe copyWith({
    List<bool>? completedIngredients,
    List<bool>? completedInstructions,
    double? quantityMultiplier,
    String? imageBase64,
  }) {
    return SharedRecipe(
      recipeId: recipeId,
      recipeName: recipeName,
      recipeJson: recipeJson,
      completedIngredients: completedIngredients ?? this.completedIngredients,
      completedInstructions:
          completedInstructions ?? this.completedInstructions,
      quantityMultiplier: quantityMultiplier ?? this.quantityMultiplier,
      imageBase64: imageBase64 ?? this.imageBase64,
    );
  }
}

// ---------------------------------------------------------------------------
// Shared session state (synced between host and guests).
//
// Neues Format ab Multi-Recipe-Sharing: `recipes` ist die kanonische Liste.
// Backward-Compat: das Wire-Format enthält weiterhin die Legacy-Single-Recipe-
// Felder (recipeSlug/recipeName/recipeJson/completedIngredients/...) — gespiegelt
// vom ERSTEN Eintrag der recipes-Liste. Damit verstehen sich:
//   • Alte Swift-Hosts (single-recipe) ↔ neue Flutter-Guests   (lesen Legacy)
//   • Neue Flutter-Hosts (multi-recipe) ↔ alte Swift-Guests    (sehen ersten)
//   • Neue Flutter-Hosts ↔ neue Flutter-Guests                 (volles Set)
// ---------------------------------------------------------------------------

class SharedSessionState {
  final List<SharedRecipe> recipes;

  /// Vom Host beim Erstellen der Session gesetzt: dürfen Gäste die geteilten
  /// Rezepte auf IHREM eigenen Mealie-Server speichern? Wird im Wire-Format
  /// mitgesendet, sodass der Client den „Auf meinem Server speichern"-Button
  /// nur zeigt, wenn der Host es erlaubt hat. Default false (konservativ:
  /// alte/Swift-Hosts ohne dieses Feld erlauben das Speichern NICHT).
  final bool allowGuestSave;

  const SharedSessionState(
      {this.recipes = const [], this.allowGuestSave = false});

  SharedRecipe? get firstRecipe => recipes.isEmpty ? null : recipes.first;

  SharedRecipe? findRecipe(String recipeId) {
    for (final r in recipes) {
      if (r.recipeId == recipeId) return r;
    }
    return null;
  }

  /// Convenience für Legacy-Code-Pfade, die nur ein Recipe annahmen.
  String? get recipeSlug => firstRecipe?.recipeId;
  String? get recipeName => firstRecipe?.recipeName;
  Map<String, dynamic>? get recipeJson => firstRecipe?.recipeJson;

  Map<String, dynamic> toJson() {
    final first = firstRecipe;
    return {
      'recipes': recipes.map((r) => r.toJson()).toList(),
      'allowGuestSave': allowGuestSave,
      // Legacy-Felder spiegeln das erste Rezept — alte Swift-Guests lesen
      // diese statt der `recipes`-Liste.
      if (first != null) ...{
        'recipeSlug': first.recipeId,
        'recipeName': first.recipeName,
        if (first.recipeJson != null) 'recipeJson': first.recipeJson,
        'completedIngredients': first.completedIngredients,
        'completedInstructions': first.completedInstructions,
        'quantityMultiplier': first.quantityMultiplier,
      },
    };
  }

  factory SharedSessionState.fromJson(Map<String, dynamic> j) {
    final allowGuestSave = j['allowGuestSave'] as bool? ?? false;
    // Neues Multi-Recipe-Format bevorzugen.
    final list = j['recipes'];
    if (list is List && list.isNotEmpty) {
      return SharedSessionState(
        allowGuestSave: allowGuestSave,
        recipes: list
            .whereType<Map>()
            .map((m) => SharedRecipe.fromJson(m.cast<String, dynamic>()))
            .where((r) => r.recipeId.isNotEmpty)
            .toList(),
      );
    }
    // Legacy-Fallback: Swift-Host mit single-recipe-Felder.
    final slug = j['recipeSlug'] as String?;
    if (slug == null || slug.isEmpty) {
      return SharedSessionState(allowGuestSave: allowGuestSave);
    }
    return SharedSessionState(
        allowGuestSave: allowGuestSave, recipes: [SharedRecipe.fromJson(j)]);
  }

  SharedSessionState copyWith(
          {List<SharedRecipe>? recipes, bool? allowGuestSave}) =>
      SharedSessionState(
        recipes: recipes ?? this.recipes,
        allowGuestSave: allowGuestSave ?? this.allowGuestSave,
      );
}

// ---------------------------------------------------------------------------
// Peer messages
// ---------------------------------------------------------------------------

enum PeerMessageType {
  fullStateSync,
  toggleIngredient,
  toggleInstruction,
  setMultiplier,
  // 1:1 zu Swifts SharedTimer-Protokoll. shareId ist eine cross-device UUID
  // damit Host und Guest dieselbe Timer-Instanz referenzieren können (lokale
  // RecipeTimer.id ist je Device individuell und nicht synchron).
  timerStarted,
  timerStopped,
  timerPaused,
  timerResumed,
  sessionEnded,
}

class PeerMessage {
  final PeerMessageType type;
  final Map<String, dynamic> payload;

  const PeerMessage({required this.type, required this.payload});

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'payload': payload,
      };

  factory PeerMessage.fromJson(Map<String, dynamic> j) => PeerMessage(
        type: PeerMessageType.values.firstWhere((e) => e.name == j['type'],
            orElse: () => PeerMessageType.fullStateSync),
        payload: (j['payload'] as Map<String, dynamic>?) ?? {},
      );

  static PeerMessage fullStateSync(SharedSessionState state) => PeerMessage(
        type: PeerMessageType.fullStateSync,
        payload: state.toJson(),
      );

  static PeerMessage toggleIngredient(
          {required String recipeId, required int index}) =>
      PeerMessage(
        type: PeerMessageType.toggleIngredient,
        payload: {'recipeId': recipeId, 'index': index},
      );

  static PeerMessage toggleInstruction(
          {required String recipeId, required int index}) =>
      PeerMessage(
        type: PeerMessageType.toggleInstruction,
        payload: {'recipeId': recipeId, 'index': index},
      );

  static PeerMessage setMultiplier(
          {required String recipeId, required double multiplier}) =>
      PeerMessage(
        type: PeerMessageType.setMultiplier,
        payload: {'recipeId': recipeId, 'multiplier': multiplier},
      );

  // Timer-Sharing — spiegelt Swifts case timerStarted(SharedTimer) /
  // timerStopped(UUID) / timerPaused(id, remainingSeconds) /
  // timerResumed(id, newEndTime). Wir senden die Dauer in Sekunden statt
  // Minuten weil Flutters TimerNotifier sowieso intern in Sekunden tickt
  // und so Brüche (z.B. 90 s) sauber übertragen werden.
  static PeerMessage timerStarted({
    required String shareId,
    required String name,
    required String recipeName,
    required int remainingSeconds,
  }) =>
      PeerMessage(
        type: PeerMessageType.timerStarted,
        payload: {
          'shareId': shareId,
          'name': name,
          'recipeName': recipeName,
          'remainingSeconds': remainingSeconds,
        },
      );

  static PeerMessage timerStopped(String shareId) => PeerMessage(
        type: PeerMessageType.timerStopped,
        payload: {'shareId': shareId},
      );

  static PeerMessage timerPaused({
    required String shareId,
    required int remainingSeconds,
  }) =>
      PeerMessage(
        type: PeerMessageType.timerPaused,
        payload: {'shareId': shareId, 'remainingSeconds': remainingSeconds},
      );

  static PeerMessage timerResumed({
    required String shareId,
    required int remainingSeconds,
  }) =>
      PeerMessage(
        type: PeerMessageType.timerResumed,
        payload: {'shareId': shareId, 'remainingSeconds': remainingSeconds},
      );

  static PeerMessage sessionEnded() => const PeerMessage(
        type: PeerMessageType.sessionEnded,
        payload: {},
      );
}

// ---------------------------------------------------------------------------
// Cook Friends state
// ---------------------------------------------------------------------------

enum CookFriendsRole { none, host, guest }

/// Localizable error codes — the UI maps these to translated strings so no
/// user-facing message is hardcoded in any single language.
enum CookFriendsErrorCode { hostNotFound, connectionFailed }

class CookFriendsState {
  final CookFriendsRole role;
  final String sessionCode;
  final int guestCount;
  final bool isConnected;
  final SharedSessionState? sharedState;
  final CookFriendsErrorCode? error;

  const CookFriendsState({
    this.role = CookFriendsRole.none,
    this.sessionCode = '',
    this.guestCount = 0,
    this.isConnected = false,
    this.sharedState,
    this.error,
  });

  CookFriendsState copyWith({
    CookFriendsRole? role,
    String? sessionCode,
    int? guestCount,
    bool? isConnected,
    SharedSessionState? sharedState,
    CookFriendsErrorCode? error,
  }) {
    return CookFriendsState(
      role: role ?? this.role,
      sessionCode: sessionCode ?? this.sessionCode,
      guestCount: guestCount ?? this.guestCount,
      isConnected: isConnected ?? this.isConnected,
      sharedState: sharedState ?? this.sharedState,
      error: error ?? this.error,
    );
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final cookFriendsProvider =
    NotifierProvider<CookFriendsNotifier, CookFriendsState>(
        CookFriendsNotifier.new);

class CookFriendsNotifier extends Notifier<CookFriendsState> {
  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;
  ServerSocket? _serverSocket;
  Socket? _guestSocket;
  final List<Socket> _guestSockets = [];

  /// Host-Einstellung (beim Erstellen der Session gesetzt): dürfen Gäste die
  /// geteilten Rezepte auf ihrem eigenen Server speichern? Fließt in jeden
  /// fullStateSync ein.
  bool _allowGuestSave = false;

  /// Host-Cache: Rezept-id → base64-kodierte Bildbytes (webp). Einmal pro
  /// Rezept vom eigenen Server geladen, damit jeder fullStateSync das Bild
  /// mitschicken kann (Gäste ohne Server zeigen es daraus an). Leerstring =
  /// „kein Bild / Fehlschlag" → kein erneuter Fetch.
  final Map<String, String> _imageB64Cache = {};

  /// Pro-Socket-Empfangspuffer für das Line-Framing in `_onDataReceived`.
  /// Hält die noch unvollständige (nicht durch '\n' abgeschlossene) letzte
  /// Zeile eines TCP-Chunks bis zum nächsten Chunk auf.
  final Map<Socket, String> _rxBuffers = {};

  /// Discovery-Event-Subscription (joinSession) — wird in _cleanup gecancelt,
  /// damit späte Events nicht auf eine bereits genullte _discovery zugreifen.
  StreamSubscription? _discoverySub;

  /// GAST: lokale Session-Keys (recipe.id), die aus dem shared-State
  /// materialisiert wurden. Nur diese darf der Sync-Cleanup bzw. sessionEnded
  /// wieder beenden — eigene, schon vor dem Join gestartete Kochsessions
  /// eines Gasts mit eigenem Server bleiben unangetastet.
  final Set<String> _guestMaterializedIds = {};

  /// GAST: shared recipeId → lokaler Session-Key. Bei Legacy-Swift-Hosts ist
  /// die shared recipeId der Mealie-SLUG, lokal keyen wir aber per recipe.id
  /// (aus dem recipeJson) — ohne das Mapping würde der Cleanup die gerade
  /// materialisierte Session sofort wieder beenden und Toggles/Multiplier
  /// fänden keine Session.
  final Map<String, String> _sharedToLocalId = {};

  @override
  CookFriendsState build() {
    ref.onDispose(_cleanup);
    // Host-Mode: jeder Change am lokalen cookingSessionsProvider (neues
    // Rezept via Add-Sheet, Recipe beendet, Tick, Multiplier) wird zum
    // Multi-Recipe-shared-State rebuilt und an alle Guests gepusht.
    ref.listen<List<CookingSession>>(cookingSessionsProvider, (prev, next) {
      _onLocalCookingSessionsChanged();
    });
    return const CookFriendsState();
  }

  // -------------------------------------------------------------------------
  // Host
  // -------------------------------------------------------------------------

  /// Startet eine Hosting-Session. Die VOLLE Liste der aktiven CookingSessions
  /// dient als Initial-Payload und wird an alle Guests gepusht. Spätere
  /// Änderungen (Add-Recipe, Tick, Multiplier) propagieren automatisch über
  /// den cookingSessionsProvider-Listener.
  Future<void> hostSession({bool allowGuestSave = false}) async {
    await _cleanup();
    _allowGuestSave = allowGuestSave;
    final code = _generateCode();

    try {
      _serverSocket = await bindDualStack(_servicePort);

      _serverSocket!.listen((socket) {
        _guestSockets.add(socket);
        state = state.copyWith(guestCount: _guestSockets.length);

        // Neuer Guest connected → fullStateSync mit der aktuellen Liste
        // der lokalen CookingSessions.
        final initial = _buildSharedStateFromLocalSessions();
        _sendToSocket(socket, PeerMessage.fullStateSync(initial));

        // Gemeinsamer Aufräumpfad für onDone UND onError: ein abrupter
        // Abbruch (App gekillt, WLAN weg) kommt oft als Stream-ERROR an,
        // nicht als onDone — ohne onError bliebe der tote Socket in
        // _guestSockets (guestCount falsch, Writes ins Leere) und der
        // Fehler flöge als unhandled Exception hoch.
        void dropGuest() {
          _guestSockets.remove(socket);
          _rxBuffers.remove(socket);
          state = state.copyWith(guestCount: _guestSockets.length);
        }

        socket.cast<List<int>>().transform(utf8.decoder).listen(
          (data) => _onDataReceived(data, socket, isHost: true),
          onDone: dropGuest,
          onError: (_) {
            socket.destroy();
            dropGuest();
          },
        );
      }, onError: (e) {
        LogManager.shared.log('⚠️ CookFriends ServerSocket-Fehler: $e');
      });

      // Bilder der aktiven Rezepte cachen, BEVOR der mDNS-Broadcast startet —
      // so bekommt schon der allererste Gast (der erst nach dem Broadcast
      // discovern kann) das Bild im initialen fullStateSync mit.
      await _cacheImagesForLocalSessions();

      // mDNS broadcast
      final service = BonsoirService(
        name: 'Mealie-$code',
        type: _serviceType,
        port: _servicePort,
      );
      _broadcast = BonsoirBroadcast(service: service);
      await _broadcast!.ready;
      await _broadcast!.start();

      final initial = _buildSharedStateFromLocalSessions();
      state = CookFriendsState(
        role: CookFriendsRole.host,
        sessionCode: code,
        isConnected: true,
        sharedState: initial,
      );
    } catch (_) {
      state =
          const CookFriendsState(error: CookFriendsErrorCode.connectionFailed);
    }
  }

  /// Baut den geteilten Multi-Recipe-State aus dem aktuellen lokalen
  /// cookingSessionsProvider — kanonische Quelle der Wahrheit auf der
  /// Host-Seite.
  SharedSessionState _buildSharedStateFromLocalSessions() {
    final sessions = ref.read(cookingSessionsProvider);
    return SharedSessionState(
      allowGuestSave: _allowGuestSave,
      recipes: sessions.map((s) {
        final b64 = _imageB64Cache[s.recipe.id];
        return SharedRecipe(
          recipeId: s.slug,
          recipeName: s.recipe.name,
          recipeJson: s.recipe.toJson(),
          completedIngredients: s.completedIngredients,
          completedInstructions: s.completedInstructions,
          quantityMultiplier: s.quantityMultiplier,
          imageBase64: (b64 != null && b64.isNotEmpty) ? b64 : null,
        );
      }).toList(),
    );
  }

  /// Lädt für alle Sessions, deren Bild noch nicht im Cache liegt, die
  /// Bildbytes vom eigenen Server und legt sie base64-kodiert ab. Fehlschläge
  /// / fehlende Bilder werden als Leerstring markiert (kein Re-Fetch). Gibt
  /// `true` zurück, wenn neue Bilder dazukamen (→ Rebroadcast lohnt sich).
  Future<bool> _cacheImagesForLocalSessions() async {
    final sessions = ref.read(cookingSessionsProvider);
    final api = ref.read(apiServiceProvider);
    var changed = false;
    for (final s in sessions) {
      final id = s.recipe.id;
      if (id.isEmpty || _imageB64Cache.containsKey(id)) continue;
      try {
        final bytes = await api.fetchRecipeImageBytes(id);
        _imageB64Cache[id] = bytes.isNotEmpty ? base64Encode(bytes) : '';
        if (bytes.isNotEmpty) changed = true;
      } catch (e) {
        _imageB64Cache[id] = ''; // nicht endlos neu versuchen
        LogManager.shared
            .log('⚠️ CookFriends Bild-Fetch fehlgeschlagen ($id): $e');
      }
    }
    return changed;
  }

  void _onLocalCookingSessionsChanged() {
    if (state.role != CookFriendsRole.host) return;
    if (!state.isConnected) return;
    // Sofort mit dem aktuellen Cache broadcasten (snappy), und falls neue
    // Rezepte dazukamen, deren Bilder nachladen und nochmal broadcasten.
    final rebuilt = _buildSharedStateFromLocalSessions();
    state = state.copyWith(sharedState: rebuilt);
    sendMessage(PeerMessage.fullStateSync(rebuilt));
    _cacheImagesForLocalSessions().then((changed) {
      if (!changed) return;
      if (state.role != CookFriendsRole.host || !state.isConnected) return;
      final withImages = _buildSharedStateFromLocalSessions();
      state = state.copyWith(sharedState: withImages);
      sendMessage(PeerMessage.fullStateSync(withImages));
    });
  }

  // -------------------------------------------------------------------------
  // Guest
  // -------------------------------------------------------------------------

  Future<void> joinSession(String code) async {
    await _cleanup();
    final upperCode = code.toUpperCase().trim();

    try {
      // Discover via mDNS. Lokale `discovery`-Referenz im Listener verwenden
      // (statt `_discovery!`): feuert ein spätes Event nach _cleanup() (das
      // _discovery nullt), würfe der Null-Check-Operator sonst eine unhandled
      // Exception.
      final discovery = BonsoirDiscovery(type: _serviceType);
      _discovery = discovery;
      await discovery.ready;

      final completer = Completer<String?>();
      String? hostIp;

      _discoverySub = discovery.eventStream!.listen((event) {
        final svc = event.service;
        if (svc == null) return;
        // bonsoir 5.x: a found service must be resolved before its host/IP is
        // known. Without this resolve step the resolved event never fires and
        // discovery times out (the cross-platform iOS↔Android symptom).
        if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
          if (_matchesCode(svc.name, upperCode)) {
            svc.resolve(discovery.serviceResolver);
          }
        } else if (event.type ==
            BonsoirDiscoveryEventType.discoveryServiceResolved) {
          if (svc is ResolvedBonsoirService &&
              _matchesCode(svc.name, upperCode)) {
            hostIp = svc.host;
            if (!completer.isCompleted) completer.complete(hostIp);
          }
        }
      }, onError: (Object e) {
        // Native Bonsoir-Fehler kommen als Stream-Error (z. B. iOS
        // `-65569 DefunctConnection`). Ohne Handler: unbehandelter
        // Zone-Fehler und 10 s Warten ins Leere. So: sofort „Host nicht
        // gefunden".
        LogManager.shared.log('⚠️ CookFriends: mDNS-Fehler: $e');
        if (!completer.isCompleted) completer.complete(null);
      });
      await discovery.start();

      // Wait up to 10 seconds for discovery (clean error instead of a raw
      // TimeoutException if the host can't be found on the local network).
      try {
        hostIp = await completer.future.timeout(const Duration(seconds: 10));
      } on TimeoutException {
        await _discovery!.stop();
        state =
            const CookFriendsState(error: CookFriendsErrorCode.hostNotFound);
        return;
      }
      await _discovery!.stop();

      if (hostIp == null) {
        state =
            const CookFriendsState(error: CookFriendsErrorCode.hostNotFound);
        return;
      }

      // Den aufgelösten Host loggen: ist das ein `.local`-Hostname oder eine
      // IPv6-(link-local-)Adresse, kann `Socket.connect` auf iOS scheitern —
      // dann sieht man hier genau, WAS bonsoir geliefert hat.
      LogManager.shared
          .log('🤝 CookFriends join → connect $hostIp:$_servicePort');
      _guestSocket = await Socket.connect(hostIp!, _servicePort,
          timeout: const Duration(seconds: 5));

      // WICHTIG: Gast-State VOR dem Anhängen des Daten-Listeners setzen. Der
      // Host schickt den initialen fullStateSync SOFORT nach dem Connect.
      // Käme er an, bevor role=guest gesetzt ist, würde der darauffolgende
      // state-Overwrite (`CookFriendsState(role: guest, …)`) die gerade
      // empfangene sharedState wieder verwerfen → der Gast bekäme nie einen
      // Slug und bliebe in der Lobby hängen. Erst Rolle setzen, dann lauschen:
      // ankommende Daten werden bis zum Listener-Attach gepuffert und danach
      // mit korrekt gesetztem role=guest verarbeitet (copyWith erhält die
      // Rolle).
      state = CookFriendsState(
        role: CookFriendsRole.guest,
        sessionCode: upperCode,
        isConnected: true,
      );

      // Host-Verbindung weg (Host hat beendet ODER App gekillt/Netzabbruch):
      // geteilte Timer beim Gast deaktivieren, sonst laufen sie ohne den
      // steuernden Host weiter und alarmieren am Ende fälschlich. Nur
      // geteilte Timer (shareId != null); eigene lokale bleiben. Bei einem
      // sauberen sessionEnded ist hier i. d. R. schon nichts mehr zu tun.
      // Ein abrupter Abbruch kommt oft als Stream-ERROR statt onDone an →
      // beide Pfade laufen über denselben Handler.
      void handleHostLost() {
        ref.read(timerProvider.notifier).stopShared();
        state = const CookFriendsState();
      }

      _guestSocket!.cast<List<int>>().transform(utf8.decoder).listen(
        (data) => _onDataReceived(data, _guestSocket!, isHost: false),
        onDone: handleHostLost,
        onError: (_) {
          _guestSocket?.destroy();
          handleHostLost();
        },
      );
    } catch (e) {
      LogManager.shared.log('❌ CookFriends join connect failed: $e');
      state =
          const CookFriendsState(error: CookFriendsErrorCode.connectionFailed);
    }
  }

  // -------------------------------------------------------------------------
  // Messaging
  // -------------------------------------------------------------------------

  void sendMessage(PeerMessage msg) {
    if (state.role == CookFriendsRole.host) {
      for (final s in _guestSockets) {
        _sendToSocket(s, msg);
      }
    } else if (state.role == CookFriendsRole.guest && _guestSocket != null) {
      _sendToSocket(_guestSocket!, msg);
    }
  }

  void _sendToSocket(Socket s, PeerMessage msg) {
    try {
      s.write('${jsonEncode(msg.toJson())}\n');
    } catch (_) {}
  }

  void _onDataReceived(String data, Socket source, {required bool isHost}) {
    // TCP ist ein Byte-Stream, kein Message-Stream: eine einzelne
    // newline-terminierte JSON-Nachricht kann über MEHRERE `data`-Chunks
    // verteilt ankommen (und umgekehrt mehrere Nachrichten in einem Chunk).
    // Das gilt besonders für den großen `fullStateSync` (volles recipeJson +
    // base64-Bild), der locker > MSS ist. Früher wurde jeder Chunk einzeln auf
    // '\n' gesplittet und geparst → eine über Chunk-Grenzen zerrissene Zeile
    // parste NIE (jsonDecode warf, still verschluckt) → der Gast bekam den
    // initialen fullStateSync nicht, blieb ohne sharedState und wurde nie in
    // den Kochmodus weitergeleitet. Daher: pro Socket puffern und nur komplette
    // (durch '\n' abgeschlossene) Zeilen verarbeiten; den Rest aufheben.
    var buffer = (_rxBuffers[source] ?? '') + data;
    int idx;
    while ((idx = buffer.indexOf('\n')) != -1) {
      final line = buffer.substring(0, idx);
      buffer = buffer.substring(idx + 1);
      if (line.trim().isEmpty) continue;
      try {
        final msg =
            PeerMessage.fromJson(jsonDecode(line) as Map<String, dynamic>);
        _applyMessage(msg, source: source, isHost: isHost);
      } catch (_) {}
    }
    // Obergrenze für eine unvollständige Zeile: Gäste schicken nur kleine
    // Steuer-Nachrichten (Haken, Timer), der Host große Zustände mit Bildern.
    // Ohne Grenze könnte ein Gerät im WLAN den Speicher fluten.
    final limit = isHost ? _maxGuestLineChars : _maxHostLineChars;
    if (buffer.length > limit) {
      LogManager.shared.log('⚠️ CookFriends: Nachricht zu groß — getrennt');
      _rxBuffers.remove(source);
      source.destroy();
      return;
    }
    _rxBuffers[source] = buffer;
  }

  void _applyMessage(PeerMessage msg,
      {required Socket source, required bool isHost}) {
    final current = state.sharedState;

    switch (msg.type) {
      case PeerMessageType.fullStateSync:
        final next = SharedSessionState.fromJson(msg.payload);
        state = state.copyWith(sharedState: next);
        // GUEST: ALLE Rezepte aus dem shared-State lokal materialisieren —
        // jede CookingSession startSession (idempotent). Per-Recipe-State
        // (Multiplier + ticked Ingredients/Instructions) auf die lokalen
        // Sessions anwenden. Recipes die NICHT mehr im shared-State sind
        // werden lokal beendet (Host hat sie geschlossen).
        if (!isHost) {
          final notifier = ref.read(cookingSessionsProvider.notifier);
          for (final shared in next.recipes) {
            if (shared.recipeJson == null) continue;
            try {
              final recipe = RecipeDetail.fromJson(shared.recipeJson!);
              // Lokal wird per recipe.id gekeyt; die shared recipeId kann bei
              // Legacy-Swift-Hosts der Mealie-SLUG sein → Mapping merken,
              // damit Cleanup/Toggles/Multiplier die Session wiederfinden.
              _sharedToLocalId[shared.recipeId] = recipe.id;
              _guestMaterializedIds.add(recipe.id);
              notifier.startSession(recipe);
              _applySharedRecipeToCookingSession(shared);
            } catch (_) {
              // malformed payload — andere Recipes nicht beeinträchtigen
            }
          }
          // Nicht mehr geteilte Rezepte beenden — aber NUR solche, die aus
          // dem shared-State materialisiert wurden. Eigene, vor dem Join
          // gestartete Kochsessions eines Gasts mit eigenem Server bleiben.
          final sharedLocalIds = next.recipes
              .map((r) => _sharedToLocalId[r.recipeId] ?? r.recipeId)
              .toSet();
          final localSessions = ref.read(cookingSessionsProvider);
          for (final s in localSessions) {
            if (_guestMaterializedIds.contains(s.slug) &&
                !sharedLocalIds.contains(s.slug)) {
              notifier.endSession(s.slug);
              _guestMaterializedIds.remove(s.slug);
            }
          }
        }
        break;

      case PeerMessageType.toggleIngredient:
        if (current == null) break;
        final i = msg.payload['index'] as int;
        final recipeId = _resolveRecipeId(msg, current);
        if (recipeId == null) break;
        final next = _applyToggleIngredient(current, recipeId, i);
        state = state.copyWith(sharedState: next);
        _propagateToggleToLocal(recipeId, i, ingredient: true);
        if (isHost) sendMessage(PeerMessage.fullStateSync(next));
        break;

      case PeerMessageType.toggleInstruction:
        if (current == null) break;
        final i = msg.payload['index'] as int;
        final recipeId = _resolveRecipeId(msg, current);
        if (recipeId == null) break;
        final next = _applyToggleInstruction(current, recipeId, i);
        state = state.copyWith(sharedState: next);
        _propagateToggleToLocal(recipeId, i, ingredient: false);
        if (isHost) sendMessage(PeerMessage.fullStateSync(next));
        break;

      case PeerMessageType.setMultiplier:
        if (current == null) break;
        final m = (msg.payload['multiplier'] as num).toDouble();
        final recipeId = _resolveRecipeId(msg, current);
        if (recipeId == null) break;
        final updated = current.recipes
            .map((r) =>
                r.recipeId == recipeId ? r.copyWith(quantityMultiplier: m) : r)
            .toList();
        final next = current.copyWith(recipes: updated);
        state = state.copyWith(sharedState: next);
        ref.read(cookingSessionsProvider.notifier).setMultiplier(recipeId, m);
        if (isHost) sendMessage(PeerMessage.fullStateSync(next));
        break;

      case PeerMessageType.timerStarted:
        final shareId = msg.payload['shareId'] as String?;
        if (shareId == null) break;
        ref.read(timerProvider.notifier).applyRemoteTimerStarted(
              shareId: shareId,
              name: msg.payload['name'] as String? ?? 'Timer',
              recipeName: msg.payload['recipeName'] as String? ?? '',
              remainingSeconds:
                  (msg.payload['remainingSeconds'] as num?)?.toInt() ?? 0,
            );
        // Host re-broadcastet damit weitere Guests den Timer auch sehen.
        if (isHost) sendMessage(msg);
        break;

      case PeerMessageType.timerPaused:
        final shareId = msg.payload['shareId'] as String?;
        if (shareId == null) break;
        ref.read(timerProvider.notifier).applyRemoteTimerPaused(
              shareId: shareId,
              remainingSeconds:
                  (msg.payload['remainingSeconds'] as num?)?.toInt() ?? 0,
            );
        if (isHost) sendMessage(msg);
        break;

      case PeerMessageType.timerResumed:
        final shareId = msg.payload['shareId'] as String?;
        if (shareId == null) break;
        ref.read(timerProvider.notifier).applyRemoteTimerResumed(
              shareId: shareId,
              remainingSeconds:
                  (msg.payload['remainingSeconds'] as num?)?.toInt() ?? 0,
            );
        if (isHost) sendMessage(msg);
        break;

      case PeerMessageType.timerStopped:
        final shareId = msg.payload['shareId'] as String?;
        if (shareId == null) break;
        ref.read(timerProvider.notifier).applyRemoteTimerStopped(shareId);
        if (isHost) sendMessage(msg);
        break;

      case PeerMessageType.sessionEnded:
        // HOST empfängt sessionEnded von einem GAST: der Gast hat die Session
        // verlassen → nur DESSEN Socket schließen und den guestCount senken.
        // Die Session läuft für den Host und alle anderen Gäste weiter.
        // (Vorher lief hier der komplette Teardown → EIN Gast, der ging, riss
        // die ganze Host-Session für alle ab.)
        if (isHost) {
          _guestSockets.remove(source);
          _rxBuffers.remove(source);
          source.destroy();
          state = state.copyWith(guestCount: _guestSockets.length);
          break;
        }
        // GAST: Host hat die Session beendet → der Gast verliert SOFORT den
        // Zugriff auf die geteilten Rezepte UND den Kochmodus. Beendet werden
        // alle aus dem shared-State materialisierten Sessions (1:1 zu Swifts
        // endAllSharedSessions) — eigene, vor dem Join gestartete Sessions
        // eines Gasts mit eigenem Server bleiben erhalten.
        _endGuestMaterializedSessions();
        // Laufende GETEILTE Timer beim Gast ebenfalls deaktivieren: ohne den
        // Host, der die Session steuert, sind sie nutzlos und würden sonst
        // weiterlaufen und am Ende fälschlich alarmieren. Nur geteilte Timer
        // (shareId != null) — eigene lokale Timer eines Gasts mit eigenem
        // Server bleiben erhalten.
        ref.read(timerProvider.notifier).stopShared();
        // Event-Trigger inkrementieren damit Screens die „Host hat Session
        // beendet"-Snackbar zeigen und sich aus dem Stack poppen.
        ref.read(cookFriendsRemoteEndedTriggerProvider.notifier).state++;
        _cleanup();
        state = const CookFriendsState();
        break;
    }
  }

  // ── Per-Recipe Sync-Helfer ───────────────────────────────────────────────

  /// Default-Recipe-ID falls eine Peer-Message keine `recipeId` enthält
  /// (alte Swift-Hosts senden noch Single-Recipe-Format). Fallback ist das
  /// erste Recipe im shared-State.
  String? _resolveRecipeId(PeerMessage msg, SharedSessionState current) {
    final raw = msg.payload['recipeId'] as String?;
    if (raw != null && raw.isNotEmpty) return raw;
    return current.firstRecipe?.recipeId;
  }

  /// Lokaler Session-Key zu einer shared recipeId (Legacy-Swift-Hosts senden
  /// den Mealie-SLUG, lokal keyen wir per recipe.id).
  String _localIdFor(String sharedRecipeId) =>
      _sharedToLocalId[sharedRecipeId] ?? sharedRecipeId;

  /// Beendet beim GAST alle aus dem shared-State materialisierten Sessions
  /// (Union aus Tracking-Set und aktuellem shared-State, gegen Races beim
  /// Verbindungsaufbau). Eigene, nicht geteilte Sessions bleiben unberührt.
  void _endGuestMaterializedSessions() {
    final notifier = ref.read(cookingSessionsProvider.notifier);
    final shared = state.sharedState?.recipes ?? const <SharedRecipe>[];
    final toEnd = <String>{
      ..._guestMaterializedIds,
      for (final r in shared) _localIdFor(r.recipeId),
    };
    for (final id in toEnd) {
      notifier.endSession(id);
    }
    _guestMaterializedIds.clear();
  }

  SharedSessionState _applyToggleIngredient(
      SharedSessionState s, String recipeId, int index) {
    final updated = s.recipes.map((r) {
      if (r.recipeId != recipeId) return r;
      final list = List<bool>.from(r.completedIngredients);
      while (list.length <= index) {
        list.add(false);
      }
      list[index] = !list[index];
      return r.copyWith(completedIngredients: list);
    }).toList();
    return s.copyWith(recipes: updated);
  }

  SharedSessionState _applyToggleInstruction(
      SharedSessionState s, String recipeId, int index) {
    final updated = s.recipes.map((r) {
      if (r.recipeId != recipeId) return r;
      final list = List<bool>.from(r.completedInstructions);
      while (list.length <= index) {
        list.add(false);
      }
      list[index] = !list[index];
      return r.copyWith(completedInstructions: list);
    }).toList();
    return s.copyWith(recipes: updated);
  }

  void _propagateToggleToLocal(String recipeId, int index,
      {required bool ingredient}) {
    final notifier = ref.read(cookingSessionsProvider.notifier);
    final localId = _localIdFor(recipeId);
    final session = notifier.getSession(localId);
    if (session == null) return;
    // Bounds-Guard: ein Peer mit abweichender Rezeptversion kann einen Index
    // jenseits der lokalen Liste senden — ohne Guard flöge ein RangeError,
    // der still geschluckt würde und Host-UI/Shared-State desynct.
    final len = ingredient
        ? session.completedIngredients.length
        : session.completedInstructions.length;
    if (index < 0 || index >= len) return;
    if (ingredient) {
      notifier.toggleIngredient(localId, index);
    } else {
      notifier.toggleInstruction(localId, index);
    }
  }

  /// Wendet den geteilten Per-Recipe-State auf die lokale CookingSession an
  /// (Multiplier + ticked Ingredient/Instruction-Positionen). Wird beim
  /// fullStateSync-Empfang für jedes Recipe aufgerufen.
  void _applySharedRecipeToCookingSession(SharedRecipe shared) {
    final notifier = ref.read(cookingSessionsProvider.notifier);
    final localId = _localIdFor(shared.recipeId);
    notifier.setMultiplier(localId, shared.quantityMultiplier);
    final session = notifier.getSession(localId);
    if (session == null) return;
    for (var i = 0;
        i < shared.completedIngredients.length &&
            i < session.completedIngredients.length;
        i++) {
      if (session.completedIngredients[i] != shared.completedIngredients[i]) {
        notifier.toggleIngredient(localId, i);
      }
    }
    for (var i = 0;
        i < shared.completedInstructions.length &&
            i < session.completedInstructions.length;
        i++) {
      if (session.completedInstructions[i] != shared.completedInstructions[i]) {
        notifier.toggleInstruction(localId, i);
      }
    }
  }

  Future<void> endSession() async {
    sendMessage(PeerMessage.sessionEnded());
    // Peer-Sockets erst GRACEFUL schließen (flush + FIN), damit die
    // sessionEnded-Nachricht garantiert beim Client ankommt. Das `destroy()`
    // in _cleanup() würde gepufferte Bytes verwerfen → der Client erführe
    // nie vom Ende und behielte Kochmodus + Rezepte.
    await _closePeersGracefully();

    // GAST verlässt die Session selbst → die lokal aus dem shared-State
    // materialisierten Rezepte beenden. Sonst behält der Gast die
    // Kochmodus-Sessions und wird über den Koch-FAB / die Auto-Weiterleitung
    // zurück in den Kochmodus gezogen, obwohl er die geteilte Session beendet
    // hat. Spiegelt den sessionEnded-Empfangspfad (Host beendet). Der HOST
    // behält dagegen seine EIGENEN Rezepte (er kocht weiter).
    if (state.role == CookFriendsRole.guest) {
      _endGuestMaterializedSessions();
    }

    await _cleanup();
    state = const CookFriendsState();
  }

  /// Flusht und schließt alle Peer-Sockets ordentlich (FIN statt RST), bevor
  /// _cleanup() sie hart zerstört. Mit Timeout, damit ein hängender Socket
  /// das Session-Ende nicht blockiert.
  Future<void> _closePeersGracefully() async {
    final socks = <Socket>[
      ..._guestSockets,
      if (_guestSocket != null) _guestSocket!,
    ];
    await Future.wait(socks.map((s) async {
      try {
        await s.flush().timeout(const Duration(seconds: 2));
        await s.close().timeout(const Duration(seconds: 2));
      } catch (_) {/* best-effort */}
    }));
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  String _generateCode() {
    final rng = Random.secure();
    return List.generate(6, (_) => _codeChars[rng.nextInt(_codeChars.length)])
        .join();
  }

  Future<void> _cleanup() async {
    await _discoverySub?.cancel();
    _discoverySub = null;
    await _broadcast?.stop();
    await _discovery?.stop();
    _broadcast = null;
    _discovery = null;

    _guestMaterializedIds.clear();
    _sharedToLocalId.clear();

    _guestSocket?.destroy();
    _guestSocket = null;

    for (final s in _guestSockets) {
      s.destroy();
    }
    _guestSockets.clear();
    _rxBuffers.clear();

    await _serverSocket?.close();
    _serverSocket = null;
  }
}
