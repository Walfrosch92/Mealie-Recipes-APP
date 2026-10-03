import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/apple_icon.dart';

// ---------------------------------------------------------------------------
// „Was ist neu" — Changelog der App (assets/changelog/changelog.json).
//
// Der Changelog ist bewusst NUR auf Englisch (User-Wunsch); „Text kopieren"
// legt ihn als Klartext in die Zwischenablage, z. B. für einen Übersetzer.
// Nur die Bedienelemente sind lokalisiert.
//
// Anzeige: beim App-Start (einmal pro Start), bis „Nicht mehr anzeigen"
// angekreuzt wird. Diese Wahl gilt nur für die aktuelle Build-Nummer —
// mit jedem neuen Build erscheint der Dialog wieder. Jederzeit über die
// Einstellungen erreichbar.
//
// Für ein neues Update nur changelog.json ersetzen.
// ---------------------------------------------------------------------------

const _prefsKey = 'whatsNewDismissedBuild';

class ChangelogSection {
  final String title;
  final String icon;
  final List<String> items;
  const ChangelogSection(
      {required this.title, required this.icon, required this.items});
}

List<ChangelogSection> parseChangelog(String raw) {
  final data = jsonDecode(raw) as Map<String, dynamic>;
  return [
    for (final s in (data['sections'] as List? ?? const []))
      if (s is Map)
        ChangelogSection(
          title: s['title']?.toString() ?? '',
          icon: s['icon']?.toString() ?? '',
          items: [for (final i in (s['items'] as List? ?? const [])) '$i'],
        ),
  ];
}

/// Klartext zum Kopieren (Markdown-ähnlich, gut für Übersetzer).
String changelogAsText(List<ChangelogSection> sections, String version) {
  final b = StringBuffer("What's new in Mealie Recipes $version\n");
  for (final s in sections) {
    b
      ..writeln()
      ..writeln(s.title);
    for (final i in s.items) {
      b.writeln('- $i');
    }
  }
  return b.toString().trimRight();
}

/// Build-Kennung: Version + Build-Nummer (iOS CFBundleVersion bzw. Android
/// versionCode).
String buildId(PackageInfo info) => '${info.version}+${info.buildNumber}';

/// Soll der Dialog automatisch erscheinen? (nicht für diesen Build
/// weggeklickt)
bool shouldAutoShowWhatsNew(String? dismissedBuild, String currentBuild) =>
    dismissedBuild != currentBuild;

bool _shownThisLaunch = false;

/// Beim Start aufrufen (Startbildschirm): zeigt „Was ist neu" höchstens
/// einmal pro App-Start, solange es für diesen Build nicht abbestellt ist.
Future<void> maybeShowWhatsNew(BuildContext context) async {
  if (_shownThisLaunch) return;
  _shownThisLaunch = true;
  try {
    final info = await PackageInfo.fromPlatform();
    final prefs = await SharedPreferences.getInstance();
    if (!shouldAutoShowWhatsNew(prefs.getString(_prefsKey), buildId(info))) {
      return;
    }
    // Frisch zurückgesetzter Changelog: nichts automatisch zeigen.
    final raw = await rootBundle.loadString('assets/changelog/changelog.json');
    if (parseChangelog(raw).isEmpty) return;
    if (!context.mounted) return;
    await showWhatsNew(context, allowDismissForever: true);
  } catch (_) {/* Changelog ist nie kritisch */}
}

/// „Was ist neu" anzeigen. [allowDismissForever] = Häkchen „Nicht mehr
/// anzeigen" (nur beim automatischen Anzeigen).
Future<void> showWhatsNew(BuildContext context,
    {bool allowDismissForever = false}) async {
  final raw = await rootBundle.loadString('assets/changelog/changelog.json');
  final info = await PackageInfo.fromPlatform();
  if (!context.mounted) return;
  await showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.appCard,
    builder: (_) => _WhatsNewSheet(
      sections: parseChangelog(raw),
      info: info,
      allowDismissForever: allowDismissForever,
    ),
  );
}

IconData _icon(String name) => switch (name) {
      'timeline' => Icons.timeline_rounded,
      'attach' => Icons.attach_file_rounded,
      'cart' => Icons.shopping_cart_rounded,
      'food' => kAppleIcon, // Apfel wie die Lebensmittel-Kachel
      'users' => Icons.manage_accounts_rounded,
      'lock' => Icons.lock_rounded,
      'home' => Icons.home_rounded,
      'mealplan' => Icons.event_rounded,
      'recipe' => Icons.restaurant_menu_rounded,
      'edit' => Icons.edit_rounded,
      'import' => Icons.download_rounded,
      'search' => Icons.search_rounded,
      'fix' => Icons.build_rounded,
      'send' => Icons.send_rounded,
      'speed' => Icons.speed_rounded,
      'timer' => Icons.timer_rounded,
      'language' => Icons.translate_rounded,
      _ => Icons.auto_awesome_rounded,
    };

class _WhatsNewSheet extends StatefulWidget {
  final List<ChangelogSection> sections;
  final PackageInfo info;
  final bool allowDismissForever;
  const _WhatsNewSheet(
      {required this.sections,
      required this.info,
      required this.allowDismissForever});

  @override
  State<_WhatsNewSheet> createState() => _WhatsNewSheetState();
}

class _WhatsNewSheetState extends State<_WhatsNewSheet> {
  bool _dontShow = false;

  Future<void> _close() async {
    if (_dontShow) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_prefsKey, buildId(widget.info));
      } catch (_) {}
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _copy() async {
    final l = AppLocalizations.of(context)!;
    await Clipboard.setData(ClipboardData(
        text: changelogAsText(widget.sections, widget.info.version)));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.copiedToClipboard)));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (_, scroll) => Column(
        children: [
          Expanded(
            child: ListView(
              controller: scroll,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              children: [
                Row(children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppTokens.accentGradient,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(Icons.history_edu_rounded,
                        color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.changelogTitle,
                            style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                color: context.appFg,
                                fontSize: 21,
                                fontWeight: FontWeight.w800)),
                        Text('${l.appVersion} ${widget.info.version}',
                            style: TextStyle(
                                color: context.appFgSub, fontSize: 13)),
                      ],
                    ),
                  ),
                ]),
                // Nur für Nicht-Englisch: Hinweis, dass der Text englisch ist.
                if (Localizations.localeOf(context).languageCode != 'en')
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(l.changelogEnglishHint,
                        style: TextStyle(
                            color: context.appFgSub,
                            fontSize: 12.5,
                            height: 1.35)),
                  ),
                if (widget.sections.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Text(l.changelogEmpty,
                        style:
                            TextStyle(color: context.appFgSub, fontSize: 14)),
                  ),
                for (final s in widget.sections) ...[
                  const SizedBox(height: 18),
                  Row(children: [
                    iconOrApple(_icon(s.icon),
                        size: 20, color: AppTokens.accentDeep),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(s.title,
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: context.appFg,
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  for (final i in s.items)
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7, right: 8),
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                  color: AppTokens.accent,
                                  shape: BoxShape.circle),
                            ),
                          ),
                          Expanded(
                            child: Text(i,
                                style: TextStyle(
                                    color: context.appFgSub,
                                    fontSize: 14,
                                    height: 1.4)),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.allowDismissForever)
                    CheckboxListTile(
                      value: _dontShow,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(l.dontShowAgain,
                          style: TextStyle(color: context.appFg)),
                      onChanged: (v) => setState(() => _dontShow = v ?? false),
                    ),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _copy,
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        label: Text(l.copyTextAction),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: AppTokens.accent),
                        onPressed: _close,
                        child: Text(l.close),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
