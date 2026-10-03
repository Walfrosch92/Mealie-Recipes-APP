import '../../../core/utils/platform_features.dart';
import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/app_settings.dart';
import '../../../core/models/organizer_item.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/cached_json_list.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/recipe_image_store.dart';
import '../../../core/utils/media_urls.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/photo_source_sheet.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../../foods_units/providers/foods_units_admin_provider.dart';
import '../../organizers/providers/organizers_provider.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../models/recipe_draft.dart';
import '../widgets/edit_common.dart';
import '../widgets/edit_sheets.dart';
import '../widgets/ingredient_edit_row.dart';
import '../widgets/organization_section.dart';
import '../widgets/recipe_meta_sections.dart';
import '../widgets/step_edit_row.dart';
import 'recipe_json_editor_screen.dart';

// ---------------------------------------------------------------------------
// Rezept bearbeiten — Funktionsumfang wie der Editor der Mealie-Webapp:
// Bild (Kamera, Fotos, URL, entfernen), Name, Beschreibung, Portionen,
// Ertrag, Zeiten, Bewertung; Zutaten mit Abschnitten, Unterrezepten,
// Alternativen, Parser, Mehrfach-Hinzufügen und Umsortieren; Schritte mit
// Abschnitten, Überschrift, Markdown-Vorschau, Bildern, Verknüpfungen
// (Zutaten + Notizen), Zusammenführen und Umsortieren; Notizen, Kategorien/
// Schlagworte/Utensilien, Nährwerte, Rezept-Einstellungen, Besitzer,
// Ursprüngliche URL, API-Extras und JSON-Editor (beide „Erweitert").
//
// Gespeichert wird über [RecipeDraft]: Roh-JSON als Basis, darüber nur die
// bearbeiteten Felder — die App „vergisst" nichts mehr.
// ---------------------------------------------------------------------------

class RecipeEditScreen extends ConsumerStatefulWidget {
  final String slug;
  const RecipeEditScreen({super.key, required this.slug});

  @override
  ConsumerState<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

enum _ImageChoice { camera, gallery, url, remove }

class _RecipeEditScreenState extends ConsumerState<RecipeEditScreen> {
  RecipeDraft? _draft;
  bool _loadFailed = false;

  /// Der Nutzer hat das Formular berührt → ein später eintreffender
  /// Server-Stand ersetzt den Cache-Entwurf nicht mehr.
  bool _touched = false;

  double? _rating;
  double? _initialRating;

  // Bild: wird erst beim Speichern angewendet (Abbrechen verwirft es).
  File? _newImage;
  String? _newImageUrl;
  bool _removeImage = false;

  bool _saving = false;
  String? _error;
  String? _uploadingStepUid;

  List<String> _unitNames = [];
  List<String> _foodNames = [];
  List<Map<String, dynamic>> _unitsRaw = [];
  List<Map<String, dynamic>> _foods = [];

  bool _showMeta = false;
  bool _showIngredients = false;
  bool _showSteps = false;
  bool _showNotes = false;
  bool _showOrganization = false;
  bool _showNutrition = false;
  bool _showSettings = false;

  @override
  void initState() {
    super.initState();
    _listenUnitsAndFoods();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _draft?.dispose();
    super.dispose();
  }

  // ── Laden: Cache sofort, Server-Rohdaten im Hintergrund ──────────────────

  Future<String?> _serverVersion() async {
    try {
      final info = await ref
          .read(serverInfoProvider.future)
          .timeout(const Duration(seconds: 3));
      return info.isEmpty ? null : info.first['version']?.toString();
    } catch (_) {
      return null;
    }
  }

  Future<void> _load() async {
    final api = ref.read(apiServiceProvider);
    final rawFuture = api
        .fetchRecipeRaw(widget.slug)
        .then<Map<String, dynamic>?>((r) => r)
        .catchError((_) => null);
    final version = await _serverVersion();

    try {
      final cached = await ref.read(recipeDetailProvider(widget.slug).future);
      if (!mounted) return;
      if (_draft == null) {
        _setDraft(RecipeDraft.fromCache(cached, serverVersion: version));
        _rating = _initialRating = cached.rating;
      }
    } catch (_) {/* evtl. kommt der Server-Stand */}

    final raw = await rawFuture;
    if (!mounted) return;
    if (raw != null) {
      final d = _draft;
      if (d == null || (!d.complete && !_touched && !d.isDirty)) {
        _setDraft(RecipeDraft.fromRaw(raw, serverVersion: version));
        if (d == null) {
          _rating = _initialRating = (raw['rating'] as num?)?.toDouble();
        }
      }
    } else if (_draft == null) {
      setState(() => _loadFailed = true);
    }
  }

  void _setDraft(RecipeDraft d) {
    final old = _draft;
    setState(() => _draft = d);
    if (old != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
    }
  }

  // Einheiten + Lebensmittel cache-first (Vorschläge, Namensauflösung).
  void _listenUnitsAndFoods() {
    ref.listenManual<AsyncValue<List<Map<String, dynamic>>>>(
      foodsUnitsAdminProvider(FoodUnitKind.unit),
      (_, next) {
        final units = next.valueOrNull;
        if (units == null || !mounted) return;
        setState(() {
          _unitsRaw = units;
          _unitNames = [
            for (final u in units)
              if (((u['name'] as String?)?.trim() ?? '').isNotEmpty)
                (u['name'] as String).trim()
          ];
        });
      },
      fireImmediately: true,
    );
    ref.listenManual<AsyncValue<List<Map<String, dynamic>>>>(
      foodsUnitsAdminProvider(FoodUnitKind.food),
      (_, next) {
        final foods = next.valueOrNull;
        if (foods == null || !mounted) return;
        setState(() {
          _foods = foods;
          _foodNames = [
            for (final f in foods)
              if (((f['name'] as String?)?.trim() ?? '').isNotEmpty)
                (f['name'] as String).trim()
          ];
        });
      },
      fireImmediately: true,
    );
  }

  Map<String, dynamic>? _findIn(List<Map<String, dynamic>> list, String name) {
    final n = name.trim().toLowerCase();
    if (n.isEmpty) return null;
    // Wie Mealie: Name, Plural, Abkürzungen (Einheiten) und Aliasse zählen —
    // sonst legt „g" neben „Gramm (g)" eine doppelte Einheit an.
    String low(Object? v) => (v as String?)?.trim().toLowerCase() ?? '';
    for (final m in list) {
      final names = <String>{
        low(m['name']),
        low(m['pluralName']),
        low(m['abbreviation']),
        low(m['pluralAbbreviation']),
        for (final a in (m['aliases'] as List?) ?? const [])
          if (a is Map) low(a['name']),
      }..remove('');
      if (names.contains(n)) return Map<String, dynamic>.from(m);
    }
    return null;
  }

  Map<String, dynamic>? _findFood(String name) => _findIn(_foods, name);
  Map<String, dynamic>? _findUnit(String name) => _findIn(_unitsRaw, name);

  bool get _isDirty =>
      (_draft?.isDirty ?? false) ||
      _newImage != null ||
      _newImageUrl != null ||
      _removeImage ||
      _rating != _initialRating;

  void _changed() => setState(() {});

  // ── Speichern ────────────────────────────────────────────────────────────

  String _formatDuration(AppLocalizations l, int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return [
      if (h > 0) l.durationHours(h),
      if (m > 0) l.durationMinutes(m),
    ].join(' ');
  }

  /// Neue Lebensmittel/Einheiten vor dem Speichern anlegen (mit id) —
  /// sonst lehnt Mealie strukturierte Zutaten mit HTTP 422 ab.
  Future<void> _ensureFoodsAndUnits(RecipeDraft d) async {
    if (d.noteOnlyIngredients) return;
    final api = ref.read(apiServiceProvider);
    for (final i in d.ingredients) {
      final food = i.food.text.trim();
      final resolvedFoodOk = i.resolvedFood != null &&
          (i.resolvedFood!['name'] ?? '').toString().trim() == food;
      if (i.writesFood &&
          food.isNotEmpty &&
          !resolvedFoodOk &&
          _findFood(food) == null) {
        final created = await api.createFood(food);
        if (created != null) _foods = [..._foods, created];
      }
      final unit = i.unit.text.trim();
      final resolvedUnitOk = i.resolvedUnit != null &&
          (i.resolvedUnit!['name'] ?? '').toString().trim() == unit;
      if (i.writesUnit &&
          unit.isNotEmpty &&
          !resolvedUnitOk &&
          _findUnit(unit) == null) {
        final created = await api.createUnit(unit);
        if (created != null) _unitsRaw = [..._unitsRaw, created];
      }
    }
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    final d = _draft;
    if (d == null) return;
    if (d.name.text.trim().isEmpty) {
      setState(() => _error = l.recipeName);
      _showErrorDialog(l.recipeName);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _saving = true;
      _error = null;
    });
    final messenger = ScaffoldMessenger.of(context);
    try {
      final api = ref.read(apiServiceProvider);
      final recipeId = d.id.isNotEmpty ? d.id : widget.slug;

      // Aktuellen Server-Stand als Basis (erhält alles Unbearbeitete).
      d.rebase(await api.fetchRecipeRaw(recipeId));
      await _ensureFoodsAndUnits(d);

      final payload = d.buildPayload(
        formatDuration: (m) => _formatDuration(l, m),
        findFood: _findFood,
        findUnit: _findUnit,
      );
      final saved = await api.patchRecipe(recipeId, payload);
      // Bild- und Bewertungs-Endpunkte brauchen den (evtl. neuen) Slug.
      final slug = (saved?['slug'] as String?) ?? d.slug;

      final imageChanged =
          _newImage != null || _newImageUrl != null || _removeImage;
      if (_newImage != null) {
        await api.uploadRecipeImage(slug, _newImage!);
      } else if (_newImageUrl != null) {
        await api.scrapeRecipeImage(slug, _newImageUrl!);
      } else if (_removeImage) {
        await api.deleteRecipeImage(slug);
      }
      if (imageChanged) {
        // Die Bild-URL ist stabil → ohne Evict zeigte der Cache weiter das
        // alte Foto (Platten- und Speicher-Cache), ebenso die Offline-Kopie.
        final serverUrl =
            ref.read(settingsProvider).valueOrNull?.serverUrl ?? '';
        if (serverUrl.isNotEmpty) {
          await CachedNetworkImage.evictFromCache(
              '$serverUrl/api/media/recipes/${d.id}/images/original.webp');
        }
        await RecipeImageStore.shared.remove(d.id);
      }

      if (_rating != _initialRating) {
        try {
          await api.setRating(slug, _rating ?? 0);
        } catch (_) {/* Bewertung blockiert das Speichern nicht */}
      }

      // Gespeicherten Stand (PATCH-Antwort) sofort in Liste + Cache, damit
      // die Detailansicht nicht kurz den alten zeigt; danach dieses eine
      // Rezept neu prüfen (Bild/Bewertung kamen nach dem PATCH).
      if (saved != null) {
        try {
          await ref.read(recipesProvider.notifier).upsertOne(
              RecipeDetail.fromJson(saved)
                  .copyWith(cacheSchema: kRecipeCacheSchema));
        } catch (_) {/* Detail-Abgleich holt es ohnehin */}
      }
      ref.invalidate(recipeDetailProvider(widget.slug));

      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(
        content: Text(l.saveSuccess),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ));
      _goBack(force: true);
    } catch (e) {
      if (!mounted) return;
      final msg = mealieErrorMessage(e) ?? _apiError(e);
      setState(() {
        _error = msg;
        _saving = false;
      });
      _showErrorDialog(msg);
    }
  }

  String _apiError(Object e) {
    if (e is DioException) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      final detail = data is Map && data['detail'] != null
          ? data['detail'].toString()
          : (data?.toString() ?? '');
      if (status != null) {
        return 'HTTP $status${detail.isNotEmpty ? ' – $detail' : ''}';
      }
      return e.type.name;
    }
    return e.toString();
  }

  void _showErrorDialog(String message) {
    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.errorLoadingRecipe),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.ok)),
        ],
      ),
    );
  }

  /// Zurück zur Detailansicht. Ohne Navigator-Eintrag (Deep-Link direkt
  /// hierher) hart auf die Detail-Route.
  Future<void> _goBack({bool force = false}) async {
    if (!force && _isDirty && !await _confirmDiscard()) return;
    if (!mounted) return;
    // Erst PopScope freigeben (neu bauen), dann schließen.
    setState(() => _discardConfirmed = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/recipes/${widget.slug}');
      }
    });
  }

  bool _discardConfirmed = false;

  Future<bool> _confirmDiscard() {
    final l = AppLocalizations.of(context)!;
    return confirmEditAction(context,
        message: l.discardChangesConfirm, confirmLabel: l.discardChanges);
  }

  // ── Bild ─────────────────────────────────────────────────────────────────

  Future<void> _changeImage() async {
    final l = AppLocalizations.of(context)!;
    final hasImage = !_removeImage &&
        (_newImage != null ||
            _newImageUrl != null ||
            (_draft?.raw['image'] != null));
    final choice = await showModalBottomSheet<_ImageChoice>(
      context: context,
      useRootNavigator: true,
      backgroundColor: context.appCard,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (PlatformFeatures.camera)
              ListTile(
                leading: Icon(Icons.photo_camera_rounded, color: ctx.appFg),
                title: Text(l.takePhoto, style: TextStyle(color: ctx.appFg)),
                onTap: () => Navigator.pop(ctx, _ImageChoice.camera),
              ),
            ListTile(
              leading: Icon(Icons.photo_library_rounded, color: ctx.appFg),
              title: Text(l.selectPhoto, style: TextStyle(color: ctx.appFg)),
              onTap: () => Navigator.pop(ctx, _ImageChoice.gallery),
            ),
            ListTile(
              leading: Icon(Icons.link_rounded, color: ctx.appFg),
              title: Text(l.imageFromUrl, style: TextStyle(color: ctx.appFg)),
              onTap: () => Navigator.pop(ctx, _ImageChoice.url),
            ),
            if (hasImage)
              ListTile(
                leading:
                    const Icon(Icons.delete_outline_rounded, color: Colors.red),
                title: Text(l.deleteRecipeImage,
                    style: const TextStyle(color: Colors.red)),
                onTap: () => Navigator.pop(ctx, _ImageChoice.remove),
              ),
          ],
        ),
      ),
    );
    if (choice == null || !mounted) return;
    switch (choice) {
      case _ImageChoice.camera:
      case _ImageChoice.gallery:
        final file = await pickPhotoFromSource(
            context,
            choice == _ImageChoice.camera
                ? ImageSource.camera
                : ImageSource.gallery);
        if (file == null || !mounted) return;
        setState(() {
          _newImage = file;
          _newImageUrl = null;
          _removeImage = false;
        });
      case _ImageChoice.url:
        final url = await showTextInputDialog(context,
            title: l.imageFromUrl,
            hint: 'https://…',
            keyboardType: TextInputType.url,
            capitalization: TextCapitalization.none,
            confirmLabel: l.apply);
        if (url == null || !mounted) return;
        final uri = Uri.tryParse(url);
        if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.invalidUrl)));
          return;
        }
        setState(() {
          _newImageUrl = url;
          _newImage = null;
          _removeImage = false;
        });
      case _ImageChoice.remove:
        final ok = await confirmEditAction(context,
            message: l.deleteRecipeImageConfirm, confirmLabel: l.delete);
        if (!ok || !mounted) return;
        setState(() {
          _removeImage = true;
          _newImage = null;
          _newImageUrl = null;
        });
    }
  }

  // ── Zutaten ──────────────────────────────────────────────────────────────

  void _reorder<T>(List<T> list, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    setState(() => list.insert(newIndex, list.removeAt(oldIndex)));
  }

  void _disposeLater(void Function() dispose) =>
      WidgetsBinding.instance.addPostFrameCallback((_) => dispose());

  Future<void> _ingredientAction(
      DraftIngredient item, IngredientAction a) async {
    final d = _draft!;
    final list = d.ingredients;
    final i = list.indexOf(item);
    if (i < 0) return;
    switch (a) {
      case IngredientAction.toggleSection:
        setState(() {
          if (item.showTitle) item.title.clear();
          item.showTitle = !item.showTitle;
        });
      case IngredientAction.linkRecipe:
        final r = await showRecipePickerSheet(context, excludeId: d.id);
        if (r == null || !mounted) return;
        setState(() {
          item.linkedRecipe = r;
          item.food.clear();
        });
      case IngredientAction.useFood:
        setState(() => item.linkedRecipe = null);
      case IngredientAction.toggleSubstitutions:
        setState(() {
          if (item.showSubstitutions) {
            for (final s in item.substitutions) {
              _disposeLater(s.dispose);
            }
            item.substitutions.clear();
            item.showSubstitutions = false;
          } else {
            if (item.substitutions.isEmpty) {
              item.substitutions.add(DraftSubstitution());
            }
            item.showSubstitutions = true;
          }
        });
      case IngredientAction.insertAbove:
        setState(() => list.insert(i, DraftIngredient.empty()));
      case IngredientAction.insertBelow:
        setState(() => list.insert(i + 1, DraftIngredient.empty()));
      case IngredientAction.moveTop:
        setState(() => list.insert(0, list.removeAt(i)));
      case IngredientAction.moveBottom:
        setState(() => list.add(list.removeAt(i)));
      case IngredientAction.delete:
        setState(() => list.removeAt(i));
        _disposeLater(item.dispose);
    }
  }

  Future<void> _bulkAddIngredients() async {
    final l = AppLocalizations.of(context)!;
    final lines = await showBulkAddSheet(context, title: l.bulkAddIngredients);
    if (lines == null || !mounted) return;
    setState(() => _draft!.ingredients
        .addAll([for (final t in lines) DraftIngredient.empty(note: t)]));
  }

  Future<void> _parseIngredients() async {
    final l = AppLocalizations.of(context)!;
    final d = _draft!;
    final applied = await showIngredientParseSheet(
      context,
      ingredients: d.ingredients,
      unitsRaw: _unitsRaw,
      findFood: _findFood,
      findUnit: _findUnit,
    );
    if (applied != true || !mounted) return;
    setState(() {
      // Alte Server: geparste Zutaten brauchen sichtbare Mengen.
      if (d.settings['disableAmount'] == true) {
        d.settings['disableAmount'] = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(l.reparseDone),
      duration: const Duration(seconds: 2),
    ));
  }

  // ── Schritte ─────────────────────────────────────────────────────────────

  Future<void> _stepAction(DraftStep item, StepAction a) async {
    final d = _draft!;
    final list = d.steps;
    final i = list.indexOf(item);
    if (i < 0) return;
    switch (a) {
      case StepAction.toggleSection:
        setState(() {
          if (item.showTitle) item.title.clear();
          item.showTitle = !item.showTitle;
        });
      case StepAction.link:
        await showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          useSafeArea: true,
          isScrollControlled: true,
          backgroundColor: context.appCard,
          builder: (_) => LinkReferencesSheet(
            step: item,
            allSteps: list,
            ingredients: d.ingredients,
            notes: d.notes,
            notesSupported: d.caps.noteReferences,
          ),
        );
        if (mounted) setState(() {});
      case StepAction.insertImage:
        await _insertStepImage(item);
      case StepAction.togglePreview:
        setState(() => item.preview = !item.preview);
      case StepAction.mergeAbove:
        if (i == 0) return;
        final prev = list[i - 1];
        setState(() {
          final a = prev.text.text.trimRight();
          final b = item.text.text.trim();
          prev.text.text = [a, b].where((s) => s.isNotEmpty).join('\n\n');
          for (final r in item.ingredientRefs) {
            if (!prev.ingredientRefs.contains(r)) prev.ingredientRefs.add(r);
          }
          for (final r in item.noteRefs) {
            if (!prev.noteRefs.contains(r)) prev.noteRefs.add(r);
          }
          list.removeAt(i);
        });
        _disposeLater(item.dispose);
      case StepAction.insertAbove:
        setState(() => list.insert(i, DraftStep.empty()));
      case StepAction.insertBelow:
        setState(() => list.insert(i + 1, DraftStep.empty()));
      case StepAction.moveTop:
        setState(() => list.insert(0, list.removeAt(i)));
      case StepAction.moveBottom:
        setState(() => list.add(list.removeAt(i)));
      case StepAction.delete:
        setState(() => list.removeAt(i));
        _disposeLater(item.dispose);
    }
  }

  /// Bild in einen Schritt (wie die Webapp): als Anhang hochladen und als
  /// `<img>` in den Schritt-Text einfügen.
  Future<void> _insertStepImage(DraftStep step) async {
    final l = AppLocalizations.of(context)!;
    final d = _draft!;
    final file = await pickPhotoWithSource(context);
    if (file == null || !mounted) return;
    setState(() => _uploadingStepUid = step.uid);
    try {
      final name = file.path.split('/').last;
      final asset = await ref.read(apiServiceProvider).uploadRecipeAsset(
          d.slug.isNotEmpty ? d.slug : widget.slug,
          file: file,
          name: name,
          icon: 'mdi-file-image');
      if (!mounted) return;
      final tag = '<img src="${recipeAssetPath(d.id, asset.fileName)}" '
          'height="100%" width="100%"/>';
      setState(() {
        final t = step.text.text.trimRight();
        step.text.text = t.isEmpty ? tag : '$t\n$tag';
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mealieErrorMessage(e) ?? l.stepImageFailed)));
    } finally {
      if (mounted) setState(() => _uploadingStepUid = null);
    }
  }

  Future<void> _bulkAddSteps() async {
    final l = AppLocalizations.of(context)!;
    final lines = await showBulkAddSheet(context, title: l.bulkAddSteps);
    if (lines == null || !mounted) return;
    setState(() => _draft!.steps
        .addAll([for (final t in lines) DraftStep.empty(text: t)]));
  }

  // ── Kategorien / Schlagworte / Utensilien ────────────────────────────────

  Future<String?> _promptName(String title) =>
      showTextInputDialog(context, title: title);

  void _toggleIn(List<Map<String, dynamic>> list, Map<String, dynamic> o) {
    setState(() {
      final i = list.indexWhere((x) => x['id'] == o['id']);
      i >= 0 ? list.removeAt(i) : list.add(o);
    });
  }

  Future<void> _createTag() async {
    final l = AppLocalizations.of(context)!;
    final name = await _promptName(l.newTag);
    if (name == null) return;
    try {
      final api = ref.read(apiServiceProvider);
      // Vorhandenen Tag gleichen Namens wiederverwenden (UNIQUE-Slug → 500).
      final existing = await api.fetchTags();
      final t = name.toLowerCase();
      final match =
          existing.where((x) => x.name.trim().toLowerCase() == t).firstOrNull;
      final tag = match ?? await api.createTag(name);
      if (!mounted) return;
      final tags = _draft!.tags;
      if (!tags.any((x) => x['id'] == tag.id)) {
        setState(() => tags.add(tag.toJson()));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.createFailed}: ${_apiError(e)}')));
    }
  }

  Future<void> _createCategory() async {
    final l = AppLocalizations.of(context)!;
    final name = await _promptName(l.newCategory);
    if (name == null) return;
    try {
      final api = ref.read(apiServiceProvider);
      final existing = await api.fetchCategories();
      final t = name.toLowerCase();
      final match =
          existing.where((x) => x.name.trim().toLowerCase() == t).firstOrNull;
      final cat = match ?? await api.createCategory(name);
      if (!mounted) return;
      final cats = _draft!.categories;
      if (!cats.any((x) => x['id'] == cat.id)) {
        setState(() => cats.add(cat.toJson()));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.createFailed}: ${_apiError(e)}')));
    }
  }

  Future<void> _createTool() async {
    final l = AppLocalizations.of(context)!;
    final name = await _promptName(l.newTool);
    if (name == null) return;
    try {
      final item = await ref
          .read(organizersProvider(OrganizerKind.tool).notifier)
          .create(name);
      if (!mounted) return;
      final tools = _draft!.tools;
      if (!tools.any((x) => x['id'] == item.id)) {
        setState(() =>
            tools.add({'id': item.id, 'name': item.name, 'slug': item.slug}));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.createFailed}: ${_apiError(e)}')));
    }
  }

  Future<bool> _confirmDelete(String name) {
    final l = AppLocalizations.of(context)!;
    return confirmEditAction(context,
        message: l.deleteOrganizerConfirm(name), confirmLabel: l.delete);
  }

  Future<void> _deleteTool(OrganizerItem t) async {
    final l = AppLocalizations.of(context)!;
    if (!await _confirmDelete(t.name)) return;
    try {
      await ref.read(organizersProvider(OrganizerKind.tool).notifier).delete(t);
      if (!mounted) return;
      setState(() => _draft!.tools.removeWhere((x) => x['id'] == t.id));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.deleteFailed)));
    }
  }

  Future<void> _deleteTag(TagSummary t) async {
    final l = AppLocalizations.of(context)!;
    if (!await _confirmDelete(t.name)) return;
    try {
      await ref.read(apiServiceProvider).deleteTag(t.id);
      if (!mounted) return;
      setState(() => _draft!.tags.removeWhere((x) => x['id'] == t.id));
      ref.read(recipesProvider.notifier).stripTagEverywhere(t.id);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.deleteFailed)));
    }
  }

  Future<void> _deleteCategory(CategorySummary c) async {
    final l = AppLocalizations.of(context)!;
    if (!await _confirmDelete(c.name)) return;
    try {
      await ref.read(apiServiceProvider).deleteCategory(c.id);
      if (!mounted) return;
      setState(() => _draft!.categories.removeWhere((x) => x['id'] == c.id));
      ref.read(recipesProvider.notifier).stripCategoryEverywhere(c.id);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.deleteFailed)));
    }
  }

  /// Slug eines Utensils: Mealie verlangt ihn — ältere Einträge kennen ihn
  /// nicht, dann aus der Utensilien-Liste bzw. dem Namen.
  Map<String, dynamic> _withToolSlug(Map<String, dynamic> t) {
    final slug = (t['slug'] as String?) ?? '';
    if (slug.isNotEmpty) return t;
    final all = ref.read(organizersProvider(OrganizerKind.tool)).valueOrNull ??
        const <OrganizerItem>[];
    for (final i in all) {
      if (i.id == t['id'] && i.slug.isNotEmpty) return {...t, 'slug': i.slug};
    }
    final name = (t['name'] as String?) ?? '';
    return {
      ...t,
      'slug': name
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9äöüß]+'), '-')
          .replaceAll(RegExp(r'^-+|-+$'), ''),
    };
  }

  // ── JSON-Editor (Erweitert) ──────────────────────────────────────────────

  Future<void> _openJsonEditor() async {
    final d = _draft!;
    if (_isDirty && !await _confirmDiscard()) return;
    if (!mounted) return;
    final saved = await Navigator.of(context, rootNavigator: true).push<bool>(
      MaterialPageRoute(
        builder: (_) => RecipeJsonEditorScreen(
            recipeId: d.id.isNotEmpty ? d.id : widget.slug),
      ),
    );
    if (saved == true && mounted) {
      ref.invalidate(recipeDetailProvider(widget.slug));
      _goBack(force: true);
    }
  }

  // ── UI ───────────────────────────────────────────────────────────────────

  Widget _proxyDecorator(Widget child, int index, Animation<double> anim) =>
      Material(
        elevation: 6,
        color: context.appCard,
        borderRadius: BorderRadius.circular(AppTokens.rSm),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final d = _draft;

    if (d == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.editRecipe)),
        body: SafeArea(
          top: false,
          child: Center(
            child: _loadFailed
                ? Text(l.errorLoadingRecipe,
                    style: TextStyle(color: context.appFgSub))
                : const CircularProgressIndicator(),
          ),
        ),
      );
    }

    final perms = ref.watch(userPermissionsProvider);
    final me = ref.watch(currentUserProvider);
    final advanced = me?['advanced'] == true;
    final settings = ref.watch(settingsProvider).valueOrNull;
    final serverUrl = settings?.serverUrl ?? '';
    final members = ref.watch(groupMembersProvider).valueOrNull ?? const [];
    final owner = members.where((u) => u['id'] == d.userId).firstOrNull ??
        (me != null && me['id'] == d.userId ? me : null);
    final origOwner = d.raw['userId']?.toString();
    final isOwner = perms.id != null && perms.id == origOwner;
    final canEditOwner = isOwner || perms.admin;

    final tagObjs = [
      for (final t in d.tags)
        TagSummary(
            id: '${t['id']}',
            name: '${t['name'] ?? ''}',
            slug: '${t['slug'] ?? ''}')
    ];
    final catObjs = [
      for (final c in d.categories)
        CategorySummary(
            id: '${c['id']}',
            name: '${c['name'] ?? ''}',
            slug: '${c['slug'] ?? ''}')
    ];
    final toolObjs = [
      for (final t in d.tools)
        RecipeTool(
            id: '${t['id']}',
            name: '${t['name'] ?? ''}',
            slug: '${t['slug'] ?? ''}')
    ];
    final organizeCount = d.tags.length + d.categories.length + d.tools.length;
    final nutritionCount =
        d.nutrition.values.where((c) => c.text.trim().isNotEmpty).length;
    final hasUnparsed = d.ingredients.any((i) => i.isUnparsed);
    final stepLinks = {
      for (final i in d.ingredients) i.referenceId,
      for (final n in d.notes) n.referenceId,
    };

    return PopScope(
      canPop: !_isDirty || _discardConfirmed,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goBack();
      },
      child: Scaffold(
        backgroundColor: context.appBg,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          leadingWidth: 96,
          leading: TextButton(
            onPressed: _saving ? null : () => _goBack(),
            child: Text(l.cancel,
                maxLines: 1,
                overflow: TextOverflow.visible,
                softWrap: false,
                style: const TextStyle(color: Colors.red)),
          ),
          title: Text(l.editRecipe,
              style: TextStyle(color: context.appFg, fontSize: 16)),
          actions: [
            TextButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l.saveChanges,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        body: Listener(
          onPointerDown: (_) => _touched = true,
          child: WithCookingModeFAB(
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              slivers: [
                SliverToBoxAdapter(child: _header(context, l, d, settings)),

                // ── Portionen & Zeiten ─────────────────────────────
                SliverToBoxAdapter(
                  child: EditSection(
                    icon: Icons.access_time_rounded,
                    title: l.servingsAndTimes,
                    badge: _metaBadge(d),
                    expanded: _showMeta,
                    onToggle: () => setState(() => _showMeta = !_showMeta),
                    child: TimesServingsContent(
                      draft: d,
                      rating: _rating,
                      onRatingChanged: (v) => setState(() => _rating = v),
                      onChanged: _changed,
                    ),
                  ),
                ),

                // ── Zutaten ────────────────────────────────────────
                SliverToBoxAdapter(
                  child: EditSectionHeader(
                    icon: Icons.eco_rounded,
                    title: l.ingredients,
                    badge: d.ingredients.isEmpty
                        ? null
                        : '${d.ingredients.length}',
                    expanded: _showIngredients,
                    onToggle: () =>
                        setState(() => _showIngredients = !_showIngredients),
                  ),
                ),
                if (_showIngredients) ...[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 4, 0),
                    sliver: SliverReorderableList(
                      itemCount: d.ingredients.length,
                      proxyDecorator: _proxyDecorator,
                      onReorder: (o, n) => _reorder(d.ingredients, o, n),
                      itemBuilder: (_, i) {
                        final item = d.ingredients[i];
                        return IngredientEditRow(
                          key: ValueKey(item.uid),
                          item: item,
                          index: i,
                          count: d.ingredients.length,
                          unitNames: _unitNames,
                          foodNames: _foodNames,
                          foodExists: (n) => _findFood(n) != null,
                          noteOnly: d.noteOnlyIngredients,
                          substitutionsSupported:
                              d.caps.substitutions && d.complete,
                          onAction: (a) => _ingredientAction(item, a),
                          onPickRecipe: () => _ingredientAction(
                              item, IngredientAction.linkRecipe),
                          onChanged: _changed,
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: EditSectionBody(
                      child: Column(children: [
                        if (d.ingredients.isNotEmpty &&
                                !d.noteOnlyIngredients ||
                            hasUnparsed)
                          EditActionTile(
                            icon: Icons.auto_fix_high,
                            title: l.reparseIngredients,
                            subtitle: hasUnparsed
                                ? l.reparseIngredientsSubtitle
                                : null,
                            onTap: _parseIngredients,
                          ),
                        EditActionTile(
                          icon: Icons.add_circle_outline,
                          title: l.addIngredientLine,
                          onTap: () => setState(
                              () => d.ingredients.add(DraftIngredient.empty())),
                        ),
                        EditActionTile(
                          icon: Icons.segment_rounded,
                          title: l.addIngredientSection,
                          onTap: () => setState(() => d.ingredients
                              .add(DraftIngredient.empty(section: true))),
                        ),
                        EditActionTile(
                          icon: Icons.playlist_add_rounded,
                          title: l.bulkAddIngredients,
                          onTap: _bulkAddIngredients,
                        ),
                      ]),
                    ),
                  ),
                ],

                // ── Zubereitung ────────────────────────────────────
                SliverToBoxAdapter(
                  child: EditSectionHeader(
                    icon: Icons.format_list_numbered_rounded,
                    title: l.instructions,
                    badge: d.steps.isEmpty ? null : '${d.steps.length}',
                    expanded: _showSteps,
                    onToggle: () => setState(() => _showSteps = !_showSteps),
                  ),
                ),
                if (_showSteps) ...[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 4, 0),
                    sliver: SliverReorderableList(
                      itemCount: d.steps.length,
                      proxyDecorator: _proxyDecorator,
                      onReorder: (o, n) => _reorder(d.steps, o, n),
                      itemBuilder: (_, i) {
                        final item = d.steps[i];
                        return StepEditRow(
                          key: ValueKey(item.uid),
                          item: item,
                          index: i,
                          count: d.steps.length,
                          linkedCount: [
                            ...item.ingredientRefs,
                            if (d.caps.noteReferences) ...item.noteRefs,
                          ].where(stepLinks.contains).length,
                          uploadingImage: _uploadingStepUid == item.uid,
                          serverUrl: serverUrl,
                          apiToken: settings?.apiToken,
                          onAction: (a) => _stepAction(item, a),
                          onChanged: _changed,
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: EditSectionBody(
                      child: Column(children: [
                        EditActionTile(
                          icon: Icons.add_circle_outline,
                          title: l.addInstruction,
                          onTap: () =>
                              setState(() => d.steps.add(DraftStep.empty())),
                        ),
                        EditActionTile(
                          icon: Icons.segment_rounded,
                          title: l.addIngredientSection,
                          onTap: () => setState(() =>
                              d.steps.add(DraftStep.empty(section: true))),
                        ),
                        EditActionTile(
                          icon: Icons.playlist_add_rounded,
                          title: l.bulkAddSteps,
                          onTap: _bulkAddSteps,
                        ),
                      ]),
                    ),
                  ),
                ],

                // ── Notizen ────────────────────────────────────────
                SliverToBoxAdapter(
                  child: EditSection(
                    icon: Icons.sticky_note_2_outlined,
                    title: l.notes,
                    badge: d.notes.isEmpty ? null : '${d.notes.length}',
                    expanded: _showNotes,
                    onToggle: () => setState(() => _showNotes = !_showNotes),
                    child: NotesContent(
                      draft: d,
                      onChanged: _changed,
                      onDelete: (n) {
                        setState(() => d.notes.remove(n));
                        _disposeLater(n.dispose);
                      },
                    ),
                  ),
                ),

                // ── Kategorien, Schlagworte, Utensilien ────────────
                SliverToBoxAdapter(
                  child: EditSection(
                    icon: Icons.sell_rounded,
                    title: l.tagsAndCategories,
                    badge: organizeCount > 0 ? '$organizeCount' : null,
                    expanded: _showOrganization,
                    onToggle: () =>
                        setState(() => _showOrganization = !_showOrganization),
                    child: OrganizationContent(
                      allTags: ref.watch(allTagsProvider),
                      allCategories: ref.watch(allCategoriesProvider),
                      selectedTags: tagObjs,
                      selectedCategories: catObjs,
                      onToggleTag: (t) => _toggleIn(d.tags, t.toJson()),
                      onToggleCategory: (c) =>
                          _toggleIn(d.categories, c.toJson()),
                      onCreateTag: perms.mayOrganize ? _createTag : null,
                      onCreateCategory:
                          perms.mayOrganize ? _createCategory : null,
                      onDeleteTag: perms.mayOrganize ? _deleteTag : null,
                      onDeleteCategory:
                          perms.mayOrganize ? _deleteCategory : null,
                      allTools: ref
                              .watch(organizersProvider(OrganizerKind.tool))
                              .valueOrNull ??
                          const [],
                      selectedTools: toolObjs,
                      onToggleTool: (t) => _toggleIn(
                          d.tools,
                          _withToolSlug(
                              {'id': t.id, 'name': t.name, 'slug': t.slug})),
                      onCreateTool: _createTool,
                      onDeleteTool: _deleteTool,
                      l: l,
                    ),
                  ),
                ),

                // ── Nährwerte ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: EditSection(
                    icon: Icons.local_fire_department_outlined,
                    title: l.nutritionTitle,
                    badge: nutritionCount > 0 ? '$nutritionCount' : null,
                    expanded: _showNutrition,
                    onToggle: () =>
                        setState(() => _showNutrition = !_showNutrition),
                    child: NutritionContent(draft: d, onChanged: _changed),
                  ),
                ),

                // ── Einstellungen ──────────────────────────────────
                SliverToBoxAdapter(
                  child: EditSection(
                    icon: Icons.tune_rounded,
                    title: l.recipeSettingsTitle,
                    expanded: _showSettings,
                    onToggle: () =>
                        setState(() => _showSettings = !_showSettings),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RecipeSettingsContent(
                          draft: d,
                          isOwner: isOwner,
                          canEditOwner: canEditOwner,
                          ownerName: owner == null ? '' : memberName(owner),
                          ownerCacheKey: owner?['cacheKey']?.toString(),
                          showExtras: advanced && d.complete,
                          onPickOwner: () async {
                            final id = await showOwnerPickerSheet(context,
                                selectedId: d.userId);
                            if (id != null && mounted) {
                              setState(() => d.userId = id);
                            }
                          },
                          onChanged: _changed,
                        ),
                        if (advanced)
                          EditActionTile(
                            icon: Icons.data_object_rounded,
                            title: l.jsonEditorTitle,
                            onTap: _saving ? null : _openJsonEditor,
                          ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                      height: 32 + MediaQuery.paddingOf(context).bottom),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _metaBadge(RecipeDraft d) {
    final parts = <String>[];
    final s = parseDraftQuantity(d.servings.text);
    if (s != null && s > 0) parts.add(formatDraftQuantity(s));
    final t = d.total.totalMinutes;
    if (t > 0) {
      final h = t ~/ 60;
      final m = t % 60;
      parts.add(h > 0 ? (m > 0 ? '${h}h ${m}m' : '${h}h') : '${m}m');
    }
    return parts.join(' · ');
  }

  Widget _header(BuildContext context, AppLocalizations l, RecipeDraft d,
      AppSettings? settings) {
    final serverUrl = settings?.serverUrl ?? '';
    final imageUrl =
        '$serverUrl/api/media/recipes/${d.id}/images/original.webp';
    Widget image;
    if (_newImage != null) {
      image = Image.file(_newImage!,
          width: double.infinity, height: 200, fit: BoxFit.cover);
    } else if (_newImageUrl != null) {
      image = CachedNetworkImage(
        imageUrl: _newImageUrl!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _imagePlaceholder(context),
      );
    } else if (_removeImage || serverUrl.isEmpty || d.id.isEmpty) {
      image = _imagePlaceholder(context);
    } else {
      image = CachedNetworkImage(
        imageUrl: imageUrl,
        httpHeaders: mediaHeaders(settings),
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _imagePlaceholder(context),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: GestureDetector(
            onTap: _changeImage,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTokens.rLg),
              child: Stack(
                children: [
                  image,
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppTokens.accentGradient,
                        shape: BoxShape.circle,
                        boxShadow: context.appAccentGlow,
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onTapOutside: unfocusOnTapOutside,
                controller: d.name,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => _changed(),
                style: TextStyle(
                    color: context.appFg,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: l.recipeName,
                  hintStyle: TextStyle(color: context.appFgSub),
                  filled: true,
                  fillColor: context.appSurface2,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Icon(Icons.text_fields, size: 13, color: context.appFgSub),
                const SizedBox(width: 4),
                Text(l.descriptionLabel,
                    style: TextStyle(
                        color: context.appFgSub,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 4),
              TextField(
                onTapOutside: unfocusOnTapOutside,
                controller: d.description,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => _changed(),
                style: TextStyle(color: context.appFg, fontSize: 15),
                minLines: 3,
                maxLines: null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: context.appSurface2,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              if (!d.complete) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTokens.accent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    const Icon(Icons.cloud_off_rounded,
                        size: 18, color: AppTokens.accentDeep),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(l.editorOfflineHint,
                          style: TextStyle(color: context.appFg, fontSize: 13)),
                    ),
                  ]),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(_error!, style: const TextStyle(fontSize: 13)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      height: 200,
      color: context.appSurface2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo, size: 48, color: context.appFgSub),
          const SizedBox(height: 8),
          Text(l.tapToAddPhoto,
              style: TextStyle(color: context.appFgSub, fontSize: 13)),
        ],
      ),
    );
  }
}
