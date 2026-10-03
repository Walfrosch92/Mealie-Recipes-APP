import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';
import '../models/cookbook_summary.dart';
import '../models/organizer_item.dart';
import '../utils/app_l10n.dart';
import '../utils/video_url.dart';
import '../models/recipe_detail.dart';
import '../models/recipe_summary.dart';
import '../models/shopping_item.dart';
import '../models/mealplan_entry.dart';
import '../models/mealplan_rule.dart';
import '../models/timeline_event.dart';
import '../providers/settings_provider.dart';
import '../services/local_cache.dart';
import '../services/log_manager.dart';

// ---------------------------------------------------------------------------
// Auth-Modus — geteilt zwischen Setup- und Settings-Screen: „password" zeigt
// Benutzer/Passwort-Felder (→ generiert ein API-Token, siehe
// createLongLiveToken), „token" das klassische manuelle API-Token-Feld
// (nötig für OIDC-/LDAP-Nutzer ohne lokales Mealie-Passwort).
// ---------------------------------------------------------------------------

enum AuthMode { password, token }

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final apiServiceProvider = Provider<ApiService>((ref) {
  // Recreate the Dio-backed ApiService only when SERVER config changes.
  // UI preferences (collapsed categories, category order, language, etc.)
  // also live in AppSettings, so watching the whole settingsProvider would
  // invalidate every data provider on each preference toggle — that was
  // the source of the 2-second list reload on every category collapse.
  ref.watch(settingsProvider.select((async) {
    final s = async.valueOrNull;
    return Object.hash(
      s?.serverUrl,
      s?.apiToken,
      s?.householdId,
      s?.apiVersion,
      s?.shoppingListId,
      s?.sendOptionalHeaders,
      s?.optionalHeaderKey1,
      s?.optionalHeaderValue1,
      s?.optionalHeaderKey2,
      s?.optionalHeaderValue2,
      s?.optionalHeaderKey3,
      s?.optionalHeaderValue3,
    );
  }));
  final settings =
      ref.read(settingsProvider).valueOrNull ?? const AppSettings();
  return ApiService(settings);
});

/// Hält den in `main()` vor `runApp` aus dem SharedPreferences-Cache
/// geladenen User-Snapshot. Default ist null; die `main`-Funktion überschreibt
/// das via `ProviderScope.overrides`. So ist der gecachte User ab dem ersten
/// Build synchron verfügbar — kein Async-Frame-Flackern.
final initialCachedUserProvider =
    Provider<Map<String, dynamic>?>((ref) => null);

/// The authenticated Mealie user (via /api/users/self). Wird als synchroner
/// NotifierProvider geliefert damit der Home-Screen den Namen ab Frame 1
/// hat: initial = preloaded Cache aus `initialCachedUserProvider`, parallel
/// im Hintergrund refresh vom Server sobald settings geladen sind.
final currentUserProvider =
    NotifierProvider<CurrentUserNotifier, Map<String, dynamic>?>(
        CurrentUserNotifier.new);

/// Name der versteckten Einkaufsliste, die „Rezept senden" als Postfach auf
/// dem Mealie-Server nutzt (siehe RecipeMailbox). Bewusst sprachneutral und
/// unverwechselbar — die App blendet sie überall aus.
const kRecipeMailboxListName = '📨 Mealie Recipes · Send To';

bool isRecipeMailboxList(Map<String, dynamic> list) =>
    (list['name'] as String?)?.trim() == kRecipeMailboxListName;

class CurrentUserNotifier extends Notifier<Map<String, dynamic>?> {
  @override
  Map<String, dynamic>? build() {
    // Synchron den preloaded Cache zurückgeben (Frame 1: Name da).
    final initial = ref.read(initialCachedUserProvider);
    // Hintergrund-Refresh nach settings.future. Kein await im build().
    Future.microtask(_refreshFromServer);
    return initial;
  }

  /// Nach dem Speichern des eigenen Kontos den neuen Stand übernehmen.
  Future<void> replace(Map<String, dynamic> user) async {
    await LocalCache.saveCurrentUser(user);
    state = user;
  }

  Future<void> _refreshFromServer() async {
    try {
      final settings = await ref.read(settingsProvider.future);
      if (!settings.isConfigured) {
        // Settings unkonfiguriert (Guest-Mode oder Setup nicht fertig)
        // → keinen Server-Hit, aber den Cache aktualisieren wenn nötig.
        if (state != null) {
          await LocalCache.saveCurrentUser(null);
          state = null;
        }
        return;
      }
      final fresh = await ref.read(apiServiceProvider).fetchCurrentUser();
      await LocalCache.saveCurrentUser(fresh);
      state = fresh;
    } catch (_) {
      // Bei Netzwerkfehler den gecachten Stand behalten.
    }
  }
}

// ---------------------------------------------------------------------------
// API service
// ---------------------------------------------------------------------------

class ApiService {
  final AppSettings settings;
  late final Dio _dio;

  ApiService(this.settings) {
    _dio = Dio(BaseOptions(
      baseUrl: settings.serverUrl.isEmpty ? '' : settings.serverUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Token und Zusatz-Header (z. B. Cloudflare-Access) NUR an den
        // eigenen Mealie-Server — nie an einen fremden Host, falls je eine
        // absolute URL (z. B. aus Rezeptdaten) hier durchläuft.
        if (_isOwnServer(options.uri)) {
          if (settings.apiToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${settings.apiToken}';
          }
          settings.optionalHeaders.forEach((k, v) {
            options.headers[k] = v;
          });
        }
        options.headers['Content-Type'] = 'application/json';
        LogManager.shared.log('🌐 ${options.method} ${options.uri}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        LogManager.shared
            .log('✅ ${response.statusCode} ${response.requestOptions.uri}');
        handler.next(response);
      },
      onError: (e, handler) {
        final status = e.response?.statusCode;
        final body = e.response?.data;
        LogManager.shared
            .log('❌ ${e.requestOptions.method} ${e.requestOptions.uri} '
                '→ ${status ?? e.type.name}${body != null ? ': $body' : ''}');
        handler.next(e);
      },
    ));
  }

  bool _isOwnServer(Uri uri) {
    final base = Uri.tryParse(settings.serverUrl.trim());
    if (base == null || base.host.isEmpty) return false;
    return uri.scheme == base.scheme &&
        uri.host.toLowerCase() == base.host.toLowerCase() &&
        uri.port == base.port;
  }

  // -------------------------------------------------------------------------
  // Path versioning — mirrors APIService.versionedPath()
  // v2: /api/users  →  /api/users
  // v3: /api/users  →  /api/admin/users
  // -------------------------------------------------------------------------

  String _path(String path) {
    // v3 moved most user-management endpoints under /api/admin/users — but
    // /api/users/self und /api/users/api-tokens (Login→Token-Erzeugung,
    // siehe createLongLiveToken) bleiben in JEDER Mealie-Version unverändert.
    // Rewriting sie returnt 404 und bricht die personalisierte Begrüßung
    // bzw. den Benutzer/Passwort-Login auf v3-Servern.
    if (settings.apiVersion == 'v3' &&
        path.startsWith('/api/users') &&
        !path.startsWith('/api/users/self') &&
        !path.startsWith('/api/users/api-tokens')) {
      return path.replaceFirst('/api/users', '/api/admin/users');
    }
    return path;
  }

  // -------------------------------------------------------------------------
  // Test connection
  // -------------------------------------------------------------------------

  Future<String> testConnection() async {
    final resp = await _dio.get(_path('/api/app/about'));
    final version = resp.data?['version'] as String? ?? '';
    return version;
  }

  // -------------------------------------------------------------------------
  // Login (Benutzer & Passwort statt API-Token)
  //
  // Alternative zum manuellen API-Token aus dem Webapp-Profil: der Nutzer
  // meldet sich EINMALIG mit Benutzer+Passwort an, die App erzeugt daraus ein
  // langlebiges API-Token (dieselbe Sorte, die der Nutzer sonst manuell unter
  // Profil → API-Tokens anlegt) und verwirft Passwort UND das kurzlebige
  // Login-JWT sofort danach. Ab da läuft die App exakt wie mit einem manuell
  // eingegebenen Token — kein separater Auth-Pfad, kein Token-Refresh nötig.
  // -------------------------------------------------------------------------

  /// POST /api/auth/token — Mealies klassischer OAuth2-Password-Grant, ERWARTET
  /// form-encoded Body (kein JSON), deshalb FormData statt `data: {...}`.
  /// Liefert nur ein kurzlebiges JWT (Std. ~48h) — wird NIRGENDS persistiert,
  /// nur sofort an [createLongLiveToken] weitergereicht.
  Future<String> loginWithPassword(String username, String password) async {
    final resp = await _dio.post(
      _path('/api/auth/token'),
      data: FormData.fromMap({'username': username, 'password': password}),
    );
    final data = resp.data;
    final token = data is Map ? data['access_token'] as String? : null;
    if (token == null || token.isEmpty) {
      throw const FormatException('Keine access_token in der Login-Antwort');
    }
    return token;
  }

  /// POST /api/users/api-tokens — erzeugt ein langlebiges API-Token,
  /// authentifiziert mit dem kurzlebigen JWT aus [loginWithPassword]. NICHT
  /// über den `settings.apiToken`-Interceptor (der ist beim Erstlogin noch
  /// leer) — der Bearer wird für DIESEN einen Request explizit gesetzt.
  /// Rückgabe (id, rawToken): rawToken liefert Mealie nur bei der Erzeugung
  /// einmalig zurück; id erlaubt späteres Aufräumen via [deleteLongLiveToken].
  Future<(String id, String token)> createLongLiveToken(
      String bearerToken, String name) async {
    final resp = await _dio.post(
      _path('/api/users/api-tokens'),
      data: {'name': name},
      options: Options(headers: {'Authorization': 'Bearer $bearerToken'}),
    );
    final data = resp.data;
    if (data is! Map) {
      throw const FormatException('Unerwartete Antwort beim Token-Erzeugen');
    }
    final token = (data['token'] as String?)?.trim() ?? '';
    final id = data['id']?.toString() ?? '';
    if (token.isEmpty) {
      throw const FormatException('Kein Token in der Erzeugen-Antwort');
    }
    return (id, token);
  }

  /// DELETE /api/users/api-tokens/{id} — räumt ein von der App generiertes
  /// Token auf (z. B. bei App-Reset), damit sich im Mealie-Profil nicht bei
  /// jedem Reset+Neu-Login ein weiteres Token ansammelt. Best-effort: der
  /// Aufrufer fängt Fehler ab (das Token existiert serverseitig ggf. schon
  /// nicht mehr, z. B. weil der Nutzer es manuell im Profil widerrufen hat).
  Future<void> deleteLongLiveToken(String id) async {
    await _dio.delete(_path('/api/users/api-tokens/$id'));
  }

  // -------------------------------------------------------------------------
  // Recipes — list with pagination (mirrors fetchAllRecipes)
  // -------------------------------------------------------------------------

  /// Fetches ALL recipes across all pages, pausing 1 second every 3 pages.
  Future<List<RecipeSummary>> fetchAllRecipes() async {
    const perPage = 50;
    int page = 1;
    final List<RecipeSummary> all = [];

    while (true) {
      final resp = await _getRecipePageWithRetry(page, perPage);
      final data = resp.data as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>? ?? [])
          .map((e) => RecipeSummary.fromJson(e as Map<String, dynamic>))
          .toList();
      all.addAll(items);

      final total = data['total'] as int? ?? items.length;
      if (all.length >= total || items.isEmpty) break;

      page++;
      // 1-second pause every 3 pages to avoid overloading the server
      if (page % 3 == 1) await Future.delayed(const Duration(seconds: 1));
    }

    return all;
  }

  /// Die zuletzt geänderten Rezepte (neueste zuerst) — EINE Anfrage für den
  /// schnellen Abgleich beim Öffnen der App. Mealie setzt `date_updated` bei
  /// jedem Speichern des Rezepts.
  Future<List<RecipeSummary>> fetchRecentlyUpdatedRecipes(
      {int perPage = 50}) async {
    final resp = await _dio.get(
      _path('/api/recipes'),
      queryParameters: {
        'page': 1,
        'perPage': perPage,
        'orderBy': 'date_updated',
        'orderDirection': 'desc',
      },
    );
    final data = resp.data as Map<String, dynamic>;
    return [
      for (final e in data['items'] as List<dynamic>? ?? const [])
        RecipeSummary.fromJson(e as Map<String, dynamic>)
    ];
  }

  /// Eine Seite von [fetchAllRecipes] mit bis zu 2 Wiederholungen. Bei großen
  /// Bibliotheken (50+ Seiten) liess sonst EIN Timeout oder Verbindungs-
  /// abbruch auf irgendeiner Seite den kompletten Abgleich scheitern.
  /// Wiederholt wird nur, was vorübergehend sein kann (Timeout, Verbindung,
  /// 5xx) — ein 401/404 kommt beim zweiten Mal genauso zurück.
  Future<Response<dynamic>> _getRecipePageWithRetry(
      int page, int perPage) async {
    const maxRetries = 2;
    for (var attempt = 0;; attempt++) {
      try {
        return await _dio.get(
          _path('/api/recipes'),
          queryParameters: {
            'page': page,
            'perPage': perPage,
            'orderBy': 'name',
            'orderDirection': 'asc',
          },
        );
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        final transient = e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.connectionError ||
            (status != null && status >= 500);
        if (!transient || attempt >= maxRetries) rethrow;
        LogManager.shared.log(
            '🔁 Rezeptseite $page: Versuch ${attempt + 2}/${maxRetries + 1}');
        await Future.delayed(Duration(seconds: 2 * (attempt + 1)));
      }
    }
  }

  // -------------------------------------------------------------------------
  // Recipe detail
  // -------------------------------------------------------------------------

  Future<RecipeDetail> fetchRecipeDetail(String id) async {
    final resp = await _dio.get(_path('/api/recipes/$id'));
    // Frisch vom Server mit dem aktuellen Modell gelesen → aktuelle
    // Cache-Version (steuert das einmalige Nachladen alter Cache-Einträge).
    return RecipeDetail.fromJson(resp.data as Map<String, dynamic>)
        .copyWith(cacheSchema: kRecipeCacheSchema);
  }

  /// Rohes Rezept-JSON (Editor: behält beim Speichern alle Felder, auch
  /// solche, die das App-Modell nicht kennt).
  Future<Map<String, dynamic>> fetchRecipeRaw(String idOrSlug) async {
    final resp = await _dio.get(_path('/api/recipes/$idOrSlug'));
    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// /api/app/about — Version und aktivierte Server-Funktionen (z. B.
  /// `enableOpenai` für den KI-Zutatenparser).
  Future<Map<String, dynamic>> fetchServerInfo() async {
    final resp = await _dio.get(_path('/api/app/about'));
    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// Zutaten mit dem Mealie-Parser zerlegen ([parser]: nlp, brute, openai).
  /// Liefert je Zeile ein ParsedIngredient {input, confidence, ingredient}.
  Future<List<Map<String, dynamic>>> parseIngredients(List<String> lines,
      {String parser = 'nlp'}) async {
    final resp = await _dio.post(_path('/api/parser/ingredients'),
        data: {'parser': parser, 'ingredients': lines});
    final body = resp.data;
    if (body is! List) return const [];
    return [
      for (final e in body)
        if (e is Map) Map<String, dynamic>.from(e)
    ];
  }

  /// Eine einzelne Zutat parsen (Fallback, wenn der Server die ganze Liste
  /// ablehnt — z. B. stürzt Mealies Brute-Parser bei einzelnen Texten ab).
  Future<Map<String, dynamic>> parseIngredient(String line,
      {String parser = 'nlp'}) async {
    final resp = await _dio.post(_path('/api/parser/ingredient'),
        data: {'parser': parser, 'ingredient': line});
    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// Rezeptbild von einer URL laden lassen (der Server lädt herunter).
  Future<void> scrapeRecipeImage(String slug, String url) async {
    await _dio.post(_path('/api/recipes/$slug/image'), data: {'url': url});
  }

  /// Rezeptbild entfernen.
  Future<void> deleteRecipeImage(String slug) async {
    await _dio.delete(_path('/api/recipes/$slug/image'));
  }

  /// Alle Benutzer der Gruppe (Auswahl „Besitzer" im Editor).
  Future<List<Map<String, dynamic>>> fetchGroupMembers() async {
    final resp = await _dio.get(_path('/api/groups/members'),
        queryParameters: {'perPage': -1, 'orderBy': 'full_name'});
    final body = resp.data;
    final List items = body is Map
        ? (body['items'] as List? ?? const [])
        : (body as List? ?? const []);
    return [
      for (final e in items)
        if (e is Map) Map<String, dynamic>.from(e)
    ];
  }

  // -------------------------------------------------------------------------
  // Recipe CRUD
  // -------------------------------------------------------------------------

  Future<RecipeDetail> createRecipe(Map<String, dynamic> payload) async {
    // POST returns the slug of the new recipe
    final resp = await _dio.post(_path('/api/recipes'), data: payload);
    final slug = resp.data as String;
    return fetchRecipeDetail(slug);
  }

  // PATCH api/recipes/<id> — mirrors iOS updateFullRecipe(originalSlug:payload:)
  Future<void> updateRecipe(String id, Map<String, dynamic> payload) async {
    await _dio.patch(_path('/api/recipes/$id'), data: payload);
  }

  /// PATCH mit Antwort: das gespeicherte Rezept (roh) — u. a. mit dem
  /// neuen Slug, falls der Name geändert wurde.
  Future<Map<String, dynamic>?> patchRecipe(
      String id, Map<String, dynamic> payload) async {
    final resp = await _dio.patch(_path('/api/recipes/$id'), data: payload);
    final body = resp.data;
    return body is Map ? Map<String, dynamic>.from(body) : null;
  }

  // Partial-PATCH nur der Notizen (RecipePatchRequest erlaubt Teil-Updates —
  // andere Felder bleiben unangetastet).
  Future<void> updateRecipeNotes(String id, List<RecipeNote> notes) async {
    await updateRecipe(id, {
      'notes': notes.map((n) => {'title': n.title, 'text': n.text}).toList(),
    });
  }

  Future<void> deleteRecipe(String id) async {
    await _dio.delete(_path('/api/recipes/$id'));
  }

  // -------------------------------------------------------------------------
  // Last made („Zuletzt gekocht")
  // -------------------------------------------------------------------------

  // PATCH /api/recipes/{slug}/last-made  Body {"timestamp": ISO-8601-UTC} —
  // derselbe Endpoint, den die Mealie-Webapp für ihren „Last Made"-Button
  // nutzt. Wird beim Abschluss im Kochmodus aufgerufen (Toggle-gesteuert).
  Future<void> updateLastMade(String slug, DateTime timestamp) async {
    await _dio.patch(
      _path('/api/recipes/$slug/last-made'),
      data: {'timestamp': timestamp.toUtc().toIso8601String()},
    );
  }

  // -------------------------------------------------------------------------
  // Rating
  // -------------------------------------------------------------------------

  String? _cachedUserId;

  // Mirrors iOS getCurrentUserId() — fetches and caches the current user id.
  Future<String?> _currentUserId() async {
    if (_cachedUserId != null) return _cachedUserId;
    try {
      final resp = await _dio.get(_path('/api/users/self'));
      final data = resp.data as Map<String, dynamic>;
      _cachedUserId = data['id'] as String?;
    } catch (_) {}
    return _cachedUserId;
  }

  /// Returns the authenticated user — used by the homescreen to greet by name.
  /// Throws if the request fails (caller decides how to handle).
  Future<Map<String, dynamic>> fetchCurrentUser() async {
    final resp = await _dio.get(_path('/api/users/self'));
    return Map<String, dynamic>.from(resp.data as Map);
  }

  // Bewertung setzen — 1:1 zur Swift-App (setRecipeRating). Mealie nutzt in
  // ALLEN von der App unterstützten Versionen die User-Ratings-Endpoints,
  // NICHT ein PATCH des Rezepts:
  //   • Setzen:   POST   /api/users/{userId}/ratings/{slug}  Body {"rating": <int>}
  //   • Löschen:  DELETE /api/users/{userId}/ratings/{slug}
  //
  // Wichtig:
  //   • `rating` MUSS ein Integer sein — das UserRatingUpdate-Schema lehnt
  //     Floats (z. B. 4.0) mit HTTP 422 ab (das war der „geht nicht"-Bug).
  //   • Der Pfad wird NICHT durch `_path()` umgeschrieben — Rating- und
  //     /self-Endpoints bleiben unter /api/users (Swift macht denselben
  //     Ausschluss); nur die User-Verwaltung wandert in v3 nach /api/admin.
  //   • rating <= 0 → Bewertung entfernen (DELETE) statt 0 zu POSTen.
  Future<void> setRating(String slug, double rating) async {
    final userId = await _currentUserId();
    if (userId == null) {
      throw StateError('Aktuelle User-ID nicht verfügbar — Rating abgebrochen');
    }
    final r = rating.round();
    if (r <= 0) {
      try {
        await _dio.delete('/api/users/$userId/ratings/$slug');
      } on DioException catch (e) {
        // 404 = es gab serverseitig gar keinen User-Rating-Datensatz (die
        // angezeigte Bewertung kam z. B. aus dem Gruppen-Durchschnitt).
        // Ziel „keine Bewertung" ist damit erreicht — kein Fehler.
        if (e.response?.statusCode != 404) rethrow;
      }
      return;
    }
    await _dio.post(
      '/api/users/$userId/ratings/$slug',
      data: {'rating': r},
    );
  }

  // Favoriten („Herz") — parallel zu setRating. Mealie verwaltet Favoriten über
  // dieselbe User-Ratings-Familie:
  //   • Setzen:   POST   /api/users/{userId}/favorites/{slug}
  //   • Entfernen:DELETE /api/users/{userId}/favorites/{slug}
  //   • Liste:    GET    /api/users/self/favorites  → UserRatings(ratings:[…])
  // Wie bei setRating: KEIN `_path()`-Rewrite (self/ratings/favorites bleiben
  // unter /api/users), und der Pfad-Parameter ist der ECHTE Rezept-Slug
  // (nicht die UUID — siehe Slug-vs-id-Falle).

  /// IDs (UUID) der vom aktuellen User favorisierten Rezepte.
  Future<Set<String>> fetchFavoriteRecipeIds() async {
    final resp = await _dio.get('/api/users/self/favorites');
    final data = resp.data;
    // Antwort ist UserRatings_UserRatingSummary_ = {"ratings":[{recipeId,
    // rating, isFavorite}, …]}; ältere Server liefern evtl. direkt eine Liste.
    final List list = data is Map
        ? (data['ratings'] as List? ?? const [])
        : (data as List? ?? const []);
    final ids = <String>{};
    for (final e in list) {
      if (e is! Map) continue;
      final rid = (e['recipeId'] ?? e['recipe_id']);
      final fav = (e['isFavorite'] ?? e['is_favorite']);
      // Der /favorites-Endpoint liefert nur Favoriten; das isFavorite-Feld
      // (falls vorhanden) muss trotzdem true sein, sonst überspringen.
      if (rid is String && rid.isNotEmpty && fav != false) ids.add(rid);
    }
    return ids;
  }

  /// Favorit setzen ([favorite] true) oder entfernen. [slug] = echter Slug.
  Future<void> setFavorite(String slug, bool favorite) async {
    final userId = await _currentUserId();
    if (userId == null) {
      throw StateError(
          'Aktuelle User-ID nicht verfügbar — Favorit abgebrochen');
    }
    if (favorite) {
      await _dio.post('/api/users/$userId/favorites/$slug');
    } else {
      await _dio.delete('/api/users/$userId/favorites/$slug');
    }
  }

  // -------------------------------------------------------------------------
  // Image upload (multipart)
  // -------------------------------------------------------------------------

  Future<void> uploadRecipeImage(String slug, File imageFile) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: 'image.jpg',
      ),
      'extension': 'jpg',
    });
    await _dio.put(
      _path('/api/recipes/$slug/image'),
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  /// Wie [uploadRecipeImage], aber aus rohen Bytes (kein File nötig). Wird beim
  /// „geteiltes Rezept auf eigenem Server speichern" genutzt, wo das Bild vom
  /// Server geladen und direkt weiter-hochgeladen wird.
  Future<void> uploadRecipeImageBytes(String slug, List<int> bytes,
      {String extension = 'jpg'}) async {
    final formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(bytes, filename: 'image.$extension'),
      'extension': extension,
    });
    await _dio.put(
      _path('/api/recipes/$slug/image'),
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  /// Lädt die Original-Bildbytes eines Rezepts vom konfigurierten Server.
  /// Wirft bei 404 (kein Bild bzw. Rezept gehört zu einem anderen Server) —
  /// der Aufrufer behandelt das als „kein Bild zu kopieren".
  Future<List<int>> fetchRecipeImageBytes(String recipeId) async {
    final resp = await _dio.get<List<int>>(
      _path('/api/media/recipes/$recipeId/images/original.webp'),
      options: Options(responseType: ResponseType.bytes),
    );
    return resp.data ?? const <int>[];
  }

  // -------------------------------------------------------------------------
  // Import from URL
  // -------------------------------------------------------------------------

  // POST api/recipes/create/image — mirrors iOS uploadRecipeImage(_:translateLanguage:)
  //
  // Schickt ALLE Seiten eines Rezepts in EINER Multipart-Anfrage. Mealie
  // deklariert den Endpunkt als `images: list[UploadFile] = File(...)`, mehrere
  // Parts unter demselben Feldnamen `images` sind also das vorgesehene Format
  // (deshalb heisst das Feld auch im Singular-Fall schon plural). Das kostet
  // EINE KI-Anfrage für das ganze Rezept statt einer pro Seite und ist
  // abwärtskompatibel — der Endpunkt existiert unverändert auch in älteren
  // Mealie-Versionen. `translateLanguage` bleibt Query-Parameter.
  //
  // Die Reihenfolge der Liste bleibt in den Multipart-Parts erhalten; die
  // erste Seite wird von Mealie zum Hauptbild des Rezepts.
  Future<String> importRecipeFromImages(List<File> imageFiles) async {
    if (imageFiles.isEmpty) throw Exception('No images to upload');
    // Zielsprache des KI-Imports: die bewusst gewählte Importsprache, sonst
    // die App-Sprache (siehe AppSettings.effectiveImportLanguage).
    final queryParams = {
      'translateLanguage': settings.effectiveImportLanguage,
    };
    // Eine Liste als Wert → Dio hängt pro Element einen eigenen Part mit
    // demselben Feldnamen `images` an, in genau dieser Reihenfolge.
    final formData = FormData.fromMap({
      'images': [
        for (var i = 0; i < imageFiles.length; i++)
          await MultipartFile.fromFile(
            imageFiles[i].path,
            filename: _uploadFilename(imageFiles[i].path, i + 1),
          ),
      ],
    });
    // Ab Mealie 3.23: universeller KI-Import — ordnet zusätzlich Schlagworte,
    // Kategorien und Utensilien zu (fehlende werden angelegt). Ältere Server
    // kennen ihn nicht (404/405) → wie bisher /create/image. Eigene FormData
    // pro Versuch: ein MultipartFile-Stream lässt sich nur einmal lesen.
    try {
      final aiForm = FormData.fromMap({
        'translateLanguage': settings.effectiveImportLanguage,
        'createNewOrganizers': 'true',
        'images': [
          for (var i = 0; i < imageFiles.length; i++)
            await MultipartFile.fromFile(
              imageFiles[i].path,
              filename: _uploadFilename(imageFiles[i].path, i + 1),
            ),
        ],
      });
      final resp = await _dio.post(
        _path('/api/recipes/create/ai'),
        data: aiForm,
        options: Options(
          contentType: 'multipart/form-data',
          receiveTimeout: const Duration(seconds: 240),
        ),
      );
      return (resp.data as String? ?? '').replaceAll('"', '').trim();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status != 404 && status != 405) rethrow;
      LogManager.shared.log(
          '🤖 Foto-Import: /create/ai fehlt (Mealie < 3.23) → /create/image');
    }
    final resp = await _dio.post(
      _path('/api/recipes/create/image'),
      queryParameters: queryParams,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        // Mehrere Seiten brauchen mehr KI-Zeit als eine einzelne.
        receiveTimeout: const Duration(seconds: 240),
      ),
    );
    return (resp.data as String? ?? '').replaceAll('"', '').trim();
  }

  // KI-URL-Import auf Servern OHNE /create/ai (Mealie < 3.23).
  //
  // Webseiten: KI erzwingen über die beiden Endpunkte, die auch Mealies
  // eigene Debug-Seite nutzt — `test-scrape-url` mit `useOpenAI` lässt die KI
  // die Seite in schema.org-Rezept-JSON übersetzen (speichert nichts),
  // `create/html-or-json` legt daraus das Rezept an (lädt die Seite dank
  // mitgeschicktem JSON NICHT erneut; `url` wird nur als Quelle gespeichert).
  // Videos: /create/url — nur dieser Weg transkribiert (Audio-Anbieter), die
  // KI-Seitenanalyse sähe bloß den Seitentext von YouTube & Co.
  // Scheitert die KI (nicht eingerichtet, kein Rezept erkannt), bleibt als
  // letzter Rückfall der normale Import.
  Future<String> _importUrlWithoutAiEndpoint(String url) async {
    if (looksLikeVideoUrl(url)) {
      LogManager.shared.log('🤖 KI-Import (< 3.23): Video → /create/url');
      return (await importRecipeFromUrl(url)).slug;
    }
    LogManager.shared.log('🤖 KI-Import (< 3.23): KI-Seitenanalyse erzwungen');
    Map<String, dynamic>? scraped;
    try {
      final resp = await _dio.post(
        _path('/api/recipes/test-scrape-url'),
        data: {'url': url, 'useOpenAI': true},
        options: Options(receiveTimeout: const Duration(minutes: 5)),
      );
      // Erfolg: das Rezept-JSON. Misserfolg: ein Hinweis-String.
      if (resp.data is Map) {
        scraped = Map<String, dynamic>.from(resp.data as Map);
      }
    } on DioException catch (e) {
      LogManager.shared.log('🤖 KI-Seitenanalyse fehlgeschlagen: '
          '${e.response?.statusCode ?? e.type.name}');
    }
    if (scraped == null || scraped.isEmpty) {
      LogManager.shared.log('🤖 KI lieferte kein Rezept → normaler Import');
      return (await importRecipeFromUrl(url)).slug;
    }
    final resp = await _dio.post(
      _path('/api/recipes/create/html-or-json'),
      data: {'data': jsonEncode(scraped), 'url': url},
      options: Options(receiveTimeout: const Duration(minutes: 2)),
    );
    final slug = (resp.data as String? ?? '').replaceAll('"', '').trim();
    if (slug.isEmpty) throw const AiImportException(null);
    return slug;
  }

  /// `image_3.png` — durchnummeriert (die Parts brauchen unterscheidbare
  /// Dateinamen) und mit der ECHTEN Endung, damit der Server den Typ richtig
  /// erkennt: die PDF-Seite kommt als PNG, Fotos als JPG.
  static String _uploadFilename(String path, int index) {
    final dot = path.lastIndexOf('.');
    final slash = path.lastIndexOf('/');
    final ext = (dot > slash && dot != -1)
        ? path.substring(dot + 1).toLowerCase()
        : 'jpg';
    return 'image_$index.$ext';
  }

  // POST api/recipes/create/url — mirrors iOS uploadRecipeFromURL(url:)
  // Returns the recipe id (UUID) to fetch detail
  Future<RecipeDetail> importRecipeFromUrl(String url) async {
    final resp = await _dio.post(
      _path('/api/recipes/create/url'),
      data: {'url': url},
      // Seit Mealie 3.13 transkribiert auch dieser Endpunkt Rezeptvideos bzw.
      // fällt bei unlesbaren Seiten auf KI zurück — das dauert weit länger
      // als die üblichen 30 s (vorher: Timeout, obwohl der Server weiterlief
      // und das Rezept am Ende trotzdem anlegte).
      options: Options(receiveTimeout: const Duration(minutes: 5)),
    );
    // API returns the new recipe's slug as a plain string
    final slug = (resp.data as String? ?? '').replaceAll('"', '').trim();
    if (slug.isEmpty) throw Exception('No slug returned from URL import');
    return fetchRecipeDetail(slug);
  }

  // POST api/recipes/create/ai/stream — Mealie „Import with AI" (ab 3.23)
  //
  // Lässt die URL vom KI-Anbieter des Servers auswerten. Erkennt der Server
  // ein Video (YouTube, Instagram, TikTok …, per yt-dlp), lädt er es herunter
  // und transkribiert den Ton (braucht einen Audio-Anbieter, z. B. whisper-1);
  // sonst liest die KI die Webseite — auch solche, an denen der normale
  // Scraper scheitert. Multipart-Formular: `url`, `translateLanguage`.
  //
  // Bewusst die STREAM-Variante (Server-Sent Events): ein Video-Import dauert
  // Minuten. Die Events halten die Verbindung offen (Reverse-Proxys kappen
  // stille Verbindungen oft nach 60 s) und liefern Fortschrittstexte, die der
  // Server bereits in die Sprache aus `Accept-Language` übersetzt:
  //   event: progress  data: {"message": "…"}
  //   event: done      data: {"slug": "…"}
  //   event: error     data: {"message": "…"}
  //
  // Ältere Server (< 3.23) kennen den Endpunkt nicht (404/405) → Rückfall auf
  // /create/url, das seit 3.13 Videos ebenfalls transkribiert.
  //
  // Liefert den Slug des neuen Rezepts.
  Future<String> importRecipeWithAi(
    String url, {
    void Function(String message)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'url': url,
      'translateLanguage': settings.effectiveImportLanguage,
      // Ab 3.23 ordnet Mealie nach dem Import per KI Schlagworte, Kategorien
      // und Utensilien zu. Standard wäre: nur VORHANDENE verknüpfen. So legt
      // Mealie fehlende zusätzlich an. Keine Versionsprüfung nötig: das Feld
      // gibt es nur an diesem Endpunkt, ältere Server landen im Rückfall
      // (/create/url) unten und sehen es nie.
      'createNewOrganizers': 'true',
    });
    final Response<ResponseBody> resp;
    try {
      resp = await _dio.post<ResponseBody>(
        _path('/api/recipes/create/ai/stream'),
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'text/event-stream',
            'Accept-Language': settings.selectedLanguage,
          },
          receiveTimeout: const Duration(minutes: 15),
        ),
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 404 || status == 405) {
        return _importUrlWithoutAiEndpoint(url);
      }
      rethrow;
    }

    final body = resp.data;
    if (body == null) throw const AiImportException(null);
    return readAiImportStream(body.stream, onProgress: onProgress);
  }

  // -------------------------------------------------------------------------
  // Categories & Tags
  // -------------------------------------------------------------------------

  Future<List<CategorySummary>> fetchCategories() async {
    final resp = await _dio.get(_path('/api/organizers/categories'));
    final data = resp.data as Map<String, dynamic>;
    return (data['items'] as List<dynamic>? ?? [])
        .map((e) => CategorySummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TagSummary>> fetchTags() async {
    final resp = await _dio.get(_path('/api/organizers/tags'));
    final data = resp.data as Map<String, dynamic>;
    return (data['items'] as List<dynamic>? ?? [])
        .map((e) => TagSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CategorySummary> createCategory(String name) async {
    final resp = await _dio.post(
      _path('/api/organizers/categories'),
      data: {'name': name},
    );
    return CategorySummary.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<TagSummary> createTag(String name) async {
    final resp = await _dio.post(
      _path('/api/organizers/tags'),
      data: {'name': name},
    );
    return TagSummary.fromJson(resp.data as Map<String, dynamic>);
  }

  // Organizer/Label löschen (serverseitig). DELETE per id (UUID).
  Future<void> deleteCategory(String id) async {
    await _dio.delete(_path('/api/organizers/categories/$id'));
  }

  Future<void> deleteTag(String id) async {
    await _dio.delete(_path('/api/organizers/tags/$id'));
  }

  Future<void> deleteShoppingLabel(String id) async {
    await _dio.delete(_path('/api/groups/labels/$id'));
  }

  /// Name/Farbe einer Abteilung ändern. PUT verlangt das ganze Objekt
  /// (MultiPurposeLabelUpdate inkl. groupId) → vorher laden.
  Future<ShoppingLabel> updateShoppingLabel(String id,
      {required String name, required String color}) async {
    final raw = Map<String, dynamic>.from(
        (await _dio.get(_path('/api/groups/labels/$id'))).data as Map);
    final resp = await _dio.put(_path('/api/groups/labels/$id'),
        data: {...raw, 'name': name, 'color': color});
    return ShoppingLabel.fromJson(resp.data as Map<String, dynamic>);
  }

  /// Mealies Standard-Lebensmittel bzw. -Einheiten einer Sprache anlegen
  /// (POST /api/groups/seeders/{foods|units}, [locale] z. B. `de-DE`).
  /// Vorhandene Einträge werden NICHT abgeglichen (Duplikate möglich).
  Future<void> seedFoodsOrUnits(String kindPath, String locale) async {
    await _dio.post(_path('/api/groups/seeders/$kindPath'),
        data: {'locale': locale},
        options: Options(receiveTimeout: const Duration(minutes: 3)));
  }

  // -------------------------------------------------------------------------
  // Units & Foods (for ingredient autocomplete)
  // -------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> fetchUnits() async {
    // perPage=-1 → ALLE Einheiten (sonst paginiert Mealie auf 50, und das
    // Auflösen/Strippen von Einheiten würde Treffer verpassen).
    final resp =
        await _dio.get(_path('/api/units'), queryParameters: {'perPage': -1});
    final data = resp.data as Map<String, dynamic>;
    return (data['items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchFoods() async {
    final resp =
        await _dio.get(_path('/api/foods'), queryParameters: {'perPage': -1});
    final data = resp.data as Map<String, dynamic>;
    return (data['items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .toList();
  }

  // Legt ein Food/Unit an und gibt das erstellte Objekt (mit id) zurück. Wird
  // beim „Zutaten neu parsen" gebraucht: Mealie verlangt im Rezept-Update für
  // food/unit ein Objekt MIT gültiger id — ein reines {name} wird mit HTTP 422
  // abgelehnt. Existiert das Food/Unit schon (POST schlägt fehl), wird es per
  // Namens-Lookup zurückgegeben.
  Future<Map<String, dynamic>?> createFood(String name) async {
    try {
      final resp = await _dio.post(_path('/api/foods'), data: {'name': name});
      if (resp.data is Map) {
        return (resp.data as Map).cast<String, dynamic>();
      }
    } on DioException {
      final all = await fetchFoods();
      for (final f in all) {
        if (((f['name'] as String?)?.trim().toLowerCase() ?? '') ==
            name.trim().toLowerCase()) {
          return f;
        }
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> createUnit(String name) async {
    try {
      final resp = await _dio.post(_path('/api/units'), data: {'name': name});
      if (resp.data is Map) {
        return (resp.data as Map).cast<String, dynamic>();
      }
    } on DioException {
      final all = await fetchUnits();
      for (final u in all) {
        if (((u['name'] as String?)?.trim().toLowerCase() ?? '') ==
            name.trim().toLowerCase()) {
          return u;
        }
      }
    }
    return null;
  }

  // -------------------------------------------------------------------------
  // Households
  // -------------------------------------------------------------------------

  /// Haushalt des API-Key-Nutzers (GET /api/households/self) — bestimmt die
  /// Vorauswahl im Setup-Dropdown und ist der Fallback, falls die
  /// Gruppen-Liste (fetchHouseholds) nicht ladbar ist.
  Future<Map<String, dynamic>?> fetchSelfHousehold() async {
    final resp = await _dio.get(_path('/api/households/self'));
    final body = resp.data;
    if (body is Map) return Map<String, dynamic>.from(body);
    return null;
  }

  /// Haushalte der Gruppe (GET /api/groups/households) — fürs Setup-Dropdown.
  /// Wie fetchShoppingLists tolerant gegenüber {items:[…]} und rohen Arrays.
  Future<List<Map<String, dynamic>>> fetchHouseholds() async {
    final resp = await _dio.get(
      _path('/api/groups/households'),
      queryParameters: {'perPage': -1},
    );
    final body = resp.data;
    final List items;
    if (body is List) {
      items = body;
    } else if (body is Map<String, dynamic>) {
      items = (body['items'] as List?) ?? const [];
    } else {
      items = const [];
    }
    return items
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  // -------------------------------------------------------------------------
  // Shopping list
  // -------------------------------------------------------------------------

  /// [includeMailbox]: die versteckte „Rezept senden"-Postfachliste
  /// ([kRecipeMailboxListName]) mitliefern — nur für das Postfach selbst.
  /// Überall sonst (Listenwahl, Verwaltung, Setup, Einstellungen) bleibt sie
  /// unsichtbar.
  Future<List<Map<String, dynamic>>> fetchShoppingLists(
      {bool includeMailbox = false}) async {
    final resp = await _dio.get(_path('/api/households/shopping/lists'),
        queryParameters: {'perPage': -1});
    // Mealie usually returns {items: [...]} but some endpoints/versions
    // return a bare array — handle both rather than failing silently.
    final body = resp.data;
    final List items;
    if (body is List) {
      items = body;
    } else if (body is Map<String, dynamic>) {
      items = (body['items'] as List?) ?? const [];
    } else {
      items = const [];
    }
    return items
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .where((m) => includeMailbox || !isRecipeMailboxList(m))
        .toList();
  }

  /// Rezept als „verknüpftes Rezept" der Liste zählen (+1), OHNE Zutaten
  /// hinzuzufügen — die legt die App selbst an (1x-/Exakt-Modus). Leere
  /// `recipeIngredients` = Mealie fügt keine Artikel hinzu, erhöht aber den
  /// Rezept-Zähler der Liste (wie ein Webapp-„Zur Einkaufsliste").
  Future<void> addShoppingListRecipeReference(
      String listId, String recipeId) async {
    await _dio
        .post(_path('/api/households/shopping/lists/$listId/recipe'), data: [
      {
        'recipeId': recipeId,
        'recipeIncrementQuantity': 1,
        'recipeIngredients': <Object>[],
      }
    ]);
  }

  /// Rezept von der Liste nehmen (−1): Mealie zieht die Mengen dieses
  /// Rezepts von den offenen Artikeln ab und löscht leere — wie das „−" in
  /// der Webapp.
  Future<void> removeShoppingListRecipe(String listId, String recipeId) async {
    await _dio.post(
        _path('/api/households/shopping/lists/$listId/recipe/$recipeId/delete'),
        data: {'recipeDecrementQuantity': 1});
  }

  /// Einträge einer beliebigen Liste (roh) — für das Rezept-Postfach.
  Future<List<Map<String, dynamic>>> fetchShoppingListItemsRaw(
      String listId) async {
    final list = await fetchShoppingList(listId);
    return ((list['listItems'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  /// Freitext-Eintrag in einer beliebigen Liste anlegen (Rezept-Postfach).
  Future<void> addRawShoppingItem(String listId, String note) async {
    await _dio.post(_path('/api/households/shopping/items'), data: {
      'shoppingListId': listId,
      'note': note,
      'isFood': false,
      'quantity': 1,
      'checked': false,
    });
  }

  /// Vollständige Liste inkl. `listItems` und `labelSettings`.
  Future<Map<String, dynamic>> fetchShoppingList(String id) async {
    final resp = await _dio.get(_path('/api/households/shopping/lists/$id'));
    return Map<String, dynamic>.from(resp.data as Map);
  }

  Future<Map<String, dynamic>> createShoppingList(String name) async {
    final resp = await _dio
        .post(_path('/api/households/shopping/lists'), data: {'name': name});
    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// Umbenennen: PUT ersetzt die GANZE Liste (ShoppingListUpdate inkl.
  /// `listItems`) — deshalb wie die Webapp erst den vollständigen Stand laden
  /// und mitschicken, sonst wären danach alle Artikel weg.
  Future<Map<String, dynamic>> renameShoppingList(
      String id, String name) async {
    final full = await fetchShoppingList(id);
    final resp = await _dio.put(_path('/api/households/shopping/lists/$id'),
        data: {...full, 'name': name});
    return Map<String, dynamic>.from(resp.data as Map);
  }

  Future<void> deleteShoppingList(String id) async {
    await _dio.delete(_path('/api/households/shopping/lists/$id'));
  }

  /// Reihenfolge der Abteilungen (Labels) einer Liste. [settings] = die
  /// `labelSettings`-Einträge der Liste in der gewünschten Reihenfolge.
  Future<Map<String, dynamic>> updateShoppingListLabelOrder(
      String listId, List<Map<String, dynamic>> settings) async {
    final body = [
      for (var i = 0; i < settings.length; i++)
        {
          'id': settings[i]['id'],
          'shoppingListId': listId,
          'labelId': settings[i]['labelId'],
          'position': i,
        },
    ];
    final resp = await _dio.put(
        _path('/api/households/shopping/lists/$listId/label-settings'),
        data: body);
    return Map<String, dynamic>.from(resp.data as Map);
  }

  Future<List<ShoppingItem>> fetchShoppingItems() async {
    if (settings.shoppingListId.isEmpty) return [];
    final resp = await _dio.get(
      _path('/api/households/shopping/items'),
      queryParameters: {
        'shoppingListId': settings.shoppingListId,
        'perPage': 500,
      },
    );
    final data = resp.data as Map<String, dynamic>;
    final items = (data['items'] as List<dynamic>? ?? [])
        .map((e) => ShoppingItem.fromJson(e as Map<String, dynamic>))
        .toList();
    // Sicherheitsnetz: NICHT blind auf den Server-Query-Filter verlassen —
    // liefert er (Version/Proxy-abhängig) doch mal alle Haushalts-Listen
    // zurück, tauchen sonst Artikel fremder Listen in der App auf, sobald
    // mehrere Listen befüllt sind. Hart clientseitig auf die aktive Liste
    // filtern garantiert die Trennung unabhängig vom Server-Verhalten.
    return items
        .where((i) => i.shoppingListId == settings.shoppingListId)
        .toList();
  }

  Future<ShoppingItem> addShoppingItem(ShoppingItemCreate item) async {
    final resp = await _dio.post(
      _path('/api/households/shopping/items'),
      data: item.toJson(),
    );
    final data = resp.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
          'Unexpected shopping-item POST response: ${data.runtimeType}');
    }
    // Mealie v3 antwortet mit einem ItemsCollectionResponse-Wrapper:
    //   {"createdItems":[item], "updatedItems":[...], "deletedItems":[...]}
    // Mealie v2 antwortet mit dem rohen Item-Objekt.
    // Beide Varianten tolerieren, sonst fängt der Caller eine FormatException
    // und das frisch hinzugefügte Item taucht nie in der UI auf — der User
    // muss manuell refreshen.
    if (data.containsKey('createdItems') ||
        data.containsKey('updatedItems') ||
        data.containsKey('deletedItems')) {
      final created = data['createdItems'];
      if (created is List && created.isNotEmpty) {
        return ShoppingItem.fromJson(
            (created.first as Map).cast<String, dynamic>());
      }
      final updated = data['updatedItems'];
      if (updated is List && updated.isNotEmpty) {
        return ShoppingItem.fromJson(
            (updated.first as Map).cast<String, dynamic>());
      }
      throw const FormatException(
          'Mealie v3 returned an empty createdItems/updatedItems wrapper');
    }
    return ShoppingItem.fromJson(data);
  }

  // PUT mirrors iOS updateShoppingItem(_:) payload — mit einer bewussten
  // Abweichung: die note wird IMMER mitgeschickt, auch bei Food-Items.
  // iOS ließ sie bei gesetztem food weg; dann löscht der Server die note
  // beim ersten Quantity-/Check-Update. Früher egal (note == Food-Name,
  // displayName fiel unsichtbar auf food zurück) — mit „exakten Mengen"
  // steckt die Einheit in der note („g Butter") und ging so beim ersten
  // +/− verloren. Create setzt die note ebenfalls immer.
  Future<void> updateShoppingItem(ShoppingItem item) async {
    final payload = <String, dynamic>{
      'id': item.id,
      'shoppingListId': item.shoppingListId ?? settings.shoppingListId,
      'checked': item.checked,
      'note': item.note ?? '',
      'labelId': item.label?.id,
      'quantity': item.quantity ?? 1,
      'foodId': item.food?.id,
      'unitId': item.unit?.id,
      // isFood explizit mitschicken: nach einem Umbenennen (clearFood) muss
      // der Server das Item als Freitext-Artikel führen — ohne das Feld
      // bliebe serverseitig isFood=true mit food=null zurück und die Webapp
      // zeigte eine leere Artikelzeile.
      'isFood': item.isFood,
      // Rezept-Verknüpfungen unverändert zurückschicken — fehlen sie im PUT,
      // löscht Mealie sie (und damit das Rezept aus den verknüpften
      // Rezepten der Liste, auch bei Rezepten aus der Webapp).
      'recipeReferences': item.recipeReferences,
      // Ebenso Position (Reihenfolge in der Webapp, sonst 0) und Extras von
      // Integrationen (sonst {}) — Mealie ersetzt beim PUT das ganze Objekt.
      if (item.position != null) 'position': item.position,
      if (item.extras != null) 'extras': item.extras,
    };
    await _dio.put(
      _path('/api/households/shopping/items/${item.id}'),
      data: payload,
    );
  }

  Future<void> deleteShoppingItem(String itemId) async {
    await _dio.delete(_path('/api/households/shopping/items/$itemId'));
  }

  // Delete all checked items — mirrors iOS deleteShoppingItems(_:)
  Future<void> deleteCheckedItems(List<ShoppingItem> items) async {
    for (final item in items.where((i) => i.checked)) {
      try {
        await deleteShoppingItem(item.id);
      } catch (_) {}
    }
  }

  // Fetch labels from api/groups/labels — mirrors iOS fetchShoppingLabels()
  Future<List<ShoppingLabel>> fetchShoppingLabels() async {
    // perPage=-1: sonst paginiert Mealie auf 50 und größere Haushalte
    // verlören Abteilungen (Farben/Zuordnung).
    final resp = await _dio
        .get(_path('/api/groups/labels'), queryParameters: {'perPage': -1});
    final data = resp.data as Map<String, dynamic>;
    return (data['items'] as List<dynamic>? ?? [])
        .map((e) => ShoppingLabel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Neues Shopping-Label (Kategorie) inkl. Farbe anlegen.
  // POST /api/groups/labels  Body {name, color}. `color` ist ein Hex-String
  // (#RRGGBB); groupId setzt der Server selbst.
  Future<ShoppingLabel> createShoppingLabel(String name,
      {String? color}) async {
    final resp = await _dio.post(
      _path('/api/groups/labels'),
      data: {
        'name': name,
        if (color != null && color.isNotEmpty) 'color': color,
      },
    );
    return ShoppingLabel.fromJson(resp.data as Map<String, dynamic>);
  }

  // -------------------------------------------------------------------------
  // Cookbooks
  // -------------------------------------------------------------------------

  /// Alle Kochbücher des Haushalts. perPage=-1 → ALLE (sonst paginiert
  /// Mealie auf 50). Sortierung nach `position` macht der Aufrufer client-
  /// seitig — ein orderBy=position lehnen manche Mealie-Versionen ab.
  Future<List<CookbookSummary>> fetchCookbooks() async {
    final resp = await _dio.get(
      _path('/api/households/cookbooks'),
      queryParameters: {'perPage': -1},
    );
    // Wie fetchShoppingLists: {items:[…]} und rohe Arrays tolerieren.
    final body = resp.data;
    final List items;
    if (body is List) {
      items = body;
    } else if (body is Map<String, dynamic>) {
      items = (body['items'] as List?) ?? const [];
    } else {
      items = const [];
    }
    return items
        .whereType<Map>()
        .map((e) => CookbookSummary.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Rezept-Summaries über einen gespeicherten Kochbuch-Filter.
  /// GET /api/recipes?queryFilter=… — Antwort ist das bekannte
  /// {items:[RecipeSummary]}-Format. Der Filter-String wird OPAK an den
  /// Server durchgereicht (URL-Encoding übernimmt Dio via queryParameters);
  /// leerer Filter → Mealie liefert ALLE Rezepte (Webapp-Verhalten).
  /// perPage=-1 → EIN Request pro Kochbuch, egal wie groß es ist.
  Future<List<RecipeSummary>> fetchRecipeSummariesByQueryFilter(
      String queryFilter) async {
    final resp = await _dio.get(
      _path('/api/recipes'),
      queryParameters: {
        'perPage': -1,
        'orderBy': 'name',
        'orderDirection': 'asc',
        if (queryFilter.trim().isNotEmpty) 'queryFilter': queryFilter,
      },
    );
    final data = resp.data as Map<String, dynamic>;
    return (data['items'] as List<dynamic>? ?? [])
        .map((e) => RecipeSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // POST /api/households/cookbooks — mirrors die Webapp „Ein Kochbuch
  // erstellen"-Maske. Server vergibt id/slug/position selbst, daher werden
  // hier NUR die vom Nutzer gesetzten Felder geschickt.
  Future<CookbookSummary> createCookbook({
    required String name,
    String? description,
    String queryFilterString = '',
    bool public = false,
  }) async {
    final resp = await _dio.post(
      _path('/api/households/cookbooks'),
      data: {
        'name': name,
        'description': description ?? '',
        'queryFilterString': queryFilterString,
        'public': public,
      },
    );
    return CookbookSummary.fromJson(resp.data as Map<String, dynamic>);
  }

  // PUT /api/households/cookbooks/{id}. `position` bewusst NICHT
  // mitgeschickt — das ist reine Drag&Drop-Reihenfolge (in der App nicht
  // editierbar) und soll durch ein Bearbeiten nicht verändert werden.
  Future<CookbookSummary> updateCookbook(CookbookSummary cookbook) async {
    final resp = await _dio.put(
      _path('/api/households/cookbooks/${cookbook.id}'),
      data: {
        'id': cookbook.id,
        'name': cookbook.name,
        'description': cookbook.description ?? '',
        'queryFilterString': cookbook.queryFilterString,
        'public': cookbook.public,
        // PUT ersetzt das ganze Kochbuch — ohne Position fiele es auf 1
        // zurück und die Reihenfolge in der Webapp ginge verloren; den Slug
        // mitschicken, damit Links auf das Kochbuch stabil bleiben.
        'position': cookbook.position,
        if ((cookbook.slug ?? '').isNotEmpty) 'slug': cookbook.slug,
      },
    );
    return CookbookSummary.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<void> deleteCookbook(String id) async {
    await _dio.delete(_path('/api/households/cookbooks/$id'));
  }

  /// Werkzeuge (Organizer, wie Kategorien/Tags) — für den Kochbuch-Filter-
  /// Baustein „Utensilien". `onHand` gibt's nur am Rezept selbst, hier immer
  /// false (RecipeTool.fromJson deckt das fehlende Feld bereits ab).
  Future<List<RecipeTool>> fetchTools() async {
    final resp = await _dio
        .get(_path('/api/organizers/tools'), queryParameters: {'perPage': -1});
    final data = resp.data as Map<String, dynamic>;
    return (data['items'] as List<dynamic>? ?? [])
        .map((e) => RecipeTool.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Mealie „Rezept-Suche" (GET /api/recipes/suggestions) — dieselben
  /// Parameter wie die Webapp. Liefert die rohen `items`
  /// ({recipe, missingFoods, missingTools, substitutedFoods}).
  Future<List<Map<String, dynamic>>> fetchRecipeSuggestions({
    required List<String> foodIds,
    required List<String> toolIds,
    required int maxMissingFoods,
    required int maxMissingTools,
    required bool includeFoodsOnHand,
    required bool includeToolsOnHand,
    required bool includeSubstitutions,
    String queryFilter = '',
    int limit = 20,
  }) async {
    final resp = await _dio.get(
      _path('/api/recipes/suggestions'),
      queryParameters: {
        'limit': limit,
        if (queryFilter.isNotEmpty) 'queryFilter': queryFilter,
        'maxMissingFoods': maxMissingFoods,
        'maxMissingTools': maxMissingTools,
        'includeFoodsOnHand': includeFoodsOnHand,
        'includeToolsOnHand': includeToolsOnHand,
        'includeSubstitutions': includeSubstitutions,
        // Mehrfach-Parameter wie die Webapp: foods=a&foods=b
        if (foodIds.isNotEmpty) 'foods': ListParam(foodIds, ListFormat.multi),
        if (toolIds.isNotEmpty) 'tools': ListParam(toolIds, ListFormat.multi),
      },
    );
    final data = resp.data as Map<String, dynamic>;
    return (data['items'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
  }

  // -------------------------------------------------------------------------
  // Kommentare (POST/DELETE /api/comments; Löschen nur eigene bzw. als Admin)
  // -------------------------------------------------------------------------

  Future<RecipeComment> addRecipeComment(String recipeId, String text) async {
    final resp = await _dio.post(_path('/api/comments'),
        data: {'recipeId': recipeId, 'text': text});
    final c = RecipeComment.tryParse(resp.data);
    if (c == null) throw Exception('Invalid comment response');
    return c;
  }

  Future<void> deleteRecipeComment(String id) async {
    await _dio.delete(_path('/api/comments/$id'));
  }

  // -------------------------------------------------------------------------
  // Organizer-Verwaltung (Kategorien / Schlagworte / Utensilien)
  // -------------------------------------------------------------------------

  Future<List<OrganizerItem>> fetchOrganizers(OrganizerKind kind) async {
    final resp = await _dio.get(_path('/api/organizers/${kind.path}'),
        queryParameters: {'perPage': -1});
    final data = resp.data;
    final items = data is Map<String, dynamic>
        ? (data['items'] as List? ?? const [])
        : (data is List ? data : const []);
    return items
        .whereType<Map>()
        .map((e) => OrganizerItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<OrganizerItem> createOrganizer(OrganizerKind kind, String name) async {
    final resp = await _dio
        .post(_path('/api/organizers/${kind.path}'), data: {'name': name});
    return OrganizerItem.fromJson(Map<String, dynamic>.from(resp.data as Map));
  }

  /// PUT mit dem vollständigen Stand — bei Utensilien inkl.
  /// `householdsWithTool` (sonst setzt Mealie ihn auf leer zurück).
  Future<OrganizerItem> updateOrganizer(
      OrganizerKind kind, OrganizerItem item) async {
    final resp = await _dio.put(
      _path('/api/organizers/${kind.path}/${item.id}'),
      data: {
        'name': item.name,
        if (kind == OrganizerKind.tool)
          'householdsWithTool': item.householdsWithTool,
      },
    );
    return OrganizerItem.fromJson(Map<String, dynamic>.from(resp.data as Map));
  }

  Future<void> deleteOrganizer(OrganizerKind kind, String id) async {
    await _dio.delete(_path('/api/organizers/${kind.path}/$id'));
  }

  // -------------------------------------------------------------------------
  // Benutzerverwaltung (Admin: /api/admin/users; Haushalt: /api/households)
  // -------------------------------------------------------------------------

  List<Map<String, dynamic>> _items(dynamic body) {
    final List items = body is List
        ? body
        : (body is Map ? (body['items'] as List? ?? const []) : const []);
    return items
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  /// Alle Benutzer (nur Admins). `_path` bildet /api/users auf die v3-Route
  /// /api/admin/users ab.
  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    final resp = await _dio.get(_path('/api/users'),
        queryParameters: {'perPage': -1, 'orderBy': 'fullName'});
    return _items(resp.data);
  }

  Future<Map<String, dynamic>> fetchUser(String id) async {
    final resp = await _dio.get(_path('/api/users/$id'));
    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// Anlegen (UserIn): username, fullName, email, password, admin, group,
  /// household (NAMEN), advanced, can* — 409 bei doppeltem Namen/E-Mail.
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> data) async {
    final resp = await _dio.post(_path('/api/users'), data: data);
    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// PUT verlangt das ganze UserOut-Objekt → vollständigen Stand schicken.
  /// Der Server verbietet, sich selbst die Admin-Rechte zu entziehen (403).
  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> full) async {
    final resp = await _dio.put(_path('/api/users/${full['id']}'), data: full);
    return Map<String, dynamic>.from(resp.data as Map);
  }

  Future<void> deleteUser(String id) async {
    await _dio.delete(_path('/api/users/$id'));
  }

  /// Nach zu vielen Fehlversuchen gesperrte Benutzer entsperren → Anzahl.
  Future<int> unlockLockedUsers() async {
    final resp = await _dio
        .post(_path('/api/users/unlock'), queryParameters: {'force': true});
    final data = resp.data;
    return data is Map ? ((data['unlocked'] as num?)?.toInt() ?? 0) : 0;
  }

  /// Token für „Link zum Zurücksetzen des Passworts" (Webapp:
  /// {server}/reset-password/?token=…).
  Future<String> createPasswordResetToken(String email) async {
    final resp = await _dio
        .post(_path('/api/users/password-reset-token'), data: {'email': email});
    return (resp.data as Map)['token'].toString();
  }

  /// Profilbild hochladen (multipart `profile`). Mealie erlaubt das für das
  /// eigene Profil und Admins für alle. Bewusst OHNE `_path` — die Route
  /// liegt in jeder Version unter /api/users/{id}/image (nicht /admin).
  Future<void> uploadUserImage(String userId, List<int> bytes,
      {String filename = 'profile.jpg'}) async {
    final formData = FormData.fromMap(
        {'profile': MultipartFile.fromBytes(bytes, filename: filename)});
    await _dio.post('/api/users/$userId/image',
        data: formData, options: Options(contentType: 'multipart/form-data'));
  }

  /// Eigenes Konto speichern (jeder Benutzer). Mealie: PUT /api/users/{id}
  /// mit dem VOLLEN Benutzer — Rechte, Gruppe und Haushalt müssen
  /// unverändert mitkommen, sonst 403. Bewusst OHNE `_path()`: dieser
  /// Endpunkt bleibt auch in v3 unter /api/users (Admin-API nur für andere).
  Future<Map<String, dynamic>> updateSelf(Map<String, dynamic> changes) async {
    final full = await fetchCurrentUser();
    await _dio.put('/api/users/${full['id']}', data: {...full, ...changes});
    return fetchCurrentUser();
  }

  /// Eigenes Passwort ändern (wie Profil → Passwort ändern in der Webapp).
  /// Mealie prüft das aktuelle Passwort; bei LDAP lehnt es ab.
  Future<void> changeOwnPassword(String current, String next) async {
    await _dio.put('/api/users/password',
        data: {'currentPassword': current, 'newPassword': next});
  }

  /// Rechte eines Haushaltsmitglieds setzen (Recht „Verwalten" nötig; die
  /// eigenen Rechte lehnt der Server ab).
  Future<Map<String, dynamic>> setMemberPermissions(String userId,
      {required bool canManageHousehold,
      required bool canManage,
      required bool canInvite,
      required bool canOrganize}) async {
    final resp = await _dio.put(_path('/api/households/permissions'), data: {
      'userId': userId,
      'canManageHousehold': canManageHousehold,
      'canManage': canManage,
      'canInvite': canInvite,
      'canOrganize': canOrganize,
    });
    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// Einladungs-Token (Webapp: {server}/register?token=…).
  Future<String> createInviteToken({int uses = 1}) async {
    final resp = await _dio
        .post(_path('/api/households/invitations'), data: {'uses': uses});
    return (resp.data as Map)['token'].toString();
  }

  /// Einladung per E-Mail (braucht SMTP in Mealie). true = verschickt.
  Future<bool> sendInviteEmail(String email, String token) async {
    final resp = await _dio.post(_path('/api/households/invitations/email'),
        data: {'email': email, 'token': token});
    final data = resp.data;
    return data is Map && data['success'] == true;
  }

  // -------------------------------------------------------------------------
  // Haushalte & Gruppen (Admin: /api/admin/…) und eigene Einstellungen
  // -------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> fetchAdminHouseholds() async {
    final resp = await _dio.get(_path('/api/admin/households'),
        queryParameters: {'perPage': -1, 'orderBy': 'name'});
    return _items(resp.data);
  }

  Future<Map<String, dynamic>> createHousehold(
      {required String name, required String groupId}) async {
    final resp = await _dio.post(_path('/api/admin/households'),
        data: {'name': name, 'groupId': groupId});
    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// UpdateHouseholdAdmin: id, groupId, name (+ optional preferences).
  Future<Map<String, dynamic>> updateHouseholdAdmin(
      {required String id,
      required String groupId,
      required String name,
      Map<String, dynamic>? preferences}) async {
    final resp = await _dio.put(_path('/api/admin/households/$id'), data: {
      'id': id,
      'groupId': groupId,
      'name': name,
      if (preferences != null) 'preferences': preferences,
    });
    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// 400, solange der Haushalt noch Benutzer hat.
  Future<void> deleteHousehold(String id) async {
    await _dio.delete(_path('/api/admin/households/$id'));
  }

  Future<List<Map<String, dynamic>>> fetchAdminGroups() async {
    final resp = await _dio.get(_path('/api/admin/groups'),
        queryParameters: {'perPage': -1, 'orderBy': 'name'});
    return _items(resp.data);
  }

  Future<Map<String, dynamic>> createGroup(String name) async {
    final resp =
        await _dio.post(_path('/api/admin/groups'), data: {'name': name});
    return Map<String, dynamic>.from(resp.data as Map);
  }

  Future<Map<String, dynamic>> updateGroupAdmin(
      {required String id,
      required String name,
      Map<String, dynamic>? preferences}) async {
    final resp = await _dio.put(_path('/api/admin/groups/$id'), data: {
      'id': id,
      'name': name,
      if (preferences != null) 'preferences': preferences,
    });
    return Map<String, dynamic>.from(resp.data as Map);
  }

  Future<void> deleteGroup(String id) async {
    await _dio.delete(_path('/api/admin/groups/$id'));
  }

  /// Einstellungen des EIGENEN Haushalts (Ändern: Recht „Haushalt
  /// verwalten").
  Future<Map<String, dynamic>> fetchHouseholdPreferences() async {
    final resp = await _dio.get(_path('/api/households/preferences'));
    return Map<String, dynamic>.from(resp.data as Map);
  }

  Future<Map<String, dynamic>> updateHouseholdPreferences(
      Map<String, dynamic> prefs) async {
    final resp =
        await _dio.put(_path('/api/households/preferences'), data: prefs);
    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// Einstellungen der EIGENEN Gruppe (Ändern: Recht „Verwalten").
  Future<Map<String, dynamic>> fetchGroupPreferences() async {
    final resp = await _dio.get(_path('/api/groups/preferences'));
    return Map<String, dynamic>.from(resp.data as Map);
  }

  Future<Map<String, dynamic>> updateGroupPreferences(
      Map<String, dynamic> prefs) async {
    final resp = await _dio.put(_path('/api/groups/preferences'), data: prefs);
    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// Mitglieder des aktuellen Haushalts — für den Kochbuch-Filter-Baustein
  /// „Benutzer" (Rezepte gefiltert nach Ersteller). Tolerant wie
  /// fetchShoppingLists/fetchHouseholds gegenüber {items:[…]} und rohen
  /// Arrays.
  Future<List<Map<String, dynamic>>> fetchHouseholdMembers() async {
    final resp = await _dio.get(
      _path('/api/households/members'),
      queryParameters: {'perPage': -1},
    );
    final body = resp.data;
    final List items;
    if (body is List) {
      items = body;
    } else if (body is Map<String, dynamic>) {
      items = (body['items'] as List?) ?? const [];
    } else {
      items = const [];
    }
    return items
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  // -------------------------------------------------------------------------
  // Meal plan
  // -------------------------------------------------------------------------

  // Fetch ALL mealplan entries (no date filter) — mirrors iOS fetchMealplanEntries()
  // Needed for the "entries in other weeks" feature.
  Future<List<MealplanEntry>> fetchAllMealplanEntries() async {
    final resp = await _dio.get(
      _path('/api/households/mealplans'),
      queryParameters: {'perPage': 1000, 'orderBy': 'date'},
    );
    final data = resp.data as Map<String, dynamic>;
    return (data['items'] as List<dynamic>? ?? [])
        .map((e) => MealplanEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MealplanEntry> createMealplanEntry(MealplanEntryCreate entry) async {
    final resp = await _dio.post(
      _path('/api/households/mealplans'),
      data: entry.toJson(),
    );
    return MealplanEntry.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<void> deleteMealplanEntry(String entryId) async {
    await _dio.delete(_path('/api/households/mealplans/$entryId'));
  }

  // -------------------------------------------------------------------------
  // Mahlzeitenplan-Regeln (Zufallsrezepte) — /api/households/mealplans/rules
  // -------------------------------------------------------------------------

  Future<List<MealPlanRule>> fetchMealplanRules() async {
    final resp = await _dio.get(
      _path('/api/households/mealplans/rules'),
      queryParameters: {'perPage': -1},
    );
    final body = resp.data;
    final items = body is Map
        ? (body['items'] as List? ?? const [])
        : (body is List ? body : const []);
    return items.map(MealPlanRule.tryParse).whereType<MealPlanRule>().toList();
  }

  Future<MealPlanRule> createMealplanRule(MealPlanRule rule) async {
    final resp = await _dio.post(_path('/api/households/mealplans/rules'),
        data: rule.toCreateJson());
    return MealPlanRule.tryParse(resp.data) ?? rule;
  }

  Future<MealPlanRule> updateMealplanRule(MealPlanRule rule) async {
    final resp = await _dio.put(
        _path('/api/households/mealplans/rules/${rule.id}'),
        data: rule.toCreateJson());
    return MealPlanRule.tryParse(resp.data) ?? rule;
  }

  Future<void> deleteMealplanRule(String id) async {
    await _dio.delete(_path('/api/households/mealplans/rules/$id'));
  }

  // -------------------------------------------------------------------------
  // Zeitleiste — /api/recipes/timeline/events (wie die Webapp)
  // -------------------------------------------------------------------------

  /// Einträge, neueste zuerst. [recipeId] gesetzt = nur dieses Rezept
  /// (queryFilter `recipe_id="…"` wie die Rezeptseite der Webapp), sonst die
  /// Zeitleiste aller Rezepte seitenweise ([page] ab 1).
  Future<List<TimelineEvent>> fetchTimelineEvents(
      {String? recipeId, int page = 1, int perPage = 50}) async {
    final resp = await _dio.get(
      _path('/api/recipes/timeline/events'),
      queryParameters: {
        'page': page,
        'perPage': perPage,
        'orderBy': 'timestamp',
        'orderDirection': 'desc',
        if (recipeId != null) 'queryFilter': 'recipe_id="$recipeId"',
      },
    );
    final body = resp.data;
    final items = body is Map ? (body['items'] as List? ?? const []) : const [];
    return items
        .map(TimelineEvent.tryParse)
        .whereType<TimelineEvent>()
        .toList();
  }

  Future<TimelineEvent> createTimelineEvent({
    required String recipeId,
    required String subject,
    String eventType = 'comment',
    String? message,
    DateTime? timestamp,
  }) async {
    final resp = await _dio.post(_path('/api/recipes/timeline/events'), data: {
      'recipeId': recipeId,
      'subject': subject,
      'eventType': eventType,
      if (message != null && message.trim().isNotEmpty)
        'eventMessage': message.trim(),
      'timestamp': (timestamp ?? DateTime.now()).toUtc().toIso8601String(),
    });
    final ev = TimelineEvent.tryParse(resp.data);
    if (ev == null) throw StateError('Timeline event without id');
    return ev;
  }

  /// PUT verlangt Betreff + Text (RecipeTimelineEventUpdate).
  Future<void> updateTimelineEvent(TimelineEvent event) async {
    await _dio.put(_path('/api/recipes/timeline/events/${event.id}'), data: {
      'subject': event.subject,
      'eventMessage': event.message,
    });
  }

  Future<void> deleteTimelineEvent(String id) async {
    await _dio.delete(_path('/api/recipes/timeline/events/$id'));
  }

  /// Foto zu einem Eintrag (multipart `image` + `extension`, wie die Webapp).
  Future<void> uploadTimelineEventImage(String eventId, File image) async {
    final ext = _extensionOf(image.path, fallback: 'jpg');
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path, filename: 'image.$ext'),
      'extension': ext,
    });
    await _dio.put(
      _path('/api/recipes/timeline/events/$eventId/image'),
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  static String _extensionOf(String path, {String fallback = ''}) {
    final name = path.split('/').last;
    final dot = name.lastIndexOf('.');
    if (dot < 0 || dot == name.length - 1) return fallback;
    return name.substring(dot + 1).toLowerCase();
  }

  // -------------------------------------------------------------------------
  // Rezept-Anhänge — POST /api/recipes/{slug}/assets (multipart)
  // -------------------------------------------------------------------------

  /// Lädt [file] als Anhang hoch. Neuere Mealie-Versionen tragen ihn selbst
  /// im Rezept ein; ältere schreiben nur die Datei — dann ergänzt der
  /// Aufrufer die `assets`-Liste per PATCH (siehe recipe_assets_sync.dart).
  Future<RecipeAsset> uploadRecipeAsset(String slug,
      {required File file, required String name, required String icon}) async {
    final ext = _extensionOf(file.path);
    final formData = FormData.fromMap({
      'name': name,
      'icon': icon,
      'extension': ext,
      'file': await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last),
    });
    final resp = await _dio.post(
      _path('/api/recipes/$slug/assets'),
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    final asset = RecipeAsset.tryParse(resp.data);
    if (asset == null) throw StateError('Asset upload without fileName');
    return asset;
  }

  /// Anhang-Liste des Rezepts ersetzen (Teil-PATCH). Löschen = Liste ohne
  /// den Eintrag — wie die Webapp (die Datei bleibt auf dem Server liegen).
  Future<void> updateRecipeAssets(String id, List<RecipeAsset> assets,
      {RecipeSettings? settings}) async {
    await updateRecipe(id, {
      'assets': assets.map((a) => a.toJson()).toList(),
      if (settings != null) 'settings': settings.toJson(),
    });
  }

  /// Lädt eine Datei vom Server (mit den Auth-/Zusatz-Headern) nach [target].
  Future<void> downloadToFile(String path, String target) async {
    await _dio.download(path, target);
  }

  // -------------------------------------------------------------------------
  // Lebensmittel & Einheiten verwalten
  // -------------------------------------------------------------------------

  /// PUT ersetzt das GANZE Objekt (CreateIngredientFood/-Unit) — deshalb den
  /// vollständigen Server-Stand [raw] mit den Änderungen schicken, sonst
  /// gingen Aliase, Label, Haushalte usw. verloren.
  Future<Map<String, dynamic>> updateFood(Map<String, dynamic> raw) async {
    final resp = await _dio.put(_path('/api/foods/${raw['id']}'), data: raw);
    return Map<String, dynamic>.from(resp.data as Map);
  }

  Future<void> deleteFood(String id) async {
    await _dio.delete(_path('/api/foods/$id'));
  }

  /// Führt [fromId] in [toId] zusammen: alle Verwendungen zeigen danach auf
  /// [toId], [fromId] wird gelöscht.
  Future<void> mergeFoods(String fromId, String toId) async {
    await _dio.put(_path('/api/foods/merge'),
        data: {'fromFood': fromId, 'toFood': toId});
  }

  Future<Map<String, dynamic>> updateUnit(Map<String, dynamic> raw) async {
    final resp = await _dio.put(_path('/api/units/${raw['id']}'), data: raw);
    return Map<String, dynamic>.from(resp.data as Map);
  }

  Future<void> deleteUnit(String id) async {
    await _dio.delete(_path('/api/units/$id'));
  }

  Future<void> mergeUnits(String fromId, String toId) async {
    await _dio.put(_path('/api/units/merge'),
        data: {'fromUnit': fromId, 'toUnit': toId});
  }

  /// Anlegen mit allen Feldern (die bestehenden createFood/createUnit kennen
  /// nur den Namen).
  Future<Map<String, dynamic>> createFoodFull(Map<String, dynamic> data) async {
    final resp = await _dio.post(_path('/api/foods'), data: data);
    return Map<String, dynamic>.from(resp.data as Map);
  }

  Future<Map<String, dynamic>> createUnitFull(Map<String, dynamic> data) async {
    final resp = await _dio.post(_path('/api/units'), data: data);
    return Map<String, dynamic>.from(resp.data as Map);
  }

  // =========================================================================
  // Webapp-Werkzeuge (Desktop: Windows/macOS) — Massenimport, ZIP-Import,
  // Migrationen, Berichte, Rezeptdaten-Massenaktionen + Exporte, Duplizieren,
  // Freigabe-Links, Rezept-Export, Webhooks, Benachrichtigungen,
  // Rezept-Aktionen und Administration. Endpunkte/Schemas 1:1 aus
  // mealie-next (3.28): routes/* + frontend/app/lib/api/*.
  // =========================================================================

  Map<String, dynamic> _map(dynamic data) =>
      data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};

  /// POST /api/recipes/create/url/bulk — läuft im Hintergrund des Servers,
  /// Fortschritt/Ergebnis im Bericht (Kategorie `bulk_import`).
  /// [imports]: `{url, categories?: [{id,name,slug}], tags?: [...]}`.
  Future<String?> bulkImportUrls(List<Map<String, dynamic>> imports) async {
    final resp = await _dio.post(_path('/api/recipes/create/url/bulk'),
        data: {'imports': imports});
    return _map(resp.data)['reportId']?.toString();
  }

  /// POST /api/recipes/create/zip — ein aus Mealie exportiertes Rezept
  /// (.zip). Liefert den Slug des neuen Rezepts.
  Future<String> importRecipeZip(List<int> bytes, String filename) async {
    final resp = await _dio.post(
      _path('/api/recipes/create/zip'),
      data: FormData.fromMap(
          {'archive': MultipartFile.fromBytes(bytes, filename: filename)}),
      options: Options(contentType: 'multipart/form-data'),
    );
    return resp.data?.toString().replaceAll('"', '') ?? '';
  }

  /// POST /api/groups/migrations (multipart) — Import aus anderen Apps.
  Future<Map<String, dynamic>> startMigration({
    required String type,
    required List<int> bytes,
    required String filename,
    required bool addMigrationTag,
  }) async {
    final resp = await _dio.post(
      _path('/api/groups/migrations'),
      data: FormData.fromMap({
        'add_migration_tag': addMigrationTag.toString(),
        'migration_type': type,
        'archive': MultipartFile.fromBytes(bytes, filename: filename),
      }),
      options: Options(
        contentType: 'multipart/form-data',
        // Große Archive brauchen beim Server länger als 30 s.
        receiveTimeout: const Duration(minutes: 10),
        sendTimeout: const Duration(minutes: 10),
      ),
    );
    return _map(resp.data);
  }

  /// GET /api/groups/reports[?report_type=…] (backup|restore|migration|
  /// bulk_import).
  Future<List<Map<String, dynamic>>> fetchReports({String? type}) async {
    final resp = await _dio.get(_path('/api/groups/reports'),
        queryParameters: {if (type != null) 'report_type': type});
    return _items(resp.data);
  }

  Future<Map<String, dynamic>> fetchReport(String id) async =>
      _map((await _dio.get(_path('/api/groups/reports/$id'))).data);

  Future<void> deleteReport(String id) async =>
      _dio.delete(_path('/api/groups/reports/$id'));

  // ── Massenaktionen (Rezeptdaten) — `recipes` = Slugs ─────────────────────

  Future<void> bulkTagRecipes(
          List<String> slugs, List<Map<String, dynamic>> tags) async =>
      _dio.post(_path('/api/recipes/bulk-actions/tag'),
          data: {'recipes': slugs, 'tags': tags});

  Future<void> bulkCategorizeRecipes(
          List<String> slugs, List<Map<String, dynamic>> categories) async =>
      _dio.post(_path('/api/recipes/bulk-actions/categorize'),
          data: {'recipes': slugs, 'categories': categories});

  /// Ersetzt die KOMPLETTEN Rezept-Einstellungen der gewählten Rezepte
  /// (public, showNutrition, showAssets, landscapeView, disableComments,
  /// locked) — wie die Webapp.
  Future<void> bulkSetRecipeSettings(
          List<String> slugs, Map<String, bool> settings) async =>
      _dio.post(_path('/api/recipes/bulk-actions/settings'),
          data: {'recipes': slugs, 'settings': settings});

  Future<void> bulkDeleteRecipes(List<String> slugs) async =>
      _dio.post(_path('/api/recipes/bulk-actions/delete'),
          data: {'recipes': slugs});

  Future<void> bulkExportRecipes(List<String> slugs) async =>
      _dio.post(_path('/api/recipes/bulk-actions/export'),
          data: {'recipes': slugs, 'exportType': 'json'});

  Future<List<Map<String, dynamic>>> fetchRecipeExports() async =>
      _items((await _dio.get(_path('/api/recipes/bulk-actions/export'))).data);

  Future<void> purgeRecipeExports() async =>
      _dio.delete(_path('/api/recipes/bulk-actions/export/purge'));

  /// Datei eines Gruppen-Exports laden (Token → /api/utils/download).
  Future<List<int>> downloadRecipeExport(String exportId) async {
    final resp = await _dio
        .get(_path('/api/recipes/bulk-actions/export/$exportId/download'));
    return _downloadFileToken(_map(resp.data)['fileToken']?.toString() ?? '');
  }

  Future<List<int>> _downloadFileToken(String token) async {
    if (token.isEmpty) throw const FormatException('Missing file token');
    final resp = await _dio.get<List<int>>(
      _path('/api/utils/download'),
      queryParameters: {'token': token},
      options: Options(
        responseType: ResponseType.bytes,
        receiveTimeout: const Duration(minutes: 10),
      ),
    );
    return resp.data ?? const [];
  }

  // ── Einzelnes Rezept ─────────────────────────────────────────────────────

  /// POST /api/recipes/{slug}/duplicate — liefert das neue Rezept (roh).
  Future<Map<String, dynamic>> duplicateRecipe(String slug,
      {String? name}) async {
    final resp = await _dio.post(_path('/api/recipes/$slug/duplicate'),
        data: {'name': (name?.trim().isEmpty ?? true) ? null : name!.trim()});
    return _map(resp.data);
  }

  /// GET /api/recipes/{slug}/exports?template_name=raw|zip — Datei-Bytes.
  Future<List<int>> exportRecipeFile(String slug, String template) async {
    final resp = await _dio.get<List<int>>(
      _path('/api/recipes/$slug/exports'),
      queryParameters: {'template_name': template},
      options: Options(responseType: ResponseType.bytes),
    );
    return resp.data ?? const [];
  }

  Future<List<Map<String, dynamic>>> fetchShareTokens(String recipeId) async =>
      _items((await _dio.get(_path('/api/shared/recipes'),
              queryParameters: {'recipe_id': recipeId}))
          .data);

  Future<Map<String, dynamic>> createShareToken(
      String recipeId, DateTime expiresAt) async {
    final resp = await _dio.post(_path('/api/shared/recipes'), data: {
      'recipeId': recipeId,
      'expiresAt': expiresAt.toUtc().toIso8601String(),
    });
    return _map(resp.data);
  }

  Future<void> deleteShareToken(String id) async =>
      _dio.delete(_path('/api/shared/recipes/$id'));

  // ── Haushalt: Webhooks / Benachrichtigungen / Rezept-Aktionen ───────────

  Future<List<Map<String, dynamic>>> fetchWebhooks() async =>
      _items((await _dio.get(_path('/api/households/webhooks'),
              queryParameters: {'perPage': -1}))
          .data);

  /// [data]: `{enabled, name, url, webhookType: 'mealplan', scheduledTime}`
  /// (`scheduledTime` = UTC „HH:MM").
  Future<void> saveWebhook(Map<String, dynamic> data, {String? id}) async {
    if (id == null) {
      await _dio.post(_path('/api/households/webhooks'), data: data);
    } else {
      await _dio.put(_path('/api/households/webhooks/$id'), data: data);
    }
  }

  Future<void> deleteWebhook(String id) async =>
      _dio.delete(_path('/api/households/webhooks/$id'));

  Future<void> testWebhook(String id) async =>
      _dio.post(_path('/api/households/webhooks/$id/test'), data: {});

  Future<List<Map<String, dynamic>>> fetchNotifiers() async =>
      _items((await _dio.get(_path('/api/households/events/notifications'),
              queryParameters: {'perPage': -1}))
          .data);

  /// POST {name, appriseUrl} — Mealie legt alle Ereignisse AUS an.
  Future<Map<String, dynamic>> createNotifier(
          String name, String appriseUrl) async =>
      _map((await _dio.post(_path('/api/households/events/notifications'),
              data: {'name': name, 'appriseUrl': appriseUrl}))
          .data);

  /// PUT GroupEventNotifierUpdate (ganzes Objekt). `appriseUrl: null`
  /// behält die gespeicherte URL (Server liefert sie nie aus).
  Future<void> updateNotifier(Map<String, dynamic> full) async =>
      _dio.put(_path('/api/households/events/notifications/${full['id']}'),
          data: full);

  Future<void> deleteNotifier(String id) async =>
      _dio.delete(_path('/api/households/events/notifications/$id'));

  Future<void> testNotifier(String id) async => _dio
      .post(_path('/api/households/events/notifications/$id/test'), data: {});

  Future<List<Map<String, dynamic>>> fetchRecipeActions() async =>
      _items((await _dio
              .get(_path('/api/households/recipe-actions'), queryParameters: {
        'perPage': -1,
        'orderBy': 'title',
        'orderDirection': 'asc',
      }))
          .data);

  /// Neu: `{actionType, title, url}`; ändern: ganzes Objekt inkl.
  /// groupId/householdId (Mealie: SaveGroupRecipeAction).
  Future<void> saveRecipeAction(Map<String, dynamic> data, {String? id}) async {
    if (id == null) {
      await _dio.post(_path('/api/households/recipe-actions'), data: data);
    } else {
      await _dio.put(_path('/api/households/recipe-actions/$id'), data: data);
    }
  }

  Future<void> deleteRecipeAction(String id) async =>
      _dio.delete(_path('/api/households/recipe-actions/$id'));

  /// „Post"-Aktion: der Server sendet das Rezept an die hinterlegte URL.
  Future<void> triggerRecipeAction(
          String id, String recipeSlug, double scale) async =>
      _dio.post(_path('/api/households/recipe-actions/$id/trigger/$recipeSlug'),
          data: {'recipe_scale': scale});

  // ── Administration ───────────────────────────────────────────────────────

  Future<Map<String, dynamic>> fetchAdminAbout() async =>
      _map((await _dio.get(_path('/api/admin/about'))).data);

  Future<Map<String, dynamic>> fetchAdminStatistics() async =>
      _map((await _dio.get(_path('/api/admin/about/statistics'))).data);

  Future<Map<String, dynamic>> fetchAdminConfigCheck() async =>
      _map((await _dio.get(_path('/api/admin/about/check'))).data);

  /// POST /api/admin/email {email} → `{success, error?}`.
  Future<Map<String, dynamic>> sendTestEmail(String email) async =>
      _map((await _dio.post(_path('/api/admin/email'), data: {'email': email}))
          .data);

  /// `{imports: [{name, date, size}], templates: [...]}`.
  Future<Map<String, dynamic>> fetchBackups() async =>
      _map((await _dio.get(_path('/api/admin/backups'))).data);

  Future<void> createBackup() async => _dio.post(_path('/api/admin/backups'),
      data: {}, options: Options(receiveTimeout: const Duration(minutes: 10)));

  Future<void> deleteBackup(String name) async =>
      _dio.delete(_path('/api/admin/backups/${Uri.encodeComponent(name)}'));

  Future<List<int>> downloadBackup(String name) async {
    final resp = await _dio
        .get(_path('/api/admin/backups/${Uri.encodeComponent(name)}'));
    return _downloadFileToken(_map(resp.data)['fileToken']?.toString() ?? '');
  }

  Future<void> uploadBackup(List<int> bytes, String filename) async =>
      _dio.post(
        _path('/api/admin/backups/upload'),
        data: FormData.fromMap(
            {'archive': MultipartFile.fromBytes(bytes, filename: filename)}),
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(minutes: 10),
          receiveTimeout: const Duration(minutes: 10),
        ),
      );

  /// Überschreibt ALLE Daten des Servers mit der Sicherung.
  Future<void> restoreBackup(String name) async => _dio.post(
      _path('/api/admin/backups/${Uri.encodeComponent(name)}/restore'),
      data: {},
      options: Options(receiveTimeout: const Duration(minutes: 15)));

  /// `{dataDirSize, cleanableImages, cleanableDirs}`.
  Future<Map<String, dynamic>> fetchMaintenanceSummary() async =>
      _map((await _dio.get(_path('/api/admin/maintenance'))).data);

  /// `{tempDirSize, backupsDirSize, groupsDirSize, recipesDirSize,
  /// userDirSize}`.
  Future<Map<String, dynamic>> fetchMaintenanceStorage() async =>
      _map((await _dio.get(_path('/api/admin/maintenance/storage'))).data);

  // ── KI-Anbieter (Mealie 3.28, Gruppe; Recht „Verwalten") ────────────────

  /// `{defaultProviderId, audioProviderId, imageProviderId, providers:
  /// [{id, name}], aiEnabled, …}`.
  Future<Map<String, dynamic>> fetchAiProviderSettings() async =>
      _map((await _dio.get(_path('/api/groups/ai-providers/settings'))).data);

  Future<Map<String, dynamic>> updateAiProviderSettings(
          {String? defaultId, String? audioId, String? imageId}) async =>
      _map((await _dio.put(_path('/api/groups/ai-providers/settings'), data: {
        'defaultProviderId': defaultId,
        'audioProviderId': audioId,
        'imageProviderId': imageId,
      }))
          .data);

  /// Ohne API-Schlüssel (den liefert Mealie nie aus).
  Future<Map<String, dynamic>> fetchAiProvider(String id) async => _map(
      (await _dio.get(_path('/api/groups/ai-providers/providers/$id'))).data);

  /// [data]: `{name, model, apiKey, baseUrl, timeout, requestHeaders,
  /// requestParams}` — beim Ändern leerer `apiKey` = gespeicherten behalten.
  Future<void> saveAiProvider(Map<String, dynamic> data, {String? id}) async {
    if (id == null) {
      await _dio.post(_path('/api/groups/ai-providers/providers'), data: data);
    } else {
      await _dio.put(_path('/api/groups/ai-providers/providers/$id'),
          data: data);
    }
  }

  Future<void> deleteAiProvider(String id) async =>
      _dio.delete(_path('/api/groups/ai-providers/providers/$id'));

  /// Verbindung testen: ungespeichert (ganze Konfiguration) bzw. gespeichert
  /// mit optionalen ungespeicherten Änderungen. → `{success, message,
  /// supportsImages}`.
  Future<Map<String, dynamic>> testAiProvider(Map<String, dynamic> data,
      {String? savedId}) async {
    final path = savedId == null
        ? '/api/groups/ai-providers/providers/test'
        : '/api/groups/ai-providers/providers/$savedId/test';
    final resp = await _dio.post(_path(path),
        data: data,
        options: Options(receiveTimeout: const Duration(minutes: 6)));
    return _map(resp.data);
  }

  /// Admin-Debug (/admin/debug/openai/{id}) mit optionalem Testbild →
  /// `{success, response}`.
  Future<Map<String, dynamic>> debugAiProvider(String providerId,
      {List<int>? imageBytes, String? imageName}) async {
    final resp = await _dio.post(
      _path('/api/admin/debug/openai/$providerId'),
      data: imageBytes == null
          ? null
          : FormData.fromMap({
              'image': MultipartFile.fromBytes(imageBytes,
                  filename: imageName ?? 'image.jpg'),
            }),
      options: Options(
        contentType: imageBytes == null ? null : 'multipart/form-data',
        receiveTimeout: const Duration(minutes: 6),
      ),
    );
    return _map(resp.data);
  }

  /// [what]: images | temp | recipe-folders. Liefert die Server-Meldung.
  Future<String?> runMaintenanceClean(String what) async {
    final resp = await _dio.post(_path('/api/admin/maintenance/clean/$what'),
        data: {}, options: Options(receiveTimeout: const Duration(minutes: 5)));
    return _map(resp.data)['message']?.toString();
  }
}

/// Fehler aus dem KI-Import. [message] kommt übersetzt vom Server (z. B.
/// „KI ist nicht aktiviert"); `null` = unbekannter Fehler.
class AiImportException implements Exception {
  const AiImportException(this.message);
  final String? message;

  @override
  String toString() => message ?? 'AI import failed';
}

/// Lesbare Fehlermeldung aus einer Mealie-Antwort (`{"detail": {"message":
/// …}}` bzw. `{"detail": "…"}`), sonst `null`.
String? mealieErrorMessage(Object error) {
  if (error is AiImportException) return error.message;
  if (error is! DioException) return null;
  final data = error.response?.data;
  // 403 = Mealie verweigert die Aktion (Rechte) — statt der englischen
  // Server-Meldung einen übersetzten, erklärenden Text liefern.
  if (error.response?.statusCode == 403) {
    final l = currentAppL10n;
    if (l != null) {
      final raw = (data is Map ? data['detail'] : null)?.toString() ?? '';
      if (raw.contains('delete this recipe') ||
          raw.contains('delete all of these recipes')) {
        return l.noPermissionDeleteRecipe;
      }
      if (raw.contains('edit this recipe') || raw.contains('lock/unlock')) {
        return l.noPermissionEditRecipe;
      }
      if (raw.contains('demote yourself')) return l.noPermissionDemoteSelf;
      return l.noPermissionGeneric;
    }
  }
  if (data is Map) {
    final detail = data['detail'];
    final msg = detail is Map ? detail['message']?.toString() : null;
    // Haushalt/Gruppe mit Benutzern lässt Mealie nicht löschen.
    if (msg != null && msg.contains('with users') && currentAppL10n != null) {
      return currentAppL10n!.cannotDeleteWithUsers;
    }
    if (detail is Map && detail['message'] is String) {
      return detail['message'] as String;
    }
    if (detail is String) return detail;
  }
  return null;
}

/// Liest den SSE-Strom von `/create/ai/stream` bis `done` (→ Slug) oder
/// `error` (→ [AiImportException]). Top-Level, damit testbar ohne Server.
Future<String> readAiImportStream(
  Stream<List<int>> bytes, {
  void Function(String message)? onProgress,
}) async {
  String? event;
  final data = StringBuffer();
  await for (final line
      in utf8.decoder.bind(bytes).transform(const LineSplitter())) {
    if (line.isEmpty) {
      // Leerzeile = Ende eines Events.
      final result = _handleAiEvent(event, data.toString(), onProgress);
      if (result != null) return result;
      event = null;
      data.clear();
    } else if (line.startsWith(':')) {
      continue; // Keep-alive-Kommentar (sse-starlette „: ping")
    } else if (line.startsWith('event:')) {
      event = line.substring(6).trim();
    } else if (line.startsWith('data:')) {
      if (data.isNotEmpty) data.write('\n');
      data.write(line.substring(5).trimLeft());
    }
  }
  // Letztes Event ohne abschließende Leerzeile.
  final result = _handleAiEvent(event, data.toString(), onProgress);
  if (result != null) return result;
  throw const AiImportException(null);
}

/// Wertet ein SSE-Event des KI-Imports aus: Slug bei `done`, Exception bei
/// `error`, sonst `null` (weiterlesen).
String? _handleAiEvent(
    String? event, String raw, void Function(String)? onProgress) {
  if (event == null || raw.isEmpty) return null;
  Map<String, dynamic>? json;
  try {
    json = jsonDecode(raw) as Map<String, dynamic>?;
  } catch (_) {
    json = null;
  }
  final message = json?['message'] as String?;
  switch (event) {
    case 'progress':
      if (message != null && message.isNotEmpty) {
        LogManager.shared.log('🤖 KI-Import: $message');
        onProgress?.call(message);
      }
      return null;
    case 'done':
      final slug = (json?['slug'] as String? ?? '').trim();
      if (slug.isEmpty) throw const AiImportException(null);
      LogManager.shared.log('🤖 KI-Import fertig: $slug');
      return slug;
    case 'error':
      LogManager.shared.log('🤖 KI-Import Fehler: $message');
      throw AiImportException(message);
    default:
      return null;
  }
}
