import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/log_manager.dart';
import '../../cooking_mode/providers/cooking_session_provider.dart';
import '../providers/recipes_provider.dart';

/// Persistiert eine geänderte Notizliste für [recipe]: aktualisiert sofort
/// den Disk-Cache (über `recipesProvider.upsertOne`, das Liste UND File-Cache
/// synchron hält — direkt `RecipeDetailCacheManager.replaceOne` aufzurufen
/// würde NUR die Datei treffen und `recipesProvider`s In-Memory-Liste
/// veraltet lassen, da die z. B. von Home/Rezeptliste/Widgets gelesen wird)
/// und eine ggf. aktive Kochsession desselben Rezepts (offline-first — der
/// Aufrufer hat die Liste bereits lokal per `setState` angezeigt), synct
/// danach per Partial-PATCH zum Server und lässt bei Erfolg den
/// Detail-Provider neu laden (analog zum lastMade-Sync in
/// cooking_mode_screen._finishRecipe). Wirft bei Netzwerkfehlern weiter, damit
/// der Aufrufer eine Fehlermeldung zeigen kann — die lokale Anzeige bleibt in
/// jedem Fall wie vom Nutzer bearbeitet (Cache/Session werden nicht zurückgerollt).
Future<void> persistRecipeNotes(
  WidgetRef ref,
  RecipeDetail recipe,
  List<RecipeNote> notes,
) async {
  final updated = recipe.copyWith(notes: notes);
  unawaited(ref.read(recipesProvider.notifier).upsertOne(updated));
  ref
      .read(cookingSessionsProvider.notifier)
      .updateRecipeNotes(recipe.id, notes);
  try {
    // Ältere Offline-Änderungen zuerst — sonst mischte dieser Abgleich ohne
    // sie und sie kämen erst danach, in falscher Reihenfolge.
    await flushPendingRecipeNotes(ref);
    final api = ref.read(apiServiceProvider);
    // Gleichzeitige Änderungen (z. B. Notiz in der Webapp ergänzt) nicht
    // überschreiben: Notizen sind EIN Array, ein PATCH ersetzt es ganz. Darum
    // den aktuellen Server-Stand holen und nur UNSERE Änderung (gegenüber
    // [recipe.notes]) darauf anwenden.
    var toSend = notes;
    try {
      final server = await api.fetchRecipeDetail(recipe.id);
      toSend = mergeRecipeNotes(
          base: recipe.notes, mine: notes, server: server.notes);
    } catch (_) {/* offline/Fehler: wie bisher die eigene Liste senden */}
    await api.updateRecipeNotes(recipe.id, toSend);
    if (!identical(toSend, notes)) {
      unawaited(ref
          .read(recipesProvider.notifier)
          .upsertOne(recipe.copyWith(notes: toSend)));
      ref
          .read(cookingSessionsProvider.notifier)
          .updateRecipeNotes(recipe.id, toSend);
    }
    ref.invalidate(recipeDetailProvider(recipe.id));
  } catch (e) {
    LogManager.shared.log('📝 Notiz-Sync fehlgeschlagen (${recipe.slug}): $e');
    // Server lehnt ab (403 = kein Recht, das Rezept zu bearbeiten): die
    // lokale Änderung zurücknehmen — sonst stünde eine Notiz in der App, die
    // es in Mealie nie gibt. Netzwerkfehler (offline) bleiben lokal stehen.
    // Offline: vormerken und beim Wiederverbinden senden (vorher blieb die
    // Notiz nur lokal stehen und erreichte Mealie nie).
    if (isConnectionError(e)) {
      await _queuePendingNotes(recipe.id, base: recipe.notes, mine: notes);
      throw const RecipeNotesQueued();
    }
    if (e is DioException && e.response?.statusCode == 403) {
      unawaited(ref.read(recipesProvider.notifier).upsertOne(recipe));
      ref
          .read(cookingSessionsProvider.notifier)
          .updateRecipeNotes(recipe.id, recipe.notes);
      throw const RecipeNotesRejected();
    }
    rethrow;
  }
}

/// Der Server hat die Notiz-Änderung abgelehnt (fehlendes Recht) — die
/// lokale Änderung wurde zurückgenommen.
class RecipeNotesRejected implements Exception {
  const RecipeNotesRejected();
}

/// Offline: die Änderung ist vorgemerkt und wird beim Wiederverbinden
/// gesendet ([flushPendingRecipeNotes]).
class RecipeNotesQueued implements Exception {
  const RecipeNotesQueued();
}

// ── Offline-Warteschlange ──────────────────────────────────────────────────
// Pro Rezept: [base] = Server-Stand VOR der ersten Offline-Änderung, [mine]
// = letzter lokaler Stand. Beim Senden wird wie online dreiseitig gegen den
// aktuellen Server-Stand gemischt (mergeRecipeNotes) — Änderungen, die
// zwischendurch in der Webapp gemacht wurden, bleiben erhalten.

const _kPendingNotes = 'pending_recipe_notes';

List<Map<String, String>> _notesJson(List<RecipeNote> notes) => [
      for (final n in notes)
        {
          'title': n.title,
          'text': n.text,
          if (n.referenceId != null) 'referenceId': n.referenceId!,
        }
    ];

List<RecipeNote> _notesFrom(dynamic raw) => [
      for (final n in (raw as List? ?? const []))
        if (n is Map)
          RecipeNote(
              title: n['title']?.toString() ?? '',
              text: n['text']?.toString() ?? '',
              referenceId: n['referenceId']?.toString()),
    ];

Future<Map<String, dynamic>> _loadPending() async {
  try {
    final raw =
        (await SharedPreferences.getInstance()).getString(_kPendingNotes);
    if (raw == null || raw.isEmpty) return {};
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  } catch (_) {
    return {};
  }
}

Future<void> _savePending(Map<String, dynamic> pending) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    if (pending.isEmpty) {
      await prefs.remove(_kPendingNotes);
    } else {
      await prefs.setString(_kPendingNotes, jsonEncode(pending));
    }
  } catch (_) {}
}

Future<void> _queuePendingNotes(String recipeId,
    {required List<RecipeNote> base, required List<RecipeNote> mine}) async {
  final pending = await _loadPending();
  final prev = pending[recipeId];
  pending[recipeId] = {
    // Mehrere Offline-Änderungen: die URSPRÜNGLICHE Basis behalten.
    'base': prev is Map ? prev['base'] : _notesJson(base),
    'mine': _notesJson(mine),
  };
  await _savePending(pending);
}

bool _flushing = false;

/// Vorgemerkte Offline-Notizen senden (App-Start, Rückkehr in die App,
/// Server wieder erreichbar). Bricht beim ersten Verbindungsfehler ab — der
/// Rest bleibt vorgemerkt. Endgültige Ablehnung (kein Recht, Rezept
/// gelöscht) verwirft den Eintrag und stellt den Server-Stand wieder her.
Future<void> flushPendingRecipeNotes(WidgetRef ref) async {
  if (_flushing) return;
  _flushing = true;
  try {
    final pending = await _loadPending();
    if (pending.isEmpty) return;
    final settings = await ref.read(settingsProvider.future);
    if (!settings.isConfigured) return;
    final api = ref.read(apiServiceProvider);
    for (final id in pending.keys.toList()) {
      final entry = pending[id];
      if (entry is! Map) {
        pending.remove(id);
        continue;
      }
      try {
        final server = await api.fetchRecipeDetail(id);
        final toSend = mergeRecipeNotes(
            base: _notesFrom(entry['base']),
            mine: _notesFrom(entry['mine']),
            server: server.notes);
        await api.updateRecipeNotes(id, toSend);
        await ref
            .read(recipesProvider.notifier)
            .upsertOne(server.copyWith(notes: toSend));
        ref
            .read(cookingSessionsProvider.notifier)
            .updateRecipeNotes(id, toSend);
        ref.invalidate(recipeDetailProvider(id));
        pending.remove(id);
        LogManager.shared.log('📝 Offline-Notiz nachgesendet ($id)');
      } catch (e) {
        // Nur bei ENDGÜLTIGER Ablehnung verwerfen (403 kein Recht, 404 Rezept
        // gelöscht). Alles andere — offline, Anmeldung abgelaufen (401),
        // Serverfehler — bleibt vorgemerkt für den nächsten Versuch.
        final status = e is DioException ? e.response?.statusCode : null;
        if (status != 403 && status != 404) break;
        LogManager.shared.log('📝 Offline-Notiz verworfen ($id): $e');
        pending.remove(id);
        // Lokale Anzeige auf den Server-Stand zurück (falls erreichbar).
        try {
          final server = await api.fetchRecipeDetail(id);
          await ref.read(recipesProvider.notifier).upsertOne(server);
          ref
              .read(cookingSessionsProvider.notifier)
              .updateRecipeNotes(id, server.notes);
        } catch (_) {}
      }
    }
    await _savePending(pending);
  } finally {
    _flushing = false;
  }
}

/// Drei-Wege-Abgleich der Notizen: wendet die Änderung von [base] → [mine]
/// (gelöschte, geänderte, neue Notizen) auf den aktuellen [server]-Stand an.
/// Ist der Server unverändert, kommt [mine] selbst zurück (identisch).
List<RecipeNote> mergeRecipeNotes({
  required List<RecipeNote> base,
  required List<RecipeNote> mine,
  required List<RecipeNote> server,
}) {
  String key(RecipeNote n) => '${n.title}\u0000${n.text}';
  final baseKeys = base.map(key).toList();
  final serverKeys = server.map(key).toList();
  if (_sameList(baseKeys, serverKeys)) {
    return _withServerIds(mine, base: base, server: server);
  }
  final mineKeys = mine.map(key).toSet();
  final removed = {
    for (final k in baseKeys)
      if (!mineKeys.contains(k)) k
  };
  final baseSet = baseKeys.toSet();
  final added = [
    for (final n in mine)
      if (!baseSet.contains(key(n))) n
  ];
  final result = [
    for (final n in server)
      if (!removed.contains(key(n))) n,
  ];
  final present = result.map(key).toSet();
  for (final n in added) {
    if (present.add(key(n))) result.add(n);
  }
  return _withServerIds(result, base: base, server: server);
}

/// Fehlende `referenceId`s vom Server ergänzen (Cache-Stände vor dem
/// Update kannten sie nicht). Ohne sie vergäbe Mealie beim Speichern allen
/// Notizen neue IDs und die Notiz-Verweise der Schritte gingen verloren.
/// Unveränderte Notizen: per Inhalt. Bearbeitete: die ID der Notiz, die an
/// derselben Stelle stand und jetzt fehlt (also die bearbeitete war).
List<RecipeNote> _withServerIds(List<RecipeNote> notes,
    {required List<RecipeNote> base, required List<RecipeNote> server}) {
  if (notes.every((n) => n.referenceId != null)) return notes;
  String key(RecipeNote n) => '${n.title}\u0000${n.text}';
  final serverIdByKey = <String, String>{
    for (final n in server)
      if (n.referenceId != null) key(n): n.referenceId!,
  };
  final noteKeys = notes.map(key).toSet();
  final used = notes.map((n) => n.referenceId).whereType<String>().toSet();
  final out = <RecipeNote>[];
  var changed = false;
  for (var i = 0; i < notes.length; i++) {
    final n = notes[i];
    if (n.referenceId != null) {
      out.add(n);
      continue;
    }
    var id = serverIdByKey[key(n)];
    if (id == null && i < base.length && !noteKeys.contains(key(base[i]))) {
      id = base[i].referenceId ?? serverIdByKey[key(base[i])];
    }
    if (id != null && used.add(id)) {
      out.add(RecipeNote(title: n.title, text: n.text, referenceId: id));
      changed = true;
    } else {
      out.add(n);
    }
  }
  return changed ? out : notes;
}

bool _sameList(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
