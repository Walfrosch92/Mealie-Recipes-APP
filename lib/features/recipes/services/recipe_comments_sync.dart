import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/services/log_manager.dart';
import '../providers/recipes_provider.dart';

// ---------------------------------------------------------------------------
// Kommentare anlegen/löschen. Anders als Notizen NICHT offline-first: ein
// Kommentar braucht die Server-id und den Verfasser, beides vergibt Mealie.
// Erst nach erfolgreichem Request wird Liste + Datei-Cache nachgezogen
// (upsertOne), damit der Kommentar auch offline sichtbar bleibt.
// Fehler werden weitergeworfen → der Aufrufer zeigt eine Meldung.
// ---------------------------------------------------------------------------

RecipeDetail _latest(WidgetRef ref, RecipeDetail recipe) {
  for (final r in ref.read(recipesProvider).valueOrNull ?? const []) {
    if (r.id == recipe.id) return r;
  }
  return recipe;
}

Future<RecipeComment> postRecipeComment(
    WidgetRef ref, RecipeDetail recipe, String text) async {
  final comment = await ref
      .read(apiServiceProvider)
      .addRecipeComment(recipe.id, text.trim());
  final latest = _latest(ref, recipe);
  await ref
      .read(recipesProvider.notifier)
      .upsertOne(latest.copyWith(comments: [...latest.comments, comment]));
  LogManager.shared.log('💬 Kommentar gespeichert (${recipe.slug})');
  return comment;
}

Future<void> deleteRecipeCommentEverywhere(
    WidgetRef ref, RecipeDetail recipe, RecipeComment comment) async {
  await ref.read(apiServiceProvider).deleteRecipeComment(comment.id);
  final latest = _latest(ref, recipe);
  await ref.read(recipesProvider.notifier).upsertOne(latest.copyWith(
      comments: latest.comments.where((c) => c.id != comment.id).toList()));
}
