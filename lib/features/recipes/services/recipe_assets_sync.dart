import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/services/log_manager.dart';
import '../providers/recipes_provider.dart';

// ---------------------------------------------------------------------------
// Rezept-Anhänge hochladen/entfernen. Wie Kommentare NICHT offline-first
// (der Server vergibt den Dateinamen). Nach Erfolg werden Liste + Datei-
// Cache nachgezogen (upsertOne).
//
// Hochladen: neuere Mealie-Versionen tragen den Anhang selbst im Rezept ein,
// ältere schreiben nur die Datei (die Webapp speichert danach das Rezept).
// Deshalb wird nach dem Upload der Server-Stand gelesen und die Liste nur
// bei Bedarf per PATCH ergänzt. Zusätzlich `settings.showAssets` an — sonst
// blendet die Webapp die Anhänge in der Ansicht aus.
// ---------------------------------------------------------------------------

/// Dateiendungen, die Mealie als Anhang annimmt (ASSET_ALLOWED_EXTENSIONS).
const kAllowedAssetExtensions = [
  'pdf',
  'jpg',
  'jpeg',
  'png',
  'gif',
  'webp',
  'bmp',
  'avif',
  'txt',
  'md',
  'csv',
  'json',
];

/// mdi-Icon wie in der Webapp-Auswahl, passend zur Dateiendung.
String assetIconForExtension(String ext) => switch (ext.toLowerCase()) {
      'pdf' => 'mdi-file-pdf-box',
      'jpg' ||
      'jpeg' ||
      'png' ||
      'gif' ||
      'webp' ||
      'bmp' ||
      'avif' =>
        'mdi-file-image',
      'json' => 'mdi-code-json',
      _ => 'mdi-file',
    };

RecipeDetail _latest(WidgetRef ref, RecipeDetail recipe) {
  for (final r in ref.read(recipesProvider).valueOrNull ?? const []) {
    if (r.id == recipe.id) return r;
  }
  return recipe;
}

Future<RecipeAsset> addRecipeAsset(WidgetRef ref, RecipeDetail recipe,
    {required File file, required String name}) async {
  final api = ref.read(apiServiceProvider);
  final ext = file.path.split('.').last.toLowerCase();
  final asset = await api.uploadRecipeAsset(recipe.slug,
      file: file, name: name, icon: assetIconForExtension(ext));

  var fresh = await api.fetchRecipeDetail(recipe.id);
  final recorded = fresh.assets.any((a) => a.fileName == asset.fileName);
  final showOff = !(fresh.settings?.showAssets ?? false);
  if (!recorded || showOff) {
    final assets = recorded ? fresh.assets : [...fresh.assets, asset];
    final settings =
        (fresh.settings ?? const RecipeSettings()).copyWith(showAssets: true);
    await api.updateRecipeAssets(recipe.id, assets, settings: settings);
    fresh = fresh.copyWith(assets: assets, settings: settings);
  }
  await ref.read(recipesProvider.notifier).upsertOne(fresh);
  LogManager.shared.log('📎 Anhang hochgeladen (${recipe.slug}): '
      '${asset.fileName}');
  return asset;
}

Future<void> removeRecipeAsset(
    WidgetRef ref, RecipeDetail recipe, RecipeAsset asset) async {
  // Vom aktuellen Server-Stand ausgehen (nicht vom Cache) — sonst würde ein
  // inzwischen in der Webapp hinzugefügter Anhang mit gelöscht, denn der
  // PATCH ersetzt die ganze Anhang-Liste.
  var latest = _latest(ref, recipe);
  try {
    latest = await ref.read(apiServiceProvider).fetchRecipeDetail(recipe.id);
  } catch (_) {/* offline: Cache-Stand */}
  final assets =
      latest.assets.where((a) => a.fileName != asset.fileName).toList();
  await ref.read(apiServiceProvider).updateRecipeAssets(recipe.id, assets);
  await ref
      .read(recipesProvider.notifier)
      .upsertOne(latest.copyWith(assets: assets));
}
