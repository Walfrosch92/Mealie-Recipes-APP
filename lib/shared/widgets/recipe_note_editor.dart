import 'package:flutter/material.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../core/models/recipe_detail.dart';
import '../theme/app_colors.dart';
import 'markdown_text.dart';
import 'section_header.dart';
import '../../features/recipes/services/recipe_text_image.dart'
    show appendToTextField;

// ---------------------------------------------------------------------------
// Wiederverwendbare Bausteine zum Anzeigen/Anlegen/Löschen einer einzelnen
// Rezept-Notiz (RecipeNote{title,text}) — genutzt von der Detailansicht
// (inline Sektion) und vom Kochmodus (Bottom-Sheet). Reine UI, keine
// Provider-Kopplung — Persistenz übernimmt der Aufrufer.
// ---------------------------------------------------------------------------

/// Dialog zum Anlegen (`initial == null`) oder Bearbeiten einer Notiz.
/// Liefert `null` bei Abbruch oder leerem Text.
Future<RecipeNote?> showNoteEditorDialog(
  BuildContext context, {
  RecipeNote? initial,
  // Bild hochladen und als `<img>` einfügen (null = kein Knopf, z. B. ohne
  // Recht zum Bearbeiten oder im Gastmodus).
  Future<String?> Function()? onPickImage,
}) =>
    showDialog<RecipeNote>(
      context: context,
      builder: (_) =>
          _NoteEditorDialog(initial: initial, onPickImage: onPickImage),
    );

/// Eigenes StatefulWidget, das seine Controller selbst besitzt und erst beim
/// Abbau freigibt — vorher wurden sie direkt nach `showDialog` freigegeben,
/// während der Dialog noch ausblendete („TextEditingController used after
/// being disposed").
class _NoteEditorDialog extends StatefulWidget {
  final RecipeNote? initial;
  final Future<String?> Function()? onPickImage;
  const _NoteEditorDialog({this.initial, this.onPickImage});

  @override
  State<_NoteEditorDialog> createState() => _NoteEditorDialogState();
}

class _NoteEditorDialogState extends State<_NoteEditorDialog> {
  late final _titleCtrl =
      TextEditingController(text: widget.initial?.title ?? '');
  late final _textCtrl =
      TextEditingController(text: widget.initial?.text ?? '');
  bool _uploading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _uploading = true);
    final tag = await widget.onPickImage!();
    if (!mounted) return;
    if (tag != null) appendToTextField(_textCtrl, tag);
    setState(() => _uploading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      // Querformat/Tastatur: Inhalt scrollt, Knöpfe bleiben sichtbar.
      scrollable: true,
      backgroundColor: context.appCard,
      title: Text(widget.initial == null ? l.addNote : l.editNote,
          style: TextStyle(color: context.appFg)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleCtrl,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(color: context.appFg),
            decoration: InputDecoration(hintText: l.noteTitleHint),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _textCtrl,
            minLines: 3,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(color: context.appFg),
            decoration: InputDecoration(hintText: l.noteTextHint),
          ),
          if (widget.onPickImage != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _uploading ? null : _pickImage,
                icon: _uploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.add_photo_alternate_outlined, size: 18),
                label: Text(l.insertStepImageAction),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: _uploading
              ? null
              : () {
                  final text = _textCtrl.text.trim();
                  if (text.isEmpty) {
                    Navigator.pop(context);
                    return;
                  }
                  Navigator.pop(context,
                      RecipeNote(title: _titleCtrl.text.trim(), text: text));
                },
          child: Text(l.save),
        ),
      ],
    );
  }
}

/// Löschbestätigung — analog zum bestehenden Rezept-Löschen-Dialog.
Future<bool> confirmDeleteNote(BuildContext context) async {
  final l = AppLocalizations.of(context)!;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: ctx.appCard,
      title: Text(l.deleteNoteTitle, style: TextStyle(color: ctx.appFg)),
      content: Text(l.deleteNoteMessage, style: TextStyle(color: ctx.appFgSub)),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
        FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l.delete),
        ),
      ],
    ),
  );
  return ok ?? false;
}

class RecipeNoteCard extends StatelessWidget {
  final RecipeNote note;
  final bool editable;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  /// Für Bilder in der Notiz (Mealie-Asset-Pfade + Anmeldung nur am eigenen
  /// Server). Ohne Server (Gastmodus) erscheinen nur absolute Bild-URLs.
  final String? serverUrl;
  final String? apiToken;

  const RecipeNoteCard({
    super.key,
    required this.note,
    this.editable = false,
    this.onEdit,
    this.onDelete,
    this.serverUrl,
    this.apiToken,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: detailCardDecoration(context),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Akzentstreifen: Notizen als Hinweise erkennbar
            Container(
              width: 4,
              decoration:
                  const BoxDecoration(gradient: AppTokens.accentGradient),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(14, 12, editable ? 0 : 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (note.title.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          note.title,
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: context.appFg,
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    // Bilder in Notizen anzeigen (antippen = groß), wie in
                    // den Schritten — vorher still ausgeblendet.
                    MarkdownText(
                      text: note.text,
                      serverUrl: serverUrl,
                      apiToken: apiToken,
                      style: TextStyle(
                          color: context.appFgSub, fontSize: 14, height: 1.45),
                    ),
                  ],
                ),
              ),
            ),
            if (editable)
              Align(
                alignment: Alignment.topCenter,
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert_rounded,
                      size: 20, color: context.appFgTertiary),
                  color: context.appCard,
                  onSelected: (v) =>
                      v == 'edit' ? onEdit?.call() : onDelete?.call(),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [
                        Icon(Icons.edit_outlined,
                            size: 19, color: context.appFg),
                        const SizedBox(width: 10),
                        Text(l.edit),
                      ]),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [
                        const Icon(Icons.delete_outline_rounded,
                            size: 19, color: Color(0xFFE53935)),
                        const SizedBox(width: 10),
                        Text(l.delete,
                            style: const TextStyle(color: Color(0xFFE53935))),
                      ]),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// „Notiz hinzufügen": bei leerer Liste als einladende Platzhalter-Karte,
/// sonst (ohne Überschrift, z. B. im Kochmodus-Sheet) als Button darunter.
class AddNoteButton extends StatelessWidget {
  final VoidCallback onTap;

  /// true = leere Liste → großer Platzhalter mit Hinweistext.
  final bool empty;
  const AddNoteButton({super.key, required this.onTap, this.empty = false});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Material(
      color: AppTokens.accent.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(AppTokens.rMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.rMd),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding:
              EdgeInsets.symmetric(vertical: empty ? 18 : 12, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTokens.rMd),
            border: Border.all(
                color: AppTokens.accent.withValues(alpha: 0.35), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline_rounded,
                  size: 20, color: AppTokens.accentDeep),
              const SizedBox(width: 8),
              Text(l.addNote,
                  style: const TextStyle(
                      color: AppTokens.accentDeep,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
