import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../leftovers/providers/leftover_finder_provider.dart'
    show FinderItem;
import '../../leftovers/screens/leftover_finder_screen.dart'
    show recipeFinderFoodRoute;
import '../../../core/utils/mealie_version.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart' show currentUserProvider;
import '../../../core/models/cookbook_summary.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/models/shopping_item.dart';
import '../../../core/utils/search_match.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/apple_icon.dart';
import '../../cookbooks/providers/cookbooks_provider.dart';
import '../../foods_units/providers/foods_units_admin_provider.dart';
import '../../../core/models/organizer_item.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../cooking_mode/providers/cooking_session_provider.dart';
import '../../mealplan/screens/add_meal_entry_screen.dart'
    show AddMealEntryScreen;
import '../../home/screens/home_screen.dart'
    show searchableHomeTiles, tileAllowed;
import '../../organizers/providers/organizers_provider.dart';
import '../../users/providers/users_provider.dart';
import '../../users/screens/household_management_screen.dart'
    show adminHouseholdsProvider;
import '../../recipe_match/screens/recipe_match_screen.dart'
    show RecipeMatchThumb;
import '../../recipes/providers/recipes_provider.dart';
import '../../shopping_list/providers/shopping_list_provider.dart';

// ---------------------------------------------------------------------------
// Globale Suche (Suchfeld auf dem Startbildschirm). Findet Inhalte UND
// Funktionen der App: „Liste" → Kachel Einkaufsliste, Kachel Einkaufslisten,
// Einstellung Einkaufsliste … Alles aus den lokalen Caches → offline nutzbar.
// Treffer = jedes Suchwort kommt vor (Groß/Klein, Akzente egal).
//
// [palette] (Windows/macOS, Strg/⌘ + K bzw. F): schwebendes Fenster über der
// App, ↑/↓ wählt, Enter führt aus, Esc/Klick daneben schließt. Vor jeder
// Aktion schließt sich die Palette; navigiert wird dann über den Kontext des
// Root-Navigators (der eigene Kontext ist nach dem Schließen weg).
// ---------------------------------------------------------------------------

/// Ein Treffer in „Funktionen" bzw. „Einstellungen".
class _NavHit {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  const _NavHit(this.icon, this.title, this.subtitle, this.onTap);
}

class _MoveIntent extends Intent {
  final int delta;
  const _MoveIntent(this.delta);
}

class GlobalSearchScreen extends ConsumerStatefulWidget {
  /// Als Befehlspalette (Desktop) statt als ganze Seite.
  final bool palette;
  const GlobalSearchScreen({super.key, this.palette = false});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';

  // Tastatur-Auswahl (Palette): Index in der Trefferliste dieses builds.
  int _sel = 0;
  final List<GlobalKey> _rowKeys = [];
  List<VoidCallback> _entries = const [];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  bool _matches(List<String> terms, Iterable<String?> texts) {
    final hay = normalizeForSearch(texts.whereType<String>().join(' '));
    return terms.every(hay.contains);
  }

  static String _clean(String s) => s.replaceFirst(RegExp(r'^\S+\s+'), '');

  /// Kontext für Navigation aus einer Aktion: in der Palette der des
  /// Root-Navigators (bleibt nach dem Schließen gültig), sonst der eigene.
  BuildContext get _navCtx => widget.palette
      ? GoRouter.of(context).routerDelegate.navigatorKey.currentContext!
      : context;

  /// Aktion ausführen — in der Palette vorher schließen.
  VoidCallback _run(VoidCallback action) => () {
        if (widget.palette) Navigator.of(context).pop();
        action();
      };

  void _move(int delta) {
    if (_entries.isEmpty) return;
    setState(() => _sel = (_sel + delta).clamp(0, _entries.length - 1));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _sel < _rowKeys.length ? _rowKeys[_sel].currentContext : null;
      if (ctx != null) {
        Scrollable.ensureVisible(ctx,
            alignment: 0.5, duration: const Duration(milliseconds: 120));
      }
    });
  }

  // Kacheln — zusätzliche Suchwörter, wo der Kachelname allein nicht reicht
  // (die Einkaufslisten-Kachel heißt wie die aktive Liste, z. B. „Liste 1").
  List<_NavHit> _functions(
      AppLocalizations l, List<String> terms, BuildContext nav) {
    final extra = <String, List<String>>{
      'shopping': [l.shoppingList],
      'mealplan': [l.mealplanTitle],
      'leftovers': [l.leftoverFinder],
    };
    return [
      for (final t in searchableHomeTiles(nav, ref))
        if (_matches(terms, [t.label, ...?extra[t.key]]))
          _NavHit(t.icon, t.label, null, _run(t.onTap)),
    ];
  }

  // Einstellungen: Abschnitt + die einzelnen Einstellungen darin. Ein Tipp
  // springt in den Abschnitt (siehe SettingsScreen._handleSectionJump).
  List<_NavHit> _settings(
      AppLocalizations l, List<String> terms, BuildContext nav) {
    VoidCallback open(String section) => _run(() => nav.go(
        '/settings?section=$section&t=${DateTime.now().millisecondsSinceEpoch}'));
    final sections = <(String, IconData, String, List<String>)>[
      (
        'connection',
        Icons.dns_rounded,
        l.connectionSection,
        [
          l.serverUrl,
          l.wifiServerTitle,
          l.token,
          l.householdId,
          l.renewApiToken
        ]
      ),
      (
        'shopping',
        Icons.format_list_bulleted_rounded,
        _clean(l.shoppingList),
        [l.exactQuantities, l.remindToShop]
      ),
      (
        'advanced',
        Icons.tune_rounded,
        l.advancedOptions,
        [l.mealieApiVersion, l.offlineRecipeImages, l.sendOptionalHeaders]
      ),
      (
        'personalization',
        Icons.palette_rounded,
        l.personalization,
        [l.language, l.showRecipeImages]
      ),
      ('security', Icons.lock_rounded, l.securitySettings, [l.biometricLock]),
      (
        'developer',
        Icons.code_rounded,
        l.developer,
        [l.enableLogging, l.supportContact]
      ),
    ];
    final hits = <_NavHit>[];
    for (final (key, icon, title, items) in sections) {
      if (_matches(terms, [title])) {
        hits.add(_NavHit(icon, title, l.settingsTitle, open(key)));
      }
      for (final item in items) {
        if (_matches(terms, [item])) {
          hits.add(
              _NavHit(icon, item, '${l.settingsTitle} · $title', open(key)));
        }
      }
    }
    return hits;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final terms = searchTerms(_query);
    final nav = _navCtx;

    // Jede Trefferzeile meldet sich hier an (Reihenfolge = Anzeige), damit
    // ↑/↓/Enter in der Palette funktionieren.
    final entries = <VoidCallback>[];
    Widget sel(Widget row, VoidCallback onTap) {
      final i = entries.length;
      entries.add(onTap);
      while (_rowKeys.length <= i) {
        _rowKeys.add(GlobalKey());
      }
      final on = widget.palette && i == _sel;
      return Container(
        key: _rowKeys[i],
        color: on ? AppTokens.accent.withValues(alpha: 0.14) : null,
        child: row,
      );
    }

    final children = <Widget>[];
    if (terms.isEmpty) {
      children.add(Padding(
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
        child: Column(children: [
          Icon(Icons.search_rounded, size: 52, color: context.appFgTertiary),
          const SizedBox(height: 12),
          Text(l.globalSearchIntro,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: context.appFgSub, fontSize: 15, height: 1.45)),
        ]),
      ));
    } else {
      final functions = _functions(l, terms, nav);
      final settings = _settings(l, terms, nav);
      // Name, Schlagworte, Kategorien UND Zutaten — Namenstreffer zuerst.
      final recipes = searchRecipesTiered(
          ref.watch(recipesProvider).valueOrNull ?? const <RecipeDetail>[],
          terms);
      final items = [
        for (final i in ref.watch(shoppingListProvider).valueOrNull ??
            const <ShoppingItem>[])
          if (_matches(terms, [i.displayName, i.note])) i,
      ];
      // Verwaltungs-Listen — nur, wenn der Nutzer die zugehörige Kachel
      // sehen darf (Mealie-Rechte, siehe tileAllowed). Ein Tipp springt in
      // die Liste und markiert den Eintrag (?highlight=<id>).
      final perms = ref.watch(userPermissionsProvider);
      final v330 = ref.watch(mealie330Provider);
      bool allowed(String key) => tileAllowed(key, perms, mealie330: v330);
      List<OrganizerItem> orgs(OrganizerKind k) => rankBySearch([
            for (final o in ref.watch(organizersProvider(k)).valueOrNull ??
                const <OrganizerItem>[])
              if (_matches(terms, [o.name])) o,
          ], terms, (o) => o.name);
      List<Map<String, dynamic>> foodUnits(FoodUnitKind k) => rankBySearch([
            for (final m in ref.watch(foodsUnitsAdminProvider(k)).valueOrNull ??
                const <Map<String, dynamic>>[])
              if (_matches(terms, [
                m['name'] as String?,
                m['pluralName'] as String?,
                m['abbreviation'] as String?,
              ]))
                m,
          ], terms, (m) => m['name'] as String? ?? '');
      final foods = allowed('foods')
          ? foodUnits(FoodUnitKind.food)
          : const <Map<String, dynamic>>[];
      final units = allowed('units')
          ? foodUnits(FoodUnitKind.unit)
          : const <Map<String, dynamic>>[];
      final tools =
          allowed('tools') ? orgs(OrganizerKind.tool) : const <OrganizerItem>[];
      final cats = allowed('categories')
          ? orgs(OrganizerKind.category)
          : const <OrganizerItem>[];
      final tags =
          allowed('tags') ? orgs(OrganizerKind.tag) : const <OrganizerItem>[];
      final labels = allowed('labels')
          ? [
              for (final lb in ref.watch(shoppingLabelsProvider).valueOrNull ??
                  const <ShoppingLabel>[])
                if (_matches(terms, [lb.name])) lb,
            ]
          : const <ShoppingLabel>[];
      final users = allowed('users')
          ? [
              for (final u in ref.watch(usersProvider).valueOrNull ??
                  const <Map<String, dynamic>>[])
                if (_matches(terms, [
                  u['fullName'] as String?,
                  u['username'] as String?,
                  u['email'] as String?,
                ]))
                  u,
            ]
          : const <Map<String, dynamic>>[];
      // Haushalte: der eigene (id „own" = Haushalts-Einstellungen) und — für
      // Admins — alle Haushalte der Liste.
      final households = <(String, String)>[];
      if (allowed('households')) {
        final own = ref.watch(currentUserProvider)?['household']?.toString();
        if (own != null && own.isNotEmpty && _matches(terms, [own])) {
          households.add(('own', own));
        }
        if (perms.admin) {
          for (final h in ref.watch(adminHouseholdsProvider).valueOrNull ??
              const <Map<String, dynamic>>[]) {
            final name = h['name']?.toString() ?? '';
            if (name.isNotEmpty && _matches(terms, [name])) {
              households.add((h['id']?.toString() ?? '', name));
            }
          }
        }
      }
      // In die Rezeptliste springen, vorgefiltert (Suche bzw. Organizer).
      String recipesRoute({String q = '', String? key, String? id}) =>
          '/recipes?q=${Uri.encodeQueryComponent(q)}'
          '${key == null ? '' : '&$key=${Uri.encodeQueryComponent(id ?? '')}'}'
          '&t=${DateTime.now().millisecondsSinceEpoch}';
      String jump(String path, String id) =>
          '$path?highlight=${Uri.encodeQueryComponent(id)}'
          '&t=${DateTime.now().millisecondsSinceEpoch}';
      Widget jumpTile(IconData icon, String title, String route,
          {String? subtitle, String? recipesFilter}) {
        final tap = _run(() => nav.push(route));
        return sel(
            ListTile(
              leading: iconOrApple(icon, color: context.appFgSub, size: 22),
              title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
              // Pfeil: alle Rezepte mit diesem Eintrag (Lebensmittel,
              // Schlagwort, …) in der Rezeptliste zeigen.
              trailing: recipesFilter == null
                  ? null
                  : IconButton(
                      tooltip: l.organizerShowRecipes,
                      icon: const Icon(Icons.manage_search_rounded,
                          color: AppTokens.accentDeep),
                      // Rezept-Suche ist eine eigene Seite (push, mit
                      // Zurück), die Rezeptliste ein Tab (go).
                      onPressed: _run(() =>
                          recipesFilter.startsWith('/leftovers')
                              ? nav.push(recipesFilter)
                              : nav.go(recipesFilter)),
                    ),
              subtitle: subtitle == null || subtitle.isEmpty
                  ? null
                  : Text(subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: context.appFgSub, fontSize: 13)),
              onTap: tap,
            ),
            tap);
      }

      Widget navTile(_NavHit h) => sel(_NavTile(hit: h), h.onTap);

      final cookbooks = [
        for (final c in ref.watch(cookbooksProvider).valueOrNull ??
            const <CookbookSummary>[])
          if (_matches(terms, [c.name, c.description])) c,
      ];

      void section(String title, int total, List<Widget> rows) {
        if (rows.isEmpty) return;
        children.add(_SectionHeader(title: title, count: total));
        children.addAll(rows);
      }

      // ── Aktionen: direkt etwas tun statt nur hinspringen ─────────────
      final raw = _query.trim();
      final listId =
          ref.watch(settingsProvider).valueOrNull?.shoppingListId ?? '';
      final isUrl = RegExp(r'^https?://', caseSensitive: false).hasMatch(raw);
      section(
          l.globalSearchActions, (isUrl ? 1 : 0) + (listId.isEmpty ? 0 : 1), [
        if (isUrl)
          navTile(_NavHit(
              Icons.download_rounded,
              l.globalSearchImportUrl,
              raw,
              _run(() =>
                  nav.push('/import?url=${Uri.encodeQueryComponent(raw)}')))),
        if (listId.isNotEmpty && !isUrl)
          navTile(_NavHit(
              Icons.add_shopping_cart_rounded,
              l.globalSearchAddToList(raw),
              _clean(l.shoppingList), _run(() async {
            final messenger = ScaffoldMessenger.of(nav);
            await ref.read(shoppingListProvider.notifier).addItem(note: raw);
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(l.globalSearchAdded(raw)),
                persist: false,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                    label: _clean(l.shoppingList),
                    onPressed: () => nav.go('/shopping')),
              ));
          }))),
      ]);
      section(l.globalSearchFunctions, functions.length, [
        for (final h in functions) navTile(h),
      ]);
      section(l.settingsTitle, settings.length, [
        for (final h in settings) navTile(h),
      ]);
      section(l.recipes, recipes.length, [
        for (final r in recipes.take(10))
          () {
            final open = _run(() => nav.push('/recipes/${r.id}'));
            return sel(
                ListTile(
                  leading: RecipeMatchThumb(recipe: r, size: 40),
                  title: Text(r.name,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  onTap: open,
                  contentPadding: const EdgeInsets.only(left: 16, right: 4),
                  // Kurzaktionen: direkt kochen oder einplanen.
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      tooltip: l.startCooking,
                      icon: const Icon(Icons.soup_kitchen_rounded,
                          color: AppTokens.accentDeep),
                      onPressed: _run(() {
                        ref
                            .read(cookingSessionsProvider.notifier)
                            .startSession(r);
                        nav.push('/cooking/${r.id}');
                      }),
                    ),
                    IconButton(
                      tooltip: l.addMealEntry,
                      icon: Icon(Icons.event_rounded, color: context.appFgSub),
                      onPressed: _run(() =>
                          Navigator.of(nav, rootNavigator: true)
                              .push(MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => AddMealEntryScreen(
                                defaultRecipeId: r.id,
                                defaultRecipeName: r.name),
                          ))),
                    ),
                  ]),
                ),
                open);
          }(),
        if (recipes.length > 10)
          () {
            final all = _run(() => nav.go(recipesRoute(q: raw)));
            return sel(
                ListTile(
                  leading: const Icon(Icons.list_rounded,
                      color: AppTokens.accentDeep),
                  title: Text(l.globalSearchShowAllRecipes(recipes.length),
                      style: const TextStyle(
                          color: AppTokens.accentDeep,
                          fontWeight: FontWeight.w700)),
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: AppTokens.accentDeep),
                  onTap: all,
                ),
                all);
          }(),
      ]);
      section(_clean(l.shoppingList), items.length, [
        for (final i in items.take(8))
          () {
            final open = _run(() => nav.go('/shopping'));
            return sel(
                ListTile(
                  leading: Icon(
                      i.checked
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: i.checked
                          ? const Color(0xFF2E9E57)
                          : context.appFgSub),
                  title: Text(i.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: i.checked
                              ? context.appFgTertiary
                              : context.appFg)),
                  onTap: open,
                ),
                open);
          }(),
      ]);
      section(l.foodsTitle, foods.length, [
        for (final f in foods.take(6))
          jumpTile(kAppleIcon, (f['name'] as String?) ?? '',
              jump('/data/foods', f['id'] as String? ?? ''),
              // Zutat → Kachel „Rezept-Suche“ (nicht die Rezeptliste, deren
              // Filter man sonst jedes Mal wieder entfernen müsste).
              recipesFilter: recipeFinderFoodRoute(f['id'] as String? ?? '',
                  FinderItem.food(f)?.name ?? (f['name'] as String? ?? ''))),
      ]);
      section(l.unitsTitle, units.length, [
        for (final u in units.take(6))
          jumpTile(kMeasuringCupIcon, (u['name'] as String?) ?? '',
              jump('/data/units', u['id'] as String? ?? ''),
              subtitle: u['abbreviation'] as String?),
      ]);
      section(l.toolsTitle, tools.length, [
        for (final t in tools.take(6))
          jumpTile(
              Icons.kitchen_rounded, t.name, jump('/organizers/tools', t.id),
              recipesFilter: recipesRoute(key: 'tool', id: t.id)),
      ]);
      section(l.categories, cats.length, [
        for (final c in cats.take(6))
          jumpTile(Icons.category_rounded, c.name,
              jump('/organizers/categories', c.id),
              recipesFilter: recipesRoute(key: 'category', id: c.id)),
      ]);
      section(l.tags, tags.length, [
        for (final t in tags.take(6))
          jumpTile(Icons.sell_rounded, t.name, jump('/organizers/tags', t.id),
              recipesFilter: recipesRoute(key: 'tag', id: t.id)),
      ]);
      section(l.labelsTitle, labels.length, [
        for (final lb in labels.take(6))
          jumpTile(Icons.label_rounded, lb.name, jump('/data/labels', lb.id)),
      ]);
      section(l.cookbooks, cookbooks.length, [
        for (final c in cookbooks.take(6))
          () {
            final open = _run(() => nav.push('/cookbooks/${c.id}'));
            return sel(
                ListTile(
                  leading:
                      Icon(Icons.menu_book_rounded, color: context.appFgSub),
                  title: Text(c.name),
                  onTap: open,
                ),
                open);
          }(),
      ]);

      section(l.userManagementTitle, users.length, [
        for (final u in users.take(6))
          jumpTile(
              Icons.person_rounded,
              (u['fullName'] as String?)?.trim().isNotEmpty == true
                  ? u['fullName'] as String
                  : (u['username'] as String?) ?? '',
              jump('/users', u['id']?.toString() ?? ''),
              subtitle: u['email'] as String?),
      ]);
      section(l.householdManagementTitle, households.length, [
        for (final (id, name) in households.take(6))
          jumpTile(Icons.house_rounded, name, jump('/households', id),
              subtitle: id == 'own' ? l.myHouseholdSection : null),
      ]);

      if (children.isEmpty) {
        children.add(Padding(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          child: Text(l.globalSearchNoResults(_query.trim()),
              textAlign: TextAlign.center,
              style: TextStyle(color: context.appFgSub, fontSize: 15)),
        ));
      }
    }
    _entries = entries;
    if (_sel >= entries.length) _sel = entries.isEmpty ? 0 : entries.length - 1;

    final field = Shortcuts(
      // Vor die Standard-Textkürzel: ↑/↓ wählen in der Palette einen Treffer
      // statt den Cursor zu bewegen.
      shortcuts: widget.palette
          ? const {
              SingleActivator(LogicalKeyboardKey.arrowDown): _MoveIntent(1),
              SingleActivator(LogicalKeyboardKey.arrowUp): _MoveIntent(-1),
            }
          : const <ShortcutActivator, Intent>{},
      child: Actions(
        actions: {
          _MoveIntent:
              CallbackAction<_MoveIntent>(onInvoke: (i) => _move(i.delta)),
        },
        child: TextField(
          controller: _ctrl,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: (v) => setState(() {
            _query = v;
            _sel = 0;
          }),
          onSubmitted: widget.palette
              ? (_) {
                  if (_entries.isNotEmpty) _entries[_sel]();
                }
              : null,
          style: TextStyle(color: context.appFg, fontSize: 16),
          decoration: InputDecoration(
            hintText: l.globalSearchHint,
            prefixIcon: Icon(Icons.search_rounded, color: context.appFgSub),
            suffixIcon: _query.isEmpty
                ? null
                : IconButton(
                    tooltip: l.searchClear,
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      _ctrl.clear();
                      setState(() {
                        _query = '';
                        _sel = 0;
                      });
                    },
                  ),
            filled: true,
            fillColor: context.appSurface2,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTokens.rSm),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
    final list = ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(bottom: 16),
      shrinkWrap: widget.palette,
      children: children,
    );

    if (widget.palette) {
      // Schwebende Befehlspalette: oben mittig, höchstens 680 breit. Leere
      // Flächen lassen Klicks zur Barriere durch (schließt die Palette).
      final size = MediaQuery.sizeOf(context);
      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: size.height * 0.12),
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: 680, maxHeight: size.height * 0.7),
            child: Material(
              color: context.appCard,
              elevation: 16,
              borderRadius: BorderRadius.circular(AppTokens.rLg),
              clipBehavior: Clip.antiAlias,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(padding: const EdgeInsets.all(12), child: field),
                Divider(height: 1, color: context.appSeparator),
                Flexible(child: list),
              ]),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(padding: const EdgeInsets.only(right: 12), child: field),
      ),
      body: list,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
        child: Text('${title.toUpperCase()} · $count',
            style: TextStyle(
                color: context.appFgSub,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6)),
      );
}

class _NavTile extends StatelessWidget {
  final _NavHit hit;
  const _NavTile({required this.hit});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTokens.rSm),
            color: AppTokens.accent.withValues(alpha: 0.16),
          ),
          child: iconOrApple(hit.icon, color: AppTokens.accentDeep, size: 21),
        ),
        title: Text(hit.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: hit.subtitle == null
            ? null
            : Text(hit.subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: context.appFgSub, fontSize: 13)),
        trailing:
            Icon(Icons.chevron_right_rounded, color: context.appFgTertiary),
        onTap: hit.onTap,
      );
}
