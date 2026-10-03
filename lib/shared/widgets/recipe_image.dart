import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/services/recipe_image_store.dart';

/// Rezept-Hauptbild: nimmt die dauerhafte Offline-Kopie aus dem
/// [RecipeImageStore], wenn es eine gibt (Einstellung „Rezeptbilder offline
/// speichern"), sonst wie bisher `CachedNetworkImage`. Ist die lokale Datei
/// unlesbar, fällt es ebenfalls auf das Netzwerk zurück.
///
/// Hört auf Änderungen im Speicher: wird das Bild ersetzt (neues Foto) oder
/// entfernt, baut NUR ein Widget neu, dessen eigene Datei sich geändert hat.
class RecipeImage extends StatefulWidget {
  const RecipeImage({
    super.key,
    required this.recipeId,
    required this.imageUrl,
    required this.placeholder,
    this.httpHeaders,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String recipeId;
  final String imageUrl;
  final Map<String, String>? httpHeaders;
  final BoxFit fit;
  final double? width;
  final double? height;

  /// Für Laden UND Fehler, wie an allen bisherigen Aufrufstellen.
  final WidgetBuilder placeholder;

  @override
  State<RecipeImage> createState() => _RecipeImageState();
}

class _RecipeImageState extends State<RecipeImage> {
  String? _path;

  @override
  void initState() {
    super.initState();
    _path = RecipeImageStore.shared.fileFor(widget.recipeId)?.path;
    RecipeImageStore.shared.stats.addListener(_onStoreChanged);
  }

  @override
  void didUpdateWidget(RecipeImage old) {
    super.didUpdateWidget(old);
    if (old.recipeId != widget.recipeId) {
      _path = RecipeImageStore.shared.fileFor(widget.recipeId)?.path;
    }
  }

  @override
  void dispose() {
    RecipeImageStore.shared.stats.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    final path = RecipeImageStore.shared.fileFor(widget.recipeId)?.path;
    if (path != _path && mounted) setState(() => _path = path);
  }

  @override
  Widget build(BuildContext context) {
    final network = CachedNetworkImage(
      imageUrl: widget.imageUrl,
      httpHeaders: widget.httpHeaders,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      placeholder: (c, _) => widget.placeholder(c),
      errorWidget: (c, _, __) => widget.placeholder(c),
    );
    final path = _path;
    if (path == null) return network;
    return Image.file(
      File(path),
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) => network,
    );
  }
}
