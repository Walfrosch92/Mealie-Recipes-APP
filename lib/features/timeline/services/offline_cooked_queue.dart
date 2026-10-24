import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/log_manager.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../providers/timeline_provider.dart';

// ---------------------------------------------------------------------------
// Offline-Warteschlange für „Ich hab's gekocht" (Detail-Sheet + Kochmodus-
// Abschluss) und den Kommentar von der Kochmodus-Abschlussseite.
//
// Ohne Verbindung gingen Zeitleisten-Eintrag, „Zuletzt gekocht", Foto und
// Kommentar bisher still verloren. Jetzt: Eintrag in SharedPreferences, das
// Foto als Kopie in Application Support (der Picker legt es nur temporär
// ab), Nachsenden beim App-Start, bei der Rückkehr in die App und sobald der
// Server wieder antwortet. Verworfen wird nur bei endgültiger Ablehnung
// (403 kein Recht, 404 Rezept gelöscht) — offline, abgelaufene Anmeldung
// (401) oder Serverfehler lassen den Eintrag stehen.
// ---------------------------------------------------------------------------

const _kPendingMade = 'pending_recipe_made';
const _kPendingComments = 'pending_recipe_comments';

Future<List<Map<String, dynamic>>> _load(String key) async {
  try {
    final raw = (await SharedPreferences.getInstance()).getString(key);
    if (raw == null || raw.isEmpty) return [];
    return [
      for (final e in jsonDecode(raw) as List)
        if (e is Map) Map<String, dynamic>.from(e),
    ];
  } catch (_) {
    return [];
  }
}

Future<void> _save(String key, List<Map<String, dynamic>> list) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    if (list.isEmpty) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, jsonEncode(list));
    }
  } catch (_) {}
}

String _newId() =>
    '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 30)}';

Future<String?> _keepPhoto(File? photo, String id) async {
  if (photo == null || !await photo.exists()) return null;
  try {
    final dir = Directory(
        '${(await getApplicationSupportDirectory()).path}/pending_cooked');
    await dir.create(recursive: true);
    final dot = photo.path.lastIndexOf('.');
    final ext = dot > 0 ? photo.path.substring(dot) : '.jpg';
    final copy = await photo.copy('${dir.path}/$id$ext');
    return copy.path;
  } catch (e) {
    LogManager.shared.log('📷 Offline-Foto nicht gesichert: $e');
    return null;
  }
}

Future<void> _deletePhoto(String? path) async {
  if (path == null) return;
  try {
    await File(path).delete();
  } catch (_) {}
}

/// „Ich hab's gekocht" vormerken (von [recordRecipeMade] bei fehlender
/// Verbindung aufgerufen).
Future<void> queueRecipeMade({
  required RecipeDetail recipe,
  required String subject,
  String? message,
  required DateTime timestamp,
  File? photo,
  List<ReferencedRecipe> childRecipes = const [],
  String? childMessageText,
}) async {
  final id = _newId();
  final list = await _load(_kPendingMade);
  list.add({
    'id': id,
    'recipeId': recipe.id,
    'subject': subject,
    if (message != null && message.trim().isNotEmpty) 'message': message,
    'timestamp': timestamp.toUtc().toIso8601String(),
    'photo': await _keepPhoto(photo, id),
    'children': [for (final c in childRecipes) c.toJson()],
    if (childMessageText != null) 'childMessage': childMessageText,
  });
  await _save(_kPendingMade, list);
  LogManager.shared.log('🍳 „Gekocht" offline vorgemerkt (${recipe.slug})');
}

/// Kommentar von der Kochmodus-Abschlussseite vormerken.
Future<void> queueRecipeComment(String recipeId, String text) async {
  final list = await _load(_kPendingComments);
  list.add({'recipeId': recipeId, 'text': text});
  await _save(_kPendingComments, list);
}

/// Endgültige Ablehnung → Eintrag verwerfen. Alles andere → behalten.
bool _isFinal(Object e) {
  final status = e is DioException ? e.response?.statusCode : null;
  return status == 403 || status == 404;
}

bool _flushing = false;

/// Vorgemerkte Einträge senden. Bricht beim ersten nicht-endgültigen Fehler
/// ab (Reihenfolge bleibt erhalten, der Rest wartet auf den nächsten Anlauf).
Future<void> flushOfflineCooked(ProviderContainer container) async {
  if (_flushing) return;
  _flushing = true;
  try {
    final settings = await container.read(settingsProvider.future);
    if (!settings.isConfigured) return;
    final api = container.read(apiServiceProvider);

    final made = await _load(_kPendingMade);
    while (made.isNotEmpty) {
      final e = made.first;
      final photoPath = e['photo'] as String?;
      try {
        // Frischer Server-Stand: „Zuletzt gekocht" wird gegen den echten
        // Wert verglichen (lokal steht der vorgemerkte schon drin), und ein
        // gelöschtes Rezept fällt hier mit 404 auf.
        final recipe = await api.fetchRecipeDetail(e['recipeId'] as String);
        final photo = photoPath != null && await File(photoPath).exists()
            ? File(photoPath)
            : null;
        await sendRecipeMade(
          container,
          recipe: recipe,
          subject: e['subject'] as String? ?? '',
          message: e['message'] as String?,
          timestamp: DateTime.parse(e['timestamp'] as String).toLocal(),
          photo: photo,
          childRecipes: [
            for (final c in (e['children'] as List? ?? const []))
              if (c is Map)
                ReferencedRecipe(
                    id: c['id']?.toString() ?? '',
                    slug: c['slug']?.toString() ?? '',
                    name: c['name']?.toString() ?? ''),
          ],
          childMessageText: e['childMessage'] as String?,
        );
        LogManager.shared.log('🍳 „Gekocht" nachgesendet (${recipe.slug})');
      } catch (err) {
        if (!_isFinal(err)) break;
        LogManager.shared.log('🍳 „Gekocht" verworfen: $err');
      }
      made.removeAt(0);
      await _deletePhoto(photoPath);
      await _save(_kPendingMade, made);
    }

    final comments = await _load(_kPendingComments);
    while (comments.isNotEmpty) {
      final c = comments.first;
      final recipeId = c['recipeId'] as String? ?? '';
      try {
        final comment =
            await api.addRecipeComment(recipeId, c['text'] as String? ?? '');
        for (final r
            in container.read(recipesProvider).valueOrNull ?? const []) {
          if (r.id == recipeId) {
            await container
                .read(recipesProvider.notifier)
                .upsertOne(r.copyWith(comments: [...r.comments, comment]));
          }
        }
        container.invalidate(recipeDetailProvider(recipeId));
      } catch (err) {
        if (!_isFinal(err)) break;
        LogManager.shared.log('💬 Offline-Kommentar verworfen: $err');
      }
      comments.removeAt(0);
      await _save(_kPendingComments, comments);
    }
  } finally {
    _flushing = false;
  }
}
