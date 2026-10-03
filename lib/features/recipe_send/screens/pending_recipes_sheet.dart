import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../shared/theme/app_colors.dart';
import '../../cooking_mode/providers/cooking_session_provider.dart';
import '../services/recipe_send_service.dart';

// ---------------------------------------------------------------------------
// PendingRecipesSheet — 1:1 Port von Swifts PendingRecipesSheet.swift.
//
// Wird in app.dart per `ref.listen(pendingRecipesProvider)` automatisch via
// MaterialPageRoute(fullscreenDialog: true) angezeigt sobald die erste
// neue Lieferung reinkommt. Die Sheet selbst watcht den Provider live —
// kommen weitere Rezepte währen sie offen ist, tauchen sie sofort in der
// Liste auf (mit Default „selected" wie in iOS).
//
// Aktionen:
//   • Cancel/„Später" oben links  → Provider clearen + Sheet poppen
//   • „Kochmodus öffnen"          → für jedes ausgewählte Recipe eine
//     CookingSession starten, dann zur Cooking-Mode-Route des ersten
//     ausgewählten navigieren. Andere Sessions tauchen automatisch als
//     Karten in der Cooking-Mode-Sessions-Bar auf.
// ---------------------------------------------------------------------------

class PendingRecipesSheet extends ConsumerStatefulWidget {
  const PendingRecipesSheet({super.key});

  @override
  ConsumerState<PendingRecipesSheet> createState() =>
      _PendingRecipesSheetState();
}

class _PendingRecipesSheetState extends ConsumerState<PendingRecipesSheet> {
  /// Recipe-IDs, die der User gerade ausgewählt hat. Standard: alle.
  /// Tracking per recipe.id statt per Listen-Index, damit Insertions
  /// (live-arrivierende Recipes) die User-Auswahl nicht durcheinanderwerfen.
  Set<String> _selectedIds = const {};
  bool _initialized = false;

  void _syncDefaults(List<PendingRecipe> incoming) {
    if (_initialized) {
      // Nur die neu hinzugekommenen Recipes per Default selektieren —
      // bestehende Toggles des Users bleiben respektiert.
      final knownIds = _selectedIds;
      final newOnes = incoming
          .where((p) => !knownIds.contains(p.recipe.id))
          .map((p) => p.recipe.id);
      if (newOnes.isNotEmpty) {
        _selectedIds = {..._selectedIds, ...newOnes};
      }
      // IDs die nicht mehr in der Liste sind (z.B. Provider cleared)
      // aus der Auswahl entfernen.
      final allCurrentIds = incoming.map((p) => p.recipe.id).toSet();
      _selectedIds = _selectedIds.where(allCurrentIds.contains).toSet();
      return;
    }
    _selectedIds = incoming.map((p) => p.recipe.id).toSet();
    _initialized = true;
  }

  String _senderLabel(List<PendingRecipe> recipes, AppLocalizations l) {
    final names = recipes
        .map((p) => p.senderName)
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    if (names.isEmpty) return '';
    return l.pendingRecipesFrom(names.join(', '));
  }

  void _toggle(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _dismiss() {
    // Komplette pending-Liste clearen damit der App-Listener nicht direkt
    // wieder feuert (er triggert auf transition empty→nonempty).
    ref.read(pendingRecipesProvider.notifier).clear();
    if (context.canPop()) context.pop();
  }

  void _openInCookingMode(List<PendingRecipe> all) {
    final selected =
        all.where((p) => _selectedIds.contains(p.recipe.id)).toList();
    if (selected.isEmpty) return;
    final sessionNotifier = ref.read(cookingSessionsProvider.notifier);
    for (final p in selected) {
      sessionNotifier.startSession(p.recipe);
    }
    // Provider clearen damit das Sheet nicht direkt nach dem Pop wieder
    // hochpoppt (Re-Trigger via ref.listen-Transition).
    ref.read(pendingRecipesProvider.notifier).clear();
    if (context.canPop()) context.pop();
    // Auf das erste ausgewählte Recipe navigieren — die anderen liegen
    // schon als Sessions in cookingSessionsProvider und tauchen unten in
    // der Sessions-Bar des CookingModeScreen automatisch auf.
    final first = selected.first.recipe;
    context.push('/cooking/${first.id}');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final recipes = ref.watch(pendingRecipesProvider);
    _syncDefaults(recipes);
    final senderLabel = _senderLabel(recipes, l);
    final hasSelection = _selectedIds.isNotEmpty;
    final accent = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Text(l.pendingRecipesTitle),
        leading: TextButton(
          onPressed: _dismiss,
          child: Text(l.pendingRecipesLater,
              style: TextStyle(color: context.appFgSub)),
        ),
        leadingWidth: 100,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header: Paperplane-Icon + Sender-Label.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                children: [
                  Icon(Icons.send_rounded, color: accent, size: 52),
                  if (senderLabel.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(senderLabel,
                        style:
                            TextStyle(color: context.appFgSub, fontSize: 14)),
                  ],
                ],
              ),
            ),
            Divider(color: context.appSeparator, height: 1),
            // Recipe-Liste mit runden Checkbox-Icons.
            Expanded(
              child: recipes.isEmpty
                  ? const SizedBox.shrink()
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: recipes.length,
                      separatorBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(left: 54),
                        child: Divider(color: context.appSeparator, height: 1),
                      ),
                      itemBuilder: (ctx, i) {
                        final p = recipes[i];
                        final selected = _selectedIds.contains(p.recipe.id);
                        return InkWell(
                          onTap: () => _toggle(p.recipe.id),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            child: Row(
                              children: [
                                Icon(
                                  selected
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  size: 26,
                                  color: selected ? accent : context.appFgSub,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(p.recipe.name,
                                          style: TextStyle(
                                              color: context.appFg,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500)),
                                      if (p.senderName.isNotEmpty) ...[
                                        const SizedBox(height: 3),
                                        Text(p.senderName,
                                            style: TextStyle(
                                                color: context.appFgSub,
                                                fontSize: 12)),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Divider(color: context.appSeparator, height: 1),
            // Action: „Kochmodus öffnen" — disabled wenn nichts ausgewählt
            // ist (mirror Swift `.disabled(selectedIds.isEmpty)`).
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed:
                      hasSelection ? () => _openInCookingMode(recipes) : null,
                  icon: const Icon(Icons.local_fire_department_rounded),
                  label: Text(l.pendingRecipesOpenCooking),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9F0A),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: context.appSurface2,
                    disabledForegroundColor: context.appFgSub,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
