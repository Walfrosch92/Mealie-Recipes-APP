import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/utils/media_urls.dart';
import '../../../shared/widgets/photo_source_sheet.dart';

// ---------------------------------------------------------------------------
// Bild in einen Rezepttext (Schritt oder Notiz) einfügen — wie die Webapp:
// Foto wählen, als Rezept-Anhang hochladen und als `<img>` in den Text
// setzen. Gemeinsam für Schritte (Rezept-Editor) und Notizen (Editor,
// Detailansicht, Kochmodus).
// ---------------------------------------------------------------------------

/// Gibt das einzufügende `<img>`-Tag zurück oder `null` (abgebrochen bzw.
/// Fehler — der Fehler wird als Hinweis angezeigt).
Future<String?> pickAndUploadRecipeTextImage(
  BuildContext context,
  WidgetRef ref, {
  required String recipeSlug,
  required String recipeId,
}) async {
  final l = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  final file = await pickPhotoWithSource(context);
  if (file == null) return null;
  try {
    final name = file.path.split('/').last;
    final asset = await ref.read(apiServiceProvider).uploadRecipeAsset(
        recipeSlug,
        file: file,
        name: name,
        icon: 'mdi-file-image');
    return '<img src="${recipeAssetPath(recipeId, asset.fileName)}" '
        'height="100%" width="100%"/>';
  } catch (e) {
    messenger.showSnackBar(
        SnackBar(content: Text(mealieErrorMessage(e) ?? l.stepImageFailed)));
    return null;
  }
}

/// Fügt [tag] am Ende des Textfelds an (neue Zeile).
void appendToTextField(TextEditingController ctrl, String tag) {
  final t = ctrl.text.trimRight();
  ctrl.text = t.isEmpty ? tag : '$t\n$tag';
  ctrl.selection = TextSelection.collapsed(offset: ctrl.text.length);
}
