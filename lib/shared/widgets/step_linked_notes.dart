import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../core/models/recipe_detail.dart';
import '../../core/providers/settings_provider.dart';
import '../theme/app_colors.dart';
import 'markdown_text.dart';
import 'tap_area.dart';

// ---------------------------------------------------------------------------
// Mit einem Schritt verknüpfte Notizen (Mealie 3.28 `noteReferences`) — wie
// die Webapp (RecipePageInstructions.vue): in der Rezeptansicht ein Notiz-
// Knopf am Schritt, der sie öffnet; im Kochmodus direkt neben dem Schritt.
// Titel leer → „Notiz"; Text als Markdown.
// ---------------------------------------------------------------------------

class StepLinkedNotesButton extends StatelessWidget {
  final List<RecipeNote> notes;
  const StepLinkedNotesButton({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    return Tooltip(
      message: '${l.stepLinkedNotes} (${notes.length})',
      child: TapArea(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.selectionClick();
          showModalBottomSheet<void>(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (_) => SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l.stepLinkedNotes,
                        style: TextStyle(
                            color: context.appFg,
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    StepLinkedNotesList(notes: notes),
                  ],
                ),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.sticky_note_2_outlined,
                size: 20, color: AppTokens.accentDeep),
            if (notes.length > 1)
              Text(' ${notes.length}',
                  style: const TextStyle(
                      color: AppTokens.accentDeep,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
    );
  }
}

/// Die Notizen untereinander (Titel + Markdown-Text), mit Trennlinien.
class StepLinkedNotesList extends ConsumerWidget {
  final List<RecipeNote> notes;
  final bool dimmed;
  const StepLinkedNotesList(
      {super.key, required this.notes, this.dimmed = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider).valueOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (i, n) in notes.indexed) ...[
          if (i > 0) Divider(color: context.appSeparator, height: 20),
          Text(n.title.trim().isEmpty ? l.noteFallbackTitle : n.title.trim(),
              style: TextStyle(
                  color: dimmed ? context.appFgSub : context.appFg,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          MarkdownText(
            text: n.text,
            serverUrl: settings?.serverUrl,
            apiToken: settings?.apiToken,
            style: TextStyle(
                color: context.appFgSub, fontSize: 14, height: 1.4),
          ),
        ],
      ],
    );
  }
}
