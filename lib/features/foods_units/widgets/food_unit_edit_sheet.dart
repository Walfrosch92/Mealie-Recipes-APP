import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/utils/search_match.dart';
import '../../../shared/theme/app_colors.dart';
import '../../organizers/providers/organizers_provider.dart'
    show ownHouseholdSlugProvider;
import '../../shopping_list/providers/shopping_list_provider.dart'
    show shoppingLabelsProvider;
import '../../shopping_list/screens/shopping_list_screen.dart'
    show shoppingCategoryColor;
import '../providers/foods_units_admin_provider.dart';
import '../screens/labels_screen.dart' show createLabelInteractive;

// ---------------------------------------------------------------------------
// Lebensmittel / Einheit bearbeiten oder anlegen — alle Felder der Mealie-
// Webapp („Daten verwalten"). Liefert das zu speichernde Objekt: bei
// Bestehenden der VOLLE Server-Stand mit den Änderungen (PUT ersetzt alles).
//
// Felder, die erst neuere Mealie-Versionen kennen (Ersatzprodukte,
// Standardisierung von Einheiten), werden nur gezeigt, wenn der Server sie
// liefert ([supportsSubstitutions] / [supportsStandardization]).
// ---------------------------------------------------------------------------

/// Dropdown-Wert für „+ Neue Bezeichnung" (kein echtes Label).
const _kNewLabel = '__new_label__';

/// Mealies Standardeinheiten für Umrechnungen (StandardizedUnitType).
const kStandardUnits = [
  'milliliter',
  'liter',
  'gram',
  'kilogram',
  'fluid_ounce',
  'cup',
  'ounce',
  'pound',
];

String standardUnitLabel(AppLocalizations l, String v) => switch (v) {
      'fluid_ounce' => l.stdFluidOunce,
      'cup' => l.stdCup,
      'ounce' => l.stdOunce,
      'pound' => l.stdPound,
      'milliliter' => l.stdMilliliter,
      'liter' => l.stdLiter,
      'gram' => l.stdGram,
      'kilogram' => l.stdKilogram,
      _ => v,
    };

Future<Map<String, dynamic>?> showFoodUnitEditSheet(
  BuildContext context, {
  required FoodUnitKind kind,
  Map<String, dynamic>? item,
  required List<Map<String, dynamic>> allItems,
}) {
  bool has(String key) => allItems.any((m) => m.containsKey(key));
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.appCard,
    builder: (_) => _FoodUnitEditSheet(
      kind: kind,
      item: item,
      allItems: allItems,
      supportsSubstitutions: has('substitutions'),
      supportsStandardization: has('standardUnit'),
    ),
  );
}

class _FoodUnitEditSheet extends ConsumerStatefulWidget {
  final FoodUnitKind kind;
  final Map<String, dynamic>? item;
  final List<Map<String, dynamic>> allItems;
  final bool supportsSubstitutions;
  final bool supportsStandardization;

  const _FoodUnitEditSheet({
    required this.kind,
    required this.item,
    required this.allItems,
    required this.supportsSubstitutions,
    required this.supportsStandardization,
  });

  @override
  ConsumerState<_FoodUnitEditSheet> createState() => _FoodUnitEditSheetState();
}

class _Substitution {
  final String? foodId;
  final String? note;
  const _Substitution(this.foodId, this.note);
}

class _FoodUnitEditSheetState extends ConsumerState<_FoodUnitEditSheet> {
  late final _name = _ctrl('name');
  late final _plural = _ctrl('pluralName');
  late final _abbr = _ctrl('abbreviation');
  late final _pluralAbbr = _ctrl('pluralAbbreviation');
  late final _desc = _ctrl('description');
  late final _stdQty =
      TextEditingController(text: _fmtNum(widget.item?['standardQuantity']));
  final _aliasCtrl = TextEditingController();
  bool _nameError = false;

  Map<String, dynamic>? get _item => widget.item;
  bool get _isUnit => widget.kind == FoodUnitKind.unit;

  TextEditingController _ctrl(String key) =>
      TextEditingController(text: (_item?[key] as String?) ?? '');

  static String _fmtNum(dynamic v) {
    if (v is! num || v <= 0) return '';
    return v == v.roundToDouble() ? v.toInt().toString() : v.toString();
  }

  // ── Lebensmittel ──
  late String? _labelId = _item?['labelId'] as String?;

  /// Erzwingt einen Neuaufbau des Bezeichnungs-Dropdowns (nach „Neu").
  int _labelKey = 0;
  late final List<String> _households = [
    for (final h
        in (_item?['householdsWithIngredientFood'] as List?) ?? const [])
      h.toString(),
  ];
  late bool _legacyOnHand = _item?['onHand'] == true;
  bool get _usesHouseholdOnHand =>
      _item == null ||
      _item!.containsKey('householdsWithIngredientFood') ||
      !_item!.containsKey('onHand');
  late final List<_Substitution> _subs = [
    for (final s in (_item?['substitutions'] as List?) ?? const [])
      if (s is Map)
        _Substitution(
          (s['substituteFoodId'] ?? (s['substituteFood'] as Map?)?['id'])
              ?.toString(),
          (s['note'] as String?)?.trim(),
        ),
  ];

  // ── Einheiten ──
  late bool _useAbbr = _item?['useAbbreviation'] == true;
  late bool _fraction = (_item?['fraction'] as bool?) ?? true;
  late String? _stdUnit = _item?['standardUnit'] as String?;

  // ── beide ──
  late final List<String> _aliases = [
    for (final a in (_item?['aliases'] as List?) ?? const [])
      if (a is Map && (a['name'] as String?)?.trim().isNotEmpty == true)
        (a['name'] as String).trim(),
  ];

  @override
  void dispose() {
    for (final c in [
      _name,
      _plural,
      _abbr,
      _pluralAbbr,
      _desc,
      _stdQty,
      _aliasCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _addAlias() {
    final v = _aliasCtrl.text.trim();
    if (v.isEmpty) return;
    setState(() {
      if (!_aliases.contains(v)) _aliases.add(v);
      _aliasCtrl.clear();
    });
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = true);
      return;
    }
    final data = <String, dynamic>{
      ...?_item,
      'name': name,
      'pluralName': _plural.text.trim(),
      'description': _desc.text.trim(),
      'aliases': [
        for (final a in _aliases) {'name': a}
      ],
    };
    if (_isUnit) {
      data['abbreviation'] = _abbr.text.trim();
      data['pluralAbbreviation'] = _pluralAbbr.text.trim();
      data['useAbbreviation'] = _useAbbr;
      data['fraction'] = _fraction;
      if (widget.supportsStandardization) {
        final qty = double.tryParse(_stdQty.text.trim().replaceAll(',', '.'));
        final ok = _stdUnit != null && qty != null && qty > 0;
        data['standardQuantity'] = ok ? qty : null;
        data['standardUnit'] = ok ? _stdUnit : null;
      }
    } else {
      data['labelId'] = _labelId;
      data.remove('label'); // eingebettetes Objekt passt nach Wechsel nicht
      if (_usesHouseholdOnHand) {
        data['householdsWithIngredientFood'] = _households;
      } else {
        data['onHand'] = _legacyOnHand;
      }
      if (widget.supportsSubstitutions) {
        data['substitutions'] = [
          for (final s in _subs)
            {
              if (s.foodId != null) 'substituteFoodId': s.foodId,
              if ((s.note ?? '').isNotEmpty) 'note': s.note,
            },
        ];
      }
    }
    Navigator.pop(context, data);
  }

  // ── Bausteine ──

  Widget _field(TextEditingController c, String label,
          {bool autofocus = false,
          String? error,
          int maxLines = 1,
          TextInputType? keyboard}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          autofocus: autofocus,
          maxLines: maxLines,
          keyboardType: keyboard,
          textCapitalization: TextCapitalization.sentences,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          style: TextStyle(color: context.appFg),
          decoration: InputDecoration(
            labelText: label,
            errorText: error,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTokens.rSm)),
          ),
        ),
      );

  Widget _section(String title, {String? hint}) => Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: context.appFg,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            if (hint != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(hint,
                    style: TextStyle(color: context.appFgSub, fontSize: 12.5)),
              ),
          ],
        ),
      );

  Widget _switch(String title, String? subtitle, bool value,
          ValueChanged<bool> onChanged) =>
      SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: TextStyle(color: context.appFg)),
        subtitle: subtitle == null
            ? null
            : Text(subtitle,
                style: TextStyle(color: context.appFgSub, fontSize: 12.5)),
        value: value,
        activeTrackColor: AppTokens.accent,
        onChanged: onChanged,
      );

  List<Widget> _foodFields(AppLocalizations l) {
    final labels = ref.watch(shoppingLabelsProvider).valueOrNull ?? const [];
    final slug = ref.watch(ownHouseholdSlugProvider).valueOrNull;
    final known = labels.any((x) => x.id == _labelId);
    final onHand = _usesHouseholdOnHand
        ? (slug != null && _households.contains(slug))
        : _legacyOnHand;
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: DropdownButtonFormField<String?>(
          key: ValueKey('label-$_labelKey'),
          initialValue: known ? _labelId : null,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: l.foodLabelLabel,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTokens.rSm)),
          ),
          items: [
            DropdownMenuItem<String?>(value: null, child: Text(l.foodNoLabel)),
            DropdownMenuItem<String?>(
              value: _kNewLabel,
              child: Row(children: [
                const Icon(Icons.add_rounded,
                    size: 18, color: AppTokens.accentDeep),
                const SizedBox(width: 8),
                Text(l.newLabel,
                    style: const TextStyle(color: AppTokens.accentDeep)),
              ]),
            ),
            for (final lb in labels)
              DropdownMenuItem<String?>(
                value: lb.id,
                child: Row(children: [
                  CircleAvatar(
                      radius: 6,
                      backgroundColor:
                          shoppingCategoryColor(lb.color, lb.name)),
                  const SizedBox(width: 10),
                  Flexible(
                      child: Text(lb.name, overflow: TextOverflow.ellipsis)),
                ]),
              ),
          ],
          onChanged: (v) async {
            if (v != _kNewLabel) {
              setState(() => _labelId = v);
              return;
            }
            // Neue Bezeichnung anlegen und direkt auswählen.
            final created = await createLabelInteractive(context, ref);
            if (!mounted) return;
            setState(() {
              if (created != null) _labelId = created.id;
              _labelKey++; // Dropdown neu aufbauen (Auswahl-Anzeige)
            });
          },
        ),
      ),
      // „Vorrätig" braucht beim Haushalts-Modell den eigenen Slug.
      if (!_usesHouseholdOnHand || slug != null)
        _switch(l.foodOnHand, null, onHand, (v) {
          setState(() {
            if (!_usesHouseholdOnHand) {
              _legacyOnHand = v;
            } else if (v) {
              _households.add(slug!);
            } else {
              _households.remove(slug);
            }
          });
        }),
      const SizedBox(height: 4),
    ];
  }

  List<Widget> _unitFields(AppLocalizations l) => [
        _field(_abbr, l.abbreviationLabel),
        _field(_pluralAbbr, l.pluralAbbreviationLabel),
        _switch(l.useAbbreviationLabel, l.useAbbreviationHint, _useAbbr,
            (v) => setState(() => _useAbbr = v)),
        _switch(l.fractionLabel, l.fractionHint, _fraction,
            (v) => setState(() => _fraction = v)),
        if (widget.supportsStandardization) ...[
          _section(l.standardizationTitle, hint: l.standardizationHint),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 110,
                child: _field(_stdQty, l.standardQuantityLabel,
                    keyboard:
                        const TextInputType.numberWithOptions(decimal: true)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DropdownButtonFormField<String?>(
                    initialValue:
                        kStandardUnits.contains(_stdUnit) ? _stdUnit : null,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l.standardUnitLabel,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTokens.rSm)),
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                          value: null, child: Text(l.standardUnitNone)),
                      for (final u in kStandardUnits)
                        DropdownMenuItem<String?>(
                            value: u, child: Text(standardUnitLabel(l, u))),
                    ],
                    onChanged: (v) => setState(() => _stdUnit = v),
                  ),
                ),
              ),
            ],
          ),
        ],
      ];

  Widget _aliasEditor(AppLocalizations l) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _section(l.aliasesLabel),
          if (_aliases.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final a in _aliases)
                    InputChip(
                      label: Text(a),
                      onDeleted: () => setState(() => _aliases.remove(a)),
                    ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              controller: _aliasCtrl,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _addAlias(),
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              style: TextStyle(color: context.appFg),
              decoration: InputDecoration(
                hintText: l.aliasAddHint,
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTokens.rSm)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add_rounded),
                  tooltip: l.aliasAddHint,
                  onPressed: _addAlias,
                ),
              ),
            ),
          ),
        ],
      );

  String _foodName(String? id) {
    if (id == null) return '';
    for (final m in widget.allItems) {
      if (m['id'] == id) return foodUnitName(m);
    }
    return '';
  }

  Future<void> _addSubstitution(AppLocalizations l) async {
    final result = await showDialog<_Substitution>(
      context: context,
      builder: (_) => _SubstitutionDialog(
        foods: widget.allItems.where((m) => m['id'] != _item?['id']).toList(),
      ),
    );
    if (result != null) setState(() => _subs.add(result));
  }

  Widget _substitutionEditor(AppLocalizations l) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _section(l.substitutionsLabel),
          for (var i = 0; i < _subs.length; i++)
            Card(
              margin: const EdgeInsets.only(bottom: 6),
              color: context.appSurface2,
              elevation: 0,
              child: ListTile(
                dense: true,
                leading: const Icon(Icons.swap_horiz_rounded),
                title: Text(
                    [
                      _foodName(_subs[i].foodId),
                      _subs[i].note ?? '',
                    ].where((t) => t.isNotEmpty).join(' — '),
                    style: TextStyle(color: context.appFg)),
                trailing: IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => setState(() => _subs.removeAt(i)),
                ),
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _addSubstitution(l),
              icon: const Icon(Icons.add_rounded),
              label: Text(l.substitutionAddHint),
            ),
          ),
          const SizedBox(height: 6),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
              _item == null
                  ? (_isUnit ? l.newUnit : l.newFood)
                  : (_isUnit ? l.editUnit : l.editFood),
              style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: context.appFg,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _field(_name, l.name,
                      autofocus: _item == null,
                      error: _nameError ? l.required : null),
                  _field(_plural, l.pluralNameLabel),
                  if (_isUnit) ..._unitFields(l) else ..._foodFields(l),
                  _aliasEditor(l),
                  if (!_isUnit && widget.supportsSubstitutions)
                    _substitutionEditor(l),
                  _field(_desc, l.descriptionLabel, maxLines: 3),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: AppTokens.accent,
                padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: _submit,
            child: Text(_item == null ? l.add : l.save),
          ),
        ],
      ),
    );
  }
}

/// Ersatz hinzufügen: Lebensmittel (Suche) und/oder freie Notiz.
class _SubstitutionDialog extends StatefulWidget {
  final List<Map<String, dynamic>> foods;
  const _SubstitutionDialog({required this.foods});

  @override
  State<_SubstitutionDialog> createState() => _SubstitutionDialogState();
}

class _SubstitutionDialogState extends State<_SubstitutionDialog> {
  final _note = TextEditingController();
  final _search = TextEditingController();
  Map<String, dynamic>? _food;
  bool _error = false;

  @override
  void dispose() {
    _note.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final terms = searchTerms(_search.text);
    final matches = terms.isEmpty
        ? const <Map<String, dynamic>>[]
        : widget.foods
            .where((m) =>
                terms.every(normalizeForSearch(foodUnitName(m)).contains))
            .take(6)
            .toList();
    return AlertDialog(
      backgroundColor: context.appCard,
      title: Text(l.substitutionAddHint),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_food != null)
              InputChip(
                label: Text(foodUnitName(_food!)),
                onDeleted: () => setState(() => _food = null),
              )
            else ...[
              TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: l.substitutionFoodLabel,
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
              ),
              for (final m in matches)
                ListTile(
                  dense: true,
                  title: Text(foodUnitName(m)),
                  onTap: () => setState(() {
                    _food = m;
                    _error = false;
                  }),
                ),
            ],
            const SizedBox(height: 10),
            TextField(
              controller: _note,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => setState(() => _error = false),
              decoration: InputDecoration(
                labelText: l.substitutionNoteLabel,
                errorText: _error ? l.substitutionNeedOne : null,
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
            final note = _note.text.trim();
            if (_food == null && note.isEmpty) {
              setState(() => _error = true);
              return;
            }
            Navigator.pop(
                context,
                _Substitution(
                    _food?['id'] as String?, note.isEmpty ? null : note));
          },
          child: Text(l.add),
        ),
      ],
    );
  }
}
