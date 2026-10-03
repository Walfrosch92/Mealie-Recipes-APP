import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../widgets/tool_widgets.dart';

// ---------------------------------------------------------------------------
// Haushalt → Webhooks (Mealie /household/webhooks): werden zur geplanten
// Uhrzeit mit den Essensplan-Daten des Tages aufgerufen. Mealie speichert
// die Zeit als UTC „HH:MM"; angezeigt/eingegeben wird Ortszeit (wie
// timeUTCToLocal/timeLocalToUTC der Webapp).
// ---------------------------------------------------------------------------

TimeOfDay _utcToLocal(String? hhmm) {
  final parts = (hhmm ?? '00:00').split(':');
  final now = DateTime.now().toUtc();
  final utc = DateTime.utc(
      now.year,
      now.month,
      now.day,
      int.tryParse(parts[0]) ?? 0,
      int.tryParse(parts.elementAtOrNull(1) ?? '') ?? 0);
  return TimeOfDay.fromDateTime(utc.toLocal());
}

String _localToUtc(TimeOfDay t) {
  final now = DateTime.now();
  final utc = DateTime(now.year, now.month, now.day, t.hour, t.minute).toUtc();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(utc.hour)}:${two(utc.minute)}';
}

class WebhooksScreen extends ConsumerStatefulWidget {
  const WebhooksScreen({super.key});

  @override
  ConsumerState<WebhooksScreen> createState() => _WebhooksScreenState();
}

class _WebhooksScreenState extends ConsumerState<WebhooksScreen> {
  List<Map<String, dynamic>>? _hooks;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await ref.read(apiServiceProvider).fetchWebhooks();
      list.sort((a, b) => (a['name']?.toString() ?? '')
          .toLowerCase()
          .compareTo((b['name']?.toString() ?? '').toLowerCase()));
      if (mounted) setState(() => _hooks = list);
    } catch (e) {
      if (!mounted) return;
      setState(() => _hooks ??= const []);
      showToolError(context, AppLocalizations.of(context)!.loadFailed, e);
    }
  }

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

  Future<void> _edit([Map<String, dynamic>? hook]) async {
    final l = AppLocalizations.of(context)!;
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _WebhookDialog(hook: hook),
    );
    if (result == null) return;
    await _guard(hook == null ? l.createFailed : l.saveFailed, () async {
      await ref
          .read(apiServiceProvider)
          .saveWebhook(result, id: hook?['id']?.toString());
      await _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final hooks = _hooks;
    return ToolPage(
      title: l.webhooksTitle,
      description: l.webhooksDescription,
      busy: _busy,
      onRefresh: _load,
      actions: [
        IconButton(
          tooltip: l.webhookNew,
          icon: const Icon(Icons.add_rounded),
          onPressed: _busy ? null : () => _edit(),
        ),
      ],
      children: [
        if (hooks == null)
          const ToolEmpty('', loading: true)
        else if (hooks.isEmpty)
          ToolEmpty(l.webhooksEmpty)
        else
          for (final h in hooks)
            ToolCard(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.webhook_rounded,
                      color: h['enabled'] == true
                          ? AppTokens.accentDeep
                          : context.appFgTertiary),
                  title: Text(h['name']?.toString() ?? '',
                      style: TextStyle(
                          color: context.appFg, fontWeight: FontWeight.w700)),
                  subtitle: Text(
                      '${_utcToLocal(h['scheduledTime']?.toString()).format(context)}'
                      '${h['enabled'] == true ? '' : ' · ${l.disabledLabel}'}\n'
                      '${h['url'] ?? ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(color: context.appFgSub, fontSize: 12.5)),
                  onTap: () => _edit(h),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: l.testAction,
                        icon: const Icon(Icons.send_rounded),
                        onPressed: _busy
                            ? null
                            : () => _guard(
                                l.webhookTestFailed,
                                () => ref
                                    .read(apiServiceProvider)
                                    .testWebhook(h['id'].toString()),
                                success: l.webhookTestSent),
                      ),
                      IconButton(
                        tooltip: l.delete,
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: _busy
                            ? null
                            : () async {
                                if (!await confirmTool(context,
                                    message: l.webhookDeleteConfirm(
                                        h['name']?.toString() ?? ''))) {
                                  return;
                                }
                                await _guard(l.deleteFailed, () async {
                                  await ref
                                      .read(apiServiceProvider)
                                      .deleteWebhook(h['id'].toString());
                                  await _load();
                                });
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
      ],
    );
  }
}

class _WebhookDialog extends StatefulWidget {
  final Map<String, dynamic>? hook;
  const _WebhookDialog({this.hook});

  @override
  State<_WebhookDialog> createState() => _WebhookDialogState();
}

class _WebhookDialogState extends State<_WebhookDialog> {
  late final _name =
      TextEditingController(text: widget.hook?['name']?.toString() ?? '');
  late final _url =
      TextEditingController(text: widget.hook?['url']?.toString() ?? '');
  late bool _enabled = widget.hook?['enabled'] as bool? ?? true;
  late TimeOfDay _time = widget.hook == null
      ? const TimeOfDay(hour: 0, minute: 0)
      : _utcToLocal(widget.hook!['scheduledTime']?.toString());
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _url.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: context.appCard,
      title: Text(widget.hook == null ? l.webhookNew : l.webhookEdit),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _enabled,
              onChanged: (v) => setState(() => _enabled = v),
              title: Text(l.enabledLabel),
            ),
            TextField(
              controller: _name,
              autofocus: widget.hook == null,
              decoration: InputDecoration(labelText: l.webhookName),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _url,
              keyboardType: TextInputType.url,
              autocorrect: false,
              decoration: InputDecoration(labelText: l.webhookUrl),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule_rounded),
              title: Text(l.webhookTime),
              trailing: Text(_time.format(context),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              onTap: () async {
                final t =
                    await showTimePicker(context: context, initialTime: _time);
                if (t != null) setState(() => _time = t);
              },
            ),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(
          onPressed: () {
            final uri = Uri.tryParse(_url.text.trim());
            if (_name.text.trim().isEmpty) {
              setState(() => _error = l.required);
              return;
            }
            if (uri == null ||
                (uri.scheme != 'http' && uri.scheme != 'https')) {
              setState(() => _error = l.invalidUrl);
              return;
            }
            Navigator.pop(context, {
              'enabled': _enabled,
              'name': _name.text.trim(),
              'url': _url.text.trim(),
              'webhookType': 'mealplan',
              'scheduledTime': _localToUtc(_time),
            });
          },
          child: Text(widget.hook == null ? l.add : l.save),
        ),
      ],
    );
  }
}
