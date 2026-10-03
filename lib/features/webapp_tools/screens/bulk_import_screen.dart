import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/organizer_item.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/async_action_button.dart';
import '../../../shared/widgets/multi_select_sheet.dart';
import '../../organizers/providers/organizers_provider.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../widgets/tool_widgets.dart';
import 'report_screen.dart';

// ---------------------------------------------------------------------------
// Massenimport (Mealie „Recipe Bulk Importer", /r/create/bulk): mehrere
// Rezept-URLs auf einmal — je Zeile optional Kategorien/Schlagworte. Der
// Server importiert im Hintergrund; das Ergebnis steht im Bericht
// (Kategorie bulk_import) darunter. Ist ein Bericht fertig, gleicht die App
// ihre Rezeptliste mit dem Server ab.
// ---------------------------------------------------------------------------

class _Row {
  final TextEditingController url;
  List<OrganizerItem> categories = [];
  List<OrganizerItem> tags = [];
  _Row([String text = '']) : url = TextEditingController(text: text);
}

class BulkImportScreen extends ConsumerStatefulWidget {
  const BulkImportScreen({super.key});

  @override
  ConsumerState<BulkImportScreen> createState() => _BulkImportScreenState();
}

class _BulkImportScreenState extends ConsumerState<BulkImportScreen> {
  final List<_Row> _rows = [_Row()];
  bool _showOrganizers = false;
  int _reportsReload = 0;

  @override
  void dispose() {
    for (final r in _rows) {
      r.url.dispose();
    }
    super.dispose();
  }

  void _addRows(Iterable<String> urls) {
    setState(() {
      // Eine leere Startzeile ersetzen statt stehen lassen.
      if (_rows.length == 1 && _rows.first.url.text.trim().isEmpty) {
        _rows.removeAt(0).url.dispose();
      }
      _rows.addAll(urls.map(_Row.new));
      if (_rows.isEmpty) _rows.add(_Row());
    });
  }

  Future<void> _pasteMany() async {
    final l = AppLocalizations.of(context)!;
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.appCard,
        title: Text(l.bulkAddTitle),
        content: SizedBox(
          width: 520,
          child: TextField(
            controller: ctrl,
            autofocus: true,
            minLines: 8,
            maxLines: 16,
            decoration: InputDecoration(
              hintText: l.bulkAddHint,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true), child: Text(l.add)),
        ],
      ),
    );
    final text = ctrl.text;
    ctrl.dispose();
    if (ok != true) return;
    final urls = text
        .split(RegExp(r'[\r\n]+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (urls.isNotEmpty) _addRows(urls);
  }

  Future<void> _pick(_Row row, OrganizerKind kind) async {
    final l = AppLocalizations.of(context)!;
    final current = kind == OrganizerKind.category ? row.categories : row.tags;
    final res = await showMultiSelectSheet(
      context,
      title: kind == OrganizerKind.category ? l.categories : l.tags,
      initial: [for (final o in current) (id: o.id, name: o.name)],
      items: (ref) => [
        for (final o in ref.watch(organizersProvider(kind)).valueOrNull ??
            const <OrganizerItem>[])
          (id: o.id, name: o.name)
      ],
      loading: (ref) => ref.watch(organizersProvider(kind)).isLoading,
    );
    if (res == null) return;
    final all = ref.read(organizersProvider(kind)).valueOrNull ?? const [];
    final ids = {for (final s in res.selected) s.id};
    setState(() {
      final chosen = all.where((o) => ids.contains(o.id)).toList();
      if (kind == OrganizerKind.category) {
        row.categories = chosen;
      } else {
        row.tags = chosen;
      }
    });
  }

  Map<String, dynamic> _organizerJson(OrganizerItem o) =>
      {'id': o.id, 'name': o.name, 'slug': o.slug};

  Future<void> _start() async {
    final l = AppLocalizations.of(context)!;
    final rows = _rows.where((r) => r.url.text.trim().isNotEmpty).toList();
    if (rows.isEmpty) return;
    for (final r in rows) {
      final uri = Uri.tryParse(r.url.text.trim());
      if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
        showToolMessage(context, '${l.invalidUrl}\n${r.url.text.trim()}');
        return;
      }
    }
    try {
      await ref.read(apiServiceProvider).bulkImportUrls([
        for (final r in rows)
          {
            'url': r.url.text.trim(),
            if (_showOrganizers && r.categories.isNotEmpty)
              'categories': r.categories.map(_organizerJson).toList(),
            if (_showOrganizers && r.tags.isNotEmpty)
              'tags': r.tags.map(_organizerJson).toList(),
          }
      ]);
      if (!mounted) return;
      showToolMessage(context, l.bulkImportStarted);
      setState(() {
        for (final r in _rows) {
          r.url.dispose();
        }
        _rows
          ..clear()
          ..add(_Row());
        _reportsReload++;
      });
    } catch (e) {
      if (mounted) showToolError(context, l.bulkImportFailed, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final canStart = _rows.any((r) => r.url.text.trim().isNotEmpty);
    return ToolPage(
      title: l.bulkImportTitle,
      description: l.bulkImportDescription,
      children: [
        ToolCard(
          children: [
            for (var i = 0; i < _rows.length; i++) _rowWidget(l, i),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => setState(() => _rows.add(_Row())),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(l.bulkImportAddRow),
                ),
                OutlinedButton.icon(
                  onPressed: _pasteMany,
                  icon: const Icon(Icons.playlist_add_rounded),
                  label: Text(l.bulkAddTitle),
                ),
                TextButton.icon(
                  onPressed: () => setState(() {
                    for (final r in _rows) {
                      r.url.dispose();
                    }
                    _rows
                      ..clear()
                      ..add(_Row());
                  }),
                  icon: const Icon(Icons.clear_all_rounded),
                  label: Text(l.clearAll),
                ),
              ],
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _showOrganizers,
              onChanged: (v) => setState(() => _showOrganizers = v),
              title: Text(l.bulkImportSetOrganizers,
                  style: TextStyle(color: context.appFg)),
            ),
            const SizedBox(height: 8),
            AsyncActionButton(
              expand: true,
              icon: Icons.cloud_download_rounded,
              label: l.bulkImportStart,
              onPressed: canStart ? _start : null,
            ),
          ],
        ),
        ReportListCard(
          type: 'bulk_import',
          title: l.bulkImportReports,
          reloadToken: _reportsReload,
          onReportFinished: () =>
              ref.read(recipesProvider.notifier).reconcileNow(),
        ),
      ],
    );
  }

  Widget _rowWidget(AppLocalizations l, int i) {
    final row = _rows[i];
    String names(List<OrganizerItem> list) =>
        list.isEmpty ? '—' : list.map((o) => o.name).join(', ');
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(
              child: TextField(
                controller: row.url,
                keyboardType: TextInputType.url,
                autocorrect: false,
                onChanged: (_) => setState(() {}),
                style: TextStyle(color: context.appFg),
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Icon(Icons.link_rounded),
                  hintText: l.bulkImportUrlHint,
                  filled: true,
                  fillColor: context.appSurface2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTokens.rSm),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: l.delete,
              icon: Icon(Icons.delete_outline_rounded, color: context.appFgSub),
              onPressed: () => setState(() {
                _rows.removeAt(i).url.dispose();
                if (_rows.isEmpty) _rows.add(_Row());
              }),
            ),
          ]),
          if (_showOrganizers)
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 48),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.category_rounded, size: 16),
                    label: Text('${l.categories}: ${names(row.categories)}'),
                    onPressed: () => _pick(row, OrganizerKind.category),
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.sell_rounded, size: 16),
                    label: Text('${l.tags}: ${names(row.tags)}'),
                    onPressed: () => _pick(row, OrganizerKind.tag),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
