import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart' show mealieErrorMessage;
import '../../../core/models/mealplan_rule.dart';
import '../../../core/models/organizer_item.dart';
import '../../../core/utils/cookbook_query_filter.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/async_action_button.dart';
import '../../../shared/widgets/query_filter_editor.dart';
import '../../organizers/providers/organizers_provider.dart';
import '../providers/mealplan_rules_provider.dart';

// ---------------------------------------------------------------------------
// Mahlzeitenplan-Regel anlegen/bearbeiten — wie „Meal Plan Rules" in den
// Haushaltseinstellungen der Mealie-Webapp: Tag, Mahlzeit, Filter.
// ---------------------------------------------------------------------------

/// Wochentag in der App-Sprache (`monday` → „Montag").
String ruleDayLabel(BuildContext context, String day) {
  final l = AppLocalizations.of(context)!;
  final i = kRuleDays.indexOf(day);
  if (i < 0) return l.mealRuleAnyDay;
  // 1. Januar 2024 war ein Montag.
  return DateFormat.EEEE(Localizations.localeOf(context).toString())
      .format(DateTime(2024, 1, 1 + i));
}

String ruleEntryTypeLabel(AppLocalizations l, String type) => switch (type) {
      'breakfast' => l.breakfast,
      'lunch' => l.lunch,
      'dinner' => l.dinner,
      'side' => l.mealTypeSide,
      'snack' => l.mealTypeSnack,
      'drink' => l.mealTypeDrink,
      'dessert' => l.mealTypeDessert,
      _ => l.mealRuleAnyMeal,
    };

/// Kurzbeschreibung des Filters für die Regel-Liste: Namen von Kategorien,
/// Schlagworten, Utensilien; sonst die Anzahl der Bedingungen.
String ruleFilterSummary(
    AppLocalizations l, String filter, Map<String, String> namesById) {
  if (filter.trim().isEmpty) return l.mealRuleAllRecipes;
  final rows = tryParseCookbookQueryFilter(filter);
  if (rows == null) return l.mealRuleConditionCount(1);
  final parts = <String>[];
  for (final r in rows) {
    final names = [for (final id in r.valueIds) namesById[id]]
        .whereType<String>()
        .toList();
    if (names.isEmpty || r.valueIds.length != names.length) {
      return l.mealRuleConditionCount(rows.length);
    }
    final joined = names.join(', ');
    parts.add(r.op == CookbookFilterOp.isNotOneOf ? '≠ $joined' : joined);
  }
  return parts.join(' · ');
}

/// id → Name aller Kategorien, Schlagworte und Utensilien (für Zusammenfassungen).
Map<String, String> organizerNamesById(WidgetRef ref) => {
      for (final k in OrganizerKind.values)
        for (final i in ref.watch(organizersProvider(k)).valueOrNull ??
            const <OrganizerItem>[])
          i.id: i.name,
    };

class MealRuleEditScreen extends ConsumerStatefulWidget {
  /// null = neue Regel.
  final MealPlanRule? rule;
  const MealRuleEditScreen({super.key, this.rule});

  @override
  ConsumerState<MealRuleEditScreen> createState() => _MealRuleEditScreenState();
}

class _MealRuleEditScreenState extends ConsumerState<MealRuleEditScreen> {
  final _filterCtrl = QueryFilterEditorController();
  late String _day = widget.rule?.day ?? 'unset';
  late String _type = widget.rule?.entryType ?? 'unset';
  String? _error;

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _error = null);
    try {
      await ref.read(mealplanRulesProvider.notifier).save(MealPlanRule(
            id: widget.rule?.id ?? '',
            day: _day,
            entryType: _type,
            queryFilterString: _filterCtrl.compose(),
          ));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _error = mealieErrorMessage(e) ?? l.saveFailed);
      }
    }
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: ctx.appCard,
            content: Text(l.mealRuleDeleteConfirm,
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
    if (!ok || !mounted) return;
    try {
      await ref.read(mealplanRulesProvider.notifier).delete(widget.rule!);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => _error = l.deleteFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Text(
            widget.rule == null ? l.mealRuleNewTitle : l.mealRuleEditTitle),
        actions: [
          if (widget.rule != null)
            IconButton(
              tooltip: l.delete,
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              onPressed: _delete,
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            DropdownButtonFormField<String>(
              initialValue: _day,
              isExpanded: true,
              decoration: InputDecoration(
                  labelText: l.mealRuleDay, border: const OutlineInputBorder()),
              items: [
                DropdownMenuItem(value: 'unset', child: Text(l.mealRuleAnyDay)),
                for (final d in kRuleDays)
                  DropdownMenuItem(
                      value: d, child: Text(ruleDayLabel(context, d))),
              ],
              onChanged: (v) => setState(() => _day = v ?? 'unset'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _type,
              isExpanded: true,
              decoration: InputDecoration(
                  labelText: l.mealRuleMealType,
                  border: const OutlineInputBorder()),
              items: [
                DropdownMenuItem(
                    value: 'unset', child: Text(l.mealRuleAnyMeal)),
                for (final t in kRuleEntryTypes)
                  DropdownMenuItem(
                      value: t, child: Text(ruleEntryTypeLabel(l, t))),
              ],
              onChanged: (v) => setState(() => _type = v ?? 'unset'),
            ),
            const SizedBox(height: 24),
            Text(l.mealRuleConditionsTitle,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            QueryFilterEditor(
              controller: _filterCtrl,
              initialFilter: widget.rule?.queryFilterString ?? '',
            ),
            const SizedBox(height: 24),
            if (_error != null) ...[
              Text(_error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
              const SizedBox(height: 16),
            ],
            AsyncActionButton(expand: true, label: l.save, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
