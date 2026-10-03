import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/shopping_item.dart';
import '../../../core/utils/search_match.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../../shopping_list/providers/shopping_list_provider.dart'
    show shoppingLabelsProvider, shoppingListProvider;
import '../../shopping_list/screens/shopping_list_screen.dart'
    show shoppingCategoryColor;

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
    final detail = mealieErrorMessage(e);
    messenger.showSnackBar(SnackBar(
        content: Text(
            detail == null ? l.createFailed : '${l.createFailed}: $detail')));
    return null;
  }
}

class LabelsScreen extends ConsumerStatefulWidget {
  const LabelsScreen({super.key});

  @override
  ConsumerState<LabelsScreen> createState() => _LabelsScreenState();
}

class _LabelsScreenState extends ConsumerState<LabelsScreen> {
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
    final detail = mealieErrorMessage(e);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(detail == null ? fallback : '$fallback: $detail')));
  }

  Future<void> _edit(ShoppingLabel? label) async {
    final l = AppLocalizations.of(context)!;
    final result = await showLabelEditDialog(context, label: label);
    if (result == null) return;
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
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
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
    final shown = labels
        .where((x) => terms.every(normalizeForSearch(x.name).contains))
        .toList();

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
                  IconButton(
                    icon: Icon(Icons.checklist_rounded, color: context.appFg),
                    tooltip: l.selectAction,
                    onPressed: () => setState(() => _selecting = true),
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
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
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
                    onRefresh: _refresh,
                    child: labels.isEmpty
                        ? ListView(children: [
                            Padding(
                              padding: const EdgeInsets.all(32),
                              child: async.isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : Text(l.foodsUnitsEmpty,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: context.appFgSub,
                                          fontSize: 15)),
                            ),
                          ])
                        : ListView.builder(
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
                              return EntranceOnce(
                                id: 'label-${lb.id}',
                                index: i,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _selecting
                                      ? tile
                                      : Slidable(
                                          key: ValueKey(lb.id),
                                          endActionPane: ActionPane(
                                            motion: const DrawerMotion(),
                                            extentRatio: 0.3,
                                            children: [
                                              SlidableAction(
                                                onPressed: (_) async {
                                                  if (await _confirm(
                                                      l.labelDeleteConfirm(
                                                          lb.name))) {
                                                    await _deleteIds([lb.id]);
                                                  }
                                                },
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                icon: Icons.delete,
                                                label: l.delete,
                                              ),
                                            ],
                                          ),
                                          child: tile,
                                        ),
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
class _LabelDialog extends StatefulWidget {
  final ShoppingLabel? label;
  const _LabelDialog({this.label});

  @override
  State<_LabelDialog> createState() => _LabelDialogState();
}

class _LabelDialogState extends State<_LabelDialog> {
  late final _name = TextEditingController(text: widget.label?.name ?? '');
  late final _hex = TextEditingController(
      text: _normalize(widget.label?.color) ?? _kPalette[5]);
  bool _nameError = false;

  static String? _normalize(String? c) {
    if (c == null) return null;
    var v = c.trim().toUpperCase();
    if (!v.startsWith('#')) v = '#$v';
    // Mealie speichert teils #RRGGBBAA — für die Anzeige reicht RGB.
    if (v.length == 9) v = v.substring(0, 7);
    return RegExp(r'^#[0-9A-F]{6}$').hasMatch(v) ? v : null;
  }

  Color? get _color {
    final v = _normalize(_hex.text);
    return v == null
        ? null
        : Color(int.parse('FF${v.substring(1)}', radix: 16));
  }

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
            TextField(
              controller: _name,
              autofocus: widget.label == null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l.name,
                errorText: _nameError ? l.required : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(l.colorLabel,
                style: TextStyle(color: context.appFgSub, fontSize: 12.5)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final hex in _kPalette)
                  GestureDetector(
                    onTap: () => setState(() => _hex.text = hex),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(
                            int.parse('FF${hex.substring(1)}', radix: 16)),
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
            Navigator.pop(context,
                (name: name, color: _normalize(_hex.text) ?? _kPalette[5]));
          },
          child: Text(widget.label == null ? l.add : l.save),
        ),
      ],
    );
  }
}
