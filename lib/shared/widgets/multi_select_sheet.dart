import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../theme/app_colors.dart';
import 'gradient_button.dart';

// ---------------------------------------------------------------------------
// Auswahl-Sheet wie Mealies „SearchFilter": Suchfeld + Mehrfachauswahl,
// optional „Alle enthalten / Irgendeines enthalten" und Einfachauswahl
// (Haushalte). Genutzt von Rezeptliste und Rezept-Suche.
// ---------------------------------------------------------------------------

typedef SelectItem = ({String id, String name});

class MultiSelectResult {
  final List<SelectItem> selected;

  /// Nur gesetzt, wenn das Sheet den Alle/Irgendeines-Schalter zeigte.
  final bool? requireAll;
  const MultiSelectResult(this.selected, this.requireAll);
}

/// Öffnet das Sheet. [items] wird live beobachtet (Listen laden ggf. noch),
/// [loading] zeigt solange einen Ladekreis. [requireAll] != null → Schalter
/// „Alle enthalten / Irgendeines enthalten". [single] → höchstens ein Eintrag.
Future<MultiSelectResult?> showMultiSelectSheet(
  BuildContext context, {
  required String title,
  required List<SelectItem> initial,
  required List<SelectItem> Function(WidgetRef ref) items,
  bool Function(WidgetRef ref)? loading,
  bool? requireAll,
  bool single = false,
}) =>
    showModalBottomSheet<MultiSelectResult>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.appCard,
      builder: (_) => _MultiSelectSheet(
        title: title,
        initial: initial,
        items: items,
        loading: loading ?? (_) => false,
        requireAll: requireAll,
        single: single,
      ),
    );

class _MultiSelectSheet extends ConsumerStatefulWidget {
  final String title;
  final List<SelectItem> initial;
  final List<SelectItem> Function(WidgetRef ref) items;
  final bool Function(WidgetRef ref) loading;
  final bool? requireAll;
  final bool single;

  const _MultiSelectSheet({
    required this.title,
    required this.initial,
    required this.items,
    required this.loading,
    required this.requireAll,
    required this.single,
  });

  @override
  ConsumerState<_MultiSelectSheet> createState() => _MultiSelectSheetState();
}

class _MultiSelectSheetState extends ConsumerState<_MultiSelectSheet> {
  late final Map<String, SelectItem> _selected = {
    for (final i in widget.initial) i.id: i,
  };
  late bool? _requireAll = widget.requireAll;
  String _query = '';

  void _toggle(SelectItem item, bool on) => setState(() {
        if (widget.single) _selected.clear();
        if (on) {
          _selected[item.id] = item;
        } else {
          _selected.remove(item.id);
        }
      });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final all = List.of(widget.items(ref));
    final q = _query.trim().toLowerCase();
    final shown = q.isEmpty
        ? all
        : all.where((i) => i.name.toLowerCase().contains(q)).toList();
    // Ausgewählte zuerst, damit man sie ohne Scrollen wiederfindet.
    shown.sort((a, b) {
      final sa = _selected.containsKey(a.id) ? 0 : 1;
      final sb = _selected.containsKey(b.id) ? 0 : 1;
      return sa != sb
          ? sa.compareTo(sb)
          : a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Column(children: [
        const SheetHandle(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
          child: Row(children: [
            Expanded(
              child: Text(widget.title,
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: context.appFg,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
            ),
            if (_selected.isNotEmpty)
              TextButton(
                onPressed: () => setState(_selected.clear),
                child: Text(l.finderClearSelection),
              ),
          ]),
        ),
        if (_requireAll != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: false, label: Text(l.searchHasAny)),
                  ButtonSegment(value: true, label: Text(l.searchHasAll)),
                ],
                selected: {_requireAll!},
                onSelectionChanged: (s) =>
                    setState(() => _requireAll = s.first),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            style: TextStyle(color: context.appFg),
            decoration: InputDecoration(
              hintText: l.search,
              prefixIcon: const Icon(Icons.search_rounded),
              isDense: true,
              filled: true,
              fillColor: context.appSurface2,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTokens.rSm),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: all.isEmpty && widget.loading(ref)
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: shown.length,
                  itemBuilder: (_, i) {
                    final item = shown[i];
                    final on = _selected.containsKey(item.id);
                    final title =
                        Text(item.name, style: TextStyle(color: context.appFg));
                    return widget.single
                        ? ListTile(
                            dense: true,
                            leading: Icon(
                                on
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_off_rounded,
                                color: on
                                    ? AppTokens.accent
                                    : context.appFgTertiary),
                            title: title,
                            onTap: () => _toggle(item, !on),
                          )
                        : CheckboxListTile(
                            value: on,
                            dense: true,
                            activeColor: AppTokens.accent,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: title,
                            onChanged: (v) => _toggle(item, v == true),
                          );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: GradientButton(
            label: l.done,
            icon: Icons.check_rounded,
            onTap: () => Navigator.pop(context,
                MultiSelectResult(_selected.values.toList(), _requireAll)),
          ),
        ),
      ]),
    );
  }
}
