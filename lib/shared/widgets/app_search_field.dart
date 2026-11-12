import 'package:flutter/material.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Suchfeld für Listen — überall gleich: Lupe links, ✕ zum Leeren rechts
// (sobald Text drin steht), gefüllt, Radius rSm, ohne Rahmen. Tippen
// außerhalb schließt die Tastatur.
//
// [fillColor]: Standard ist die Kartenfarbe (Feld liegt auf dem
// Seitenhintergrund). In Sheets/Karten `context.appSurface2` übergeben.
// ---------------------------------------------------------------------------

class AppSearchField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final Color? fillColor;
  final TextInputAction? textInputAction;

  const AppSearchField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.autofocus = false,
    this.fillColor,
    this.textInputAction,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  TextEditingController? _own;
  TextEditingController get _ctrl =>
      widget.controller ?? (_own ??= TextEditingController());

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_onText);
  }

  @override
  void didUpdateWidget(AppSearchField old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      (old.controller ?? _own)?.removeListener(_onText);
      _ctrl.addListener(_onText);
    }
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onText);
    _own?.dispose();
    super.dispose();
  }

  void _onText() {
    if (mounted) setState(() {});
  }

  void _clear() {
    _ctrl.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return TextField(
      controller: _ctrl,
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction ?? TextInputAction.search,
      onChanged: widget.onChanged,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      style: TextStyle(color: context.appFg),
      decoration: InputDecoration(
        hintText: widget.hintText ?? l.search,
        hintStyle: TextStyle(color: context.appFgTertiary),
        prefixIcon: Icon(Icons.search_rounded, color: context.appFgSub),
        suffixIcon: _ctrl.text.isEmpty
            ? null
            : IconButton(
                tooltip: l.a11yClearSearch,
                icon: Icon(Icons.clear_rounded,
                    color: context.appFgSub, size: 20),
                onPressed: _clear,
              ),
        filled: true,
        fillColor: widget.fillColor ?? context.appCard,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.rSm),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
