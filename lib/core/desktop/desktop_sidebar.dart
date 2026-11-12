import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../features/auth/widgets/account_tab.dart';
import '../../features/users/providers/users_provider.dart'
    show userDisplayName;
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/user_avatar.dart';
import '../api/api_service.dart' show currentUserProvider;
import '../providers/settings_provider.dart';
import '../utils/platform_features.dart';
import '../../features/home/screens/home_screen.dart' show searchableHomeTiles;
import 'sidebar_pins.dart';

// ---------------------------------------------------------------------------
// Seitenleiste der Desktop-Apps (Windows/macOS) — ersetzt auf breiten
// Fenstern die Tab-Leiste am unteren Rand.
//
// Gleiche Ziele, Symbole, Farben und Schriften wie die Handy-App, aber an der
// Stelle, an der man sie am Rechner erwartet: links, dauerhaft sichtbar, mit
// ausgeschriebenen Namen und den Tastenkürzeln daneben. Sie liegt UM den
// Navigator (MaterialApp.builder) und bleibt deshalb auch auf Unterseiten
// (Rezept, Import, Verwaltung …) stehen.
//
// Breite: ab [_expandedFrom] mit Text (232), darunter als schmale Symbol-
// Leiste (84). Unter [LargeScreen.minWidth] gibt es keine Seitenleiste —
// dort sieht das Fenster aus wie die Handy-App (Tab-Leiste unten).
// ---------------------------------------------------------------------------

/// Sagt den Seiten, ob die Seitenleiste gerade die Navigation übernimmt
/// (dann entfällt die Tab-Leiste unten samt ihrem Platzbedarf).
class DesktopSidebarScope extends InheritedWidget {
  final bool active;
  const DesktopSidebarScope(
      {super.key, required this.active, required super.child});

  static bool isActive(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<DesktopSidebarScope>()
          ?.active ??
      false;

  @override
  bool updateShouldNotify(DesktopSidebarScope old) => old.active != active;
}

enum _Dest { home, recipes, shopping, plan, manage, settings }

class DesktopShell extends ConsumerStatefulWidget {
  final GoRouter router;
  final Widget child;
  const DesktopShell({super.key, required this.router, required this.child});

  static const double _expandedFrom = 1180;
  static const double expandedWidth = 232;
  static const double compactWidth = 84;

  @override
  ConsumerState<DesktopShell> createState() => _DesktopShellState();
}

class _DesktopShellState extends ConsumerState<DesktopShell> {
  // Einmal beim Start festgelegt (Rechner oder Tablet): die Baumform darf
  // sich danach nicht mehr ändern, sonst verlöre der Navigator beim Drehen
  // des Geräts alle offenen Seiten. Handys bekommen die Hülle nie.
  bool? _enabled;

  // Bleibt beim Wechsel schmal ↔ breit derselbe Zweig im Baum, damit der
  // Navigator (und alle offenen Seiten) den Fenster-Resize übersteht.
  final _contentKey = GlobalKey();
  _Dest _last = _Dest.home;
  String _path = '';

  @override
  void initState() {
    super.initState();
    widget.router.routerDelegate.addListener(_onRoute);
    _path = _readPath();
  }

  @override
  void didUpdateWidget(DesktopShell old) {
    super.didUpdateWidget(old);
    if (old.router != widget.router) {
      old.router.routerDelegate.removeListener(_onRoute);
      widget.router.routerDelegate.addListener(_onRoute);
      _path = _readPath();
    }
  }

  @override
  void dispose() {
    widget.router.routerDelegate.removeListener(_onRoute);
    // Erst aus dem Overlay lösen, dann freigeben (Reihenfolge ist Pflicht).
    _entry.remove();
    _entry.dispose();
    super.dispose();
  }

  String _readPath() {
    try {
      return widget.router.routerDelegate.currentConfiguration.uri.path;
    } catch (_) {
      return ''; // noch keine Route
    }
  }

  // Der Router meldet Wechsel auch MITTEN im Build (erste Route, Redirects)
  // — dann erst nach dem Frame neu bauen.
  void _onRoute() {
    final next = _readPath();
    if (next == _path || !mounted) return;
    void apply() {
      if (mounted) setState(() => _path = _readPath());
    }

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) => apply());
    } else {
      apply();
    }
  }

  _Dest? _destFor(String path) {
    if (path.startsWith('/home')) return _Dest.home;
    if (path.startsWith('/recipes')) return _Dest.recipes;
    if (path.startsWith('/shopping')) return _Dest.shopping;
    if (path.startsWith('/mealplan') || path.startsWith('/week-planner')) {
      return _Dest.plan;
    }
    if (path.startsWith('/manage')) return _Dest.manage;
    if (path.startsWith('/settings')) return _Dest.settings;
    return null; // Unterseite: letzter Bereich bleibt markiert.
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    // Ganz am Anfang kann die Fenstergröße noch 0 sein — dann noch nicht
    // festlegen (sonst gälte ein Tablet für immer als Handy).
    if (_enabled == null && !LargeScreen.isDesktop && mq.size.isEmpty) {
      return widget.child;
    }
    _enabled ??= LargeScreen.isDesktop || mq.size.shortestSide >= 600;
    // Handy: nichts zu tun (Baumform bleibt dort konstant).
    if (!_enabled!) return widget.child;
    // Tablet: Seitenleiste nur, wenn in den Einstellungen gewünscht.
    final wanted = LargeScreen.isDesktop ||
        (ref.watch(settingsProvider).valueOrNull?.tabletSidebar ?? true);
    // Eigenes Overlay UM Seitenleiste + Navigator: gezogene Kacheln (und
    // andere „rootOverlay"-Elemente) liegen damit über dem ganzen Fenster,
    // statt an der Kante der Seitenleiste abgeschnitten zu werden.
    return _ShellData(
      state: this,
      wanted: wanted,
      mq: mq,
      path: _path,
      child: Overlay(initialEntries: [_entry]),
    );
  }

  late final OverlayEntry _entry =
      OverlayEntry(builder: (context) => _body(context));

  Widget _body(BuildContext context) {
    final data = context.dependOnInheritedWidgetOfExactType<_ShellData>()!;
    final mq = data.mq;
    return Builder(
      builder: (context) {
        final path = data.path;
        final onAuthPage = path.isEmpty ||
            path == '/' ||
            path.startsWith('/setup') ||
            path.startsWith('/biometric');
        final show = data.wanted && LargeScreen.isWide(context) && !onAuthPage;
        final dest = _destFor(path);
        if (dest != null) _last = dest;
        final expanded = mq.size.width >= DesktopShell._expandedFrom;
        final barWidth = !show
            ? 0.0
            : expanded
                ? DesktopShell.expandedWidth
                : DesktopShell.compactWidth;
        return DesktopSidebarScope(
          active: show,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (show)
                _Sidebar(
                  key: const ValueKey('desktop-sidebar'),
                  router: widget.router,
                  current: _last,
                  path: path,
                  expanded: expanded,
                  width: barWidth,
                ),
              Expanded(
                key: _contentKey,
                // Die Seiten rechnen mit der tatsächlich sichtbaren Breite
                // (Spaltenzahl, Zwei-Spalten-Ansicht, Lesespalte).
                child: MediaQuery(
                  data: mq.copyWith(
                      size: Size(mq.size.width - barWidth, mq.size.height)),
                  child: widget.child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Reicht Fenstergröße, Pfad und Seiteninhalt in den Overlay-Eintrag.
class _ShellData extends InheritedWidget {
  final _DesktopShellState state;
  final bool wanted;
  final MediaQueryData mq;
  final String path;
  const _ShellData({
    required this.state,
    required this.wanted,
    required this.mq,
    required this.path,
    required super.child,
  });

  // Der Seiteninhalt (state.widget.child) wechselt bei jedem Build.
  @override
  bool updateShouldNotify(_ShellData old) => true;
}

class _Sidebar extends ConsumerWidget {
  final GoRouter router;
  final _Dest current;

  /// Aktueller Pfad — ein Ziel, auf dem man schon steht, wird nicht noch
  /// einmal geöffnet.
  final String path;
  final bool expanded;
  final double width;
  const _Sidebar({
    super.key,
    required this.router,
    required this.current,
    required this.path,
    required this.expanded,
    required this.width,
  });

  String get _mod => Platform.isMacOS ? '⌘' : 'Strg+';

  /// Tastenkürzel nur am Rechner anzeigen (Tablets haben keine).
  String? _hint(String keys) => LargeScreen.isDesktop ? '$_mod$keys' : null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    Widget dest(_Dest d, IconData icon, String label, String route,
            {String? shortcut, bool push = false}) =>
        _SidebarItem(
          icon: icon,
          label: label,
          shortcut: shortcut,
          active: current == d,
          expanded: expanded,
          onTap: () {
            if (path == route) return;
            push ? router.push(route) : router.go(route);
          },
        );
    Widget action(
            IconData icon, String label, String route, String? shortcut) =>
        _SidebarItem(
          icon: icon,
          label: label,
          shortcut: shortcut,
          active: false,
          expanded: expanded,
          onTap: () {
            if (path != route) router.push(route);
          },
        );

    // Eigene Einträge (Anheften per Ziehen + Kürzel) gibt es nur am Rechner.
    final pins = LargeScreen.isDesktop
        ? ref.watch(sidebarPinsProvider)
        : const <SidebarPin>[];
    final dragging =
        LargeScreen.isDesktop && ref.watch(sidebarDraggingProvider);
    final nav = router.routerDelegate.navigatorKey.currentContext;
    // Nur Kacheln, die der Nutzer (noch) sehen darf.
    final tiles = nav == null
        ? const <({
            String key,
            IconData icon,
            String label,
            VoidCallback onTap
          })>[]
        : searchableHomeTiles(nav, ref);
    final shown = [
      for (final p in pins)
        if (tiles.where((t) => t.key == p.key).firstOrNull != null)
          (pin: p, tile: tiles.firstWhere((t) => t.key == p.key)),
    ];

    Future<void> askShortcut(String key) async {
      final ctx = router.routerDelegate.navigatorKey.currentContext;
      final tile = tiles.where((t) => t.key == key).firstOrNull;
      if (ctx == null || tile == null) return;
      final notifier = ref.read(sidebarPinsProvider.notifier);
      final current = ref
          .read(sidebarPinsProvider)
          .where((p) => p.key == key)
          .firstOrNull
          ?.shortcut;
      final res = await showPinShortcutDialog(
        ctx,
        name: tile.label,
        current: current,
        isTaken: (s) => ref
            .read(sidebarPinsProvider)
            .any((p) => p.key != key && p.shortcut == s),
      );
      if (res != null) notifier.setShortcut(key, res.shortcut);
    }

    void drop(TileDrag d, int index) {
      final notifier = ref.read(sidebarPinsProvider.notifier);
      final isNew = !notifier.contains(d.key);
      if (!notifier.pinAt(d.key, index)) {
        final ctx = router.routerDelegate.navigatorKey.currentContext;
        if (ctx != null) {
          ScaffoldMessenger.maybeOf(ctx)?.showSnackBar(
              SnackBar(content: Text(l.sidebarFull(kMaxSidebarPins))));
        }
        return;
      }
      // Frisch angeheftet → gleich nach dem Tastenkürzel fragen.
      if (isNew) {
        WidgetsBinding.instance.addPostFrameCallback((_) => askShortcut(d.key));
      }
    }

    Future<void> pinMenu(String key, Offset globalPosition) async {
      final ctx = router.routerDelegate.navigatorKey.currentContext;
      if (ctx == null) return;
      final overlay =
          Navigator.of(ctx).overlay?.context.findRenderObject() as RenderBox?;
      if (overlay == null) return;
      final at = globalPosition - overlay.localToGlobal(Offset.zero);
      Widget row(IconData icon, String text, {Color? color}) => Row(children: [
            Icon(icon, size: 20, color: color ?? ctx.appFg),
            const SizedBox(width: 12),
            Flexible(
                child: Text(text, style: TextStyle(color: color ?? ctx.appFg))),
          ]);
      final picked = await showMenu<String>(
        context: ctx,
        color: ctx.appCard,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.rSm)),
        position: RelativeRect.fromLTRB(
            at.dx < 8 ? 8 : at.dx, at.dy, overlay.size.width, 0),
        items: [
          PopupMenuItem(
              value: 'shortcut',
              child: row(Icons.keyboard_rounded, l.sidebarShortcutChange)),
          PopupMenuItem(
              value: 'unpin',
              child: row(Icons.push_pin_outlined, l.sidebarUnpin,
                  color: AppTokens.danger)),
        ],
      );
      if (picked == 'shortcut') await askShortcut(key);
      if (picked == 'unpin') {
        ref.read(sidebarPinsProvider.notifier).unpin(key);
      }
    }

    final pinned = <Widget>[
      if (shown.isNotEmpty || dragging)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Divider(height: 1, color: context.appSeparator),
        ),
      for (var i = 0; i < shown.length; i++)
        // Auf einen vorhandenen Eintrag ziehen = davor einsortieren.
        DragTarget<TileDrag>(
          onWillAcceptWithDetails: (d) => d.data.key != shown[i].pin.key,
          onAcceptWithDetails: (d) => drop(d.data, pins.indexOf(shown[i].pin)),
          builder: (ctx, cand, _) => DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    width: 2,
                    color: cand.isNotEmpty
                        ? AppTokens.accent
                        : Colors.transparent),
              ),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onSecondaryTapUp: (d) =>
                  pinMenu(shown[i].pin.key, d.globalPosition),
              child: _SidebarItem(
                icon: shown[i].tile.icon,
                label: shown[i].tile.label,
                shortcut: shown[i].pin.shortcut?.label,
                active: false,
                expanded: expanded,
                onTap: shown[i].tile.onTap,
              ),
            ),
          ),
        ),
      // Während eine Kachel gezogen wird: graue Positionen für die freien
      // Plätze (wie die leeren Tage im Essensplan).
      if (dragging)
        for (var i = pins.length; i < kMaxSidebarPins; i++)
          DragTarget<TileDrag>(
            onAcceptWithDetails: (d) => drop(d.data, pins.length),
            builder: (ctx, cand, _) => _DropSlot(
              hovered: cand.isNotEmpty,
              expanded: expanded,
              label: l.sidebarDropHere,
            ),
          ),
    ];

    return Material(
      color: context.appCard,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: context.appSeparator)),
        ),
        padding: EdgeInsets.fromLTRB(
            expanded ? 12 : 8,
            14 + MediaQuery.paddingOf(context).top,
            expanded ? 12 : 8,
            12 + MediaQuery.paddingOf(context).bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AccountButton(router: router, expanded: expanded),
            const SizedBox(height: 14),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    dest(_Dest.home, Icons.home_rounded, l.navHome, '/home',
                        shortcut: _hint('1')),
                    dest(_Dest.recipes, Icons.restaurant_menu_rounded,
                        l.recipes, '/recipes',
                        shortcut: _hint('2')),
                    dest(_Dest.shopping, Icons.shopping_cart_rounded,
                        l.shopping, '/shopping',
                        shortcut: _hint('3')),
                    dest(_Dest.plan, Icons.event_rounded, l.planning,
                        '/mealplan',
                        shortcut: _hint('4')),
                    dest(_Dest.manage, Icons.grid_view_rounded,
                        l.managementTitle, '/manage',
                        shortcut: _hint('5'), push: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 10),
                      child: Divider(height: 1, color: context.appSeparator),
                    ),
                    action(
                        Icons.search_rounded, l.search, '/search', _hint('F')),
                    action(Icons.download_rounded, l.importRecipe, '/import',
                        _hint('N')),
                    ...pinned,
                  ],
                ),
              ),
            ),
            dest(_Dest.settings, Icons.settings_rounded, l.navSettings,
                '/settings',
                shortcut: _hint('6')),
          ],
        ),
      ),
    );
  }
}

/// Graue Ablage-Position für eine gezogene Kachel.
class _DropSlot extends StatelessWidget {
  final bool hovered;
  final bool expanded;
  final String label;
  const _DropSlot(
      {required this.hovered, required this.expanded, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: expanded ? 42 : 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: hovered
              ? AppTokens.accent.withValues(alpha: 0.18)
              : context.appSurface2,
          borderRadius: BorderRadius.circular(AppTokens.rSm),
          border: Border.all(
              color: hovered ? AppTokens.accent : context.appSeparator,
              width: hovered ? 1.5 : 1),
        ),
        child: hovered && expanded
            ? Text(label,
                style: const TextStyle(
                    color: AppTokens.accentDeep,
                    fontSize: 12,
                    fontWeight: FontWeight.w700))
            : Icon(Icons.add_rounded,
                size: 18,
                color: hovered ? AppTokens.accentDeep : context.appFgTertiary),
      ),
    );
  }
}

/// Profilbild + Name oben in der Seitenleiste; Klick → Konto-Menü.
class _AccountButton extends ConsumerWidget {
  final GoRouter router;
  final bool expanded;
  const _AccountButton({required this.router, required this.expanded});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final id = user?['id']?.toString();
    final name = user == null ? '' : userDisplayName(user);
    final server = ref.watch(settingsProvider).valueOrNull?.serverUrl ?? '';
    final host = Uri.tryParse(server)?.host ?? '';
    final avatar = (id == null || id.isEmpty)
        ? CircleAvatar(
            radius: 17,
            backgroundColor: AppTokens.accent.withValues(alpha: 0.14),
            child: const Icon(Icons.person_rounded,
                size: 20, color: AppTokens.accentDeep),
          )
        : UserAvatar(
            userId: id,
            name: name,
            radius: 17,
            highlight: true,
            cacheKey: user?['cacheKey']?.toString(),
          );
    return Builder(
      builder: (anchor) => InkWell(
        borderRadius: BorderRadius.circular(AppTokens.rSm),
        onTap: () {
          final nav = router.routerDelegate.navigatorKey.currentContext;
          if (nav == null) return;
          showAccountMenu(nav, ref, positionFrom: anchor, below: true);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: expanded
              ? Row(
                  children: [
                    avatar,
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name.isEmpty ? 'Mealie Recipes' : name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  color: context.appFg,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2)),
                          if (host.isNotEmpty)
                            Text(host,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: context.appFgTertiary,
                                    fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.unfold_more_rounded,
                        size: 18, color: context.appFgTertiary),
                  ],
                )
              : Center(child: avatar),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? shortcut;
  final bool active;
  final bool expanded;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.expanded,
    required this.onTap,
    this.shortcut,
  });

  @override
  Widget build(BuildContext context) {
    final fg = active ? AppTokens.accentDeep : context.appFgSub;
    final radius = BorderRadius.circular(AppTokens.rSm);
    final Widget content = expanded
        ? Row(
            children: [
              Icon(icon, size: 20, color: fg),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: active ? context.appFg : context.appFgSub,
                        fontSize: 14,
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.w600)),
              ),
              if (shortcut != null)
                Text(shortcut!,
                    style:
                        TextStyle(color: context.appFgTertiary, fontSize: 11)),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 22, color: fg),
              const SizedBox(height: 3),
              Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: fg,
                      fontSize: 10,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w600)),
            ],
          );
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Semantics(
        button: true,
        selected: active,
        child: Material(
          color: active
              ? AppTokens.accent.withValues(alpha: 0.14)
              : Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Padding(
              padding: expanded
                  ? const EdgeInsets.symmetric(horizontal: 12, vertical: 11)
                  : const EdgeInsets.symmetric(horizontal: 2, vertical: 9),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
