// Einheiten-Auswahl „Wie angegeben / Metrisch / Imperial" (Issue #50) —
// Gegenstück zu Mealie-Webs RecipeUnitSystemButton. Die Wahl gilt wie dort
// für alle Rezepte (gerätelokal) und ändert nur die Anzeige.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/app_settings.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/utils/unit_conversion.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart' show SheetHandle;

/// Aktuell gewähltes Einheitensystem (`null` = wie angegeben).
final unitSystemProvider = Provider<UnitSystem?>((ref) =>
    unitSystemFromKey(ref.watch(settingsProvider).valueOrNull?.unitSystem));

/// Kurzer Name des Systems (Mealie `activeLabel`).
String unitSystemLabel(AppLocalizations l, UnitSystem? s) => switch (s) {
      UnitSystem.metric => l.unitSystemMetric,
      UnitSystem.us => l.unitSystemImperial,
      null => l.unitSystemAsWritten,
    };

/// Hat das Rezept überhaupt Zutaten mit Mealie-Standardisierung? Sonst wie
/// in der Webapp deaktiviert — der Eintrag bleibt sichtbar, tut aber nichts.
bool recipeHasConvertibleIngredients(RecipeDetail recipe) =>
    recipe.recipeIngredient.any(canConvertIngredient);

Future<void> showUnitSystemSheet(
    BuildContext context, WidgetRef ref, RecipeDetail recipe) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (sheetCtx) =>
        _UnitSystemSheet(convertible: recipeHasConvertibleIngredients(recipe)),
  );
}

class _UnitSystemSheet extends ConsumerWidget {
  final bool convertible;
  const _UnitSystemSheet({required this.convertible});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final current = ref.watch(unitSystemProvider);
    final options = <(UnitSystem?, String)>[
      (null, l.unitSystemAsWritten),
      (UnitSystem.metric, l.unitSystemMetricHint),
      (UnitSystem.us, l.unitSystemImperialHint),
    ];

    Future<void> select(UnitSystem? s) async {
      HapticFeedback.selectionClick();
      final base =
          ref.read(settingsProvider).valueOrNull ?? const AppSettings();
      await ref
          .read(settingsProvider.notifier)
          .save(base.copyWith(unitSystem: unitSystemKey(s)));
      if (context.mounted) Navigator.pop(context);
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetHandle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
              child: Text(l.unitSystemTitle,
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: context.appFg,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                  convertible ? l.unitSystemHint : l.unitSystemUnavailable,
                  style: TextStyle(color: context.appFgSub, fontSize: 13)),
            ),
            for (final (value, label) in options)
              ListTile(
                enabled: convertible || value == null,
                leading: Icon(
                  value == current
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: value == current
                      ? AppTokens.accentDeep
                      : context.appFgTertiary,
                ),
                title: Text(label,
                    style: TextStyle(
                        color: convertible || value == null
                            ? context.appFg
                            : context.appFgTertiary,
                        fontWeight: FontWeight.w600)),
                onTap: () => select(value),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
