import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/log_manager.dart';
import '../../../core/utils/media_urls.dart';
import '../../../core/utils/safe_path.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/recipe_image_viewer.dart';

// ---------------------------------------------------------------------------
// Anhang öffnen: Bilder im Vollbild-Viewer, PDFs und Textdateien direkt in
// der App, alles andere über das Teilen-Menü. Nicht-Bilder werden über
// ApiService (Auth- und Zusatz-Header) in einen App-Cache-Ordner geladen und
// dort wiederverwendet — ein zweites Öffnen geht auch offline.
// ---------------------------------------------------------------------------

Future<File> _localAssetFile(RecipeDetail recipe, RecipeAsset asset) async {
  final dir = await getApplicationCacheDirectory();
  return File('${dir.path}/recipe_assets/${safePathSegment(recipe.id)}/'
      '${safePathSegment(asset.fileName)}');
}

Future<void> openRecipeAsset(BuildContext context, WidgetRef ref,
    RecipeDetail recipe, RecipeAsset asset) async {
  final l = AppLocalizations.of(context)!;
  final settings = ref.read(settingsProvider).valueOrNull;
  final server = settings?.serverUrl ?? '';

  if (asset.isImage && server.isNotEmpty) {
    await showRecipeImageViewer(
      context,
      recipeId: recipe.id,
      imageUrl: recipeAssetUrl(server, recipe.id, asset.fileName),
      httpHeaders: mediaHeaders(settings),
      useOfflineCopy: false,
    );
    return;
  }

  final messenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context, rootNavigator: true);
  File file;
  try {
    file = await _localAssetFile(recipe, asset);
    if (!await file.exists() || await file.length() == 0) {
      await file.parent.create(recursive: true);
      await ref.read(apiServiceProvider).downloadToFile(
          recipeAssetPath(recipe.id, asset.fileName), file.path);
    }
  } catch (e) {
    LogManager.shared.log('❌ Anhang laden fehlgeschlagen: $e');
    messenger.showSnackBar(SnackBar(content: Text(l.assetsOpenFailed)));
    return;
  }

  if (asset.isPdf || asset.isText) {
    await navigator.push(MaterialPageRoute(
      builder: (_) => _AssetFileScreen(asset: asset, file: file),
    ));
  } else {
    await Share.shareXFiles([XFile(file.path)]);
  }
}

class _AssetFileScreen extends StatefulWidget {
  final RecipeAsset asset;
  final File file;
  const _AssetFileScreen({required this.asset, required this.file});

  @override
  State<_AssetFileScreen> createState() => _AssetFileScreenState();
}

class _AssetFileScreenState extends State<_AssetFileScreen> {
  PdfControllerPinch? _pdf;
  String? _text;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    if (widget.asset.isPdf) {
      _pdf =
          PdfControllerPinch(document: PdfDocument.openFile(widget.file.path));
    } else {
      _loadText();
    }
  }

  Future<void> _loadText() async {
    try {
      var text = await widget.file.readAsString();
      if (widget.asset.extension == 'json') {
        try {
          text = const JsonEncoder.withIndent('  ').convert(jsonDecode(text));
        } catch (_) {/* kein gültiges JSON → roh zeigen */}
      }
      if (mounted) setState(() => _text = text);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _pdf?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    Widget body;
    if (_pdf != null) {
      body = PdfViewPinch(controller: _pdf!);
    } else if (_failed) {
      body = Center(
          child: Text(l.assetsOpenFailed,
              style: TextStyle(color: context.appFgSub)));
    } else if (_text == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          _text!,
          style: TextStyle(
            color: context.appFg,
            fontSize: 14,
            height: 1.45,
            fontFamily: widget.asset.extension == 'json' ||
                    widget.asset.extension == 'csv'
                ? 'monospace'
                : null,
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Text(widget.asset.name,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: l.assetsShare,
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () => Share.shareXFiles([XFile(widget.file.path)]),
          ),
        ],
      ),
      body: SafeArea(top: false, child: body),
    );
  }
}
