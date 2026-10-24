import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/app_settings.dart';
import '../../../core/models/organizer_item.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/utils/meal_types.dart';
import '../../../core/utils/search_match.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart' show SheetHandle;
import '../../organizers/providers/organizers_provider.dart';
import '../../../core/models/mealplan_rule.dart';
import '../../../core/api/api_service.dart' show userErrorMessage;
import '../../../core/providers/permissions_provider.dart';
import '../providers/mealplan_provider.dart';
import '../providers/mealplan_rules_provider.dart';
import '../screens/meal_rule_edit_screen.dart';
import '../../../core/utils/mealie_version.dart';
import 'calendar_feed_sheet.dart';

// ---------------------------------------------------------------------------
// Zahnrad im Mahlzeitenplan = „Essensplan Einstellungen" (Mealie-Begriff):
// Wochenbeginn direkt, Kalender-Abo und Würfelregeln als eigene Untermenüs.
//
// Würfelregeln: Oben wählt der Nutzer das System — „App-Auswahl" (unten
// beschrieben) oder „Mealie-Regeln" (die Regeln des Haushalts vom Server,
// wie der Zufallsknopf der Webapp).
//
// App-Auswahl: pro Mahlzeit beliebig viele
// Kategorien und Schlagworte wählen. Der Würfel im „Mahlzeit hinzufügen"-
// Fenster schlägt dann nur Rezepte vor, die mindestens einen davon haben.
// Dieselbe Auswahl darf in mehreren Mahlzeiten vorkommen. Jede Änderung wird
// sofort gespeichert (AppSettings.mealDiceFilters, nur lokal).
// ---------------------------------------------------------------------------

Future<void> showMealDiceSettingsSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: context.appCard,
      builder: (_) => const _MealplanSettingsSheet(),
    );

Future<void> _showDiceRulesSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: context.appCard,
      builder: (_) => const _MealDiceSettingsSheet(),
    );

class _MealplanSettingsSheet extends ConsumerWidget {
  const _MealplanSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final useMealie =
        ref.watch(settingsProvider).valueOrNull?.mealDiceUseMealieRules ??
            false;
    Widget entry(IconData icon, String title, String subtitle,
            VoidCallback onTap) =>
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: AppTokens.accentDeep),
          title: Text(title),
          subtitle: Text(subtitle,
              style: TextStyle(color: context.appFgSub, fontSize: 12.5)),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: onTap,
        );
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: SheetHandle()),
            Text(l.mealplanSettingsTitle,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3)),
            const SizedBox(height: 12),
            // Wochenbeginn — direkt die Mealie-Haushalts-Einstellung.
            const _WeekStartSection(),
            const SizedBox(height: 8),
            entry(
              Icons.casino_rounded,
              l.mealDiceRulesTitle,
              // Zeigt, welches System der Würfel gerade nutzt.
              '${l.mealDiceModeTitle}: '
                  '${useMealie ? l.mealRulesTitle : l.mealDiceModeApp}',
              () => _showDiceRulesSheet(context),
            ),
            // Mealie ≥ 3.29: Mahlzeitplan als Kalender abonnieren (iCal).
            if (ref.watch(mealie329Provider))
              entry(Icons.event_rounded, l.calendarFeedTitle,
                  l.calendarFeedSubtitle, () => showCalendarFeedSheet(context)),
          ],
        ),
      ),
    );
  }
}

class _MealDiceSettingsSheet extends ConsumerStatefulWidget {
  const _MealDiceSettingsSheet();

  @override
  ConsumerState<_MealDiceSettingsSheet> createState() =>
      _MealDiceSettingsSheetState();
}

class _MealDiceSettingsSheetState
    extends ConsumerState<_MealDiceSettingsSheet> {
  static const _slots = kMealTypes; // alle Mealie-Mahlzeitentypen
  String _slot = 'breakfast';

  /// Suche über Kategorien UND Schlagworte (gleiche Logik wie die Rezeptsuche:
  /// Groß/Klein, Akzente, Wortreihenfolge egal).
  String _query = '';

  // Beim Antippen der Suche: Sheet ganz aufziehen und das Suchfeld nach
  // oben scrollen — sonst lagen die Treffer darunter hinter der Tastatur.
  final _sheet = DraggableScrollableController();
  final _searchFocus = FocusNode();
  final _searchKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(_onSearchFocus);
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _sheet.dispose();
    super.dispose();
  }

  Future<void> _onSearchFocus() async {
    if (!_searchFocus.hasFocus) return;
    if (_sheet.isAttached) {
      await _sheet.animateTo(0.95,
          duration: const Duration(milliseconds: 220), curve: Curves.easeOut);
    }
    // Warten, bis die Tastatur (und damit das untere Polster) da ist.
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final ctx = _searchKey.currentContext;
    if (!mounted || ctx == null || !ctx.mounted) return;
    await Scrollable.ensureVisible(ctx,
        alignment: 0.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut);
  }

  String _slotLabel(AppLocalizations l, String slot) =>
      '${mealTypeEmoji(slot)} ${mealTypeLabel(slot, l)}';

  void _toggle(AppSettings settings, String key) {
    HapticFeedback.selectionClick();
    final current =
        List<String>.of(settings.mealDiceFilters[_slot] ?? const []);
    if (!current.remove(key)) current.add(key);
    ref.read(settingsProvider.notifier).save(settings.copyWith(
        mealDiceFilters: {...settings.mealDiceFilters, _slot: current}));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider).valueOrNull;
    if (settings == null) return const SizedBox.shrink();
    final selected = settings.mealDiceFilters[_slot] ?? const [];
    final useMealie = settings.mealDiceUseMealieRules;
    final categories =
        ref.watch(organizersProvider(OrganizerKind.category)).valueOrNull ??
            const <OrganizerItem>[];
    final tags = ref.watch(organizersProvider(OrganizerKind.tag)).valueOrNull ??
        const <OrganizerItem>[];

    final terms = searchTerms(_query);
    List<OrganizerItem> filtered(List<OrganizerItem> items) => terms.isEmpty
        ? items
        : items
            .where((i) => terms.every(normalizeForSearch(i.name).contains))
            .toList();

    Widget chips(List<OrganizerItem> all, String prefix) {
      final items = filtered(all);
      if (items.isEmpty) {
        if (all.isNotEmpty) {
          // Es gibt Einträge, nur passt keiner zur Suche.
          return Text('—',
              style: TextStyle(color: context.appFgTertiary, fontSize: 13));
        }
        return Text(l.organizerEmpty,
            style: TextStyle(color: context.appFgTertiary, fontSize: 13));
      }
      return Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final i in items)
            FilterChip(
              label: Text(i.name),
              selected: selected.contains('$prefix${i.id}'),
              onSelected: (_) => _toggle(settings, '$prefix${i.id}'),
              selectedColor: AppTokens.accent.withValues(alpha: 0.25),
              checkmarkColor: AppTokens.accentDeep,
            ),
        ],
      );
    }

    return DraggableScrollableSheet(
      controller: _sheet,
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (_, scroll) => ListView(
        controller: scroll,
        // Unten Platz in Tastaturhöhe: alle Treffer lassen sich über die
        // Tastatur scrollen, ohne dass die Liste zurückfällt.
        padding: EdgeInsets.fromLTRB(
            16, 0, 16, 24 + MediaQuery.viewInsetsOf(context).bottom),
        children: [
          const SheetHandle(),
          Text(l.mealDiceRulesTitle,
              style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: context.appFg,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3)),
          const SizedBox(height: 12),
          // System wählen: App-eigene Auswahl oder Mealie-Regeln.
          Text(l.mealDiceModeTitle,
              style: TextStyle(color: context.appFgSub, fontSize: 12.5)),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<bool>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                    value: false,
                    icon: const Icon(Icons.tune_rounded, size: 18),
                    label: Text(l.mealDiceModeApp)),
                ButtonSegment(
                    value: true,
                    icon: const Icon(Icons.rule_rounded, size: 18),
                    label: Text(l.mealRulesTitle)),
              ],
              selected: {useMealie},
              onSelectionChanged: (v) {
                HapticFeedback.selectionClick();
                ref
                    .read(settingsProvider.notifier)
                    .save(settings.copyWith(mealDiceUseMealieRules: v.first));
              },
            ),
          ),
          const SizedBox(height: 16),
          if (useMealie)
            const _MealieRulesSection()
          else ...[
            Text(l.mealDiceSettingsHint,
                style: TextStyle(
                    color: context.appFgSub, fontSize: 13, height: 1.4)),
            const SizedBox(height: 14),
            // Mahlzeit wählen — Zähler zeigt, wie viele Einträge gesetzt sind.
            // Eine Zeile, seitlich wischbar (alle 7 Mealie-Typen).
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final s in _slots)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(() {
                          final n = settings.mealDiceFilters[s]?.length ?? 0;
                          return n == 0
                              ? _slotLabel(l, s)
                              : '${_slotLabel(l, s)} ($n)';
                        }()),
                        selected: _slot == s,
                        onSelected: (_) => setState(() => _slot = s),
                        selectedColor: AppTokens.accent.withValues(alpha: 0.25),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              key: _searchKey,
              focusNode: _searchFocus,
              onChanged: (v) => setState(() => _query = v),
              style: TextStyle(color: context.appFg),
              decoration: InputDecoration(
                hintText: l.search,
                prefixIcon: Icon(Icons.search_rounded, color: context.appFgSub),
                filled: true,
                fillColor: context.appSurface2,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.rSm),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(l.categories,
                style: TextStyle(
                    color: context.appFg,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            chips(categories, 'c:'),
            const SizedBox(height: 18),
            Text(l.tags,
                style: TextStyle(
                    color: context.appFg,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            chips(tags, 't:'),
            if (selected.isEmpty) ...[
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 18, color: AppTokens.accentDeep),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(l.mealDiceSettingsNoneHint,
                        style: TextStyle(
                            color: context.appFgSub,
                            fontSize: 12,
                            height: 1.4)),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mealie-Regeln (Server, gelten auch in der Webapp) — Liste + Anlegen.
// ---------------------------------------------------------------------------

class _MealieRulesSection extends ConsumerWidget {
  const _MealieRulesSection();

  Future<void> _open(BuildContext context, MealPlanRule? rule) =>
      Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (_) => MealRuleEditScreen(rule: rule)));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final rules = ref.watch(mealplanRulesProvider).valueOrNull ?? const [];
    final names = organizerNamesById(ref);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.mealRulesHint,
            style: TextStyle(
                color: context.appFgSub, fontSize: 12.5, height: 1.4)),
        const SizedBox(height: 10),
        for (final r in rules)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: context.appSurface2,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTokens.rSm)),
            child: ListTile(
              onTap: () => _open(context, r),
              leading:
                  const Icon(Icons.rule_rounded, color: AppTokens.accentDeep),
              title: Text(
                  '${ruleDayLabel(context, r.day)} · '
                  '${ruleEntryTypeLabel(l, r.entryType)}',
                  style: TextStyle(
                      color: context.appFg, fontWeight: FontWeight.w600)),
              subtitle: Text(ruleFilterSummary(l, r.queryFilterString, names),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.appFgSub, fontSize: 12.5)),
              trailing: Icon(Icons.chevron_right_rounded,
                  color: context.appFgTertiary),
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => _open(context, null),
            icon: const Icon(Icons.add_rounded),
            label: Text(l.mealRuleAdd),
          ),
        ),
      ],
    );
  }
}

// ── Wochenbeginn (Mealie-Haushalts-Einstellung) ──────────────────────────
// Zeigt und ändert `firstDayOfWeek` des eigenen Haushalts in Mealie — App
// und Webapp beginnen die Woche dadurch am selben Tag. Ändern darf nur, wer
// den Haushalt verwalten kann (Mealie: can_manage_household).

class _WeekStartSection extends ConsumerStatefulWidget {
  const _WeekStartSection();

  @override
  ConsumerState<_WeekStartSection> createState() => _WeekStartSectionState();
}

class _WeekStartSectionState extends ConsumerState<_WeekStartSection> {
  bool _saving = false;

  Future<void> _change(int mealieDay) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    HapticFeedback.selectionClick();
    setState(() => _saving = true);
    try {
      await setHouseholdFirstDayOfWeek(ref, mealieDay);
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(userErrorMessage(e, l.saveFailed))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final perms = ref.watch(userPermissionsProvider);
    final mayChange = perms.admin || perms.canManageHousehold;
    final dart = ref.watch(weekStartWeekdayProvider);
    final current = dart == DateTime.sunday ? 0 : dart; // → Mealie 0–6
    // Mealie 0 = Sonntag: 7.1.2024 war ein Sonntag.
    String dayName(int i) =>
        DateFormat.EEEE(locale).format(DateTime(2024, 1, 7 + i));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<int>(
          key: ValueKey(current),
          initialValue: current,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: l.firstDayOfWeekLabel,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTokens.rSm)),
            suffixIcon: _saving
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : null,
          ),
          items: [
            for (var i = 0; i < 7; i++)
              DropdownMenuItem(value: i, child: Text(dayName(i))),
          ],
          onChanged: mayChange && !_saving
              ? (v) {
                  if (v != null && v != current) _change(v);
                }
              : null,
        ),
        const SizedBox(height: 6),
        Text(mayChange ? l.weekStartSyncHint : l.weekStartNoPermission,
            style: TextStyle(color: context.appFgSub, fontSize: 12.5)),
      ],
    );
  }
}
