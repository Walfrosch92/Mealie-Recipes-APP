import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/section_header.dart';
import '../providers/detail_sections.dart';
import '../services/recipe_comments_sync.dart';
import '../../../shared/widgets/user_avatar.dart';

// ---------------------------------------------------------------------------
// Kommentare in der Rezeptdetailansicht (unter den Notizen): Verfasser,
// Zeitpunkt im regionalen Format, Text. Eigene Kommentare (bzw. alle für
// Admins — so prüft es auch Mealie) lassen sich löschen. Darunter das
// Eingabefeld für einen neuen Kommentar.
// ---------------------------------------------------------------------------

/// Datum + Uhrzeit eines Kommentars im Format der Region: App-Sprache mit dem
/// Land des Geräts, wenn die Sprache übereinstimmt (de + AT → „27.09.2026,
/// 14:05"; en + US → „Sep 27, 2026, 2:05 PM"), sonst nur die App-Sprache.
String formatCommentTime(BuildContext context, DateTime local) {
  final app = Localizations.localeOf(context).languageCode;
  final device = PlatformDispatcher.instance.locale;
  var locale = app;
  final country = device.countryCode;
  if (device.languageCode == app && country != null && country.isNotEmpty) {
    final candidate = '${app}_$country';
    if (DateFormat.localeExists(candidate)) locale = candidate;
  }
  return DateFormat.yMMMd(locale).add_jm().format(local);
}

class RecipeCommentsSection extends ConsumerStatefulWidget {
  final RecipeDetail recipe;

  /// Nur anzeigen (Kochmodus): keine Überschrift, kein Eingabefeld, kein
  /// Löschen.
  final bool readOnly;

  const RecipeCommentsSection(
      {super.key, required this.recipe, this.readOnly = false});

  @override
  ConsumerState<RecipeCommentsSection> createState() =>
      _RecipeCommentsSectionState();
}

class _RecipeCommentsSectionState extends ConsumerState<RecipeCommentsSection> {
  final _ctrl = TextEditingController();
  late List<RecipeComment> _comments;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _comments = List.of(widget.recipe.comments);
  }

  @override
  void didUpdateWidget(covariant RecipeCommentsSection old) {
    super.didUpdateWidget(old);
    if (!identical(old.recipe, widget.recipe)) {
      _comments = List.of(widget.recipe.comments);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty || _sending) return;
    final l = AppLocalizations.of(context)!;
    setState(() => _sending = true);
    try {
      final c = await postRecipeComment(ref, widget.recipe, text);
      if (!mounted) return;
      setState(() {
        _comments = [..._comments, c];
        _ctrl.clear();
      });
      FocusScope.of(context).unfocus();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(mealieErrorMessage(e) ?? l.commentSaveFailed)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _delete(RecipeComment c) async {
    final l = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: ctx.appCard,
            content: Text(l.commentDeleteConfirm,
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
    if (!ok) return;
    try {
      await deleteRecipeCommentEverywhere(ref, widget.recipe, c);
      if (!mounted) return;
      setState(() => _comments = _comments.where((x) => x.id != c.id).toList());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.deleteFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final me = ref.watch(currentUserProvider);
    final myId = me?['id']?.toString();
    final isAdmin = me?['admin'] == true;
    final canSend = _ctrl.text.trim().isNotEmpty && !_sending;

    final readOnly = widget.readOnly;
    final expanded =
        readOnly || isDetailSectionExpanded(ref, DetailSection.comments);
    final header = readOnly
        ? null
        : SectionHeader(
            icon: Icons.forum_rounded,
            title: l.commentsTitle,
            count: _comments.length,
            expanded: expanded,
            onToggle: () => toggleDetailSection(ref, DetailSection.comments),
          );
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final c in _comments)
          _CommentCard(
            comment: c,
            isMine: myId != null && c.userId == myId,
            canDelete:
                !readOnly && (isAdmin || (myId != null && c.userId == myId)),
            onDelete: () => _delete(c),
          ),
        if (!readOnly)
          // Eingabeleiste wie ein Chat: rundes Feld + Verlaufs-Senden-Button.
          Container(
            padding: const EdgeInsets.fromLTRB(16, 4, 6, 4),
            decoration: BoxDecoration(
              color: context.appCard,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: context.appSeparator, width: 1),
              boxShadow: context.appShadowSm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    enabled: !_sending,
                    minLines: 1,
                    maxLines: 5,
                    // Mehrzeilig: Tippen daneben schließt die Tastatur.
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(color: context.appFg, fontSize: 14.5),
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: l.commentHint,
                      hintStyle: TextStyle(color: context.appFgTertiary),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Semantics(
                    button: true,
                    label: l.send,
                    child: GestureDetector(
                      onTap: canSend ? _send : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // beim Senden orange lassen (weißer Lade-Kreis)
                          gradient: canSend || _sending
                              ? AppTokens.accentGradient
                              : null,
                          color:
                              canSend || _sending ? null : context.appSurface2,
                          boxShadow: canSend ? context.appAccentGlow : null,
                        ),
                        child: _sending
                            ? const Padding(
                                padding: EdgeInsets.all(11),
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : Icon(Icons.arrow_upward_rounded,
                                size: 21,
                                color: canSend
                                    ? Colors.white
                                    : context.appFgTertiary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
    if (header == null) return body;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [header, CollapsibleBody(expanded: expanded, child: body)],
    );
  }
}

class _CommentCard extends StatelessWidget {
  final RecipeComment comment;
  final bool isMine;
  final bool canDelete;
  final VoidCallback onDelete;

  const _CommentCard({
    required this.comment,
    required this.isMine,
    required this.canDelete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final when = comment.createdAtLocal;
    final name = comment.userName.isEmpty ? '—' : comment.userName;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.fromLTRB(12, 12, canDelete ? 0 : 14, 14),
      decoration: detailCardDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar: Mealie-Profilbild, sonst Anfangsbuchstabe (eigene
          // Kommentare im Verlauf, fremde dezent getönt).
          UserAvatar(
            userId: comment.userId,
            name: name,
            radius: 18,
            highlight: isMine,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: context.appFg,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700)),
                if (when != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(formatCommentTime(context, when),
                        style: TextStyle(
                            color: context.appFgTertiary, fontSize: 12)),
                  ),
                const SizedBox(height: 6),
                Text(comment.text,
                    style: TextStyle(
                        color: context.appFgSub, fontSize: 14, height: 1.45)),
              ],
            ),
          ),
          if (canDelete)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded,
                  size: 20, color: context.appFgTertiary),
              color: context.appCard,
              onSelected: (_) => onDelete(),
              itemBuilder: (_) => [
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
        ],
      ),
    );
  }
}
