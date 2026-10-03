import '../../../core/utils/platform_features.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart' show mealieErrorMessage;
import '../../../core/models/recipe_detail.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/photo_source_sheet.dart';
import '../../../shared/widgets/section_header.dart';
import '../providers/detail_sections.dart';
import '../screens/recipe_asset_viewer.dart';
import '../services/recipe_assets_sync.dart';

/// Anhänge in der Rezeptdetailansicht (Mealie `assets`): Liste, Tippen
/// öffnet, „⋮" entfernt, unten „Anhang hinzufügen" (Datei, Kamera, Fotos).
class RecipeAssetsSection extends ConsumerStatefulWidget {
  final RecipeDetail recipe;

  /// false = nur ansehen (kein Recht, das Rezept zu bearbeiten).
  final bool editable;
  const RecipeAssetsSection(
      {super.key, required this.recipe, this.editable = true});

  @override
  ConsumerState<RecipeAssetsSection> createState() =>
      _RecipeAssetsSectionState();
}

class _RecipeAssetsSectionState extends ConsumerState<RecipeAssetsSection> {
  bool _uploading = false;

  Future<void> _add() async {
    final l = AppLocalizations.of(context)!;
    final source = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      backgroundColor: context.appCard,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.insert_drive_file_rounded, color: ctx.appFg),
              title:
                  Text(l.assetsChooseFile, style: TextStyle(color: ctx.appFg)),
              subtitle: Text(l.assetsUnsupported,
                  style: TextStyle(color: ctx.appFgSub, fontSize: 12)),
              onTap: () => Navigator.pop(ctx, 'file'),
            ),
            ListTile(
              leading: Icon(
                  PlatformFeatures.camera
                      ? Icons.photo_camera_rounded
                      : Icons.photo_library_rounded,
                  color: ctx.appFg),
              title: Text(
                  PlatformFeatures.camera
                      ? '${l.takePhoto} / ${l.selectPhoto}'
                      : l.selectPhoto,
                  style: TextStyle(color: ctx.appFg)),
              onTap: () => Navigator.pop(ctx, 'photo'),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    File? file;
    if (source == 'file') {
      final res = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: kAllowedAssetExtensions);
      final path = res?.files.single.path;
      if (path != null) file = File(path);
    } else {
      file = await pickPhotoWithSource(context);
    }
    if (file == null || !mounted) return;

    final fileName = file.path.split('/').last;
    final dot = fileName.lastIndexOf('.');
    final ext = dot < 0 ? '' : fileName.substring(dot + 1).toLowerCase();
    if (!kAllowedAssetExtensions.contains(ext)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.assetsUnsupported)));
      return;
    }

    final name =
        await _askName(dot < 0 ? fileName : fileName.substring(0, dot));
    if (name == null || !mounted) return;

    setState(() => _uploading = true);
    try {
      await addRecipeAsset(ref, widget.recipe, file: file, name: name);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(mealieErrorMessage(e) ?? l.assetsUploadFailed)));
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<String?> _askName(String initial) async {
    final l = AppLocalizations.of(context)!;
    final ctrl = TextEditingController(text: initial);
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.appCard,
        title: Text(l.assetsAdd),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: l.name),
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: Text(l.add)),
        ],
      ),
    );
    ctrl.dispose();
    return (name == null || name.isEmpty) ? null : name;
  }

  Future<void> _remove(RecipeAsset asset) async {
    final l = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: ctx.appCard,
            content: Text(l.assetsDeleteConfirm(asset.name),
                style: TextStyle(color: ctx.appFg)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l.cancel)),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l.delete),
              ),
            ],
          ),
        ) ??
        false;
    if (!ok || !mounted) return;
    try {
      await removeRecipeAsset(ref, widget.recipe, asset);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.deleteFailed)));
      }
    }
  }

  IconData _icon(RecipeAsset a) {
    if (a.isPdf) return Icons.picture_as_pdf_rounded;
    if (a.isImage) return Icons.image_rounded;
    if (a.extension == 'json') return Icons.data_object_rounded;
    if (a.isText) return Icons.description_rounded;
    return Icons.insert_drive_file_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final assets = widget.recipe.assets;
    final expanded = isDetailSectionExpanded(ref, DetailSection.assets);

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final a in assets)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: detailCardDecoration(context),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => openRecipeAsset(context, ref, widget.recipe, a),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTokens.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          Icon(_icon(a), size: 20, color: AppTokens.accentDeep),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: context.appFg,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700)),
                          if (a.extension.isNotEmpty)
                            Text(a.extension.toUpperCase(),
                                style: TextStyle(
                                    color: context.appFgTertiary,
                                    fontSize: 11.5)),
                        ],
                      ),
                    ),
                    if (widget.editable)
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert_rounded,
                            size: 20, color: context.appFgTertiary),
                        color: context.appCard,
                        onSelected: (_) => _remove(a),
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(children: [
                              const Icon(Icons.delete_outline_rounded,
                                  size: 19, color: Color(0xFFE53935)),
                              const SizedBox(width: 10),
                              Text(l.delete,
                                  style: const TextStyle(
                                      color: Color(0xFFE53935))),
                            ]),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        if (widget.editable)
          SectionAddButton(
            label: _uploading ? l.assetsUploading : l.assetsAdd,
            icon: Icons.attach_file_rounded,
            busy: _uploading,
            onTap: _add,
          ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          icon: Icons.attach_file_rounded,
          title: l.assetsTitle,
          count: assets.length,
          expanded: expanded,
          onToggle: () => toggleDetailSection(ref, DetailSection.assets),
        ),
        CollapsibleBody(expanded: expanded, child: body),
      ],
    );
  }
}
