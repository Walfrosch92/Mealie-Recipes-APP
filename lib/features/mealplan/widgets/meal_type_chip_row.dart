import 'package:flutter/material.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/utils/meal_types.dart';
import '../../../shared/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Mahlzeitentyp wählen: alle 7 Typen wie in Mealie-Web in EINER Zeile, nach
// links/rechts wischbar. Gemeinsam genutzt von „Mahlzeit hinzufügen",
// „Einplanen" (Rezeptdetail) und „Verschieben". Der gewählte Chip wird beim
// Öffnen in den sichtbaren Bereich gescrollt (z. B. „Nachspeise").
// ---------------------------------------------------------------------------

class MealTypeChipRow extends StatefulWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  /// Zusätzlicher, Mealie unbekannter Typ (alte/fremde Einträge) — bleibt
  /// wählbar, damit „Verschieben" ihn nicht stillschweigend ändert.
  final bool includeUnknownSelected;

  /// Seitenabstand innerhalb der Zeile.
  final double sidePadding;

  const MealTypeChipRow({
    super.key,
    required this.selected,
    required this.onChanged,
    this.includeUnknownSelected = false,
    this.sidePadding = 6,
  });

  @override
  State<MealTypeChipRow> createState() => _MealTypeChipRowState();
}

class _MealTypeChipRowState extends State<MealTypeChipRow> {
  final _selectedKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _selectedKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(ctx, alignment: 0.5, duration: Duration.zero);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final types = [
      ...kMealTypes,
      if (widget.includeUnknownSelected &&
          !kMealTypes.contains(widget.selected))
        widget.selected,
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: widget.sidePadding),
      child: Row(
        children: [
          for (final type in types)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: _chip(context, l, type, type == widget.selected),
            ),
        ],
      ),
    );
  }

  Widget _chip(
      BuildContext context, AppLocalizations l, String type, bool isSelected) {
    return GestureDetector(
      key: isSelected ? _selectedKey : null,
      onTap: () => widget.onChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTokens.accentGradient : null,
          color: isSelected ? null : context.appSurface2,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                      color: Color(0x40FF7800),
                      blurRadius: 10,
                      offset: Offset(0, 3))
                ]
              : null,
        ),
        child: Text('${mealTypeEmoji(type)} ${mealTypeLabel(type, l)}',
            style: TextStyle(
                color: isSelected ? Colors.white : context.appFgSub,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
      ),
    );
  }
}
