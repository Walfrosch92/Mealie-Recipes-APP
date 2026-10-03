import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show compute;
import 'package:path_provider/path_provider.dart';

import '../models/recipe_detail.dart';
import 'log_manager.dart';

// ---------------------------------------------------------------------------
// RecipeDetailCacheManager — Port von Swift Services/RecipeCache.swift
//
// Datei-basierter Cache in `${appSupportDir}/MealieCache/recipeCache.json`.
// Swift (und Flutter bis 2026-09) legten ihn unter `cachesDirectory` ab —
// den Ordner darf iOS bei Speicherknappheit jederzeit leeren, und bei
// grossen Bibliotheken (2.500+ Rezepte) war der Cache dann „über Nacht" weg.
// Application Support räumt das System nie auf; eine vorhandene Datei am
// alten Ort wird einmalig verschoben (`_resolveFile`).
// SharedPreferences ist hier ungeeignet, weil die komplette Rezept-
// bibliothek viele MB gross werden kann und Android-SharedPreferences
// (alles im Speicher, XML) typischerweise nur ~1 MB gut verträgt.
//
// Das ist der EINZIGE Rezept-Cache der App: `recipesProvider` hält die Liste
// im Speicher, dieser Manager persistiert sie. (Früher zog der Leftover-Finder
// über `LocalCache.saveRecipeDetails` eine zweite, komplett eigene Kopie
// derselben Bibliothek in SharedPreferences — die ist ersatzlos entfallen.)
//
// Verhalten (bewusste Abweichungen vom Swift-Original):
//   - KEIN Limit — weder Anzahl noch Dateigröße.
//     Swift kappte hier auf 200 Rezepte / 10 MB und warf den Rest per
//     LRU-Eviction weg. Das machte Bibliotheken >200 Rezepte offline
//     unvollständig UND liess `_reconcileWithServer` bei JEDEM Start die
//     nicht persistierten Rezepte erneut als „neu" nachladen (sie flogen
//     beim nächsten save() sofort wieder raus). Jetzt wird alles behalten.
//   - Weil die Datei damit unbegrenzt wächst, laufen JSON-Encode und -Parse
//     ab einer gewissen Größe in einem Hintergrund-Isolate (`compute`),
//     sonst blockiert das Serialisieren den UI-Thread. Siehe `_isolate*`.
//   - `_memory` spiegelt den Dateiinhalt im RAM: nach dem ersten `load()`
//     kostet ein Lesezugriff KEINE Datei-IO mehr, und die häufigen
//     Einzeländerungen (`replaceOne` bei jedem Rezept-Besuch) schreiben
//     entprellt statt sofort die ganze Datei neu.
//   - Alle Zugriffe laufen seriell (`_serialized`), damit sich die
//     Read-Modify-Write-Zyklen nicht überholen.
//   - Geschrieben wird ATOMAR: erst in `recipeCache.json.tmp`, dann per
//     rename über die echte Datei. `writeAsString` leert die Zieldatei
//     sofort und schreibt dann mehrere MB — wurde der Prozess dazwischen
//     beendet (App in den Hintergrund, iOS killt sie), blieb eine halbe
//     JSON-Datei zurück, `load()` lieferte stillschweigend eine leere Liste
//     und der nächste Einzel-Write überschrieb den Rest endgültig.
//
// Public API:
//   load()          → List<RecipeDetail>
//   save(recipes)   → schreibt die komplette Liste (sofort)
//   clear()         → Datei + RAM-Spiegel löschen
//   getById(id)     → RecipeDetail?
//   replaceOne(d)   → ersetzt den Eintrag mit gleicher id an Ort und Stelle
//                     (bzw. hängt d an, wenn neu), Write entprellt
//   removeById(id)  → entfernt den Eintrag, Write entprellt
//   flush()         → einen ausstehenden entprellten Write sofort ausführen
// ---------------------------------------------------------------------------

class RecipeDetailCacheManager {
  RecipeDetailCacheManager._();
  static final RecipeDetailCacheManager shared = RecipeDetailCacheManager._();

  static const _cacheFolderName = 'MealieCache';
  static const _cacheFileName = 'recipeCache.json';

  // Ab wann sich der Umweg über einen Hintergrund-Isolate lohnt. Darunter
  // kostet das Spawnen des Isolates (plus das Kopieren der Rezepte hinein und
  // der geparsten Objekte zurück) mehr, als das Encoden/Parsen auf dem
  // UI-Isolate überhaupt dauert — kleine Bibliotheken bleiben deshalb auf dem
  // direkten Weg. Die beiden Schwellen meinen ungefähr dieselbe Datenmenge:
  // beim Speichern ist die Rezept-Anzahl bekannt, beim Laden (noch) nicht,
  // dort ist die Dateigröße das billigste verfügbare Maß (~3 KB pro Rezept).
  static const _isolateRecipeThreshold = 150;
  static const _isolateBytesThreshold = 512 * 1024;

  // Sammelfenster für Einzeländerungen. Wer durch mehrere Rezepte blättert,
  // löst sonst pro Detail-Aufruf ein komplettes Neuschreiben der Datei aus.
  static const _writeDebounce = Duration(seconds: 2);

  /// RAM-Spiegel des Dateiinhalts. `null` = noch nicht gelesen.
  List<RecipeDetail>? _memory;
  Timer? _pendingWrite;

  Future<File>? _fileFuture;
  Future<File> _file() {
    return _fileFuture ??= _resolveFile();
  }

  Future<File> _resolveFile() async {
    final base = await getApplicationSupportDirectory();
    final folder = Directory('${base.path}/$_cacheFolderName');
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    final file = File('${folder.path}/$_cacheFileName');
    await _migrateFromCachesDir(file);
    return file;
  }

  /// Einmaliger Umzug aus dem alten, vom OS leerbaren Cache-Verzeichnis.
  /// Nur wenn am neuen Ort noch nichts liegt — sonst ist die neue Datei die
  /// Wahrheit und die alte nur ein Überbleibsel (wird dann entfernt).
  Future<void> _migrateFromCachesDir(File target) async {
    try {
      final oldBase = await getApplicationCacheDirectory();
      final oldFolder = Directory('${oldBase.path}/$_cacheFolderName');
      final old = File('${oldFolder.path}/$_cacheFileName');
      if (!await old.exists()) return;
      if (await target.exists()) {
        await old.delete();
      } else {
        try {
          await old.rename(target.path);
        } catch (_) {
          // rename über Dateisystemgrenzen hinweg schlägt fehl → kopieren.
          await old.copy(target.path);
          await old.delete();
        }
        LogManager.shared
            .log('🗂️ Rezept-Cache nach Application Support verschoben');
      }
      if (await oldFolder.exists() && await oldFolder.list().isEmpty) {
        await oldFolder.delete();
      }
    } catch (e) {
      LogManager.shared.log('⚠️ Rezept-Cache-Umzug fehlgeschlagen: $e');
    }
  }

  // ── Serialisierung aller Cache-Operationen ────────────────────────────────
  // `replaceOne`/`removeById` sind Read-Modify-Write, und Encode/Write hängen
  // seit dem Isolate-Offload an deutlich mehr await-Punkten. Ohne Reihenfolge
  // könnten sich zwei parallele Läufe überholen: der zweite liest, bevor der
  // erste geschrieben hat (verlorenes Update), oder beide schreiben
  // gleichzeitig dieselbe Datei (halbe JSON-Datei → `load()` wirft und liefert
  // eine leere Liste, der Cache wäre also weg). `_opChain` reiht jede
  // Operation hinter der vorherigen ein.
  Future<void> _opChain = Future<void>.value();

  Future<T> _serialized<T>(Future<T> Function() op) {
    final done = Completer<T>();
    _opChain = _opChain.then((_) async {
      try {
        done.complete(await op());
      } catch (e, st) {
        // Fehler wandern zum Aufrufer, brechen aber die Kette nicht ab.
        done.completeError(e, st);
      }
    });
    return done.future;
  }

  // ── Public API ────────────────────────────────────────────────────────────

  Future<List<RecipeDetail>> load() => _serialized(_loadUnlocked);

  /// Schreibt die KOMPLETTE Liste — ohne Mengen- oder Größenbegrenzung und
  /// ohne Entprellung (Aufrufer sind die seltenen Voll-Läufe: Cold-Load und
  /// Reconcile, inkl. deren Zwischenstände).
  Future<void> save(List<RecipeDetail> recipes) =>
      _serialized(() => _saveUnlocked(recipes));

  Future<void> clear() => _serialized(() async {
        _cancelPendingWrite();
        _memory = null;
        try {
          final f = await _file();
          if (await f.exists()) await f.delete();
          final tmp = File('${f.path}.tmp');
          if (await tmp.exists()) await tmp.delete();
        } catch (_) {}
      });

  Future<RecipeDetail?> getById(String id) => _serialized(() async {
        final list = await _loadUnlocked();
        for (final r in list) {
          if (r.id == id) return r;
        }
        return null;
      });

  /// mirror Swift `reloadRecipe(with:)` für die Detail-View — abweichend von
  /// Swift POSITIONSERHALTEND (in place) statt entfernen+anhängen: die
  /// Reihenfolge des Caches wird beim Warm-Start zur State-Reihenfolge, und
  /// das Ans-Ende-Schieben ließ Index-basierte Verbraucher (Home-Tages-
  /// vorschlag) auf das zuletzt angesehene Rezept umspringen.
  ///
  /// Läuft komplett auf dem RAM-Spiegel: kein Datei-Read, und der Write wird
  /// entprellt. Das ist der mit Abstand häufigste Schreibpfad (jeder
  /// Rezept-Besuch ruft ihn nach dem Detail-Fetch auf).
  Future<void> replaceOne(RecipeDetail recipe) => _serialized(() async {
        final list = await _loadUnlocked();
        final idx = list.indexWhere((r) => r.id == recipe.id);
        final updated = List<RecipeDetail>.of(list);
        if (idx >= 0) {
          updated[idx] = recipe;
        } else {
          updated.add(recipe);
        }
        _memory = updated;
        _scheduleWrite();
      });

  /// Entfernt ein Rezept (per id) aus dem Cache. Wird nach dem Löschen
  /// aufgerufen, sonst taucht das gelöschte Rezept beim nächsten Warm-Start aus
  /// dem Cache wieder auf (Anzahl bleibt zu hoch).
  Future<void> removeById(String id) => _serialized(() async {
        final list = await _loadUnlocked();
        final filtered = list.where((r) => r.id != id).toList();
        if (filtered.length == list.length) return;
        _memory = filtered;
        _scheduleWrite();
      });

  /// Schreibt eine ausstehende entprellte Änderung sofort. Wird beim Wechsel
  /// in den Hintergrund gerufen (siehe `app.dart`), damit ein danach vom
  /// System beendeter Prozess die letzte Änderung nicht verliert.
  Future<void> flush() {
    if (_pendingWrite == null) return Future.value();
    _cancelPendingWrite();
    final snapshot = _memory;
    if (snapshot == null) return Future.value();
    return _serialized(() => _writeToDisk(snapshot));
  }

  // ── Interna (ohne Lock — nur aus einer `_serialized`-Operation aufrufen) ───

  Future<List<RecipeDetail>> _loadUnlocked() async {
    final cached = _memory;
    if (cached != null) return cached;
    var loaded = const <RecipeDetail>[];
    try {
      final f = await _file();
      if (await f.exists()) {
        // Große Datei: Lesen UND Parsen komplett im Hintergrund-Isolate, damit
        // der grosse JSON-String gar nicht erst über die Isolate-Grenze
        // kopiert werden muss (nur der Pfad geht rein, die Objekte zurück).
        loaded = await f.length() > _isolateBytesThreshold
            ? await compute(_readAndDecodeCacheFile, f.path)
            : _decodeRecipes(await f.readAsString());
      }
    } catch (e) {
      // Früher stillschweigend — ein unlesbarer Cache sah im Log genauso aus
      // wie ein leerer und war nicht von „OS hat aufgeräumt" zu unterscheiden.
      LogManager.shared.log('⚠️ Rezept-Cache nicht lesbar → leer: $e');
      loaded = const [];
    }
    _memory = loaded;
    return loaded;
  }

  Future<void> _saveUnlocked(List<RecipeDetail> recipes) async {
    _cancelPendingWrite(); // die Vollliste ist jetzt die Wahrheit
    _memory = recipes;
    await _writeToDisk(recipes);
  }

  Future<void> _writeToDisk(List<RecipeDetail> recipes) async {
    try {
      final f = await _file();
      if (recipes.length > _isolateRecipeThreshold) {
        await compute(
            _encodeAndWriteCacheFile, _CacheWriteRequest(f.path, recipes));
        return;
      }
      await _writeAtomically(f.path, _encodeRecipes(recipes));
    } catch (e) {
      // Best effort — dank atomarem Schreiben bleibt die alte Datei intakt.
      LogManager.shared.log('⚠️ Rezept-Cache nicht gespeichert: $e');
    }
  }

  void _scheduleWrite() {
    _pendingWrite?.cancel();
    _pendingWrite = Timer(_writeDebounce, () {
      _pendingWrite = null;
      final snapshot = _memory;
      if (snapshot == null) return;
      // Nicht awaitbar (Timer-Callback); `_writeToDisk` schluckt Fehler selbst.
      unawaited(_serialized(() => _writeToDisk(snapshot)));
    });
  }

  void _cancelPendingWrite() {
    _pendingWrite?.cancel();
    _pendingWrite = null;
  }
}

// ---------------------------------------------------------------------------
// Isolate-Entrypoints — müssen Top-Level (bzw. static) sein, damit `compute`
// sie in den Hintergrund-Isolate schicken kann. RecipeDetail & Co. sind reine
// Datenklassen (Strings/Zahlen/Listen), also über die Isolate-Grenze kopierbar.
// ---------------------------------------------------------------------------

class _CacheWriteRequest {
  const _CacheWriteRequest(this.path, this.recipes);
  final String path;
  final List<RecipeDetail> recipes;
}

Future<List<RecipeDetail>> _readAndDecodeCacheFile(String path) async {
  return _decodeRecipes(await File(path).readAsString());
}

Future<void> _encodeAndWriteCacheFile(_CacheWriteRequest req) async {
  await _writeAtomically(req.path, _encodeRecipes(req.recipes));
}

/// Schreibt erst eine Temp-Datei daneben und benennt sie dann um. rename
/// innerhalb desselben Ordners ist atomar: die Zieldatei ist zu jedem
/// Zeitpunkt entweder komplett alt oder komplett neu, nie halb geschrieben.
Future<void> _writeAtomically(String path, String contents) async {
  final tmp = File('$path.tmp');
  await tmp.writeAsString(contents, flush: true);
  await tmp.rename(path);
}

List<RecipeDetail> _decodeRecipes(String raw) {
  if (raw.isEmpty) return const [];
  final decoded = jsonDecode(raw);
  // Swift speichert als { "recipes": [...] }. Wir akzeptieren beide Formen
  // (Wrapper-Object oder rohes Array) damit eine vorhandene
  // SharedPreferences-Migration bzw. zukünftige Migrationen einfach bleiben.
  final list = decoded is Map<String, dynamic>
      ? decoded['recipes'] as List<dynamic>? ?? const []
      : decoded as List<dynamic>;
  return list
      .map((e) => RecipeDetail.fromJson(e as Map<String, dynamic>))
      .toList();
}

String _encodeRecipes(List<RecipeDetail> recipes) =>
    jsonEncode({'recipes': recipes.map((r) => r.toJson()).toList()});
