import 'package:flutter/material.dart';
import '../../../shared/widgets/sheet_title.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/app_settings.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart' show SheetHandle;
import '../../../shared/widgets/import_language_sheet.dart';

// ---------------------------------------------------------------------------
// Zahnrad im Rezept-Import (#45): Wie viel der KI-Import von Mealie
// zusätzlich erledigt. Jeder Schritt ist ein eigener KI-Aufruf auf dem
// Server (Video: bis zu 4 hintereinander).
//
// Oben drei Voreinstellungen (AppSettings.importPreset):
//  - Schnell:     Video-Links über /create/url (eine KI-Anfrage), keine
//                 Übersetzung, nur vorhandene Kategorien/Tags.
//  - Gründlich:   voller KI-Import (Standard, Verhalten wie bisher).
//  - Individuell: die einzelnen Schalter darunter — Übersetzen,
//                 Kategorien & Tags, Video-Links, Foto/PDF-Stream.
// Wirksam sind immer die `use…`-Getter von AppSettings. Jede Änderung wird
// sofort gespeichert.
// ---------------------------------------------------------------------------

Future<void> showImportOptionsSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => const _ImportOptionsSheet(),
    );

class _ImportOptionsSheet extends ConsumerWidget {
  const _ImportOptionsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final settings =
        ref.watch(settingsProvider).valueOrNull ?? const AppSettings();
    void save(AppSettings next) =>
        ref.read(settingsProvider.notifier).save(next);

    final preset = settings.importPreset;
    final custom = preset == 'custom';

    void selectPreset(String next) {
      HapticFeedback.selectionClick();
      // Wechsel zu „Individuell": die Schalter starten mit dem, was die
      // bisherige Voreinstellung tat — nichts ändert sich unbemerkt.
      save(next == 'custom' && !custom
          ? settings.copyWith(
              importPreset: 'custom',
              importTranslate: settings.useImportTranslate,
              importOrganizers: settings.useImportOrganizers,
              importVideoAi: settings.useImportVideoAi,
              importStreamPhotos: settings.useImportStreamPhotos,
            )
          : settings.copyWith(importPreset: next));
    }

    final (presetIcon, presetTitle, presetPoints) = switch (preset) {
      'fast' => (
          Icons.bolt_rounded,
          l.importPresetFastTitle,
          [
            l.importPresetFastVideo,
            l.importPresetFastTranslate,
            l.importPresetFastOrganizers,
          ]
        ),
      'custom' => (
          Icons.tune_rounded,
          l.importPresetCustomTitle,
          [l.importPresetCustomBody]
        ),
      _ => (
          Icons.auto_awesome_rounded,
          l.importPresetThoroughTitle,
          [
            l.importPresetThoroughVideo,
            l.importPresetThoroughTranslate,
            l.importPresetThoroughOrganizers,
          ]
        ),
    };

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: SheetHandle()),
            SheetTitle(l.importOptionsTitle),
            const SizedBox(height: 6),
            Text(l.importOptionsHint,
                style: TextStyle(color: context.appFgSub, fontSize: 13)),
            const SizedBox(height: 14),

            // ── Voreinstellung ─────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                      value: 'fast',
                      icon: const Icon(Icons.bolt_rounded, size: 18),
                      label: Text(l.importPresetFast)),
                  ButtonSegment(
                      value: 'thorough',
                      icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                      label: Text(l.importPresetThorough)),
                  ButtonSegment(
                      value: 'custom',
                      icon: const Icon(Icons.tune_rounded, size: 18),
                      label: Text(l.importPresetCustom)),
                ],
                selected: {preset},
                onSelectionChanged: (v) => selectPreset(v.first),
              ),
            ),
            const SizedBox(height: 12),

            // ── Was die gewählte Voreinstellung macht ──────────────────
            _PresetExplanation(
              icon: presetIcon,
              title: presetTitle,
              points: presetPoints,
              bulleted: !custom,
            ),

            // Zielsprache — wenn übersetzt wird (Gründlich; bei
            // „Individuell" sitzt sie unter dem Übersetzen-Schalter).
            if (settings.useImportTranslate && !custom) ...[
              const SizedBox(height: 4),
              _LanguageRow(settings: settings, onSave: save),
            ],

            // ── Individuell: die einzelnen Schalter ────────────────────
            if (custom) ...[
              const SizedBox(height: 8),
              _CustomOptions(settings: settings, onSave: save),
            ],
          ],
        ),
      ),
    );
  }
}

/// Karte mit Titel und den Punkten, was die Voreinstellung tut.
class _PresetExplanation extends StatelessWidget {
  const _PresetExplanation({
    required this.icon,
    required this.title,
    required this.points,
    required this.bulleted,
  });

  final IconData icon;
  final String title;
  final List<String> points;
  final bool bulleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appSurface2,
        borderRadius: BorderRadius.circular(AppTokens.rSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 18, color: AppTokens.accentDeep),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title,
                  style: TextStyle(
                      color: context.appFg,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 8),
          for (final p in points)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (bulleted)
                    Padding(
                      padding: const EdgeInsets.only(top: 1, right: 6),
                      child: Icon(Icons.check_rounded,
                          size: 15, color: context.appFgSub),
                    ),
                  Expanded(
                    child: Text(p,
                        style: TextStyle(
                            color: context.appFgSub,
                            fontSize: 13,
                            height: 1.35)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _LanguageRow extends ConsumerWidget {
  const _LanguageRow({required this.settings, required this.onSave});
  final AppSettings settings;
  final void Function(AppSettings) onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final langLabel =
        '${importLanguageFlag(settings.importLanguage, settings.selectedLanguage)} '
        '${importLanguageLabel(settings.importLanguage, settings.selectedLanguage)}';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.translate_rounded, color: AppTokens.accentDeep),
      title: Text(l.importLanguage,
          style: TextStyle(color: context.appFg, fontSize: 15)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(langLabel, style: TextStyle(color: context.appFg, fontSize: 14)),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
      onTap: () async {
        final picked = await showImportLanguageSheet(
          context,
          current: settings.importLanguage,
          appLanguageLabel: importLanguageLabel('', settings.selectedLanguage),
        );
        if (picked == null) return;
        final cur = ref.read(settingsProvider).valueOrNull ?? settings;
        onSave(cur.copyWith(importLanguage: picked));
      },
    );
  }
}

/// „Individuell": alle Schalter einzeln.
class _CustomOptions extends StatelessWidget {
  const _CustomOptions({required this.settings, required this.onSave});
  final AppSettings settings;
  final void Function(AppSettings) onSave;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final organizersHint = switch (settings.importOrganizers) {
      'existing' => l.importOrganizersExistingHint,
      'none' => l.importOrganizersNoneHint,
      _ => l.importOrganizersCreateHint,
    };
    TextStyle hint() => TextStyle(color: context.appFgSub, fontSize: 13);

    Widget heading(IconData icon, String text) => Row(
          children: [
            Icon(icon, color: AppTokens.accentDeep),
            const SizedBox(width: 16),
            Expanded(
              child: Text(text,
                  style: TextStyle(color: context.appFg, fontSize: 16)),
            ),
          ],
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Übersetzen ─────────────────────────────────────────────
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          activeTrackColor: AppTokens.accent,
          secondary:
              const Icon(Icons.translate_rounded, color: AppTokens.accentDeep),
          title: Text(l.importTranslateTitle),
          value: settings.importTranslate,
          onChanged: (v) {
            HapticFeedback.selectionClick();
            onSave(settings.copyWith(importTranslate: v));
          },
        ),
        if (settings.importTranslate)
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: _LanguageRow(settings: settings, onSave: onSave),
          ),
        const SizedBox(height: 12),

        // ── Kategorien & Tags ──────────────────────────────────────
        heading(Icons.sell_rounded, l.importOrganizersTitle),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                  value: 'create', label: Text(l.importOrganizersCreate)),
              ButtonSegment(
                  value: 'existing', label: Text(l.importOrganizersExisting)),
              ButtonSegment(value: 'none', label: Text(l.importOrganizersNone)),
            ],
            selected: {settings.importOrganizers},
            onSelectionChanged: (v) {
              HapticFeedback.selectionClick();
              onSave(settings.copyWith(importOrganizers: v.first));
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(organizersHint, style: hint()),
        const SizedBox(height: 16),

        // ── Video-Links: schnell (/create/url) oder gründlich (KI) ──
        heading(Icons.smart_display_rounded, l.importVideoTitle),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<bool>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: false, label: Text(l.importVideoFast)),
              ButtonSegment(value: true, label: Text(l.importVideoThorough)),
            ],
            selected: {settings.importVideoAi},
            onSelectionChanged: (v) {
              HapticFeedback.selectionClick();
              onSave(settings.copyWith(importVideoAi: v.first));
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
            settings.importVideoAi
                ? l.importVideoThoroughHint
                : l.importVideoFastHint,
            style: hint()),
        const SizedBox(height: 16),

        // ── Foto/PDF-Upload: Stream oder wie bisher ────────────────
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          activeTrackColor: AppTokens.accent,
          secondary:
              const Icon(Icons.stream_rounded, color: AppTokens.accentDeep),
          title: Text(l.importStreamPhotosTitle),
          subtitle: Text(l.importStreamPhotosHint, style: hint()),
          value: settings.importStreamPhotos,
          onChanged: (v) {
            HapticFeedback.selectionClick();
            onSave(settings.copyWith(importStreamPhotos: v));
          },
        ),
      ],
    );
  }
}
