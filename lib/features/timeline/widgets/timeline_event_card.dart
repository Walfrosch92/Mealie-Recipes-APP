import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/models/timeline_event.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/utils/media_urls.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/recipe_image_viewer.dart';
import '../../../shared/widgets/section_header.dart';
import '../providers/timeline_provider.dart';
import '../../../shared/widgets/user_avatar.dart';

/// Datum eines Eintrags („Sa., 27. Sep. 2026").
String formatTimelineDate(BuildContext context, DateTime? d) => d == null
    ? ''
    : DateFormat.yMMMEd(Localizations.localeOf(context).toString()).format(d);

/// Ein Zeitleisten-Eintrag: Datum, Betreff, Notiz, Foto (Tippen = Vollbild).
/// Eigene Einträge (oder alle für Admins — wie Mealie) lassen sich bearbeiten
/// und löschen. [recipe]/[onOpenRecipe] = Kopfzeile mit Rezept (Gesamt-
/// Zeitleiste).
class TimelineEventCard extends ConsumerWidget {
  final TimelineEvent event;
  final RecipeDetail? recipe;
  final VoidCallback? onOpenRecipe;
  final VoidCallback? onDeleted;

  const TimelineEventCard({
    super.key,
    required this.event,
    this.recipe,
    this.onOpenRecipe,
    this.onDeleted,
  });

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final ctrl = TextEditingController(text: event.message);
    final text = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.appCard,
        title: Text(l.timelineEditNote),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          minLines: 2,
          maxLines: 6,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: Text(l.save)),
        ],
      ),
    );
    ctrl.dispose();
    if (text == null) return;
    try {
      await ref
          .read(recipeTimelineProvider(event.recipeId).notifier)
          .updateMessage(event, text);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(mealieErrorMessage(e) ?? l.saveFailed)));
      }
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: ctx.appCard,
            content: Text(l.timelineDeleteConfirm,
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
      await ref
          .read(recipeTimelineProvider(event.recipeId).notifier)
          .delete(event);
      onDeleted?.call();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.deleteFailed)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider).valueOrNull;
    final server = settings?.serverUrl ?? '';
    final headers = mediaHeaders(settings);
    final me = ref.watch(currentUserProvider);
    final canEdit = !event.isSystem &&
        (me?['admin'] == true ||
            (me?['id'] != null && me!['id'].toString() == event.userId));

    final icon = switch (event.eventType) {
      'system' => Icons.info_outline_rounded,
      'comment' => Icons.restaurant_rounded,
      _ => Icons.bookmark_outline_rounded,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: detailCardDecoration(context),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (onOpenRecipe != null)
            InkWell(
              onTap: onOpenRecipe,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: server.isEmpty
                            ? _thumbFallback(context)
                            : CachedNetworkImage(
                                imageUrl:
                                    '$server/api/media/recipes/${event.recipeId}/images/min-original.webp',
                                httpHeaders: headers,
                                fit: BoxFit.cover,
                                errorWidget: (c, _, __) => _thumbFallback(c),
                                placeholder: (c, _) => _thumbFallback(c),
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(recipe?.name ?? l.timelineUnknownRecipe,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: context.appFg,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        color: context.appFgTertiary),
                  ],
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 12, canEdit ? 0 : 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Verfasser mit Profilbild; System-Einträge und Nutzer ohne
                // Bild behalten das Typ-Symbol.
                UserAvatar(
                  userId: event.isSystem ? null : event.userId,
                  name: '',
                  radius: 17,
                  fallback: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient:
                          event.isSystem ? null : AppTokens.accentGradient,
                      color: event.isSystem ? context.appSurface2 : null,
                    ),
                    child: Icon(icon,
                        size: 18,
                        color:
                            event.isSystem ? context.appFgSub : Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formatTimelineDate(context, event.timestampLocal),
                          style: TextStyle(
                              color: context.appFgTertiary, fontSize: 12)),
                      const SizedBox(height: 2),
                      Text(event.subject,
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: context.appFg,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700)),
                      if (event.message.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(event.message,
                            style: TextStyle(
                                color: context.appFgSub,
                                fontSize: 14,
                                height: 1.4)),
                      ],
                    ],
                  ),
                ),
                if (canEdit)
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert_rounded,
                        size: 20, color: context.appFgTertiary),
                    color: context.appCard,
                    onSelected: (v) => v == 'edit'
                        ? _edit(context, ref)
                        : _delete(context, ref),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(children: [
                          Icon(Icons.edit_rounded,
                              size: 19, color: context.appFg),
                          const SizedBox(width: 10),
                          Text(l.timelineEditNote),
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
              ],
            ),
          ),
          if (event.hasImage && server.isNotEmpty)
            GestureDetector(
              onTap: () => showRecipeImageViewer(
                context,
                recipeId: event.recipeId,
                imageUrl: timelineImageUrl(server, event.recipeId, event.id,
                    size: 'original'),
                httpHeaders: headers,
                useOfflineCopy: false,
              ),
              child: CachedNetworkImage(
                imageUrl: timelineImageUrl(server, event.recipeId, event.id),
                httpHeaders: headers,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (c, _) =>
                    Container(height: 200, color: c.appSurface2),
                errorWidget: (c, _, __) => const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _thumbFallback(BuildContext context) => Container(
        color: context.appSurface2,
        child: Icon(Icons.restaurant_rounded,
            size: 18, color: context.appFgTertiary),
      );
}
