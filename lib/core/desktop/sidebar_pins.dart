import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Eigene Einträge in der Desktop-Seitenleiste (Windows/macOS).
//
// Der Nutzer zieht eine Kachel (Home / „Weiteres") auf die Seitenleiste —
// während des Ziehens zeigt die Leiste graue Ablage-Positionen. Nach dem
// Ablegen vergibt er ein Tastenkürzel, das wie bei den festen Einträgen
// neben dem Namen steht. Gespeichert wird pro Gerät (SharedPreferences).
// ---------------------------------------------------------------------------

/// Höchstzahl eigener Einträge (= Zahl der grauen Positionen).
const kMaxSidebarPins = 8;

/// Was beim Ziehen einer Kachel unterwegs ist: [index] für das Umsortieren
/// der Kacheln untereinander, [key] für das Anheften an die Seitenleiste.
class TileDrag {
  final int index;
  final String key;
  const TileDrag(this.index, this.key);
}

/// Tastenkürzel eines Eintrags: immer mit der Haupt-Zusatztaste (⌘ am Mac,
/// Strg unter Windows), optional mit Umschalt/Alt.
@immutable
class PinShortcut {
  final int keyId;
  final bool shift;
  final bool alt;
  const PinShortcut(this.keyId, {this.shift = false, this.alt = false});

  LogicalKeyboardKey get key =>
      LogicalKeyboardKey.findKeyByKeyId(keyId) ?? LogicalKeyboardKey(keyId);

  SingleActivator get activator => Platform.isMacOS
      ? SingleActivator(key, meta: true, shift: shift, alt: alt)
      : SingleActivator(key, control: true, shift: shift, alt: alt);

  /// Anzeige wie bei den festen Einträgen („⌘G", „Strg+⇧G").
  String get label {
    final k = key.keyLabel.isNotEmpty ? key.keyLabel : (key.debugName ?? '?');
    return Platform.isMacOS
        ? '⌘${alt ? '⌥' : ''}${shift ? '⇧' : ''}$k'
        : 'Strg+${alt ? 'Alt+' : ''}${shift ? '⇧' : ''}$k';
  }

  String encode() => '$keyId,${shift ? 1 : 0},${alt ? 1 : 0}';

  static PinShortcut? decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final p = raw.split(',');
    final id = int.tryParse(p.first);
    if (id == null) return null;
    return PinShortcut(id,
        shift: p.length > 1 && p[1] == '1', alt: p.length > 2 && p[2] == '1');
  }

  /// Von der App oder vom System belegt (ohne Umschalt/Alt): Ziffern 1–6,
  /// Suchen, Import, Einstellungen sowie Beenden, Schließen, Kopieren & Co.
  bool get isReserved {
    if (shift || alt) return false;
    const taken = [
      LogicalKeyboardKey.digit1, LogicalKeyboardKey.digit2, //
      LogicalKeyboardKey.digit3, LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5, LogicalKeyboardKey.digit6,
      LogicalKeyboardKey.keyF, LogicalKeyboardKey.keyK,
      LogicalKeyboardKey.keyN, LogicalKeyboardKey.comma,
      LogicalKeyboardKey.keyQ, LogicalKeyboardKey.keyW,
      LogicalKeyboardKey.keyC, LogicalKeyboardKey.keyV,
      LogicalKeyboardKey.keyX, LogicalKeyboardKey.keyA,
      LogicalKeyboardKey.keyZ, LogicalKeyboardKey.keyM,
      LogicalKeyboardKey.keyH,
    ];
    return taken.any((k) => k.keyId == keyId);
  }

  @override
  bool operator ==(Object other) =>
      other is PinShortcut &&
      other.keyId == keyId &&
      other.shift == shift &&
      other.alt == alt;

  @override
  int get hashCode => Object.hash(keyId, shift, alt);
}

@immutable
class SidebarPin {
  final String key;
  final PinShortcut? shortcut;
  const SidebarPin(this.key, [this.shortcut]);
}

/// Läuft gerade ein Kachel-Zug? Dann zeigt die Seitenleiste ihre Positionen.
final sidebarDraggingProvider = StateProvider<bool>((ref) => false);

final sidebarPinsProvider =
    StateNotifierProvider<SidebarPinsNotifier, List<SidebarPin>>(
        (ref) => SidebarPinsNotifier());

class SidebarPinsNotifier extends StateNotifier<List<SidebarPin>> {
  SidebarPinsNotifier() : super(const []) {
    _load();
  }

  static const _prefsKey = 'desktopSidebarPins';

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_prefsKey) ?? const [];
      if (!mounted) return;
      state = [
        for (final r in raw)
          if (r.split('|').first.isNotEmpty)
            SidebarPin(
                r.split('|').first,
                PinShortcut.decode(
                    r.contains('|') ? r.substring(r.indexOf('|') + 1) : null)),
      ];
    } catch (_) {/* ohne gespeicherte Einträge starten */}
  }

  void _set(List<SidebarPin> next) {
    state = next;
    SharedPreferences.getInstance().then((p) => p.setStringList(_prefsKey, [
          for (final s in next) '${s.key}|${s.shortcut?.encode() ?? ''}',
        ]));
  }

  bool contains(String key) => state.any((p) => p.key == key);

  /// Heftet [key] an Position [index] (bzw. verschiebt ihn dorthin).
  /// `false`, wenn die Leiste voll ist.
  bool pinAt(String key, int index) {
    final existing = state.where((p) => p.key == key).firstOrNull;
    if (existing == null && state.length >= kMaxSidebarPins) return false;
    final next = [...state.where((p) => p.key != key)];
    next.insert(index.clamp(0, next.length), existing ?? SidebarPin(key));
    _set(next);
    return true;
  }

  void unpin(String key) => _set([...state.where((p) => p.key != key)]);

  void setShortcut(String key, PinShortcut? shortcut) => _set([
        for (final p in state) p.key == key ? SidebarPin(key, shortcut) : p,
      ]);
}

/// Dialog „Tastenkürzel festlegen": wartet auf eine Kombination mit ⌘/Strg.
/// Ergebnis: `null` = abgebrochen (nichts ändern), sonst das neue Kürzel
/// (`shortcut == null` = ohne Kürzel).
Future<({PinShortcut? shortcut})?> showPinShortcutDialog(
  BuildContext context, {
  required String name,
  required PinShortcut? current,
  required bool Function(PinShortcut) isTaken,
}) =>
    showDialog<({PinShortcut? shortcut})>(
      context: context,
      builder: (_) =>
          _ShortcutDialog(name: name, current: current, isTaken: isTaken),
    );

class _ShortcutDialog extends StatefulWidget {
  final String name;
  final PinShortcut? current;
  final bool Function(PinShortcut) isTaken;
  const _ShortcutDialog(
      {required this.name, required this.current, required this.isTaken});

  @override
  State<_ShortcutDialog> createState() => _ShortcutDialogState();
}

class _ShortcutDialogState extends State<_ShortcutDialog> {
  late PinShortcut? _picked = widget.current;
  bool _taken = false;
  final _focus = FocusNode();

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  static final _modifiers = {
    LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.metaRight, //
    LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.controlRight,
    LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.shiftRight,
    LogicalKeyboardKey.altLeft, LogicalKeyboardKey.altRight,
    LogicalKeyboardKey.capsLock, LogicalKeyboardKey.fn,
  };

  KeyEventResult _onKey(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final key = e.logicalKey;
    // Esc/Enter/Tab bleiben für den Dialog selbst.
    if (key == LogicalKeyboardKey.escape ||
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.tab) {
      return KeyEventResult.ignored;
    }
    if (_modifiers.contains(key)) return KeyEventResult.handled;
    final hw = HardwareKeyboard.instance;
    final primary = Platform.isMacOS ? hw.isMetaPressed : hw.isControlPressed;
    if (!primary) return KeyEventResult.handled;
    final s =
        PinShortcut(key.keyId, shift: hw.isShiftPressed, alt: hw.isAltPressed);
    setState(() {
      _taken = s != widget.current && (s.isReserved || widget.isTaken(s));
      _picked = _taken ? _picked : s;
    });
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: context.appCard,
      title: Text(l.sidebarShortcutTitle(widget.name)),
      content: Focus(
        focusNode: _focus,
        autofocus: true,
        onKeyEvent: _onKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.sidebarShortcutPrompt(Platform.isMacOS ? '⌘' : 'Strg'),
                style: TextStyle(color: context.appFgSub, fontSize: 14)),
            const SizedBox(height: 16),
            Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.appSurface2,
                borderRadius: BorderRadius.circular(AppTokens.rSm),
                border: Border.all(
                    color: _taken ? AppTokens.danger : context.appSeparator),
              ),
              child: Text(_picked?.label ?? '—',
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: context.appFg,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
            ),
            SizedBox(
              height: 26,
              child: _taken
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(l.sidebarShortcutTaken,
                          style: const TextStyle(
                              color: AppTokens.danger, fontSize: 13)),
                    )
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, (shortcut: null)),
            child: Text(l.sidebarShortcutNone)),
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(
          onPressed: _picked == null
              ? null
              : () => Navigator.pop(context, (shortcut: _picked)),
          child: Text(l.save),
        ),
      ],
    );
  }
}
