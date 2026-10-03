import '../../core/utils/platform_features.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:image_picker/image_picker.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../theme/app_colors.dart';

/// Fragt „Kamera oder Fotos?" und liefert das gewählte Bild (verkleinert auf
/// max. 2048 px) oder `null`. Verweigerte/fehlende Kamera → Snackbar.
Future<File?> pickPhotoWithSource(BuildContext context) async {
  // Ohne Kamera (Windows/Desktop): gleich die Dateiauswahl, keine Frage.
  if (!PlatformFeatures.camera) {
    return pickPhotoFromSource(context, ImageSource.gallery);
  }
  final l = AppLocalizations.of(context)!;
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    useRootNavigator: true,
    backgroundColor: context.appCard,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.photo_camera_rounded, color: ctx.appFg),
            title: Text(l.takePhoto, style: TextStyle(color: ctx.appFg)),
            onTap: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          ListTile(
            leading: Icon(Icons.photo_library_rounded, color: ctx.appFg),
            title: Text(l.selectPhoto, style: TextStyle(color: ctx.appFg)),
            onTap: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
  if (source == null || !context.mounted) return null;
  return pickPhotoFromSource(context, source);
}

/// Foto direkt aus [source] (Kamera/Fotos), verkleinert auf max. 2048 px.
Future<File?> pickPhotoFromSource(
    BuildContext context, ImageSource source) async {
  final l = AppLocalizations.of(context)!;
  try {
    final picked = await ImagePicker().pickImage(
        source: source, imageQuality: 85, maxWidth: 2048, maxHeight: 2048);
    return picked == null ? null : File(picked.path);
  } on PlatformException catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.code == 'camera_access_denied'
              ? l.cameraPermissionDenied
              : l.cameraUnavailable)));
    }
    return null;
  }
}
