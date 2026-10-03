import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/utils/platform_features.dart';
import '../../../shared/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Gemeinsame Bausteine der Webapp-Werkzeuge (nur Desktop, siehe
// PlatformFeatures.webAppTools): Seitengerüst mit zentrierter Lesespalte,
// Karten, Bestätigungsdialog, Fehlermeldung, Datei speichern/öffnen.
// ---------------------------------------------------------------------------

/// Seite mit AppBar, optionaler Erklärung oben und zentrierter Spalte
/// (große Anzeige: [LargeScreen.inset]).
class ToolPage extends StatelessWidget {
  final String title;
  final String? description;
  final List<Widget> children;
  final List<Widget>? actions;
  final Future<void> Function()? onRefresh;
  final bool busy;

  const ToolPage({
    super.key,
    required this.title,
    required this.children,
    this.description,
    this.actions,
    this.onRefresh,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    final inset = LargeScreen.inset(context, base: 16);
    final list = ListView(
      padding: EdgeInsets.fromLTRB(inset, 12, inset, 40),
      children: [
        if (description != null) ...[
          Text(description!,
              style: TextStyle(
                  color: context.appFgSub, fontSize: 14, height: 1.4)),
          const SizedBox(height: 16),
        ],
        ...children,
      ],
    );
    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(title: Text(title), actions: actions),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            if (busy) const LinearProgressIndicator(minHeight: 2),
            Expanded(
              child: onRefresh == null
                  ? list
                  : RefreshIndicator(onRefresh: onRefresh!, child: list),
            ),
          ],
        ),
      ),
    );
  }
}

/// Weiße Karte mit optionalem Titel + Untertitel.
class ToolCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  const ToolCard({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.children = const [],
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: padding,
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(AppTokens.rMd),
        border: Border.all(color: context.appSeparator),
        boxShadow: context.appShadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Row(children: [
              if (icon != null) ...[
                Icon(icon, color: AppTokens.accentDeep, size: 20),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(title!,
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: context.appFg,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2)),
              ),
              if (trailing != null) trailing!,
            ]),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(subtitle!,
                style: TextStyle(
                    color: context.appFgSub, fontSize: 13.5, height: 1.4)),
          ],
          if (title != null && children.isNotEmpty) const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

/// Zeile „Bezeichnung …… Wert".
class ToolInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? leading;
  const ToolInfoRow(this.label, this.value, {super.key, this.leading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 8)],
          Expanded(
            child: Text(label,
                style: TextStyle(color: context.appFgSub, fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: SelectableText(value,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: context.appFg,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

/// Grün/rot-Status (z. B. „E-Mail konfiguriert").
class ToolStatusRow extends StatelessWidget {
  final bool ok;
  final String title;
  final String? detail;
  const ToolStatusRow(
      {super.key, required this.ok, required this.title, this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ok ? Icons.check_circle_rounded : Icons.error_rounded,
              color: ok ? const Color(0xFF2E9E57) : const Color(0xFFD9443A),
              size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: context.appFg,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                if (detail != null && detail!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(detail!,
                        style: TextStyle(
                            color: context.appFgSub,
                            fontSize: 12.5,
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

/// Hinweis-/Warnbox (rot = destruktiv).
class ToolNotice extends StatelessWidget {
  final String text;
  final bool danger;
  const ToolNotice(this.text, {super.key, this.danger = false});

  @override
  Widget build(BuildContext context) {
    final color = danger ? const Color(0xFFD9443A) : AppTokens.accentDeep;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppTokens.rSm),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(danger ? Icons.warning_amber_rounded : Icons.info_outline,
              color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style:
                    TextStyle(color: context.appFg, fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

/// Leerer Zustand / Ladeanzeige einer Liste.
class ToolEmpty extends StatelessWidget {
  final String text;
  final bool loading;
  const ToolEmpty(this.text, {super.key, this.loading = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: loading
              ? const CircularProgressIndicator()
              : Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.appFgSub, fontSize: 14)),
        ),
      );
}

/// Ja/Nein-Rückfrage. [destructive] färbt den Bestätigen-Knopf rot.
Future<bool> confirmTool(
  BuildContext context, {
  required String message,
  String? title,
  String? confirmLabel,
  bool destructive = true,
}) async {
  final l = AppLocalizations.of(context)!;
  return await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: ctx.appCard,
          title: title == null ? null : Text(title),
          content: Text(message, style: TextStyle(color: ctx.appFg)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l.cancel)),
            FilledButton(
              style: destructive
                  ? FilledButton.styleFrom(backgroundColor: Colors.red)
                  : null,
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(confirmLabel ?? (destructive ? l.delete : l.ok)),
            ),
          ],
        ),
      ) ??
      false;
}

/// Snackbar „[fallback]: Server-Meldung".
void showToolError(BuildContext context, String fallback, Object error) {
  final detail = mealieErrorMessage(error);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(detail == null ? fallback : '$fallback: $detail')));
}

void showToolMessage(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

/// „Speichern unter"-Dialog und Datei schreiben. `true` = gespeichert,
/// `false` = abgebrochen.
Future<bool> saveBytesWithDialog(List<int> bytes, String fileName) async {
  final path = await FilePicker.platform.saveFile(fileName: fileName);
  if (path == null) return false;
  await File(path).writeAsBytes(Uint8List.fromList(bytes), flush: true);
  return true;
}

/// Eine Datei wählen (mit erlaubten Endungen ohne Punkt). `null` =
/// abgebrochen.
Future<({List<int> bytes, String name})?> pickToolFile(
    List<String> extensions) async {
  final res = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: extensions,
    withData: true,
  );
  final f = res?.files.singleOrNull;
  if (f == null) return null;
  final bytes =
      f.bytes ?? (f.path == null ? null : await File(f.path!).readAsBytes());
  if (bytes == null) return null;
  return (bytes: bytes, name: f.name);
}

/// Mealie-Datum (ISO, oft ohne Zeitzone = UTC) lokal formatiert.
String formatToolDate(BuildContext context, dynamic raw, {bool time = true}) {
  final s = raw?.toString() ?? '';
  if (s.isEmpty) return '';
  var dt = DateTime.tryParse(s);
  if (dt == null) return s;
  if (!dt.isUtc && !RegExp(r'([+-]\d\d:?\d\d|Z)$').hasMatch(s)) {
    dt = DateTime.utc(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second,
        dt.millisecond);
  }
  final loc = MaterialLocalizations.of(context);
  final local = dt.toLocal();
  final date = loc.formatShortDate(local);
  if (!time) return date;
  return '$date ${loc.formatTimeOfDay(TimeOfDay.fromDateTime(local), alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context))}';
}
