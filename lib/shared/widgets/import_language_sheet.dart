import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../core/models/import_language.dart';
import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Auswahl der Zielsprache für den KI-Rezeptimport. Von den Einstellungen UND
// vom Setup-Schritt genutzt, damit beide dieselbe (durchsuchbare) Liste zeigen.
//
// Rückgabe: der gewählte Sprachcode, `''` für „wie App-Sprache", oder `null`,
// wenn der Nutzer abbricht.
// ---------------------------------------------------------------------------

Future<String?> showImportLanguageSheet(
  BuildContext context, {
  required String current,
  required String appLanguageLabel,
}) {
  return showModalBottomSheet<String>(
    useSafeArea: true,
    context: context,
    backgroundColor: context.appCard,
    // Root-Navigator: sonst liegt das Sheet hinter der fixen GlassTabBar.
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (sheetCtx) => _ImportLanguageSheet(
      current: current,
      appLanguageLabel: appLanguageLabel,
    ),
  );
}

class _ImportLanguageSheet extends StatefulWidget {
  final String current;
  final String appLanguageLabel;

  const _ImportLanguageSheet({
    required this.current,
    required this.appLanguageLabel,
  });

  @override
  State<_ImportLanguageSheet> createState() => _ImportLanguageSheetState();
}

class _ImportLanguageSheetState extends State<_ImportLanguageSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ImportLanguage> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return kImportLanguages;
    // Name UND Code durchsuchen: „ukr", „uk" und „Українська" führen alle
    // zum Ziel, auch wenn die Tastatur das Alphabet nicht hergibt.
    return kImportLanguages
        .where((lang) =>
            lang.name.toLowerCase().contains(q) ||
            lang.code.toLowerCase().contains(q))
        .toList();
  }

  void _pick(String code) {
    HapticFeedback.selectionClick();
    Navigator.pop(context, code);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final matches = _filtered;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      child: Padding(
        // Tastatur-Inset: sonst verdeckt sie das Suchfeld.
        padding:
            EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(l.importLanguage,
                  style: TextStyle(
                      color: context.appFg,
                      fontSize: 17,
                      fontWeight: FontWeight.w600)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchCtrl,
                autocorrect: false,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: l.importLanguageSearch,
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  // „Wie App-Sprache" nur ohne aktive Suche — der Eintrag ist
                  // keine Sprache und würde jedes Suchergebnis verwässern.
                  if (_query.trim().isEmpty)
                    ListTile(
                      leading:
                          Icon(Icons.sync_rounded, color: context.appFgSub),
                      title: Text(l.importLanguageFollowApp,
                          style: TextStyle(color: context.appFg)),
                      subtitle: Text(widget.appLanguageLabel,
                          style: TextStyle(color: context.appFgSub)),
                      trailing: widget.current.isEmpty
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () => _pick(''),
                    ),
                  if (matches.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(l.importLanguageNoMatch,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.appFgSub)),
                    ),
                  ...matches.map((lang) => ListTile(
                        leading: Text(lang.flag,
                            style: const TextStyle(fontSize: 22)),
                        title: Text(lang.name,
                            style: TextStyle(color: context.appFg)),
                        trailing: widget.current == lang.code
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : null,
                        onTap: () => _pick(lang.code),
                      )),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Anzeigetext der aktuellen Auswahl („Deutsch", „Українська" …). Bei leerem
/// Code — also „wie App-Sprache" — der Name der App-Sprache.
String importLanguageLabel(String importCode, String appCode) {
  final lang = importLanguageFor(importCode.isEmpty ? appCode : importCode);
  // Unbekannter Code (App-Sprache ohne Listeneintrag): den Code selbst zeigen,
  // statt eine falsche Sprache vorzugaukeln.
  return lang?.name ?? (importCode.isEmpty ? appCode : importCode);
}

/// Flagge zur aktuellen Auswahl — leer, wenn der Code unbekannt ist.
String importLanguageFlag(String importCode, String appCode) =>
    importLanguageFor(importCode.isEmpty ? appCode : importCode)?.flag ?? '🌍';
