import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/providers/cached_json_list.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../../core/services/local_cache.dart';
import '../../../shared/theme/app_colors.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../../organizers/screens/organizers_screen.dart'
    show showOrganizerNameDialog;

// ---------------------------------------------------------------------------
// Haushaltsverwaltung — wie in der Mealie-Webapp, nach Rechten abgestuft:
//  • „Haushalt verwalten": Haushaltskonfiguration des EIGENEN Haushalts
//    (privat, Rezept-Änderungen anderer Haushalte sperren, Wochenbeginn,
//    Ankündigungen, Rezept-Voreinstellungen) — /api/households/preferences.
//  • „Verwalten": Gruppeneinstellungen der EIGENEN Gruppe (privat,
//    Ankündigungen) — /api/groups/preferences.
//  • Admin: ALLE Haushalte und Gruppen anlegen, umbenennen, konfigurieren,
//    löschen (Mealie lehnt Löschen ab, solange noch Benutzer drin sind).
// ---------------------------------------------------------------------------

// Cache-first wie überall: sofort aus dem Cache, Abgleich im Hintergrund.
final adminHouseholdsProvider =
    AsyncNotifierProvider<_AdminHouseholdsNotifier, List<Map<String, dynamic>>>(
        _AdminHouseholdsNotifier.new);

class _AdminHouseholdsNotifier extends CachedJsonListNotifier {
  @override
  String get cacheKey => 'admin_households';
  @override
  Future<List<Map<String, dynamic>>> fetch(ApiService api) =>
      api.fetchAdminHouseholds();
}

final adminGroupsProvider =
    AsyncNotifierProvider<_AdminGroupsNotifier, List<Map<String, dynamic>>>(
        _AdminGroupsNotifier.new);

class _AdminGroupsNotifier extends CachedJsonListNotifier {
  @override
  String get cacheKey => 'admin_groups';
  @override
  Future<List<Map<String, dynamic>>> fetch(ApiService api) =>
      api.fetchAdminGroups();
}

/// Felder von UpdateHouseholdPreferences in Webapp-Reihenfolge.
const _kHouseholdPrefKeys = [
  'privateHousehold',
  'lockRecipeEditsFromOtherHouseholds',
  'firstDayOfWeek',
  'showAnnouncements',
  'recipePublic',
  'recipeShowNutrition',
  'recipeShowAssets',
  'recipeLandscapeView',
  'recipeDisableComments',
];

Map<String, dynamic> _pickHouseholdPrefs(Map<String, dynamic>? raw) => {
      for (final k in _kHouseholdPrefKeys)
        if (raw != null && raw.containsKey(k)) k: raw[k],
    };

Map<String, dynamic> _pickGroupPrefs(Map<String, dynamic>? raw) => {
      for (final k in ['privateGroup', 'showAnnouncements'])
        if (raw != null && raw.containsKey(k)) k: raw[k],
    };

class HouseholdManagementScreen extends ConsumerWidget {
  const HouseholdManagementScreen({super.key});

  void _snack(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _openOwnHouseholdPrefs(BuildContext context, WidgetRef ref) =>
      _openPrefsSheet(
        context,
        title: AppLocalizations.of(context)!.householdPreferencesTitle,
        cacheKey: 'household_preferences',
        load: () async => _pickHouseholdPrefs(
            await ref.read(apiServiceProvider).fetchHouseholdPreferences()),
        save: (p) => ref.read(apiServiceProvider).updateHouseholdPreferences(p),
        household: true,
      );

  Future<void> _openOwnGroupPrefs(BuildContext context, WidgetRef ref) =>
      _openPrefsSheet(
        context,
        title: AppLocalizations.of(context)!.groupPreferencesTitle,
        cacheKey: 'group_preferences',
        load: () async => _pickGroupPrefs(
            await ref.read(apiServiceProvider).fetchGroupPreferences()),
        save: (p) => ref.read(apiServiceProvider).updateGroupPreferences(p),
        household: false,
      );

  Future<void> _createHousehold(BuildContext context, WidgetRef ref,
      List<Map<String, dynamic>> groups) async {
    final l = AppLocalizations.of(context)!;
    final name =
        await showOrganizerNameDialog(context, title: l.createHouseholdTitle);
    if (name == null || !context.mounted) return;
    // Gruppe: die eigene (bzw. die einzige); bei mehreren fragen.
    String? groupId = ref.read(currentUserProvider)?['groupId']?.toString();
    if (groups.length > 1) {
      groupId = await showDialog<String>(
        context: context,
        builder: (ctx) => SimpleDialog(
          backgroundColor: ctx.appCard,
          title: Text(l.groupLabel),
          children: [
            for (final g in groups)
              SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, g['id'].toString()),
                child: Text(g['name']?.toString() ?? ''),
              ),
          ],
        ),
      );
    }
    if (groupId == null) return;
    try {
      await ref
          .read(apiServiceProvider)
          .createHousehold(name: name, groupId: groupId);
      unawaited(ref.read(adminHouseholdsProvider.notifier).refresh());
    } catch (e) {
      if (context.mounted) {
        _snack(context, mealieErrorMessage(e) ?? l.createFailed);
      }
    }
  }

  Future<void> _createGroup(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    final name =
        await showOrganizerNameDialog(context, title: l.createGroupTitle);
    if (name == null) return;
    try {
      await ref.read(apiServiceProvider).createGroup(name);
      unawaited(ref.read(adminGroupsProvider.notifier).refresh());
      unawaited(ref.read(adminHouseholdsProvider.notifier).refresh());
    } catch (e) {
      if (context.mounted) {
        _snack(context, mealieErrorMessage(e) ?? l.createFailed);
      }
    }
  }

  Future<void> _openHousehold(
      BuildContext context, WidgetRef ref, Map<String, dynamic> h) async {
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.appCard,
      builder: (_) => _AdminEntitySheet(entity: h, household: true),
    );
    unawaited(ref.read(adminHouseholdsProvider.notifier).refresh());
  }

  Future<void> _openGroup(
      BuildContext context, WidgetRef ref, Map<String, dynamic> g) async {
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.appCard,
      builder: (_) => _AdminEntitySheet(entity: g, household: false),
    );
    unawaited(ref.read(adminGroupsProvider.notifier).refresh());
    unawaited(ref.read(adminHouseholdsProvider.notifier).refresh());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final p = ref.watch(userPermissionsProvider);
    final mayHousehold = p.admin || p.canManageHousehold;
    final mayGroup = p.admin || p.canManage;
    final households = p.admin ? ref.watch(adminHouseholdsProvider) : null;
    final groups = p.admin ? ref.watch(adminGroupsProvider) : null;

    Widget header(String text, {VoidCallback? onAdd, String? addTooltip}) =>
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 18, 0, 8),
          child: Row(children: [
            Expanded(
              child: Text(text,
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: context.appFg,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
            ),
            if (onAdd != null)
              IconButton(
                icon: const Icon(Icons.add_rounded),
                tooltip: addTooltip,
                onPressed: onAdd,
              ),
          ]),
        );

    Widget card(
            {required IconData icon,
            required String title,
            String? subtitle,
            required VoidCallback onTap}) =>
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: context.appCard,
            borderRadius: BorderRadius.circular(AppTokens.rMd),
            border: Border.all(color: context.appSeparator, width: 1),
            boxShadow: context.appShadowSm,
          ),
          child: ListTile(
            onTap: onTap,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTokens.rMd)),
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: AppTokens.accentGradient,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            title: Text(title,
                style: TextStyle(
                    color: context.appFg, fontWeight: FontWeight.w700)),
            subtitle: subtitle == null
                ? null
                : Text(subtitle,
                    style: TextStyle(color: context.appFgSub, fontSize: 12.5)),
            trailing:
                Icon(Icons.chevron_right_rounded, color: context.appFgTertiary),
          ),
        );

    Widget asyncList(AsyncValue<List<Map<String, dynamic>>> a,
            Widget Function(Map<String, dynamic>) item) =>
        a.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text(mealieErrorMessage(e) ?? e.toString(),
              style: TextStyle(color: context.appFgSub)),
          data: (list) => Column(children: [for (final m in list) item(m)]),
        );

    final me = ref.watch(currentUserProvider);
    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(title: Text(l.householdManagementTitle)),
      body: WithCookingModeFAB(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
            children: [
              if (mayHousehold) ...[
                header(l.myHouseholdSection),
                card(
                  icon: Icons.home_rounded,
                  title: l.householdPreferencesTitle,
                  subtitle: me?['household']?.toString(),
                  onTap: () => _openOwnHouseholdPrefs(context, ref),
                ),
              ],
              if (mayGroup) ...[
                header(l.myGroupSection),
                card(
                  icon: Icons.groups_rounded,
                  title: l.groupPreferencesTitle,
                  subtitle: me?['group']?.toString(),
                  onTap: () => _openOwnGroupPrefs(context, ref),
                ),
              ],
              if (p.admin && households != null && groups != null) ...[
                header(l.householdsTitle,
                    addTooltip: l.createHouseholdTitle,
                    onAdd: () => _createHousehold(
                        context, ref, groups.valueOrNull ?? const [])),
                asyncList(
                  households,
                  (h) => card(
                    icon: Icons.house_rounded,
                    title: h['name']?.toString() ?? '',
                    subtitle: [
                      if ((h['group'] ?? '').toString().isNotEmpty)
                        h['group'].toString(),
                      l.usersCount((h['users'] as List?)?.length ?? 0),
                    ].join(' · '),
                    onTap: () => _openHousehold(context, ref, h),
                  ),
                ),
                header(l.groupsTitle,
                    addTooltip: l.createGroupTitle,
                    onAdd: () => _createGroup(context, ref)),
                asyncList(
                  groups,
                  (g) => card(
                    icon: Icons.groups_rounded,
                    title: g['name']?.toString() ?? '',
                    subtitle: l.usersCount((g['users'] as List?)?.length ?? 0),
                    onTap: () => _openGroup(context, ref, g),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Einstellungs-Formular (geteilt) ──────────────────────────────────────

class _PrefsForm extends StatelessWidget {
  final bool household;
  final Map<String, dynamic> values;
  final void Function(String key, dynamic value) onChanged;
  const _PrefsForm(
      {required this.household, required this.values, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    Widget sw(String key, String title, {String? hint}) {
      if (!values.containsKey(key)) return const SizedBox.shrink();
      return SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title:
            Text(title, style: TextStyle(color: context.appFg, fontSize: 14)),
        subtitle: hint == null
            ? null
            : Text(hint,
                style: TextStyle(color: context.appFgSub, fontSize: 12)),
        value: values[key] == true,
        activeTrackColor: AppTokens.accent,
        onChanged: (v) => onChanged(key, v),
      );
    }

    if (!household) {
      return Column(children: [
        sw('privateGroup', l.privateGroupLabel, hint: l.privateGroupHint),
        sw('showAnnouncements', l.showAnnouncementsLabel),
      ]);
    }
    final locale = Localizations.localeOf(context).toString();
    // Mealie: 0 = Sonntag … 6 = Samstag (7. Jan. 2024 war ein Sonntag).
    String dayName(int i) =>
        DateFormat.EEEE(locale).format(DateTime(2024, 1, 7 + i));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        sw('privateHousehold', l.privateHouseholdLabel,
            hint: l.privateHouseholdHint),
        sw('lockRecipeEditsFromOtherHouseholds', l.lockRecipeEditsLabel,
            hint: l.lockRecipeEditsHint),
        if (values.containsKey('firstDayOfWeek'))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: DropdownButtonFormField<int>(
              initialValue: ((values['firstDayOfWeek'] as num?) ?? 0).toInt(),
              isExpanded: true,
              decoration: InputDecoration(
                labelText: l.firstDayOfWeekLabel,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTokens.rSm)),
              ),
              items: [
                for (var i = 0; i < 7; i++)
                  DropdownMenuItem(value: i, child: Text(dayName(i))),
              ],
              onChanged: (v) => onChanged('firstDayOfWeek', v ?? 0),
            ),
          ),
        sw('showAnnouncements', l.showAnnouncementsLabel),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 2),
          child: Text(l.householdRecipePreferencesTitle,
              style: TextStyle(
                  color: context.appFg,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
        ),
        sw('recipePublic', l.recipePublicDefaultLabel),
        sw('recipeShowNutrition', l.recipeShowNutritionDefaultLabel),
        sw('recipeShowAssets', l.recipeShowAssetsDefaultLabel),
        sw('recipeLandscapeView', l.recipeLandscapeDefaultLabel),
        sw('recipeDisableComments', l.recipeDisableCommentsDefaultLabel),
      ],
    );
  }
}

/// Eigene Haushalts-/Gruppeneinstellungen laden → bearbeiten → speichern.
Future<void> _openPrefsSheet(
  BuildContext context, {
  required String title,
  required String cacheKey,
  required Future<Map<String, dynamic>> Function() load,
  required Future<Object?> Function(Map<String, dynamic>) save,
  required bool household,
}) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.appCard,
      builder: (_) => _PrefsSheet(
          title: title,
          cacheKey: cacheKey,
          load: load,
          save: save,
          household: household),
    );

class _PrefsSheet extends StatefulWidget {
  final String title;
  final String cacheKey;
  final Future<Map<String, dynamic>> Function() load;
  final Future<Object?> Function(Map<String, dynamic>) save;
  final bool household;
  const _PrefsSheet(
      {required this.title,
      required this.cacheKey,
      required this.load,
      required this.save,
      required this.household});

  @override
  State<_PrefsSheet> createState() => _PrefsSheetState();
}

class _PrefsSheetState extends State<_PrefsSheet> {
  Map<String, dynamic>? _values;
  Object? _loadError;
  bool _saving = false;
  bool _edited = false;

  // Cache-first: gespeicherten Stand sofort zeigen, Server-Stand übernehmen,
  // solange noch nichts geändert wurde. Offline bleibt der Cache.
  @override
  void initState() {
    super.initState();
    LocalCache.loadJsonList(widget.cacheKey).then((c) {
      if (mounted && c.isNotEmpty && _values == null) {
        setState(() {
          _values = Map.of(c.first);
          _loadError = null;
        });
      }
    });
    widget.load().then((v) {
      unawaited(LocalCache.saveJsonList(widget.cacheKey, [v]));
      if (mounted && !_edited) setState(() => _values = v);
    }, onError: (Object e) {
      if (mounted && _values == null) setState(() => _loadError = e);
    });
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    setState(() => _saving = true);
    try {
      await widget.save(_values!);
      unawaited(LocalCache.saveJsonList(widget.cacheKey, [_values!]));
      nav.pop();
      messenger.showSnackBar(SnackBar(content: Text(l.preferencesSaved)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
          SnackBar(content: Text(mealieErrorMessage(e) ?? l.saveFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.title,
              style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: context.appFg,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          if (_loadError != null)
            Text(mealieErrorMessage(_loadError!) ?? _loadError.toString(),
                style: TextStyle(color: context.appFgSub))
          else if (_values == null)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            Flexible(
              child: SingleChildScrollView(
                child: _PrefsForm(
                  household: widget.household,
                  values: _values!,
                  onChanged: (k, v) => setState(() {
                    _edited = true;
                    _values![k] = v;
                  }),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: AppTokens.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: _saving ? null : _save,
              child: Text(l.save),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Admin: Haushalt / Gruppe bearbeiten ──────────────────────────────────

class _AdminEntitySheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> entity;
  final bool household;
  const _AdminEntitySheet({required this.entity, required this.household});

  @override
  ConsumerState<_AdminEntitySheet> createState() => _AdminEntitySheetState();
}

class _AdminEntitySheetState extends ConsumerState<_AdminEntitySheet> {
  late final _name =
      TextEditingController(text: widget.entity['name']?.toString() ?? '');
  late final Map<String, dynamic> _prefs = widget.household
      ? _pickHouseholdPrefs(
          (widget.entity['preferences'] as Map?)?.cast<String, dynamic>())
      : _pickGroupPrefs(
          (widget.entity['preferences'] as Map?)?.cast<String, dynamic>());
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final name = _name.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    final api = ref.read(apiServiceProvider);
    final id = widget.entity['id'].toString();
    try {
      if (widget.household) {
        await api.updateHouseholdAdmin(
          id: id,
          groupId: widget.entity['groupId'].toString(),
          name: name,
          preferences: _prefs.isEmpty ? null : _prefs,
        );
      } else {
        await api.updateGroupAdmin(
            id: id, name: name, preferences: _prefs.isEmpty ? null : _prefs);
      }
      nav.pop();
      messenger.showSnackBar(SnackBar(content: Text(l.preferencesSaved)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
          SnackBar(content: Text(mealieErrorMessage(e) ?? l.saveFailed)));
    }
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final name = widget.entity['name']?.toString() ?? '';
    final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: ctx.appCard,
            content: Text(
                widget.household
                    ? l.deleteHouseholdConfirm(name)
                    : l.deleteGroupConfirm(name),
                style: TextStyle(color: ctx.appFg)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l.cancel)),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l.delete),
              ),
            ],
          ),
        ) ??
        false;
    if (!ok) return;
    try {
      final api = ref.read(apiServiceProvider);
      final id = widget.entity['id'].toString();
      if (widget.household) {
        await api.deleteHousehold(id);
      } else {
        await api.deleteGroup(id);
      }
      nav.pop();
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(mealieErrorMessage(e) ?? l.deleteFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final users = (widget.entity['users'] as List?)?.length ?? 0;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _name,
                    textCapitalization: TextCapitalization.sentences,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      labelText: widget.household
                          ? l.householdNameLabel
                          : l.groupNameLabel,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTokens.rSm)),
                    ),
                  ),
                  if (widget.household &&
                      (widget.entity['group'] ?? '').toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('${l.groupLabel}: ${widget.entity['group']}',
                          style: TextStyle(color: context.appFgSub)),
                    ),
                  const SizedBox(height: 12),
                  Text(
                      widget.household
                          ? l.householdPreferencesTitle
                          : l.groupPreferencesTitle,
                      style: TextStyle(
                          color: context.appFg,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  _PrefsForm(
                    household: widget.household,
                    values: _prefs,
                    onChanged: (k, v) => setState(() => _prefs[k] = v),
                  ),
                  const SizedBox(height: 8),
                  // Mealie verweigert das Löschen, solange Benutzer drin sind.
                  TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: _saving ? null : _delete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: Text(users > 0
                        ? '${l.delete} (${l.usersCount(users)})'
                        : l.delete),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: AppTokens.accent,
                padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: _saving ? null : _save,
            child: Text(l.save),
          ),
        ],
      ),
    );
  }
}
