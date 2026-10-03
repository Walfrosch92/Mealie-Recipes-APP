import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/recipe_detail.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/section_header.dart';
import '../../recipes/providers/detail_sections.dart';
import '../providers/timeline_filter_provider.dart';
import '../providers/timeline_provider.dart';
import 'made_this_sheet.dart';
import 'timeline_event_card.dart';

/// Zeitleiste in der Rezeptdetailansicht (unter Kommentaren): aufklappbar,
/// „Ich hab's gekocht" oben, darunter die Einträge (neueste zuerst). Standard
/// sind die letzten [_initialCount] sichtbar, der Rest per „Alle anzeigen".
class RecipeTimelineSection extends ConsumerStatefulWidget {
  final RecipeDetail recipe;
  const RecipeTimelineSection({super.key, required this.recipe});

  @override
  ConsumerState<RecipeTimelineSection> createState() =>
      _RecipeTimelineSectionState();
}

class _RecipeTimelineSectionState extends ConsumerState<RecipeTimelineSection> {
  static const _initialCount = 5;
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final all =
        ref.watch(recipeTimelineProvider(widget.recipe.id)).valueOrNull ??
            const [];
    final events =
        applyTimelineFilter(all, ref.watch(timelineTypeFilterProvider));
    final expanded = isDetailSectionExpanded(ref, DetailSection.timeline);
    final shown =
        _showAll ? events : events.take(_initialCount).toList(growable: false);

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SectionAddButton(
            label: l.timelineMadeThis,
            icon: Icons.restaurant_rounded,
            onTap: () => showMadeThisSheet(context, widget.recipe),
          ),
        ),
        if (events.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(l.timelineEmpty,
                style: TextStyle(color: context.appFgSub, fontSize: 14)),
          ),
        for (final e in shown) TimelineEventCard(event: e),
        if (!_showAll && events.length > _initialCount)
          TextButton(
            onPressed: () => setState(() => _showAll = true),
            child: Text('${l.showAll} (${events.length})'),
          ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          icon: Icons.timeline_rounded,
          title: l.timelineTitle,
          count: events.length,
          expanded: expanded,
          trailing: all.isEmpty ? null : const TimelineFilterButton(),
          onToggle: () => toggleDetailSection(ref, DetailSection.timeline),
        ),
        CollapsibleBody(expanded: expanded, child: body),
      ],
    );
  }
}
