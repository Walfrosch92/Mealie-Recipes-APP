import '../../../core/utils/platform_features.dart';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/models/shopping_item.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/utils/ingredient_display.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/autocomplete_field.dart';
import '../../../shared/widgets/deletable_chip.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/liquid_glass.dart';
import '../../../shared/theme/app_colors.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../providers/foods_units_provider.dart';
import '../providers/pending_changes_provider.dart';
import '../providers/shopping_list_provider.dart';
import '../providers/shopping_lists_provider.dart';
import '../widgets/shopping_list_switch_sheet.dart';
import 'google_tasks_import_screen.dart';
import 'reminders_import_screen.dart';
import 'sync_changes_sheet.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  final _ctrl = TextEditingController();
  final _focusNode = FocusNode();
  // Exakt-Modus: eigene Felder für Menge und Einheit vor dem Artikelnamen.
  final _qtyCtrl = TextEditingController();
  final _unitCtrl = TextEditingController();
  final _qtyFocus = FocusNode();
  final _unitFocus = FocusNode();
  ShoppingLabel? _selectedLabel;
  bool _inputFocused = false;

  @override
  void initState() {
    super.initState();
    // Fokus über ALLE Eingabefelder verfolgen — der „Einkauf abschließen"-
    // Button ist nur sichtbar, wenn keins davon fokussiert ist.
    _focusNode.addListener(_syncInputFocus);
    _qtyFocus.addListener(_syncInputFocus);
    _unitFocus.addListener(_syncInputFocus);
    // Controller-Listener: ohne den blieb der Plus-Button beim Tippen grau
    // (Issue 4a) — das Build-Bracket evaluiert ctrl.text einmal, und ohne
    // Notifier rebuildet die _InputBar erst beim nächsten anderen setState.
    _ctrl.addListener(() => setState(() {}));
    // Beim Öffnen des Screens einmal still vom Server nachladen — vorher
    // zeigte der Screen nur den zuletzt geladenen (ggf. veralteten) Stand
    // und man musste manuell den Reload-Button/Pull-to-Refresh benutzen.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(shoppingListProvider.notifier).refreshOnOpen();
    });
  }

  void _syncInputFocus() {
    setState(() => _inputFocused =
        _focusNode.hasFocus || _qtyFocus.hasFocus || _unitFocus.hasFocus);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _qtyCtrl.dispose();
    _unitCtrl.dispose();
    _focusNode.dispose();
    _qtyFocus.dispose();
    _unitFocus.dispose();
    super.dispose();
  }

  void _addItem() {
    final note = _ctrl.text.trim();
    if (note.isEmpty) return;

    final exact =
        ref.read(settingsProvider).valueOrNull?.addExactQuantities ?? false;
    double qty = 1;
    ShoppingUnit? unit;
    String? unitText;
    ShoppingFood? food;
    if (exact) {
      // Menge: Komma-Dezimalen tolerieren; leer/unparsebar → 1.
      final rawQty = _qtyCtrl.text.trim().replaceAll(',', '.');
      if (rawQty.isNotEmpty) qty = double.tryParse(rawQty) ?? 1;
      // Einheit gegen den Server-Katalog auflösen (Name/Abkürzung/Mehr-
      // sprach-Token) → strukturierter Add; ohne Treffer als Freitext in
      // den Artikeltext einbetten (Konvention von addIngredient).
      final typedUnit = _unitCtrl.text.trim();
      if (typedUnit.isNotEmpty) {
        unit = resolveUnitByName(
            ref.read(unitsCatalogProvider).valueOrNull ?? const [], typedUnit);
        if (unit == null) unitText = typedUnit;
      }
      // Exakter Namenstreffer im Foods-Katalog → echtes Food-Item wie ein
      // Webapp-Add (foodId + isFood, Label/Kategorie des Foods greift).
      // Kein Treffer → addItem legt das Food serverseitig neu an.
      food = resolveFoodByName(
          ref.read(foodsCatalogProvider).valueOrNull ?? const [], note);
    }

    // Lehnt der Server das Item ab (kein Netzwerkfehler, z. B. HTTP 422),
    // wirft addItem jetzt — das wurde früher still verschluckt und der
    // Artikel fehlte kommentarlos in Liste UND Webapp.
    ref
        .read(shoppingListProvider.notifier)
        .addItem(
          note: note,
          label: _selectedLabel,
          quantity: qty,
          unit: unit,
          unitText: unitText,
          food: food,
        )
        .catchError((Object e) {
      if (!mounted) return;
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l.createFailed}: $note')),
      );
    });
    _ctrl.clear();
    _qtyCtrl.clear();
    _unitCtrl.clear();
    _selectedLabel = null;
    // Issue 4c: Keyboard schließen damit der „Einkauf abschließen"-Button
    // wieder erscheint (der ist nur sichtbar wenn !inputFocused).
    _focusNode.unfocus();
    _qtyFocus.unfocus();
    _unitFocus.unfocus();
    setState(() {});
    // Success feedback
    HapticFeedback.lightImpact();
  }

  void _showArchiveConfirm(BuildContext context, AppLocalizations l) {
    showDialog(
      context: context,
      // Dialog liegt auf dem ROOT-Navigator — Pops müssen den Dialog-Context
      // nutzen, sonst poppt der Branch-Navigator die Tab-Seite selbst.
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: context.appCard,
        title: Text(l.completeShoppingTitle,
            style: TextStyle(color: context.appFg)),
        content: Text(l.completeShoppingMessage,
            style: TextStyle(color: context.appFgSub)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogCtx), child: Text(l.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogCtx);
              // archiveCheckedItems already removes the items from local
              // state optimistically — no need for a full refresh after.
              await ref
                  .read(shoppingListProvider.notifier)
                  .archiveCheckedItems();
            },
            child: Text(l.done),
          ),
        ],
      ),
    );
  }

  void _openSyncSheet(BuildContext context) {
    // rootNavigator: sonst landet die Seite im Tab-Branch-Navigator und
    // liegt hinter der fixen GlassTabBar.
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const SyncChangesSheet(),
      ),
    );
  }

  PopupMenuItem<String> _menuItem(
          BuildContext context, String value, IconData icon, String label) =>
      PopupMenuItem(
        value: value,
        child: Row(children: [
          Icon(icon, size: 20, color: context.appFg),
          const SizedBox(width: 12),
          Flexible(child: Text(label)),
        ]),
      );

  Future<void> _openTaskImport(BuildContext context) async {
    // iOS → Apple Reminders, Android → Google Tasks. The original Swift app
    // used Reminders, so iOS users get the same flow they're used to.
    final Widget screen = Platform.isIOS
        ? const RemindersImportScreen()
        : const GoogleTasksImportScreen();
    final imported = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
    if (imported != null && imported > 0 && mounted) {
      await ref.read(shoppingListProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final listAsync = ref.watch(shoppingListProvider);
    final labelsAsync = ref.watch(shoppingLabelsProvider);
    final settings = ref.watch(settingsProvider).valueOrNull;
    final collapsed = settings?.collapsedShoppingCategories ?? [];
    final labels = labelsAsync.valueOrNull ?? [];
    final isOffline = ref.watch(shoppingOfflineProvider);
    final exactQuantities = settings?.addExactQuantities ?? false;
    // Kataloge für die Autovervollständigung (cache-first, offline-fähig).
    // Foods in BEIDEN Modi (Artikelname), Einheiten nur im Exakt-Modus.
    final foodOptions =
        (ref.watch(foodsCatalogProvider).valueOrNull ?? const <ShoppingFood>[])
            .map((f) => f.name ?? '')
            .where((n) => n.isNotEmpty)
            .toList();
    final unitOptions = exactQuantities
        ? ((ref.watch(unitsCatalogProvider).valueOrNull ??
                const <ShoppingUnit>[])
            .map((u) => u.name ?? '')
            .where((n) => n.isNotEmpty)
            .toList())
        : const <String>[];
    // Noch nicht zum Server synchronisierte Adds (Offline-Dummies) — deren
    // Zeilen bekommen ein Cloud-Badge, damit sichtbar ist, dass sie in der
    // Webapp noch fehlen. `watch`: nach dem Auto-Sync verschwindet das Badge.
    final pendingAddIds =
        ref.watch(pendingShoppingChangesProvider).adds.map((a) => a.id).toSet();

    // 1:1 zu Swifts `.onReceive(NotificationCenter.publisher(for: .pending-
    // ShoppingSync))`: bei jedem Tick des Triggers UND vorhandenen pending
    // changes das Sync-Sheet öffnen.
    ref.listen<int>(shoppingSyncTriggerProvider, (prev, next) {
      if (prev == next) return;
      final pending = ref.read(pendingShoppingChangesProvider);
      if (!pending.hasChanges) return;
      _openSyncSheet(context);
    });

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Row(
          children: [
            // Name der aktiven Liste statt „Einkaufsliste" (Emoji bleibt).
            Flexible(
              child: Text(
                shoppingTitleWithName(
                    l.shoppingList, ref.watch(activeShoppingListNameProvider)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isOffline) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(l.offlineBadge,
                    style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: context.appFg),
            onPressed: () async {
              // Kataloge mit anstoßen (cache-first: still im Hintergrund),
              // damit neue Webapp-Foods/-Einheiten als Vorschläge auftauchen.
              ref.invalidate(foodsCatalogProvider);
              ref.invalidate(unitsCatalogProvider);
              await ref.read(shoppingLabelsProvider.notifier).reload();
              await ref.read(shoppingListProvider.notifier).refresh();
            },
          ),
          // ⋮: Liste wechseln, archivierte Listen, Import (Apple
          // Erinnerungen bzw. Google Tasks). „Neu laden" bleibt draußen.
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: context.appFg),
            color: context.appCard,
            onSelected: (v) {
              switch (v) {
                case 'switch':
                  showShoppingListSwitchSheet(context);
                case 'archived':
                  context.push('/shopping/archived');
                case 'import':
                  _openTaskImport(context);
              }
            },
            itemBuilder: (_) => [
              _menuItem(context, 'switch', Icons.swap_horiz_rounded,
                  l.switchListTitle),
              // Menü hat eigene Symbole → führendes Emoji des Titels weg.
              _menuItem(context, 'archived', Icons.inventory_2_outlined,
                  l.archivedLists.replaceFirst(RegExp(r'^\S+\s+'), '')),
              // Apple Erinnerungen (iOS) / Google Tasks (Android) — unter
              // Windows nicht verfügbar.
              if (PlatformFeatures.taskImport)
                _menuItem(context, 'import', Icons.move_to_inbox_outlined,
                    l.importMenuAction),
            ],
          ),
        ],
      ),
      body: WithCookingModeFAB(
        bottomInset: GlassTabBar.height + 24,
        child: SafeArea(
          top: false,
          child: listAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(e.toString(), style: TextStyle(color: context.appFgSub)),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () =>
                        ref.read(shoppingListProvider.notifier).refresh(),
                    child: Text(l.retry),
                  ),
                ],
              ),
            ),
            data: (items) => Column(
              children: [
                // Item list
                Expanded(
                  child: items.isEmpty
                      ? _ShoppingDoneEmptyState(l: l)
                      : RefreshIndicator(
                          onRefresh: () async {
                            ref.invalidate(foodsCatalogProvider);
                            ref.invalidate(unitsCatalogProvider);
                            await ref
                                .read(shoppingLabelsProvider.notifier)
                                .reload();
                            await ref
                                .read(shoppingListProvider.notifier)
                                .refresh();
                          },
                          child: _ShoppingItemList(
                            items: items,
                            labels: labels,
                            pendingAddIds: pendingAddIds,
                            collapsed: collapsed,
                            categoryOrder:
                                settings?.shoppingCategoryOrder ?? [],
                            exactQuantities:
                                settings?.addExactQuantities ?? false,
                            onToggle: (item) => ref
                                .read(shoppingListProvider.notifier)
                                .toggleChecked(item),
                            onQuantityChange:
                                (item, qty, {bool clearUnit = false}) => ref
                                    .read(shoppingListProvider.notifier)
                                    .updateQuantity(item, qty,
                                        clearUnit: clearUnit),
                            onDelete: (id) => ref
                                .read(shoppingListProvider.notifier)
                                .deleteItem(id),
                            onCategoryChange: (item, label) => ref
                                .read(shoppingListProvider.notifier)
                                .updateItemCategory(item, label),
                            onEdit: (item, note, qty, label, clearLabel) => ref
                                .read(shoppingListProvider.notifier)
                                .editItem(item,
                                    note: note,
                                    quantity: qty,
                                    label: label,
                                    clearLabel: clearLabel),
                            onToggleCollapse: (category) {
                              final s = settings;
                              if (s == null) return;
                              final newCollapsed = List<String>.from(collapsed);
                              if (newCollapsed.contains(category)) {
                                newCollapsed.remove(category);
                              } else {
                                newCollapsed.add(category);
                              }
                              ref.read(settingsProvider.notifier).save(
                                  s.copyWith(
                                      collapsedShoppingCategories:
                                          newCollapsed));
                            },
                            onReorderCategories: (newOrder) {
                              final s = settings;
                              if (s == null) return;
                              // Keep positions of categories not currently shown.
                              final merged = <String>[
                                ...newOrder,
                                ...s.shoppingCategoryOrder
                                    .where((c) => !newOrder.contains(c)),
                              ];
                              ref.read(settingsProvider.notifier).save(
                                  s.copyWith(shoppingCategoryOrder: merged));
                              // Mealie speichert die Reihenfolge pro Liste —
                              // dort mitziehen (Webapp zeigt sie dann genauso).
                              ref
                                  .read(shoppingListsProvider.notifier)
                                  .pushOrderByNames(s.shoppingListId, merged);
                            },
                            availableLabels: labels,
                          ),
                        ),
                ),

                // Bottom input bar — mirrors iOS inputSection
                _InputBar(
                  ctrl: _ctrl,
                  focusNode: _focusNode,
                  qtyCtrl: _qtyCtrl,
                  unitCtrl: _unitCtrl,
                  qtyFocus: _qtyFocus,
                  unitFocus: _unitFocus,
                  exactQuantities: exactQuantities,
                  foodOptions: foodOptions,
                  unitOptions: unitOptions,
                  selectedLabel: _selectedLabel,
                  labels: labels,
                  inputFocused: _inputFocused,
                  onAdd: _addItem,
                  onLabelSelected: (label) =>
                      setState(() => _selectedLabel = label),
                  onCreateLabel: () async {
                    final label =
                        await showCreateShoppingLabelDialog(context, ref);
                    if (label != null && context.mounted) {
                      setState(() => _selectedLabel = label);
                    }
                  },
                  onDeleteLabel: (label) async {
                    await deleteShoppingLabelWithConfirm(context, ref, label);
                    if (context.mounted && _selectedLabel?.id == label.id) {
                      setState(() => _selectedLabel = null);
                    }
                  },
                  onArchive: () => _showArchiveConfirm(context, l),
                  l: l,
                ),

                // Die GlassTabBar schwebt jetzt als Shell-Overlay (app.dart) —
                // die Eingabezeile braucht deren Höhe als Abstand, sonst läge sie
                // hinter dem Glas. Bei offener Tastatur entfällt der Abstand
                // (die Leiste liegt dann eh hinter der Tastatur), damit die
                // Eingabezeile direkt über der Tastatur sitzt wie zuvor.
                SizedBox(
                    height: MediaQuery.viewInsetsOf(context).bottom > 0
                        ? 0
                        : GlassTabBar.height),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state — mirrors iOS EmptyListView (green seal + "Einkauf abgeschlossen")
// ---------------------------------------------------------------------------

class _ShoppingDoneEmptyState extends StatelessWidget {
  final AppLocalizations l;
  const _ShoppingDoneEmptyState({required this.l});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF7BD88F), Color(0xFF34A853)],
              ),
              boxShadow: [
                BoxShadow(
                    color: Color(0x4D34A853),
                    blurRadius: 24,
                    offset: Offset(0, 10))
              ],
            ),
            child:
                const Icon(Icons.check_rounded, size: 52, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(l.shoppingCompleted,
              style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: context.appFg,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3)),
          const SizedBox(height: 8),
          Text(l.shoppingCompletedSubtitle,
              style: TextStyle(color: context.appFgSub, fontSize: 15)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Item list grouped by category
// ---------------------------------------------------------------------------

// Edit callback: (item, note, quantity, label, clearLabel)
typedef ShoppingItemEdit = void Function(ShoppingItem item, String note,
    double quantity, ShoppingLabel? label, bool clearLabel);

class _ShoppingItemList extends StatelessWidget {
  final List<ShoppingItem> items;
  final List<ShoppingLabel> labels;
  final Set<String> pendingAddIds;
  final List<String> collapsed;
  final List<String> categoryOrder;
  final bool exactQuantities;
  final ValueChanged<ShoppingItem> onToggle;
  final void Function(ShoppingItem, double, {bool clearUnit}) onQuantityChange;
  final ValueChanged<String> onDelete;
  final void Function(ShoppingItem, ShoppingLabel?) onCategoryChange;
  final ShoppingItemEdit onEdit;
  final ValueChanged<String> onToggleCollapse;
  final ValueChanged<List<String>> onReorderCategories;
  final List<ShoppingLabel> availableLabels;

  const _ShoppingItemList({
    required this.items,
    required this.labels,
    required this.pendingAddIds,
    required this.collapsed,
    required this.categoryOrder,
    required this.exactQuantities,
    required this.onToggle,
    required this.onQuantityChange,
    required this.onDelete,
    required this.onCategoryChange,
    required this.onEdit,
    required this.onToggleCollapse,
    required this.onReorderCategories,
    required this.availableLabels,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final unchecked = items.where((i) => !i.checked).toList();
    final checked = items.where((i) => i.checked).toList();

    // Group unchecked by label
    final groups = <String, List<ShoppingItem>>{};
    for (final item in unchecked) {
      final key = item.label?.name ?? l.unlabeledCategory;
      groups.putIfAbsent(key, () => []).add(item);
    }

    // Sort groups: user-defined order first (persisted locally), then fall
    // back to the server label order for any category not yet positioned.
    final labelNames = labels.map((l) => l.name).toList();
    final sortedKeys = groups.keys.toList()
      ..sort((a, b) {
        final oa = categoryOrder.indexOf(a);
        final ob = categoryOrder.indexOf(b);
        if (oa != -1 && ob != -1) return oa.compareTo(ob);
        if (oa != -1) return -1;
        if (ob != -1) return 1;
        final ia = labelNames.indexOf(a);
        final ib = labelNames.indexOf(b);
        if (ia == -1 && ib == -1) return a.compareTo(b);
        if (ia == -1) return 1;
        if (ib == -1) return -1;
        return ia.compareTo(ib);
      });

    Widget buildSection(String category, int index) {
      final groupItems = (groups[category] ?? [])
        ..sort((a, b) => a.displayName.compareTo(b.displayName));
      final label = labels.firstWhere((l) => l.name == category, orElse: () {
        return const ShoppingLabel(id: '', name: '');
      });
      // Always prefer the server label color (stable & consistent app-wide);
      // fall back to a deterministic-by-name color only when none is set.
      final labelColor = shoppingCategoryColor(label.color, category);
      final isCollapsed = collapsed.contains(category);

      return _CategorySection(
        key: ValueKey('shopping_cat_$category'),
        dragIndex: index,
        category: category,
        count: groupItems.length,
        labelColor: labelColor,
        isCollapsed: isCollapsed,
        items: groupItems,
        pendingAddIds: pendingAddIds,
        availableLabels: availableLabels,
        exactQuantities: exactQuantities,
        onToggleCollapse: () => onToggleCollapse(category),
        onToggle: onToggle,
        onQuantityChange: onQuantityChange,
        onDelete: onDelete,
        onCategoryChange: onCategoryChange,
        onEdit: onEdit,
      );
    }

    // Completed items section — pinned, non-reorderable footer.
    Widget? completedFooter;
    if (checked.isNotEmpty) {
      final completedLabel = l.completedItems;
      final isCollapsed = collapsed.contains(completedLabel);
      final sortedChecked = checked
        ..sort((a, b) => a.displayName.compareTo(b.displayName));
      completedFooter = _CompletedSection(
        items: sortedChecked,
        isCollapsed: isCollapsed,
        label: completedLabel,
        exactQuantities: exactQuantities,
        onToggleCollapse: () => onToggleCollapse(completedLabel),
        onToggle: onToggle,
        onDelete: onDelete,
      );
    }

    // Long-press to drag a category header and reorder; the new order is
    // persisted locally by the parent.
    return ReorderableListView(
      buildDefaultDragHandles: false,
      // Platz für die schwebende GlassTabBar (der System-Inset wird bereits vom
      // umgebenden SafeArea(top:false) konsumiert) — sonst lägen die letzten
      // Artikel / der „Erledigt"-Footer hinter dem Balken.
      // Große Anzeige (Windows/macOS): zentrierte Spalte statt Fensterbreite.
      padding: EdgeInsets.only(
        left: LargeScreen.inset(context),
        right: LargeScreen.inset(context),
        bottom: GlassTabBar.height + 24,
      ),
      // Erledigt-Bereich + „verknüpfte Rezepte" (wie die Webapp unten).
      footer: Column(mainAxisSize: MainAxisSize.min, children: [
        if (completedFooter != null) completedFooter,
        const _LinkedRecipesSection(),
      ]),
      onReorder: (oldIndex, newIndex) {
        final keys = List<String>.from(sortedKeys);
        if (newIndex > oldIndex) newIndex -= 1;
        final moved = keys.removeAt(oldIndex);
        keys.insert(newIndex, moved);
        onReorderCategories(keys);
      },
      children: [
        for (int i = 0; i < sortedKeys.length; i++)
          buildSection(sortedKeys[i], i),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared category color resolution — server hex first (consistent & stable),
// deterministic-by-name fallback only when the server provides no color.
// Used by the category header, input-bar chips and the category picker so a
// given label always renders the same color everywhere.
// ---------------------------------------------------------------------------

Color shoppingCategoryColor(String? hex, String name) {
  if (hex != null && hex.trim().isNotEmpty) {
    try {
      final h = hex.replaceAll('#', '').trim();
      final v = int.parse(h.length == 6 ? 'FF$h' : h, radix: 16);
      return Color(v);
    } catch (_) {/* fall through */}
  }
  const palette = [
    Colors.teal,
    Colors.indigo,
    Colors.orange,
    Colors.purple,
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
  ];
  return palette[name.hashCode.abs() % palette.length];
}

// ---------------------------------------------------------------------------
// Category section with collapsible header
// ---------------------------------------------------------------------------

class _CategorySection extends StatelessWidget {
  final String category;
  final int dragIndex;
  final int count;
  final Color labelColor;
  final bool isCollapsed;
  final List<ShoppingItem> items;
  final Set<String> pendingAddIds;
  final List<ShoppingLabel> availableLabels;
  final bool exactQuantities;
  final VoidCallback onToggleCollapse;
  final ValueChanged<ShoppingItem> onToggle;
  final void Function(ShoppingItem, double, {bool clearUnit}) onQuantityChange;
  final ValueChanged<String> onDelete;
  final void Function(ShoppingItem, ShoppingLabel?) onCategoryChange;
  final ShoppingItemEdit onEdit;

  const _CategorySection({
    super.key,
    required this.category,
    required this.dragIndex,
    required this.count,
    required this.labelColor,
    required this.isCollapsed,
    required this.items,
    required this.pendingAddIds,
    required this.availableLabels,
    required this.exactQuantities,
    required this.onToggleCollapse,
    required this.onToggle,
    required this.onQuantityChange,
    required this.onDelete,
    required this.onCategoryChange,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        _brightness(labelColor) < 0.5 ? Colors.white : Colors.black87;

    return Column(
      children: [
        // Category header chip — mirrors iOS categoryHeaderChip.
        // Long-press starts a drag to reorder categories (order persisted).
        ReorderableDelayedDragStartListener(
          index: dragIndex,
          child: InkWell(
            onTap: onToggleCollapse,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              height: 50,
              decoration: BoxDecoration(
                color: labelColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: labelColor.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.drag_indicator,
                      color: textColor.withValues(alpha: 0.7), size: 18),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(category,
                        style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: textColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            fontSize: 16)),
                  ),
                  if (count > 0)
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: textColor.withValues(alpha: 0.15),
                      ),
                      child: Center(
                        child: Text('$count',
                            style: TextStyle(
                                color: textColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  Icon(
                    isCollapsed
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: textColor.withValues(alpha: 0.8),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isCollapsed)
          ...items.asMap().entries.map((e) => EntranceOnce(
                id: 'shop-${e.value.id}',
                index: e.key,
                child: _ItemRow(
                  item: e.value,
                  isPendingAdd: pendingAddIds.contains(e.value.id),
                  availableLabels: availableLabels,
                  exactQuantities: exactQuantities,
                  onToggle: onToggle,
                  onQuantityChange: onQuantityChange,
                  onDelete: onDelete,
                  onCategoryChange: onCategoryChange,
                  onEdit: onEdit,
                ),
              )),
      ],
    );
  }

  static double _brightness(Color c) {
    return 0.299 * c.r + 0.587 * c.g + 0.114 * c.b;
  }
}

// ---------------------------------------------------------------------------
// Completed items section
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// „Verknüpfte Rezepte" — wie die Webapp (shopping-lists/[id].vue): Rezepte,
// deren Zutaten auf der Liste stehen, mit Anzahl, „−" (Zutaten des Rezepts
// wieder abziehen) und „+" (nochmal hinzufügen). Quelle: recipeReferences
// der aktiven Liste (shoppingListsProvider).
// ---------------------------------------------------------------------------

class _LinkedRecipesSection extends ConsumerStatefulWidget {
  const _LinkedRecipesSection();

  @override
  ConsumerState<_LinkedRecipesSection> createState() =>
      _LinkedRecipesSectionState();
}

class _LinkedRecipesSectionState extends ConsumerState<_LinkedRecipesSection> {
  bool _expanded = false;
  String? _busyRecipeId;

  Future<void> _run(String recipeId, Future<void> Function() action) async {
    if (_busyRecipeId != null) return;
    setState(() => _busyRecipeId = recipeId);
    try {
      await action();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.saveFailed)));
      }
    } finally {
      if (mounted) setState(() => _busyRecipeId = null);
    }
  }

  Future<void> _addAgain(String listId, String recipeId) async {
    final notifier = ref.read(shoppingListProvider.notifier);
    RecipeDetail? recipe;
    for (final r in ref.read(recipesProvider).valueOrNull ?? const []) {
      if (r.id == recipeId) recipe = r;
    }
    recipe ??= await ref.read(apiServiceProvider).fetchRecipeDetail(recipeId);
    // Wie Mealies „+": vorrätige Zutaten auslassen.
    final onHand = await notifier.onHandChecker();
    await notifier.addRecipe(
      shoppingListId: listId,
      recipe: recipe,
      multiplier: 1,
      skipIf: onHand,
    );
    await notifier.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final listId = ref.watch(
        settingsProvider.select((s) => s.valueOrNull?.shoppingListId ?? ''));
    Map<String, dynamic>? list;
    for (final m in ref.watch(shoppingListsProvider).valueOrNull ?? const []) {
      if (m['id'] == listId) list = m;
    }
    final refs = [
      for (final r in (list?['recipeReferences'] as List?) ?? const [])
        if (r is Map && (r['recipeId']?.toString() ?? '').isNotEmpty)
          r.cast<String, dynamic>(),
    ];
    if (refs.isEmpty) return const SizedBox.shrink();
    final notifier = ref.read(shoppingListProvider.notifier);

    String fmt(num? q) {
      final v = (q ?? 1).toDouble();
      return v == v.roundToDouble() ? '${v.toInt()}' : v.toStringAsFixed(1);
    }

    return Column(children: [
      InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.appSeparator, width: 1),
          ),
          child: Row(children: [
            Icon(Icons.menu_book_rounded, size: 18, color: context.appFgSub),
            const SizedBox(width: 8),
            Expanded(
              child: Text(l.linkedRecipesCount(refs.length),
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: context.appFg,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      fontSize: 16)),
            ),
            Icon(
                _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: context.appFgSub,
                size: 20),
          ]),
        ),
      ),
      if (_expanded)
        for (final r in refs)
          Builder(builder: (context) {
            final recipeId = r['recipeId'].toString();
            final recipe = (r['recipe'] as Map?)?.cast<String, dynamic>();
            final name = (recipe?['name'] as String?)?.trim() ?? '';
            final busy = _busyRecipeId == recipeId;
            return ListTile(
              contentPadding: const EdgeInsets.only(left: 22, right: 8),
              title: Text(name.isEmpty ? '…' : name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: context.appFg, fontWeight: FontWeight.w600)),
              onTap: () => context.push('/recipes/$recipeId'),
              trailing: busy
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  : Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline_rounded),
                        color: context.appFgSub,
                        onPressed: () => _run(recipeId,
                            () => notifier.removeRecipe(listId, recipeId)),
                      ),
                      Text(fmt(r['recipeQuantity'] as num?),
                          style: TextStyle(
                              color: context.appFg,
                              fontWeight: FontWeight.w700)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        color: AppTokens.accentDeep,
                        onPressed: () =>
                            _run(recipeId, () => _addAgain(listId, recipeId)),
                      ),
                    ]),
            );
          }),
    ]);
  }
}

class _CompletedSection extends StatelessWidget {
  final List<ShoppingItem> items;
  final bool isCollapsed;
  final String label;
  final bool exactQuantities;
  final VoidCallback onToggleCollapse;
  final ValueChanged<ShoppingItem> onToggle;
  final ValueChanged<String> onDelete;

  const _CompletedSection({
    required this.items,
    required this.isCollapsed,
    required this.label,
    required this.exactQuantities,
    required this.onToggleCollapse,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onToggleCollapse,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: context.appSurface2,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.appSeparator, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline_rounded,
                    size: 18, color: context.appFgSub),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(label,
                      style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: context.appFg,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                          fontSize: 16)),
                ),
                Icon(
                  isCollapsed
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: context.appFgSub,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (!isCollapsed)
          ...items.map((item) => Dismissible(
                key: ValueKey('done_${item.id}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => onDelete(item.id),
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () => onToggle(item),
                    child: const Icon(Icons.check_circle,
                        color: Colors.green, size: 22),
                  ),
                  title: Text(
                    // Exakt AN: voller Webapp-Spiegel („150 g Joghurt") —
                    // erledigte Zeilen haben keinen Stepper, daher Menge im
                    // Text. Exakt AUS: nur der Name (1x-Stückkauf-Sicht).
                    exactQuantities ? _exactItemText(item) : item.displayName,
                    style: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough),
                  ),
                ),
              )),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Item row — mirrors iOS ShoppingListItemView
// ---------------------------------------------------------------------------

class _ItemRow extends StatefulWidget {
  final ShoppingItem item;
  final bool isPendingAdd;
  final List<ShoppingLabel> availableLabels;
  final bool exactQuantities;
  final ValueChanged<ShoppingItem> onToggle;
  final void Function(ShoppingItem, double, {bool clearUnit}) onQuantityChange;
  final ValueChanged<String> onDelete;
  final void Function(ShoppingItem, ShoppingLabel?) onCategoryChange;
  final ShoppingItemEdit onEdit;

  const _ItemRow({
    required this.item,
    required this.isPendingAdd,
    required this.availableLabels,
    required this.exactQuantities,
    required this.onToggle,
    required this.onQuantityChange,
    required this.onDelete,
    required this.onCategoryChange,
    required this.onEdit,
  });

  @override
  State<_ItemRow> createState() => _ItemRowState();
}

class _ItemRowState extends State<_ItemRow> {
  late double _qty;

  @override
  void initState() {
    super.initState();
    _qty = widget.item.effectiveQuantity;
  }

  @override
  void didUpdateWidget(_ItemRow old) {
    super.didUpdateWidget(old);
    if (old.item.quantity != widget.item.quantity) {
      _qty = widget.item.effectiveQuantity;
    }
  }

  // Full edit sheet: name, quantity and category in one place.
  void _showCategoryPicker() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      backgroundColor: context.appCard,
      // Root-Navigator: sonst liegt das Sheet hinter der fixen GlassTabBar.
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (_) => _EditItemSheet(
        item: widget.item,
        availableLabels: widget.availableLabels,
        onSave: (note, qty, label, clearLabel) {
          widget.onEdit(widget.item, note, qty, label, clearLabel);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    // Strukturierte Einheit (Web-Adds, Exakt-Adds): "g", "Teelöffel", …
    // unitCarriesName („Eier (Größe M)"): die Einheit steckt bereits im
    // displayName — als Stück-Artikel behandeln, sonst zeigte Exakt AUS nur
    // die Klammer-Anmerkung und Exakt AN den Namen doppelt.
    final abbreviation = item.unit?.abbreviation;
    final hasUnit = ((abbreviation?.isNotEmpty ?? false) ||
            (item.unit?.name?.isNotEmpty ?? false)) &&
        !item.unitCarriesName;
    final exact = widget.exactQuantities;
    // Exakt AN: 1:1 Webapp-Spiegel — echte Menge im Stepper, Einheit vor dem
    // Namen ("150 | g Joghurt"). Exakt AUS: Einheiten-Artikel als 1x-Stück-
    // kauf anzeigen ("1 | Joghurt"); erst eine bewusste +/−-Interaktion
    // macht daraus einen echten Stück-Artikel (clearUnit).
    final shownQty = (!exact && hasUnit) ? 1.0 : _qty;
    // Plural von Einheit/Zutat richtet sich nach der TATSÄCHLICH gezeigten
    // Menge (shownQty), nicht der rohen _qty — sonst stünde bei erzwungener
    // 1x-Stückkauf-Anzeige ("1") trotzdem ein pluralisierter Name daneben.
    final usePlural = shouldPluralize(shownQty);
    final unitLabel = (abbreviation?.isNotEmpty ?? false)
        ? abbreviation!
        : pluralize(item.unit?.name ?? '', item.unit?.pluralName, usePlural);
    final title = (exact && hasUnit)
        ? '$unitLabel ${item.displayNamePlural(usePlural)}'
        : item.displayNamePlural(usePlural);

    final l = AppLocalizations.of(context)!;
    return Slidable(
      key: ValueKey(item.id),
      groupTag: 'shopping-items',
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          // Bearbeiten (blue) — opens category picker, mirrors iOS edit action
          SlidableAction(
            onPressed: (_) => _showCategoryPicker(),
            backgroundColor: const Color(0xFF0A84FF),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: l.edit,
          ),
          // Löschen (red) — mirrors iOS delete action
          SlidableAction(
            onPressed: (_) => widget.onDelete(item.id),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: l.delete,
          ),
        ],
      ),
      child: GestureDetector(
        onLongPress: _showCategoryPicker,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: context.appSeparator, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              // Minus button — mirrors iOS minus circle button
              _CircleButton(
                icon: Icons.remove,
                onTap: () {
                  if (shownQty > 0) {
                    // Bruchmengen (z. B. 0.5 aus „exakte Mengen") nicht ins
                    // Negative schieben — unter 1 geht es direkt auf 0.
                    final newQty = shownQty > 1 ? shownQty - 1 : 0.0;
                    setState(() => _qty = newQty);
                    widget.onQuantityChange(item, newQty,
                        clearUnit: !exact && hasUnit);
                  }
                },
              ),
              SizedBox(
                width: 28,
                // FittedBox: große exakte Mengen („200") und Dezimalen
                // („0.5") passend einschrumpfen statt zu clippen.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(_fmtStepQty(shownQty),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: context.appFg)),
                ),
              ),
              // Plus button
              _CircleButton(
                icon: Icons.add,
                onTap: () {
                  final newQty = shownQty + 1;
                  setState(() => _qty = newQty);
                  widget.onQuantityChange(item, newQty,
                      clearUnit: !exact && hasUnit);
                },
              ),
              const SizedBox(width: 10),
              // Name — bei Food-Items mit echter Zusatznotiz („festkochend")
              // hängt die Notiz gedimmt hinter dem Produktnamen, wie in der
              // Webapp. Für alle anderen Items ist noteAnnotation leer.
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onToggle(item),
                  onLongPress: _showCategoryPicker,
                  child: Text.rich(
                    TextSpan(
                      text: title,
                      children: [
                        if (item.noteAnnotation.isNotEmpty)
                          TextSpan(
                            text: '  ${item.noteAnnotation}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: context.appFgTertiary,
                            ),
                          ),
                      ],
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          item.checked ? context.appFgTertiary : context.appFg,
                      decoration:
                          item.checked ? TextDecoration.lineThrough : null,
                      decorationColor: context.appFgTertiary,
                    ),
                    maxLines: 2,
                  ),
                ),
              ),
              // Cloud-Badge: Item wurde offline erfasst und ist noch nicht
              // auf dem Server (fehlt also auch in der Webapp). Verschwindet
              // automatisch, sobald der Auto-Sync es nachgeschoben hat.
              if (widget.isPendingAdd) ...[
                const SizedBox(width: 6),
                Icon(Icons.cloud_upload_outlined,
                    size: 16, color: context.appFgTertiary),
              ],
              const SizedBox(width: 8),
              // Checkmark button — Verlaufs-Haken „poppt" beim Abhaken.
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  widget.onToggle(item);
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.elasticOut,
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: item.checked
                      ? Container(
                          key: const ValueKey(true),
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppTokens.accentGradient,
                          ),
                          child: const Icon(Icons.check_rounded,
                              size: 16, color: Colors.white),
                        )
                      : Container(
                          key: const ValueKey(false),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: context.appFgTertiary, width: 2),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Stepper-Mengenanzeige: ganze Zahlen ohne Nachkommastelle, exakte Mengen
// aus Rezepten (z. B. 0.5 l) mit einer Dezimalstelle — `truncate()` würde
// 0.5 als "0" anzeigen.
String _fmtStepQty(double q) {
  if (q == q.truncateToDouble()) return q.truncate().toString();
  return q.toStringAsFixed(1);
}

// Voller Webapp-Spiegel-Text im Exakt-Modus: „<Menge> <Einheit> <Name>"
// (Menge nur wenn > 0, Einheit bevorzugt als Abkürzung — wie Mealie-Web).
// Food-Items mit echter Zusatznotiz bekommen sie hinten angehängt, wie die
// Webapp den Artikel rendert („150 g Joghurt griechisch"). Brüche + Plural
// von Einheit/Zutat wie in der Rezept-Detailansicht (Issue #32) — die
// Abkürzung ("g") bleibt unverändert, da sie ohnehin einheitenlos ist.
String _exactItemText(ShoppingItem item) {
  final qty = item.quantity ?? 0;
  final usePlural = shouldPluralize(qty);
  final abbreviation = item.unit?.abbreviation;
  // unitCarriesName: Einheit steckt schon im displayName („Eier (Größe M)").
  final unitLabel = item.unitCarriesName
      ? ''
      : ((abbreviation?.isNotEmpty ?? false)
          ? abbreviation!
          : pluralize(item.unit?.name ?? '', item.unit?.pluralName, usePlural));
  return [
    if (qty > 0) formatQuantity(qty),
    if (unitLabel.isNotEmpty) unitLabel,
    item.displayNamePlural(usePlural),
    if (item.noteAnnotation.isNotEmpty) item.noteAnnotation,
  ].join(' ');
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Edit item sheet — edit name, quantity and category in one place
// ---------------------------------------------------------------------------

class _EditItemSheet extends ConsumerStatefulWidget {
  final ShoppingItem item;
  final List<ShoppingLabel> availableLabels;
  final void Function(
          String note, double quantity, ShoppingLabel? label, bool clearLabel)
      onSave;

  const _EditItemSheet({
    required this.item,
    required this.availableLabels,
    required this.onSave,
  });

  @override
  ConsumerState<_EditItemSheet> createState() => _EditItemSheetState();
}

class _EditItemSheetState extends ConsumerState<_EditItemSheet> {
  late TextEditingController _nameCtrl;
  // Exakt-Modus: Menge direkt eintippbar (200 g Butter braucht keine 200
  // Stepper-Taps); Stepper-Buttons bleiben zusätzlich nutzbar.
  late TextEditingController _qtyCtrl;
  late double _qty;
  late String? _labelId; // null = unlabeled

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(
        text: widget.item.displayName == '-'
            ? (widget.item.note ?? '')
            : widget.item.displayName);
    _qty = widget.item.effectiveQuantity;
    _qtyCtrl = TextEditingController(text: _fmtStepQty(_qty));
    _labelId = widget.item.label?.id;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  bool get _exact =>
      ref.read(settingsProvider).valueOrNull?.addExactQuantities ?? false;

  // Menge aus dem Textfeld übernehmen (Komma tolerieren); leer/unparsebar →
  // letzter Stepper-Stand.
  double _effectiveQty() {
    if (!_exact) return _qty;
    final parsed = double.tryParse(_qtyCtrl.text.trim().replaceAll(',', '.'));
    return (parsed == null || parsed <= 0) ? _qty : parsed;
  }

  void _stepQty(double delta) {
    final next = _effectiveQty() + delta;
    if (next <= 0) return; // nicht unter die kleinste sinnvolle Menge
    setState(() {
      _qty = next;
      _qtyCtrl.text = _fmtStepQty(_qty);
    });
  }

  void _save() {
    final clearLabel = _labelId == null;
    final label = clearLabel
        ? null
        : widget.availableLabels.firstWhere((l) => l.id == _labelId,
            orElse: () =>
                widget.item.label ?? const ShoppingLabel(id: '', name: ''));
    widget.onSave(_nameCtrl.text, _effectiveQty(),
        (label != null && label.id.isEmpty) ? null : label, clearLabel);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: SheetHandle()),
          const SizedBox(height: 6),
          Center(
            child: Text(l.edit,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3)),
          ),
          const SizedBox(height: 16),

          // Name (note)
          Text(l.itemNote,
              style: TextStyle(color: context.appFgSub, fontSize: 13)),
          const SizedBox(height: 6),
          TextField(
            controller: _nameCtrl,
            style: TextStyle(color: context.appFg),
            decoration: InputDecoration(
              filled: true,
              fillColor: context.appCard,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTokens.rSm),
                borderSide: BorderSide(color: context.appSeparator, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTokens.rSm),
                borderSide:
                    const BorderSide(color: AppTokens.accent, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Quantity stepper — im Exakt-Modus ist die Menge zusätzlich
          // direkt eintippbar (statt 200× Plus für „200 g").
          Row(
            children: [
              Text('${l.ingredientQuantity}:',
                  style: TextStyle(color: context.appFgSub, fontSize: 13)),
              const Spacer(),
              _CircleButton(
                icon: Icons.remove,
                onTap: () => _stepQty(-1),
              ),
              if (_exact)
                SizedBox(
                  width: 64,
                  child: TextField(
                    controller: _qtyCtrl,
                    textAlign: TextAlign.center,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                        color: context.appFg,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 6),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: 44,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(_fmtStepQty(_qty),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: context.appFg,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              _CircleButton(
                icon: Icons.add,
                onTap: () => _stepQty(1),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Category chips
          Text('${l.unlabeledCategory} / ${l.tags}:',
              style: TextStyle(color: context.appFgSub, fontSize: 13)),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _labelId = null),
                  child: _catChip(
                    name: l.unlabeledCategory,
                    color: Colors.grey,
                    selected: _labelId == null,
                  ),
                ),
                const SizedBox(width: 6),
                // Live aus dem Provider lesen, damit ein neu angelegtes Label
                // sofort als Chip erscheint (statt der beim Öffnen übergebenen
                // Snapshot-Liste). Long-Press → Wackeln + Löschen (Server).
                ...(ref.watch(shoppingLabelsProvider).valueOrNull ??
                        widget.availableLabels)
                    .map((label) {
                  final c = shoppingCategoryColor(label.color, label.name);
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: DeletableChip(
                      onTap: () => setState(() => _labelId = label.id),
                      onDelete: () async {
                        await deleteShoppingLabelWithConfirm(
                            context, ref, label);
                        if (mounted && _labelId == label.id) {
                          setState(() => _labelId = null);
                        }
                      },
                      child: _catChip(
                        name: label.name,
                        color: c,
                        selected: _labelId == label.id,
                      ),
                    ),
                  );
                }),
                // „+"-Chip ganz rechts → neues Label inkl. Farbe anlegen.
                _AddLabelChip(onTap: _createLabel),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Save
          GradientButton(label: l.save, onTap: _save),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // Reines Chip-Visual (ohne Gesten).
  Widget _catChip({
    required String name,
    required Color color,
    required bool selected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected
            ? color.withValues(alpha: 0.40)
            : color.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? color : color.withValues(alpha: 0.55),
          width: selected ? 1.6 : 1.0,
        ),
      ),
      child: Text(name,
          style: TextStyle(
            fontSize: 13,
            color: context.appFg,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          )),
    );
  }

  // Neues Shopping-Label (mit Farbe) anlegen und gleich auswählen.
  Future<void> _createLabel() async {
    final label = await showCreateShoppingLabelDialog(context, ref);
    if (label != null && mounted) setState(() => _labelId = label.id);
  }
}

/// Zeigt den „Neues Label (mit Farbe)"-Dialog, legt das Label serverseitig an
/// (POST /api/groups/labels), lädt die Label-Liste neu und liefert das neue
/// Label (oder null bei Abbruch/Fehler). Genutzt vom Edit-Item-Sheet UND der
/// Haupt-View (Input-Bar), damit der Dialog nicht doppelt existiert.
Future<ShoppingLabel?> showCreateShoppingLabelDialog(
    BuildContext context, WidgetRef ref) async {
  // Dialog als eigenes StatefulWidget (besitzt + disposed Controller selbst) —
  // synchrones dispose nach showDialog löste die „_dependents.isEmpty"-Assertion
  // aus, während das TextField noch abgebaut wurde.
  final result = await showDialog<(String, String)>(
    context: context,
    builder: (_) => const _CreateLabelDialog(),
  );
  if (result == null || result.$1.isEmpty) return null;
  try {
    final label = await ref
        .read(apiServiceProvider)
        .createShoppingLabel(result.$1, color: result.$2);
    await ref.read(shoppingLabelsProvider.notifier).reload();
    return label;
  } catch (_) {
    if (context.mounted) {
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.createFailed)));
    }
    return null;
  }
}

/// Löscht ein Shopping-Label nach Bestätigung serverseitig und lädt die
/// Label-Liste neu. Genutzt vom Long-Press-/Wackel-Delete in beiden Chip-Reihen.
Future<void> deleteShoppingLabelWithConfirm(
    BuildContext context, WidgetRef ref, ShoppingLabel label) async {
  final l = AppLocalizations.of(context)!;
  final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(l.deleteOrganizerConfirm(label.name)),
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
    await ref.read(apiServiceProvider).deleteShoppingLabel(label.id);
    await ref.read(shoppingLabelsProvider.notifier).reload();
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.deleteFailed)));
    }
  }
}

// Dialog „Neues Label (Name + Farbe)". Eigenes StatefulWidget → Controller-
// Lifecycle an den Dialog gebunden. Liefert (name, colorHex) per Navigator.pop.
class _CreateLabelDialog extends StatefulWidget {
  const _CreateLabelDialog();

  @override
  State<_CreateLabelDialog> createState() => _CreateLabelDialogState();
}

class _CreateLabelDialogState extends State<_CreateLabelDialog> {
  final _ctrl = TextEditingController();
  String _color = _kLabelPalette.first;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _ctrl.text.trim();
    if (name.isEmpty) {
      Navigator.pop(context);
      return;
    }
    Navigator.pop(context, (name, _color));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l.newCategory),
      // Scrollbar, damit der Inhalt bei eingeblendeter Tastatur (weniger
      // verfügbare Höhe) NICHT über seinen Bereich hinaus in die Action-Buttons
      // läuft — sonst überlappen „Abbrechen"/„Hinzufügen" das Farbraster.
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _ctrl,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: l.name),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            // Kopfzeile: „Farbe" + Vorschau der aktuell gewählten Farbe + Würfel
            // für eine Zufallsfarbe.
            Row(
              children: [
                Text(l.color,
                    style: TextStyle(color: context.appFgSub, fontSize: 13)),
                const Spacer(),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _hexToColor(_color),
                    shape: BoxShape.circle,
                    border: Border.all(color: context.appSeparator, width: 1),
                  ),
                ),
                IconButton(
                  tooltip: l.randomColor,
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.casino_rounded, color: context.appFg),
                  onPressed: () => setState(() => _color = _randomColorHex()),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Alle Farben in einem Wrap OHNE Scrollbar — passt in wenige Reihen.
            Wrap(
              spacing: 9,
              runSpacing: 9,
              children: _kLabelPalette.map((hex) {
                final c = _hexToColor(hex);
                final sel = hex.toUpperCase() == _color.toUpperCase();
                return GestureDetector(
                  onTap: () => setState(() => _color = hex),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: sel ? context.appFg : Colors.transparent,
                        width: 2.5,
                      ),
                      boxShadow: sel
                          ? [
                              BoxShadow(
                                  color: c.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2))
                            ]
                          : null,
                    ),
                    child: sel
                        ? const Icon(Icons.check, size: 15, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(onPressed: _submit, child: Text(l.add)),
      ],
    );
  }
}

/// Farbpalette für neue Einkaufslisten-Labels (Hex). Breites Spektrum auf
/// Basis der iOS-System-Akzentfarben + zusätzlicher Schattierungen, damit viel
/// Auswahl da ist; im Dialog kompakt + scrollbar dargestellt.
const _kLabelPalette = <String>[
  // Rot / Orange / Gelb
  '#FF3B30', '#E5634D', '#FF6B6B', '#FF9500', '#FF8C42', '#FFB340',
  '#FFCC00', '#FFD60A', '#F4D35E',
  // Grün / Teal
  '#34C759', '#30D158', '#A8E063', '#2EC4B6', '#00C7BE', '#0FB9B1',
  // Blau
  '#5AC8FA', '#0A84FF', '#007AFF', '#4A6FA5',
  // Lila / Pink
  '#5856D6', '#7B61FF', '#AF52DE', '#BF5AF2', '#FF2D55', '#FF375F',
  '#FF6482', '#D6336C',
  // Braun / Neutral
  '#A2845E', '#8E8E93', '#636366',
];

/// Hex (#RRGGBB) → Color.
Color _hexToColor(String hex) {
  final clean = hex.startsWith('#') ? hex.substring(1) : hex;
  return Color(int.parse('FF$clean', radix: 16));
}

/// Echte Zufallsfarbe über das GESAMTE Hex-Spektrum (#000000–#FFFFFF) — jede
/// der 16,7 Mio. Farben ist möglich, nicht nur kräftige.
String _randomColorHex() {
  final n = Random().nextInt(0x1000000); // 0 .. 0xFFFFFF
  return '#${n.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

// „+"-Chip am Ende der Label-Reihe (Edit-Item-Sheet).
class _AddLabelChip extends StatelessWidget {
  final VoidCallback onTap;
  const _AddLabelChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primary.withValues(alpha: 0.6)),
        ),
        child: Icon(Icons.add_rounded, size: 18, color: primary),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom input bar — mirrors iOS inputSection
// ---------------------------------------------------------------------------

class _InputBar extends StatelessWidget {
  final TextEditingController ctrl;
  final FocusNode focusNode;
  // Exakt-Modus: Menge + Einheit vor dem Artikelnamen erfassen.
  final TextEditingController qtyCtrl;
  final TextEditingController unitCtrl;
  final FocusNode qtyFocus;
  final FocusNode unitFocus;
  final bool exactQuantities;
  // Server-Kataloge für die Autovervollständigung beim Tippen.
  final List<String> foodOptions;
  final List<String> unitOptions;
  final ShoppingLabel? selectedLabel;
  final List<ShoppingLabel> labels;
  final bool inputFocused;
  final VoidCallback onAdd;
  final ValueChanged<ShoppingLabel?> onLabelSelected;
  final VoidCallback onCreateLabel;
  final ValueChanged<ShoppingLabel> onDeleteLabel;
  final VoidCallback onArchive;
  final AppLocalizations l;

  const _InputBar({
    required this.ctrl,
    required this.focusNode,
    required this.qtyCtrl,
    required this.unitCtrl,
    required this.qtyFocus,
    required this.unitFocus,
    required this.exactQuantities,
    required this.foodOptions,
    required this.unitOptions,
    required this.selectedLabel,
    required this.labels,
    required this.inputFocused,
    required this.onAdd,
    required this.onLabelSelected,
    required this.onCreateLabel,
    required this.onDeleteLabel,
    required this.onArchive,
    required this.l,
  });

  // Einheitlicher Karten-Look aller Eingabefelder der Add-Bar.
  InputDecoration _dec(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: context.appFgTertiary),
      filled: true,
      fillColor: context.appCard,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.rSm),
        borderSide: BorderSide(color: context.appSeparator, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.rSm),
        borderSide: const BorderSide(color: AppTokens.accent, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: context.appBg,
        border: Border(
          top: BorderSide(color: context.appSeparator, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        // Die Add-Bar liegt im Scaffold-Body → adjustResize hebt sie bereits
        // über die Tastatur; der Keyboard-Inset darf hier NICHT addiert werden
        // (sonst doppelt). Fester Abstand genügt.
        bottom: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text field(s) + add button. Exakt-Modus: [Menge][Einheit][Artikel]
          // — so lässt sich „200 g Butter" direkt eintippen statt 200× Plus.
          Row(
            children: [
              if (exactQuantities) ...[
                SizedBox(
                  width: 58,
                  child: TextField(
                    controller: qtyCtrl,
                    focusNode: qtyFocus,
                    style: TextStyle(color: context.appFg),
                    textAlign: TextAlign.center,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: _dec(context, '1'),
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  width: 86,
                  child: AutocompleteField(
                    controller: unitCtrl,
                    focusNode: unitFocus,
                    options: unitOptions,
                    style: TextStyle(color: context.appFg),
                    decoration: _dec(context, l.ingredientUnit),
                    // Overlay über der Tastatur → nach OBEN öffnen.
                    openDirection: OptionsViewOpenDirection.up,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: AutocompleteField(
                  controller: ctrl,
                  focusNode: focusNode,
                  options: foodOptions,
                  style: TextStyle(color: context.appFg),
                  // 4b: Enter-Taste der System-Tastatur soll absenden statt
                  // einen Zeilenumbruch zu setzen. `done` aktiviert das
                  // „Fertig"/„Senden"-Action-Symbol auf iOS und Android.
                  textInputAction: TextInputAction.done,
                  decoration: _dec(context, l.addItemPlaceholder),
                  openDirection: OptionsViewOpenDirection.up,
                  onSubmitted: (_) => onAdd(),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: ctrl.text.trim().isEmpty
                        ? null
                        : AppTokens.accentGradient,
                    color:
                        ctrl.text.trim().isEmpty ? context.appSurface2 : null,
                    boxShadow:
                        ctrl.text.trim().isEmpty ? null : context.appAccentGlow,
                  ),
                  child: Icon(Icons.add_rounded,
                      size: 24,
                      color: ctrl.text.trim().isEmpty
                          ? context.appFgTertiary
                          : Colors.white),
                ),
              ),
            ],
          ),

          // Label chips — mirrors iOS categoryChip row
          const SizedBox(height: 8),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // "No label" chip
                _LabelChip(
                  name: l.unlabeledCategory,
                  color: Colors.grey,
                  isSelected: selectedLabel == null,
                  onTap: () => onLabelSelected(null),
                ),
                const SizedBox(width: 6),
                ...labels.map((label) {
                  final color = shoppingCategoryColor(label.color, label.name);
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    // Long-Press → Wackeln + Löschen (Server).
                    child: DeletableChip(
                      onTap: () => onLabelSelected(label),
                      onDelete: () => onDeleteLabel(label),
                      child: _LabelChip(
                        name: label.name,
                        color: color,
                        isSelected: selectedLabel?.id == label.id,
                      ),
                    ),
                  );
                }),
                // „+"-Chip ganz rechts → neues Label inkl. Farbe anlegen.
                _AddLabelChip(onTap: onCreateLabel),
              ],
            ),
          ),

          // Archive button — only when keyboard is not focused
          if (!inputFocused) ...[
            const SizedBox(height: 10),
            GradientButton(
              label: l.completeShopping,
              icon: Icons.archive_outlined,
              onTap: onArchive,
            ),
          ],
        ],
      ),
    );
  }
}

class _LabelChip extends StatelessWidget {
  final String name;
  final Color color;
  final bool isSelected;
  // null → reines Visual (Gesten übernimmt dann z. B. DeletableChip).
  final VoidCallback? onTap;

  const _LabelChip({
    required this.name,
    required this.color,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final visual = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? color.withValues(alpha: 0.40)
            : color.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(20),
        // Always show a border on non-selected chips too — needed for
        // readability against the dark scaffold (a faint tinted fill alone
        // disappears in dark mode).
        border: Border.all(
          color: isSelected ? color : color.withValues(alpha: 0.55),
          width: isSelected ? 1.6 : 1.0,
        ),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 13,
          color: context.appFg,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
    if (onTap == null) return visual;
    return GestureDetector(onTap: onTap, child: visual);
  }
}
