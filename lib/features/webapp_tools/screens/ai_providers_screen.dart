import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../widgets/tool_widgets.dart';

// ---------------------------------------------------------------------------
// KI-Anbieter der Gruppe (Mealie 3.28, GroupAIProviderSettingsEditor +
// GroupAIProviderDialog): Anbieter anlegen/bearbeiten/testen/löschen und
// Standard-, Audio- und Bild-Anbieter wählen. Ohne Standard-Anbieter sind
// alle KI-Funktionen aus. Der API-Schlüssel kommt nie vom Server zurück —
// beim Bearbeiten leer lassen = gespeicherten behalten.
// ---------------------------------------------------------------------------

class AiProvidersScreen extends ConsumerStatefulWidget {
  const AiProvidersScreen({super.key});

  @override
  ConsumerState<AiProvidersScreen> createState() => _AiProvidersScreenState();
}

class _AiProvidersScreenState extends ConsumerState<AiProvidersScreen> {
  Map<String, dynamic>? _settings;
  Object? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final s = await ref.read(apiServiceProvider).fetchAiProviderSettings();
      if (!mounted) return;
      setState(() {
        _settings = s;
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  List<Map<String, dynamic>> get _providers => [
        for (final p in (_settings?['providers'] as List? ?? const []))
          if (p is Map) Map<String, dynamic>.from(p)
      ]..sort((a, b) => (a['name']?.toString() ?? '')
          .toLowerCase()
          .compareTo((b['name']?.toString() ?? '').toLowerCase()));

  Future<void> _guard(String fail, Future<void> Function() op,
      {String? success}) async {
    setState(() => _busy = true);
    try {
      await op();
      if (mounted && success != null) showToolMessage(context, success);
    } catch (e) {
      if (mounted) showToolError(context, fail, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _setSlot(String slot, String? id) async {
    final l = AppLocalizations.of(context)!;
    final s = _settings ?? const {};
    String? v(String key) => key == slot ? id : s[key]?.toString();
    await _guard(l.saveFailed, () async {
      final updated =
          await ref.read(apiServiceProvider).updateAiProviderSettings(
                defaultId: v('defaultProviderId'),
                audioId: v('audioProviderId'),
                imageId: v('imageProviderId'),
              );
      if (mounted) setState(() => _settings = updated);
    });
  }

  Future<void> _edit([String? id]) async {
    final l = AppLocalizations.of(context)!;
    Map<String, dynamic>? existing;
    if (id != null) {
      try {
        existing = await ref.read(apiServiceProvider).fetchAiProvider(id);
      } catch (e) {
        if (mounted) showToolError(context, l.loadFailed, e);
        return;
      }
    }
    if (!mounted) return;
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _ProviderDialog(existing: existing),
    );
    if (saved == true) {
      await _load();
      if (mounted) {
        showToolMessage(
            context, id == null ? l.aiProviderCreated : l.aiProviderUpdated);
      }
    }
  }

  Future<void> _delete(Map<String, dynamic> p) async {
    final l = AppLocalizations.of(context)!;
    if (!await confirmTool(context,
        message: l.aiProviderDeleteConfirm(p['name']?.toString() ?? ''))) {
      return;
    }
    await _guard(l.aiProviderDeleteFailed, () async {
      await ref.read(apiServiceProvider).deleteAiProvider(p['id'].toString());
      await _load();
    }, success: l.aiProviderDeleted);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final s = _settings;
    final providers = _providers;

    Widget slot(String key, String label, String help) {
      final current = s?[key]?.toString();
      final valid = providers.any((p) => p['id'].toString() == current);
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: DropdownButtonFormField<String?>(
          key: ValueKey('$key-$current-${providers.length}'),
          initialValue: valid ? current : null,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: label,
            helperText: help,
            helperMaxLines: 2,
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem<String?>(
                value: null, child: Text(l.aiProviderNone)),
            for (final p in providers)
              DropdownMenuItem<String?>(
                  value: p['id'].toString(),
                  child: Text(p['name']?.toString() ?? '')),
          ],
          onChanged: _busy ? null : (v) => _setSlot(key, v),
        ),
      );
    }

    return ToolPage(
      title: l.aiProvidersTitle,
      description: l.aiProvidersDescription,
      busy: _busy,
      onRefresh: _load,
      actions: [
        IconButton(
          tooltip: l.aiProviderCreate,
          icon: const Icon(Icons.add_rounded),
          onPressed: _busy || s == null ? null : () => _edit(),
        ),
      ],
      children: [
        if (s == null)
          ToolEmpty(
              _error == null
                  ? ''
                  : (mealieErrorMessage(_error!) ?? l.loadFailed),
              loading: _error == null)
        else ...[
          if (providers.isNotEmpty && s['defaultProviderId'] == null)
            ToolNotice(l.aiNoDefaultWarning, danger: true),
          ToolCard(
            title: l.aiProviderSettingsTitle,
            icon: Icons.tune_rounded,
            children: [
              slot('defaultProviderId', l.aiDefaultProvider,
                  l.aiDefaultProviderDescription),
              slot('audioProviderId', l.aiAudioProvider,
                  l.aiAudioProviderDescription),
              slot('imageProviderId', l.aiImageProvider,
                  l.aiImageProviderDescription),
            ],
          ),
          ToolCard(
            title: l.aiProvidersList,
            icon: Icons.auto_awesome_rounded,
            trailing: TextButton.icon(
              onPressed: _busy ? null : () => _edit(),
              icon: const Icon(Icons.add_rounded),
              label: Text(l.aiProviderCreate),
            ),
            children: [
              if (providers.isEmpty)
                ToolEmpty(l.aiProvidersEmpty)
              else
                for (final p in providers)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.smart_toy_rounded,
                        color: AppTokens.accentDeep),
                    title: Text(p['name']?.toString() ?? '',
                        style: TextStyle(
                            color: context.appFg, fontWeight: FontWeight.w700)),
                    subtitle: Text(
                        [
                          if (s['defaultProviderId'] == p['id'])
                            l.aiDefaultProvider,
                          if (s['audioProviderId'] == p['id'])
                            l.aiAudioProvider,
                          if (s['imageProviderId'] == p['id'])
                            l.aiImageProvider,
                        ].join(' · '),
                        style:
                            TextStyle(color: context.appFgSub, fontSize: 12.5)),
                    onTap: _busy ? null : () => _edit(p['id'].toString()),
                    trailing: IconButton(
                      tooltip: l.delete,
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: _busy ? null : () => _delete(p),
                    ),
                  ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Anlegen/Bearbeiten inkl. „Verbindung testen". Gibt `true` nach dem
/// Speichern zurück.
class _ProviderDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic>? existing;
  const _ProviderDialog({this.existing});

  @override
  ConsumerState<_ProviderDialog> createState() => _ProviderDialogState();
}

class _ProviderDialogState extends ConsumerState<_ProviderDialog> {
  late final _name =
      TextEditingController(text: widget.existing?['name']?.toString() ?? '');
  late final _model =
      TextEditingController(text: widget.existing?['model']?.toString() ?? '');
  final _apiKey = TextEditingController();
  late final _baseUrl = TextEditingController(
      text: widget.existing?['baseUrl']?.toString() ?? '');
  late final _timeout =
      TextEditingController(text: '${widget.existing?['timeout'] ?? 300}');
  late final List<(TextEditingController, TextEditingController)> _headers =
      _pairs(widget.existing?['requestHeaders']);
  late final List<(TextEditingController, TextEditingController)> _params =
      _pairs(widget.existing?['requestParams']);
  bool _busy = false;
  bool _advanced = false;
  ({bool ok, String text})? _test;

  bool get _isEdit => widget.existing != null;

  static List<(TextEditingController, TextEditingController)> _pairs(
          dynamic map) =>
      [
        if (map is Map)
          for (final e in map.entries)
            (
              TextEditingController(text: e.key.toString()),
              TextEditingController(text: e.value.toString())
            )
      ];

  @override
  void dispose() {
    for (final c in [_name, _model, _apiKey, _baseUrl, _timeout]) {
      c.dispose();
    }
    for (final (k, v) in [..._headers, ..._params]) {
      k.dispose();
      v.dispose();
    }
    super.dispose();
  }

  Map<String, String> _toMap(
          List<(TextEditingController, TextEditingController)> list) =>
      {
        for (final (k, v) in list)
          if (k.text.trim().isNotEmpty) k.text.trim(): v.text
      };

  Map<String, dynamic> _payload() => {
        'name': _name.text.trim(),
        'model': _model.text.trim(),
        if (_apiKey.text.trim().isNotEmpty) 'apiKey': _apiKey.text.trim(),
        'baseUrl': _baseUrl.text.trim().isEmpty ? null : _baseUrl.text.trim(),
        'timeout': int.tryParse(_timeout.text.trim()) ?? 300,
        'requestHeaders': _toMap(_headers),
        'requestParams': _toMap(_params),
      };

  bool get _valid =>
      _name.text.trim().isNotEmpty &&
      _model.text.trim().isNotEmpty &&
      (_isEdit || _apiKey.text.trim().isNotEmpty) &&
      (int.tryParse(_timeout.text.trim()) ?? -1) >= 0;

  Future<void> _runTest() async {
    final l = AppLocalizations.of(context)!;
    setState(() {
      _busy = true;
      _test = null;
    });
    try {
      final r = await ref.read(apiServiceProvider).testAiProvider(_payload(),
          savedId: widget.existing?['id']?.toString());
      final ok = r['success'] == true;
      final parts = [
        ok ? l.aiTestSucceeded : l.aiTestFailed,
        if ((r['message']?.toString() ?? '').isNotEmpty)
          r['message'].toString(),
        if (ok && r['supportsImages'] == true) l.aiSupportsImages,
        if (ok && r['supportsImages'] == false) l.aiTextOnly,
      ];
      if (mounted) setState(() => _test = (ok: ok, text: parts.join('\n')));
    } catch (e) {
      if (mounted) {
        setState(() => _test = (
              ok: false,
              text: '${l.aiTestFailed}\n${mealieErrorMessage(e) ?? e}'
            ));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    try {
      await ref
          .read(apiServiceProvider)
          .saveAiProvider(_payload(), id: widget.existing?['id']?.toString());
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        showToolError(context,
            _isEdit ? l.aiProviderUpdateFailed : l.aiProviderCreateFailed, e);
        setState(() => _busy = false);
      }
    }
  }

  Widget _pairEditor(
      String title, List<(TextEditingController, TextEditingController)> list) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: Row(children: [
            Expanded(
              child: Text(title,
                  style: TextStyle(
                      color: context.appFg, fontWeight: FontWeight.w700)),
            ),
            IconButton(
              tooltip: l.add,
              icon: const Icon(Icons.add_rounded),
              onPressed: () => setState(() =>
                  list.add((TextEditingController(), TextEditingController()))),
            ),
          ]),
        ),
        for (var i = 0; i < list.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: list[i].$1,
                  decoration:
                      InputDecoration(isDense: true, labelText: l.aiKeyLabel),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: list[i].$2,
                  decoration:
                      InputDecoration(isDense: true, labelText: l.aiValueLabel),
                ),
              ),
              IconButton(
                tooltip: l.delete,
                icon: const Icon(Icons.close_rounded),
                onPressed: () => setState(() {
                  final (k, v) = list.removeAt(i);
                  k.dispose();
                  v.dispose();
                }),
              ),
            ]),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: context.appCard,
      title: Text(_isEdit ? l.aiProviderEdit : l.aiProviderCreate),
      content: SizedBox(
        width: 540,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _name,
                autofocus: !_isEdit,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(labelText: l.aiProviderName),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _model,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                    labelText: l.aiModel,
                    helperText: l.aiModelDescription,
                    helperMaxLines: 2),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _apiKey,
                obscureText: true,
                autocorrect: false,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                    labelText: l.aiApiKey,
                    helperText: _isEdit
                        ? l.aiApiKeyEditDescription
                        : l.aiApiKeyCreateDescription,
                    helperMaxLines: 3),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _baseUrl,
                autocorrect: false,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                    labelText: l.aiBaseUrl,
                    helperText: l.aiBaseUrlDescription,
                    helperMaxLines: 3),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _timeout,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(labelText: l.aiTimeout),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => setState(() => _advanced = !_advanced),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(children: [
                    Icon(_advanced
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded),
                    const SizedBox(width: 6),
                    Text(l.aiAdvanced,
                        style: TextStyle(
                            color: context.appFg, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),
              if (_advanced) ...[
                _pairEditor(l.aiRequestHeaders, _headers),
                _pairEditor(l.aiRequestParams, _params),
              ],
              if (_test != null)
                ToolStatusRow(
                    ok: _test!.ok,
                    title: _test!.text.split('\n').first,
                    detail: _test!.text.split('\n').skip(1).join('\n')),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: _busy ? null : () => Navigator.pop(context),
            child: Text(l.cancel)),
        OutlinedButton.icon(
          onPressed: _busy || !_valid ? null : _runTest,
          icon: _busy
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.network_check_rounded),
          label: Text(l.aiTestConnection),
        ),
        FilledButton(
          onPressed: _busy || !_valid ? null : _save,
          child: Text(_isEdit ? l.save : l.add),
        ),
      ],
    );
  }
}
