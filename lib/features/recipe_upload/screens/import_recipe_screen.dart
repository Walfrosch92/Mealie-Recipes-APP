import '../../../core/providers/permissions_provider.dart';
import '../../../core/utils/platform_features.dart';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/tap_area.dart';
import 'package:flutter/services.dart' show Clipboard, PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/mealie_version.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

import '../../cooking_mode/widgets/cooking_mode_fab.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/utils/video_url.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/async_action_button.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../../webapp_tools/widgets/tool_widgets.dart' show pickToolFile;
import '../widgets/import_options_sheet.dart';
import '../widgets/import_progress_panel.dart';

// ---------------------------------------------------------------------------
// Add Recipe / Upload — mirrors iOS RecipeUploadView 1:1
//
// Behaviour 1:1 to iOS:
//  - URL / Image / PDF upload all show a success alert + reset form (stay on screen)
//  - errors show an error alert
//  - PDF is rendered to an image (first page) before upload (iOS PDFKit equivalent)
// ---------------------------------------------------------------------------

class ImportRecipeScreen extends ConsumerStatefulWidget {
  const ImportRecipeScreen({super.key, this.sharedUrl});

  /// Kommt vom Share-Deep-Link (iOS Share Extension / Android Share-Sheet,
  /// mealierecipes://import?url=…) — Feld wird nur vorbefüllt. Der Import
  /// startet NICHT automatisch: der Nutzer soll vorher entscheiden können,
  /// ob die KI-Funktion verwendet wird (User-Wunsch 2026-09-27).
  final String? sharedUrl;

  @override
  ConsumerState<ImportRecipeScreen> createState() => _ImportRecipeScreenState();
}

enum _UploadState { idle, preparing, uploading }

/// Welcher Import gerade läuft — jede Box zeigt Fortschritt nur für ihren
/// eigenen (vorher zeigte die Foto-Box auch bei Link/Einfügen/ZIP „Wird
/// hochgeladen …", #45).
enum _ImportKind { url, pages, paste, zip }

class _ImportRecipeScreenState extends ConsumerState<ImportRecipeScreen> {
  // Manuell anlegen (wie „Rezept erstellen" in der Webapp): nur der Name,
  // alles Weitere im Rezept-Editor.
  final _manualNameCtrl = TextEditingController();
  bool _creatingManual = false;

  Future<void> _createManual() async {
    final l = AppLocalizations.of(context)!;
    final name = _manualNameCtrl.text.trim();
    if (name.isEmpty || _creatingManual) return;
    FocusScope.of(context).unfocus();
    setState(() => _creatingManual = true);
    try {
      final recipe =
          await ref.read(apiServiceProvider).createRecipe({'name': name});
      // Sofort in Liste + Cache, damit es auch ohne Speichern auftaucht.
      await ref.read(recipesProvider.notifier).upsertOne(recipe);
      if (!mounted) return;
      _manualNameCtrl.clear();
      setState(() => _creatingManual = false);
      context.push('/recipes/${recipe.id}/edit');
    } catch (e) {
      if (!mounted) return;
      setState(() => _creatingManual = false);
      _showError(mealieErrorMessage(e) ?? l.createFailed);
    }
  }

  final _urlCtrl = TextEditingController();
  _UploadState _state = _UploadState.idle;

  /// URL mit der KI des Servers auswerten (Mealie „Import with AI") statt mit
  /// dem normalen Scraper — für Rezeptvideos und Seiten ohne Rezept-Markup.
  bool _useAi = false;

  /// Hat der Nutzer den Schalter selbst bedient? Dann schaltet die
  /// Video-Erkennung ihn nicht mehr automatisch um.
  bool _aiToggledByUser = false;

  /// Fortschrittsmeldungen des Servers in Eingangsreihenfolge („Video wird
  /// heruntergeladen …", „Audio wird transkribiert …").
  final List<String> _aiSteps = [];

  /// Laufender Import (null = keiner), steuert, WO der Fortschritt steht.
  _ImportKind? _active;

  /// Am Fortschritt des laufenden Imports — wird beim Start ins Bild
  /// gescrollt, falls die Box gerade außerhalb liegt.
  final _progressKey = GlobalKey();

  void _begin(_ImportKind kind, {_UploadState state = _UploadState.uploading}) {
    setState(() {
      _state = state;
      _active = kind;
      _aiSteps.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _progressKey.currentContext;
      if (ctx == null || !ctx.mounted) return;
      Scrollable.ensureVisible(ctx,
          alignment: 0.5,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic);
    });
  }

  /// Fortschrittsmeldung von /create/ai/stream als neuer Schritt.
  void _onAiProgress(String msg) {
    final m = msg.trim();
    if (!mounted || m.isEmpty) return;
    // Gleiche Meldung zweimal hintereinander = derselbe Schritt.
    if (_aiSteps.isNotEmpty && _aiSteps.last == m) return;
    setState(() => _aiSteps.add(m));
  }

  void _end() {
    if (!mounted) return;
    setState(() {
      _state = _UploadState.idle;
      _active = null;
      _aiSteps.clear();
    });
  }

  static const int _maxFileSize = 10 * 1024 * 1024; // 10 MB (iOS maxFileSize)

  /// Gesammelte Seiten für den KI-Import (Kamera / Galerie / PDF), in der
  /// Reihenfolge, in der sie hochgeladen werden. Erste Seite = Hauptbild.
  final List<File> _pages = [];
  static const int _maxPages = 10;

  bool get _isUploading => _state == _UploadState.uploading;
  bool get _isBusy => _state != _UploadState.idle;
  bool get _canAddPages => !_isBusy && _pages.length < _maxPages;

  @override
  void initState() {
    super.initState();
    final shared = widget.sharedUrl;
    if (shared != null && shared.isNotEmpty) {
      _urlCtrl.text = shared;
      // Geteiltes Rezeptvideo (z. B. aus der Instagram-App): KI-Schalter
      // vorbelegen — wie beim Eintippen, bleibt frei umschaltbar.
      _useAi = _aiForVideo(shared);
    }
  }

  @override
  void dispose() {
    _manualNameCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  void _resetForm() {
    _urlCtrl.clear();
    _pages.clear();
    _aiToggledByUser = false;
    _useAi = false;
    if (mounted) setState(() {});
  }

  /// KI-Schalter vorbelegen: bei Video-Links nur, wenn im Zahnrad
  /// „Gründlich" gewählt ist (Standard). „Schnell" = /create/url, eine
  /// einzige KI-Anfrage auf dem Server (Issue #45).
  bool _aiForVideo(String url) =>
      looksLikeVideoUrl(url) &&
      (ref.read(settingsProvider).valueOrNull?.useImportVideoAi ?? true);

  void _onUrlChanged(String text) {
    setState(() {
      if (!_aiToggledByUser) _useAi = _aiForVideo(text);
    });
  }

  // Holt das frisch importierte Rezept (1 Request) und pflegt es über
  // upsertOne in Liste + File-Cache ein — ersetzt den früheren Voll-
  // refresh(), der nach jedem Import ALLE Rezepte neu lud.
  Future<void> _registerNewRecipe(String recipeId) async {
    try {
      final detail =
          await ref.read(apiServiceProvider).fetchRecipeDetail(recipeId);
      await ref.read(recipesProvider.notifier).upsertOne(detail);
    } catch (_) {
      // Import war erfolgreich, nur das Nachladen scheiterte — das Rezept
      // kommt spätestens mit dem nächsten Warm-Start-Reconcile in die Liste.
    }
  }

  // ── URL Import ──────────────────────────────────────────────────────────

  Future<void> _uploadFromURL() async {
    final url = _urlCtrl.text.trim();
    if (url.isEmpty || _isUploading) return;

    // URL validation — mirrors iOS guard scheme == http/https
    final uri = Uri.tryParse(url);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      _showError(AppLocalizations.of(context)!.invalidUrl);
      return;
    }

    _begin(_ImportKind.url);
    final api = ref.read(apiServiceProvider);
    final aiFailedText = AppLocalizations.of(context)!.aiImportFailed;
    try {
      final RecipeDetail detail;
      if (_useAi) {
        final slug =
            await api.importRecipeWithAi(url, onProgress: _onAiProgress);
        detail = await api.fetchRecipeDetail(slug);
      } else {
        detail = await api.importRecipeFromUrl(url);
      }
      // Nur das NEUE Rezept in Liste + File-Cache einpflegen statt per
      // Voll-refresh() alle Rezepte neu zu laden (150+ Requests pro Import).
      await ref.read(recipesProvider.notifier).upsertOne(detail);
      _showSuccess(detail.id);
    } catch (e) {
      // Übersetzte Server-Meldung („KI nicht aktiviert" …) statt der rohen
      // DioException, sofern vorhanden.
      _showError(userErrorMessage(e, _useAi ? aiFailedText : null));
    } finally {
      _end();
    }
  }

  // ── Image Import (OpenAI) ───────────────────────────────────────────────
  //
  // Kochbuchrezepte laufen oft über mehrere Seiten (Zutaten links,
  // Zubereitung rechts oder umgeblättert). Deshalb laden Kamera, Galerie und
  // PDF nicht mehr sofort hoch, sondern sammeln ihre Seiten in `_pages`.
  // Abgeschickt wird dann EINE Multipart-Anfrage mit allen Bildern
  // (`importRecipeFromImages`) — also eine einzige KI-Anfrage für das ganze
  // Rezept statt einer pro Seite. Die erste Seite wird das Hauptbild.

  /// Übernimmt die neuen Seiten, so weit das Limit reicht.
  void _addPages(List<File> files) {
    final free = _maxPages - _pages.length;
    final toAdd = files.take(free).toList();
    if (toAdd.isNotEmpty) setState(() => _pages.addAll(toAdd));
    // Nicht stillschweigend schlucken, wenn mehr ausgewählt wurde als passt.
    if (files.length > toAdd.length && mounted) {
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.maxImagesReached(_maxPages))));
    }
  }

  void _removePage(int index) {
    if (_isBusy) return;
    setState(() => _pages.removeAt(index));
  }

  void _reorderPages(int oldIndex, int newIndex) {
    if (_isBusy) return;
    // newIndex ist bei onReorderItem schon korrigiert.
    setState(() => _pages.insert(newIndex, _pages.removeAt(oldIndex)));
  }

  // Galerie und Kamera teilen sich dieselben Grenzen: 2048 px reichen, damit
  // die KI Zutatenlisten sicher liest, ohne den Upload aufzublähen.
  Future<void> _addPageFromCamera() async {
    if (!_canAddPages) return;
    final XFile? picked;
    try {
      picked = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
          maxWidth: 2048,
          maxHeight: 2048);
    } on PlatformException catch (e) {
      if (!mounted) return;
      final l = AppLocalizations.of(context)!;
      // Verweigerte Kamera bzw. Gerät ohne Kamera (z. B. Simulator) als Klartext
      // statt der rohen PlatformException im Fehlerdialog.
      _showError(e.code == 'camera_access_denied'
          ? l.cameraPermissionDenied
          : l.cameraUnavailable);
      return;
    }
    if (picked == null) return;
    _addPages([File(picked.path)]);
  }

  Future<void> _addPagesFromGallery() async {
    if (!_canAddPages) return;
    final List<XFile> picked;
    final remaining = _maxPages - _pages.length;
    try {
      picked = await ImagePicker().pickMultiImage(
          imageQuality: 80,
          maxWidth: 2048,
          maxHeight: 2048,
          // `limit` muss laut image_picker >1 sein; bei genau einem freien
          // Platz also weglassen und stattdessen in `_addPages` kappen.
          limit: remaining > 1 ? remaining : null);
    } on PlatformException catch (e) {
      if (!mounted) return;
      _showError(e.message ?? e.code);
      return;
    }
    if (picked.isEmpty) return;
    _addPages(picked.map((x) => File(x.path)).toList());
  }

  // ── PDF ─────────────────────────────────────────────────────────────────
  // Mirrors iOS: PDF → Bild. Das gerenderte Bild wandert als EINE Seite in
  // die Auswahl und kann dort mit Fotos kombiniert werden.

  Future<void> _addPageFromPdf() async {
    if (!_canAddPages) return;
    final picked = await FilePicker.pickFile(
        type: FileType.custom, allowedExtensions: ['pdf']);
    if (!mounted || picked == null) return;
    final path = picked.path;
    if (path == null) return;

    // 10 MB check — mirrors iOS maxFileSize
    final size = picked.lengthSync() ?? await picked.length() ?? 0;
    if (!mounted) return;
    if (size > _maxFileSize) {
      _showError(AppLocalizations.of(context)!.pdfTooLarge);
      return;
    }

    _begin(_ImportKind.pages, state: _UploadState.preparing);
    try {
      final imageFile = await _renderPdfToSingleImage(path);
      if (imageFile == null) {
        throw Exception('PDF could not be converted to an image');
      }
      if (mounted) _addPages([imageFile]);
    } catch (e) {
      _showError(userErrorMessage(e));
    } finally {
      _end();
    }
  }

  // ── Upload aller gesammelten Seiten ─────────────────────────────────────

  Future<void> _createRecipeFromPages() async {
    if (_pages.isEmpty || _isBusy) return;
    _begin(_ImportKind.pages);
    try {
      final recipeId = await ref
          .read(apiServiceProvider)
          .importRecipeFromImages(List<File>.of(_pages),
              onProgress: _onAiProgress);
      if (recipeId.isEmpty) throw Exception('No recipe returned');
      await _registerNewRecipe(recipeId);
      if (mounted) setState(() => _pages.clear());
      _showSuccess(recipeId);
    } catch (e) {
      // Auswahl BEWUSST stehen lassen: nach einem Fehlschlag (Timeout, fehlender
      // KI-Key, Server offline) kann direkt neu gesendet werden, ohne alle
      // Seiten noch einmal auszuwählen.
      _showError(userErrorMessage(e));
    } finally {
      _end();
    }
  }

  // Renders ALL PDF pages and stacks them vertically into one tall PNG so the
  // entire recipe is uploaded as a single image. Mirrors iOS renderPDFToImage
  // intent (whole document → image → /recipes/create/image).
  Future<File?> _renderPdfToSingleImage(String pdfPath) async {
    PdfDocument? doc;
    try {
      doc = await PdfDocument.openFile(pdfPath);
      final pageCount = doc.pagesCount;
      const targetWidth = 1000.0; // normalize every page to this width

      final images = <ui.Image>[];
      for (var i = 1; i <= pageCount; i++) {
        final page = await doc.getPage(i);
        final scale = targetWidth / page.width;
        final pageImg = await page.render(
          width: targetWidth,
          height: page.height * scale,
          format: PdfPageImageFormat.png,
          backgroundColor: '#FFFFFF',
        );
        await page.close();
        if (pageImg == null) continue;
        final decoded = await decodeImageFromList(pageImg.bytes);
        images.add(decoded);
      }
      if (images.isEmpty) return null;

      // Compose all pages stacked vertically onto one canvas.
      final totalHeight =
          images.fold<double>(0, (h, img) => h + img.height.toDouble());
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint()..color = const Color(0xFFFFFFFF);
      canvas.drawRect(Rect.fromLTWH(0, 0, targetWidth, totalHeight), paint);
      double y = 0;
      for (final img in images) {
        canvas.drawImage(img, Offset(0, y), Paint());
        y += img.height.toDouble();
      }
      final picture = recorder.endRecording();
      final composed =
          await picture.toImage(targetWidth.toInt(), totalHeight.toInt());
      final bytes = await composed.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) return null;

      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/recipe_pdf_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes.buffer.asUint8List());
      return file;
    } catch (_) {
      return null;
    } finally {
      await doc?.close();
    }
  }

  // ── ZIP-Import (Desktop, Mealie „Import from Zip") ─────────────────────

  // ── Einfügen: Mealie-Export (JSON), schema.org-JSON oder HTML ────────────
  //
  // Mealie ≥ 3.30 erkennt ein eingefügtes Rezept aus einem Mealie-Export und
  // übernimmt es mit voller Struktur (Lebensmittel, Einheiten, Schritt-
  // Verknüpfungen); ältere Server lesen schema.org-Rezepte bzw. HTML.
  Future<void> _importPasted() async {
    final l = AppLocalizations.of(context)!;
    final clip = (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';
    final looksLikeRecipe =
        clip.trimLeft().startsWith('{') || clip.contains('<');
    if (!mounted) return;
    final ctrl = TextEditingController(text: looksLikeRecipe ? clip : '');
    final data = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        backgroundColor: ctx.appCard,
        title: Text(l.pasteRecipeTitle),
        content: TextField(
          controller: ctrl,
          autofocus: ctrl.text.isEmpty,
          minLines: 6,
          maxLines: 12,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          decoration: InputDecoration(
            hintText: l.pasteRecipeHint,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: Text(l.pasteRecipeImport)),
        ],
      ),
    );
    ctrl.dispose();
    if (data == null || data.trim().isEmpty || !mounted) return;
    _begin(_ImportKind.paste);
    try {
      final api = ref.read(apiServiceProvider);
      final slug = await api.importRecipeFromHtmlOrJson(data.trim());
      final detail = await api.fetchRecipeDetail(slug);
      await ref.read(recipesProvider.notifier).upsertOne(detail);
      _showSuccess(detail.id);
    } catch (e) {
      _showError(userErrorMessage(e));
    } finally {
      _end();
    }
  }

  Future<void> _importZip() async {
    final l = AppLocalizations.of(context)!;
    final f = await pickToolFile(const ['zip']);
    if (f == null || !mounted) return;
    _begin(_ImportKind.zip);
    try {
      final slug =
          await ref.read(apiServiceProvider).importRecipeZip(f.bytes, f.name);
      if (slug.isEmpty) throw Exception(l.zipImportFailed);
      final detail = await ref.read(apiServiceProvider).fetchRecipeDetail(slug);
      await ref.read(recipesProvider.notifier).upsertOne(detail);
      _showSuccess(detail.id);
    } catch (e) {
      _showError(userErrorMessage(e));
    } finally {
      _end();
    }
  }

  // ── Result alerts — mirror iOS showResult(success:errorMessage:) ──────────

  // Erfolgsdialog. Liegt die id des neu erstellten Rezepts vor, wird zusätzlich
  // angeboten, direkt in die Bearbeiten-Ansicht des neuen Rezepts zu wechseln.
  void _showSuccess([String? recipeId]) {
    if (!mounted) return;
    final l = AppLocalizations.of(context)!;
    final hasRecipe = recipeId != null && recipeId.isNotEmpty;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        // Querformat/Tastatur: Inhalt scrollt, Knöpfe bleiben sichtbar.
        scrollable: true,
        backgroundColor: dialogContext.appCard,
        title: Text(l.uploadSuccessTitle,
            style: TextStyle(color: dialogContext.appFg)),
        content: hasRecipe
            ? Text(l.editImportedRecipeQuestion,
                style: TextStyle(color: dialogContext.appFgSub))
            : null,
        actions: hasRecipe
            ? [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _resetForm();
                  },
                  child: Text(l.notNow),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _resetForm();
                    context.push('/recipes/$recipeId/edit');
                  },
                  child: Text(l.editRecipe),
                ),
              ]
            : [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _resetForm();
                  },
                  child: Text(l.ok),
                ),
              ],
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        backgroundColor: dctx.appCard,
        title: Text(l.uploadErrorTitle, style: TextStyle(color: dctx.appFg)),
        content: Text(message, style: TextStyle(color: dctx.appFgSub)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dctx),
            child: Text(l.ok),
          ),
        ],
      ),
    );
  }

  // ── Gesammelte Seiten: Vorschau, Sortierung, Absenden ───────────────────

  Widget _buildPages(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: Text(l.imagePagesSelected(_pages.length),
                  style: TextStyle(
                      color: context.appFg,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
            ),
            Text('${_pages.length}/$_maxPages',
                style: TextStyle(color: context.appFgTertiary, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(l.imagePagesHint,
            style:
                TextStyle(color: context.appFgSub, fontSize: 12, height: 1.35)),
        const SizedBox(height: 12),
        SizedBox(
          height: 118,
          child: ReorderableListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: _pages.length,
            onReorderItem: _reorderPages,
            proxyDecorator: (child, _, __) => Material(
              color: Colors.transparent,
              child: child,
            ),
            itemBuilder: (_, i) => _pageTile(l, i),
          ),
        ),
        const SizedBox(height: 14),
        AsyncActionButton(
          expand: true,
          icon: Icons.auto_awesome_rounded,
          label: l.createRecipeFromImages,
          showBusySpinner: false,
          onPressed: _isBusy ? null : _createRecipeFromPages,
        ),
      ],
    );
  }

  Widget _pageTile(AppLocalizations l, int index) {
    final isMain = index == 0;
    return Padding(
      // ObjectKey statt ValueKey(path): wird dasselbe Foto zweimal gewählt,
      // liefert der Picker denselben Pfad — zwei gleiche Keys lassen die
      // ReorderableListView werfen. Die File-Instanzen sind trotzdem eigene
      // Objekte.
      key: ObjectKey(_pages[index]),
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: 88,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTokens.rSm),
              child: Image.file(
                _pages[index],
                width: 88,
                height: 118,
                fit: BoxFit.cover,
                // Vorschaugröße dekodieren statt des vollen 2048-px-Fotos —
                // sonst liegen bei 10 Seiten dutzende MB Bitmap im RAM.
                cacheWidth: 264,
              ),
            ),
            // Erste Seite klar als Hauptbild markieren, der Rest nummeriert.
            Positioned(
              left: 4,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: isMain ? null : Colors.black.withValues(alpha: 0.6),
                  gradient: isMain ? AppTokens.accentGradient : null,
                  borderRadius: BorderRadius.circular(AppTokens.rXs),
                ),
                child: Text(
                  isMain ? l.mainImageBadge : '${index + 1}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            // Einzelne Seite entfernen.
            Positioned(
              right: 2,
              top: 2,
              child: Semantics(
                button: true,
                label: l.removePage,
                child: TapArea(
                  semanticLabel: AppLocalizations.of(context)!.removePage,
                  onTap: () => _removePage(index),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded,
                        color: Colors.white, size: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final streamPhotos =
        ref.watch(settingsProvider).valueOrNull?.useImportStreamPhotos ?? true;
    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        backgroundColor: context.appBg,
        elevation: 0,
        actions: [
          // Optionen des KI-Imports (Übersetzen, Kategorien & Tags) — #45.
          IconButton(
            tooltip: l.importOptionsTitle,
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => showImportOptionsSheet(context),
          ),
        ],
      ),
      body: WithCookingModeFAB(
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Large title — mirrors iOS .largeTitle .bold
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 24),
                  child: Text(
                    l.importRecipeTitle,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: context.appFg,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      height: 1.15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // ── URL Import GroupBox ───────────────────────────────
                _GroupBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.uploadRecipeUrl,
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: context.appFg,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3)),
                      const SizedBox(height: 8),
                      Text(l.uploadRecipeUrlHint,
                          style:
                              TextStyle(color: context.appFgSub, fontSize: 14)),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _urlCtrl,
                        style: TextStyle(color: context.appFg),
                        keyboardType: TextInputType.url,
                        autocorrect: false,
                        enabled: !_isUploading,
                        onChanged: _onUrlChanged,
                        onSubmitted: (_) => _uploadFromURL(),
                        decoration: InputDecoration(
                          hintText: 'https://example.com/recipe',
                          hintStyle: TextStyle(color: context.appFgTertiary),
                          filled: true,
                          fillColor: context.appSurface2,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 13),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTokens.rSm),
                            borderSide: BorderSide(
                                color: context.appSeparator, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTokens.rSm),
                            borderSide: const BorderSide(
                                color: AppTokens.accent, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // KI-Analyse (Mealie „Import with AI"): auch Rezeptvideos.
                      _AiToggle(
                        value: _useAi,
                        enabled: !_isUploading,
                        title: l.aiImportToggle,
                        subtitle: l.aiImportToggleHint,
                        onChanged: (v) => setState(() {
                          _useAi = v;
                          _aiToggledByUser = true;
                        }),
                      ),
                      const SizedBox(height: 12),
                      AsyncActionButton(
                        expand: true,
                        showBusySpinner: false,
                        icon: _useAi ? Icons.auto_awesome_rounded : Icons.link,
                        label:
                            _useAi ? l.aiImportButton : l.uploadFromUrlButton,
                        onPressed:
                            (_isUploading || _urlCtrl.text.trim().isEmpty)
                                ? null
                                : _uploadFromURL,
                      ),
                      if (_active == _ImportKind.url)
                        ImportProgressPanel(
                          key: _progressKey,
                          steps: _useAi ? _aiSteps : const [],
                          label: _useAi ? l.importStarting : l.importRunning,
                          hint: _useAi ? l.aiImportRunning : null,
                        ),
                    ],
                  ),
                ),

                // Divider between sections — mirrors iOS Divider()
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1),
                ),

                // ── OpenAI Image/PDF GroupBox ─────────────────────────
                _GroupBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.uploadOpenAI,
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: context.appFg,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3)),
                      const SizedBox(height: 8),
                      Text(l.uploadOpenAIHint,
                          style:
                              TextStyle(color: context.appFgSub, fontSize: 14)),
                      const SizedBox(height: 16),

                      // Alle drei Quellen gleichwertig nebeneinander. Sie laden
                      // nicht mehr direkt hoch, sondern legen eine Seite ab.
                      Row(
                        children: [
                          // Kamera nur auf Handy/Tablet (Windows: keine).
                          if (PlatformFeatures.camera) ...[
                            Expanded(
                              child: _UploadButton(
                                icon: Icons.photo_camera_rounded,
                                label: l.takePhoto,
                                onTap: _canAddPages ? _addPageFromCamera : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                          Expanded(
                            child: _UploadButton(
                              icon: Icons.photo_library_rounded,
                              label: l.selectPhoto,
                              onTap: _canAddPages ? _addPagesFromGallery : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _UploadButton(
                              icon: Icons.picture_as_pdf_rounded,
                              label: l.selectPdf,
                              onTap: _canAddPages ? _addPageFromPdf : null,
                            ),
                          ),
                        ],
                      ),

                      // Gesammelte Seiten + Absenden.
                      if (_pages.isNotEmpty) _buildPages(l),

                      // Spinner — mirrors iOS ProgressView("uploading_image"),
                      // beim PDF-Rendern mit eigenem Text (da wird noch nichts
                      // hochgeladen).
                      if (_active == _ImportKind.pages)
                        ImportProgressPanel(
                          key: _progressKey,
                          // Stream: Mealies Schritte live; bis zur ersten
                          // Meldung läuft noch der Upload der Fotos.
                          steps: _aiSteps,
                          label: !_isUploading
                              ? l.preparingPdf
                              : (streamPhotos
                                  ? l.importStarting
                                  : l.aiImagesRunning),
                        ),

                      const SizedBox(height: 16),

                      // Info box — mirrors iOS info.circle hint
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              color: AppTokens.accentDeep, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l.openAIHintTitle,
                                    style: TextStyle(
                                        color: context.appFg,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Text(l.openAIHintBody,
                                    style: TextStyle(
                                        color: context.appFgSub,
                                        fontSize: 12,
                                        height: 1.4)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1),
                ),

                // ── Rezept einfügen (Mealie-Export, JSON, HTML) ───────────
                _GroupBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.pasteRecipeTitle,
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: context.appFg,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3)),
                      const SizedBox(height: 8),
                      Text(
                          ref.watch(mealie330Provider)
                              ? l.pasteRecipeDescription330
                              : l.pasteRecipeDescription,
                          style:
                              TextStyle(color: context.appFgSub, fontSize: 14)),
                      const SizedBox(height: 12),
                      AsyncActionButton(
                        expand: true,
                        icon: Icons.content_paste_rounded,
                        label: l.pasteRecipeButton,
                        showBusySpinner: false,
                        onPressed: _isBusy ? null : _importPasted,
                      ),
                      if (_active == _ImportKind.paste)
                        ImportProgressPanel(
                            key: _progressKey, label: l.importRunning),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1),
                ),

                // ── Manuell anlegen ───────────────────────────────────
                _GroupBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.createManualTitle,
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: context.appFg,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3)),
                      const SizedBox(height: 8),
                      Text(l.createManualHint,
                          style:
                              TextStyle(color: context.appFgSub, fontSize: 14)),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _manualNameCtrl,
                        style: TextStyle(color: context.appFg),
                        textCapitalization: TextCapitalization.sentences,
                        enabled: !_creatingManual,
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => _createManual(),
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          hintText: l.recipeName,
                          hintStyle: TextStyle(color: context.appFgTertiary),
                          filled: true,
                          fillColor: context.appSurface2,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 13),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTokens.rSm),
                            borderSide: BorderSide(
                                color: context.appSeparator, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTokens.rSm),
                            borderSide: const BorderSide(
                                color: AppTokens.accent, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AsyncActionButton(
                        expand: true,
                        icon: Icons.edit_note_rounded,
                        label: l.createManualButton,
                        onPressed: (_creatingManual ||
                                _manualNameCtrl.text.trim().isEmpty)
                            ? null
                            : _createManual,
                      ),
                    ],
                  ),
                ),

                // ── Weitere Importwege (Desktop: Webapp-Werkzeuge) ────────
                if (PlatformFeatures.webAppTools) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  _GroupBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.moreImportOptions,
                            style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                color: context.appFg,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3)),
                        const SizedBox(height: 8),
                        Text(l.zipImportDescription,
                            style: TextStyle(
                                color: context.appFgSub, fontSize: 14)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            // Gleiche Optik wie die beiden anderen Wege;
                            // während des ZIP-Imports ein kleiner Ladekreis.
                            OutlinedButton.icon(
                              onPressed: _isBusy ? null : _importZip,
                              icon: _active == _ImportKind.zip
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2))
                                  : const Icon(Icons.folder_zip_rounded),
                              label: Text(l.zipImportButton),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => context.push('/bulk-import'),
                              icon: const Icon(Icons.playlist_add_rounded),
                              label: Text(l.bulkImportTitle),
                            ),
                            // Wie die Webapp (create.vue) nur mit
                            // „Erweiterte Funktionen“ — wie die Kachel.
                            if (!ref.watch(userPermissionsProvider).known ||
                                ref.watch(userPermissionsProvider).advanced)
                              OutlinedButton.icon(
                                onPressed: () => context.push('/migrations'),
                                icon: const Icon(Icons.move_down_rounded),
                                label: Text(l.migrationsTitle),
                              ),
                          ],
                        ),
                        if (_active == _ImportKind.zip)
                          ImportProgressPanel(
                              key: _progressKey, label: l.importRunning),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// GroupBox — mirrors iOS GroupBox
// ---------------------------------------------------------------------------

class _GroupBox extends StatelessWidget {
  final Widget child;
  const _GroupBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(AppTokens.rLg),
        border: Border.all(color: context.appSeparator, width: 1),
        boxShadow: context.appShadowSm,
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// KI-Schalter im URL-Import
// ---------------------------------------------------------------------------

class _AiToggle extends StatelessWidget {
  final bool value;
  final bool enabled;
  final String title;
  final String subtitle;
  final ValueChanged<bool> onChanged;

  const _AiToggle({
    required this.value,
    required this.enabled,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppTokens.rSm),
      onTap: enabled ? () => onChanged(!value) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.auto_awesome_rounded,
                  color: AppTokens.accentDeep, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: context.appFg,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          color: context.appFgSub, fontSize: 12, height: 1.35)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Switch.adaptive(
              value: value,
              activeTrackColor: AppTokens.accent,
              onChanged: enabled ? onChanged : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Upload button — mirrors iOS borderedProminent Label button
// ---------------------------------------------------------------------------

class _UploadButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _UploadButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return TapArea(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          gradient: enabled ? AppTokens.accentGradient : null,
          color: enabled ? null : context.appSurface2,
          borderRadius: BorderRadius.circular(AppTokens.rMd),
          boxShadow: enabled ? context.appAccentGlow : null,
        ),
        // Symbol über dem Text: zu dritt nebeneinander bleibt so auch auf
        // schmalen Geräten Platz für längere Labels („Appareil photo"),
        // die nebeneinander abgeschnitten würden.
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: enabled ? Colors.white : context.appFgTertiary,
                size: 22),
            const SizedBox(height: 6),
            // scaleDown: lange Einzelwörter („Fotografije") können nicht
            // umbrechen und würden auf schmalen Geräten abgeschnitten —
            // lieber minimal kleiner als „Fotograf…".
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: enabled ? Colors.white : context.appFgTertiary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      height: 1.2)),
            ),
          ],
        ),
      ),
    );
  }
}
