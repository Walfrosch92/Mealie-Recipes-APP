import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/recipe_detail.dart';
import '../../../shared/widgets/recipe_note_editor.dart';
import '../../../shared/widgets/section_header.dart';
import '../providers/detail_sections.dart';
import '../services/recipe_notes_sync.dart';

/// Notizen-Liste eines Rezepts inkl. Anlegen/Bearbeiten/Löschen — genutzt
/// sowohl inline in der Detailansicht als auch im Kochmodus-Bottom-Sheet.
/// Hält die Liste lokal (sofortige Anzeige), persistiert im Hintergrund über
/// [persistRecipeNotes] und zeigt bei Sync-Fehlern eine Snackbar (die lokale
/// Änderung bleibt trotzdem sichtbar — offline-first).
class RecipeNotesList extends ConsumerStatefulWidget {
  final RecipeDetail recipe;
  final bool editable;
  final bool showHeader;

  /// Detailansicht: Überschrift klappt den Bereich ein/aus (gespeichert).
  final bool collapsible;

  const RecipeNotesList({
    super.key,
    required this.recipe,
    required this.editable,
    this.showHeader = true,
    this.collapsible = false,
  });

  @override
  ConsumerState<RecipeNotesList> createState() => _RecipeNotesListState();
}

class _RecipeNotesListState extends ConsumerState<RecipeNotesList> {
  late List<RecipeNote> _notes;

  @override
  void initState() {
    super.initState();
    _notes = List.of(widget.recipe.notes);
  }

  @override
  void didUpdateWidget(covariant RecipeNotesList old) {
    super.didUpdateWidget(old);
    if (!identical(old.recipe, widget.recipe)) {
      _notes = List.of(widget.recipe.notes);
    }
  }

  Future<void> _persist() async {
    final before = List.of(widget.recipe.notes);
    try {
      await persistRecipeNotes(ref, widget.recipe, _notes);
    } on RecipeNotesRejected {
      // Kein Recht: Anzeige auf den Server-Stand zurücksetzen.
      if (!mounted) return;
      final l = AppLocalizations.of(context)!;
      setState(() => _notes = before);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.notesNotSavedNoPermission)));
    } catch (_) {
      if (!mounted) return;
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.saveFailed)));
    }
  }

  Future<void> _add() async {
    final note = await showNoteEditorDialog(context);
    if (note == null || !mounted) return;
    setState(() => _notes = [..._notes, note]);
    _persist();
  }

  Future<void> _edit(int i) async {
    final note = await showNoteEditorDialog(context, initial: _notes[i]);
    if (note == null || !mounted) return;
    setState(() => _notes = List.of(_notes)..[i] = note);
    _persist();
  }

  Future<void> _delete(int i) async {
    final ok = await confirmDeleteNote(context);
    if (!ok || !mounted) return;
    setState(() => _notes = List.of(_notes)..removeAt(i));
    _persist();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final collapsible = widget.showHeader && widget.collapsible;
    final expanded =
        !collapsible || isDetailSectionExpanded(ref, DetailSection.notes);
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < _notes.length; i++)
          RecipeNoteCard(
            note: _notes[i],
            editable: widget.editable,
            onEdit: () => _edit(i),
            onDelete: () => _delete(i),
          ),
        // Hinzufügen immer im Inhalt (nicht in der Überschrift) — so sind alle
        // Bereichs-Überschriften gleich aufgebaut und der Pfeil sitzt überall
        // an derselben Stelle.
        if (widget.editable) AddNoteButton(onTap: _add, empty: _notes.isEmpty),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showHeader)
          SectionHeader(
            icon: Icons.sticky_note_2_rounded,
            title: l.notes,
            count: _notes.length,
            expanded: expanded,
            onToggle: collapsible
                ? () => toggleDetailSection(ref, DetailSection.notes)
                : null,
          ),
        CollapsibleBody(expanded: expanded, child: body),
      ],
    );
  }
}
