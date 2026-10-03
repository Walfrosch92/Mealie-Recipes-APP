import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import '../../settings/services/shopping_reminder_location_service.dart';
import '../../timer/services/notification_service.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/app_settings.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/models/mealplan_entry.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/utils/platform_features.dart';
import '../../../features/cooking_mode/widgets/cooking_mode_fab.dart';
import '../../../features/mealplan/providers/mealplan_provider.dart';
import '../../../features/recipe_send/services/recipe_send_service.dart';
import '../../../features/recipes/providers/recipes_provider.dart';
import '../../../features/shopping_list/providers/shopping_list_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/apple_icon.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/liquid_glass.dart';
import '../../../shared/widgets/recipe_image.dart';
import '../../shopping_list/providers/shopping_lists_provider.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../whats_new/whats_new.dart';
import '../../webapp_tools/screens/update_screen.dart';
import '../../webapp_tools/services/app_updater.dart';

/// Ein „Heute kochen"-Eintrag: das Rezept + ein Pillen-Label (geplante
/// Mahlzeit-Art bzw. „Vorschlag").
class _Featured {
  final RecipeDetail recipe;
  final String label;
  const _Featured(this.recipe, this.label);
}

/// Entfernt ein führendes Emoji/Symbol (+ Leerzeichen) aus Labels wie
/// "🥗 Resteverwertung" → "Resteverwertung". Die Quell-Strings behalten ihr
/// Emoji (andere Screens nutzen sie so); im Premium-Home zeigen wir echte
/// Icons, daher hier ohne Emoji.
String _clean(String s) =>
    s.replaceFirst(RegExp(r'^[^\p{L}\p{N}]+', unicode: true), '').trim();

TextStyle _greetStyle(BuildContext context) => TextStyle(
      fontFamily: 'PlusJakartaSans',
      color: context.appFg,
      fontSize: 26,
      height: 1.14,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
    );

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final recipesAsync = ref.watch(recipesProvider);
    final shoppingAsync = ref.watch(shoppingListProvider);
    final user = ref.watch(currentUserProvider);
    final settings = ref.watch(settingsProvider).valueOrNull;
    // Eager-Start des SendTo-mDNS-Stacks (siehe alter Kommentar): aktiv halten.
    ref.watch(recipeSendProvider);

    final recipes = recipesAsync.valueOrNull ?? const <RecipeDetail>[];
    final recipeCount = recipesAsync.valueOrNull?.length;
    final shoppingCount =
        shoppingAsync.valueOrNull?.where((i) => !i.checked).length;

    final name = (user?['fullName'] as String?)?.trim().isNotEmpty == true
        ? (user!['fullName'] as String).trim()
        : (user?['username'] as String?)?.trim() ?? '';
    final welcome = name.isEmpty ? l.homeWelcome : l.homeWelcomeNamed(name);

    // „Heute kochen": die heute laut Mealplan geplanten Rezepte; ist nichts
    // geplant, ein deterministisches „Rezept des Tages".
    final mealplan = ref.watch(mealplanProvider).valueOrNull ?? const {};
    final todaysEntries = mealplan[startOfDay(DateTime.now())] ?? const [];
    final featured = _buildFeatured(recipes, todaysEntries, l);

    return Scaffold(
      backgroundColor: context.appBg,
      extendBody: true,
      // GlassTabBar liegt jetzt fix in der _TabShell (app.dart) — so bleibt
      // sie von Seiten-Übergängen unberührt. Die Padding-Konvention
      // (GlassTabBar.height + …) bleibt unverändert gültig.
      body: WithCookingModeFAB(
        bottomInset: GlassTabBar.height + 24,
        child: SafeArea(
          bottom: false,
          child: ListView(
            // SafeArea hier ist bottom:false → der System-Inset (Gesten-Pille /
            // 3-Button-Leiste) wird NICHT konsumiert und muss additiv ins
            // Bottom-Padding, sonst verdeckt die schwebende GlassTabBar auf
            // Geräten mit fester Buttonleiste das Listen-Ende.
            padding: EdgeInsets.fromLTRB(18, 8, 18,
                GlassTabBar.height + 44 + MediaQuery.paddingOf(context).bottom),
            children: [
              // „Was ist neu" einmal pro Start, solange für diesen Build
              // nicht abbestellt (unsichtbar, löst nur den Dialog aus).
              const _WhatsNewTrigger(),
              // Desktop: wartendes Update installieren / automatisch prüfen.
              if (PlatformFeatures.webAppTools) const DesktopUpdateTrigger(),
              const _ShoppingReminderHealthCheck(),
              // ── Begrüßung (oben mittig, zweizeilig) ───────────────────
              FadeSlideIn(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: name.isEmpty
                        ? Text(
                            welcome,
                            textAlign: TextAlign.center,
                            style: _greetStyle(context),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                l.homeWelcomeName(name),
                                textAlign: TextAlign.center,
                                style: _greetStyle(context),
                              ),
                              Text(
                                l.homeWelcomeApp,
                                textAlign: TextAlign.center,
                                style: _greetStyle(context),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // ── Heute kochen (Hero-Karussell) ─────────────────────────
              if (featured.isNotEmpty) ...[
                _SectionHeader(title: l.homeCookToday),
                const SizedBox(height: 10),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 60),
                  child: _HeroCarousel(
                    items: featured,
                    baseUrl: settings?.serverUrl ?? '',
                    token: settings?.apiToken ?? '',
                    onOpen: (r) => context.push('/recipes/${r.id}'),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ── Schnellzugriff (per Drag umsortierbar, persistent) ───
              _SectionHeader(title: l.homeQuickAccess),
              const SizedBox(height: 10),
              _buildQuickAccess(
                context,
                ref,
                l,
                settings,
                recipeCount: recipeCount,
                shoppingCount: shoppingCount,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccess(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
    AppSettings? settings, {
    int? recipeCount,
    int? shoppingCount,
  }) {
    // Angepinnte Kacheln aus dem Gesamt-Katalog + immer „Weiteres".
    final perms = ref.watch(userPermissionsProvider);
    final homeKeys =
        effectiveHomeTiles(settings, allowed: (k) => tileAllowed(k, perms));
    final catalog = _allTiles(context, l,
        perms: perms,
        updateCount: _pendingUpdates(ref),
        recipeCount: recipeCount,
        shoppingCount: shoppingCount,
        // Kachel heißt wie die aktive Liste („Liste 1").
        shoppingTitle: ref.watch(activeShoppingListNameProvider));
    final items = <_QuickItem>[
      for (final k in homeKeys) ...catalog.where((q) => q.key == k),
      // Update-Kachel nicht angepinnt → Hinweis-„1" auf „Weiteres".
      _moreTile(context, l,
          count: homeKeys.contains('updates') ? null : _pendingUpdates(ref)),
    ];

    // Alle Kacheln sind gleich groß und frei umsortierbar.
    // Nach gespeicherter Reihenfolge sortieren; neue Keys hinten anhängen.
    final byKey = {for (final q in items) q.key: q};
    final ordered = <_QuickItem>[];
    for (final k in settings?.quickAccessOrder ?? const <String>[]) {
      final it = byKey.remove(k);
      if (it != null) ordered.add(it);
    }
    ordered.addAll(items.where((q) => byKey.containsKey(q.key)));

    void reorder(int from, int to) {
      if (from == to) return;
      HapticFeedback.mediumImpact();
      final keys = ordered.map((e) => e.key).toList();
      final moved = keys.removeAt(from);
      keys.insert(to, moved);
      final s = settings ?? const AppSettings();
      ref
          .read(settingsProvider.notifier)
          .save(s.copyWith(quickAccessOrder: keys));
    }

    // Grid aus gleich großen Kacheln (per Long-Press umsortierbar) —
    // 2 Spalten, auf großer Anzeige (Windows/macOS) 3–4.
    return _tileGrid(
      LargeScreen.tileColumns(context),
      ordered.length,
      (i) => _DraggableTile(index: i, item: ordered[i], onReorder: reorder),
    );
  }

  /// Baut die „Heute kochen"-Liste: heute geplante Rezepte (in Mahlzeiten-
  /// Reihenfolge), aufgelöst auf das volle RecipeDetail aus [recipes]. Ist
  /// nichts geplant (oder nichts auflösbar), genau ein deterministisches
  /// „Rezept des Tages".
  List<_Featured> _buildFeatured(
    List<RecipeDetail> recipes,
    List<MealplanEntry> todaysEntries,
    AppLocalizations l,
  ) {
    if (recipes.isEmpty) return const [];
    final byId = {for (final r in recipes) r.id: r};

    // Mahlzeiten-Reihenfolge für ein sinnvolles Durchrotieren.
    int order(String t) => switch (t.toLowerCase()) {
          'breakfast' => 0,
          'lunch' => 1,
          'dinner' => 2,
          'side' => 3,
          _ => 4,
        };
    final planned = todaysEntries
        .where((e) => (e.recipe?.id ?? '').isNotEmpty)
        .toList()
      ..sort((a, b) => order(a.entryType).compareTo(order(b.entryType)));

    final result = <_Featured>[];
    final seen = <String>{};
    for (final e in planned) {
      final rd = byId[e.recipe!.id];
      if (rd == null || !seen.add(rd.id)) continue;
      result.add(_Featured(rd, _slotLabel(e.entryType, l)));
    }
    if (result.isNotEmpty) return result;

    // Nichts geplant → Rezept des Tages (stabil pro Kalendertag).
    // Deterministisch über einen Hash aus Tag + Rezept-ID statt als Index
    // in die Liste (`daySeed % length`): der Index sprang auf ein anderes
    // Rezept, sobald sich Reihenfolge oder Länge der Liste änderte —
    // z. B. während des inkrementellen Ladens direkt nach dem App-Start.
    // So gewinnt unabhängig davon immer dasselbe Rezept des Tages.
    final now = DateTime.now();
    final daySeed = now.year * 1000 + _dayOfYear(now);
    var pick = recipes.first;
    var best = 0x7FFFFFFF;
    for (final r in recipes) {
      final h = _fnv1a('$daySeed:${r.id}');
      if (h < best || (h == best && r.id.compareTo(pick.id) < 0)) {
        best = h;
        pick = r;
      }
    }
    return [_Featured(pick, l.homeSuggestion)];
  }

  // FNV-1a (32 Bit) — bewusst selbst implementiert statt hashCode/Object.hash,
  // damit der Tagesvorschlag auch über App-Neustarts hinweg identisch bleibt
  // (Dart-hashCodes sind nicht über Läufe hinweg garantiert stabil).
  int _fnv1a(String s) {
    var h = 0x811C9DC5;
    for (final c in s.codeUnits) {
      h ^= c;
      h = (h * 0x01000193) & 0x7FFFFFFF;
    }
    return h;
  }

  String _slotLabel(String entryType, AppLocalizations l) {
    switch (entryType.toLowerCase()) {
      case 'breakfast':
        return l.breakfast;
      case 'lunch':
        return l.lunch;
      case 'dinner':
        return l.dinner;
      default:
        return l.homePlanned;
    }
  }

  int _dayOfYear(DateTime d) => d.difference(DateTime(d.year, 1, 1)).inDays;
}

// ---------------------------------------------------------------------------
// Hero-Karussell — rotiert durch die heute geplanten Rezepte (auto + Swipe)
// ---------------------------------------------------------------------------

class _HeroCarousel extends StatefulWidget {
  final List<_Featured> items;
  final String baseUrl;
  final String token;
  final void Function(RecipeDetail) onOpen;

  const _HeroCarousel({
    required this.items,
    required this.baseUrl,
    required this.token,
    required this.onOpen,
  });

  @override
  State<_HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<_HeroCarousel> {
  final _controller = PageController();
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAuto();
  }

  @override
  void didUpdateWidget(_HeroCarousel old) {
    super.didUpdateWidget(old);
    if (widget.items.length != old.items.length) {
      if (_index >= widget.items.length) _index = 0;
      _startAuto();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // Auto-Rotation alle 6 s (nur bei mehreren Rezepten). Wird nach jedem
  // Seitenwechsel — auch manuellem Swipe — neu armiert.
  void _startAuto() {
    _timer?.cancel();
    if (widget.items.length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted || !_controller.hasClients) return;
      final next = (_index + 1) % widget.items.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: LargeScreen.heroHeight(context, 196),
          child: PageView.builder(
            controller: _controller,
            itemCount: items.length,
            onPageChanged: (i) {
              setState(() => _index = i);
              _startAuto();
            },
            itemBuilder: (_, i) {
              final f = items[i];
              return _HeroCard(
                recipe: f.recipe,
                label: f.label,
                baseUrl: widget.baseUrl,
                token: widget.token,
                onTap: () => widget.onOpen(f.recipe),
              );
            },
          ),
        ),
        if (items.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(items.length, (i) {
              final active = i == _index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 20 : 7,
                height: 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: active ? AppTokens.accentGradient : null,
                  color: active ? null : context.appSeparator,
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Hero („Heute kochen") — großes Foto + Scrim + Titel/Meta drauf
// ---------------------------------------------------------------------------

class _HeroCard extends StatelessWidget {
  final RecipeDetail recipe;
  final String label;
  final String baseUrl;
  final String token;
  final VoidCallback onTap;

  const _HeroCard({
    required this.recipe,
    required this.label,
    required this.baseUrl,
    required this.token,
    required this.onTap,
  });

  String get _imageUrl =>
      '$baseUrl/api/media/recipes/${recipe.id}/images/original.webp';

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      onTap: onTap,
      scale: 0.97,
      child: Container(
        height: LargeScreen.heroHeight(context, 196),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTokens.rLg),
          boxShadow: context.appShadowMd,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTokens.rLg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: 'recipe-image-${recipe.id}',
                child: RecipeImage(
                  recipeId: recipe.id,
                  imageUrl: _imageUrl,
                  httpHeaders: {'Authorization': 'Bearer $token'},
                  placeholder: (_) => _gradPlaceholder(),
                ),
              ),
              // Scrim unten für Lesbarkeit
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00000000),
                      Color(0x00000000),
                      Color(0xB8000000),
                    ],
                    stops: [0.0, 0.42, 1.0],
                  ),
                ),
              ),
              // Label-Pille (Glas)
              Positioned(
                top: 14,
                left: 14,
                child: LiquidGlass(
                  borderRadius: BorderRadius.circular(999),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: context.isDark ? Colors.white : context.appFg,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              // „Kochen"-Knopf
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTokens.accentGradient,
                    boxShadow: context.appAccentGlow,
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 24),
                ),
              ),
              // Titel + Meta
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      recipe.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: Colors.white,
                        fontSize: LargeScreen.isWide(context) ? 28 : 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        shadows: const [
                          Shadow(color: Color(0x66000000), blurRadius: 8)
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    _HeroMeta(recipe: recipe),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gradPlaceholder() => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8B06A), Color(0xFFC2693A)],
          ),
        ),
        child: const Center(
          child:
              Icon(Icons.restaurant_rounded, color: Colors.white54, size: 44),
        ),
      );
}

class _HeroMeta extends StatelessWidget {
  final RecipeDetail recipe;
  const _HeroMeta({required this.recipe});

  String _fmt(int min) {
    if (min < 60) return '$min min';
    final h = min ~/ 60;
    final m = min % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    final t = recipe.totalTime ?? recipe.prepTime ?? recipe.cookTime;
    if ((t ?? 0) > 0) {
      items.add(_item(Icons.schedule_rounded, _fmt(t!)));
    }
    if ((recipe.recipeYield ?? '').trim().isNotEmpty) {
      items.add(_item(Icons.restaurant_rounded, recipe.recipeYield!.trim()));
    }
    if ((recipe.rating ?? 0) > 0) {
      items.add(_item(Icons.star_rounded, recipe.rating!.toStringAsFixed(1)));
    }
    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 16, runSpacing: 4, children: items);
  }

  Widget _item(IconData icon, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600)),
        ],
      );
}

// ---------------------------------------------------------------------------
// Quick-Access-Kacheln
// ---------------------------------------------------------------------------

enum _TileColor { orange, green, blue, purple }

extension on _TileColor {
  List<Color> get grad {
    switch (this) {
      case _TileColor.orange:
        return const [Color(0xFFFFE2BC), Color(0xFFFFC074)];
      case _TileColor.green:
        return const [Color(0xFFCFEFD6), Color(0xFF94D9A6)];
      case _TileColor.blue:
        return const [Color(0xFFCFE3FF), Color(0xFF8FBDF6)];
      case _TileColor.purple:
        return const [Color(0xFFE8D6FF), Color(0xFFC29CF0)];
    }
  }

  Color get iconColor {
    switch (this) {
      case _TileColor.orange:
        return const Color(0xFF8A4B00);
      case _TileColor.green:
        return const Color(0xFF1E6B38);
      case _TileColor.blue:
        return const Color(0xFF1B4F8F);
      case _TileColor.purple:
        return const Color(0xFF5B2A8F);
    }
  }
}

// ---------------------------------------------------------------------------
// Quick-Access: Item-Beschreibung + umsortierbare Kachel
// ---------------------------------------------------------------------------

class _QuickItem {
  final String key;
  final IconData icon;
  final _TileColor color;
  final String label;
  final int? count;
  final VoidCallback onTap;
  const _QuickItem(
      this.key, this.icon, this.color, this.label, this.count, this.onTap);
}

// Gleich große Grid-Kachel (Original-Design)
class _Tile extends StatelessWidget {
  final IconData icon;
  final _TileColor color;
  final String label;
  final int? count;
  final VoidCallback? onTap;

  const _Tile({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      onTap: onTap,
      child: Container(
        height: 104,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: context.appCard,
          borderRadius: BorderRadius.circular(AppTokens.rMd),
          border: Border.all(color: context.appSeparator, width: 1),
          boxShadow: context.appShadowSm,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: color.grad,
                    ),
                  ),
                  child: iconOrApple(icon, color: color.iconColor, size: 23),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.appFg,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
            if (count != null && count! > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 24),
                  height: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: AppTokens.accentGradient,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x59FF7800),
                          blurRadius: 8,
                          offset: Offset(0, 3))
                    ],
                  ),
                  child: Text('$count',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Grid-Kachel mit Long-Press-Drag zum Umsortieren
class _DraggableTile extends StatelessWidget {
  final int index;
  final _QuickItem item;
  final void Function(int from, int to) onReorder;

  /// Zusätzliches Element oben rechts (Pin in „Weiteres").
  final Widget? overlay;
  const _DraggableTile({
    required this.index,
    required this.item,
    required this.onReorder,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    final tile = _Tile(
      icon: item.icon,
      color: item.color,
      label: item.label,
      count: item.count,
      onTap: item.onTap,
    );

    return DragTarget<int>(
      onWillAcceptWithDetails: (d) => d.data != index,
      onAcceptWithDetails: (d) => onReorder(d.data, index),
      builder: (ctx, candidate, rejected) {
        final hovering = candidate.isNotEmpty;
        return LongPressDraggable<int>(
          data: index,
          onDragStarted: () => HapticFeedback.mediumImpact(),
          feedback: Builder(builder: (c) {
            final cols = LargeScreen.tileColumns(c);
            final w =
                (MediaQuery.sizeOf(c).width - 36 - 12 * (cols - 1)) / cols;
            return Material(
              color: Colors.transparent,
              child: SizedBox(
                width: w,
                child: Transform.scale(scale: 1.04, child: tile),
              ),
            );
          }),
          childWhenDragging: Opacity(opacity: 0.25, child: tile),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTokens.rMd),
              border: Border.all(
                color: hovering ? AppTokens.accent : Colors.transparent,
                width: 2,
              ),
            ),
            // passthrough: die Kachel bekommt die volle Spaltenbreite (ein
            // normaler Stack gibt nur lockere Vorgaben weiter → jede Kachel
            // war nur so breit wie ihr Text). Pin sitzt IN der Kachel.
            child: overlay == null
                ? tile
                : Stack(fit: StackFit.passthrough, children: [
                    tile,
                    Positioned(top: 8, right: 8, child: overlay!),
                  ]),
          ),
        );
      },
    );
  }
}

/// Gleich breite Kachel-Zeilen mit [cols] Spalten (12 pt Abstand); die
/// letzte Zeile wird mit leeren Zellen aufgefüllt.
Widget _tileGrid(int cols, int count, Widget Function(int i) tile) {
  final rows = <Widget>[];
  for (var i = 0; i < count; i += cols) {
    rows.add(Row(
      children: [
        for (var c = 0; c < cols; c++) ...[
          if (c > 0) const SizedBox(width: 12),
          Expanded(
            child: i + c < count ? tile(i + c) : const SizedBox.shrink(),
          ),
        ],
      ],
    ));
    if (i + cols < count) rows.add(const SizedBox(height: 12));
  }
  return Column(children: rows);
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          color: context.appFg,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// „Weiteres" (Home-Kachel) — dieselben Kacheln wie auf dem Startbildschirm,
// gesammelt: Resteverwertung, Kochbücher, Utensilien, Kategorien,
// Schlagworte, Lebensmittel, Einheiten, Listenverwaltung. Jede lässt sich
// per Pin zusätzlich auf den Startbildschirm legen.
// ---------------------------------------------------------------------------

/// Gesamt-Katalog ALLER Kacheln (ohne „Weiteres") in Standard-Reihenfolge.
/// Stabile Keys — sie stehen in `homeTiles`, `quickAccessOrder` und
/// `moreTilesOrder`.
/// Darf der Nutzer diese Kachel sehen? Nur Kacheln, deren Funktion Mealie
/// per Recht schützt, werden ausgeblendet — Benutzerverwaltung (Admin/
/// Verwalten/Einladen) und Kategorien/Schlagworte/Lebensmittel (Recht
/// „Organisieren"). Alles andere prüft Mealie nicht → für alle sichtbar.
bool tileAllowed(String key, UserPermissions p) => switch (key) {
      // Jeder sieht die Benutzerverwaltung — normale Benutzer nur das
      // eigene Konto.
      'users' => p.known,
      'households' =>
        p.known && (p.admin || p.canManageHousehold || p.canManage),
      'categories' || 'tags' || 'foods' => p.mayOrganize,
      // Mealie-Administration (Sicherungen, Wartung, Website) nur für Admins.
      'admin' => p.known && p.admin,
      // KI-Anbieter: Mealie verlangt das Recht „Verwalten" (can_manage).
      'aiproviders' => p.known && p.canManage,
      'debug' => p.known,
      _ => true,
    };

/// Orange „1" auf der Update-Kachel, solange ein neueres Release bereitsteht
/// (Desktop; der Start-Check füllt den Status).
int? _pendingUpdates(WidgetRef ref) {
  if (!PlatformFeatures.webAppTools) return null;
  final status = ref.watch(appUpdateProvider.select((s) => s.status));
  return status == UpdateStatus.available || status == UpdateStatus.ready
      ? 1
      : null;
}

List<_QuickItem> _allTiles(BuildContext context, AppLocalizations l,
        {required UserPermissions perms,
        int? recipeCount,
        int? shoppingCount,
        String? shoppingTitle,
        int? updateCount}) =>
    _allTilesUnfiltered(context, l,
            recipeCount: recipeCount,
            shoppingCount: shoppingCount,
            shoppingTitle: shoppingTitle,
            updateCount: updateCount)
        .where((q) => tileAllowed(q.key, perms))
        .toList();

List<_QuickItem> _allTilesUnfiltered(BuildContext context, AppLocalizations l,
        {int? recipeCount,
        int? shoppingCount,
        String? shoppingTitle,
        int? updateCount}) =>
    <_QuickItem>[
      _QuickItem('recipes', Icons.restaurant_menu_rounded, _TileColor.orange,
          l.recipes, recipeCount, () => context.go('/recipes')),
      _QuickItem(
          'shopping',
          Icons.shopping_cart_rounded,
          _TileColor.green,
          shoppingTitle ?? _clean(l.shoppingList),
          shoppingCount,
          () => context.go('/shopping')),
      _QuickItem('mealplan', Icons.event_rounded, _TileColor.blue,
          _clean(l.essensplan), null, () => context.go('/mealplan')),
      _QuickItem('import', Icons.add_rounded, _TileColor.orange, l.importRecipe,
          null, () => context.push('/import')),
      _QuickItem('cookfriends', Icons.group_add_rounded, _TileColor.blue,
          l.cookFriends, null, () => context.push('/cook-friends')),
      _QuickItem('timeline', Icons.timeline_rounded, _TileColor.blue,
          l.timelineTitle, null, () => context.push('/timeline')),
      _QuickItem('favorites', Icons.favorite_rounded, _TileColor.orange,
          l.favoritesTitle, null, () => context.push('/favorites')),
      _QuickItem('leftovers', Icons.search_rounded, _TileColor.purple,
          _clean(l.resteverwertung), null, () => context.push('/leftovers')),
      _QuickItem('cookbooks', Icons.menu_book_rounded, _TileColor.purple,
          l.cookbooks, null, () => context.push('/cookbooks')),
      _QuickItem('tools', Icons.kitchen_rounded, _TileColor.green, l.toolsTitle,
          null, () => context.push('/organizers/tools')),
      _QuickItem('categories', Icons.category_rounded, _TileColor.purple,
          l.categories, null, () => context.push('/organizers/categories')),
      _QuickItem('tags', Icons.sell_rounded, _TileColor.orange, l.tags, null,
          () => context.push('/organizers/tags')),
      _QuickItem('foods', kAppleIcon, _TileColor.green, l.foodsTitle, null,
          () => context.push('/data/foods')),
      _QuickItem('units', kMeasuringCupIcon, _TileColor.orange, l.unitsTitle,
          null, () => context.push('/data/units')),
      _QuickItem('labels', Icons.label_rounded, _TileColor.purple,
          l.labelsTitle, null, () => context.push('/data/labels')),
      _QuickItem('shoppinglists', Icons.list_alt_rounded, _TileColor.blue,
          l.listManagementTitle, null, () => context.push('/shopping-lists')),
      _QuickItem('users', Icons.manage_accounts_rounded, _TileColor.purple,
          l.userManagementTitle, null, () => context.push('/users')),
      _QuickItem('households', Icons.house_rounded, _TileColor.green,
          l.householdManagementTitle, null, () => context.push('/households')),
      // Webapp-Werkzeuge — nur in den Desktop-Apps (Windows/macOS).
      if (PlatformFeatures.webAppTools) ...[
        _QuickItem('bulkimport', Icons.playlist_add_rounded, _TileColor.orange,
            l.bulkImportTitle, null, () => context.push('/bulk-import')),
        _QuickItem('migrations', Icons.move_down_rounded, _TileColor.blue,
            l.migrationsTitle, null, () => context.push('/migrations')),
        _QuickItem('recipedata', Icons.dataset_rounded, _TileColor.purple,
            l.recipeDataTitle, null, () => context.push('/recipe-data')),
        _QuickItem('recipeactions', Icons.bolt_rounded, _TileColor.orange,
            l.recipeActionsTitle, null, () => context.push('/recipe-actions')),
        _QuickItem('webhooks', Icons.webhook_rounded, _TileColor.green,
            l.webhooksTitle, null, () => context.push('/webhooks')),
        _QuickItem(
            'notifiers',
            Icons.notifications_active_rounded,
            _TileColor.blue,
            l.notifiersTitle,
            null,
            () => context.push('/notifiers')),
        _QuickItem('updates', Icons.system_update_rounded, _TileColor.blue,
            l.updateTitle, updateCount, () => context.push('/updates')),
        _QuickItem('aiproviders', Icons.auto_awesome_rounded, _TileColor.purple,
            l.aiProvidersTitle, null, () => context.push('/ai-providers')),
        _QuickItem('debug', Icons.bug_report_rounded, _TileColor.green,
            l.debugTitle, null, () => context.push('/debug')),
        _QuickItem(
            'admin',
            Icons.admin_panel_settings_rounded,
            _TileColor.purple,
            l.adminTitle,
            null,
            () => context.push('/admin')),
      ],
    ];

_QuickItem _moreTile(BuildContext context, AppLocalizations l, {int? count}) =>
    _QuickItem('manage', Icons.apps_rounded, _TileColor.purple,
        l.managementTitle, count, () => context.push('/manage'));

/// Obergrenze für Kacheln auf dem Startbildschirm (User-Wunsch), inklusive
/// der festen Kachel „Weiteres".
const kMaxHomeTiles = 8;

/// So viele Kacheln lassen sich anpinnen (eine Stelle gehört „Weiteres").
const kMaxPinnedHomeTiles = kMaxHomeTiles - 1;

/// Standard-Startbildschirm (bis zur ersten eigenen Änderung) — derselbe
/// Stand wie vor den Pins.
const kDefaultHomeTiles = [
  'recipes',
  'shopping',
  'mealplan',
  'import',
  'cookfriends',
  'timeline',
];

/// Gespeicherte Startbildschirm-Auswahl inkl. Kacheln, die gerade wegen
/// fehlender Rechte versteckt sind (bleiben gespeichert, falls das Recht
/// wiederkommt). Ohne eigene Auswahl: Standard + früher angepinnte.
List<String> _storedHomeTiles(AppSettings? s) {
  final base = s?.homeTiles ??
      [...kDefaultHomeTiles, ...(s?.homePinnedTiles ?? const <String>[])];
  final seen = <String>{};
  return [
    for (final k in base)
      if (seen.add(k)) k,
  ];
}

/// Kacheln auf dem Startbildschirm: gespeicherte Auswahl, ohne die ohne Recht
/// ([allowed]), höchstens [kMaxPinnedHomeTiles]. Versteckte zählen NICHT
/// gegen die Obergrenze.
List<String> effectiveHomeTiles(AppSettings? s,
        {bool Function(String key)? allowed}) =>
    _storedHomeTiles(s)
        .where((k) => allowed?.call(k) ?? true)
        .take(kMaxPinnedHomeTiles)
        .toList();

/// Reihenfolge nach [order]; unbekannte/neue Keys behalten ihre Standard-
/// Position dahinter.
List<_QuickItem> _orderBy(List<_QuickItem> items, List<String> order) {
  final byKey = {for (final q in items) q.key: q};
  final ordered = <_QuickItem>[];
  for (final k in order) {
    final it = byKey.remove(k);
    if (it != null) ordered.add(it);
  }
  ordered.addAll(items.where((q) => byKey.containsKey(q.key)));
  return ordered;
}

// ---------------------------------------------------------------------------
// „Weiteres" (Home-Kachel) — ALLE Kacheln (die vom Startbildschirm und die
// übrigen). Pin = liegt zusätzlich auf dem Startbildschirm (max. 8 inkl.
// „Weiteres"). Lang drücken + ziehen sortiert (eigene Reihenfolge).
// ---------------------------------------------------------------------------

class ManagementScreen extends ConsumerStatefulWidget {
  const ManagementScreen({super.key});

  @override
  ConsumerState<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends ConsumerState<ManagementScreen> {
  /// Scrollposition für die laufende Sitzung merken: Kacheln wie Rezepte/
  /// Einkaufsliste/Essensplan wechseln per `go` in einen Tab und schließen
  /// „Weiteres" dabei — beim Wiederöffnen sprang die Seite sonst nach oben.
  static double _lastOffset = 0;
  late final ScrollController _scroll =
      ScrollController(initialScrollOffset: _lastOffset)
        ..addListener(() => _lastOffset = _scroll.offset);

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _togglePin(BuildContext context, String key) {
    final l = AppLocalizations.of(context)!;
    final s = ref.read(settingsProvider).valueOrNull ?? const AppSettings();
    final perms = ref.read(userPermissionsProvider);
    // Gespeicherte Liste behält auch gerade versteckte Kacheln; die
    // Obergrenze zählt nur sichtbare.
    final stored = _storedHomeTiles(s);
    final visible =
        effectiveHomeTiles(s, allowed: (k) => tileAllowed(k, perms));
    if (visible.contains(key)) {
      stored.remove(key);
    } else {
      if (visible.length >= kMaxPinnedHomeTiles) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l.homeScreenFull(kMaxHomeTiles))));
        return;
      }
      stored
        ..remove(key)
        ..add(key);
    }
    HapticFeedback.selectionClick();
    ref.read(settingsProvider.notifier).save(s.copyWith(homeTiles: stored));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider).valueOrNull;
    final perms = ref.watch(userPermissionsProvider);
    final home =
        effectiveHomeTiles(settings, allowed: (k) => tileAllowed(k, perms));
    final ordered = _orderBy(
        _allTiles(context, l,
            perms: perms,
            updateCount: _pendingUpdates(ref),
            shoppingTitle: ref.watch(activeShoppingListNameProvider)),
        settings?.moreTilesOrder ?? const []);

    void reorder(int from, int to) {
      if (from == to) return;
      HapticFeedback.mediumImpact();
      final keys = ordered.map((e) => e.key).toList();
      keys.insert(to, keys.removeAt(from));
      final s = settings ?? const AppSettings();
      ref
          .read(settingsProvider.notifier)
          .save(s.copyWith(moreTilesOrder: keys));
    }

    Widget tile(int i) {
      final q = ordered[i];
      final isPinned = home.contains(q.key);
      return _DraggableTile(
        index: i,
        item: q,
        onReorder: reorder,
        // Kompakter runder Pin innerhalb der Kachel (oben rechts).
        overlay: Tooltip(
          message: isPinned ? l.unpinFromHome : l.pinToHome,
          child: Material(
            color: isPinned
                ? AppTokens.accent.withValues(alpha: 0.15)
                : context.appSurface2,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _togglePin(context, q.key),
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Icon(
                  isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                  size: 18,
                  color:
                      isPinned ? AppTokens.accentDeep : context.appFgTertiary,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(title: Text(l.managementTitle)),
      body: WithCookingModeFAB(
        child: SafeArea(
          top: false,
          child: ListView(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              _tileGrid(LargeScreen.tileColumns(context), ordered.length, tile),
            ],
          ),
        ),
      ),
    );
  }
}

/// Zeigt nach dem ersten Frame des Startbildschirms ggf. „Was ist neu".
class _WhatsNewTrigger extends StatefulWidget {
  const _WhatsNewTrigger();

  @override
  State<_WhatsNewTrigger> createState() => _WhatsNewTriggerState();
}

class _WhatsNewTriggerState extends State<_WhatsNewTrigger> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) maybeShowWhatsNew(context);
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Einmal pro App-Start: Ist „Erinnere mich zum Einkaufen" an, aber fehlt
/// inzwischen „Immer"-Standort oder die Mitteilungs-Berechtigung (vom Nutzer
/// oder von iOS zurückgenommen), feuert die Erinnerung bei geschlossener App
/// still nie — dann einen Hinweis mit Weg in die Einstellungen zeigen.
class _ShoppingReminderHealthCheck extends ConsumerStatefulWidget {
  const _ShoppingReminderHealthCheck();

  @override
  ConsumerState<_ShoppingReminderHealthCheck> createState() =>
      _ShoppingReminderHealthCheckState();
}

bool _reminderCheckedThisLaunch = false;

class _ShoppingReminderHealthCheckState
    extends ConsumerState<_ShoppingReminderHealthCheck> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  Future<void> _check() async {
    if (_reminderCheckedThisLaunch) return;
    final s = await ref.read(settingsProvider.future);
    if (!s.remindToShopEnabled || s.shoppingReminderLocations.isEmpty) return;
    _reminderCheckedThisLaunch = true;
    const service = ShoppingReminderLocationService();
    final ok = await service.hasAlwaysPermission() &&
        await NotificationService.notificationsAllowed();
    if (ok || !mounted) return;
    final l = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(l.shoppingReminderInactiveHint),
      duration: const Duration(seconds: 8),
      action: SnackBarAction(
          label: l.openSettings, onPressed: service.openAppSettings),
    ));
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
