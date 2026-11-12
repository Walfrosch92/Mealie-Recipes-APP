import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Sprung aus der globalen Suche zu einem Listeneintrag: die Route trägt
// `?highlight=<id>&t=<ms>`; die Liste scrollt hin und rahmt den Eintrag kurz
// orange ein (wie die Abschnitte in den Einstellungen).
//
// Bei ListView.builder existieren Einträge außerhalb des Bildschirms noch
// nicht — deshalb erst grob an die geschätzte Position springen und dann,
// sobald der Eintrag gebaut ist, genau hinscrollen (wenige Versuche).
//
// Nutzung im State: `with SearchJumpMixin`, in build
// `handleSearchJump(context, ids)` mit den angezeigten IDs aufrufen,
// `searchScroll` als Controller der Liste setzen und jeden Eintrag mit
// `searchHighlight(id, child)` umhüllen.
// ---------------------------------------------------------------------------

mixin SearchJumpMixin<T extends StatefulWidget> on State<T> {
  final searchScroll = ScrollController();
  final Map<String, GlobalKey> _jumpKeys = {};
  String? _handledJump;
  String? _highlightedId;
  Timer? _highlightTimer;

  @override
  void dispose() {
    _highlightTimer?.cancel();
    searchScroll.dispose();
    super.dispose();
  }

  GlobalKey _keyFor(String id) => _jumpKeys.putIfAbsent(id, GlobalKey.new);

  /// In build aufrufen — [ids] in der angezeigten Reihenfolge. Ist der
  /// Eintrag (noch) nicht geladen, wird es beim nächsten build erneut
  /// versucht.
  void handleSearchJump(BuildContext context, List<String> ids) {
    // Ohne GoRouter-Seite (z. B. per MaterialPageRoute geöffnet) gibt es
    // keinen Sprung — nicht abstürzen.
    final Uri uri;
    try {
      uri = GoRouterState.of(context).uri;
    } catch (_) {
      return;
    }
    final id = uri.queryParameters['highlight'];
    if (id == null) {
      _handledJump = null;
      return;
    }
    final jump = uri.query;
    if (jump == _handledJump) return;
    final index = ids.indexOf(id);
    if (index < 0) return;
    _handledJump = jump;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollTo(id, index, ids.length, 0));
  }

  void _scrollTo(String id, int index, int count, int attempt) {
    if (!mounted) return;
    final ctx = _jumpKeys[id]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          alignment: 0.3,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut);
      setState(() => _highlightedId = id);
      _highlightTimer?.cancel();
      _highlightTimer = Timer(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _highlightedId = null);
      });
      return;
    }
    if (attempt >= 6 || !searchScroll.hasClients) return;
    // Noch nicht gebaut → an die geschätzte Stelle springen, dann erneut.
    final pos = searchScroll.position;
    final total = pos.maxScrollExtent + pos.viewportDimension;
    final estimate = total / count * index - pos.viewportDimension * 0.3;
    searchScroll
        .jumpTo(estimate.clamp(pos.minScrollExtent, pos.maxScrollExtent));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollTo(id, index, count, attempt + 1));
  }

  /// Listeneintrag umhüllen: Ziel zum Hinscrollen + kurzer oranger Rahmen.
  Widget searchHighlight(String id, Widget child,
      {double radius = AppTokens.rMd}) {
    final on = _highlightedId == id;
    return KeyedSubtree(
      key: _keyFor(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
              color: on ? AppTokens.accent : Colors.transparent, width: 2),
        ),
        child: child,
      ),
    );
  }
}
