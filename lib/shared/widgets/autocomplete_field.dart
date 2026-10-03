import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Autocomplete-Textfeld gegen eine feste Optionsliste (Server-Einheiten/
// -Foods). Schlägt beim Tippen passende Einträge vor (starts-with vor
// contains, max. 8); neue (nicht vorhandene) Namen bleiben einfach Freitext.
// Genutzt von der Rezeptbearbeitung (Einheit/Zutat) und der Eingabezeile der
// Einkaufsliste — deshalb sind Dekoration, Stil und Öffnungsrichtung des
// Vorschlags-Overlays konfigurierbar (die Eingabezeile sitzt unten über der
// Tastatur → Overlay öffnet nach OBEN).
// ---------------------------------------------------------------------------

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
    return RawAutocomplete<String>(
      textEditingController: widget.controller,
      focusNode: _focus,
      optionsViewOpenDirection: widget.openDirection,
      optionsBuilder: (TextEditingValue value) {
        final q = value.text.trim().toLowerCase();
        if (q.isEmpty) return const Iterable<String>.empty();
        final starts = <String>[];
        final contains = <String>[];
        for (final o in widget.options) {
          final lo = o.toLowerCase();
          if (lo == q) continue; // exakter Treffer → kein Vorschlag nötig
          if (lo.startsWith(q)) {
            starts.add(o);
          } else if (lo.contains(q)) {
            contains.add(o);
          }
        }
        return [...starts, ...contains].take(8);
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
            borderRadius: BorderRadius.circular(8),
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
                      child: Text(opt),
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
