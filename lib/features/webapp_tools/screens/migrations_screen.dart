import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/async_action_button.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../widgets/tool_widgets.dart';
import 'report_screen.dart';

// ---------------------------------------------------------------------------
// Datenmigration (Mealie /group/migrations): Rezepte aus anderen Apps
// übernehmen. Typen + erlaubte Dateien 1:1 wie die Webapp
// (SupportedMigrations, acceptedFileType). Ergebnis im Bericht
// (Kategorie migration).
// ---------------------------------------------------------------------------

class _Migration {
  final String type;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) description;
  final List<String> extensions;
  const _Migration(this.type, this.title, this.description, this.extensions);
}

// Mealie-Produktnamen bleiben in allen Sprachen gleich (wie in der Webapp).
final _migrations = <_Migration>[
  _Migration('mealie_alpha', (_) => 'Mealie Pre v1.0',
      (l) => l.migrationMealieDescription, const ['zip']),
  _Migration('chowdown', (_) => 'Chowdown',
      (l) => l.migrationChowdownDescription, const ['zip']),
  _Migration('copymethat', (_) => 'Copy Me That Recipe Manager',
      (l) => l.migrationCopyMeThatDescription, const ['zip']),
  _Migration('myrecipebox', (_) => 'My Recipe Box',
      (l) => l.migrationMyRecipeBoxDescription, const ['csv']),
  _Migration('nextcloud', (_) => 'Nextcloud Cookbook',
      (l) => l.migrationNextcloudDescription, const ['zip']),
  _Migration('paprika', (_) => 'Paprika Recipe Manager',
      (l) => l.migrationPaprikaDescription, const ['zip']),
  _Migration('plantoeat', (_) => 'Plan to Eat',
      (l) => l.migrationPlanToEatDescription, const ['zip', 'csv', 'txt']),
  _Migration('recipekeeper', (_) => 'Recipe Keeper',
      (l) => l.migrationRecipeKeeperDescription, const ['zip']),
  _Migration('tandoor', (_) => 'Tandoor Recipes',
      (l) => l.migrationTandoorDescription, const ['zip']),
  _Migration('cookn', (_) => "DVO Cook'n X3",
      (l) => l.migrationCooknDescription, const ['zip']),
];

class MigrationsScreen extends ConsumerStatefulWidget {
  const MigrationsScreen({super.key});

  @override
  ConsumerState<MigrationsScreen> createState() => _MigrationsScreenState();
}

class _MigrationsScreenState extends ConsumerState<MigrationsScreen> {
  _Migration _type = _migrations.first;
  ({List<int> bytes, String name})? _file;
  bool _addTag = false;
  int _reportsReload = 0;

  Future<void> _chooseFile() async {
    final f = await pickToolFile(_type.extensions);
    if (f != null && mounted) setState(() => _file = f);
  }

  Future<void> _start() async {
    final l = AppLocalizations.of(context)!;
    final f = _file;
    if (f == null) return;
    try {
      await ref.read(apiServiceProvider).startMigration(
            type: _type.type,
            bytes: f.bytes,
            filename: f.name,
            addMigrationTag: _addTag,
          );
      if (!mounted) return;
      showToolMessage(context, l.migrationStarted);
      setState(() {
        _file = null;
        _reportsReload++;
      });
      // Die Migration läuft synchron im Request — danach sind die Rezepte da.
      await ref.read(recipesProvider.notifier).reconcileNow();
    } catch (e) {
      if (mounted) showToolError(context, l.migrationFailed, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ToolPage(
      title: l.migrationsTitle,
      description: l.migrationsDescription,
      children: [
        ToolCard(
          title: l.migrationNew,
          icon: Icons.move_down_rounded,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _type.type,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: l.migrationChooseType,
                border: const OutlineInputBorder(),
              ),
              items: [
                for (final m in _migrations)
                  DropdownMenuItem(value: m.type, child: Text(m.title(l))),
              ],
              onChanged: (v) => setState(() {
                _type = _migrations.firstWhere((m) => m.type == v);
                // Andere Dateitypen → bisherige Auswahl verwerfen.
                final f = _file;
                if (f != null &&
                    !_type.extensions
                        .any((e) => f.name.toLowerCase().endsWith('.$e'))) {
                  _file = null;
                }
              }),
            ),
            const SizedBox(height: 12),
            Text(_type.description(l),
                style: TextStyle(
                    color: context.appFgSub, fontSize: 13.5, height: 1.4)),
            const SizedBox(height: 12),
            Row(children: [
              OutlinedButton.icon(
                onPressed: _chooseFile,
                icon: const Icon(Icons.attach_file_rounded),
                label: Text(l.chooseFileButton),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _file?.name ??
                      '${l.noFileSelected} (${_type.extensions.map((e) => '.$e').join(', ')})',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: _file == null ? context.appFgSub : context.appFg),
                ),
              ),
            ]),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _addTag,
              onChanged: (v) => setState(() => _addTag = v ?? false),
              title: Text(l.migrationTagAll(_type.type),
                  style: TextStyle(color: context.appFg)),
            ),
            const SizedBox(height: 4),
            AsyncActionButton(
              expand: true,
              icon: Icons.upload_file_rounded,
              label: l.migrationStart,
              onPressed: _file == null ? null : _start,
            ),
          ],
        ),
        ReportListCard(
          type: 'migration',
          title: l.migrationPrevious,
          reloadToken: _reportsReload,
          onReportFinished: () =>
              ref.read(recipesProvider.notifier).reconcileNow(),
        ),
      ],
    );
  }
}
