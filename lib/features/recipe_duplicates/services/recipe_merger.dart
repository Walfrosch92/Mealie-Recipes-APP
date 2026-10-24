import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../../core/services/log_manager.dart';
import '../../mealplan/providers/mealplan_provider.dart';
import '../../recipes/providers/favorites_provider.dart';
import '../../recipes/providers/recipes_provider.dart';

// ---------------------------------------------------------------------------
// Doppelte Rezepte zusammenführen: [keep] bleibt, [remove] wird gelöscht.
//
// Mealie löscht mit einem Rezept per Cascade auch seine Essensplan-Einträge,
// Kommentare, Zeitleiste, Anhänge und Favoriten-/Bewertungs-Zeilen
// (mealie/db/models/recipe/recipe.py). Damit nichts Wichtiges verloren geht,
// wird VOR dem Löschen übernommen:
//   • Kategorien, Schlagworte, Utensilien, Notizen (Vereinigung, PATCH)
//   • geplante Mahlzeiten → zeigen danach auf [keep]
//   • eigener Favorit
// Kommentare/Zeitleiste/Anhänge lassen sich per API nicht umhängen — der
// Bestätigungsdialog sagt das.
// Reihenfolge: erst prüfen, dann übernehmen, dann löschen. Scheitert etwas
// davor, wird nichts gelöscht.
//
// Rechte wie Mealie (RecipeService): Löschen nur Ersteller/Admin — geprüft
// am FRISCHEN Server-Stand (alter Cache kann den Ersteller nicht kennen).
// Darf der Nutzer [keep] nicht sicher bearbeiten (fremd + gesperrt oder
// anderer Haushalt), werden Kategorien/Schlagworte/Utensilien/Notizen NICHT
// übernommen (der PATCH würde mit 403 scheitern) — der Dialog sagt es vorher.
// ---------------------------------------------------------------------------

/// Ein zu löschendes Rezept gehört laut Server jemand anderem.
class DuplicateMergeNotAllowed implements Exception {
  const DuplicateMergeNotAllowed();
}

Future<void> mergeDuplicateRecipes(
  WidgetRef ref, {
  required RecipeDetail keep,
  required List<RecipeDetail> remove,
}) async {
  final api = ref.read(apiServiceProvider);
  final perms = ref.read(userPermissionsProvider);
  final removeIds = {for (final r in remove) r.id};

  // 0. Server-Stand holen und Löschrecht prüfen, BEVOR irgendetwas
  //    geändert wird.
  final fresh = await api.fetchRecipeDetail(keep.id);
  final freshRemove = [
    for (final r in remove) await api.fetchRecipeDetail(r.id),
  ];
  if (freshRemove.any((r) => !canDeleteRecipe(perms, r))) {
    throw const DuplicateMergeNotAllowed();
  }
  remove = freshRemove;

  // 1. Organizer + Notizen vereinigen — auf Basis des Server-Stands von
  //    [keep] (PATCH ersetzt die Listen komplett). Nur wenn [keep]
  //    bearbeitet werden darf.
  final mayEditKeep = canSurelyEditRecipe(perms, fresh);
  final categories = {for (final c in fresh.recipeCategory) c.id: c};
  final tags = {for (final t in fresh.tags) t.id: t};
  final tools = {for (final t in fresh.tools) t.id: t};
  final notes = [...fresh.notes];
  String noteKey(RecipeNote n) => '${n.title.trim()}\n${n.text.trim()}';
  final noteKeys = {for (final n in notes) noteKey(n)};
  var changed = false;
  for (final r in remove) {
    for (final c in r.recipeCategory) {
      if (!categories.containsKey(c.id)) {
        categories[c.id] = c;
        changed = true;
      }
    }
    for (final t in r.tags) {
      if (!tags.containsKey(t.id)) {
        tags[t.id] = t;
        changed = true;
      }
    }
    // Mealie verlangt den Slug beim Speichern von Utensilien — ältere
    // Cache-Einträge ohne Slug lieber auslassen als den PATCH zu riskieren.
    for (final t in r.tools) {
      if (!tools.containsKey(t.id) && t.slug.isNotEmpty) {
        tools[t.id] = t;
        changed = true;
      }
    }
    for (final n in r.notes) {
      if (noteKeys.add(noteKey(n))) {
        notes.add(n);
        changed = true;
      }
    }
  }
  if (changed && mayEditKeep) {
    await api.updateRecipe(keep.id, {
      'recipeCategory': [for (final c in categories.values) c.toJson()],
      'tags': [for (final t in tags.values) t.toJson()],
      'tools': [
        for (final t in tools.values)
          {'id': t.id, 'name': t.name, 'slug': t.slug}
      ],
      'notes': [
        for (final n in notes) {'title': n.title, 'text': n.text}
      ],
    });
  }

  // 2. Geplante Mahlzeiten umhängen (sonst löscht Mealie sie mit).
  var movedMeals = 0;
  final entries = await api.fetchAllMealplanEntries();
  for (final e in entries) {
    final rid = e.recipeId ?? e.recipe?.id;
    if (rid == null || !removeIds.contains(rid)) continue;
    await api.updateMealplanEntry(e,
        date: e.date, entryType: e.entryType, recipeId: keep.id);
    movedMeals++;
  }

  // 3. Eigenen Favoriten übernehmen.
  final favs = ref.read(favoritesProvider).valueOrNull ?? const <String>{};
  if (!favs.contains(keep.id) && remove.any((r) => favs.contains(r.id))) {
    try {
      await ref
          .read(favoritesProvider.notifier)
          .toggle(id: keep.id, slug: fresh.slug);
    } catch (_) {/* Favorit ist Komfort — kein Grund abzubrechen */}
  }

  // 4. Löschen.
  for (final r in remove) {
    await api.deleteRecipe(r.id);
    ref.read(recipesProvider.notifier).removeById(r.id);
  }

  // Lokalen Stand nachziehen: zusammengeführtes Rezept + Essensplan.
  try {
    final merged = await api.fetchRecipeDetail(keep.id);
    await ref.read(recipesProvider.notifier).upsertOne(merged);
  } catch (_) {}
  if (movedMeals > 0) {
    try {
      await ref.read(mealplanProvider.notifier).refresh();
    } catch (_) {}
  }
  LogManager.shared.log('Duplikate zusammengeführt: ${keep.name} behalten, '
      '${remove.length} gelöscht, $movedMeals Mahlzeiten umgehängt');
}
