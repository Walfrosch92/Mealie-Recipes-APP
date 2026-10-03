import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/photo_source_sheet.dart';
import '../providers/timeline_provider.dart';

/// Anzeigename des angemeldeten Nutzers für den Zeitleisten-Betreff
/// („Anna hat das gekocht") — voller Name, sonst Benutzername.
String currentUserDisplayName(Map<String, dynamic>? me) {
  final full = (me?['fullName'] as String?)?.trim() ?? '';
  if (full.isNotEmpty) return full;
  return (me?['username'] as String?)?.trim() ?? '';
}

/// Zeitpunkt für einen gewählten Tag: heute = jetzt, sonst wie die Webapp
/// 23:59:59 Ortszeit (liegt damit immer nach „Rezept erstellt").
DateTime madeThisTimestamp(DateTime day, {DateTime? now}) {
  final n = now ?? DateTime.now();
  if (day.year == n.year && day.month == n.month && day.day == n.day) {
    return n;
  }
  return DateTime(day.year, day.month, day.day, 23, 59, 59);
}

/// „Ich hab's gekocht" — Datum, Notiz und Foto; legt den Zeitleisten-
/// Eintrag an und setzt „Zuletzt gekocht" (wie die Mealie-Webapp).
Future<void> showMadeThisSheet(BuildContext context, RecipeDetail recipe) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.appCard,
    builder: (_) => _MadeThisSheet(recipe: recipe),
  );
}

class _MadeThisSheet extends ConsumerStatefulWidget {
  final RecipeDetail recipe;
  const _MadeThisSheet({required this.recipe});

  @override
  ConsumerState<_MadeThisSheet> createState() => _MadeThisSheetState();
}

class _MadeThisSheetState extends ConsumerState<_MadeThisSheet> {
  final _noteCtrl = TextEditingController();
  DateTime _day = DateTime.now();
  File? _photo;
  bool _saving = false;

  /// Verlinkte Unterrezepte (aus den Zutaten), eindeutig nach id.
  late final List<ReferencedRecipe> _children = () {
    final seen = <String>{};
    return [
      for (final i in widget.recipe.recipeIngredient)
        if (i.referencedRecipe != null && seen.add(i.referencedRecipe!.id))
          i.referencedRecipe!,
    ];
  }();

  /// Angehakte Unterrezepte — wie in der Webapp standardmäßig keine.
  final Set<String> _checkedChildren = {};

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null) setState(() => _day = picked);
  }

  Future<void> _pickPhoto() async {
    final f = await pickPhotoWithSource(context);
    if (f != null && mounted) setState(() => _photo = f);
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final container = ProviderScope.containerOf(context);
    setState(() => _saving = true);
    try {
      final result = await recordRecipeMade(
        container,
        recipe: widget.recipe,
        subject: l.timelineUserMadeThis(
            currentUserDisplayName(ref.read(currentUserProvider))),
        message: _noteCtrl.text,
        when: madeThisTimestamp(_day),
        photo: _photo,
        childRecipes:
            _children.where((c) => _checkedChildren.contains(c.id)).toList(),
        childMessage: l.timelineMadeForRecipe,
      );
      if (!mounted) return;
      Navigator.pop(context);
      messenger.showSnackBar(SnackBar(
          content: Text(result == MadeThisResult.imageFailed
              ? l.timelineImageFailed
              : l.timelineSaved)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(
          content: Text(mealieErrorMessage(e) ?? l.timelineSaveFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.timelineMadeThis,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 20,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(widget.recipe.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: context.appFgSub, fontSize: 14)),
            const SizedBox(height: 18),
            // Datum
            InkWell(
              borderRadius: BorderRadius.circular(AppTokens.rSm),
              onTap: _saving ? null : _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l.timelineDate,
                  prefixIcon:
                      Icon(Icons.event_rounded, color: context.appFgSub),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTokens.rSm)),
                ),
                child: Text(DateFormat.yMMMEd(locale).format(_day),
                    style: TextStyle(color: context.appFg)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _noteCtrl,
              enabled: !_saving,
              minLines: 2,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              style: TextStyle(color: context.appFg),
              decoration: InputDecoration(
                labelText: l.timelineNoteHint,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTokens.rSm)),
              ),
            ),
            const SizedBox(height: 14),
            if (_photo == null)
              OutlinedButton.icon(
                onPressed: _saving ? null : _pickPhoto,
                icon: const Icon(Icons.add_a_photo_rounded),
                label: Text(l.timelineAddPhoto),
              )
            else
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppTokens.rMd),
                    child: Image.file(_photo!,
                        height: 180, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: l.timelineRemovePhoto,
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.white),
                        onPressed: _saving
                            ? null
                            : () => setState(() => _photo = null),
                      ),
                    ),
                  ),
                ],
              ),
            if (_children.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(l.timelineChildRecipesTitle,
                  style: TextStyle(
                      color: context.appFg, fontWeight: FontWeight.w700)),
              for (final c in _children)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                  value: _checkedChildren.contains(c.id),
                  title: Text(c.name, style: TextStyle(color: context.appFg)),
                  onChanged: _saving
                      ? null
                      : (v) => setState(() => v == true
                          ? _checkedChildren.add(c.id)
                          : _checkedChildren.remove(c.id)),
                ),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppTokens.accent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.check_rounded),
              label: Text(l.save),
            ),
          ],
        ),
      ),
    );
  }
}
