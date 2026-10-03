import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/cached_json_list.dart';
import '../../../core/utils/ingredient_parse.dart';
import '../../../core/utils/search_match.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../models/recipe_draft.dart';
import 'edit_common.dart';

// ---------------------------------------------------------------------------
// Auswahl-Sheets des Editors: Unterrezept, Besitzer, Zutaten-Parser.
// ---------------------------------------------------------------------------

/// Rezept als Zutat verknüpfen (Webapp „Rezept ein/aus"): Auswahl aus den
/// lokal bekannten Rezepten (offline verfügbar), ohne das Rezept selbst.
Future<Map<String, dynamic>?> showRecipePickerSheet(BuildContext context,
    {required String excludeId}) {
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.appCard,
    builder: (_) => _RecipePickerSheet(excludeId: excludeId),
  );
}

class _RecipePickerSheet extends ConsumerStatefulWidget {
  final String excludeId;
  const _RecipePickerSheet({required this.excludeId});

  @override
  ConsumerState<_RecipePickerSheet> createState() => _RecipePickerSheetState();
}

class _RecipePickerSheetState extends ConsumerState<_RecipePickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final all =
        ref.watch(recipesProvider).valueOrNull ?? const <RecipeDetail>[];
    final terms = searchTerms(_query);
    final list = all
        .where((r) => r.id != widget.excludeId)
        .where((r) =>
            terms.isEmpty || terms.every(normalizeForSearch(r.name).contains))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: Column(
        children: [
          EditSheetHeader(
              icon: Icons.menu_book_rounded, title: l.linkRecipeAction),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              autofocus: false,
              onChanged: (v) => setState(() => _query = v),
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              decoration: filledEditDecoration(context, hint: l.searchRecipes)
                  .copyWith(
                      prefixIcon:
                          Icon(Icons.search_rounded, color: context.appFgSub)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) {
                final r = list[i];
                return ListTile(
                  leading: const Icon(Icons.menu_book_rounded,
                      color: AppTokens.accentDeep),
                  title: Text(r.name, style: TextStyle(color: context.appFg)),
                  onTap: () => Navigator.pop(
                      context, {'id': r.id, 'slug': r.slug, 'name': r.name}),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Besitzer des Rezepts wählen (Benutzer der Gruppe).
Future<String?> showOwnerPickerSheet(BuildContext context,
    {required String? selectedId}) {
  return showModalBottomSheet<String>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.appCard,
    builder: (_) => _OwnerPickerSheet(selectedId: selectedId),
  );
}

String memberName(Map<String, dynamic> u) {
  final full = (u['fullName'] as String?)?.trim() ?? '';
  return full.isNotEmpty ? full : (u['username'] as String?)?.trim() ?? '';
}

class _OwnerPickerSheet extends ConsumerWidget {
  final String? selectedId;
  const _OwnerPickerSheet({required this.selectedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final async = ref.watch(groupMembersProvider);
    final members = [...(async.valueOrNull ?? const <Map<String, dynamic>>[])]
      ..sort((a, b) =>
          memberName(a).toLowerCase().compareTo(memberName(b).toLowerCase()));
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.75),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EditSheetHeader(icon: Icons.person_rounded, title: l.ownerLabel),
          if (async.isLoading && members.isEmpty)
            const Padding(
                padding: EdgeInsets.all(24), child: CircularProgressIndicator())
          else if (members.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                  async.hasError
                      ? (mealieErrorMessage(async.error!) ?? l.saveFailed)
                      : '—',
                  style: TextStyle(color: context.appFgSub)),
            )
          else
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final u in members)
                    ListTile(
                      leading: UserAvatar(
                        userId: u['id']?.toString(),
                        name: memberName(u),
                        radius: 18,
                        cacheKey: u['cacheKey']?.toString(),
                      ),
                      title: Text(memberName(u),
                          style: TextStyle(color: context.appFg)),
                      subtitle: (u['username'] as String?) != null
                          ? Text('@${u['username']}',
                              style: TextStyle(
                                  color: context.appFgSub, fontSize: 12))
                          : null,
                      trailing: u['id'] == selectedId
                          ? const Icon(Icons.check_rounded,
                              color: AppTokens.accentDeep)
                          : null,
                      onTap: () => Navigator.pop(context, u['id']?.toString()),
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Zutaten-Parser (Webapp „Parsen"): Mealie-Parser (NLP / Brute / OpenAI) oder
// der App-eigene Offline-Parser; Ergebnisse prüfen, dann übernehmen.
// ---------------------------------------------------------------------------

enum IngredientParser { nlp, brute, openai, app }

class ParsedIngredientLine {
  final DraftIngredient target;
  final String input;
  final String quantity;
  final Map<String, dynamic>? unit;
  final Map<String, dynamic>? food;
  final String note;

  /// 0…1, `null` beim App-Parser.
  final double? confidence;

  /// Server konnte diese Zeile nicht parsen — wird nicht übernommen.
  final bool failed;
  bool selected;

  ParsedIngredientLine({
    required this.target,
    required this.input,
    required this.quantity,
    required this.unit,
    required this.food,
    required this.note,
    required this.confidence,
    this.failed = false,
  }) : selected = !failed;

  factory ParsedIngredientLine.failed(DraftIngredient target, String input) =>
      ParsedIngredientLine(
        target: target,
        input: input,
        quantity: '',
        unit: null,
        food: null,
        note: '',
        confidence: null,
        failed: true,
      );

  String get unitName => (unit?['name'] ?? '').toString().trim();
  String get foodName => (food?['name'] ?? '').toString().trim();

  /// Noch nicht auf dem Server vorhanden (wird beim Speichern angelegt).
  bool get newUnit => unit != null && unit!['id'] == null;
  bool get newFood => food != null && food!['id'] == null;

  /// In die Zutat übernehmen (Abschnitt, Verknüpfungen, Alternativen und
  /// alle übrigen Felder bleiben erhalten).
  void apply() {
    target.quantity.text = quantity;
    target.unit.text = unitName;
    target.food.text = foodName;
    target.note.text = note;
    target.resolvedUnit = unit?['id'] != null ? unit : null;
    target.resolvedFood = food?['id'] != null ? food : null;
  }
}

Future<bool?> showIngredientParseSheet(
  BuildContext context, {
  required List<DraftIngredient> ingredients,
  required List<Map<String, dynamic>> unitsRaw,
  required Map<String, dynamic>? Function(String name) findFood,
  required Map<String, dynamic>? Function(String name) findUnit,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.appCard,
    builder: (_) => _ParseSheet(
      ingredients: ingredients,
      unitsRaw: unitsRaw,
      findFood: findFood,
      findUnit: findUnit,
    ),
  );
}

class _ParseSheet extends ConsumerStatefulWidget {
  final List<DraftIngredient> ingredients;
  final List<Map<String, dynamic>> unitsRaw;
  final Map<String, dynamic>? Function(String name) findFood;
  final Map<String, dynamic>? Function(String name) findUnit;

  const _ParseSheet({
    required this.ingredients,
    required this.unitsRaw,
    required this.findFood,
    required this.findUnit,
  });

  @override
  ConsumerState<_ParseSheet> createState() => _ParseSheetState();
}

class _ParseSheetState extends ConsumerState<_ParseSheet> {
  // Wie die Webapp: NLP ist auf Englisch trainiert — sonst Brute als Start.
  late IngredientParser _parser =
      Localizations.localeOf(context).languageCode == 'en'
          ? IngredientParser.nlp
          : IngredientParser.brute;
  List<ParsedIngredientLine>? _results;
  bool _busy = false;
  String? _error;

  /// Unstrukturierte Zutaten; gibt es keine, alle (außer Unterrezepten) —
  /// wie „Parsen" in der Webapp.
  List<DraftIngredient> get _targets {
    final unparsed = widget.ingredients.where((i) => i.isUnparsed).toList();
    if (unparsed.isNotEmpty) return unparsed;
    return widget.ingredients
        .where((i) => i.linkedRecipe == null && i.parserInput.isNotEmpty)
        .toList();
  }

  Future<void> _run() async {
    final targets = _targets;
    if (targets.isEmpty) return;
    setState(() {
      _busy = true;
      _error = null;
      _results = null;
    });
    final inputs = [for (final t in targets) t.parserInput];
    try {
      final List<ParsedIngredientLine> lines;
      if (_parser == IngredientParser.app) {
        final lookup = buildUnitLookup(widget.unitsRaw);
        lines = [
          for (var i = 0; i < targets.length; i++)
            () {
              final p = splitIngredientNote(inputs[i], lookup);
              final hasSplit = p.unit.isNotEmpty || p.quantity.isNotEmpty;
              return ParsedIngredientLine(
                target: targets[i],
                input: inputs[i],
                quantity: hasSplit
                    ? formatDraftQuantity(parseDraftQuantity(p.quantity))
                    : targets[i].quantity.text,
                unit: p.unit.isEmpty
                    ? null
                    : (widget.findUnit(p.unit) ?? {'name': p.unit}),
                food: hasSplit && p.food.isNotEmpty
                    ? (widget.findFood(p.food) ?? {'name': p.food})
                    : null,
                note: hasSplit ? '' : targets[i].note.text,
                confidence: null,
              )..selected = hasSplit;
            }()
        ];
      } else {
        final api = ref.read(apiServiceProvider);
        final parser = _parser.name;
        List<Map<String, dynamic>?> res;
        try {
          final all = await api.parseIngredients(inputs, parser: parser);
          res = [
            for (var i = 0; i < inputs.length; i++)
              i < all.length ? all[i] : null
          ];
        } catch (e) {
          // Eine einzige problematische Zeile lässt den Server die ganze
          // Liste ablehnen (Mealies Brute-Parser stürzt bei manchen Texten
          // ab) → Zeile für Zeile, nicht erkannte werden markiert.
          Object firstError = e;
          var anyOk = false;
          res = [];
          for (final input in inputs) {
            try {
              res.add(await api.parseIngredient(input, parser: parser));
              anyOk = true;
            } catch (_) {
              res.add(null);
            }
          }
          if (!anyOk) throw firstError;
        }
        lines = [
          for (var i = 0; i < targets.length; i++)
            () {
              final r = res[i];
              if (r == null) {
                return ParsedIngredientLine.failed(targets[i], inputs[i]);
              }
              final ing = r['ingredient'] is Map
                  ? Map<String, dynamic>.from(r['ingredient'] as Map)
                  : <String, dynamic>{};
              Map<String, dynamic>? obj(dynamic v, bool unit) {
                if (v is! Map) return null;
                final m = Map<String, dynamic>.from(v);
                final name = (m['name'] ?? '').toString().trim();
                if (name.isEmpty) return null;
                if (m['id'] != null) return m;
                // Parser kennt es nicht → evtl. doch im Katalog (anderer
                // Fall), sonst beim Speichern neu anlegen.
                return (unit ? widget.findUnit(name) : widget.findFood(name)) ??
                    {'name': name};
              }

              final conf = r['confidence'];
              return ParsedIngredientLine(
                target: targets[i],
                input: inputs[i],
                quantity: formatDraftQuantity(ing['quantity'] as num?),
                unit: obj(ing['unit'], true),
                food: obj(ing['food'], false),
                note: (ing['note'] ?? '').toString().trim(),
                confidence:
                    conf is Map ? (conf['average'] as num?)?.toDouble() : null,
              );
            }()
        ];
      }
      if (!mounted) return;
      setState(() {
        _results = lines;
        _busy = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        final status = e is DioException ? e.response?.statusCode : null;
        _error = mealieErrorMessage(e) ??
            [
              AppLocalizations.of(context)!.parseFailed,
              if (status != null) '(HTTP $status)',
            ].join(' ');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final info = ref.watch(serverInfoProvider).valueOrNull;
    final openai =
        info != null && info.isNotEmpty && info.first['enableOpenai'] == true;
    final parsers = [
      IngredientParser.nlp,
      IngredientParser.brute,
      if (openai) IngredientParser.openai,
      IngredientParser.app,
    ];
    String label(IngredientParser p) => switch (p) {
          IngredientParser.nlp => l.parserNlp,
          IngredientParser.brute => l.parserBrute,
          IngredientParser.openai => l.parserOpenai,
          IngredientParser.app => l.parserApp,
        };
    final results = _results;
    final selected = results?.where((r) => r.selected).length ?? 0;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EditSheetHeader(
              icon: Icons.auto_fix_high, title: l.ingredientParserTitle),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(l.ingredientParserHint(_targets.length),
                style: TextStyle(color: context.appFgSub, fontSize: 13)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final p in parsers)
                  ChoiceChip(
                    label: Text(label(p)),
                    selected: _parser == p,
                    onSelected: _busy
                        ? null
                        : (_) => setState(() {
                              _parser = p;
                              _results = null;
                            }),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _busy
                ? const Center(child: CircularProgressIndicator())
                : results == null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: _error != null
                              ? Text(_error!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red))
                              : Icon(Icons.auto_fix_high,
                                  size: 48, color: context.appFgTertiary),
                        ),
                      )
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (_, i) => _ParsedTile(
                          line: results[i],
                          onChanged: (v) =>
                              setState(() => results[i].selected = v),
                        ),
                      ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                16, 8, 16, 16 + MediaQuery.paddingOf(context).bottom),
            child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: AppTokens.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: _busy || _targets.isEmpty
                  ? null
                  : results == null
                      ? _run
                      : selected == 0
                          ? null
                          : () {
                              for (final r in results) {
                                if (r.selected) r.apply();
                              }
                              Navigator.pop(context, true);
                            },
              child: Text(results == null
                  ? l.parseAction
                  : l.applyParsedCount(selected)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParsedTile extends StatelessWidget {
  final ParsedIngredientLine line;
  final ValueChanged<bool> onChanged;
  const _ParsedTile({required this.line, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    Widget part(String label, String value, {bool isNew = false}) {
      if (value.isEmpty) return const SizedBox.shrink();
      return Container(
        margin: const EdgeInsets.only(right: 6, top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isNew
              ? AppTokens.accent.withValues(alpha: 0.15)
              : context.appSurface2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text.rich(TextSpan(children: [
          TextSpan(
              text: '$label ',
              style: TextStyle(color: context.appFgTertiary, fontSize: 11)),
          TextSpan(
              text: value,
              style: TextStyle(
                  color: context.appFg,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          if (isNew)
            TextSpan(
                text: '  ${l.parsedNewBadge}',
                style: const TextStyle(
                    color: AppTokens.accentDeep,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
        ])),
      );
    }

    final conf = line.confidence;
    return CheckboxListTile(
      value: line.selected,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: line.failed ? null : (v) => onChanged(v ?? false),
      title: Row(children: [
        Expanded(
          child: Text(line.input,
              style: TextStyle(color: context.appFgSub, fontSize: 13)),
        ),
        if (conf != null)
          Text('${(conf * 100).round()} %',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: conf >= 0.75
                      ? Colors.green
                      : conf >= 0.5
                          ? Colors.orange
                          : Colors.red)),
      ]),
      subtitle: line.failed
          ? Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(l.parseLineFailed,
                  style: const TextStyle(color: Colors.red, fontSize: 12)),
            )
          : Wrap(children: [
              part(l.ingredientQuantity, line.quantity),
              part(l.ingredientUnit, line.unitName, isNew: line.newUnit),
              part(l.ingredientName, line.foodName, isNew: line.newFood),
              part(l.ingredientNote, line.note),
            ]),
    );
  }
}
