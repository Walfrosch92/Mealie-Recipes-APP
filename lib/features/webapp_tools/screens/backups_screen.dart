import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/async_action_button.dart';
import '../widgets/tool_widgets.dart';

// ---------------------------------------------------------------------------
// Administration → Sicherungen (Mealie /admin/backups): Gesamtsicherung von
// Datenbank + Datenverzeichnis erstellen, hochladen (.zip), herunterladen,
// löschen und wiederherstellen. Wiederherstellen überschreibt ALLES — wie
// die Webapp nur nach ausdrücklicher Bestätigung („Ich verstehe …").
// ---------------------------------------------------------------------------

class BackupsScreen extends ConsumerStatefulWidget {
  const BackupsScreen({super.key});

  @override
  ConsumerState<BackupsScreen> createState() => _BackupsScreenState();
}

class _BackupsScreenState extends ConsumerState<BackupsScreen> {
  List<Map<String, dynamic>>? _backups;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final all = await ref.read(apiServiceProvider).fetchBackups();
      final list = [
        for (final b in (all['imports'] as List? ?? const []))
          if (b is Map) Map<String, dynamic>.from(b)
      ];
      if (mounted) setState(() => _backups = list);
    } catch (e) {
      if (!mounted) return;
      setState(() => _backups ??= const []);
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

  Future<void> _create() =>
      _guard(AppLocalizations.of(context)!.backupCreateFailed, () async {
        await ref.read(apiServiceProvider).createBackup();
        await _load();
      }, success: AppLocalizations.of(context)!.backupCreated);

  Future<void> _upload() async {
    final l = AppLocalizations.of(context)!;
    final f = await pickToolFile(const ['zip']);
    if (f == null) return;
    await _guard(l.uploadFailed, () async {
      await ref.read(apiServiceProvider).uploadBackup(f.bytes, f.name);
      await _load();
    }, success: l.backupUploaded);
  }

  Future<void> _download(String name) async {
    final l = AppLocalizations.of(context)!;
    await _guard(l.downloadFailed, () async {
      final bytes = await ref.read(apiServiceProvider).downloadBackup(name);
      if (await saveBytesWithDialog(bytes, name) && mounted) {
        showToolMessage(context, l.fileSaved);
      }
    });
  }

  Future<void> _delete(String name) async {
    final l = AppLocalizations.of(context)!;
    if (!await confirmTool(context,
        title: l.backupDelete, message: l.backupDeleteConfirm(name))) {
      return;
    }
    await _guard(l.deleteFailed, () async {
      await ref.read(apiServiceProvider).deleteBackup(name);
      await _load();
    }, success: l.backupDeleted);
  }

  Future<void> _restore(String name) async {
    final l = AppLocalizations.of(context)!;
    var acknowledged = false;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          backgroundColor: ctx.appCard,
          title: Text(l.backupRestore),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(name,
                    style: TextStyle(
                        color: ctx.appFg, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(l.backupRestoreDescription,
                    style: TextStyle(color: ctx.appFg, height: 1.4)),
                const SizedBox(height: 8),
                ToolNotice(l.backupCannotBeUndone, danger: true),
                Text(l.backupPostgresNote,
                    style: TextStyle(color: ctx.appFgSub, fontSize: 12.5)),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: acknowledged,
                  onChanged: (v) => setLocal(() => acknowledged = v ?? false),
                  title: Text(l.backupAcknowledge,
                      style: TextStyle(color: ctx.appFg, fontSize: 13.5)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l.cancel)),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: acknowledged ? () => Navigator.pop(ctx, true) : null,
              child: Text(l.backupRestore),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    await _guard(l.backupRestoreFailed, () async {
      await ref.read(apiServiceProvider).restoreBackup(name);
    }, success: l.backupRestoreSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final backups = _backups;
    return ToolPage(
      title: l.backupsTitle,
      description: l.backupsDescription,
      busy: _busy,
      onRefresh: _load,
      children: [
        ToolCard(
          title: l.backupCreateHeading,
          icon: Icons.backup_rounded,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                AsyncActionButton(
                  icon: Icons.add_rounded,
                  label: l.backupCreate,
                  onPressed: _busy ? null : _create,
                ),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _upload,
                  icon: const Icon(Icons.upload_rounded),
                  label: Text(l.backupUpload),
                ),
              ],
            ),
          ],
        ),
        ToolCard(
          title: l.backupsTitle,
          icon: Icons.folder_zip_rounded,
          children: [
            if (backups == null)
              const ToolEmpty('', loading: true)
            else if (backups.isEmpty)
              ToolEmpty(l.backupsEmpty)
            else
              for (final b in backups)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.inventory_2_rounded,
                      color: AppTokens.accentDeep),
                  title: Text(b['name']?.toString() ?? '',
                      style: TextStyle(
                          color: context.appFg, fontWeight: FontWeight.w600)),
                  subtitle: Text(
                      '${formatToolDate(context, b['date'])} · ${b['size'] ?? ''}',
                      style:
                          TextStyle(color: context.appFgSub, fontSize: 12.5)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: l.downloadAction,
                        icon: const Icon(Icons.download_rounded),
                        onPressed: _busy
                            ? null
                            : () => _download(b['name'].toString()),
                      ),
                      IconButton(
                        tooltip: l.backupRestore,
                        icon: const Icon(Icons.settings_backup_restore_rounded),
                        onPressed:
                            _busy ? null : () => _restore(b['name'].toString()),
                      ),
                      IconButton(
                        tooltip: l.delete,
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed:
                            _busy ? null : () => _delete(b['name'].toString()),
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
