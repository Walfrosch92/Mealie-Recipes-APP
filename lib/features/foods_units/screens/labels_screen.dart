import 'package:flutter/material.dart';
import '../../../shared/widgets/swipe_context_menu.dart';
import '../../../shared/widgets/tap_area.dart';
import '../../../shared/widgets/app_search_field.dart';
import '../../../shared/widgets/app_snack.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/shopping_item.dart';
import '../../../core/utils/search_match.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/autocomplete_field.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../../shopping_list/providers/shopping_list_provider.dart'
    show shoppingLabelsProvider, shoppingListProvider;
import '../../shopping_list/screens/shopping_list_screen.dart'
    show shoppingCategoryColor;
import '../../../shared/widgets/search_jump.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../core/utils/hex_color.dart';

// ---------------------------------------------------------------------------
// Abteilungen (Mealie „Labels") verwalten — wie die Webapp: anlegen,
// Name und Farbe ändern, löschen, mehrere auf einmal löschen. Die Farben
// färben die Einkaufsliste. (Mealie bietet für Labels KEINE Standarddaten.)
// ---------------------------------------------------------------------------

/// Vorschlagsfarben (Hex wie Mealie speichert, `#RRGGBB`).
const _kPalette = [
  '#E53935', '#D81B60', '#8E24AA', '#5E35B1', '#3949AB', '#1E88E5', //
  '#039BE5', '#00ACC1', '#00897B', '#43A047', '#7CB342', '#C0CA33', //
  '#FDD835', '#FFB300', '#FB8C00', '#F4511E', '#6D4C41', '#757575', //
];

/// Dialog Name + Farbe einer Bezeichnung (Mealie-Label). Geteilt mit
/// „Bezeichnungen sortieren" und dem Lebensmittel-Editor.
Future<({String name, String color})?> showLabelEditDialog(BuildContext context,
        {ShoppingLabel? label}) =>
    showDialog<({String name, String color})>(
      context: context,
      builder: (_) => _LabelDialog(label: label),
    );

/// Neue Bezeichnung anlegen (Dialog + Server) und die Bezeichnungen neu
/// laden. Mealie hängt sie automatisch ans Ende der Sortierung JEDER
/// Einkaufsliste. Liefert die neue Bezeichnung oder `null` (abgebrochen/
/// Fehler — Fehler als Snackbar).
Future<ShoppingLabel?> createLabelInteractive(
    BuildContext context, WidgetRef ref) async {
  final l = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  final result = await showLabelEditDialog(context);
  if (result == null) return null;
  try {
    final created = await ref
        .read(apiServiceProvider)
        .createShoppingLabel(result.name, color: result.color);
    await ref.read(shoppingLabelsProvider.notifier).refreshQuiet();
    return created;
  } catch (e) {
    messenger.showSnackBar(
        SnackBar(content: Text(userErrorMessage(e, l.createFailed))));
    return null;
  }
}

class LabelsScreen extends ConsumerStatefulWidget {
  const LabelsScreen({super.key});

  @override
  ConsumerState<LabelsScreen> createState() => _LabelsScreenState();
}

class _LabelsScreenState extends ConsumerState<LabelsScreen>
    with SearchJumpMixin {
  String _query = '';
  bool _selecting = false;
  final Set<String> _selected = {};
  bool _busy = false;

  Future<void> _refresh() async {
    await ref.read(shoppingLabelsProvider.notifier).refreshQuiet();
    // Einkaufsliste zeigt Farben/Namen der Abteilungen → neu einlesen.
    ref.invalidate(shoppingListProvider);
  }

  void _error(String fallback, Object e) {
    if (!mounted) return;
    showErrorSnack(context, fallback, e);
  }

  Future<void> _edit(ShoppingLabel? label) async {
    final l = AppLocalizations.of(context)!;
    final result = await showLabelEditDialog(context, label: label);
    if (result == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final api = ref.read(apiServiceProvider);
      if (label == null) {
        await api.createShoppingLabel(result.name, color: result.color);
      } else {
        await api.updateShoppingLabel(label.id,
            name: result.name, color: result.color);
      }
      HapticFeedback.lightImpact();
      await _refresh();
    } catch (e) {
      _error(label == null ? l.createFailed : l.saveFailed, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirm(String text) async {
    final l = AppLocalizations.of(context)!;
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: ctx.appCard,
            content: Text(text, style: TextStyle(color: ctx.appFg)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l.cancel)),
              FilledButton(
                style: AppTokens.dangerButton,
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l.delete),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteIds(List<String> ids) async {
    final l = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    Object? failure;
    for (final id in ids) {
      try {
        await ref.read(apiServiceProvider).deleteShoppingLabel(id);
      } catch (e) {
        failure = e;
      }
    }
    await _refresh();
    if (!mounted) return;
    setState(() {
      _busy = false;
      _selecting = false;
      _selected.clear();
    });
    if (failure != null) _error(l.deleteFailed, failure);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final async = ref.watch(shoppingLabelsProvider);
    final labels = [...async.valueOrNull ?? const <ShoppingLabel>[]]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    final terms = searchTerms(_query);
    final shown = rankBySearch(
        labels.where((x) => terms.every(normalizeForSearch(x.name).contains)),
        terms,
        (x) => x.name);
    // Sprung aus der globalen Suche (?highlight=<id>).
    handleSearchJump(context, [for (final x in shown) x.id]);

    return PopScope(
      canPop: !_selecting,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _selecting) {
          setState(() {
            _selecting = false;
            _selected.clear();
          });
        }
      },
      child: Scaffold(
        backgroundColor: context.appBg,
        appBar: _selecting
            ? AppBar(
                leading: IconButton(
                  tooltip: AppLocalizations.of(context)!.cancel,
                  icon: const Icon(Icons.close_rounded),
                  onPressed: _busy
                      ? null
                      : () => setState(() {
                            _selecting = false;
                            _selected.clear();
                          }),
                ),
                title: Text(l.selectedCount(_selected.length)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    tooltip: l.delete,
                    onPressed: _busy || _selected.isEmpty
                        ? null
                        : () async {
                            if (await _confirm(
                                l.deleteSelectedConfirm(_selected.length))) {
                              await _deleteIds(_selected.toList());
                            }
                          },
                  ),
                ],
              )
            : AppBar(
                title: Text(l.labelsTitle),
                actions: [
                  IconButton(
                    icon: Icon(Icons.add_rounded, color: context.appFg),
                    tooltip: l.newLabel,
                    onPressed: () => _edit(null),
                  ),
                  // „Auswählen" im ⋮-Menü — wie bei Lebensmitteln/Einheiten.
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert_rounded, color: context.appFg),
                    color: context.appCard,
                    onSelected: (v) {
                      if (v == 'select') setState(() => _selecting = true);
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'select',
                        child: Row(children: [
                          Icon(Icons.checklist_rounded,
                              color: context.appFg, size: 20),
                          const SizedBox(width: 12),
                          Text(l.selectAction,
                              style: TextStyle(color: context.appFg)),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
        body: WithCookingModeFAB(
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                if (_busy) const LinearProgressIndicator(minHeight: 2),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: AppSearchField(
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: labels.isEmpty
                        ? (async.isLoading
                            ? ListView(children: const [
                                Padding(
                                    padding: EdgeInsets.all(32),
                                    child: Center(
                                        child: CircularProgressIndicator())),
                              ])
                            : EmptyStateView(
                                icon: Icons.label_rounded,
                                message: l.foodsUnitsEmpty))
                        : ListView.builder(
                            controller: searchScroll,
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            itemCount: shown.length,
                            itemBuilder: (_, i) {
                              final lb = shown[i];
                              final sel = _selected.contains(lb.id);
                              final tile = BounceTap(
                                scale: 0.99,
                                onTap: _selecting
                                    ? () => setState(() => sel
                                        ? _selected.remove(lb.id)
                                        : _selected.add(lb.id))
                                    : () => _edit(lb),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: context.appCard,
                                    borderRadius:
                                        BorderRadius.circular(AppTokens.rMd),
                                    border: Border.all(
                                        color: sel
                                            ? AppTokens.accent
                                            : context.appSeparator,
                                        width: sel ? 1.5 : 1),
                                    boxShadow: context.appShadowSm,
                                  ),
                                  child: Row(children: [
                                    if (_selecting)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Icon(
                                          sel
                                              ? Icons.check_circle_rounded
                                              : Icons
                                                  .radio_button_unchecked_rounded,
                                          color: sel
                                              ? AppTokens.accent
                                              : context.appFgTertiary,
                                        ),
                                      ),
                                    CircleAvatar(
                                        radius: 11,
                                        backgroundColor: shoppingCategoryColor(
                                            lb.color, lb.name)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(lb.name,
                                          style: TextStyle(
                                              color: context.appFg,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                    if (!_selecting)
                                      Icon(Icons.chevron_right_rounded,
                                          color: context.appFgTertiary),
                                  ]),
                                ),
                              );
                              final marked = searchHighlight(lb.id, tile);
                              return EntranceOnce(
                                id: 'label-${lb.id}',
                                index: i,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _selecting
                                      ? marked
                                      : SwipeContextMenu(
                                          child: Slidable(
                                          key: ValueKey(lb.id),
                                          endActionPane: ActionPane(
                                            motion: const DrawerMotion(),
                                            extentRatio:
                                                AppTokens.swipeExtent(1),
                                            children: [
                                              SlidableAction(
                                                onPressed: (_) async {
                                                  if (await _confirm(
                                                      l.labelDeleteConfirm(
                                                          lb.name))) {
                                                    await _deleteIds([lb.id]);
                                                  }
                                                },
                                                backgroundColor:
                                                    AppTokens.swipeDelete,
                                                foregroundColor: Colors.white,
                                                icon: Icons
                                                    .delete_outline_rounded,
                                                label: l.delete,
                                              ),
                                            ],
                                          ),
                                          child: marked,
                                        )),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Name + Farbe (Palette oder Hex-Eingabe).
class _LabelDialog extends ConsumerStatefulWidget {
  final ShoppingLabel? label;
  const _LabelDialog({this.label});

  @override
  ConsumerState<_LabelDialog> createState() => _LabelDialogState();
}

class _LabelDialogState extends ConsumerState<_LabelDialog> {
  late final _name = TextEditingController(text: widget.label?.name ?? '');

  @override
  void initState() {
    super.initState();
    _name.addListener(() {
      if (mounted) setState(() {});
    });
  }

  /// Namen der ANDEREN Bezeichnungen (Vorschläge + Duplikat-Sperre).
  List<String> get _otherNames => [
        for (final x in ref.watch(shoppingLabelsProvider).valueOrNull ??
            const <ShoppingLabel>[])
          if (x.id != widget.label?.id) x.name,
      ];

  String? get _duplicate {
    final q = normalizeForSearch(_name.text);
    if (q.isEmpty) return null;
    for (final n in _otherNames) {
      if (normalizeForSearch(n) == q) return n;
    }
    return null;
  }

  late final _hex = TextEditingController(
      text: _normalize(widget.label?.color) ?? _kPalette[5]);
  bool _nameError = false;

  static String? _normalize(String? c) {
    final h = normalizeHexRgb(c);
    return h == null ? null : '#$h';
  }

  Color? get _color => colorFromHex(_hex.text);

  @override
  void dispose() {
    _name.dispose();
    _hex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final current = _normalize(_hex.text);
    return AlertDialog(
      backgroundColor: context.appCard,
      title: Text(widget.label == null ? l.newLabel : l.editLabel),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AutocompleteField(
              controller: _name,
              options: _otherNames,
              decoration: InputDecoration(
                labelText: l.name,
                errorText: _nameError
                    ? l.required
                    : (_duplicate == null
                        ? null
                        : l.nameAlreadyExists(_duplicate!)),
                errorMaxLines: 2,
              ),
            ),
            const SizedBox(height: 16),
            Text(l.colorLabel,
                style: TextStyle(color: context.appFgSub, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final hex in _kPalette)
                  TapArea(
                    onTap: () => setState(() => _hex.text = hex),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorFromHex(hex),
                        border: Border.all(
                            color: current == hex
                                ? context.appFg
                                : Colors.transparent,
                            width: 2.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _hex,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Hex',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CircleAvatar(
                      radius: 9, backgroundColor: _color ?? Colors.transparent),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(
          onPressed: () {
            final name = _name.text.trim();
            if (name.isEmpty) {
              setState(() => _nameError = true);
              return;
            }
            if (_duplicate != null) return; // gibt es schon
            Navigator.pop(context,
                (name: name, color: _normalize(_hex.text) ?? _kPalette[5]));
          },
          child: Text(widget.label == null ? l.add : l.save),
        ),
      ],
    );
  }
}
