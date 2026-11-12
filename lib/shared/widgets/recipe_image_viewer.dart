import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart' show VelocityTracker;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/settings_provider.dart';
import '../../core/services/recipe_image_store.dart';
import '../../core/utils/media_urls.dart';

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
//
// Schließen: ✕ oben links ODER nach unten wischen (das Bild folgt dem Finger,
// der Hintergrund blendet aus; ab ~120 px bzw. schnellem Wisch geht es zu).
// Gezoomte Bilder wischen nicht weg, lange Bilder nur am oberen Rand.
// ---------------------------------------------------------------------------

/// Weg, ab dem das Loslassen schließt.
const _kDismissDistance = 120.0;

Future<void> showRecipeImageViewer(
  BuildContext context, {
  required String recipeId,
  required String imageUrl,
  Map<String, String>? httpHeaders,
  bool useOfflineCopy = true,
}) {
  return Navigator.of(context, rootNavigator: true).push(PageRouteBuilder(
    // Durchsichtig, damit beim Wegwischen das Rezept dahinter auftaucht —
    // den schwarzen Hintergrund malt die Ansicht selbst.
    opaque: false,
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
    // Durchsichtig, damit beim Wegwischen das Rezept dahinter auftaucht —
    // den schwarzen Hintergrund malt die Ansicht selbst.
    opaque: false,
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

class _RecipeImageViewer extends ConsumerStatefulWidget {
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
  ConsumerState<_RecipeImageViewer> createState() => _RecipeImageViewerState();
}

class _RecipeImageViewerState extends ConsumerState<_RecipeImageViewer> {
  late final ImageProvider _provider;
  ImageStream? _stream;
  ImageStreamListener? _listener;
  Size? _size;
  bool _failed = false;

  // Nach-unten-Wischen zum Schließen — über rohe Zeigerereignisse
  // (Listener) statt eines Gesten-Erkenners: der stand im Gesten-Wettbewerb
  // mit Zoom (InteractiveViewer) bzw. Scrollen und verlor auf dem Gerät.
  final _zoom = TransformationController();
  final _scroll = ScrollController();
  double _dragDy = 0;
  bool _dragging = false;
  int _pointers = 0;
  Offset? _start;
  bool _mayDismiss = false;
  VelocityTracker? _velocity;

  bool get _zoomed => _zoom.value.getMaxScaleOnAxis() > 1.01;

  void _close() => Navigator.of(context).maybePop();

  void _pointerDown(PointerDownEvent e) {
    _pointers++;
    if (_pointers > 1) {
      // Zweiter Finger = Zoom → kein Wegwischen.
      _resetDrag();
      return;
    }
    _start = e.position;
    // Nur ungezoomt und — bei langen Bildern — ganz oben.
    _mayDismiss = !_zoomed && (!_scroll.hasClients || _scroll.offset <= 0);
    _velocity = VelocityTracker.withKind(e.kind)
      ..addPosition(e.timeStamp, e.position);
  }

  void _pointerMove(PointerMoveEvent e) {
    final start = _start;
    if (_pointers != 1 || !_mayDismiss || start == null) return;
    _velocity?.addPosition(e.timeStamp, e.position);
    final d = e.position - start;
    if (!_dragging) {
      // Erst ab einem deutlichen, überwiegend senkrechten Zug nach unten
      // (seitlich = Bildergalerie blättern, nach oben = scrollen).
      if (d.dy < 16 || d.dy.abs() < d.dx.abs() * 1.5) {
        if (d.dy < -16 || d.dx.abs() > 24) _mayDismiss = false;
        return;
      }
    }
    setState(() {
      _dragging = true;
      _dragDy = (d.dy - 16).clamp(0.0, double.infinity);
    });
  }

  void _pointerUp(PointerEvent e) {
    _pointers = (_pointers - 1).clamp(0, 10);
    if (!_dragging) {
      if (_pointers == 0) _start = null;
      return;
    }
    final v = _velocity?.getVelocity().pixelsPerSecond.dy ?? 0;
    if (_dragDy > _kDismissDistance || v > 900) {
      _close();
      return;
    }
    _resetDrag();
  }

  void _resetDrag() {
    _start = null;
    _mayDismiss = false;
    if (_dragging || _dragDy != 0) {
      setState(() {
        _dragging = false;
        _dragDy = 0;
      });
    }
  }

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
            // Token + optionale Zusatz-Header für den eigenen Server (#38).
            headers: mergeMediaHeaders(widget.httpHeaders, widget.imageUrl,
                ref.read(settingsProvider).valueOrNull)) as ImageProvider;
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
    _zoom.dispose();
    _scroll.dispose();
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
      // Sehr langes Bild: volle Breite, scrollen. Ganz oben nach unten
      // ziehen schließt (ohne Federeffekt, sonst bremst er den Wisch aus).
      return Scrollbar(
        controller: _scroll,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scroll,
          physics: const ClampingScrollPhysics(),
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
      transformationController: _zoom,
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
    // Beim Wegwischen blendet der schwarze Hintergrund aus.
    final fade = (1 - _dragDy / 400).clamp(0.3, 1.0);
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: fade),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              duration:
                  _dragging ? Duration.zero : const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(0, _dragDy, 0),
              child: Listener(
                // Ganze Fläche — auch der schwarze Rand neben dem Bild, die
                // Ladeanzeige und das Fehlerbild (vorher nur das Bild selbst).
                behavior: HitTestBehavior.opaque,
                onPointerDown: _pointerDown,
                onPointerMove: _pointerMove,
                onPointerUp: _pointerUp,
                onPointerCancel: _pointerUp,
                child: LayoutBuilder(builder: (_, box) => _content(box)),
              ),
            ),
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
