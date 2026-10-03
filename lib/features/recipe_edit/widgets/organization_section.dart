import 'package:flutter/material.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/organizer_item.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/utils/search_match.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/deletable_chip.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Organization section (Tags & Kategorien)
// ─────────────────────────────────────────────────────────────────────────────

class OrganizationContent extends StatefulWidget {
  final List<TagSummary> allTags;
  final List<CategorySummary> allCategories;
  final List<TagSummary> selectedTags;
  final List<CategorySummary> selectedCategories;
  final void Function(TagSummary) onToggleTag;
  final void Function(CategorySummary) onToggleCategory;
  final VoidCallback? onCreateTag;
  final VoidCallback? onCreateCategory;
  final void Function(TagSummary)? onDeleteTag;
  final void Function(CategorySummary)? onDeleteCategory;
  final List<OrganizerItem> allTools;
  final List<RecipeTool> selectedTools;
  final void Function(OrganizerItem) onToggleTool;
  final VoidCallback onCreateTool;
  final void Function(OrganizerItem) onDeleteTool;
  final AppLocalizations l;

  const OrganizationContent({
    super.key,
    required this.allTags,
    required this.allCategories,
    required this.selectedTags,
    required this.selectedCategories,
    required this.onToggleTag,
    required this.onToggleCategory,
    required this.onCreateTag,
    required this.onCreateCategory,
    required this.onDeleteTag,
    required this.onDeleteCategory,
    required this.allTools,
    required this.selectedTools,
    required this.onToggleTool,
    required this.onCreateTool,
    required this.onDeleteTool,
    required this.l,
  });

  @override
  State<OrganizationContent> createState() => _OrganizationContentState();
}

class _OrganizationContentState extends State<OrganizationContent> {
  // EINE Lupe für alle drei Reihen: filtert Kategorien, Schlagworte und
  // Utensilien gleichzeitig. Die Suche blendet nur AUS — die Auswahl selbst
  // (Listen im Editor-State) bleibt unberührt, Nicht-Treffer bleiben also
  // ausgewählt und werden mitgespeichert.
  final _searchCtrl = TextEditingController();
  bool _searchOpen = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _closeSearch() {
    setState(() {
      _searchOpen = false;
      _searchCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final allTags = w.allTags;
    final allCategories = w.allCategories;
    final selectedTags = w.selectedTags;
    final selectedCategories = w.selectedCategories;
    final allTools = w.allTools;
    final selectedTools = w.selectedTools;
    final l = w.l;
    final primary = Theme.of(context).colorScheme.primary;
    final terms = searchTerms(_searchCtrl.text);
    bool visible(String name) {
      if (terms.isEmpty) return true;
      final n = normalizeForSearch(name);
      return terms.every(n.contains);
    }

    // allTags/allCategories sind aus der geladenen Rezeptliste abgeleitet — ein
    // GERADE neu erstellter (oder ausgewählter, aber noch nirgends verwendeter)
    // Tag/Kategorie ist dort noch nicht enthalten. Daher die Vereinigung aus
    // verfügbaren + ausgewählten anzeigen, sonst „verschwindet" ein neuer Tag.
    final tags = <TagSummary>[
      ...allTags,
      ...selectedTags.where((s) => !allTags.any((a) => a.id == s.id)),
    ];
    final categories = <CategorySummary>[
      ...allCategories,
      ...selectedCategories
          .where((s) => !allCategories.any((a) => a.id == s.id)),
    ];
    // Ausgewählte, aber (noch) nicht in der geladenen Liste (offline, gerade
    // angelegt) trotzdem zeigen.
    final tools = <OrganizerItem>[
      ...allTools,
      ...selectedTools
          .where((s) => !allTools.any((a) => a.id == s.id))
          .map((s) => OrganizerItem(id: s.id, name: s.name, slug: s.slug)),
    ];

    // Reines Chip-Visual (ohne Gesten) — DeletableChip übernimmt Tap/Long-Press.
    Widget chipVisual(String name, bool selected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? primary : context.appSurface2,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(name,
            style: TextStyle(
                color: selected ? Colors.white : context.appFg,
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
      );
    }

    // „+"-Chip am Ende jeder Reihe → legt einen neuen Tag/Kategorie an.
    Widget plusChip(VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primary.withValues(alpha: 0.5)),
          ),
          child: Icon(Icons.add_rounded, size: 16, color: primary),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_searchOpen)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: _searchCtrl,
                autofocus: true,
                onChanged: (_) => setState(() {}),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                style: TextStyle(color: context.appFg, fontSize: 14),
                decoration: InputDecoration(
                  hintText: l.search,
                  hintStyle: TextStyle(color: context.appFgTertiary),
                  prefixIcon:
                      Icon(Icons.search_rounded, color: context.appFgSub),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close_rounded, color: context.appFgSub),
                    tooltip:
                        MaterialLocalizations.of(context).closeButtonTooltip,
                    onPressed: _closeSearch,
                  ),
                  isDense: true,
                  filled: true,
                  fillColor: context.appSurface2,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTokens.rSm),
                    borderSide:
                        BorderSide(color: context.appSeparator, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTokens.rSm),
                    borderSide:
                        const BorderSide(color: AppTokens.accent, width: 1.5),
                  ),
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Text(l.categories,
                    style: TextStyle(color: context.appFgSub, fontSize: 12)),
              ),
              if (!_searchOpen)
                // Lupe: filtert alle drei Reihen (Kategorien, Schlagworte,
                // Utensilien).
                IconButton(
                  icon: Icon(Icons.search_rounded, color: primary, size: 20),
                  tooltip: l.search,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: () => setState(() => _searchOpen = true),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ...categories
                  .where((c) => visible(c.name))
                  .map((c) => DeletableChip(
                        onTap: () => w.onToggleCategory(c),
                        onDelete: w.onDeleteCategory == null
                            ? null
                            : () => w.onDeleteCategory!(c),
                        child: chipVisual(c.name,
                            selectedCategories.any((x) => x.id == c.id)),
                      )),
              if (w.onCreateCategory != null) plusChip(w.onCreateCategory!),
            ],
          ),
          const SizedBox(height: 12),
          Text(l.tags, style: TextStyle(color: context.appFgSub, fontSize: 12)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ...tags.where((t) => visible(t.name)).map((t) => DeletableChip(
                    onTap: () => w.onToggleTag(t),
                    onDelete:
                        w.onDeleteTag == null ? null : () => w.onDeleteTag!(t),
                    child: chipVisual(
                        t.name, selectedTags.any((x) => x.id == t.id)),
                  )),
              if (w.onCreateTag != null) plusChip(w.onCreateTag!),
            ],
          ),
          const SizedBox(height: 12),
          Text(l.toolsTitle,
              style: TextStyle(color: context.appFgSub, fontSize: 12)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ...tools.where((t) => visible(t.name)).map((t) => DeletableChip(
                    onTap: () => w.onToggleTool(t),
                    onDelete: () => w.onDeleteTool(t),
                    child: chipVisual(
                        t.name, selectedTools.any((x) => x.id == t.id)),
                  )),
              plusChip(w.onCreateTool),
            ],
          ),
        ],
      ),
    );
  }
}
