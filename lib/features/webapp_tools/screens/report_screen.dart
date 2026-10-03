import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../widgets/tool_widgets.dart';

// ---------------------------------------------------------------------------
// Mealie-Berichte (Gruppe): Massenimport- und Migrations-Ergebnisse. Wie die
// Webapp: Liste je Kategorie (ReportTable) + Detailseite mit allen Einträgen
// (Erfolg, Meldung, Zeit, ggf. Fehlertext). Laufende Berichte werden alle
// 5 s nachgeladen, bis sie fertig sind.
// ---------------------------------------------------------------------------

String reportStatusLabel(AppLocalizations l, String? status) =>
    switch (status) {
      'success' => l.reportStatusSuccess,
      'failure' => l.reportStatusFailure,
      'partial' => l.reportStatusPartial,
      'in-progress' => l.reportStatusInProgress,
      _ => status ?? '',
    };

Widget reportStatusIcon(String? status) => switch (status) {
      'success' => const Icon(Icons.check_circle_rounded,
          color: Color(0xFF2E9E57), size: 20),
      'failure' =>
        const Icon(Icons.cancel_rounded, color: Color(0xFFD9443A), size: 20),
      'partial' => const Icon(Icons.remove_circle_rounded,
          color: AppTokens.accentDeep, size: 20),
      _ => const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2)),
    };

/// Liste der Berichte einer Kategorie (bulk_import | migration) als Karte.
/// [reloadToken] ändern → neu laden (z. B. nach einem Start).
class ReportListCard extends ConsumerStatefulWidget {
  final String type;
  final String title;
  final int reloadToken;

  /// Ein zuvor laufender Bericht ist fertig (→ Rezepte abgleichen).
  final VoidCallback? onReportFinished;
  const ReportListCard(
      {super.key,
      required this.type,
      required this.title,
      this.reloadToken = 0,
      this.onReportFinished});

  @override
  ConsumerState<ReportListCard> createState() => _ReportListCardState();
}

class _ReportListCardState extends ConsumerState<ReportListCard> {
  List<Map<String, dynamic>>? _reports;
  Timer? _poll;
  Set<String> _running = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(ReportListCard old) {
    super.didUpdateWidget(old);
    if (old.reloadToken != widget.reloadToken) _load();
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final list =
          await ref.read(apiServiceProvider).fetchReports(type: widget.type);
      list.sort((a, b) => (b['timestamp']?.toString() ?? '')
          .compareTo(a['timestamp']?.toString() ?? ''));
      if (!mounted) return;
      final running = {
        for (final r in list)
          if (r['status'] == 'in-progress') r['id'].toString()
      };
      if (_running.any((id) => !running.contains(id))) {
        widget.onReportFinished?.call();
      }
      _running = running;
      setState(() => _reports = list);
      _poll?.cancel();
      if (list.any((r) => r['status'] == 'in-progress')) {
        _poll = Timer(const Duration(seconds: 5), _load);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _reports ??= const []);
      showToolError(context, AppLocalizations.of(context)!.loadFailed, e);
    }
  }

  Future<void> _delete(String id) async {
    final l = AppLocalizations.of(context)!;
    if (!await confirmTool(context, message: l.reportDeleteConfirm)) return;
    try {
      await ref.read(apiServiceProvider).deleteReport(id);
      await _load();
    } catch (e) {
      if (mounted) showToolError(context, l.deleteFailed, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final reports = _reports;
    return ToolCard(
      title: widget.title,
      icon: Icons.assignment_outlined,
      trailing: IconButton(
        tooltip: l.reload,
        icon: Icon(Icons.refresh_rounded, color: context.appFgSub),
        onPressed: _load,
      ),
      children: [
        if (reports == null)
          const ToolEmpty('', loading: true)
        else if (reports.isEmpty)
          ToolEmpty(l.reportsEmpty)
        else
          for (final r in reports)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: reportStatusIcon(r['status']?.toString()),
              title: Text(r['name']?.toString() ?? '',
                  style: TextStyle(
                      color: context.appFg, fontWeight: FontWeight.w600)),
              subtitle: Text(
                  '${formatToolDate(context, r['timestamp'])} · '
                  '${reportStatusLabel(l, r['status']?.toString())}',
                  style: TextStyle(color: context.appFgSub, fontSize: 12.5)),
              onTap: r['status'] == 'in-progress'
                  ? null
                  : () => context.push('/reports/${r['id']}'),
              trailing: IconButton(
                tooltip: l.delete,
                icon:
                    Icon(Icons.delete_outline_rounded, color: context.appFgSub),
                onPressed: () => _delete(r['id'].toString()),
              ),
            ),
      ],
    );
  }
}

/// Detailseite eines Berichts (`/reports/:id`).
class ReportScreen extends ConsumerStatefulWidget {
  final String id;
  const ReportScreen({super.key, required this.id});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  Map<String, dynamic>? _report;
  Object? _error;
  bool _onlyFailed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final r = await ref.read(apiServiceProvider).fetchReport(widget.id);
      if (mounted) setState(() => _report = r);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final r = _report;
    final entries = [
      for (final e in (r?['entries'] as List? ?? const []))
        if (e is Map) Map<String, dynamic>.from(e)
    ];
    final failed = entries.where((e) => e['success'] != true).length;
    final shown =
        _onlyFailed ? entries.where((e) => e['success'] != true) : entries;
    return ToolPage(
      title: l.reportTitle,
      onRefresh: _load,
      children: [
        if (r == null)
          ToolEmpty(
              _error == null
                  ? ''
                  : (mealieErrorMessage(_error!) ?? l.loadFailed),
              loading: _error == null)
        else ...[
          ToolCard(
            title: r['name']?.toString(),
            children: [
              ToolInfoRow(
                  l.reportStatus, reportStatusLabel(l, r['status']?.toString()),
                  leading: reportStatusIcon(r['status']?.toString())),
              ToolInfoRow(
                  l.reportDate, formatToolDate(context, r['timestamp'])),
              ToolInfoRow(l.reportEntries, '${entries.length}'),
              ToolInfoRow(l.reportFailedEntries, '$failed'),
            ],
          ),
          if (failed > 0)
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _onlyFailed,
              onChanged: (v) => setState(() => _onlyFailed = v),
              title: Text(l.reportOnlyFailed,
                  style: TextStyle(color: context.appFg)),
            ),
          for (final e in shown) _EntryTile(entry: e),
        ],
      ],
    );
  }
}

class _EntryTile extends StatelessWidget {
  final Map<String, dynamic> entry;
  const _EntryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final ok = entry['success'] == true;
    final exception = entry['exception']?.toString() ?? '';
    return ToolCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(ok ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: ok ? const Color(0xFF2E9E57) : const Color(0xFFD9443A),
                size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(entry['message']?.toString() ?? '',
                      style: TextStyle(
                          color: context.appFg,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(formatToolDate(context, entry['timestamp']),
                      style: TextStyle(color: context.appFgSub, fontSize: 12)),
                  if (exception.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    SelectableText(exception,
                        style: TextStyle(
                            color: context.appFgSub,
                            fontSize: 12,
                            fontFamily: 'monospace',
                            height: 1.35)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
