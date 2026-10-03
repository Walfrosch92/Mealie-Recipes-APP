import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart' show mealieErrorMessage;
import '../../../shared/theme/app_colors.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../providers/timeline_filter_provider.dart';
import '../providers/timeline_provider.dart';
import '../widgets/timeline_event_card.dart';

// ---------------------------------------------------------------------------
// Zeitleiste aller Rezepte (Home-Kachel) — wie die Zeitleisten-Seite der
// Mealie-Webapp: neueste zuerst, lädt beim Scrollen seitenweise nach. Kopf
// jeder Karte = Rezept (Tippen öffnet es).
// ---------------------------------------------------------------------------

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 600) {
        ref.read(globalTimelineProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final async = ref.watch(globalTimelineProvider);
    final recipes = ref.watch(recipesProvider).valueOrNull ?? const [];
    final byId = {for (final r in recipes) r.id: r};
    final types = ref.watch(timelineTypeFilterProvider);

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Text(l.timelineTitle),
        actions: const [TimelineFilterButton(), SizedBox(width: 4)],
      ),
      body: WithCookingModeFAB(
        child: SafeArea(
          top: false,
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(mealieErrorMessage(e) ?? e.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: context.appFgSub)),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => ref.invalidate(globalTimelineProvider),
                      child: Text(l.retry),
                    ),
                  ],
                ),
              ),
            ),
            data: (raw) {
              final events = applyTimelineFilter(raw.events, types);
              return RefreshIndicator(
                onRefresh: () =>
                    ref.read(globalTimelineProvider.notifier).refresh(),
                child: events.isEmpty
                    ? ListView(children: [
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(l.timelineEmpty,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: context.appFgSub, fontSize: 15)),
                        ),
                      ])
                    : ListView.builder(
                        controller: _scroll,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                        itemCount: events.length + (raw.loadingMore ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (i >= events.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final e = events[i];
                          final recipe = byId[e.recipeId];
                          return TimelineEventCard(
                            event: e,
                            recipe: recipe,
                            onOpenRecipe: recipe == null
                                ? null
                                : () => context.push('/recipes/${recipe.id}'),
                          );
                        },
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
