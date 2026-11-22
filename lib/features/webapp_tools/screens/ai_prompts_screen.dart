import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/app_chip.dart';
import '../widgets/tool_widgets.dart';

// ---------------------------------------------------------------------------
// KI-Prompts der Gruppe (Mealie 3.30, GroupAIPromptEditor): eigene
// Anweisungen für alle Prompts plus je Aufgabe „Standard“, „Hinzufügen“
// (ergänzt Mealies Prompt) oder „Überschreiben“ (ersetzt ihn). Recht
// „Verwalten“ wie die KI-Anbieter.
// ---------------------------------------------------------------------------

/// Name der globalen Anweisungen in der Mealie-API.
const _kGlobal = 'global';

enum _Mode { standard, append, override }

class _Draft {
  _Mode mode;
  final TextEditingController append;
  final TextEditingController override;
  bool showDefault = false;

  _Draft(this.mode, String appendText, String overrideText)
      : append = TextEditingController(text: appendText),
        override = TextEditingController(text: overrideText);

  TextEditingController get active =>
      mode == _Mode.override ? override : append;

  void dispose() {
    append.dispose();
    override.dispose();
  }
}

class AiPromptsScreen extends ConsumerStatefulWidget {
  const AiPromptsScreen({super.key});

  @override
  ConsumerState<AiPromptsScreen> createState() => _AiPromptsScreenState();
}

class _AiPromptsScreenState extends ConsumerState<AiPromptsScreen> {
  Map<String, dynamic>? _data;
  Object? _error;
  bool _busy = false;
  final _global = TextEditingController();
  final Map<String, _Draft> _drafts = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _global.dispose();
    for (final d in _drafts.values) {
      d.dispose();
    }
    super.dispose();
  }

  List<Map<String, dynamic>> get _prompts => [
        for (final p in (_data?['prompts'] as List? ?? const []))
          if (p is Map) Map<String, dynamic>.from(p)
      ];

  /// Server-Stand übernehmen; [only] = nur diesen Prompt (bzw. global)
  /// zurücksetzen, ungespeicherte Änderungen an anderen bleiben.
  void _apply(Map<String, dynamic> data, {String? only}) {
    _data = data;
    if (only == null || only == _kGlobal) {
      _global.text = data['globalInstructions']?.toString() ?? '';
    }
    for (final p in _prompts) {
      final name = p['name'].toString();
      if (only != null && only != name) continue;
      final mode = switch (p['mode']) {
        'append' => _Mode.append,
        'override' => _Mode.override,
        _ => _Mode.standard,
      };
      final content = p['content']?.toString() ?? '';
      final append = mode == _Mode.append ? content : '';
      final override = mode == _Mode.override ? content : '';
      // Bestehenden Entwurf AKTUALISIEREN statt ersetzen: sein Controller
      // hängt noch am sichtbaren Textfeld — ein dispose() hier ließ nach dem
      // Speichern das Feld als graue Fehlerfläche zurück.
      final existing = _drafts[name];
      if (existing == null) {
        _drafts[name] = _Draft(mode, append, override);
      } else {
        existing.mode = mode;
        if (existing.append.text != append) existing.append.text = append;
        if (existing.override.text != override) {
          existing.override.text = override;
        }
      }
    }
  }

  Future<void> _load() async {
    try {
      final data = await ref.read(apiServiceProvider).fetchAiPrompts();
      if (!mounted) return;
      setState(() {
        _apply(data);
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _run(String name, Future<Map<String, dynamic>> Function() op,
      {bool silent = false}) async {
    final l = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    try {
      final data = await op();
      if (!mounted) return;
      setState(() => _apply(data, only: name));
      if (!silent) showToolMessage(context, l.aiPromptSaved);
    } catch (e) {
      if (mounted) showToolError(context, l.aiPromptSaveFailed, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveGlobal() {
    final api = ref.read(apiServiceProvider);
    final text = _global.text.trim();
    return _run(
        _kGlobal,
        () => text.isEmpty
            ? api.resetAiPrompt(_kGlobal)
            : api.saveAiPrompt(_kGlobal, mode: 'append', content: text));
  }

  Future<void> _savePrompt(String name) {
    final api = ref.read(apiServiceProvider);
    final d = _drafts[name]!;
    return _run(
        name,
        () => d.mode == _Mode.standard
            ? api.resetAiPrompt(name)
            : api.saveAiPrompt(name,
                mode: d.mode == _Mode.override ? 'override' : 'append',
                content: d.active.text));
  }

  /// Hat [p] ungespeicherte Änderungen (wie `isDirty` der Webapp)?
  bool _dirty(Map<String, dynamic> p) {
    final d = _drafts[p['name'].toString()];
    if (d == null) return false;
    final serverMode = p['mode']?.toString();
    if (d.mode == _Mode.standard) return serverMode != null;
    final mode = d.mode == _Mode.override ? 'override' : 'append';
    final content = d.active.text;
    return content.trim().isNotEmpty &&
        (mode != serverMode || content != (p['content']?.toString() ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final data = _data;
    return ToolPage(
      title: l.aiPromptsTitle,
      description: l.aiPromptsDescription,
      busy: _busy,
      onRefresh: _load,
      children: [
        if (data == null)
          ToolEmpty(
              _error == null
                  ? ''
                  : (mealieErrorMessage(_error!) ?? l.loadFailed),
              loading: _error == null)
        else ...[
          ToolCard(
            title: l.aiPromptsGlobal,
            icon: Icons.public_rounded,
            children: [
              Text(l.aiPromptsGlobalDescription,
                  style: TextStyle(color: context.appFgSub, fontSize: 13)),
              const SizedBox(height: 10),
              TextField(
                controller: _global,
                minLines: 2,
                maxLines: 8,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: l.aiPromptsGlobalPlaceholder,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: FilledButton(
                  onPressed: _busy ||
                          _global.text.trim() ==
                              (data['globalInstructions']?.toString() ?? '')
                      ? null
                      : _saveGlobal,
                  child: Text(l.save),
                ),
              ),
            ],
          ),
          ToolCard(
            title: l.aiPromptsList,
            icon: Icons.auto_awesome_rounded,
            children: [
              for (final p in _prompts) _promptTile(l, p),
            ],
          ),
        ],
      ],
    );
  }

  Widget _promptTile(AppLocalizations l, Map<String, dynamic> p) {
    final name = p['name'].toString();
    final d = _drafts[name]!;
    final isSystem = p['isSystem'] == true;
    final serverMode = p['mode']?.toString();
    final changed = p['defaultChanged'] == true;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        // ValueKey, KEIN PageStorageKey: sonst landet der Auf/Zu-Zustand
        // (bool) im Seitenspeicher, aus dem das mehrzeilige Textfeld darin
        // seine Scrollposition (double) liest → Absturz, im Release-Build
        // eine graue Fläche statt des Felds.
        key: ValueKey('prompt-$name'),
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 14),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        title: Text(aiPromptTitle(l, name),
            style: TextStyle(
                color: context.appFg,
                fontSize: 15,
                fontWeight: FontWeight.w700)),
        subtitle: (isSystem || serverMode != null || changed)
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Wrap(spacing: 6, runSpacing: 4, children: [
                  if (isSystem) _badge(l.aiPromptSystem, context.appFgSub),
                  if (serverMode != null)
                    _badge(
                        serverMode == 'override'
                            ? l.aiPromptOverridden
                            : l.aiPromptAppended,
                        AppTokens.accentDeep),
                  if (changed)
                    const Icon(Icons.warning_amber_rounded,
                        size: 18, color: Color(0xFFD9443A)),
                ]),
              )
            : null,
        children: [
          if (aiPromptDescription(l, name) case final desc?)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(desc,
                  style: TextStyle(color: context.appFgSub, fontSize: 13)),
            ),
          if (isSystem) ToolNotice(l.aiPromptSystemDescription),
          if (changed) ToolNotice(l.aiPromptDefaultChanged, danger: true),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final (mode, label) in [
              (_Mode.standard, l.aiPromptModeDefault),
              (_Mode.append, l.aiPromptModeAppend),
              (_Mode.override, l.aiPromptModeOverride),
            ])
              AppChip(
                label: label,
                selected: d.mode == mode,
                onTap: _busy
                    ? null
                    : () => setState(() {
                          d.mode = mode;
                          // Überschreiben beginnt mit Mealies Standard-Prompt.
                          if (mode == _Mode.override &&
                              d.override.text.trim().isEmpty) {
                            d.override.text =
                                p['defaultContent']?.toString() ?? '';
                          }
                        }),
              ),
          ]),
          if (d.mode != _Mode.standard) ...[
            const SizedBox(height: 10),
            Text(
                d.mode == _Mode.append
                    ? l.aiPromptAppendDescription
                    : l.aiPromptOverrideDescription,
                style: TextStyle(color: context.appFgSub, fontSize: 13)),
            const SizedBox(height: 8),
            TextField(
              controller: d.active,
              minLines: 3,
              maxLines: 14,
              maxLength: 20000,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ],
          Row(children: [
            TextButton.icon(
              onPressed: () => setState(() => d.showDefault = !d.showDefault),
              icon: Icon(d.showDefault
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded),
              label: Text(d.showDefault
                  ? l.aiPromptHideDefault
                  : l.aiPromptViewDefault),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _busy || !_dirty(p) ? null : () => _savePrompt(name),
              child: Text(l.save),
            ),
          ]),
          if (d.showDefault)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.appSurface2,
                borderRadius: BorderRadius.circular(AppTokens.rSm),
              ),
              child: SelectableText(p['defaultContent']?.toString() ?? '',
                  style: TextStyle(
                      color: context.appFg,
                      fontSize: 13,
                      fontFamily: 'monospace',
                      height: 1.4)),
            ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppTokens.rXs),
        ),
        child: Text(text,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w700)),
      );
}

/// Titel eines Mealie-Prompts (`recipes.build-recipe` …) wie die Webapp
/// (group.ai-prompts.prompt-titles). Unbekannte Namen (neuere Mealie-Version)
/// lesbar statt roh: „recipes.enrich-instructions" → „Enrich instructions".
String aiPromptTitle(AppLocalizations l, String name) => switch (name) {
      'recipes.build-recipe' => l.aiPromptTitleBuildRecipe,
      'recipes.enrich-instructions' => l.aiPromptTitleEnrichInstructions,
      'recipes.parse-recipe-ingredients' => l.aiPromptTitleParseIngredients,
      'recipes.parse-recipe-video' => l.aiPromptTitleRecipeVideo,
      'recipes.resolve-organizers' => l.aiPromptTitleOrganizers,
      'recipes.translate-recipe' => l.aiPromptTitleTranslate,
      'system.compile-source' => l.aiPromptTitleCompileSource,
      'system.transcribe-audio' => l.aiPromptTitleTranscribe,
      _ => _readablePromptName(name),
    };

String _readablePromptName(String name) {
  final words = name.split('.').last.replaceAll(RegExp(r'[-_]+'), ' ').trim();
  if (words.isEmpty) return name;
  return words[0].toUpperCase() + words.substring(1);
}

String? aiPromptDescription(AppLocalizations l, String name) => switch (name) {
      'recipes.build-recipe' => l.aiPromptDescBuildRecipe,
      'recipes.enrich-instructions' => l.aiPromptDescEnrichInstructions,
      'recipes.parse-recipe-ingredients' => l.aiPromptDescParseIngredients,
      'recipes.parse-recipe-video' => l.aiPromptDescRecipeVideo,
      'recipes.resolve-organizers' => l.aiPromptDescOrganizers,
      'recipes.translate-recipe' => l.aiPromptDescTranslate,
      'system.compile-source' => l.aiPromptDescCompileSource,
      'system.transcribe-audio' => l.aiPromptDescTranscribe,
      _ => null,
    };
