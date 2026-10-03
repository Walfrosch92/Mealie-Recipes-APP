import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart' show mealieErrorMessage;
import '../../../core/models/organizer_item.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/utils/search_match.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/read_only_banner.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../providers/organizers_provider.dart';

// ---------------------------------------------------------------------------
// Verwaltung von Kategorien / Schlagworten / Utensilien (Home-Kacheln).
// „+" legt an, Wischen nach links → Umbenennen/Löschen (wie die Kochbücher),
// Utensilien zusätzlich mit „im Haushalt vorhanden".
// ---------------------------------------------------------------------------

extension OrganizerKindUi on OrganizerKind {
  String title(AppLocalizations l) => switch (this) {
        OrganizerKind.category => l.categories,
        OrganizerKind.tag => l.tags,
        OrganizerKind.tool => l.toolsTitle,
      };

  String newTitle(AppLocalizations l) => switch (this) {
        OrganizerKind.category => l.newCategory,
        OrganizerKind.tag => l.newTag,
        OrganizerKind.tool => l.newTool,
      };

  IconData get icon => switch (this) {
        OrganizerKind.category => Icons.category_rounded,
        OrganizerKind.tag => Icons.sell_rounded,
        OrganizerKind.tool => Icons.kitchen_rounded,
      };

  /// Wie viele geladene Rezepte diesen Eintrag verwenden.
  int usage(List<RecipeDetail> recipes, String id) => switch (this) {
        OrganizerKind.category =>
          recipes.where((r) => r.recipeCategory.any((c) => c.id == id)).length,
        OrganizerKind.tag =>
          recipes.where((r) => r.tags.any((t) => t.id == id)).length,
        OrganizerKind.tool =>
          recipes.where((r) => r.tools.any((t) => t.id == id)).length,
      };
}

/// Namensdialog für Anlegen und Umbenennen. Liefert den getrimmten Namen oder
/// `null` (abgebrochen/leer).
Future<String?> showOrganizerNameDialog(BuildContext context,
    {required String title, String initial = '', String? confirmLabel}) async {
  final l = AppLocalizations.of(context)!;
  final ctrl = TextEditingController(text: initial);
  final result = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: ctx.appCard,
      title: Text(title),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(hintText: l.name),
        onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
        FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: Text(confirmLabel ?? l.add)),
      ],
    ),
  );
  ctrl.dispose();
  return (result == null || result.isEmpty) ? null : result;
}

class OrganizersScreen extends ConsumerStatefulWidget {
  final OrganizerKind kind;
  const OrganizersScreen({super.key, required this.kind});

  @override
  ConsumerState<OrganizersScreen> createState() => _OrganizersScreenState();
}

class _OrganizersScreenState extends ConsumerState<OrganizersScreen> {
  String _query = '';

  OrganizerKind get kind => widget.kind;

  void _error(String fallback, Object e) {
    if (!mounted) return;
    final detail = mealieErrorMessage(e);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(detail == null ? fallback : '$fallback: $detail')));
  }

  Future<void> _create() async {
    final l = AppLocalizations.of(context)!;
    final name =
        await showOrganizerNameDialog(context, title: kind.newTitle(l));
    if (name == null) return;
    try {
      await ref.read(organizersProvider(kind).notifier).create(name);
      HapticFeedback.lightImpact();
    } catch (e) {
      _error(l.createFailed, e);
    }
  }

  Future<void> _rename(OrganizerItem item) async {
    final l = AppLocalizations.of(context)!;
    final name = await showOrganizerNameDialog(context,
        title: l.renameAction, initial: item.name, confirmLabel: l.save);
    if (name == null || name == item.name) return;
    try {
      await ref.read(organizersProvider(kind).notifier).rename(item, name);
    } catch (e) {
      _error(l.saveFailed, e);
    }
  }

  Future<void> _delete(OrganizerItem item) async {
    final l = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: ctx.appCard,
            content: Text(l.deleteOrganizerConfirm(item.name),
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
      await ref.read(organizersProvider(kind).notifier).delete(item);
    } catch (e) {
      _error(l.deleteFailed, e);
    }
  }

  Future<void> _setOnHand(OrganizerItem item, String slug, bool v) async {
    final l = AppLocalizations.of(context)!;
    HapticFeedback.selectionClick();
    try {
      await ref
          .read(organizersProvider(kind).notifier)
          .setOnHand(item, slug, v);
    } catch (e) {
      _error(l.saveFailed, e);
    }
  }

  /// Kategorien/Schlagworte ändern braucht in Mealie `can_organize`;
  /// Utensilien prüft der Server nicht.
  bool get _mayEdit =>
      kind == OrganizerKind.tool ||
      ref.watch(userPermissionsProvider).mayOrganize;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final async = ref.watch(organizersProvider(kind));
    final mayEdit = _mayEdit;
    final recipes = ref.watch(recipesProvider).valueOrNull ?? const [];
    final householdSlug = kind == OrganizerKind.tool
        ? ref.watch(ownHouseholdSlugProvider).valueOrNull
        : null;

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Text(kind.title(l)),
        actions: [
          if (mayEdit)
            IconButton(
              icon: Icon(Icons.add_rounded, color: context.appFg),
              tooltip: kind.newTitle(l),
              onPressed: _create,
            ),
        ],
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
                        style: TextStyle(color: context.appFgSub),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => ref.invalidate(organizersProvider(kind)),
                      child: Text(l.retry),
                    ),
                  ],
                ),
              ),
            ),
            data: (items) {
              final terms = searchTerms(_query);
              final shown = terms.isEmpty
                  ? items
                  : items
                      .where((i) =>
                          terms.every(normalizeForSearch(i.name).contains))
                      .toList();
              return Column(
                children: [
                  if (!mayEdit) ReadOnlyBanner(text: l.organizeReadOnlyHint),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      style: TextStyle(color: context.appFg),
                      decoration: InputDecoration(
                        hintText: l.search,
                        prefixIcon:
                            Icon(Icons.search_rounded, color: context.appFgSub),
                        filled: true,
                        fillColor: context.appCard,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTokens.rSm),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () =>
                          ref.read(organizersProvider(kind).notifier).refresh(),
                      child: items.isEmpty
                          ? ListView(children: [
                              Padding(
                                padding: const EdgeInsets.all(32),
                                child: Text(l.organizerEmpty,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: context.appFgSub, fontSize: 15)),
                              ),
                            ])
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              itemCount: shown.length,
                              itemBuilder: (_, i) {
                                final item = shown[i];
                                return EntranceOnce(
                                  id: 'org-${kind.path}-${item.id}',
                                  index: i,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _OrganizerCard(
                                      kind: kind,
                                      item: item,
                                      usage: kind.usage(recipes, item.id),
                                      householdSlug: householdSlug,
                                      onRename:
                                          mayEdit ? () => _rename(item) : null,
                                      onDelete:
                                          mayEdit ? () => _delete(item) : null,
                                      onOnHand: householdSlug == null
                                          ? null
                                          : (v) => _setOnHand(
                                              item, householdSlug, v),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OrganizerCard extends StatelessWidget {
  final OrganizerKind kind;
  final OrganizerItem item;
  final int usage;
  final String? householdSlug;
  final VoidCallback? onRename;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onOnHand;

  const _OrganizerCard({
    required this.kind,
    required this.item,
    required this.usage,
    required this.householdSlug,
    required this.onRename,
    required this.onDelete,
    required this.onOnHand,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final onHand = householdSlug != null &&
        item.householdsWithTool.contains(householdSlug);
    return Slidable(
      key: ValueKey(item.id),
      enabled: onRename != null,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          SlidableAction(
            onPressed: (_) => onRename?.call(),
            backgroundColor: const Color(0xFF0A84FF),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: l.renameAction,
          ),
          SlidableAction(
            onPressed: (_) => onDelete?.call(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: l.delete,
          ),
        ],
      ),
      child: BounceTap(
        onTap: onRename,
        scale: 0.99,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: context.appCard,
            borderRadius: BorderRadius.circular(AppTokens.rMd),
            border: Border.all(color: context.appSeparator, width: 1),
            boxShadow: context.appShadowSm,
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: AppTokens.accentGradient,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(kind.icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: TextStyle(
                            color: context.appFg,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(l.organizerRecipeCount(usage),
                        style:
                            TextStyle(color: context.appFgSub, fontSize: 12)),
                  ],
                ),
              ),
              if (onOnHand != null) ...[
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch.adaptive(
                      value: onHand,
                      activeTrackColor: AppTokens.accent,
                      onChanged: onOnHand,
                    ),
                    Text(l.toolOnHand,
                        style: TextStyle(
                            color: context.appFgTertiary, fontSize: 10)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
