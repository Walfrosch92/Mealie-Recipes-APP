import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
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
  if (_sameList(baseKeys, serverKeys)) return mine;
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
  return result;
}

bool _sameList(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
