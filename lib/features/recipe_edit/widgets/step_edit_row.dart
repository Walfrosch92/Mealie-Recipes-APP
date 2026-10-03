import 'package:flutter/material.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/markdown_text.dart';
import '../models/recipe_draft.dart';
import 'edit_common.dart';

/// Aktionen im „⋯"-Menü eines Schritts (wie das Schritt-Menü der Webapp).
enum StepAction {
  toggleSection,
  link,
  insertImage,
  togglePreview,
  mergeAbove,
  insertAbove,
  insertBelow,
  moveTop,
  moveBottom,
  delete,
}

/// Ein Zubereitungsschritt: Nummer + Ziehgriff, Überschrift, Text (Markdown,
/// mit Vorschau), Verknüpfungen und optional ein Abschnittstitel.
class StepEditRow extends StatelessWidget {
  final DraftStep item;
  final int index;
  final int count;

  /// Verknüpfte Zutaten/Notizen, die es (noch) gibt.
  final int linkedCount;
  final bool uploadingImage;
  final String? serverUrl;
  final String? apiToken;
  final ValueChanged<StepAction> onAction;
  final VoidCallback onChanged;

  const StepEditRow({
    super.key,
    required this.item,
    required this.index,
    required this.count,
    required this.linkedCount,
    required this.uploadingImage,
    required this.serverUrl,
    required this.apiToken,
    required this.onAction,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final primary = Theme.of(context).colorScheme.primary;

    final body = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReorderableDragStartListener(
          index: index,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Column(children: [
              CircleAvatar(radius: 14, child: Text('${index + 1}')),
              const SizedBox(height: 4),
              Icon(Icons.drag_indicator_rounded,
                  size: 20, color: context.appFgTertiary),
            ]),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onTapOutside: unfocusOnTapOutside,
                controller: item.summary,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => onChanged(),
                style: const TextStyle(fontWeight: FontWeight.w700),
                decoration: outlinedEditDecoration(l.stepHeadingLabel),
              ),
              const SizedBox(height: 8),
              if (item.preview)
                InkWell(
                  onTap: () => onAction(StepAction.togglePreview),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.appSurface2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: item.text.text.trim().isEmpty
                        ? Text('—',
                            style: TextStyle(color: context.appFgTertiary))
                        : MarkdownText(
                            text: item.text.text,
                            style: TextStyle(
                                color: context.appFg,
                                fontSize: 15,
                                height: 1.4),
                            serverUrl: serverUrl,
                            apiToken: apiToken,
                          ),
                  ),
                )
              else
                TextField(
                  onTapOutside: unfocusOnTapOutside,
                  controller: item.text,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  onChanged: (_) => onChanged(),
                  decoration: outlinedEditDecoration(l.instructionText)
                      .copyWith(border: const OutlineInputBorder()),
                  minLines: 2,
                  maxLines: null,
                ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor:
                          linkedCount > 0 ? primary : context.appFgTertiary,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.link_rounded, size: 18),
                    label: Text(
                      linkedCount > 0
                          ? '${l.linkReferencesAction} ($linkedCount)'
                          : l.linkReferencesAction,
                      style: const TextStyle(fontSize: 13),
                    ),
                    onPressed: () => onAction(StepAction.link),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor:
                          item.preview ? primary : context.appFgTertiary,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: Icon(
                        item.preview
                            ? Icons.edit_note_rounded
                            : Icons.visibility_outlined,
                        size: 18),
                    label: Text(
                        item.preview
                            ? l.editMarkdownAction
                            : l.previewMarkdownAction,
                        style: const TextStyle(fontSize: 13)),
                    onPressed: () => onAction(StepAction.togglePreview),
                  ),
                  if (uploadingImage)
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                ],
              ),
            ],
          ),
        ),
        EditMenuButton<StepAction>(
          onSelected: onAction,
          items: [
            EditMenuItem(StepAction.toggleSection, Icons.segment_rounded,
                item.showTitle ? l.clearSection : l.addIngredientSection),
            EditMenuItem(
                StepAction.link, Icons.link_rounded, l.linkReferencesAction),
            EditMenuItem(StepAction.insertImage,
                Icons.add_photo_alternate_outlined, l.insertStepImageAction,
                enabled: !uploadingImage),
            EditMenuItem(
                StepAction.togglePreview,
                item.preview
                    ? Icons.edit_note_rounded
                    : Icons.visibility_outlined,
                item.preview ? l.editMarkdownAction : l.previewMarkdownAction),
            null,
            EditMenuItem(
                StepAction.mergeAbove, Icons.merge_rounded, l.mergeAboveAction,
                enabled: index > 0),
            EditMenuItem(StepAction.insertAbove,
                Icons.vertical_align_top_rounded, l.insertAboveAction),
            EditMenuItem(StepAction.insertBelow,
                Icons.vertical_align_bottom_rounded, l.insertBelowAction),
            EditMenuItem(StepAction.moveTop, Icons.keyboard_double_arrow_up,
                l.moveToTopAction,
                enabled: index > 0),
            EditMenuItem(StepAction.moveBottom,
                Icons.keyboard_double_arrow_down, l.moveToBottomAction,
                enabled: index < count - 1),
            null,
            EditMenuItem(StepAction.delete, Icons.delete_outline_rounded,
                l.removeInstruction,
                destructive: true),
          ],
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Abschnitt (Mealie „Titel des Abschnitts"): beginnt bei diesem
          // Schritt und gilt bis zum nächsten Titel.
          if (item.showTitle)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8, right: 40),
              child: TextField(
                onTapOutside: unfocusOnTapOutside,
                controller: item.title,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => onChanged(),
                style: const TextStyle(
                    color: AppTokens.accentDeep, fontWeight: FontWeight.w700),
                decoration: outlinedEditDecoration(
                  l.sectionTitleLabel,
                  prefixIcon: const Icon(Icons.segment_rounded, size: 20),
                  suffixIcon: IconButton(
                    tooltip: l.clearSection,
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () => onAction(StepAction.toggleSection),
                  ),
                ),
              ),
            ),
          body,
        ],
      ),
    );
  }
}

/// Verknüpfen-Sheet eines Schritts: Zutaten (und ab Mealie 3.28 Notizen) per
/// Checkbox. Zeigt wie die Webapp, ob eine Zutat schon an einem anderen
/// Schritt hängt. Mutiert die Listen des Schritts direkt.
class LinkReferencesSheet extends StatefulWidget {
  final DraftStep step;
  final List<DraftStep> allSteps;
  final List<DraftIngredient> ingredients;
  final List<DraftNote> notes;
  final bool notesSupported;

  const LinkReferencesSheet({
    super.key,
    required this.step,
    required this.allSteps,
    required this.ingredients,
    required this.notes,
    required this.notesSupported,
  });

  @override
  State<LinkReferencesSheet> createState() => _LinkReferencesSheetState();
}

class _LinkReferencesSheetState extends State<LinkReferencesSheet> {
  bool _linkedElsewhere(String refId) => widget.allSteps.any(
      (s) => !identical(s, widget.step) && s.ingredientRefs.contains(refId));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final maxH = MediaQuery.sizeOf(context).height * 0.7;
    final ings =
        widget.ingredients.where((i) => i.displayText.isNotEmpty).toList();
    final notes = widget.notes.where((n) => !n.isEmpty).toList();

    Widget heading(String text) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(text,
              style: TextStyle(
                  color: context.appFgSub,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        );

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EditSheetHeader(
                icon: Icons.link_rounded, title: l.linkReferencesAction),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  heading(l.ingredients),
                  if (ings.isEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Text(l.noIngredientsToLink,
                          style:
                              TextStyle(color: context.appFgSub, fontSize: 14)),
                    ),
                  for (final ing in ings)
                    CheckboxListTile(
                      value:
                          widget.step.ingredientRefs.contains(ing.referenceId),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(ing.displayText,
                          style: TextStyle(color: context.appFg)),
                      subtitle: _linkedElsewhere(ing.referenceId)
                          ? Text(l.linkedToOtherStep,
                              style: TextStyle(
                                  color: context.appFgTertiary, fontSize: 12))
                          : null,
                      onChanged: (v) => setState(() {
                        final refs = widget.step.ingredientRefs;
                        v == true
                            ? refs.add(ing.referenceId)
                            : refs.remove(ing.referenceId);
                      }),
                    ),
                  if (widget.notesSupported) ...[
                    heading(l.notes),
                    if (notes.isEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Text(l.noNotesToLink,
                            style: TextStyle(
                                color: context.appFgSub, fontSize: 14)),
                      ),
                    for (final n in notes)
                      CheckboxListTile(
                        value: widget.step.noteRefs.contains(n.referenceId),
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(n.label,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: context.appFg)),
                        onChanged: (v) => setState(() {
                          final refs = widget.step.noteRefs;
                          v == true
                              ? refs.add(n.referenceId)
                              : refs.remove(n.referenceId);
                        }),
                      ),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
