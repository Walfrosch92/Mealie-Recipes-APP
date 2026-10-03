import 'dart:convert';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_service.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/models/organizer_item.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/models/recipe_summary.dart';
import '../../../core/services/log_manager.dart';
import '../../../core/services/recipe_detail_cache.dart';
import '../../../core/services/recipe_image_store.dart';
import '../../../core/utils/search_match.dart';

// ---------------------------------------------------------------------------
// All recipes list — 1:1 zu Swift RecipeListViewModel.allRecipes ([RecipeDetail]).
//
// Strategie wie Swifts loadCachedOrFetchRecipes:
//   1. Beim build() den File-Cache lesen → wenn nicht leer, sofort returnen
//      (warm-start: instant, KEIN API-Call).
//   2. Wenn Cache leer (cold-start), Hintergrund-Load anstossen, der zuerst
//      alle Summaries fetcht und dann die Details inkrementell nachholt; die
//      Liste wächst sichtbar Stück für Stück (state = AsyncData(partial)).
//   3. refresh() triggert denselben Inkremental-Load ohne Cache oder state
//      vorher zu leeren — alte Liste bleibt während des Reloads sichtbar,
//      jedes neu geholte Rezept ersetzt seinen alten Stand.
//   4. Zwischenstände alle 100 Rezepte in den Cache; ein unvollständiger
//      Durchlauf wird beim Zurückkehren in die App fortgesetzt.
//
// Progress (0–1) wird in einem separaten StateProvider gespiegelt damit die
// AppBar während des Cold-Loads / Refresh einen Balken zeigen kann.
// ---------------------------------------------------------------------------

final recipeListProgressProvider = StateProvider<double>((ref) => 0);

final recipesProvider =
    AsyncNotifierProvider<RecipesNotifier, List<RecipeDetail>>(
        RecipesNotifier.new);

class RecipesNotifier extends AsyncNotifier<List<RecipeDetail>> {
  /// Der gerade laufende Voll-Load bzw. Abgleich. Es läuft immer höchstens
  /// EINER: vorher konnte ein Pull-to-Refresh während des Start-Abgleichs
  /// einen zweiten Durchlauf parallel starten (doppelte Last auf dem Server,
  /// und beide schrieben am Ende ihren eigenen Stand in den Cache).
  Future<void>? _sync;

  /// true, solange die Bibliothek seit dem letzten Durchlauf nicht
  /// vollständig mit dem Server abgeglichen ist (Abbruch, Timeouts, App im
  /// Hintergrund). [resumeSyncIfNeeded] holt dann beim Zurückkehren in die
  /// App nach — vorher gab es einen neuen Versuch erst beim nächsten
  /// Kaltstart. Startet mit true: solange in dieser Sitzung noch kein
  /// Abgleich vollständig durchlief, gilt die Liste als ungeprüft (wichtig für
  /// das Aufräumen der Offline-Bilder, das nur bei vollständiger Liste darf).
  bool _needsSync = true;

  /// Zeitpunkt des letzten VOLLSTÄNDIGEN Abgleichs. Beim Zurückkehren in die
  /// App wird danach erneut (günstig: nur die Übersicht + Differenz)
  /// abgeglichen, wenn er länger her ist als [_resumeReconcileAfter] — sonst
  /// tauchten Rezepte, die inzwischen im Web angelegt wurden, erst nach einem
  /// Kaltstart oder manuellem Aktualisieren auf.
  DateTime? _lastCompletedSync;
  static const _resumeReconcileAfter = Duration(minutes: 10);

  /// Schneller Abgleich bei JEDEM Öffnen der App (nur die zuletzt geänderten
  /// Rezepte, eine Anfrage) — höchstens alle [_quickSyncEvery]. Vorher sah
  /// z. B. das iPad eine Änderung vom iPhone erst nach 10 Minuten bzw. nach
  /// manuellem Neuladen.
  DateTime? _lastQuickSync;
  static const _quickSyncEvery = Duration(seconds: 30);
  static const _quickSyncPage = 50;

  /// Wird bei jedem build() hochgezählt. Ein laufender Durchlauf prüft nach
  /// jedem Netzwerk-Schritt, ob er noch zur aktuellen Generation gehört —
  /// sonst (App-Reset, Server gewechselt) bricht er ab, statt Rezepte des
  /// alten Servers in State und Cache zu schreiben.
  int _generation = 0;

  /// Nach so vielen neu geholten Rezepten wird der Zwischenstand in den
  /// Datei-Cache geschrieben. Vorher wurde erst ganz am Ende gespeichert:
  /// bei 2.500 Rezepten (~250 Batches, viele Minuten) warf jede
  /// Unterbrechung ALLES weg, und der nächste Start fing wieder bei null an.
  static const _checkpointEvery = 100;

  /// So viele Batches in Folge OHNE ein einziges geladenes Rezept → der
  /// Server ist nicht erreichbar (Tunnel/VPN weg, z. B. Tailscale nach
  /// Netzwechsel), der Durchlauf bricht ab. Vorher lief die Schleife trotzdem
  /// alle Batches durch, jeder wartete 30 s auf sein Timeout, bei 2.500
  /// Rezepten bis zu ~2 h, bevor ein neuer Versuch überhaupt möglich war.
  /// Fortgesetzt wird beim Zurückkehren in die App ([resumeSyncIfNeeded]).
  static const _maxFailedBatchesInRow = 3;

  @override
  Future<List<RecipeDetail>> build() async {
    final gen = ++_generation;
    // Auf den „Server eingerichtet"-Zustand REAGIEREN: dieser Provider wird oft
    // sehr früh gebaut (z.B. via widgetSyncProvider beim App-Start), BEVOR die
    // Ersteinrichtung abgeschlossen ist. Damals ist isConfigured=false →
    // `_loadIncrementally` bricht ab und lud nie nach → der User musste die
    // Rezeptliste beim Ersteinstieg manuell aktualisieren. Durch das `watch`
    // baut der Provider neu, sobald isConfigured true wird, und lädt dann
    // automatisch im Hintergrund.
    final configured = ref.watch(
        settingsProvider.select((s) => s.valueOrNull?.isConfigured ?? false));

    // Warm-Cache hat Priorität: wenn vorhanden, sofort zurückgeben (instant UI,
    // kein Warten auf die API). ABER im Hintergrund mit dem Server abgleichen,
    // damit serverseitig gelöschte (Anzahl zu hoch) bzw. auf einem anderen Gerät
    // hinzugefügte (Anzahl zu niedrig) Rezepte korrigiert werden. Vorher blieb
    // der Cache bis zu einem MANUELLEN Pull-to-Refresh stale → eine upgedatete
    // Installation zeigte z. B. 71 statt der echten 69 Rezepte.
    final cached = await RecipeDetailCacheManager.shared.load();
    // Erst laden, wenn der Server eingerichtet ist (sonst no-op bis isConfigured
    // true wird und der Provider neu baut). Läuft von einem früheren build()
    // noch ein Durchlauf, erst dessen Ende abwarten (er bricht dank
    // `_generation` beim nächsten Schritt selbst ab).
    if (configured) {
      Future.microtask(() async {
        final running = _sync;
        if (running != null) await running;
        if (gen != _generation) return;
        _startSync(cached.isNotEmpty
            ? () => _reconcileWithServer(gen)
            : () => _loadIncrementally(gen));
      });
    }
    return cached;
  }

  // mirror Swift refreshRecipes(): inkrementell neu laden, wobei die aktuelle
  // Liste während des Reloads sichtbar bleibt (kein AsyncLoading-Reset).
  // Abweichung von Swift: der Cache wird NICHT mehr vorab gelöscht — brach
  // der Reload ab (App in den Hintergrund, Timeout), war die Datei leer und
  // der nächste Start begann bei null. Jetzt ersetzt jedes neu geholte
  // Rezept seinen alten Stand; nicht ladbare behalten ihn.
  Future<void> refresh() async {
    final running = _sync;
    if (running != null) await running;
    final gen = _generation;
    await _startSync(() => _loadIncrementally(gen));
  }

  /// Nach serverseitigen Massenänderungen (Massenimport, Migration,
  /// Massenaktionen der Rezeptdaten): nur die Differenz zum Server abgleichen
  /// — kein Voll-Reload. Läuft schon ein Abgleich, danach erneut.
  Future<void> reconcileNow() async {
    final running = _sync;
    if (running != null) await running;
    if (!state.hasValue) return;
    final gen = _generation;
    await _startSync(() => _reconcileWithServer(gen));
  }

  /// Vom App-Lifecycle (`resumed`) aufgerufen: war der letzte Durchlauf
  /// unvollständig, jetzt dort weitermachen. Der Abgleich lädt ohnehin nur
  /// die Differenz, also genau die noch fehlenden bzw. veralteten Rezepte.
  void resumeSyncIfNeeded() {
    if (_sync != null) return;
    // Erster Aufbau läuft noch (Cache wird gelesen): dann gibt es nichts
    // fortzusetzen, den ersten Abgleich startet build() selbst. Vorher kam
    // `resumed` beim Kaltstart (bzw. nach Face ID) genau in dieses Fenster —
    // die Liste war noch leer, `_needsSync` stand wie zu jedem Sitzungsbeginn
    // auf true → Voll-Load ALLER Rezepte einzeln, und direkt danach meldete
    // der eigentliche Abgleich „keine Änderung".
    if (!state.hasValue) return;
    final configured =
        ref.read(settingsProvider).valueOrNull?.isConfigured ?? false;
    if (!configured) return;
    if (!_needsSync) {
      final last = _lastCompletedSync;
      if (last != null &&
          DateTime.now().difference(last) > _resumeReconcileAfter) {
        // Länger nicht abgeglichen: neue/geänderte Server-Rezepte holen.
        final gen = _generation;
        _startSync(() => _reconcileWithServer(gen));
        return;
      }
      // Kürzlich abgeglichen: nur nach zuletzt geänderten Rezepten fragen.
      final lastQuick = _lastQuickSync;
      if (lastQuick == null ||
          DateTime.now().difference(lastQuick) > _quickSyncEvery) {
        final gen = _generation;
        _startSync(() => _quickSyncRecent(gen));
        return;
      }
      // Rezepte vollständig, aber der Bild-Download wurde unterbrochen.
      if (RecipeImageStore.shared.isIncomplete) _syncImages(prune: false);
      return;
    }
    final gen = _generation;
    final hasRecipes = (state.valueOrNull ?? const []).isNotEmpty;
    LogManager.shared.log('🔄 Unvollständiger Rezept-Sync → wird fortgesetzt');
    _startSync(hasRecipes
        ? () => _reconcileWithServer(gen)
        : () => _loadIncrementally(gen));
  }

  /// Nach dem Einschalten von „Rezeptbilder offline speichern": sofort alle
  /// Bilder der vorhandenen Rezepte laden. Aufräumen (prune) nur, wenn die
  /// Rezeptliste als vollständig gilt.
  void syncImagesNow() => _syncImages(prune: !_needsSync && _sync == null);

  /// Stößt den Bild-Abgleich an, falls die Einstellung aktiv ist. Läuft im
  /// Hintergrund und reiht sich bei einem laufenden Abgleich dahinter ein.
  void _syncImages({required bool prune}) {
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings == null ||
        !settings.offlineRecipeImages ||
        !settings.isConfigured) {
      return;
    }
    final recipes = state.valueOrNull ?? const <RecipeDetail>[];
    if (recipes.isEmpty) return;
    unawaited(RecipeImageStore.shared
        .sync(recipes, ref.read(apiServiceProvider), prune: prune));
  }

  /// Einzelnes Rezept mit frischem Stand (Besuch, Import, Bearbeiten): Bild
  /// nachladen, falls es fehlt oder sich geändert hat.
  void _ensureImage(RecipeDetail recipe) {
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings == null ||
        !settings.offlineRecipeImages ||
        !settings.isConfigured) {
      return;
    }
    unawaited(
        RecipeImageStore.shared.ensure(recipe, ref.read(apiServiceProvider)));
  }

  /// Startet [op], sofern nicht schon ein Durchlauf läuft — sonst wird der
  /// laufende zurückgegeben (kein zweiter parallel).
  Future<void> _startSync(Future<void> Function() op) {
    final running = _sync;
    if (running != null) return running;
    final future = op();
    _sync = future;
    return future.whenComplete(() {
      if (identical(_sync, future)) _sync = null;
    });
  }

  // Public single-recipe-replace, vom RecipeDetailNotifier nach erfolgreichem
  // API-Get aufgerufen damit die Liste und der File-Cache synchron bleiben.
  // POSITIONSERHALTEND ersetzen statt entfernen+anhängen: das Ans-Ende-
  // Schieben veränderte bei jedem Rezept-Besuch die Listenreihenfolge, und
  // Index-basierte Verbraucher (Home-Tagesvorschlag, Widget-Daily-Pool)
  // sprangen dadurch auf das zuletzt angesehene Rezept um.
  Future<void> upsertOne(RecipeDetail recipe) async {
    final current = state.valueOrNull ?? const <RecipeDetail>[];
    final idx = current.indexWhere((r) => r.id == recipe.id);
    final updated = List<RecipeDetail>.of(current);
    if (idx >= 0) {
      updated[idx] = recipe;
    } else {
      updated.add(recipe);
    }
    state = AsyncData(updated);
    _ensureImage(recipe);
    await RecipeDetailCacheManager.shared.replaceOne(recipe);
  }

  void removeById(String id) {
    state.whenData((list) {
      state = AsyncData(list.where((r) => r.id != id).toList());
    });
    // Auch aus dem File-Cache entfernen — sonst kommt das gelöschte Rezept
    // beim nächsten Warm-Start aus dem Cache zurück (Anzahl wieder zu hoch).
    Future.microtask(() => RecipeDetailCacheManager.shared.removeById(id));
    // Gespeichertes Bild gehört zum Rezept → mit weg (unabhängig davon, ob
    // die Offline-Bilder gerade eingeschaltet sind).
    unawaited(RecipeImageStore.shared.remove(id));
  }

  /// Entfernt einen serverseitig gelöschten Tag aus allen geladenen Rezepten
  /// (Liste + File-Cache). Ersetzt den früheren Voll-`refresh()` nach dem
  /// Organizer-Löschen: der lud ALLE Rezepte neu (Summaries + 1 Request pro
  /// Rezept), nur damit der abgeleitete allTagsProvider den Tag verliert.
  Future<void> stripTagEverywhere(String tagId) async {
    await _stripOrganizer((r) => r.tags.any((t) => t.id == tagId),
        (r) => r.copyWith(tags: r.tags.where((t) => t.id != tagId).toList()));
  }

  /// Pendant zu [stripTagEverywhere] für Utensilien.
  Future<void> stripToolEverywhere(String toolId) async {
    await _stripOrganizer(
        (r) => r.tools.any((t) => t.id == toolId),
        (r) =>
            r.copyWith(tools: r.tools.where((t) => t.id != toolId).toList()));
  }

  /// Nach dem Umbenennen einer Kategorie/eines Schlagworts/Utensils: den
  /// neuen Namen in alle geladenen Rezepte übernehmen (lokal, ohne Reload).
  Future<void> renameOrganizerEverywhere(
      OrganizerKind kind, String id, String name) async {
    switch (kind) {
      case OrganizerKind.category:
        await _stripOrganizer(
            (r) => r.recipeCategory.any((c) => c.id == id),
            (r) => r.copyWith(
                recipeCategory: r.recipeCategory
                    .map((c) => c.id == id
                        ? CategorySummary(id: c.id, name: name, slug: c.slug)
                        : c)
                    .toList()));
      case OrganizerKind.tag:
        await _stripOrganizer(
            (r) => r.tags.any((t) => t.id == id),
            (r) => r.copyWith(
                tags: r.tags
                    .map((t) => t.id == id
                        ? TagSummary(id: t.id, name: name, slug: t.slug)
                        : t)
                    .toList()));
      case OrganizerKind.tool:
        await _stripOrganizer(
            (r) => r.tools.any((t) => t.id == id),
            (r) => r.copyWith(
                tools: r.tools
                    .map((t) => t.id == id
                        ? RecipeTool(
                            id: t.id,
                            name: name,
                            onHand: t.onHand,
                            slug: t.slug)
                        : t)
                    .toList()));
    }
  }

  /// Löscht [id] der Art [kind] aus allen geladenen Rezepten.
  Future<void> stripOrganizerEverywhere(OrganizerKind kind, String id) =>
      switch (kind) {
        OrganizerKind.category => stripCategoryEverywhere(id),
        OrganizerKind.tag => stripTagEverywhere(id),
        OrganizerKind.tool => stripToolEverywhere(id),
      };

  /// Pendant zu [stripTagEverywhere] für Kategorien.
  Future<void> stripCategoryEverywhere(String categoryId) async {
    await _stripOrganizer(
        (r) => r.recipeCategory.any((c) => c.id == categoryId),
        (r) => r.copyWith(
            recipeCategory:
                r.recipeCategory.where((c) => c.id != categoryId).toList()));
  }

  Future<void> _stripOrganizer(bool Function(RecipeDetail) affected,
      RecipeDetail Function(RecipeDetail) strip) async {
    final current = state.valueOrNull;
    if (current == null || !current.any(affected)) return;
    final updated = current.map((r) => affected(r) ? strip(r) : r).toList();
    state = AsyncData(updated);
    await RecipeDetailCacheManager.shared.save(updated);
  }

  /// Leichter Hintergrund-Abgleich für den Warm-Start (Cache war nicht leer):
  /// holt nur die Summaries (günstig, keine Detail-Flut) und gleicht daraus ab:
  ///   - serverseitig GELÖSCHTE Rezepte fliegen aus Cache+State,
  ///   - auf dem Server NEUE (z. B. in der Weboberfläche oder auf einem anderen
  ///     Gerät angelegte) werden nachgeladen,
  ///   - GEÄNDERTE (neueres `dateUpdated` als der gecachte Stand) werden neu
  ///     geholt.
  /// Nachgeladen wird also immer nur die Differenz, nie die ganze Bibliothek.
  /// Schreibt nur bei tatsächlicher Änderung → kein Flackern, wenn alles passt.
  /// Zwischenstände landen alle [_checkpointEvery] Rezepte im Cache, damit ein
  /// abgebrochener Abgleich beim nächsten Mal nur noch den Rest holen muss.
  Future<void> _reconcileWithServer(int gen) async {
    _needsSync = true;
    var completed = false;
    var reachedServer = false;
    var connectionLost = false;
    var showedProgress = false;
    try {
      final settings = await ref.read(settingsProvider.future);
      if (!settings.isConfigured) {
        LogManager.shared
            .log('🔄 Reconcile: nicht konfiguriert → übersprungen');
        return;
      }
      final api = ref.read(apiServiceProvider);

      final summaries = await api.fetchAllRecipes();
      if (gen != _generation) return;
      reachedServer = true;
      final serverIds = summaries.map((s) => s.id).toSet();
      final current = state.valueOrNull ?? const <RecipeDetail>[];
      final byId = {for (final r in current) r.id: r};

      // 1) Serverseitig gelöschte Rezepte bestimmen — NUR aus dem Stand vor
      //    dem Summary-Fetch. Was währenddessen per upsertOne dazukommt (z. B.
      //    ein frisch importiertes Rezept), steht noch nicht in den Summaries
      //    und darf deshalb nicht als „gelöscht" gelten.
      final removedIds = {
        for (final r in current)
          if (!serverIds.contains(r.id)) r.id,
      };

      // 2) Differenz bestimmen: NEU (noch nicht im Cache) und GEÄNDERT
      //    (Server-`dateUpdated` jünger als der gecachte Stand). Der Vergleich
      //    kostet keinen einzigen Zusatz-Request — `dateUpdated` steckt bereits
      //    in den Summaries, die wir oben ohnehin geholt haben.
      //    Dazu kommen Einträge aus einem älteren Cache-Format
      //    ([kRecipeCacheSchema]): denen fehlen neu eingelesene Felder (z. B.
      //    Zutaten-Abschnitte), obwohl sich auf dem Server nichts geändert
      //    hat. Sie werden EINMALIG neu geholt; dank Checkpoints macht ein
      //    abgebrochener Durchlauf beim nächsten Mal beim Rest weiter.
      final added = <String>[];
      final stale = <String>[];
      var outdatedSchema = 0;
      for (final s in summaries) {
        final cached = byId[s.id];
        if (cached == null) {
          added.add(s.id);
        } else if (_isNewer(s.dateUpdated, cached.dateUpdated)) {
          stale.add(s.id);
        } else if (cached.cacheSchema < kRecipeCacheSchema) {
          stale.add(s.id);
          outdatedSchema++;
        }
      }
      if (outdatedSchema > 0) {
        LogManager.shared.log('🔄 Reconcile: $outdatedSchema Rezepte aus '
            'älterem Cache-Format → werden einmalig neu geladen');
      }
      final toFetch = [...added, ...stale];

      if (removedIds.isEmpty && toFetch.isEmpty) {
        LogManager.shared.log('🔄 Reconcile: Cache=${current.length} '
            'Server=${serverIds.length} → (keine Änderung)');
        completed = true;
        return;
      }
      if (removedIds.isNotEmpty) {
        await _commit(_mergeIntoCurrent(removedIds, const {}));
        for (final id in removedIds) {
          unawaited(RecipeImageStore.shared.remove(id));
        }
      }

      // 3) Nur diese Differenz nachladen — mit Zwischenständen. Bei größeren
      //    Mengen zeigt die Rezeptliste den Fortschrittsbalken, sonst wirkte
      //    ein minutenlanger Abgleich wie „es passiert nichts".
      showedProgress = toFetch.length > 20;
      final progress = ref.read(recipeListProgressProvider.notifier);
      final fresh = <String, RecipeDetail>{};
      var sinceCheckpoint = 0;
      connectionLost = await _fetchDetailsBatched(api, toFetch,
          isCancelled: () => gen != _generation,
          onBatch: (batch, done) async {
            for (final r in batch) {
              fresh[r.id] = r;
            }
            sinceCheckpoint += batch.length;
            if (showedProgress) progress.state = done / toFetch.length;
            if (sinceCheckpoint >= _checkpointEvery) {
              sinceCheckpoint = 0;
              await _commit(_mergeIntoCurrent(removedIds, fresh));
            }
          });
      if (gen != _generation) return;
      if (fresh.isNotEmpty) {
        await _commit(_mergeIntoCurrent(removedIds, fresh));
      }
      completed = fresh.length == toFetch.length;

      LogManager.shared.log(
          '🔄 Reconcile: Cache=${current.length} Server=${serverIds.length} '
          'entfernt=${removedIds.length} neu=${added.length} '
          'geändert=${stale.length} geholt=${fresh.length} '
          '→ ${state.valueOrNull?.length ?? 0}'
          '${fresh.isNotEmpty || removedIds.isNotEmpty ? " (gespeichert)" : ""}'
          '${completed ? "" : " — unvollständig, wird fortgesetzt"}');
    } catch (e) {
      // Offline / Server nicht erreichbar → bereits gespeicherte Zwischenstände
      // bleiben, der Rest wird beim nächsten Durchlauf nachgeholt.
      LogManager.shared.log('🔄 Reconcile fehlgeschlagen: $e');
    } finally {
      if (completed && gen == _generation) {
        _needsSync = false;
        _lastCompletedSync = DateTime.now();
      }
      if (showedProgress) {
        ref.read(recipeListProgressProvider.notifier).state = 0;
      }
      // Bilder erst NACH den Rezepten laden (nicht parallel, der Server soll
      // nicht doppelt belastet werden). Aufräumen nur bei vollständiger Liste.
      if (reachedServer && !connectionLost && gen == _generation) {
        _syncImages(prune: completed);
      }
    }
  }

  /// Schneller Abgleich: holt die [_quickSyncPage] zuletzt geänderten
  /// Rezepte (eine Anfrage) und lädt nur die neuen bzw. neueren nach.
  /// Gelöschte erkennt erst der volle Abgleich ([_reconcileWithServer]).
  /// Ist die ganze Seite geändert, gibt es vermutlich mehr → voller Abgleich.
  Future<void> _quickSyncRecent(int gen) async {
    _lastQuickSync = DateTime.now();
    try {
      final api = ref.read(apiServiceProvider);
      final recent =
          await api.fetchRecentlyUpdatedRecipes(perPage: _quickSyncPage);
      if (gen != _generation) return;
      final (:toFetch, :needsFullSync) = quickSyncPlan(
          recent, state.valueOrNull ?? const <RecipeDetail>[],
          pageSize: _quickSyncPage);
      if (toFetch.isEmpty) {
        LogManager.shared.log('⚡️ Schneller Abgleich → (keine Änderung)');
        return;
      }
      if (needsFullSync) {
        LogManager.shared
            .log('⚡️ Schneller Abgleich: viele Änderungen → voller Abgleich');
        await _reconcileWithServer(gen);
        return;
      }
      final fresh = <String, RecipeDetail>{};
      await _fetchDetailsBatched(api, toFetch,
          isCancelled: () => gen != _generation,
          onBatch: (batch, _) async {
            for (final r in batch) {
              fresh[r.id] = r;
            }
          });
      if (gen != _generation || fresh.isEmpty) return;
      await _commit(_mergeIntoCurrent(const {}, fresh));
      for (final r in fresh.values) {
        _ensureImage(r);
      }
      LogManager.shared.log('⚡️ Schneller Abgleich: ${fresh.length} '
          'geänderte/neue Rezepte nachgeladen');
    } catch (e) {
      LogManager.shared.log('⚡️ Schneller Abgleich fehlgeschlagen: $e');
    }
  }

  /// Welche der zuletzt geänderten Rezepte fehlen bzw. sind im Cache älter?
  /// Ist die ganze Seite geändert, gibt es vermutlich noch mehr Änderungen
  /// → [needsFullSync].
  static ({List<String> toFetch, bool needsFullSync}) quickSyncPlan(
      List<RecipeSummary> recent, List<RecipeDetail> cached,
      {required int pageSize}) {
    final byId = {for (final r in cached) r.id: r};
    final toFetch = [
      for (final s in recent)
        if (byId[s.id] == null ||
            _isNewerStamp(s.dateUpdated, byId[s.id]!.dateUpdated))
          s.id
    ];
    return (
      toFetch: toFetch,
      needsFullSync:
          recent.length >= pageSize && toFetch.length == recent.length,
    );
  }

  /// Baut die neue Liste auf dem AKTUELLEN State auf, nicht auf einem
  /// Schnappschuss vom Laufbeginn: ein Durchlauf dauert bei großen
  /// Bibliotheken Minuten, und währenddessen per [upsertOne] ergänzte Rezepte
  /// (Detail-Besuch, Import, Kochbuch) dürfen nicht verloren gehen.
  /// Bestehende Einträge werden POSITIONSERHALTEND ersetzt (Index-basierte
  /// Verbraucher wie der Home-Tagesvorschlag sollen nicht umspringen), neue
  /// hinten angehängt, [removedIds] entfernt.
  List<RecipeDetail> _mergeIntoCurrent(
      Set<String> removedIds, Map<String, RecipeDetail> fresh) {
    final base = state.valueOrNull ?? const <RecipeDetail>[];
    final seen = <String>{};
    final out = <RecipeDetail>[];
    for (final r in base) {
      if (removedIds.contains(r.id) || !seen.add(r.id)) continue;
      out.add(fresh[r.id] ?? r);
    }
    for (final r in fresh.values) {
      if (seen.add(r.id)) out.add(r);
    }
    return out;
  }

  Future<void> _commit(List<RecipeDetail> list) async {
    state = AsyncData(list);
    await RecipeDetailCacheManager.shared.save(list);
  }

  /// True, wenn der Server-Zeitstempel jünger ist als der gecachte. Beide
  /// Werte stammen aus demselben Mealie-Feld, ein reiner String-Vergleich
  /// würde aber schon bei abweichender Formatierung (Nachkommastellen,
  /// Zeitzonen-Suffix) fälschlich anschlagen und das Rezept unnötig neu
  /// holen. Deshalb erst parsen — und nur wenn das misslingt, auf
  /// „String unterschiedlich" zurückfallen.
  bool _isNewer(String? server, String? cached) =>
      _isNewerStamp(server, cached);

  static bool _isNewerStamp(String? server, String? cached) {
    if (server == null) return false; // Server nennt keinen Stand → nichts tun
    if (cached == null) return true; // Cache kennt keinen → sicherheitshalber
    final s = DateTime.tryParse(server);
    final c = DateTime.tryParse(cached);
    if (s == null || c == null) return server != cached;
    return s.isAfter(c);
  }

  /// Holt Details zu [ids] in Batches à [batchSize] PARALLEL, mit 0,3 s Pause
  /// zwischen den Batches — NICHT alle auf einmal: ein unbegrenztes
  /// `Future.wait` feuerte nach einem unterbrochenen Reload schon mal 100+
  /// gleichzeitige Verbindungen ab und der Server quittierte das mit
  /// „Connection refused". Nicht ladbare Details werden übersprungen (das
  /// Rezept bleibt dann auf dem alten Stand und wird beim nächsten Durchlauf
  /// erneut versucht). [onBatch] bekommt nach jedem Batch dessen Ergebnis und
  /// die Anzahl der bisher abgearbeiteten IDs; [isCancelled] beendet die
  /// Schleife vorzeitig. Liefert true, wenn wegen
  /// [_maxFailedBatchesInRow] komplett gescheiterter Batches abgebrochen wurde.
  Future<bool> _fetchDetailsBatched(
    ApiService api,
    List<String> ids, {
    required Future<void> Function(List<RecipeDetail> batch, int done) onBatch,
    required bool Function() isCancelled,
    int batchSize = 10,
  }) async {
    var failedInRow = 0;
    for (var start = 0; start < ids.length; start += batchSize) {
      final end =
          (start + batchSize) > ids.length ? ids.length : (start + batchSize);
      final batch = await Future.wait([
        for (var i = start; i < end; i++) _fetchDetailOrNull(api, ids[i]),
      ]);
      if (isCancelled()) return false;
      final loaded = batch.whereType<RecipeDetail>().toList();
      await onBatch(loaded, end);
      failedInRow = loaded.isEmpty ? failedInRow + 1 : 0;
      if (failedInRow >= _maxFailedBatchesInRow) {
        LogManager.shared.log('🔄 Abbruch: $failedInRow Batches in Folge ohne '
            'Antwort (Server/Verbindung nicht erreichbar) — $end/${ids.length} '
            'bearbeitet, wird fortgesetzt');
        return true;
      }
      if (end < ids.length) {
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }
    return false;
  }

  // Angelehnt an Swift loadRecipesIncrementally(batchSize: 10): Summaries
  // holen, dann pro Batch 10 Details fetchen, den state nach jedem Batch
  // aktualisieren und 0.3 s Pause zwischen Batches einlegen. Abweichung von
  // Swift (bewusst, für Ladezeit): die 10 Details eines Batches laufen PARALLEL
  // statt seriell (siehe `_fetchDetailsBatched`). Zweite Abweichung: alle
  // [_checkpointEvery] Rezepte wird der Zwischenstand gespeichert — bricht der
  // Load ab, setzt der nächste Start per Abgleich dort fort, statt neu zu
  // beginnen.
  //
  // Dient für Cold-Start (State leer) UND refresh() (State = alte Liste):
  // neu geholte Rezepte ersetzen ihren alten Stand, nicht ladbare behalten
  // ihn, serverseitig gelöschte fliegen raus.
  Future<void> _loadIncrementally(int gen) async {
    _needsSync = true;
    var completed = false;
    var reachedServer = false;
    var connectionLost = false;
    // WICHTIG: erst auf die geladenen Settings warten, DANN den ApiService
    // greifen. Direkt nach der Ersteinrichtung läuft dieser Cold-Load sonst,
    // bevor settingsProvider Daten hat → apiServiceProvider fällt auf
    // `const AppSettings()` (serverUrl='') zurück → Dio hat keinen Host →
    // „Invalid argument(s): No host specified in URI /api/recipes…". Das Await
    // stellt sicher, dass apiServiceProvider mit der echten Server-URL neu
    // gebaut wurde, bevor wir ihn lesen.
    final settings = await ref.read(settingsProvider.future);
    if (!settings.isConfigured) {
      return; // Guest-Mode / Setup nicht abgeschlossen: nichts vom Server holen.
    }
    final api = ref.read(apiServiceProvider);
    final progress = ref.read(recipeListProgressProvider.notifier);
    progress.state = 0;

    try {
      final summaries = await api.fetchAllRecipes();
      if (gen != _generation) return;
      reachedServer = true;
      final total = summaries.length;
      final serverIds = summaries.map((s) => s.id).toSet();
      // Wie im Abgleich: nur was VOR dem Summary-Fetch da war und auf dem
      // Server fehlt, gilt als gelöscht.
      final removedIds = {
        for (final r in state.valueOrNull ?? const <RecipeDetail>[])
          if (!serverIds.contains(r.id)) r.id,
      };

      final fresh = <String, RecipeDetail>{};
      var sinceCheckpoint = 0;
      // Einzelne Fehler werden pro Rezept verschluckt (mirror Swift catch im
      // Loop) und überspringen nur dieses eine Rezept, nicht den ganzen Batch.
      connectionLost =
          await _fetchDetailsBatched(api, [for (final s in summaries) s.id],
              isCancelled: () => gen != _generation,
              onBatch: (batch, done) async {
                for (final r in batch) {
                  fresh[r.id] = r;
                }
                sinceCheckpoint += batch.length;
                final visible = _mergeIntoCurrent(removedIds, fresh);
                if (sinceCheckpoint >= _checkpointEvery) {
                  sinceCheckpoint = 0;
                  await _commit(visible);
                } else {
                  state = AsyncData(visible);
                }
                progress.state = done / total;
              });
      if (gen != _generation) return;

      await _commit(_mergeIntoCurrent(removedIds, fresh));
      for (final id in removedIds) {
        unawaited(RecipeImageStore.shared.remove(id));
      }
      completed = fresh.length == total;
      progress.state = 1;
      LogManager.shared.log('🔄 Voll-Load: Server=$total geholt=${fresh.length}'
          '${completed ? "" : " — unvollständig, wird fortgesetzt"}');
    } catch (e, st) {
      LogManager.shared.log('🔄 Voll-Load fehlgeschlagen: $e');
      // Wenn überhaupt nichts geladen werden konnte (Summary-Fetch failed)
      // und nichts im Cache war, AsyncError. Sonst: behalte was sichtbar war.
      final current = state.valueOrNull ?? const <RecipeDetail>[];
      if (current.isEmpty) {
        state = AsyncError(e, st);
      }
    } finally {
      if (completed && gen == _generation) {
        _needsSync = false;
        _lastCompletedSync = DateTime.now();
      }
      // Abgebrochen → Balken ausblenden (0 = „kein Load aktiv"; der
      // Setup-Schritt wertet 0 + vorhandene Rezepte als fertig, der User
      // hängt dort also nicht fest).
      if (progress.state < 1) progress.state = 0;
      // Verbindung während des Laufs weg → Bilder gar nicht erst versuchen
      // (sie würden nur ebenfalls in Timeouts laufen).
      if (reachedServer && !connectionLost && gen == _generation) {
        _syncImages(prune: completed);
      }
    }
  }

  /// Holt ein Rezept-Detail und gibt bei Fehler `null` zurück (statt zu
  /// werfen). So lässt sich ein ganzer Batch per `Future.wait` PARALLEL laden,
  /// ohne dass ein einzelner Fehlschlag den kompletten Batch abbricht — der
  /// Aufrufer filtert die `null`s einfach heraus.
  Future<RecipeDetail?> _fetchDetailOrNull(ApiService api, String id) async {
    try {
      return await api.fetchRecipeDetail(id);
    } catch (_) {
      return null;
    }
  }
}

// ---------------------------------------------------------------------------
// Single recipe detail (cached by slug)
// ---------------------------------------------------------------------------

final recipeDetailProvider =
    AsyncNotifierProviderFamily<RecipeDetailNotifier, RecipeDetail, String>(
        RecipeDetailNotifier.new);

class RecipeDetailNotifier extends FamilyAsyncNotifier<RecipeDetail, String> {
  // mirror Swift RecipeDetailViewModel.fetchRecipe(by:):
  //   API-first, bei Erfolg Cache aktualisieren (replaceOne); bei Fehler
  //   Cache-Fallback per ID-Lookup. Wenn weder API noch Cache liefern,
  //   wird der Fehler propagiert.
  // Cache-first: bekanntes Rezept SOFORT anzeigen, dann im Hintergrund
  // genau dieses Rezept beim Server prüfen und bei Änderungen sofort
  // ersetzen. Vorher wartete jedes Öffnen auf den Server (offline bis zum
  // Timeout) — und ein in dieser Sitzung schon geöffnetes Rezept wurde gar
  // nicht mehr geprüft, Änderungen von anderen Geräten blieben unsichtbar.
  bool _checking = false;

  @override
  Future<RecipeDetail> build(String slug) async {
    final api = ref.watch(apiServiceProvider);
    RecipeDetail? cached;
    for (final r
        in ref.read(recipesProvider).valueOrNull ?? const <RecipeDetail>[]) {
      if (r.id == slug || r.slug == slug) {
        cached = r;
        break;
      }
    }
    cached ??= await RecipeDetailCacheManager.shared.getById(slug);
    if (cached != null) {
      final shown = cached;
      Future.microtask(() => _checkServer(shown));
      return shown;
    }
    // Noch nie geladen → auf den Server warten.
    final fetched = await api.fetchRecipeDetail(slug);
    await RecipeDetailCacheManager.shared.replaceOne(fetched);
    Future.microtask(
        () => ref.read(recipesProvider.notifier).upsertOne(fetched));
    return fetched;
  }

  /// Beim (erneuten) Öffnen der Detailansicht: still beim Server nachsehen.
  void checkForUpdates() {
    final current = state.valueOrNull;
    if (current != null) _checkServer(current);
  }

  Future<void> _checkServer(RecipeDetail shown) async {
    if (_checking) return;
    _checking = true;
    try {
      final fetched = await ref.read(apiServiceProvider).fetchRecipeDetail(arg);
      final current = state.valueOrNull ?? shown;
      if (jsonEncode(fetched.toJson()) == jsonEncode(current.toJson())) return;
      state = AsyncData(fetched);
      await ref.read(recipesProvider.notifier).upsertOne(fetched);
    } catch (_) {
      // Offline / Server nicht erreichbar → angezeigter Stand bleibt.
    } finally {
      _checking = false;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final api = ref.read(apiServiceProvider);
      try {
        final fetched = await api.fetchRecipeDetail(arg);
        await RecipeDetailCacheManager.shared.replaceOne(fetched);
        Future.microtask(
            () => ref.read(recipesProvider.notifier).upsertOne(fetched));
        return fetched;
      } catch (e) {
        final cached = await RecipeDetailCacheManager.shared.getById(arg);
        if (cached != null) return cached;
        rethrow;
      }
    });
  }

  void setRecipe(RecipeDetail recipe) {
    state = AsyncData(recipe);
  }
}

// ---------------------------------------------------------------------------
// Sort & filter state
// ---------------------------------------------------------------------------

enum RecipeSort {
  nameAZ,
  nameZA,
  dateNewest,
  dateOldest,
  prepTimeShort,
  prepTimeLong,
  ratingHighest,
  ratingLowest,
}

/// Filter der Rezeptliste — wie Mealies Rezeptsuche: Kategorien,
/// Schlagworte, Utensilien und Lebensmittel jeweils mit „Irgendeines/Alle
/// enthalten", dazu Haushalt (Einfachauswahl). Gefiltert wird lokal über den
/// Rezept-Cache (offline-fähig).
class RecipeFilter {
  final String query;
  final Set<String> categoryIds;
  final Set<String> tagIds;
  final Set<String> toolIds;
  final Set<String> foodIds;
  final Set<String> householdIds;
  final bool requireAllCategories;
  final bool requireAllTags;
  final bool requireAllTools;
  final bool requireAllFoods;
  final RecipeSort sort;

  const RecipeFilter({
    this.query = '',
    this.categoryIds = const {},
    this.tagIds = const {},
    this.toolIds = const {},
    this.foodIds = const {},
    this.householdIds = const {},
    this.requireAllCategories = false,
    this.requireAllTags = false,
    this.requireAllTools = false,
    this.requireAllFoods = false,
    this.sort = RecipeSort.nameAZ,
  });

  /// Anzahl aktiver Filter-Dimensionen (für das Badge am Filter-Knopf).
  int get activeCount => [
        categoryIds,
        tagIds,
        toolIds,
        foodIds,
        householdIds,
      ].where((s) => s.isNotEmpty).length;

  bool get hasFilters => activeCount > 0;

  RecipeFilter copyWith({
    String? query,
    Set<String>? categoryIds,
    Set<String>? tagIds,
    Set<String>? toolIds,
    Set<String>? foodIds,
    Set<String>? householdIds,
    bool? requireAllCategories,
    bool? requireAllTags,
    bool? requireAllTools,
    bool? requireAllFoods,
    RecipeSort? sort,
  }) {
    return RecipeFilter(
      query: query ?? this.query,
      categoryIds: categoryIds ?? this.categoryIds,
      tagIds: tagIds ?? this.tagIds,
      toolIds: toolIds ?? this.toolIds,
      foodIds: foodIds ?? this.foodIds,
      householdIds: householdIds ?? this.householdIds,
      requireAllCategories: requireAllCategories ?? this.requireAllCategories,
      requireAllTags: requireAllTags ?? this.requireAllTags,
      requireAllTools: requireAllTools ?? this.requireAllTools,
      requireAllFoods: requireAllFoods ?? this.requireAllFoods,
      sort: sort ?? this.sort,
    );
  }
}

/// Passt eine Rezept-Eigenschaft ([have]) zur Auswahl ([wanted])? Leere
/// Auswahl = kein Filter; [all] = jedes Gewählte muss vorkommen.
bool matchesSelection(Set<String> wanted, Iterable<String> have, bool all) {
  if (wanted.isEmpty) return true;
  final h = have.toSet();
  return all ? wanted.every(h.contains) : wanted.any(h.contains);
}

/// Wendet alle Auswahl-Filter (ohne Textsuche) auf ein Rezept an.
bool recipeMatchesFilter(RecipeDetail r, RecipeFilter f) =>
    matchesSelection(f.categoryIds, r.recipeCategory.map((c) => c.id),
        f.requireAllCategories) &&
    matchesSelection(f.tagIds, r.tags.map((t) => t.id), f.requireAllTags) &&
    matchesSelection(f.toolIds, r.tools.map((t) => t.id), f.requireAllTools) &&
    matchesSelection(
        f.foodIds,
        [
          for (final i in r.recipeIngredient)
            if ((i.food?.id ?? '').isNotEmpty) i.food!.id!,
        ],
        f.requireAllFoods) &&
    matchesSelection(f.householdIds,
        [if ((r.householdId ?? '').isNotEmpty) r.householdId!], false);

/// SharedPreferences-Schlüssel der zuletzt gewählten Sortierung.
const kRecipeSortKey = 'recipeListSort';

/// Gespeicherte Sortierung als Enum (unbekannt/fehlend → A–Z).
RecipeSort recipeSortFromName(String? name) => RecipeSort.values
    .firstWhere((s) => s.name == name, orElse: () => RecipeSort.nameAZ);

/// In `main()` aus den SharedPreferences vorgeladen — so steht die zuletzt
/// gewählte Sortierung schon im ersten Frame (kein kurzes A–Z).
final initialRecipeSortProvider =
    Provider<RecipeSort>((ref) => RecipeSort.nameAZ);

final recipeFilterProvider =
    NotifierProvider<RecipeFilterNotifier, RecipeFilter>(
        RecipeFilterNotifier.new);

class RecipeFilterNotifier extends Notifier<RecipeFilter> {
  @override
  RecipeFilter build() =>
      RecipeFilter(sort: ref.read(initialRecipeSortProvider));

  void setQuery(String q) => state = state.copyWith(query: q);

  // Toggle category membership (mirrors iOS insert/remove on Set)
  void toggleCategory(String id) {
    final next = Set<String>.from(state.categoryIds);
    next.contains(id) ? next.remove(id) : next.add(id);
    state = state.copyWith(categoryIds: next);
  }

  void toggleTag(String id) {
    final next = Set<String>.from(state.tagIds);
    next.contains(id) ? next.remove(id) : next.add(id);
    state = state.copyWith(tagIds: next);
  }

  void clearCategories() => state = state.copyWith(categoryIds: {});
  void clearTags() => state = state.copyWith(tagIds: {});

  /// Ganze Filter-Auswahl übernehmen (aus dem Filter-Sheet).
  void apply(RecipeFilter Function(RecipeFilter f) change) =>
      state = change(state);

  /// Sortierung wählen und für den nächsten App-Start merken.
  void setSort(RecipeSort sort) {
    state = state.copyWith(sort: sort);
    unawaited(SharedPreferences.getInstance()
        .then((p) => p.setString(kRecipeSortKey, sort.name))
        .catchError((_) => false));
  }

  /// Filter zurücksetzen — die gewählte Sortierung bleibt (Vorliebe, kein
  /// Filter).
  void reset() => state = RecipeFilter(sort: state.sort);
}

// ---------------------------------------------------------------------------
// Filtered + sorted recipe list
// ---------------------------------------------------------------------------

final filteredRecipesProvider = Provider<List<RecipeDetail>>((ref) {
  final recipesAsync = ref.watch(recipesProvider);
  final filter = ref.watch(recipeFilterProvider);

  return recipesAsync.when(
    data: (recipes) {
      var list = recipes.toList();

      // Text search
      final terms = searchTerms(filter.query);
      if (terms.isNotEmpty) {
        list = list.where((r) => recipeMatchesSearch(r, terms)).toList();
      }

      // Kategorien/Schlagworte/Utensilien/Lebensmittel/Haushalt
      if (filter.hasFilters) {
        list = list.where((r) => recipeMatchesFilter(r, filter)).toList();
      }

      applyRecipeSort(list, filter.sort);
      return list;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Sortiert [list] IN PLACE nach [sort] — gemeinsame Logik für die
/// Rezeptliste (`filteredRecipesProvider`) UND die Rezeptsuche in der
/// Mahlzeitenplanung (`add_meal_entry_screen.dart`), damit beide Stellen
/// exakt dieselben Sortieroptionen anbieten.
void applyRecipeSort(List<RecipeDetail> list, RecipeSort sort) {
  switch (sort) {
    case RecipeSort.nameAZ:
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    case RecipeSort.nameZA:
      list.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
    case RecipeSort.dateNewest:
      list.sort((a, b) => (b.dateAdded ?? '').compareTo(a.dateAdded ?? ''));
    case RecipeSort.dateOldest:
      list.sort((a, b) => (a.dateAdded ?? '').compareTo(b.dateAdded ?? ''));
    case RecipeSort.prepTimeShort:
      list.sort((a, b) => (a.prepTime ?? 9999).compareTo(b.prepTime ?? 9999));
    case RecipeSort.prepTimeLong:
      list.sort((a, b) => (b.prepTime ?? 0).compareTo(a.prepTime ?? 0));
    case RecipeSort.ratingHighest:
      list.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    case RecipeSort.ratingLowest:
      list.sort((a, b) => (a.rating ?? 0).compareTo(b.rating ?? 0));
  }
}

// ---------------------------------------------------------------------------
// All tags derived from the loaded recipe list
// ---------------------------------------------------------------------------

final allTagsProvider = Provider<List<TagSummary>>((ref) {
  final recipesAsync = ref.watch(recipesProvider);
  return recipesAsync.when(
    data: (recipes) {
      final seen = <String>{};
      final result = <TagSummary>[];
      for (final r in recipes) {
        for (final t in r.tags) {
          if (seen.add(t.id)) result.add(t);
        }
      }
      result.sort((a, b) => a.name.compareTo(b.name));
      return result;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// ---------------------------------------------------------------------------
// All categories derived from the loaded recipe list
// ---------------------------------------------------------------------------

final allCategoriesProvider = Provider<List<CategorySummary>>((ref) {
  final recipesAsync = ref.watch(recipesProvider);
  return recipesAsync.when(
    data: (recipes) {
      final seen = <String>{};
      final result = <CategorySummary>[];
      for (final r in recipes) {
        for (final c in r.recipeCategory) {
          if (seen.add(c.id)) result.add(c);
        }
      }
      result.sort((a, b) => a.name.compareTo(b.name));
      return result;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
