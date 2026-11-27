import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/collapsible_hint.dart';
import '../../../shared/widgets/sheet_title.dart';
import '../../webapp_tools/screens/recipe_actions_screen.dart'
    show recipeActionsProvider;
import '../providers/recipe_match_provider.dart';

// ---------------------------------------------------------------------------
// Rezept-Match ⋮ → „Rezept-Aktionen" (#53): je eine „Post"-Aktion des
// Haushalts fürs Behalten und fürs Überspringen wählen (Standard: keine).
// Link-Aktionen stehen bewusst nicht zur Wahl — die würden bei jedem
// Wischen den Browser öffnen.
// ---------------------------------------------------------------------------

Future<void> showRecipeMatchActionsSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => const _ActionsSheet(),
    );

class _ActionsSheet extends ConsumerWidget {
  const _ActionsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final st = ref.watch(recipeMatchProvider);
    final async = ref.watch(recipeActionsProvider);
    final posts = [
      for (final a in async.valueOrNull ?? const <Map<String, dynamic>>[])
        if (a['actionType'] == 'post' && a['id'] != null) a,
    ];
    final ids = {for (final a in posts) a['id'].toString()};
    // Gelöschte Aktion zählt als „keine".
    String? valid(String? id) => id != null && ids.contains(id) ? id : null;

    Widget section(String title, bool keep, String? selected) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text(title.toUpperCase(),
                  style: TextStyle(
                      color: context.appFgSub,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6)),
            ),
            _Option(
              label: l.recipeMatchActionNone,
              selected: selected == null,
              onTap: () => ref
                  .read(recipeMatchProvider.notifier)
                  .setAction(keep: keep, actionId: null),
            ),
            for (final a in posts)
              _Option(
                label: a['title']?.toString() ?? '',
                selected: selected == a['id'].toString(),
                onTap: () => ref
                    .read(recipeMatchProvider.notifier)
                    .setAction(keep: keep, actionId: a['id'].toString()),
              ),
          ],
        );

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SheetHeader(title: l.recipeActionsTitle),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: CollapsibleHint(
                text: l.recipeMatchActionsHint,
                prefsKey: 'hint_recipe_match_actions',
                dense: true,
              ),
            ),
            if (async.isLoading && posts.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (posts.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                    l.recipeMatchActionsNoPost(l.recipeActionTypePost),
                    style: TextStyle(color: context.appFgSub, fontSize: 14)),
              )
            else ...[
              section(l.recipeMatchActionOnKeep, true, valid(st.keepActionId)),
              section(
                  l.recipeMatchActionOnSkip, false, valid(st.skipActionId)),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Option(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
        dense: true,
        title: Text(label,
            style: TextStyle(
                color: context.appFg,
                fontSize: 15,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
        trailing: selected
            ? const Icon(Icons.check_rounded, color: AppTokens.accentDeep)
            : null,
        selected: selected,
        onTap: onTap,
      );
}
