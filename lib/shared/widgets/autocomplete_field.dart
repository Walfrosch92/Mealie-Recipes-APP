import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

import '../../core/utils/search_match.dart';

// ---------------------------------------------------------------------------
// Autocomplete-Textfeld gegen eine feste Optionsliste (Server-Einheiten/
// -Foods). Schlägt beim Tippen passende Einträge vor (starts-with vor
// contains, max. 8); neue (nicht vorhandene) Namen bleiben einfach Freitext.
// Genutzt von der Rezeptbearbeitung (Einheit/Zutat) und der Eingabezeile der
// Einkaufsliste — deshalb sind Dekoration, Stil und Öffnungsrichtung des
// Vorschlags-Overlays konfigurierbar (die Eingabezeile sitzt unten über der
// Tastatur → Overlay öffnet nach OBEN).
// ---------------------------------------------------------------------------

/// Teil-Vervollständigung (z. B. Einkaufsliste „200 Gramm But…"): nur
/// [query] wird gegen [options] gesucht und beim Übernehmen ersetzt,
/// [prefix] bleibt stehen, [suffixFor] liefert je Vorschlag, was danach
/// angehängt wird (z. B. Leerzeichen nach einer Einheit, damit gleich der
/// Artikel folgen kann).
class AutocompleteSlot {
  final String prefix;
  final String query;
  final List<String> options;
  final String Function(String option)? suffixFor;
  const AutocompleteSlot(
      {required this.prefix,
      required this.query,
      required this.options,
      this.suffixFor});
}

class _Suggestion {
  final String label;
  final String full;
  const _Suggestion(this.label, this.full);
  @override
  String toString() => full;
}

class AutocompleteField extends StatefulWidget {
  final TextEditingController controller;

  /// Optional extern (z. B. wenn der Screen den Fokus beobachtet); ohne
  /// Angabe verwaltet das Widget einen eigenen FocusNode.
  final FocusNode? focusNode;
  final List<String> options;
  final InputDecoration decoration;
  final TextStyle? style;
  final TextInputAction? textInputAction;

  /// Enter-Verhalten: mit Callback übernimmt ER den Submit (Einkaufsliste:
  /// Artikel hinzufügen); ohne Callback wählt RawAutocomplete die
  /// hervorgehobene Option (Verhalten der Rezeptbearbeitung).
  final ValueChanged<String>? onSubmitted;
  final OptionsViewOpenDirection openDirection;

  /// Tipp außerhalb des Felds (z. B. Editor: Eingabe beenden). Die
  /// Vorschlagsliste zählt nicht als „außerhalb".
  final TapRegionCallback? onTapOutside;

  /// Optional: Vorschläge nur für einen Teil des Texts (siehe
  /// [AutocompleteSlot]). Ohne = ganzer Text gegen [options].
  final AutocompleteSlot Function(String text)? slotBuilder;

  const AutocompleteField({
    super.key,
    required this.controller,
    required this.options,
    required this.decoration,
    this.focusNode,
    this.style,
    this.textInputAction,
    this.onSubmitted,
    this.onTapOutside,
    this.slotBuilder,
    this.openDirection = OptionsViewOpenDirection.down,
  });

  @override
  State<AutocompleteField> createState() => _AutocompleteFieldState();
}

class _AutocompleteFieldState extends State<AutocompleteField> {
  FocusNode? _ownedFocus;
  FocusNode get _focus => widget.focusNode ?? (_ownedFocus ??= FocusNode());

  @override
  void dispose() {
    _ownedFocus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<_Suggestion>(
      textEditingController: widget.controller,
      focusNode: _focus,
      optionsViewOpenDirection: widget.openDirection,
      displayStringForOption: (o) => o.full,
      optionsBuilder: (TextEditingValue value) {
        final slot = widget.slotBuilder?.call(value.text) ??
            AutocompleteSlot(
                prefix: '', query: value.text, options: widget.options);
        final terms = searchTerms(slot.query);
        if (terms.isEmpty) return const Iterable<_Suggestion>.empty();
        final q = terms.join(' ');
        final hits = <String>[];
        final seen = <String>{};
        for (final o in slot.options) {
          final n = normalizeForSearch(o);
          if (n == q) continue; // exakter Treffer → kein Vorschlag nötig
          if (!seen.add(n)) continue;
          if (n.contains(q)) hits.add(o);
        }
        // Vorne passende zuerst, dann Wortanfänge, dann „irgendwo drin“.
        return rankBySearch(hits, terms, (o) => o).take(8).map((o) =>
            _Suggestion(o, '${slot.prefix}$o${slot.suffixFor?.call(o) ?? ''}'));
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          style: widget.style,
          textInputAction: widget.textInputAction,
          decoration: widget.decoration,
          onTapOutside: widget.onTapOutside,
          onSubmitted: (v) {
            final cb = widget.onSubmitted;
            if (cb != null) {
              cb(v);
            } else {
              onFieldSubmitted();
            }
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        // Öffnet das Overlay nach oben, muss die Liste UNTEN andocken —
        // sonst klaffte zwischen Feld und Vorschlägen eine Lücke.
        final up = widget.openDirection == OptionsViewOpenDirection.up;
        return Align(
          alignment: up ? Alignment.bottomLeft : Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(AppTokens.rXs),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 260),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, i) {
                  final opt = options.elementAt(i);
                  return InkWell(
                    onTap: () => onSelected(opt),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Text(opt.label),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
