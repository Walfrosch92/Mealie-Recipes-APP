import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../widgets/tool_widgets.dart';

// ---------------------------------------------------------------------------
// Administration → Wartung (Mealie /admin/maintenance): Zusammenfassung
// (Datenverzeichnis, aufräumbare Bilder/Ordner), Speicherdetails und die
// drei Aufräum-Aktionen (destruktiv + unumkehrbar → Rückfrage).
// ---------------------------------------------------------------------------

class MaintenanceScreen extends ConsumerStatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  ConsumerState<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends ConsumerState<MaintenanceScreen> {
  Map<String, dynamic>? _summary;
  Map<String, dynamic>? _storage;
  bool _busy = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final api = ref.read(apiServiceProvider);
    try {
      final r = await Future.wait(
          [api.fetchMaintenanceSummary(), api.fetchMaintenanceStorage()]);
      if (!mounted) return;
      setState(() {
        _summary = r[0];
        _storage = r[1];
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _clean(String what, String name) async {
    final l = AppLocalizations.of(context)!;
    if (!await confirmTool(context,
        title: name,
        message: l.maintenanceConfirm,
        confirmLabel: l.maintenanceRun)) {
      return;
    }
    setState(() => _busy = true);
    try {
      // Server-Meldung ist nur Englisch → eigene, übersetzte Bestätigung.
      await ref.read(apiServiceProvider).runMaintenanceClean(what);
      if (mounted) showToolMessage(context, l.maintenanceDone);
      await _load();
    } catch (e) {
      if (mounted) showToolError(context, l.maintenanceFailed, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final s = _summary, st = _storage;
    final actions = [
      (
        'recipe-folders',
        l.maintenanceCleanDirs,
        l.maintenanceCleanDirsDescription
      ),
      ('temp', l.maintenanceCleanTemp, l.maintenanceCleanTempDescription),
      ('images', l.maintenanceCleanImages, l.maintenanceCleanImagesDescription),
    ];
    return ToolPage(
      title: l.maintenanceTitle,
      busy: _busy,
      onRefresh: _load,
      children: [
        if (s == null || st == null)
          ToolEmpty(
              _error == null
                  ? ''
                  : (mealieErrorMessage(_error!) ?? l.loadFailed),
              loading: _error == null)
        else ...[
          ToolCard(
            title: l.maintenanceSummary,
            icon: Icons.summarize_rounded,
            children: [
              ToolInfoRow(
                  l.maintenanceDataDirSize, '${s['dataDirSize'] ?? ''}'),
              ToolInfoRow(
                  l.maintenanceCleanableDirs, '${s['cleanableDirs'] ?? 0}'),
              ToolInfoRow(
                  l.maintenanceCleanableImages, '${s['cleanableImages'] ?? 0}'),
            ],
          ),
          ToolCard(
            title: l.maintenanceStorage,
            icon: Icons.storage_rounded,
            children: [
              ToolInfoRow(l.maintenanceTempDir, '${st['tempDirSize'] ?? ''}'),
              ToolInfoRow(
                  l.maintenanceBackupsDir, '${st['backupsDirSize'] ?? ''}'),
              ToolInfoRow(
                  l.maintenanceGroupsDir, '${st['groupsDirSize'] ?? ''}'),
              ToolInfoRow(
                  l.maintenanceRecipesDir, '${st['recipesDirSize'] ?? ''}'),
              ToolInfoRow(l.maintenanceUserDir, '${st['userDirSize'] ?? ''}'),
            ],
          ),
        ],
        ToolCard(
          title: l.maintenanceActions,
          icon: Icons.cleaning_services_rounded,
          children: [
            ToolNotice(l.maintenanceActionsWarning, danger: true),
            for (final (what, name, desc) in actions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(name,
                    style: TextStyle(
                        color: context.appFg, fontWeight: FontWeight.w700)),
                subtitle: Text(desc,
                    style: TextStyle(color: context.appFgSub, fontSize: 12.5)),
                trailing: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppTokens.accentDeep),
                  onPressed: _busy ? null : () => _clean(what, name),
                  child: Text(l.maintenanceRun),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
