import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/async_action_button.dart';
import '../widgets/tool_widgets.dart';

// ---------------------------------------------------------------------------
// Debug (Mealie /admin/debug/parser + /admin/debug/ai-providers):
// - Zutaten-Parser testen (nlp / brute / openai) inkl. Trefferquote je Feld
//   — wie die Webapp-Seite (>75 % grün, >60 % gelb, sonst rot).
// - KI-Anbieter testen (nur Admins): Gruppe + Anbieter wählen, optional ein
//   Testbild mitschicken; Mealie antwortet mit der Modell-Antwort.
// ---------------------------------------------------------------------------

const _examples = [
  '2 tbsp minced cilantro, leaves and stems',
  '1 large yellow onion, coarsely chopped',
  '1 1/2 tsp garam masala',
  '1 inch piece fresh ginger, (peeled and minced)',
  '2 cups mango chunks, (2 large mangoes) (fresh or frozen)',
];

class DebugScreen extends ConsumerStatefulWidget {
  const DebugScreen({super.key});

  @override
  ConsumerState<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends ConsumerState<DebugScreen> {
  // ── Parser ──
  final _ingredient = TextEditingController();
  String _parser = 'nlp';
  Map<String, dynamic>? _parsed;

  // ── KI ──
  List<Map<String, dynamic>>? _groups;
  String? _groupId;
  String? _providerId;
  ({List<int> bytes, String name})? _image;
  ({bool ok, String text})? _aiResult;

  @override
  void initState() {
    super.initState();
    if (ref.read(userPermissionsProvider).admin) _loadGroups();
  }

  @override
  void dispose() {
    _ingredient.dispose();
    super.dispose();
  }

  Future<void> _loadGroups() async {
    try {
      final g = await ref.read(apiServiceProvider).fetchAdminGroups();
      if (mounted) setState(() => _groups = g);
    } catch (e) {
      if (!mounted) return;
      setState(() => _groups = const []);
      showToolError(context, AppLocalizations.of(context)!.loadFailed, e);
    }
  }

  Future<void> _parse([String? text]) async {
    final l = AppLocalizations.of(context)!;
    if (text != null) _ingredient.text = text;
    final line = _ingredient.text.trim();
    if (line.isEmpty) return;
    try {
      final r = await ref
          .read(apiServiceProvider)
          .parseIngredient(line, parser: _parser);
      if (mounted) setState(() => _parsed = r);
    } catch (e) {
      if (mounted) showToolError(context, l.debugParseFailed, e);
    }
  }

  Future<void> _runAi() async {
    final l = AppLocalizations.of(context)!;
    final id = _providerId;
    if (id == null) return;
    setState(() => _aiResult = null);
    try {
      final r = await ref.read(apiServiceProvider).debugAiProvider(id,
          imageBytes: _image?.bytes, imageName: _image?.name);
      final ok = r['success'] == true;
      if (mounted) {
        setState(() => _aiResult = (
              ok: ok,
              text: r['response']?.toString() ??
                  (ok ? l.aiTestSucceeded : l.aiTestFailed)
            ));
      }
    } catch (e) {
      if (mounted) {
        setState(
            () => _aiResult = (ok: false, text: mealieErrorMessage(e) ?? '$e'));
      }
    }
  }

  List<Map<String, dynamic>> _providersOf(String? groupId) {
    final g = _groups?.firstWhere((x) => x['id']?.toString() == groupId,
        orElse: () => const {});
    final settings = g?['aiProviderSettings'];
    final list = settings is Map ? settings['providers'] : null;
    return [
      for (final p in (list is List ? list : const []))
        if (p is Map) Map<String, dynamic>.from(p)
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isAdmin = ref.watch(userPermissionsProvider).admin;
    return ToolPage(
      title: l.debugTitle,
      children: [
        _parserCard(l),
        if (isAdmin) _aiCard(l),
      ],
    );
  }

  Widget _parserCard(AppLocalizations l) {
    final parsed = _parsed;
    final ing = parsed?['ingredient'];
    final conf = parsed?['confidence'];
    String? pct(String key) {
      final v = conf is Map ? conf[key] : null;
      return v is num ? '${(v * 100).toStringAsFixed(0)} %' : null;
    }

    Color? color(String key) {
      final v = conf is Map ? conf[key] : null;
      if (v is! num) return null;
      final p = v * 100;
      if (p > 75) return const Color(0xFF2E9E57);
      if (p > 60) return AppTokens.accentDeep;
      return const Color(0xFFD9443A);
    }

    Widget field(String label, String value, String confKey) => Container(
          width: 200,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(AppTokens.rSm),
            border: Border.all(
                color: color(confKey) ?? context.appSeparator, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(color: context.appFgSub, fontSize: 12)),
              const SizedBox(height: 4),
              SelectableText(value.isEmpty ? '—' : value,
                  style: TextStyle(
                      color: context.appFg,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
              if (pct(confKey) != null)
                Text(pct(confKey)!,
                    style: TextStyle(
                        color: color(confKey),
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
            ],
          ),
        );

    String qty(dynamic v) {
      if (v is! num || v == 0) return '';
      return v == v.roundToDouble() ? v.toInt().toString() : v.toString();
    }

    return ToolCard(
      title: l.debugParserTitle,
      subtitle: l.debugParserDescription,
      icon: Icons.science_rounded,
      children: [
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'nlp', label: Text('NLP')),
            ButtonSegment(value: 'brute', label: Text('Brute')),
            ButtonSegment(value: 'openai', label: Text('OpenAI')),
          ],
          selected: {_parser},
          onSelectionChanged: (s) => setState(() => _parser = s.first),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _ingredient,
              onSubmitted: (_) => _parse(),
              decoration: InputDecoration(
                isDense: true,
                labelText: l.debugIngredientText,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          AsyncActionButton(
            icon: Icons.play_arrow_rounded,
            label: l.debugParse,
            onPressed: () => _parse(),
          ),
        ]),
        const SizedBox(height: 10),
        Text(l.debugTryExample,
            style: TextStyle(color: context.appFgSub, fontSize: 12.5)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final e in _examples)
              ActionChip(label: Text(e), onPressed: () => _parse(e)),
          ],
        ),
        if (parsed != null && ing is Map) ...[
          const SizedBox(height: 14),
          if (pct('average') != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(l.debugAverageConfidence(pct('average')!),
                  style: TextStyle(
                      color: color('average'), fontWeight: FontWeight.w800)),
            ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              field(l.debugQuantity, qty(ing['quantity']), 'quantity'),
              field(
                  l.debugUnit,
                  (ing['unit'] is Map ? ing['unit']['name'] : '')?.toString() ??
                      '',
                  'unit'),
              field(
                  l.debugFood,
                  (ing['food'] is Map ? ing['food']['name'] : '')?.toString() ??
                      '',
                  'food'),
              field(l.debugNote, ing['note']?.toString() ?? '', 'comment'),
            ],
          ),
        ],
      ],
    );
  }

  Widget _aiCard(AppLocalizations l) {
    final groups = _groups;
    final providers = _providersOf(_groupId);
    return ToolCard(
      title: l.debugAiTitle,
      subtitle: l.debugAiDescription,
      icon: Icons.smart_toy_rounded,
      children: [
        if (groups == null)
          const ToolEmpty('', loading: true)
        else ...[
          DropdownButtonFormField<String>(
            initialValue: _groupId,
            isExpanded: true,
            decoration: InputDecoration(
                labelText: l.debugGroup, border: const OutlineInputBorder()),
            items: [
              for (final g in groups)
                DropdownMenuItem(
                    value: g['id'].toString(),
                    child: Text(g['name']?.toString() ?? '')),
            ],
            onChanged: (v) => setState(() {
              _groupId = v;
              _providerId = null;
            }),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            key: ValueKey('providers-$_groupId'),
            initialValue: _providerId,
            isExpanded: true,
            decoration: InputDecoration(
                labelText: l.aiProviderName,
                border: const OutlineInputBorder()),
            items: [
              for (final p in providers)
                DropdownMenuItem(
                    value: p['id'].toString(),
                    child: Text(p['name']?.toString() ?? '')),
            ],
            onChanged: providers.isEmpty
                ? null
                : (v) => setState(() => _providerId = v),
          ),
          const SizedBox(height: 10),
          Row(children: [
            OutlinedButton.icon(
              onPressed: () async {
                final f = await pickToolFile(
                    const ['jpg', 'jpeg', 'png', 'webp', 'heic']);
                if (f != null && mounted) setState(() => _image = f);
              },
              icon: const Icon(Icons.image_rounded),
              label: Text(l.debugChooseImage),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(_image?.name ?? l.debugNoImage,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.appFgSub)),
            ),
            if (_image != null)
              IconButton(
                tooltip: l.delete,
                icon: const Icon(Icons.close_rounded),
                onPressed: () => setState(() => _image = null),
              ),
          ]),
          const SizedBox(height: 10),
          AsyncActionButton(
            expand: true,
            icon: Icons.network_check_rounded,
            label: l.debugRunTest,
            onPressed: _providerId == null ? null : _runAi,
          ),
          if (_aiResult != null) ...[
            const SizedBox(height: 10),
            ToolStatusRow(
              ok: _aiResult!.ok,
              title: _aiResult!.ok ? l.aiTestSucceeded : l.aiTestFailed,
              detail: _aiResult!.text,
            ),
          ],
        ],
      ],
    );
  }
}
