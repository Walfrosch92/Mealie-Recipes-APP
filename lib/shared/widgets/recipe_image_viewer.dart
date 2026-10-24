import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/services/recipe_image_store.dart';

// ---------------------------------------------------------------------------
// Vollbild-Ansicht des Rezeptbilds (Tippen auf das Bild in der Detailansicht).
//
// Nimmt die Offline-Kopie, falls vorhanden, sonst das Originalbild vom Server.
// Sobald die echten Bildmaße bekannt sind, wird entschieden:
//   - Passt das Bild in voller Breite auf den Bildschirm → zentriert, mit
//     Pinch-Zoom (InteractiveViewer).
//   - Ist es höher als der Bildschirm (z. B. abfotografierte Rezeptseite) →
//     volle Breite, vertikal scrollbar mit Scrollbalken. Zoom UND Scrollen in
//     einer Geste kollidieren, deshalb hier bewusst nur Scrollen.
// ---------------------------------------------------------------------------

Future<void> showRecipeImageViewer(
  BuildContext context, {
  required String recipeId,
  required String imageUrl,
  Map<String, String>? httpHeaders,
  bool useOfflineCopy = true,
}) {
  return Navigator.of(context, rootNavigator: true).push(PageRouteBuilder(
    opaque: true,
    barrierColor: Colors.black,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, __, ___) => _RecipeImageViewer(
      recipeId: recipeId,
      imageUrl: imageUrl,
      httpHeaders: httpHeaders,
      useOfflineCopy: useOfflineCopy,
    ),
    transitionsBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
  ));
}

/// Mehrere Bilder (z. B. alle Bilder eines Schritts) im Vollbild, seitlich
/// wischbar — jedes Bild mit Zoom/Scrollen wie [showRecipeImageViewer].
/// [headersFor] liefert pro URL die Anmeldung (nur eigener Server).
Future<void> showImageGalleryViewer(
  BuildContext context, {
  required List<String> urls,
  int initialIndex = 0,
  Map<String, String>? Function(String url)? headersFor,
}) {
  if (urls.isEmpty) return Future.value();
  return Navigator.of(context, rootNavigator: true).push(PageRouteBuilder(
    opaque: true,
    barrierColor: Colors.black,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, __, ___) => _ImageGallery(
      urls: urls,
      initialIndex: initialIndex.clamp(0, urls.length - 1),
      headersFor: headersFor,
    ),
    transitionsBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
  ));
}

class _ImageGallery extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;
  final Map<String, String>? Function(String url)? headersFor;
  const _ImageGallery(
      {required this.urls, required this.initialIndex, this.headersFor});

  @override
  State<_ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<_ImageGallery> {
  late final _controller = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.urls.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (_, i) => _RecipeImageViewer(
            recipeId: '',
            imageUrl: widget.urls[i],
            httpHeaders: widget.headersFor?.call(widget.urls[i]),
            useOfflineCopy: false,
          ),
        ),
        if (widget.urls.length > 1)
          Positioned(
            top: topPad + 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('${_index + 1} / ${widget.urls.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none)),
            ),
          ),
      ],
    );
  }
}

class _RecipeImageViewer extends StatefulWidget {
  final String recipeId;
  final String imageUrl;
  final Map<String, String>? httpHeaders;

  /// false = immer die [imageUrl] laden (Zeitleisten-Fotos, Anhänge) statt
  /// der Offline-Kopie des Rezept-Hauptbilds.
  final bool useOfflineCopy;

  const _RecipeImageViewer({
    required this.recipeId,
    required this.imageUrl,
    this.httpHeaders,
    this.useOfflineCopy = true,
  });

  @override
  State<_RecipeImageViewer> createState() => _RecipeImageViewerState();
}

class _RecipeImageViewerState extends State<_RecipeImageViewer> {
  late final ImageProvider _provider;
  ImageStream? _stream;
  ImageStreamListener? _listener;
  Size? _size;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    // Hauptbild über die Rezept-ID, Schritt-/Notizbilder über ihre URL.
    final file = widget.useOfflineCopy
        ? RecipeImageStore.shared.fileFor(widget.recipeId)
        : RecipeImageStore.shared.fileForUrl(widget.imageUrl);
    _provider = file != null
        ? FileImage(file)
        : CachedNetworkImageProvider(widget.imageUrl,
            headers: widget.httpHeaders) as ImageProvider;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_stream != null) return;
    // Echte Bildmaße ermitteln (für „passt" vs. „scrollen").
    _stream = _provider.resolve(createLocalImageConfiguration(context));
    _listener = ImageStreamListener(
      (info, _) {
        if (!mounted) return;
        setState(() => _size =
            Size(info.image.width.toDouble(), info.image.height.toDouble()));
      },
      onError: (_, __) {
        if (mounted) setState(() => _failed = true);
      },
    );
    _stream!.addListener(_listener!);
  }

  @override
  void dispose() {
    if (_listener != null) _stream?.removeListener(_listener!);
    super.dispose();
  }

  Widget _content(BoxConstraints box) {
    if (_failed) {
      return const Center(
          child: Icon(Icons.broken_image_outlined,
              color: Colors.white54, size: 48));
    }
    final size = _size;
    if (size == null || size.width == 0) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
    }
    final displayHeight = box.maxWidth * size.height / size.width;

    if (displayHeight > box.maxHeight) {
      // Sehr langes Bild: volle Breite, scrollen.
      return Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 56,
              bottom: MediaQuery.paddingOf(context).bottom + 16),
          child: Image(
            image: _provider,
            width: box.maxWidth,
            fit: BoxFit.fitWidth,
            gaplessPlayback: true,
          ),
        ),
      );
    }

    // Passt auf den Bildschirm: zentriert, mit Pinch-Zoom.
    return InteractiveViewer(
      minScale: 1,
      maxScale: 5,
      child: Center(
        child: Image(
          image: _provider,
          fit: BoxFit.contain,
          gaplessPlayback: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(builder: (_, box) => _content(box)),
          ),
          // Schließen
          Positioned(
            top: topPad + 8,
            left: 12,
            child: Material(
              color: Colors.black.withValues(alpha: 0.45),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
