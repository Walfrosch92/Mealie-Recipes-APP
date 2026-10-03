import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../core/models/organizer_item.dart';
import '../../core/providers/cached_json_list.dart';
import '../../core/services/log_manager.dart';
import '../../core/utils/cookbook_query_filter.dart';
import '../../features/foods_units/providers/foods_units_admin_provider.dart';
import '../../features/organizers/providers/organizers_provider.dart';
import '../../features/shopping_list/providers/shopping_list_provider.dart'
    show shoppingLabelsProvider;
import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Filter-Baukasten für Mealie-`queryFilterString`s — geteilt zwischen
// Kochbuch-Editor und Mahlzeitenplan-Regeln (beides speichert Mealie als
// denselben Filter-String). Zeilen [Feld] [Operator] [Werte], AND-verknüpft,
// plus Roh-Text-Modus als Sicherheitsnetz: lässt sich ein geladener Filter
// nicht in Zeilen zerlegen (OR/Klammern aus der Webapp), startet der Editor
// im Roh-Modus, damit „Speichern" ihn nicht still ersetzt.
// Die Baukasten↔String-Logik steckt in core/utils/cookbook_query_filter.dart.
// ---------------------------------------------------------------------------

typedef QueryFilterOption = ({String id, String name});

/// Liest den aktuellen Filter-String aus einem [QueryFilterEditor].
class QueryFilterEditorController {
  _QueryFilterEditorState? _state;

  /// Aktueller Filter-String (Roh-Text oder aus den Zeilen gebaut).
  String compose() => _state?._compose() ?? '';
}

class QueryFilterEditor extends ConsumerStatefulWidget {
  final QueryFilterEditorController controller;
  final String initialFilter;

  /// Angebotene Felder (Standard: Kochbuch/Regeln; Rezept-Suche: alle).
  final List<CookbookFilterField> fields;

  /// Startet mit einer leeren Zeile, wenn noch kein Filter gesetzt ist.
  final bool startWithRow;

  const QueryFilterEditor({
    super.key,
    required this.controller,
    this.initialFilter = '',
    this.fields = kOrganizerFilterFields,
    this.startWithRow = false,
  });

  @override
  ConsumerState<QueryFilterEditor> createState() => _QueryFilterEditorState();
}

class _QueryFilterEditorState extends ConsumerState<QueryFilterEditor> {
  final _rawFilterCtrl = TextEditingController();
  bool _rawMode = false;
  List<CookbookFilterRow> _rows = [];

  final Map<CookbookFilterField, List<QueryFilterOption>> _options = {};
  bool _optionsLoading = true;

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
    _loadOptions();
    final initial = widget.initialFilter;
    _rawFilterCtrl.text = initial;
    final parsed = tryParseCookbookQueryFilter(initial);
    if (parsed == null) {
      // Nicht in unserem einfachen AND-Format → Roh-Modus, damit „Speichern"
      // ihn nicht durch einen (falsch) neu zusammengesetzten String ersetzt.
      _rawMode = initial.trim().isNotEmpty;
    } else {
      // CONTAINS ALL auf Haushalt/Benutzer normalisieren — kann nur aus dem
      // Roh-Modus oder außerhalb der App gesetzt worden sein (die Zeilen-UI
      // bietet den Operator dort gar nicht an).
      for (final row in parsed) {
        if (!kMultiValueFields.contains(row.field) &&
            row.op == CookbookFilterOp.containsAll) {
          row.op = CookbookFilterOp.isOneOf;
        }
      }
      _rows = parsed;
      if (_rows.isEmpty && widget.startWithRow) _rows = [_newRow()];
    }
  }

  CookbookFilterRow _newRow() =>
      CookbookFilterRow()..setField(widget.fields.first);

  @override
  void didUpdateWidget(covariant QueryFilterEditor old) {
    super.didUpdateWidget(old);
    if (!identical(old.controller, widget.controller)) {
      old.controller._state = null;
      widget.controller._state = this;
    }
  }

  @override
  void dispose() {
    if (identical(widget.controller._state, this)) {
      widget.controller._state = null;
    }
    _rawFilterCtrl.dispose();
    super.dispose();
  }

  String _compose() =>
      _rawMode ? _rawFilterCtrl.text.trim() : composeCookbookQueryFilter(_rows);

  // Alle sechs Wertelisten parallel laden — jede EINZELN abgesichert, damit
  // ein fehlender/anderer Endpoint (z. B. „Benutzer") nicht den ganzen
  // Screen blockiert. Fehlgeschlagene Dimensionen bleiben mit leerer Liste
  // nutzbar (Wertauswahl zeigt dann einen Hinweis statt Optionen).
  Future<void> _loadOptions() async {
    // Cache-first: die Listen kommen aus den geteilten, gecachten Providern
    // (Organizer, Lebensmittel, Haushalte, Mitglieder) — auch offline
    // auswählbar; der Hintergrund-Abgleich läuft dort.
    Future<List<QueryFilterOption>> safe(
        Future<List<QueryFilterOption>> Function() f) async {
      try {
        return await f();
      } catch (e) {
        LogManager.shared.log('⚠️ Kochbuch-Filteroptionen: $e');
        return const [];
      }
    }

    Future<List<QueryFilterOption>> organizers(OrganizerKind kind) async =>
        (await ref.read(organizersProvider(kind).future))
            .map((c) => (id: c.id, name: c.name))
            .toList();

    List<QueryFilterOption> named(
            List<Map<String, dynamic>> raw, String Function(Map) name) =>
        raw
            .map((m) => (id: (m['id'] as String?) ?? '', name: name(m)))
            .where((o) => o.id.isNotEmpty && o.name.isNotEmpty)
            .toList();

    final results = await Future.wait([
      safe(() => organizers(OrganizerKind.category)),
      safe(() => organizers(OrganizerKind.tag)),
      safe(() async => named(
          await ref.read(foodsUnitsAdminProvider(FoodUnitKind.food).future),
          (f) => (f['name'] as String?)?.trim() ?? '')),
      safe(() => organizers(OrganizerKind.tool)),
      safe(() async => named(await ref.read(householdsListProvider.future),
          (h) => (h['name'] as String?)?.trim() ?? '')),
      safe(() async => named(
          await ref.read(householdMembersProvider.future),
          (m) => ((m['fullName'] as String?)?.trim().isNotEmpty ?? false)
              ? (m['fullName'] as String).trim()
              : ((m['username'] as String?)?.trim() ?? ''))),
      safe(() async => [
            for (final lb in await ref.read(shoppingLabelsProvider.future))
              (id: lb.id, name: lb.name),
          ]),
    ]);

    if (!mounted) return;
    setState(() {
      _options[CookbookFilterField.category] = results[0];
      _options[CookbookFilterField.tag] = results[1];
      _options[CookbookFilterField.food] = results[2];
      _options[CookbookFilterField.tool] = results[3];
      _options[CookbookFilterField.household] = results[4];
      _options[CookbookFilterField.user] = results[5];
      _options[CookbookFilterField.foodLabel] = results[6];
      _optionsLoading = false;
    });
  }

  String _fieldLabel(AppLocalizations l, CookbookFilterField f) => switch (f) {
        CookbookFilterField.category => l.categories,
        CookbookFilterField.tag => l.tags,
        CookbookFilterField.food => l.ingredientName,
        CookbookFilterField.tool => l.cookbookFieldTools,
        CookbookFilterField.household => l.householdId,
        CookbookFilterField.user => l.cookbookFieldUsers,
        CookbookFilterField.foodLabel => l.foodLabelLabel,
        CookbookFilterField.lastMade => l.lastCooked,
        CookbookFilterField.rating => l.rating,
        CookbookFilterField.totalTime => l.totalTimeLabel,
      };

  String _opLabel(
          AppLocalizations l, CookbookFilterField f, CookbookFilterOp op) =>
      switch (op) {
        CookbookFilterOp.isOneOf => l.cookbookOpIsOneOf,
        CookbookFilterOp.isNotOneOf => l.cookbookOpIsNotOneOf,
        CookbookFilterOp.containsAll => l.cookbookOpContainsAll,
        CookbookFilterOp.eq => l.qfOpEquals,
        CookbookFilterOp.ne => l.qfOpNotEquals,
        CookbookFilterOp.gt => l.qfOpGreater,
        CookbookFilterOp.lt => l.qfOpLess,
        // „Zuletzt gemacht": ≤ heißt bei Mealie „ist älter als", ≥ „neuer".
        CookbookFilterOp.gte =>
          f == CookbookFilterField.lastMade ? l.qfOpNewerThan : l.qfOpGreaterEq,
        CookbookFilterOp.lte =>
          f == CookbookFilterField.lastMade ? l.qfOpOlderThan : l.qfOpLessEq,
      };

  String _valueSummary(CookbookFilterRow row) {
    final opts = _options[row.field] ?? const [];
    final names = [
      for (final id in row.valueIds)
        opts
            .firstWhere((o) => o.id == id, orElse: () => (id: id, name: id))
            .name,
    ];
    return names.join(', ');
  }

  Future<void> _pickValues(CookbookFilterRow row) async {
    final l = AppLocalizations.of(context)!;
    final opts = _options[row.field] ?? const [];
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      backgroundColor: context.appCard,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => _ValuePickerSheet(
        title: _fieldLabel(l, row.field),
        options: opts,
        selectedIds: row.valueIds,
        emptyHint: l.cookbookFilterOptionsUnavailable,
      ),
    );
    if (result == null) return;
    setState(() => row.valueIds = result);
  }

  void _addRow() {
    setState(() => _rows.add(_newRow()));
  }

  void _removeRow(int index) {
    setState(() => _rows.removeAt(index));
  }

  void _toggleRawMode(bool raw) {
    final l = AppLocalizations.of(context)!;
    if (raw) {
      // In den Roh-Modus: aktuellen Baukasten-Stand als Text zeigen.
      _rawFilterCtrl.text = composeCookbookQueryFilter(_rows);
      setState(() => _rawMode = true);
      return;
    }
    // Zurück zum Baukasten: nur wechseln, wenn der Text unser Format ist.
    final parsed = tryParseCookbookQueryFilter(_rawFilterCtrl.text);
    if (parsed == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.cookbookRawModeUnparseable)));
      return;
    }
    setState(() {
      _rows = parsed;
      _rawMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sicherheitsnetz-Modus dieser App (kein Webapp-Original) —
        // siehe Datei-Kopfkommentar.
        // Eigene Zeile statt neben dem Titel: bei schmalen Phone-Breiten
        // reichte die Zeilenbreite nicht für Titel + Button-Label
        // gleichzeitig — der Button lief rechts aus dem Bildschirm
        // (RenderFlex-Overflow, sichtbar abgeschnitten). Volle Breite
        // hier hat immer genug Platz, auf Tablet wie auf Phone.
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _toggleRawMode(!_rawMode),
            icon: Icon(_rawMode ? Icons.list_alt_rounded : Icons.code_rounded,
                size: 18),
            label:
                Text(_rawMode ? l.cookbookRawModeExit : l.cookbookRawModeEnter),
          ),
        ),
        const SizedBox(height: 8),

        if (_rawMode) ...[
          TextFormField(
            controller: _rawFilterCtrl,
            decoration: const InputDecoration(
              hintText: 'recipe_category.id IN ["…"]',
              border: OutlineInputBorder(),
            ),
            minLines: 3,
            maxLines: 6,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(l.cookbookRawModeHint,
              style: TextStyle(color: context.appFgSub, fontSize: 12)),
        ] else ...[
          if (_optionsLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))),
            ),
          ...List.generate(
              _rows.length,
              (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _FilterRowCard(
                      row: _rows[i],
                      l: l,
                      fields: widget.fields,
                      fieldLabel: (f) => _fieldLabel(l, f),
                      opLabel: (op) => _opLabel(l, _rows[i].field, op),
                      valueSummary: _valueSummary(_rows[i]),
                      optionsAvailable:
                          (_options[_rows[i].field] ?? const []).isNotEmpty,
                      onFieldChanged: (f) =>
                          setState(() => _rows[i].setField(f)),
                      onNumberChanged: (v) =>
                          setState(() => _rows[i].number = v),
                      onOpChanged: (op) => setState(() => _rows[i].op = op),
                      onValueTap: () => _pickValues(_rows[i]),
                      onDelete: () => _removeRow(i),
                    ),
                  )),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: _addRow,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(l.cookbookAddFilterField),
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Eine Filter-Zeile: [Feld] [Operator] [Werte-Zusammenfassung] [Löschen].
// ---------------------------------------------------------------------------

class _FilterRowCard extends StatelessWidget {
  final CookbookFilterRow row;
  final AppLocalizations l;
  final List<CookbookFilterField> fields;
  final ValueChanged<int> onNumberChanged;
  final String Function(CookbookFilterField) fieldLabel;
  final String Function(CookbookFilterOp) opLabel;
  final String valueSummary;
  final bool optionsAvailable;
  final ValueChanged<CookbookFilterField> onFieldChanged;
  final ValueChanged<CookbookFilterOp> onOpChanged;
  final VoidCallback onValueTap;
  final VoidCallback onDelete;

  const _FilterRowCard({
    required this.row,
    required this.l,
    required this.fields,
    required this.onNumberChanged,
    required this.fieldLabel,
    required this.opLabel,
    required this.valueSummary,
    required this.optionsAvailable,
    required this.onFieldChanged,
    required this.onOpChanged,
    required this.onValueTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ops = opsForField(row.field);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(AppTokens.rMd),
        border: Border.all(color: context.appSeparator, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<CookbookFilterField>(
                  initialValue: row.field,
                  isExpanded: true,
                  decoration: const InputDecoration(
                      isDense: true, border: OutlineInputBorder()),
                  items: [
                    ...fields,
                    // Geladener Filter mit einem hier nicht angebotenen Feld.
                    if (!fields.contains(row.field)) row.field,
                  ]
                      .map((f) => DropdownMenuItem(
                          value: f, child: Text(fieldLabel(f))))
                      .toList(),
                  onChanged: (f) {
                    if (f != null) onFieldChanged(f);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                color: Colors.red,
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<CookbookFilterOp>(
            initialValue: ops.contains(row.op) ? row.op : ops.first,
            isExpanded: true,
            decoration: const InputDecoration(
                isDense: true, border: OutlineInputBorder()),
            items: ops
                .map((op) =>
                    DropdownMenuItem(value: op, child: Text(opLabel(op))))
                .toList(),
            onChanged: (op) {
              if (op != null) onOpChanged(op);
            },
          ),
          const SizedBox(height: 8),
          if (row.isScalar)
            _NumberValue(row: row, l: l, onChanged: onNumberChanged)
          else
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onValueTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: context.appSurface2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        row.valueIds.isEmpty
                            ? (optionsAvailable
                                ? l.cookbookSelectValues
                                : l.cookbookFilterOptionsUnavailable)
                            : valueSummary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: row.valueIds.isEmpty
                                ? context.appFgSub
                                : context.appFg),
                      ),
                    ),
                    Icon(Icons.unfold_more, size: 18, color: context.appFgSub),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Zahlenwert einer Zeile: Bewertung (0–5), „vor N Tagen", Minuten.
// ---------------------------------------------------------------------------

class _NumberValue extends StatefulWidget {
  final CookbookFilterRow row;
  final AppLocalizations l;
  final ValueChanged<int> onChanged;
  const _NumberValue(
      {required this.row, required this.l, required this.onChanged});

  @override
  State<_NumberValue> createState() => _NumberValueState();
}

class _NumberValueState extends State<_NumberValue> {
  late final _ctrl = TextEditingController(text: '${widget.row.number ?? ''}');

  @override
  void didUpdateWidget(covariant _NumberValue old) {
    super.didUpdateWidget(old);
    final text = '${widget.row.number ?? ''}';
    if (_ctrl.text != text && int.tryParse(_ctrl.text) != widget.row.number) {
      _ctrl.text = text;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _set(int v) {
    final max = widget.row.field == CookbookFilterField.rating ? 5 : 99999;
    final clamped = v.clamp(0, max);
    _ctrl.text = '$clamped';
    widget.onChanged(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final row = widget.row;
    final n = row.number ?? 0;
    final suffix = switch (row.field) {
      CookbookFilterField.lastMade => widget.l.qfDaysAgo(n),
      CookbookFilterField.totalTime => 'min',
      _ => '★',
    };
    final step = row.field == CookbookFilterField.totalTime ? 5 : 1;
    return Row(children: [
      IconButton(
        onPressed: n > 0 ? () => _set(n - step) : null,
        icon: const Icon(Icons.remove_circle_outline_rounded),
      ),
      SizedBox(
        width: 70,
        child: TextField(
          controller: _ctrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
              isDense: true, border: OutlineInputBorder()),
          onChanged: (v) {
            final parsed = int.tryParse(v.trim());
            if (parsed != null) widget.onChanged(parsed);
          },
        ),
      ),
      IconButton(
        onPressed: () => _set(n + step),
        icon: const Icon(Icons.add_circle_outline_rounded),
      ),
      const SizedBox(width: 4),
      Expanded(
        child: Text(suffix, style: TextStyle(color: context.appFgSub)),
      ),
    ]);
  }
}

// ---------------------------------------------------------------------------
// Mehrfachauswahl-Sheet für den Werte-Slot einer Filter-Zeile — mit
// Suchfeld, damit auch lange Listen (Zutaten!) nutzbar bleiben.
// ---------------------------------------------------------------------------

class _ValuePickerSheet extends StatefulWidget {
  final String title;
  final List<QueryFilterOption> options;
  final List<String> selectedIds;
  final String emptyHint;

  const _ValuePickerSheet({
    required this.title,
    required this.options,
    required this.selectedIds,
    required this.emptyHint,
  });

  @override
  State<_ValuePickerSheet> createState() => _ValuePickerSheetState();
}

class _ValuePickerSheetState extends State<_ValuePickerSheet> {
  late Set<String> _selected;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedIds.toSet();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final query = _searchCtrl.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? widget.options
        : widget.options
            .where((o) => o.name.toLowerCase().contains(query))
            .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            if (widget.options.length > 6)
              TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: l.search,
                  prefixIcon: const Icon(Icons.search_rounded),
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: widget.options.isEmpty
                  ? Center(
                      child: Text(widget.emptyHint,
                          style: TextStyle(color: context.appFgSub)))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final o = filtered[i];
                        final sel = _selected.contains(o.id);
                        return CheckboxListTile(
                          value: sel,
                          title: Text(o.name),
                          onChanged: (v) => setState(() {
                            if (v ?? false) {
                              _selected.add(o.id);
                            } else {
                              _selected.remove(o.id);
                            }
                          }),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, _selected.toList()),
                    child: Text(l.apply),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
