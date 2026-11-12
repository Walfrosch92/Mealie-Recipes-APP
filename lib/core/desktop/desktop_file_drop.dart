import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../features/recipes/services/recipe_assets_sync.dart';
import '../../shared/theme/app_colors.dart';
import '../api/api_service.dart' show mealieErrorMessage;
import '../models/recipe_detail.dart';
import '../utils/mealie_version.dart';
import '../utils/platform_features.dart';

// ---------------------------------------------------------------------------
// Dateien ins Fenster ziehen (nur Windows/macOS, Paket desktop_drop 0.8 —
// liefert dort nur Dateien, keine Browser-Links):
//   • Link-Datei (.webloc vom Mac, .url von Windows, Textdatei mit Adresse)
//     irgendwo ablegen → Rezept-Import mit der Adresse.
//   • Bilder/PDFs/… auf ein geöffnetes Rezept → als Anhänge hochladen.
// Webadressen ohne Datei: kopieren, Strg/⌘ + K, einfügen → „Rezept von
// dieser Adresse importieren".
// ---------------------------------------------------------------------------

/// Webadresse aus einer Link-Datei lesen (null = keine Link-Datei).
Future<String?> _urlFromLinkFile(File file) async {
  final name = file.path.toLowerCase();
  if (!(name.endsWith('.webloc') ||
      name.endsWith('.url') ||
      name.endsWith('.txt'))) {
    return null;
  }
  try {
    final text = await file.readAsString();
    final match = RegExp(r'https?://[^\s<>"]+').firstMatch(text);
    return match?.group(0);
  } catch (_) {
    return null;
  }
}

/// Globales Ablageziel: Link-Dateien → Import.
class DesktopLinkDrop extends StatelessWidget {
  final GoRouter router;
  final Widget child;
  const DesktopLinkDrop({super.key, required this.router, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!PlatformFeatures.webAppTools) return child;
    return DropTarget(
      onDragDone: (details) async {
        for (final f in details.files) {
          final url = await _urlFromLinkFile(File(f.path));
          if (url != null) {
            router.push('/import?url=${Uri.encodeQueryComponent(url)}');
            return;
          }
        }
      },
      child: child,
    );
  }
}

/// Ablageziel auf einem geöffneten Rezept: Dateien → Anhänge. Während des
/// Ziehens orange umrandet mit Hinweis. Nur wenn [enabled] (Desktop + Recht,
/// das Rezept zu bearbeiten).
class RecipeAttachmentDrop extends ConsumerStatefulWidget {
  final RecipeDetail recipe;
  final bool enabled;
  final Widget child;
  const RecipeAttachmentDrop({
    super.key,
    required this.recipe,
    required this.enabled,
    required this.child,
  });

  @override
  ConsumerState<RecipeAttachmentDrop> createState() =>
      _RecipeAttachmentDropState();
}

class _RecipeAttachmentDropState extends ConsumerState<RecipeAttachmentDrop> {
  bool _hover = false;
  bool _busy = false;

  Future<void> _upload(List<DropItem> files) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final allowed =
        allowedAssetExtensions(mealie329: ref.read(mealie329Provider));
    var ok = 0;
    var skipped = 0;
    String? error;
    setState(() => _busy = true);
    for (final f in files) {
      final file = File(f.path);
      final base = file.uri.pathSegments.last;
      final dot = base.lastIndexOf('.');
      final ext = dot < 0 ? '' : base.substring(dot + 1).toLowerCase();
      // Link-Dateien gehören zum Import, nicht in die Anhänge.
      if (!allowed.contains(ext)) {
        skipped++;
        continue;
      }
      try {
        await addRecipeAsset(ref, widget.recipe,
            file: file, name: dot < 0 ? base : base.substring(0, dot));
        ok++;
      } catch (e) {
        error ??= mealieErrorMessage(e) ?? l.saveFailed;
      }
    }
    if (!mounted) return;
    setState(() => _busy = false);
    // Nur Link-Dateien → das globale Ablageziel öffnet den Import; hier
    // keine „nicht unterstützt"-Meldung.
    final onlyLinks = ok == 0 &&
        error == null &&
        files.every((f) => RegExp(r'\.(webloc|url|txt)$', caseSensitive: false)
            .hasMatch(f.path));
    if (onlyLinks) return;
    messenger.showSnackBar(SnackBar(
      content: Text(error ??
          (skipped > 0 && ok == 0
              ? l.desktopDropUnsupported
              : l.desktopDropUploaded(ok))),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || !PlatformFeatures.webAppTools) return widget.child;
    final l = AppLocalizations.of(context)!;
    return DropTarget(
      onDragEntered: (_) => setState(() => _hover = true),
      onDragExited: (_) => setState(() => _hover = false),
      onDragDone: (details) {
        setState(() => _hover = false);
        _upload(details.files);
      },
      child: Stack(children: [
        widget.child,
        if (_hover || _busy)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTokens.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppTokens.rLg),
                  border: Border.all(color: AppTokens.accent, width: 2),
                ),
                alignment: Alignment.center,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: context.appCard,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: context.appShadowMd,
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    if (_busy)
                      const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                    else
                      const Icon(Icons.attach_file_rounded,
                          color: AppTokens.accentDeep),
                    const SizedBox(width: 8),
                    Text(l.desktopDropAsAttachment,
                        style: TextStyle(
                            color: context.appFg, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
