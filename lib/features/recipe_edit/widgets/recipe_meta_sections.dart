import 'package:flutter/material.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/recipe_detail.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../models/recipe_draft.dart';
import 'edit_common.dart';

// ---------------------------------------------------------------------------
// Portionen & Zeiten
// ---------------------------------------------------------------------------

class TimesServingsContent extends StatelessWidget {
  final RecipeDraft draft;
  final double? rating;
  final ValueChanged<double?> onRatingChanged;
  final VoidCallback onChanged;

  const TimesServingsContent({
    super.key,
    required this.draft,
    required this.rating,
    required this.onRatingChanged,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final caps = draft.caps;
    const numKb = TextInputType.numberWithOptions(decimal: true);

    Widget timeRow(String label, DraftTime t) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EditSubheading(label),
              Row(children: [
                SizedBox(
                  width: 84,
                  child: TextField(
                    onTapOutside: unfocusOnTapOutside,
                    controller: t.hours,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => onChanged(),
                    style: TextStyle(color: context.appFg, fontSize: 14),
                    decoration:
                        filledEditDecoration(context, suffixText: l.hoursShort),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 92,
                  child: TextField(
                    onTapOutside: unfocusOnTapOutside,
                    controller: t.minutes,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => onChanged(),
                    style: TextStyle(color: context.appFg, fontSize: 14),
                    decoration: filledEditDecoration(context,
                        suffixText: l.minutesShort),
                  ),
                ),
                if (caps.timeSeconds) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onTapOutside: unfocusOnTapOutside,
                      controller: t.extra,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (_) => onChanged(),
                      style: TextStyle(color: context.appFg, fontSize: 14),
                      decoration:
                          filledEditDecoration(context, hint: l.timeExtraHint),
                    ),
                  ),
                ],
              ]),
            ],
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(
              child: TextField(
                onTapOutside: unfocusOnTapOutside,
                controller: draft.servings,
                keyboardType: numKb,
                onChanged: (_) => onChanged(),
                style: TextStyle(color: context.appFg, fontSize: 14),
                decoration:
                    filledEditDecoration(context, label: l.recipeServings),
              ),
            ),
            if (caps.yieldQuantity) ...[
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  onTapOutside: unfocusOnTapOutside,
                  controller: draft.yieldQuantity,
                  keyboardType: numKb,
                  onChanged: (_) => onChanged(),
                  style: TextStyle(color: context.appFg, fontSize: 14),
                  decoration:
                      filledEditDecoration(context, label: l.yieldLabel),
                ),
              ),
            ],
          ]),
          const SizedBox(height: 10),
          TextField(
            onTapOutside: unfocusOnTapOutside,
            controller: draft.yieldText,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => onChanged(),
            style: TextStyle(color: context.appFg, fontSize: 14),
            decoration: filledEditDecoration(context, label: l.yieldTextLabel),
          ),
          const SizedBox(height: 14),
          timeRow(l.prepTimeLabel, draft.prep),
          timeRow(l.performTimeLabel, draft.perform),
          timeRow(l.totalTimeLabel, draft.total),
          Row(
            children: [
              Text(l.rating,
                  style: TextStyle(color: context.appFgSub, fontSize: 14)),
              const Spacer(),
              ...List.generate(5, (i) {
                final star = i + 1;
                return GestureDetector(
                  onTap: () => onRatingChanged(
                      rating == star.toDouble() ? null : star.toDouble()),
                  child: Icon(
                      (rating ?? 0) >= star
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 28),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notizen
// ---------------------------------------------------------------------------

class NotesContent extends StatelessWidget {
  final RecipeDraft draft;
  final VoidCallback onChanged;
  final void Function(DraftNote) onDelete;

  const NotesContent({
    super.key,
    required this.draft,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              for (final n in draft.notes)
                Padding(
                  key: ValueKey(n.uid),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(children: [
                          TextField(
                            onTapOutside: unfocusOnTapOutside,
                            controller: n.title,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (_) => onChanged(),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                            decoration: outlinedEditDecoration(l.noteTitleHint),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            onTapOutside: unfocusOnTapOutside,
                            controller: n.text,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            minLines: 2,
                            maxLines: null,
                            onChanged: (_) => onChanged(),
                            decoration: outlinedEditDecoration(l.noteTextHint),
                          ),
                        ]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 20),
                        onPressed: () => onDelete(n),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        EditActionTile(
          icon: Icons.add_circle_outline,
          title: l.addNote,
          onTap: () {
            draft.notes.add(DraftNote.empty());
            onChanged();
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Nährwerte
// ---------------------------------------------------------------------------

class NutritionContent extends StatelessWidget {
  final RecipeDraft draft;
  final VoidCallback onChanged;
  const NutritionContent(
      {super.key, required this.draft, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final labels = <String, (String, String)>{
      'calories': (l.nutritionCalories, 'kcal'),
      'fatContent': (l.nutritionFat, 'g'),
      'saturatedFatContent': (l.nutritionSaturatedFat, 'g'),
      'transFatContent': (l.nutritionTransFat, 'g'),
      'unsaturatedFatContent': (l.nutritionUnsaturatedFat, 'g'),
      'cholesterolContent': (l.nutritionCholesterol, 'mg'),
      'sodiumContent': (l.nutritionSodium, 'mg'),
      'carbohydrateContent': (l.nutritionCarbohydrates, 'g'),
      'fiberContent': (l.nutritionFiber, 'g'),
      'sugarContent': (l.nutritionSugar, 'g'),
      'proteinContent': (l.nutritionProtein, 'g'),
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EditSubheading(l.nutritionPerServing),
          LayoutBuilder(builder: (context, c) {
            final w = (c.maxWidth - 8) / 2;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final k in kNutritionKeys)
                  SizedBox(
                    width: w,
                    child: TextField(
                      onTapOutside: unfocusOnTapOutside,
                      controller: draft.nutrition[k],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => onChanged(),
                      style: TextStyle(color: context.appFg, fontSize: 14),
                      decoration: filledEditDecoration(context,
                          label: labels[k]!.$1, suffixText: labels[k]!.$2),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Einstellungen (Rezept-Einstellungen, Besitzer, Ursprüngliche URL, Extras)
// ---------------------------------------------------------------------------

class RecipeSettingsContent extends StatelessWidget {
  final RecipeDraft draft;

  /// Nur der Ersteller darf sperren/entsperren (wie Mealie).
  final bool isOwner;

  /// Besitzer ändern: Ersteller oder Admin.
  final bool canEditOwner;
  final String ownerName;
  final String? ownerCacheKey;

  /// API-Extras nur mit „Erweiterte Funktionen" (wie die Webapp).
  final bool showExtras;
  final VoidCallback onPickOwner;
  final VoidCallback onChanged;

  const RecipeSettingsContent({
    super.key,
    required this.draft,
    required this.isOwner,
    required this.canEditOwner,
    required this.ownerName,
    required this.ownerCacheKey,
    required this.showExtras,
    required this.onPickOwner,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final labels = {
      'public': l.settingPublicRecipe,
      'showNutrition': l.settingShowNutrition,
      'showAssets': l.settingShowAssets,
      'landscapeView': l.settingLandscapeView,
      'disableComments': l.settingDisableComments,
      'disableAmount': l.settingDisableAmount,
      'locked': l.settingLocked,
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final k in kRecipeSettingKeys)
            if (draft.settings.containsKey(k))
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(labels[k]!,
                    style: TextStyle(color: context.appFg, fontSize: 14)),
                subtitle: k == 'locked' && !isOwner
                    ? Text(l.settingLockedOwnerOnly,
                        style: TextStyle(color: context.appFgSub, fontSize: 12))
                    : null,
                value: draft.settings[k]!,
                activeTrackColor: AppTokens.accent,
                onChanged: k == 'locked' && !isOwner
                    ? null
                    : (v) {
                        draft.settings[k] = v;
                        onChanged();
                      },
              ),
          const SizedBox(height: 8),
          EditSubheading(l.ownerLabel),
          Material(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: canEditOwner ? onPickOwner : null,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(children: [
                  UserAvatar(
                    userId: draft.userId,
                    name: ownerName,
                    radius: 16,
                    cacheKey: ownerCacheKey,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(ownerName.isEmpty ? '—' : ownerName,
                        style: TextStyle(color: context.appFg, fontSize: 14)),
                  ),
                  if (canEditOwner)
                    Icon(Icons.chevron_right_rounded,
                        color: context.appFgTertiary),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            onTapOutside: unfocusOnTapOutside,
            controller: draft.orgUrl,
            keyboardType: TextInputType.url,
            autocorrect: false,
            onChanged: (_) => onChanged(),
            style: TextStyle(color: context.appFg, fontSize: 14),
            decoration: filledEditDecoration(context,
                label: l.originalUrlLabel, hint: 'https://…'),
          ),
          if (showExtras) ...[
            const SizedBox(height: 16),
            EditSubheading(l.apiExtrasTitle),
            Text(l.apiExtrasHint,
                style: TextStyle(color: context.appFgSub, fontSize: 12)),
            const SizedBox(height: 8),
            for (final e in draft.extras)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      onTapOutside: unfocusOnTapOutside,
                      controller: e.$1,
                      autocorrect: false,
                      onChanged: (_) => onChanged(),
                      decoration: outlinedEditDecoration(l.extraKeyLabel),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      onTapOutside: unfocusOnTapOutside,
                      controller: e.$2,
                      autocorrect: false,
                      onChanged: (_) => onChanged(),
                      decoration: outlinedEditDecoration(l.extraValueLabel),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: () {
                      draft.extras.remove(e);
                      onChanged();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        e.$1.dispose();
                        e.$2.dispose();
                      });
                    },
                  ),
                ]),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(l.addExtraAction),
                onPressed: () {
                  draft.extras
                      .add((TextEditingController(), TextEditingController()));
                  onChanged();
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
