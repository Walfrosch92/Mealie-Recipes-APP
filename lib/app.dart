import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import 'core/providers/settings_provider.dart';
import 'core/utils/app_l10n.dart';
import 'core/utils/platform_features.dart';
import 'core/services/deep_link_handler.dart';
import 'core/services/recipe_detail_cache.dart';
import 'core/services/widget_sync_provider.dart';
import 'features/auth/providers/biometric_lock_provider.dart';
import 'features/auth/screens/biometric_lock_screen.dart';
import 'features/recipe_send/screens/pending_recipes_sheet.dart';
import 'features/recipe_send/services/recipe_send_service.dart';
import 'features/auth/screens/setup_screen.dart';
import 'features/cooking_mode/providers/cooking_session_provider.dart';
import 'features/timer/services/notification_service.dart';
import 'features/home/screens/home_screen.dart';
import 'features/recipes/providers/recipes_provider.dart';
import 'features/recipes/screens/recipe_list_screen.dart';
import 'features/recipes/screens/recipe_detail_screen.dart';
import 'features/recipe_edit/screens/recipe_edit_screen.dart';
import 'features/recipe_upload/screens/import_recipe_screen.dart';
import 'features/shopping_list/providers/shopping_list_provider.dart';
import 'features/shopping_list/screens/shopping_list_screen.dart';
import 'features/shopping_list/screens/archived_shopping_lists_screen.dart';
import 'features/mealplan/screens/mealplan_screen.dart';
import 'features/cooking_mode/screens/cooking_mode_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/leftovers/screens/leftover_finder_screen.dart';
import 'core/models/organizer_item.dart';
import 'features/organizers/screens/organizers_screen.dart';
import 'features/timeline/screens/timeline_screen.dart';
import 'features/recipes/screens/favorites_screen.dart';
import 'features/users/screens/user_management_screen.dart';
import 'features/users/screens/household_management_screen.dart';
import 'features/shopping_list/screens/shopping_lists_screen.dart';
import 'features/foods_units/providers/foods_units_admin_provider.dart';
import 'features/foods_units/screens/foods_units_screen.dart';
import 'features/foods_units/screens/labels_screen.dart';
import 'features/cookbooks/screens/cookbooks_screen.dart';
import 'features/cookbooks/screens/cookbook_edit_screen.dart';
import 'features/cookbooks/screens/cookbook_recipes_screen.dart';
import 'features/cook_friends/screens/cook_friends_screen.dart';
import 'features/webapp_tools/screens/admin_screen.dart';
import 'features/webapp_tools/screens/ai_providers_screen.dart';
import 'features/webapp_tools/screens/debug_screen.dart';
import 'features/webapp_tools/screens/backups_screen.dart';
import 'features/webapp_tools/screens/bulk_import_screen.dart';
import 'features/webapp_tools/screens/maintenance_screen.dart';
import 'features/webapp_tools/screens/migrations_screen.dart';
import 'features/webapp_tools/screens/notifiers_screen.dart';
import 'features/webapp_tools/screens/recipe_actions_screen.dart';
import 'features/webapp_tools/screens/recipe_data_screen.dart';
import 'features/webapp_tools/screens/report_screen.dart';
import 'features/webapp_tools/screens/update_screen.dart';
import 'features/webapp_tools/screens/webhooks_screen.dart';
import 'shared/widgets/liquid_glass.dart';

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

/// Nativer iOS-Seitenübergang (horizontaler Slide) für alle Inhalts-Routen.
/// Bewusst `CupertinoPage` statt einer `CustomTransitionPage`: nur damit ist
/// die systemseitige „vom linken Rand nach rechts wischen = zurück"-Geste
/// aktiv (interaktiver Pop mit Finger-Tracking). Hero-Animationen (z. B.
/// Rezeptbild) laufen unabhängig davon weiter.
CupertinoPage<void> _animatedPage(GoRouterState state, Widget child) {
  return CupertinoPage<void>(
    key: state.pageKey,
    // `name` = aktuelle Location als Route-Metadaten (Debugging / etwaige
    // NavigatorObserver). Harmlos, auch wenn aktuell niemand sie ausliest.
    name: state.matchedLocation,
    child: child,
  );
}

/// Root-Navigator: Routen mit diesem `parentNavigatorKey` (Rezept-Detail,
/// Edit, Kochmodus, …) werden ÜBER der Tab-Shell gepusht — sie sliden über
/// die fixe GlassTabBar statt sie mitzubewegen.
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Start-Route, SYNCHRON in `main()` aus den SharedPreferences bestimmt
/// (eingerichtet → `/home`, sonst `/setup`). Damit trifft der Router die
/// Setup-vs-Home-Entscheidung schon beim allerersten Frame korrekt, ohne auf
/// das async Laden der Settings + das `refreshListenable`-Timing angewiesen zu
/// sein (sonst blitzte/blieb bei einem nicht eingerichteten Gerät kurz `/home`).
/// Default `/home`; `main()` überschreibt den Wert via ProviderScope.overrides.
final initialLocationProvider = Provider<String>((ref) => '/home');

final _routerProvider = Provider<GoRouter>((ref) {
  // Build the GoRouter ONCE. Re-running the redirect when the configured-state
  // changes is done via refreshListenable — NOT by rebuilding this provider.
  // Watching settingsProvider here would recreate the GoRouter on every save
  // (e.g. collapsing a shopping category) and reset navigation to '/home'.
  final refresh = ValueNotifier<int>(0);
  ref.onDispose(refresh.dispose);
  ref.listen(settingsProvider, (prev, next) {
    // Auf isConfigured (eigener Server eingerichtet) reagieren — das ist die
    // einzige Größe, die der Redirect noch auswertet. Plus den Loading→Data-
    // Übergang beim Cold-Start, damit der Redirect nach dem Settings-Load
    // einmal neu läuft (sonst bliebe ein nicht eingerichtetes Gerät auf der
    // initial gerenderten Route hängen statt ins Setup zu springen).
    final wasConfigured = prev?.valueOrNull?.isConfigured ?? false;
    final nowConfigured = next.valueOrNull?.isConfigured ?? false;
    final wasLoading = prev?.isLoading ?? true;
    if (wasConfigured != nowConfigured || wasLoading != next.isLoading) {
      refresh.value++;
    }
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: ref.read(initialLocationProvider),
    refreshListenable: refresh,
    redirect: (context, state) {
      final settingsAsync = ref.read(settingsProvider);
      if (settingsAsync.isLoading) return null;
      final loc = state.matchedLocation;
      // KERNREGEL: Solange KEIN eigener Server eingerichtet ist (isConfigured),
      // wird IMMER ins Setup geleitet — unabhängig vom (flüchtigen) Gastmodus-
      // Flag. So kann ein nicht eingerichtetes Gerät prinzipiell nie in der
      // Home-/Rezepte-/Settings-View landen. Einzige Ausnahme: die in-session
      // Gast-Screens, die man bewusst vom Setup aus über „Als Gast fortfahren"
      // erreicht (Cook-Friends-Lobby + geteilter Kochmodus) sowie das Gate.
      final configured = settingsAsync.valueOrNull?.isConfigured ?? false;
      if (!configured) {
        final guestAllowed = loc == '/setup' ||
            loc == '/cook-friends' ||
            loc.startsWith('/cooking') ||
            loc == '/biometric';
        return guestAllowed ? null : '/setup';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/setup',
        builder: (ctx, state) => const SetupScreen(),
      ),
      GoRoute(
        path: '/biometric',
        builder: (ctx, state) => const BiometricLockScreen(),
      ),
      // Tab-Shell: die 5 Haupt-Tabs teilen sich EINE fixe GlassTabBar, die
      // außerhalb der Branch-Navigatoren lebt. Detail-Routen
      // (`parentNavigatorKey: _rootNavigatorKey`) sliden ÜBER die Shell,
      // die Leiste bleibt dabei unbewegt. Beim Tab-Wechsel slidet NUR der
      // Inhalt Cupertino-artig von rechts herein (_AnimatedBranchContainer) —
      // die Leiste selbst steht fix. Branch-Reihenfolge == GlassTab-Enum.
      StatefulShellRoute(
        builder: (ctx, state, shell) => _TabShell(shell: shell),
        navigatorContainerBuilder: (ctx, shell, children) =>
            _AnimatedBranchContainer(
                currentIndex: shell.currentIndex, children: children),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              builder: (ctx, state) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/recipes',
              builder: (ctx, state) => const RecipeListScreen(),
              routes: [
                GoRoute(
                  path: ':slug',
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (ctx, state) => _animatedPage(state,
                      RecipeDetailScreen(slug: state.pathParameters['slug']!)),
                ),
                GoRoute(
                  path: ':slug/edit',
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (ctx, state) => _animatedPage(state,
                      RecipeEditScreen(slug: state.pathParameters['slug']!)),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/shopping',
              builder: (ctx, state) => const ShoppingListScreen(),
              routes: [
                GoRoute(
                  path: 'archived',
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (ctx, state) =>
                      _animatedPage(state, const ArchivedShoppingListsScreen()),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/mealplan',
              builder: (ctx, state) => const MealplanScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/settings',
              builder: (ctx, state) => const SettingsScreen(),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/import',
        pageBuilder: (ctx, state) {
          // `url` kommt vom Share-Deep-Link mealierecipes://import?url=…
          // (iOS Share Extension / Android Share-Sheet) → Feld vorbefüllt,
          // Nutzer wählt KI an/aus und startet selbst.
          final url = state.uri.queryParameters['url'];
          return _animatedPage(state, ImportRecipeScreen(sharedUrl: url));
        },
      ),
      GoRoute(
        path: '/cooking/:slug',
        pageBuilder: (ctx, state) => _animatedPage(
            state, CookingModeScreen(slug: state.pathParameters['slug']!)),
      ),
      // Kategorien / Schlagworte / Utensilien verwalten (Home-Kacheln).
      GoRoute(
        path: '/organizers/:kind',
        redirect: (ctx, state) =>
            OrganizerKind.fromPath(state.pathParameters['kind']) == null
                ? '/'
                : null,
        pageBuilder: (ctx, state) => _animatedPage(
            state,
            OrganizersScreen(
                kind: OrganizerKind.fromPath(state.pathParameters['kind'])!)),
      ),
      // Verwaltung (Home-Kachel): Unterseite mit den Verwaltungs-Kacheln.
      GoRoute(
        path: '/manage',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, const ManagementScreen()),
      ),
      // Haushaltsverwaltung (Kachel nur mit Recht sichtbar).
      GoRoute(
        path: '/households',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, const HouseholdManagementScreen()),
      ),
      // Benutzerverwaltung (Kachel nur mit Recht sichtbar).
      GoRoute(
        path: '/users',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, const UserManagementScreen()),
      ),
      // Einkaufslisten verwalten (Home-Kachel).
      GoRoute(
        path: '/shopping-lists',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, const ShoppingListsScreen()),
      ),
      // Favoriten („geherzte" Rezepte, Kachel in „Weiteres").
      GoRoute(
        path: '/favorites',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, const FavoritesScreen()),
      ),
      // Zeitleiste aller Rezepte (Home-Kachel).
      GoRoute(
        path: '/timeline',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, const TimelineScreen()),
      ),
      // Abteilungen (Mealie-Labels) verwalten.
      GoRoute(
        path: '/data/labels',
        pageBuilder: (ctx, state) => _animatedPage(state, const LabelsScreen()),
      ),
      // Lebensmittel / Einheiten verwalten (Home-Kacheln).
      GoRoute(
        path: '/data/:kind',
        redirect: (ctx, state) =>
            FoodUnitKind.fromPath(state.pathParameters['kind']) == null
                ? '/'
                : null,
        pageBuilder: (ctx, state) => _animatedPage(
            state,
            FoodsUnitsScreen(
                kind: FoodUnitKind.fromPath(state.pathParameters['kind'])!)),
      ),
      GoRoute(
        path: '/leftovers',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, const LeftoverFinderScreen()),
      ),
      GoRoute(
        path: '/cookbooks',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, const CookbooksScreen()),
        routes: [
          // 'new' VOR ':id' registriert, damit der literale Pfad bevorzugt
          // gematcht wird statt als Kochbuch-id ':id' interpretiert zu werden.
          GoRoute(
            path: 'new',
            pageBuilder: (ctx, state) =>
                _animatedPage(state, const CookbookEditScreen()),
          ),
          GoRoute(
            path: ':id',
            pageBuilder: (ctx, state) => _animatedPage(state,
                CookbookRecipesScreen(cookbookId: state.pathParameters['id']!)),
            routes: [
              GoRoute(
                path: 'edit',
                pageBuilder: (ctx, state) => _animatedPage(state,
                    CookbookEditScreen(cookbookId: state.pathParameters['id'])),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/cook-friends',
        pageBuilder: (ctx, state) {
          final slug = state.uri.queryParameters['slug'] ?? '';
          // `code` kommt aus dem Invite-Deep-Link mealierecipes://cook?code=…
          // → Auto-Join in CookFriendsScreen.
          final code = state.uri.queryParameters['code'] ?? '';
          return _animatedPage(
              state, CookFriendsScreen(slug: slug, code: code));
        },
      ),
      // ── Webapp-Werkzeuge (nur Desktop; Kacheln in „Weiteres") ──────────
      GoRoute(
        path: '/bulk-import',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, const BulkImportScreen()),
      ),
      GoRoute(
        path: '/migrations',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, const MigrationsScreen()),
      ),
      GoRoute(
        path: '/reports/:id',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, ReportScreen(id: state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/recipe-data',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, const RecipeDataScreen()),
      ),
      GoRoute(
        path: '/webhooks',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, const WebhooksScreen()),
      ),
      GoRoute(
        path: '/notifiers',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, const NotifiersScreen()),
      ),
      GoRoute(
        path: '/recipe-actions',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, const RecipeActionsScreen()),
      ),
      GoRoute(
        path: '/updates',
        pageBuilder: (ctx, state) => _animatedPage(state, const UpdateScreen()),
      ),
      GoRoute(
        path: '/ai-providers',
        pageBuilder: (ctx, state) =>
            _animatedPage(state, const AiProvidersScreen()),
      ),
      GoRoute(
        path: '/debug',
        pageBuilder: (ctx, state) => _animatedPage(state, const DebugScreen()),
      ),
      GoRoute(
        path: '/admin',
        pageBuilder: (ctx, state) => _animatedPage(state, const AdminScreen()),
        routes: [
          GoRoute(
            path: 'backups',
            pageBuilder: (ctx, state) =>
                _animatedPage(state, const BackupsScreen()),
          ),
          GoRoute(
            path: 'maintenance',
            pageBuilder: (ctx, state) =>
                _animatedPage(state, const MaintenanceScreen()),
          ),
        ],
      ),
    ],
  );
});

// ---------------------------------------------------------------------------
// Tab-Shell — fixe GlassTabBar über den Branch-Navigatoren.
//
// Bewusst KEIN eigenes Scaffold/bottomNavigationBar: ein Scaffold mit
// extendBody würde die Tab-Bar-Höhe in die MediaQuery-Paddings der Bodies
// injizieren — die Screens rechnen ihre Abstände aber selbst über die
// Konvention `GlassTabBar.height + … + MediaQuery.paddingOf(context).bottom`
// (siehe Edge-to-Edge-Insets). Der Stack lässt alle Insets unverändert, die
// Leiste schwebt einfach über dem Inhalt (deren Blur greift weiter).
// ---------------------------------------------------------------------------

class _TabShell extends StatelessWidget {
  final StatefulNavigationShell shell;
  const _TabShell({required this.shell});

  @override
  Widget build(BuildContext context) {
    // Material(transparency): die Shell liegt AUSSERHALB der Screen-Scaffolds
    // — ohne Material-Ancestor rendern die Tab-Label-Texte mit dem Fallback-
    // TextStyle (gelbe Doppel-Unterstreichung, „komische Striche").
    //
    // PopScope: Android-Back auf einem NICHT-Home-Tab wechselt zurück zu Home
    // statt die App zu schließen. Tab-Ziele werden per `go` erreicht (auch von
    // den Home-Schnellzugriffen) — es gibt dort nichts zu poppen, ohne diesen
    // Guard beendete der Back-Button die App. Gepushte Routen (Detail, Import,
    // Leftovers, …) liegen auf dem Root-Navigator und poppen ganz normal,
    // bevor dieser PopScope überhaupt greift.
    return PopScope(
      canPop: shell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) shell.goBranch(0);
      },
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Positioned.fill(child: shell),
            Align(
              alignment: Alignment.bottomCenter,
              child: GlassTabBar(current: GlassTab.values[shell.currentIndex]),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _AnimatedBranchContainer — Branch-Wechsel mit Cupertino-artigem Slide.
//
// Der Standard-Container (`StatefulShellRoute.indexedStack`) schaltet Branches
// hart um. Hier slidet der NEUE Tab-Inhalt von rechts herein und der alte
// schiebt sich (Parallax, 1/3) nach links hinaus — wie der CupertinoPage-
// Übergang vor dem Shell-Umbau, nur ohne die Tab-Leiste mitzubewegen.
// Inaktive Branches bleiben Offstage im Baum (Zustand/Scroll bleibt erhalten),
// TickerMode pausiert deren Animationen.
// ---------------------------------------------------------------------------

class _AnimatedBranchContainer extends StatefulWidget {
  final int currentIndex;
  final List<Widget> children;
  const _AnimatedBranchContainer(
      {required this.currentIndex, required this.children});

  @override
  State<_AnimatedBranchContainer> createState() =>
      _AnimatedBranchContainerState();
}

class _AnimatedBranchContainerState extends State<_AnimatedBranchContainer>
    with SingleTickerProviderStateMixin {
  // value: 1 = Ruhezustand (kein Slide beim allerersten Build).
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400), value: 1);
  late final CurvedAnimation _t =
      CurvedAnimation(parent: _controller, curve: Curves.linearToEaseOut);

  /// Während der Animation sichtbarer, hinausschiebender Branch — sonst null.
  int? _previousIndex;

  @override
  void didUpdateWidget(covariant _AnimatedBranchContainer old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _previousIndex = old.currentIndex;
      _controller.forward(from: 0).whenCompleteOrCancel(() {
        if (mounted) setState(() => _previousIndex = null);
      });
      // Branches bleiben dauerhaft im Baum (Offstage) — ShoppingListScreens
      // initState()/refreshOnOpen() feuert also nur beim ALLERERSTEN Öffnen
      // der App, nicht bei jedem Tab-Wechsel zurück auf „Einkaufsliste".
      // Ohne diesen Hook zeigte der Tab den zuletzt geladenen Stand, selbst
      // wenn zwischenzeitlich extern (Webapp, anderes Gerät) Artikel dazu-
      // kamen — der User musste manuell pull-to-refreshen. Deshalb bei
      // JEDEM Wechsel AUF den Shopping-Tab explizit vom Server neu laden
      // (network-first, kein blindes Vertrauen auf den alten Stand).
      if (widget.currentIndex == GlassTab.shopping.index) {
        ProviderScope.containerOf(context, listen: false)
            .read(shoppingListProvider.notifier)
            .refreshOnOpen();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Stack-Reihenfolge = Malreihenfolge: Offstage-Branches unten, der
    // hinausschiebende darunter, der aktive zuoberst. Die ValueKeys halten
    // die Element-Zuordnung beim Umsortieren stabil (Branch-Navigatoren
    // behalten so ihren State).
    final ordered = <Widget>[
      for (var i = 0; i < widget.children.length; i++)
        if (i != widget.currentIndex && i != _previousIndex)
          _branch(i, visible: false),
      if (_previousIndex != null)
        _branch(_previousIndex!, visible: true, outgoing: true),
      _branch(widget.currentIndex, visible: true),
    ];
    return Stack(fit: StackFit.expand, children: ordered);
  }

  Widget _branch(int i, {required bool visible, bool outgoing = false}) {
    Widget child = TickerMode(enabled: visible, child: widget.children[i]);
    if (visible) {
      child = AnimatedBuilder(
        animation: _t,
        builder: (context, c) => FractionalTranslation(
          translation: Offset(outgoing ? -_t.value / 3 : 1 - _t.value, 0),
          child: c,
        ),
        child: child,
      );
    }
    // HeroMode: Offstage hält Heroes zwar unsichtbar, nimmt sie aber NICHT
    // aus der Hero-Zielsuche. Ohne diese Sperre fliegt z. B. das Bild beim
    // Schließen eines Home-Vorschlags zur Kartenposition im unsichtbaren
    // Rezepte-Tab (gleiches `recipe-image-<id>`-Tag, Branch bleibt gemountet).
    return Offstage(
        key: ValueKey('tab-branch-$i'),
        offstage: !visible,
        child: HeroMode(enabled: visible, child: child));
  }
}

// ---------------------------------------------------------------------------
// App
// ---------------------------------------------------------------------------

class MealieApp extends ConsumerStatefulWidget {
  const MealieApp({super.key});

  @override
  ConsumerState<MealieApp> createState() => _MealieAppState();
}

class _MealieAppState extends ConsumerState<MealieApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Mirrors Swifts `onChange(of: scenePhase) { if .background ... }`:
    // sobald die App komplett in den Background geht, wieder sperren —
    // aber nur wenn der User das in den Settings aktiviert hat. `paused`
    // ist auf iOS und Android das echte „Background"; `inactive` (z.B.
    // Notification-Center-Pull) ignorieren wir bewusst, sonst lockt die
    // App bei jedem kurzen Wegblicken nervig oft.
    if (state == AppLifecycleState.paused) {
      final enabled =
          ref.read(settingsProvider).valueOrNull?.isBiometricLockEnabled ??
              false;
      ref.read(biometricLockProvider.notifier).lock(
            biometricLockEnabled: enabled,
          );
      // Einzeländerungen am Rezept-Cache werden entprellt geschrieben (siehe
      // RecipeDetailCacheManager._writeDebounce). Beim Wechsel in den
      // Hintergrund darf das Fenster nicht offen bleiben — sonst verliert ein
      // vom System beendeter Prozess die letzte Änderung.
      unawaited(RecipeDetailCacheManager.shared.flush());
    }
    // Ein Rezept-Sync, der unterbrochen wurde (iOS friert die App im
    // Hintergrund ein → laufende Requests enden im Timeout), setzt hier fort
    // statt erst beim nächsten Kaltstart. No-op, wenn alles abgeglichen ist.
    if (state == AppLifecycleState.resumed) {
      ref.read(recipesProvider.notifier).resumeSyncIfNeeded();
    }
  }

  /// Flag damit der pendingRecipes-Listener das Sheet nicht doppelt pusht
  /// wenn währen es schon offen ist eine weitere Recipe reinkommt — die
  /// Sheet watcht den Provider eh live und nimmt das zusätzliche Recipe
  /// automatisch in die Liste auf.
  bool _pendingRecipesSheetShowing = false;

  /// Versucht das PendingRecipesSheet zu pushen. Wartet auf den Navigator
  /// per PostFrame, retried alle 100 ms wenn die navigatorKey-Context noch
  /// nicht da ist (Cold-Launch-Race). Maximal ~5 s; bricht ab wenn die
  /// pending-Liste in der Zwischenzeit wieder leer wurde.
  void _tryOpenPendingSheet(GoRouter router, {required int attempts}) {
    void attempt() {
      // Race-Edge: state könnte in der Zwischenzeit zurückgeleert worden sein.
      final current = ref.read(pendingRecipesProvider);
      if (current.isEmpty) {
        _pendingRecipesSheetShowing = false;
        return;
      }
      final ctx = router.routerDelegate.navigatorKey.currentContext;
      if (ctx == null) {
        if (attempts >= 50) {
          _pendingRecipesSheetShowing = false;
          return;
        }
        Future.delayed(const Duration(milliseconds: 100), () {
          _tryOpenPendingSheet(router, attempts: attempts + 1);
        });
        return;
      }
      Navigator.of(ctx, rootNavigator: true)
          .push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => const PendingRecipesSheet(),
          ))
          .whenComplete(() => _pendingRecipesSheetShowing = false);
    }

    if (attempts == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => attempt());
    } else {
      attempt();
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(_routerProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final locale =
        _localeFor(settingsAsync.valueOrNull?.selectedLanguage ?? 'de');

    // Deep-Link-Empfang aktivieren: `mealierecipes://`-URIs aus Widget-Taps,
    // Notifications und externen App-Links landen via app_links auf dem
    // GoRouter. Idempotent attached — Mehrfach-Builds registrieren keine
    // zusätzlichen Subscriptions.
    //
    // Früh anhängen, damit ein Cold-Start-Initial-Link (Widget-Tap) erfasst
    // wird. Die Navigation selbst wird im Handler gepuffert, bis die App
    // bereit ist (Settings geladen + Server eingerichtet) — sonst würde vor
    // geladenem Server-URL/Token navigiert und der apiServiceProvider fiele
    // auf `const AppSettings()` (leer) zurück → Fehlermeldung statt Inhalt.
    final deepLinks = ref.read(deepLinkHandlerProvider);
    deepLinks.attach(router);
    deepLinks.markReady(settingsAsync.valueOrNull?.isConfigured ?? false);

    // Tap auf eine Timer-„fertig"-Benachrichtigung WÄHREND die App läuft:
    // zurück in den Kochmodus der passenden (sonst ersten) aktiven Kochsession
    // navigieren. Der Tap beendet bewusst NICHTS — weder den Kochmodus noch den
    // (weiter klingelnden) Timer; letzterer endet erst per Tipp auf den grünen
    // Chip. Idempotent in build gesetzt; der Kaltstart-Pfad läuft über
    // NotificationService.launchTimerPayload() in main().
    NotificationService.onTimerTap = (recipeId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final sessions = ref.read(cookingSessionsProvider);
        if (sessions.isEmpty) return;
        CookingSession? match;
        for (final s in sessions) {
          if (s.slug == recipeId) {
            match = s;
            break;
          }
        }
        match ??= sessions.first;
        // `go` statt `push`: vermeidet ein zweites Kochmodus-Page auf dem Stack
        // (gleicher pageKey → bestehende Instanz bleibt erhalten) und ist robust
        // gegen die unzuverlässige Route-Erkennung nach imperativem push.
        router.go('/cooking/${match.slug}');
      });
    };

    // iOS-Widget-Sync aktivieren: bündelt Mealplan/Shopping/Daily/Sprache-
    // Listener, die bei jeder State-Änderung die App-Group-UserDefaults
    // aktualisieren. `watch` (nicht `read`) damit der Provider an den
    // App-Lifecycle gekoppelt bleibt.
    ref.watch(widgetSyncProvider);

    // SendTo-Empfang: sobald die erste neue Pending-Recipe reinkommt (TCP-
    // Receive in recipe_send_service._onIncomingConnection → provider.add),
    // den modalen PendingRecipesSheet aufmachen. Triggert auf Transition
    // empty → non-empty; weitere Recipes während die Sheet offen ist tauchen
    // dort automatisch live auf (ConsumerWidget watcht den Provider).
    ref.listen<List<PendingRecipe>>(pendingRecipesProvider, (prev, next) {
      // Bei JEDER Anzahl-Erhöhung öffnen (nicht nur leer→nicht-leer): sonst
      // blockiert ein hängengebliebenes altes Pending-Rezept alle neuen
      // Empfänge. Läuft das Sheet schon, taucht das neue dort live auf.
      final prevCount = prev?.length ?? 0;
      if (next.length <= prevCount) return;
      if (_pendingRecipesSheetShowing) return;
      _pendingRecipesSheetShowing = true;
      // Retry-Loop bis der Navigator bereit ist. Beim Cold-Launch (App-Start
      // mit persistiertem Pending-Recipe aus Hydrate) ist die
      // navigatorKey.currentContext beim allerersten PostFrame oft noch
      // null — vorher wurde dann silent gebailt und die Sheet erschien nie.
      _tryOpenPendingSheet(router, attempts: 0);
    });

    return MaterialApp.router(
      title: 'Mealie Recipes',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: switch (settingsAsync.valueOrNull?.themeMode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      builder: (context, child) {
        // Übersetzungen für Code ohne Context (übersetzte 403-Meldungen).
        currentAppL10n = AppLocalizations.of(context);
        // Globaler Timer-Banner-Layer. Der Kochmodus-FAB wird NICHT hier
        // global eingehängt, sondern per Screen via WithCookingModeFAB —
        // weil GoRouter-Pushes Geschwister sind, nicht verschachtelt: ein
        // globaler Overlay würde auch über dem CookingModeScreen liegen.
        // Pro-Screen-Wrapping spiegelt SwiftUIs .withCookingModeFAB() das
        // dort an WelcomeView/RecipeDetailView direkt hängt.
        //
        // Der BiometricLockOverlay liegt als letztes oben drauf — wenn
        // gesperrt, schluckt er jede Interaktion mit der dahinterliegenden
        // App (1:1 zu Swifts `.overlay { if isAppLocked { BiometricLockView } }`).
        //
        // AnnotatedRegion: setzt den System-Overlay-Style THEME-ABHÄNGIG und
        // bei jedem Theme-Wechsel neu (der globale Set in main.dart greift nur
        // beim Cold-Start und kennt die Helligkeit nicht). Ohne die
        // Icon-Brightness sind auf Geräten mit transparenter
        // System-Navigationsleiste (3-Button-Leiste, Edge-to-Edge) die
        // Buttons/Statusbar-Icons in einem der beiden Modi unsichtbar.
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
            systemNavigationBarContrastEnforced: false,
          ),
          child: _LargeScreenFrame(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (child != null) Positioned.fill(child: child),
                const _BiometricLockOverlay(),
              ],
            ),
          ),
        );
      },
    );
  }

  Locale _localeFor(String code) => Locale(code);

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    // Warme Premium-Palette (siehe app_colors.dart).
    final bg = isDark ? const Color(0xFF0E0C0A) : const Color(0xFFF6F3EE);
    final card = isDark ? const Color(0xFF1A1714) : Colors.white;
    final fg = isDark ? const Color(0xFFF5F1EA) : const Color(0xFF15110C);
    final appBarBg = isDark ? const Color(0xFF0E0C0A) : const Color(0xFFF6F3EE);

    // Headlines in Plus Jakarta Sans, Fließtext in Inter.
    const display = 'PlusJakartaSans';
    final base = ThemeData(brightness: brightness);
    final textTheme = base.textTheme
        .apply(
          fontFamily: 'Inter',
          bodyColor: fg,
          displayColor: fg,
        )
        .copyWith(
          displayLarge: TextStyle(
              fontFamily: display,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: fg),
          displayMedium: TextStyle(
              fontFamily: display,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: fg),
          displaySmall: TextStyle(
              fontFamily: display,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: fg),
          headlineLarge: TextStyle(
              fontFamily: display,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: fg),
          headlineMedium: TextStyle(
              fontFamily: display,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: fg),
          headlineSmall: TextStyle(
              fontFamily: display,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: fg),
          titleLarge: TextStyle(
              fontFamily: display,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: fg),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Inter',
      textTheme: textTheme,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF8A00),
        primary: const Color(0xFFFF8A00),
        brightness: brightness,
        surface: card,
      ),
      cardColor: card,
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBg,
        surfaceTintColor: Colors.transparent,
        foregroundColor: fg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: display,
          color: fg,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(color: fg),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BiometricLockOverlay — sichtbar wenn `biometricLockProvider` true ist.
// Spiegelt Swifts `.overlay { if isAppLocked { BiometricLockView } }`:
// liegt über der gesamten App, schluckt Touches, der User kann erst nach
// erfolgreicher Auth (oder Force-Unlock via Settings-Toggle) wieder
// interagieren.
// ---------------------------------------------------------------------------

/// Windows/macOS: auf sehr breiten Fenstern (Ultrawide/4K maximiert) die ganze
/// App auf [LargeScreen.maxAppWidth] zentrieren. Die MediaQuery-Größe wird
/// mit verkleinert, damit Layout-Weichen (Spalten, Hero-Höhe) und Sheets
/// mit der tatsächlich sichtbaren Breite rechnen. Mobil: unverändert.
class _LargeScreenFrame extends StatelessWidget {
  final Widget child;
  const _LargeScreenFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    if (!LargeScreen.isWide(context)) return child;
    final mq = MediaQuery.of(context);
    if (mq.size.width <= LargeScreen.maxAppWidth) return child;
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        // Volle Höhe erzwingen: Center reicht nur lockere Constraints weiter,
        // sonst schrumpft der App-Stack (nur ein 0×0-Kind) auf Höhe 0 und das
        // Fenster bleibt leer.
        child: SizedBox(
          width: LargeScreen.maxAppWidth,
          height: mq.size.height,
          child: MediaQuery(
            data: mq.copyWith(
                size: Size(LargeScreen.maxAppWidth, mq.size.height)),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _BiometricLockOverlay extends ConsumerWidget {
  const _BiometricLockOverlay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLocked = ref.watch(biometricLockProvider);
    if (!isLocked) return const SizedBox.shrink();
    return const Positioned.fill(child: BiometricLockScreen());
  }
}
