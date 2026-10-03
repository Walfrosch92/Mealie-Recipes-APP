import 'package:flutter/material.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../shared/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Gemeinsame Bausteine des Rezept-Editors — gleiche Optik wie bisher:
// aufklappbare Abschnitte mit Akzent-Icon-Badge, Eingabefelder im
// App-Stil, Aktionsmenüs und kleine Eingabe-Dialoge/-Sheets.
// ---------------------------------------------------------------------------

/// Tipp außerhalb eines Editor-Felds beendet die Eingabe. Sonst bliebe das
/// Feld fokussiert: Nach Schalter, ⋯-Menü oder Sheet gab Flutter ihm den
/// Fokus zurück und scrollte dabei jedes Mal zu ihm hoch.
void unfocusOnTapOutside(PointerDownEvent _) =>
    FocusManager.instance.primaryFocus?.unfocus();

/// Kopfzeile eines aufklappbaren Editor-Abschnitts (spiegelt iOS
/// customDisclosureGroup). Der Inhalt folgt separat (auch als Sliver).
class EditSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badge;
  final bool expanded;
  final VoidCallback onToggle;

  const EditSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.badge,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: context.appSeparator, width: 0.5),
            bottom: expanded
                ? BorderSide.none
                : BorderSide(color: context.appSeparator, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: AppTokens.accent.withValues(alpha: 0.12),
              ),
              child: Icon(icon, color: AppTokens.accentDeep, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: context.appFg,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2)),
            ),
            if (badge != null && badge!.isNotEmpty)
              Container(
                constraints: const BoxConstraints(minWidth: 24),
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: AppTokens.accentGradient,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(badge!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ),
            const SizedBox(width: 8),
            AnimatedRotation(
              turns: expanded ? 0.25 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.chevron_right_rounded,
                  color: context.appFgTertiary, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}

/// Aufklappbarer Abschnitt mit normalem (Nicht-Sliver-)Inhalt.
class EditSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badge;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;

  const EditSection({
    super.key,
    required this.icon,
    required this.title,
    this.badge,
    required this.expanded,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditSectionHeader(
          icon: icon,
          title: title,
          badge: badge,
          expanded: expanded,
          onToggle: onToggle,
        ),
        if (expanded) EditSectionBody(child: child),
      ],
    );
  }
}

/// Inhalt eines aufgeklappten Abschnitts (untere Trennlinie).
class EditSectionBody extends StatelessWidget {
  final Widget child;
  const EditSectionBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: context.appSeparator, width: 0.5),
          ),
        ),
        child: child,
      );
}

/// Gefülltes Feld wie Name/Beschreibung/Zeiten (surface2, ohne Rahmen).
InputDecoration filledEditDecoration(BuildContext context,
        {String? label, String? hint, Widget? suffix, String? suffixText}) =>
    InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: context.appFgSub, fontSize: 12),
      hintStyle: TextStyle(color: context.appFgTertiary),
      suffixIcon: suffix,
      suffixText: suffixText,
      suffixStyle: TextStyle(color: context.appFgSub, fontSize: 13),
      filled: true,
      fillColor: context.appSurface2,
      isDense: true,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    );

/// Umrandetes Kompaktfeld wie in den Zutaten-/Schritt-Zeilen.
InputDecoration outlinedEditDecoration(String label,
        {Widget? prefixIcon, Widget? suffixIcon, String? hint}) =>
    InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: const OutlineInputBorder(),
      isDense: true,
    );

/// Kleine Überschrift innerhalb eines Abschnitts.
class EditSubheading extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const EditSubheading(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 6),
        child: Row(children: [
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: context.appFgSub,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
          if (trailing != null) trailing!,
        ]),
      );
}

/// Aktions-Zeile am Ende eines Abschnitts („Zutat hinzufügen" …).
class EditActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  const EditActionTile(
      {super.key,
      required this.icon,
      required this.title,
      this.subtitle,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ListTile(
      leading: Icon(icon, color: primary),
      title: Text(title, style: TextStyle(color: primary, fontSize: 15)),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!,
              style: TextStyle(color: context.appFgSub, fontSize: 12)),
      onTap: onTap,
    );
  }
}

/// Eintrag eines Aktionsmenüs.
class EditMenuItem<T> {
  final T value;
  final IconData icon;
  final String label;
  final bool destructive;
  final bool enabled;
  const EditMenuItem(this.value, this.icon, this.label,
      {this.destructive = false, this.enabled = true});
}

/// „⋯"-Menü einer Zeile.
class EditMenuButton<T> extends StatelessWidget {
  final List<EditMenuItem<T>?> items;
  final ValueChanged<T> onSelected;
  final String? tooltip;
  const EditMenuButton(
      {super.key, required this.items, required this.onSelected, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      icon: Icon(Icons.more_vert_rounded, color: context.appFgSub, size: 20),
      tooltip: tooltip,
      color: context.appCard,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 220),
      onSelected: onSelected,
      itemBuilder: (_) => [
        for (final i in items)
          if (i == null)
            const PopupMenuDivider()
          else
            PopupMenuItem<T>(
              value: i.value,
              enabled: i.enabled,
              child: Row(children: [
                Icon(i.icon,
                    size: 20,
                    color: i.destructive ? Colors.red : context.appFg),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(i.label,
                      style: TextStyle(
                          color: i.destructive ? Colors.red : context.appFg)),
                ),
              ]),
            ),
      ],
    );
  }
}

/// Einzeiliger Eingabe-Dialog (Name eines Tags, Bild-URL …). Besitzt seinen
/// Controller selbst (kein dispose-Race nach showDialog).
Future<String?> showTextInputDialog(
  BuildContext context, {
  required String title,
  String? hint,
  String initial = '',
  String? confirmLabel,
  TextInputType? keyboardType,
  TextCapitalization capitalization = TextCapitalization.sentences,
}) async {
  final result = await showDialog<String>(
    context: context,
    builder: (_) => _TextInputDialog(
      title: title,
      hint: hint,
      initial: initial,
      confirmLabel: confirmLabel,
      keyboardType: keyboardType,
      capitalization: capitalization,
    ),
  );
  final t = result?.trim();
  return (t == null || t.isEmpty) ? null : t;
}

class _TextInputDialog extends StatefulWidget {
  final String title;
  final String? hint;
  final String initial;
  final String? confirmLabel;
  final TextInputType? keyboardType;
  final TextCapitalization capitalization;
  const _TextInputDialog({
    required this.title,
    this.hint,
    required this.initial,
    this.confirmLabel,
    this.keyboardType,
    required this.capitalization,
  });

  @override
  State<_TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  late final _ctrl = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: context.appCard,
      title: Text(widget.title),
      content: TextField(
        controller: _ctrl,
        autofocus: true,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.capitalization,
        autocorrect: widget.keyboardType != TextInputType.url,
        decoration: InputDecoration(hintText: widget.hint ?? l.name),
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(
            onPressed: () => Navigator.pop(context, _ctrl.text),
            child: Text(widget.confirmLabel ?? l.add)),
      ],
    );
  }
}

/// Ja/Nein-Bestätigung (rot = destruktiv).
Future<bool> confirmEditAction(BuildContext context,
    {required String message,
    required String confirmLabel,
    bool destructive = true}) async {
  final l = AppLocalizations.of(context)!;
  return await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: ctx.appCard,
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
              child: Text(confirmLabel),
            ),
          ],
        ),
      ) ??
      false;
}

/// „Mehrere hinzufügen" (Webapp „Bulk Add"): eine Zeile = ein Eintrag.
Future<List<String>?> showBulkAddSheet(BuildContext context,
    {required String title}) {
  return showModalBottomSheet<List<String>>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.appCard,
    builder: (_) => _BulkAddSheet(title: title),
  );
}

class _BulkAddSheet extends StatefulWidget {
  final String title;
  const _BulkAddSheet({required this.title});

  @override
  State<_BulkAddSheet> createState() => _BulkAddSheetState();
}

class _BulkAddSheetState extends State<_BulkAddSheet> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<String> get _lines => _ctrl.text
      .split('\n')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final n = _lines.length;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
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
          const SizedBox(height: 6),
          Text(l.bulkAddHint,
              style: TextStyle(color: context.appFgSub, fontSize: 13)),
          const SizedBox(height: 12),
          Flexible(
            child: TextField(
              controller: _ctrl,
              autofocus: true,
              minLines: 6,
              maxLines: 14,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => setState(() {}),
              decoration: filledEditDecoration(context),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: AppTokens.accent,
                padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: n == 0 ? null : () => Navigator.pop(context, _lines),
            child: Text(n == 0 ? l.add : l.bulkAddCount(n)),
          ),
        ],
      ),
    );
  }
}

/// Kleiner Kopf für Bottom-Sheets des Editors (Icon, Titel, Schließen).
class EditSheetHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  const EditSheetHeader(
      {super.key, required this.icon, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title,
                style: TextStyle(
                    color: context.appFg,
                    fontSize: 17,
                    fontWeight: FontWeight.w600)),
          ),
          trailing ??
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l.close)),
        ],
      ),
    );
  }
}
