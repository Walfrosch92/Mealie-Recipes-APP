import '../utils/safe_path.dart';
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../api/api_service.dart';
import '../models/recipe_detail.dart';
import 'log_manager.dart';

// ---------------------------------------------------------------------------
// RecipeImageStore — dauerhafte Offline-Kopie ALLER Rezeptbilder
// (Einstellung „Rezeptbilder offline speichern", AppSettings.offlineRecipeImages).
//
// Warum nicht einfach `cached_network_image`? Dessen Standard-Cache behält
// höchstens 200 Bilder für 30 Tage im temporären Ordner, den das OS jederzeit
// leeren darf, und lädt nur, was schon einmal angezeigt wurde. Bei großen
// Bibliotheken waren offline deshalb fast alle Bilder weg.
//
// Hier gilt stattdessen:
//   - Ablage in `${appSupportDir}/MealieImages/` (vom OS nie aufgeräumt, vom
//     Backup ausgeschlossen: iOS AppDelegate, Android backup_rules.xml).
//   - Dateiname `<recipeId>__<imageKey>.webp`. `imageKey` ist Mealies
//     `image`-Feld, das der Server bei jedem neuen Bild neu vergibt. Ändert
//     es sich, wird das neue Bild geholt und DANACH das alte gelöscht (offline
//     bleibt bis dahin das alte sichtbar).
//   - Ein Bild bleibt, bis das Rezept gelöscht wird, sein Bild wechselt oder
//     der Schalter ausgeschaltet wird. Verwaiste Bilder werden nur nach einem
//     VOLLSTÄNDIGEN Abgleich weggeräumt (`prune`). Eine unvollständige
//     Rezeptliste (z. B. nach Cache-Verlust) darf nie Bilder löschen.
//   - Geschrieben wird atomar (.tmp + rename), wie beim Rezept-Cache.
//   - Downloads schonen den Server: 2 parallel, kurze Pause, und Abbruch nach
//     mehreren Fehlschlägen in Folge (Server weg / App im Hintergrund).
//     Fortgesetzt wird beim nächsten Abgleich bzw. beim Zurückkehren in die
//     App (`isIncomplete`).
// ---------------------------------------------------------------------------

@immutable
class RecipeImageStats {
  const RecipeImageStats({this.count = 0, this.bytes = 0, this.total = 0});

  /// Gespeicherte Bilder.
  final int count;

  /// Belegter Speicher in Bytes.
  final int bytes;

  /// Rezepte mit Bild laut letztem Abgleich (0 = noch unbekannt).
  final int total;
}

class RecipeImageStore {
  RecipeImageStore._();
  static final RecipeImageStore shared = RecipeImageStore._();

  static const _folderName = 'MealieImages';
  static const _separator = '__';
  static const _parallel = 2;
  static const _pause = Duration(milliseconds: 250);
  static const _maxConsecutiveFailures = 5;

  /// recipeId → gespeichertes Bild.
  final Map<String, _StoredImage> _index = {};

  /// Stand für die Anzeige in den Einstellungen.
  final ValueNotifier<RecipeImageStats> stats =
      ValueNotifier(const RecipeImageStats());

  /// Gerade ladende IDs. Verhindert, dass Voll-Abgleich und Einzel-Nachladen
  /// ([ensure]) dasselbe Bild doppelt holen.
  final Set<String> _inFlight = {};

  /// Bilder, die der Server in dieser Sitzung mit 404 beantwortet hat
  /// (recipeId → imageKey). Nicht bei jedem Abgleich erneut anfragen.
  final Map<String, String> _missing = {};

  /// Wird bei [removeAll] hochgezählt. Laufende Downloads prüfen das nach
  /// jedem await und verwerfen ihr Ergebnis, statt Bilder in einen gerade
  /// geleerten Ordner zu schreiben.
  int _generation = 0;

  Future<void>? _running;
  _SyncRequest? _pending;
  bool _incomplete = false;
  int _total = 0;

  Future<Directory>? _dirFuture;
  Future<void>? _initFuture;

  /// true, wenn der letzte Abgleich nicht alle Bilder holen konnte.
  bool get isIncomplete => _incomplete;

  /// Liest den Ordner einmal ein. Sollte vor dem ersten Frame laufen, damit
  /// die Bilder auch beim Kaltstart ohne Netz sofort da sind.
  Future<void> init() => _initFuture ??= _init();

  Future<void> _init() async {
    try {
      final dir = await _dir();
      await for (final entity in dir.list()) {
        if (entity is! File) continue;
        final name = entity.uri.pathSegments.last;
        if (name.endsWith('.tmp')) {
          // Überbleibsel eines abgebrochenen Downloads.
          await _deleteQuietly(entity);
          continue;
        }
        final parsed = _parseName(name);
        if (parsed == null) continue;
        final (id, key) = parsed;
        final existing = _index[id];
        if (existing != null) {
          // Zwei Stände desselben Rezepts (Absturz zwischen Download und
          // Löschen des alten). Welcher aktuell ist, klärt der nächste
          // Abgleich, bis dahin reicht einer.
          await _deleteQuietly(entity);
          continue;
        }
        _index[id] = _StoredImage(key, entity);
      }
    } catch (e) {
      LogManager.shared.log('⚠️ Bildspeicher nicht lesbar: $e');
    }
    _publishStats();
    // Größen erst danach und ohne await: init() läuft vor dem ersten Frame,
    // und tausende stat()-Aufrufe sollen den Start nicht aufhalten. Die
    // Größe braucht nur die Anzeige in den Einstellungen.
    unawaited(_measureSizes());
  }

  Future<void> _measureSizes() async {
    for (final stored in List.of(_index.values)) {
      if (stored.bytes != null) continue;
      try {
        stored.bytes = await stored.file.length();
      } catch (_) {
        stored.bytes = 0;
      }
    }
    _publishStats();
  }

  /// Lokale Datei zum Rezept, falls vorhanden. Synchron, damit Widgets beim
  /// Bauen direkt entscheiden können (lokal vs. Netzwerk).
  File? fileFor(String recipeId) => _index[recipeId]?.file;

  /// Gleicht die gespeicherten Bilder mit [recipes] ab und lädt fehlende bzw.
  /// geänderte nach. [prune] nur setzen, wenn [recipes] die VOLLSTÄNDIGE
  /// Bibliothek ist: dann fliegen Bilder von Rezepten raus, die nicht mehr
  /// existieren. Läuft schon ein Abgleich, wird dieser hier danach
  /// ausgeführt (bei mehreren wartenden gewinnt der neueste).
  Future<void> sync(List<RecipeDetail> recipes, ApiService api,
      {required bool prune}) async {
    await init();
    _pending = _SyncRequest(recipes, api, prune);
    if (_running != null) return _running!;
    final run = _drain();
    _running = run;
    try {
      await run;
    } finally {
      _running = null;
    }
  }

  Future<void> _drain() async {
    while (_pending != null) {
      final req = _pending!;
      _pending = null;
      await _syncOnce(req);
    }
  }

  Future<void> _syncOnce(_SyncRequest req) async {
    final gen = _generation;
    final wanted = <String, String>{};
    final withoutImage = <String>{};
    for (final r in req.recipes) {
      final key = _sanitizeKey(r.image);
      if (key == null) {
        withoutImage.add(r.id);
      } else {
        wanted[r.id] = key;
      }
    }

    // Rezept existiert, hat aber kein Bild (mehr) → lokale Kopie weg.
    // Das ist auch bei unvollständiger Liste sicher, das Rezept ist ja da.
    for (final id in withoutImage) {
      if (_index.containsKey(id)) await remove(id);
    }
    if (req.prune) {
      final orphans =
          _index.keys.where((id) => !wanted.containsKey(id)).toList();
      for (final id in orphans) {
        await remove(id);
      }
      if (orphans.isNotEmpty) {
        LogManager.shared
            .log('🖼️ ${orphans.length} verwaiste Rezeptbilder entfernt');
      }
    }
    if (gen != _generation) return;

    _total = req.prune
        ? wanted.length
        : (wanted.length > _total ? wanted.length : _total);
    final todo = [
      for (final e in wanted.entries)
        if (_index[e.key]?.key != e.value &&
            _missing[e.key] != e.value &&
            !_inFlight.contains(e.key))
          e.key,
    ];
    _publishStats();
    if (todo.isEmpty) {
      _incomplete = false;
      _logNotStored(req.recipes, wanted);
      return;
    }

    LogManager.shared.log('🖼️ Rezeptbilder: ${todo.length} zu laden '
        '(gespeichert=${_index.length})');
    var loaded = 0;
    var consecutiveFailures = 0;
    var aborted = false;
    for (var start = 0; start < todo.length; start += _parallel) {
      final end =
          (start + _parallel) > todo.length ? todo.length : start + _parallel;
      final results = await Future.wait([
        for (var i = start; i < end; i++)
          _download(req.api, todo[i], wanted[todo[i]]!, gen),
      ]);
      if (gen != _generation) return;
      for (final r in results) {
        switch (r) {
          case _DownloadResult.ok:
            loaded++;
            consecutiveFailures = 0;
          case _DownloadResult.missing:
            consecutiveFailures = 0;
          case _DownloadResult.failed:
            consecutiveFailures++;
        }
      }
      if (consecutiveFailures >= _maxConsecutiveFailures) {
        aborted = true;
        break;
      }
      if (end < todo.length) await Future.delayed(_pause);
    }
    _incomplete = aborted || loaded < todo.length - _missingCount(todo);
    LogManager.shared.log('🖼️ Rezeptbilder: $loaded/${todo.length} geladen'
        '${aborted ? " — abgebrochen (Server nicht erreichbar)" : ""}'
        '${_incomplete ? ", wird fortgesetzt" : ""}');
    _logNotStored(req.recipes, wanted);
  }

  /// Nennt die Rezepte, die ein Bild haben sollten, aber keine lokale Kopie
  /// besitzen, samt Grund. Sonst ist bei „80/81" nicht herauszufinden,
  /// welches Rezept fehlt: die Anzeige fällt still auf das Netzwerk zurück.
  void _logNotStored(List<RecipeDetail> recipes, Map<String, String> wanted) {
    final names = {for (final r in recipes) r.id: r.name};
    final lines = <String>[];
    for (final e in wanted.entries) {
      if (_index[e.key]?.key == e.value) continue;
      final String reason;
      if (_missing[e.key] == e.value) {
        reason = 'Server liefert kein Bild (404/leer)';
      } else if (_inFlight.contains(e.key)) {
        reason = 'lädt noch';
      } else if (_index.containsKey(e.key)) {
        reason = 'altes Bild gespeichert, neues fehlt';
      } else {
        reason = 'Download fehlgeschlagen';
      }
      lines.add(
          '„${names[e.key] ?? '?'}" (${e.key}, image=${e.value}): $reason');
      if (lines.length >= 20) break;
    }
    if (lines.isEmpty) return;
    LogManager.shared.log('🖼️ Ohne Offline-Bild:\n  ${lines.join('\n  ')}');
  }

  int _missingCount(List<String> ids) =>
      ids.where((id) => _missing.containsKey(id)).length;

  /// Holt das Bild EINES Rezepts, falls es fehlt oder sich geändert hat.
  /// Für den Detail-Besuch, Import und Bearbeiten: dort kommt ein frischer
  /// Rezeptstand an, der vom Voll-Abgleich erst beim nächsten Mal erfasst
  /// würde.
  Future<void> ensure(RecipeDetail recipe, ApiService api) async {
    await init();
    final key = _sanitizeKey(recipe.image);
    if (key == null) {
      if (_index.containsKey(recipe.id)) await remove(recipe.id);
      return;
    }
    if (_index[recipe.id]?.key == key || _inFlight.contains(recipe.id)) {
      return;
    }
    // Explizit angefordert: ein früheres 404 nicht als endgültig werten.
    _missing.remove(recipe.id);
    await _download(api, recipe.id, key, _generation);
  }

  Future<_DownloadResult> _download(
      ApiService api, String id, String key, int gen) async {
    _inFlight.add(id);
    File? tmp;
    try {
      final bytes = await api.fetchRecipeImageBytes(id);
      if (gen != _generation) return _DownloadResult.failed;
      if (bytes.isEmpty) {
        _missing[id] = key;
        _publishStats();
        return _DownloadResult.missing;
      }
      final dir = await _dir();
      final target =
          File('${dir.path}/${safePathSegment(id)}$_separator$key.webp');
      tmp = File('${target.path}.tmp');
      await tmp.writeAsBytes(bytes, flush: true);
      if (gen != _generation) return _DownloadResult.failed;
      await tmp.rename(target.path);
      tmp = null;
      final old = _index[id];
      _index[id] = _StoredImage(key, target, bytes.length);
      _missing.remove(id);
      if (old != null && old.file.path != target.path) {
        await _deleteQuietly(old.file);
      }
      _publishStats();
      return _DownloadResult.ok;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        _missing[id] = key;
        _publishStats();
        return _DownloadResult.missing;
      }
      LogManager.shared.log('⚠️ Rezeptbild $id nicht geladen: '
          '${e.response?.statusCode ?? e.type.name}');
      return _DownloadResult.failed;
    } catch (e) {
      LogManager.shared.log('⚠️ Rezeptbild $id nicht gespeichert: $e');
      return _DownloadResult.failed;
    } finally {
      _inFlight.remove(id);
      if (tmp != null) await _deleteQuietly(tmp);
    }
  }

  /// Entfernt das Bild eines Rezepts (Rezept gelöscht / Bild entfernt).
  Future<void> remove(String recipeId) async {
    final stored = _index.remove(recipeId);
    _missing.remove(recipeId);
    if (stored == null) return;
    await _deleteQuietly(stored.file);
    _publishStats();
  }

  /// Löscht ALLE gespeicherten Bilder (Schalter aus, App-Reset) und bricht
  /// laufende Downloads ab.
  Future<void> removeAll() async {
    _generation++;
    _pending = null;
    _index.clear();
    _missing.clear();
    _incomplete = false;
    _total = 0;
    try {
      final dir = await _dir();
      if (await dir.exists()) {
        await for (final entity in dir.list()) {
          await _deleteQuietly(entity);
        }
      }
    } catch (e) {
      LogManager.shared.log('⚠️ Rezeptbilder nicht gelöscht: $e');
    }
    _publishStats();
  }

  // ── Interna ───────────────────────────────────────────────────────────────

  Future<Directory> _dir() => _dirFuture ??= () async {
        final base = await getApplicationSupportDirectory();
        final dir = Directory('${base.path}/$_folderName');
        if (!await dir.exists()) await dir.create(recursive: true);
        return dir;
      }();

  void _publishStats() {
    var bytes = 0;
    for (final s in _index.values) {
      bytes += s.bytes ?? 0;
    }
    // Rezepte, deren Bild der Server mit 404 beantwortet (Bildeintrag ohne
    // Datei), kann niemand speichern. Nicht mitzählen, sonst bleibt die
    // Anzeige für immer bei z. B. „80/81" stehen.
    final total = _total - _missing.length;
    stats.value = RecipeImageStats(
        count: _index.length, bytes: bytes, total: total < 0 ? 0 : total);
  }

  /// Mealies Bild-Schlüssel dateinamentauglich machen. Unterstriche werden
  /// ersetzt, damit `__` eindeutig Rezept-ID und Schlüssel trennt.
  static String? _sanitizeKey(String? image) {
    if (image == null || image.trim().isEmpty) return null;
    return image.trim().replaceAll(RegExp(r'[^A-Za-z0-9.\-]'), '-');
  }

  static (String, String)? _parseName(String name) {
    if (!name.endsWith('.webp')) return null;
    final base = name.substring(0, name.length - '.webp'.length);
    final i = base.indexOf(_separator);
    if (i <= 0 || i + _separator.length >= base.length) return null;
    return (base.substring(0, i), base.substring(i + _separator.length));
  }

  static Future<void> _deleteQuietly(FileSystemEntity entity) async {
    try {
      await entity.delete(recursive: true);
    } catch (_) {}
  }
}

class _StoredImage {
  _StoredImage(this.key, this.file, [this.bytes]);
  final String key;
  final File file;

  /// null = noch nicht gemessen (siehe `_measureSizes`).
  int? bytes;
}

class _SyncRequest {
  const _SyncRequest(this.recipes, this.api, this.prune);
  final List<RecipeDetail> recipes;
  final ApiService api;
  final bool prune;
}

enum _DownloadResult { ok, missing, failed }
