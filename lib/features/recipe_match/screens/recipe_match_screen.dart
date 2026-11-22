import '../../../core/utils/yield_format.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/organizer_item.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/utils/cooking_step_utils.dart';
import '../../../core/utils/ingredient_display.dart';
import '../../../core/utils/media_urls.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/multi_select_sheet.dart';
import '../../../shared/widgets/recipe_image.dart';
import '../../organizers/providers/organizers_provider.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../../shopping_list/providers/shopping_list_provider.dart';
import '../providers/recipe_match_provider.dart';
import 'recipe_match_tray_sheet.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/app_chip.dart';

// ---------------------------------------------------------------------------
// Rezept-Match — Kartenstapel. Runder „X"-Knopf = nächste Karte, oranges
// Herz = aufs Tablett; die Karte lässt sich auch zu einem der beiden Knöpfe
// ziehen (links = X, rechts = Herz), der Ziel-Knopf wächst dabei mit.
// Antippen dreht die Karte weiter: Bild → Zutaten (Portionen, „vorrätig")
// → Zubereitung → wieder Bild.
// Das Tablett öffnet ein Wisch nach oben über den Griff am unteren Rand
// (Antippen geht auch — für Bedienungshilfen). Logik siehe
// [RecipeMatchNotifier].
// ---------------------------------------------------------------------------

/// Ab dieser Geschwindigkeit (px/s) bzw. Strecke (px) öffnet ein Wisch nach
/// oben auf dem Griff das Tablett.
const _kTraySwipeVelocity = 250.0;
const _kTraySwipeDistance = 36.0;

/// Karte ziehen: ab dieser seitlichen Strecke (px) bzw. Geschwindigkeit
/// (px/s) zählt das Loslassen als ✕ bzw. Herz.
const _kDragDistance = 100.0;
const _kDragVelocity = 700.0;

enum _Fly { none, next, keep, back }

class RecipeMatchScreen extends ConsumerStatefulWidget {
  const RecipeMatchScreen({super.key});

  @override
  ConsumerState<RecipeMatchScreen> createState() => _RecipeMatchScreenState();
}

class _RecipeMatchScreenState extends ConsumerState<RecipeMatchScreen>
    with SingleTickerProviderStateMixin {
  /// Versatz der obersten Karte (Ziehen bzw. Wegfliegen).
  Offset _drag = Offset.zero;
  bool _dragging = false;

  /// Umdreh-Zähler der obersten Karte: 0 = Bild, 1 = Zutaten,
  /// 2 = Zubereitung, dann wieder Bild (Seite = _turns % 3).
  int _turns = 0;
  bool get _onFront => _turns % 3 == 0;

  late final AnimationController _fly = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 260))
    ..addListener(_onFlyTick)
    ..addStatusListener(_onFlyStatus);
  Offset _flyFrom = Offset.zero;
  Offset _flyTo = Offset.zero;
  _Fly _flyKind = _Fly.none;
  String? _flyId;

  /// Zuletzt per ✕ übersprungenes Rezept — der kleine „Zurück"-Knopf holt
  /// es wieder oben auf den Stapel.
  String? _lastSkipped;

  /// „Im Haushalt vorrätig" (wie beim Hinzufügen zur Einkaufsliste).
  bool Function(Ingredient)? _onHand;

  @override
  void initState() {
    super.initState();
    ref.read(shoppingListProvider.notifier).onHandChecker().then((f) {
      if (mounted) setState(() => _onHand = f);
    }).catchError((_) {});
  }

  @override
  void dispose() {
    _fly.dispose();
    super.dispose();
  }

  void _onFlyTick() {
    final t = Curves.easeOutCubic.transform(_fly.value);
    setState(() => _drag = Offset.lerp(_flyFrom, _flyTo, t)!);
  }

  void _onFlyStatus(AnimationStatus s) {
    if (s != AnimationStatus.completed) return;
    final id = _flyId;
    final kind = _flyKind;
    _flyKind = _Fly.none;
    _flyId = null;
    if (kind == _Fly.back) {
      setState(() => _drag = Offset.zero);
      return;
    }
    final n = ref.read(recipeMatchProvider.notifier);
    if (id != null && kind == _Fly.next) n.next(id);
    if (id != null && kind == _Fly.keep) {
      n.keep(id);
      _showKeptSnack(id);
    }
    setState(() {
      _drag = Offset.zero;
      _turns = 0;
      _lastSkipped = kind == _Fly.next ? id : null;
    });
  }

  void _showKeptSnack(String id) {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      content: Text(l.recipeMatchKept),
      // Flutter lässt Snackbars mit Aktion sonst stehen, bis man sie
      // wegtippt (persist = action != null).
      persist: false,
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: l.undo,
        onPressed: () =>
            ref.read(recipeMatchProvider.notifier).restoreToTop(id),
      ),
    ));
  }

  /// Karte wegfliegen lassen — in Richtung des jeweiligen Knopfs: „X" nach
  /// links unten, Herz nach rechts unten. [_Fly.back] = zurück in die Mitte.
  void _launch(_Fly kind, String id, Size area) {
    if (_fly.isAnimating) return;
    if (kind != _Fly.back) HapticFeedback.mediumImpact();
    _flyKind = kind;
    _flyId = id;
    _flyFrom = _drag;
    final down = _drag.dy + area.height * 0.25;
    _flyTo = switch (kind) {
      _Fly.next => Offset(-area.width * 1.4, down),
      _Fly.keep => Offset(area.width * 1.4, down),
      _ => Offset.zero,
    };
    _fly.forward(from: 0);
  }

  // ✕ und Herz liegen UNTER der Karte, nah an der Mitte — zählt deshalb
  // auch, wenn der Finger beim Loslassen über dem Knopf ist (nicht nur die
  // seitliche Strecke; zum Herz kam man sonst nur ganz rechts außen).
  final _xKey = GlobalKey();
  final _heartKey = GlobalKey();
  Offset? _pointer;

  bool _over(GlobalKey key) {
    final p = _pointer;
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (p == null || box == null || !box.hasSize) return false;
    final rect = box.localToGlobal(Offset.zero) & box.size;
    return rect.inflate(28).contains(p);
  }

  void _onPanEnd(DragEndDetails d, String id, Size area) {
    if (!_dragging) return;
    _dragging = false;
    final overX = _over(_xKey);
    final overHeart = _over(_heartKey);
    _pointer = null;
    final vx = d.velocity.pixelsPerSecond.dx;
    if (overHeart) {
      _launch(_Fly.keep, id, area);
    } else if (overX) {
      _launch(_Fly.next, id, area);
    } else if (_drag.dx < -_kDragDistance || vx < -_kDragVelocity) {
      _launch(_Fly.next, id, area);
    } else if (_drag.dx > _kDragDistance || vx > _kDragVelocity) {
      _launch(_Fly.keep, id, area);
    } else {
      _launch(_Fly.back, id, area);
    }
  }

  /// -1 … 1: wie stark die Karte gerade Richtung ✕ (links) bzw. Herz
  /// (rechts) zeigt — für wachsende Knöpfe und das Symbol auf der Karte.
  double get _lean {
    if (_flyKind == _Fly.back) return 0;
    if (_dragging && _over(_heartKey)) return 1;
    if (_dragging && _over(_xKey)) return -1;
    return (_drag.dx / _kDragDistance).clamp(-1.0, 1.0);
  }

  void _openTray() {
    HapticFeedback.selectionClick();
    showRecipeMatchTraySheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final st = ref.watch(recipeMatchProvider);
    final recipesAsync = ref.watch(recipesProvider);
    final all = recipesAsync.valueOrNull ?? const <RecipeDetail>[];
    final deck = st.deck(all);
    final tray = st.trayRecipes(all);
    // Griff leuchtet auf, während eine Karte hineinsinkt.
    final dropping = _flyKind == _Fly.keep && _fly.isAnimating;

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Text(l.recipeMatchTitle),
        actions: [
          IconButton(
            tooltip: l.recipeMatchShuffle,
            icon: const Icon(Icons.shuffle_rounded),
            onPressed: deck.length < 2
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    setState(() => _turns = 0);
                    ref.read(recipeMatchProvider.notifier).shuffle();
                  },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _FilterBar(filters: st.filters),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(l.recipeMatchCardsLeft(deck.length),
                    style: TextStyle(color: context.appFgSub, fontSize: 13)),
              ),
            ),
            Expanded(
              child: LayoutBuilder(builder: (ctx, c) {
                final area = Size(c.maxWidth, c.maxHeight);
                if (recipesAsync.isLoading && all.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (deck.isEmpty) return _EmptyDeck(filters: st.filters);
                return _buildStack(deck, area);
              }),
            ),
            if (deck.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                child: LayoutBuilder(
                  builder: (ctx, c) {
                    final area = Size(c.maxWidth, 600);
                    final canUndo = _lastSkipped != null;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // „Zurück" nach einem ✕ — Platz bleibt immer
                        // reserviert (rechts gespiegelt), damit ✕ und Herz
                        // nicht springen.
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 180),
                          opacity: canUndo ? 1 : 0,
                          child: IgnorePointer(
                            ignoring: !canUndo,
                            child: _RoundButton(
                              icon: Icons.undo_rounded,
                              tooltip: l.undo,
                              size: 48,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                final id = _lastSkipped;
                                if (id == null) return;
                                ref
                                    .read(recipeMatchProvider.notifier)
                                    .restoreToTop(id);
                                setState(() {
                                  _lastSkipped = null;
                                  _turns = 0;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        _RoundButton(
                          key: _xKey,
                          icon: Icons.close_rounded,
                          tooltip: l.recipeMatchNext,
                          size: 64,
                          emphasis: (-_lean).clamp(0.0, 1.0),
                          onTap: () => _launch(_Fly.next, deck.first.id, area),
                        ),
                        const SizedBox(width: 40),
                        _RoundButton(
                          key: _heartKey,
                          icon: Icons.favorite_rounded,
                          tooltip: l.recipeMatchKeep,
                          size: 72,
                          primary: true,
                          emphasis: _lean.clamp(0.0, 1.0),
                          onTap: () => _launch(_Fly.keep, deck.first.id, area),
                        ),
                        const SizedBox(width: 24 + 48),
                      ],
                    );
                  },
                ),
              ),
            _TrayHandle(
              recipes: tray,
              highlighted: dropping,
              onOpen: _openTray,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStack(List<RecipeDetail> deck, Size area) {
    final top = deck.first;
    final cardW = min(area.width - 48, 420.0);
    final cardH = area.height - 28;
    // 0 … 1: wie weit die oberste Karte schon weg ist — die nächste rückt
    // entsprechend nach vorne.
    final progress = (_drag.distance / 260).clamp(0.0, 1.0);
    final shrink = (_drag.dy / 1100).clamp(0.0, 0.3);

    Widget positioned(Widget child) => Center(
          child: SizedBox(width: cardW, height: cardH, child: child),
        );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (deck.length > 2)
          positioned(Transform.rotate(
            angle: 0.08,
            child: Transform.scale(scale: 0.92, child: const _CardBlank()),
          )),
        if (deck.length > 1)
          positioned(Transform.rotate(
            angle: -0.055 * (1 - progress),
            child: Transform.scale(
              scale: 0.95 + 0.05 * progress,
              child: IgnorePointer(child: _CardFront(recipe: deck[1])),
            ),
          )),
        positioned(Transform.translate(
          offset: _drag,
          child: Transform.rotate(
            angle: _drag.dx / 900,
            child: Transform.scale(
              scale: 1 - shrink,
              child: GestureDetector(
                onTap: () {
                  if (_fly.isAnimating) return;
                  HapticFeedback.selectionClick();
                  setState(() => _turns++);
                },
                // Umgedreht scrollt die Zutatenliste — dann kein Ziehen.
                onPanStart: !_onFront
                    ? null
                    : (_) {
                        if (!_fly.isAnimating) _dragging = true;
                      },
                onPanUpdate: !_onFront
                    ? null
                    : (d) {
                        if (!_dragging) return;
                        _pointer = d.globalPosition;
                        setState(() => _drag += d.delta);
                      },
                onPanEnd: !_onFront ? null : (d) => _onPanEnd(d, top.id, area),
                child: Stack(children: [
                  Positioned.fill(
                    // Schlüssel je Rezept: die nächste Karte startet ohne
                    // Rückwärts-Drehung auf ihrer Bildseite.
                    child: _FlipCard(
                      key: ValueKey('match-card-${top.id}'),
                      turns: _turns,
                      faces: [
                        _CardFront(recipe: top),
                        _CardIngredients(
                          recipe: top,
                          onHand: _onHand,
                          onNext: () => setState(() => _turns++),
                          onOpen: () => context.push('/recipes/${top.id}'),
                        ),
                        _CardSteps(
                          recipe: top,
                          onNext: () => setState(() => _turns++),
                          onOpen: () => context.push('/recipes/${top.id}'),
                        ),
                      ],
                    ),
                  ),
                  // Symbol des Ziel-Knopfs blendet beim Ziehen ein.
                  if (_lean.abs() > 0.05)
                    Positioned(
                      top: 18,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: Center(
                          child: Opacity(
                            opacity: _lean.abs(),
                            child: _DragBadge(keep: _lean > 0),
                          ),
                        ),
                      ),
                    ),
                ]),
              ),
            ),
          ),
        )),
      ],
    );
  }
}

// ── Filter ───────────────────────────────────────────────────────────────

class _FilterBar extends ConsumerWidget {
  final RecipeMatchFilters filters;
  const _FilterBar({required this.filters});

  Future<void> _pick(
      BuildContext context, WidgetRef ref, OrganizerKind kind) async {
    final l = AppLocalizations.of(context)!;
    final isCat = kind == OrganizerKind.category;
    final res = await showMultiSelectSheet(
      context,
      title: isCat ? l.categories : l.tags,
      initial: isCat ? filters.categories : filters.tags,
      items: (r) => [
        for (final o in r.watch(organizersProvider(kind)).valueOrNull ??
            const <OrganizerItem>[])
          (id: o.id, name: o.name),
      ],
      loading: (r) => r.watch(organizersProvider(kind)).isLoading,
    );
    if (res == null) return;
    final n = ref.read(recipeMatchProvider.notifier);
    final current = ref.read(recipeMatchProvider).filters;
    n.setFilters(isCat
        ? current.copyWith(categories: res.selected)
        : current.copyWith(tags: res.selected));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final max = filters.maxMinutes;
    String withCount(String label, int n) => n == 0 ? label : '$label ($n)';
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Row(children: [
        _FilterChip(
          icon: Icons.schedule_rounded,
          label: max == null ? l.recipeMatchAnyTime : l.recipeMatchMaxTime(max),
          active: max != null,
          // Antippen schaltet durch: jede Dauer → ≤ 30 → ≤ 60 → jede Dauer.
          onTap: () {
            HapticFeedback.selectionClick();
            final i = kRecipeMatchMaxTimes.indexOf(max);
            final next =
                kRecipeMatchMaxTimes[(i + 1) % kRecipeMatchMaxTimes.length];
            ref
                .read(recipeMatchProvider.notifier)
                .setFilters(filters.copyWith(maxMinutes: () => next));
          },
        ),
        const SizedBox(width: 8),
        _FilterChip(
          icon: Icons.category_rounded,
          label: withCount(l.categories, filters.categories.length),
          active: filters.categories.isNotEmpty,
          onTap: () => _pick(context, ref, OrganizerKind.category),
        ),
        const SizedBox(width: 8),
        _FilterChip(
          icon: Icons.sell_rounded,
          label: withCount(l.tags, filters.tags.length),
          active: filters.tags.isNotEmpty,
          onTap: () => _pick(context, ref, OrganizerKind.tag),
        ),
      ]),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterChip({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) =>
      AppChip(icon: icon, label: label, selected: active, onTap: onTap);
}

class _EmptyDeck extends ConsumerWidget {
  final RecipeMatchFilters filters;
  const _EmptyDeck({required this.filters});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    return EmptyStateView(
      icon: Icons.style_rounded,
      title: l.recipeMatchEmpty,
      message: l.recipeMatchEmptyHint,
      actionLabel: filters.count > 0 ? l.recipeMatchResetFilters : null,
      actionIcon: Icons.filter_alt_off_rounded,
      onAction: () => ref
          .read(recipeMatchProvider.notifier)
          .setFilters(const RecipeMatchFilters()),
      scrollable: false,
    );
  }
}

// ── Karte ────────────────────────────────────────────────────────────────

/// Dreht durch die Seiten [faces] (um die senkrechte Achse): jede halbe
/// Drehung zeigt die nächste Seite, nach der letzten wieder die erste.
/// [turns] zählt nur hoch, damit die Drehung immer in dieselbe Richtung läuft.
class _FlipCard extends StatelessWidget {
  final int turns;
  final List<Widget> faces;
  const _FlipCard({super.key, required this.turns, required this.faces});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: turns * pi),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOutCubic,
      builder: (ctx, angle, _) {
        // Seitenwechsel genau bei 90°; Rest-Winkel −90…90° → nie gespiegelt.
        final k = (angle / pi).round();
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateY(angle - k * pi),
          child: faces[k % faces.length],
        );
      },
    );
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(AppTokens.rLg),
        border: Border.all(color: context.appSeparator),
        boxShadow: context.appShadowMd,
      ),
      child: child,
    );
  }
}

class _CardBlank extends StatelessWidget {
  const _CardBlank();

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: context.appSurface2,
          borderRadius: BorderRadius.circular(AppTokens.rLg),
          border: Border.all(color: context.appSeparator),
        ),
      );
}

String _fmtMinutes(int min, AppLocalizations l) {
  if (min < 60) return '$min ${l.minutesShort}';
  final h = min ~/ 60;
  final m = min % 60;
  return m == 0 ? '$h h' : '$h h $m ${l.minutesShort}';
}

class _RecipeThumb extends ConsumerWidget {
  final RecipeDetail recipe;
  final double? width;
  final double? height;
  final double iconSize;
  const _RecipeThumb(
      {required this.recipe, this.width, this.height, this.iconSize = 40});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider).valueOrNull;
    Widget placeholder(BuildContext ctx) => Container(
          width: width,
          height: height,
          color: ctx.appSurface2,
          alignment: Alignment.center,
          child: Icon(Icons.restaurant_rounded,
              size: iconSize, color: ctx.appFgTertiary),
        );
    if (!(s?.showRecipeImages ?? true)) return placeholder(context);
    return RecipeImage(
      recipeId: recipe.id,
      imageUrl:
          '${s?.serverUrl ?? ''}/api/media/recipes/${recipe.id}/images/original.webp',
      httpHeaders: mediaHeaders(s),
      width: width,
      height: height,
      placeholder: placeholder,
    );
  }
}

class _CardFront extends StatelessWidget {
  final RecipeDetail recipe;
  const _CardFront({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final total = recipe.totalTime ?? 0;
    // Portionen/Ergibt wie die Webapp getrennt (hier unskaliert).
    final yieldText = recipeYieldParts(recipe, 1, l.servings).join(' · ');
    final ingCount = recipe.recipeIngredient.where((i) => i.hasContent).length;
    final rating = recipe.rating ?? 0;
    final chips = [
      ...recipe.recipeCategory.map((c) => c.name),
      ...recipe.tags.map((t) => t.name),
    ].where((n) => n.trim().isNotEmpty).take(3).toList();
    final sub = context.appFgSub;

    Widget meta(IconData icon, String text) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: sub),
            const SizedBox(width: 4),
            Flexible(
              child: Text(text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: sub, fontSize: 13)),
            ),
          ],
        );

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 11,
            child: Stack(fit: StackFit.expand, children: [
              _RecipeThumb(recipe: recipe, iconSize: 56),
              if (rating > 0)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.62),
                      borderRadius: BorderRadius.circular(AppTokens.rXs),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.star_rounded,
                          size: 15, color: AppTokens.accentLight),
                      const SizedBox(width: 4),
                      Text(rating.toStringAsFixed(1),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
            ]),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: context.appFg,
                          fontSize: 20,
                          height: 1.2,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 14, runSpacing: 4, children: [
                    if (total > 0)
                      meta(Icons.schedule_rounded, _fmtMinutes(total, l)),
                    if (yieldText.isNotEmpty)
                      meta(Icons.people_alt_rounded, yieldText),
                    if (ingCount > 0)
                      meta(Icons.format_list_bulleted_rounded,
                          '$ingCount ${l.ingredients}'),
                  ]),
                  if (chips.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 26,
                      child: ClipRect(
                        child: Row(children: [
                          for (final c in chips)
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: context.appSurface2,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(c,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: context.appFgSub,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                        ]),
                      ),
                    ),
                  ],
                  const Spacer(),
                ],
              ),
            ),
          ),
          Container(
            height: 44,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: context.appSeparator)),
            ),
            alignment: Alignment.center,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.flip_rounded, size: 16, color: sub),
              const SizedBox(width: 7),
              Text(l.recipeMatchFlipHint,
                  style: TextStyle(
                      color: sub, fontSize: 13, fontWeight: FontWeight.w500)),
            ]),
          ),
        ],
      ),
    );
  }
}

/// Gemeinsamer Rahmen der Rückseiten (Zutaten, Zubereitung): Kopf mit
/// Bild + Name, Abschnittszeile, Inhalt, Fuß mit „weiter"-Knopf und
/// „Ganzes Rezept".
class _CardSide extends StatelessWidget {
  final RecipeDetail recipe;
  final String sectionLabel;
  final Widget? trailing;
  final Widget body;
  final String nextLabel;
  final IconData nextIcon;
  final VoidCallback onNext;
  final VoidCallback onOpen;
  const _CardSide({
    required this.recipe,
    required this.sectionLabel,
    required this.body,
    required this.nextLabel,
    required this.nextIcon,
    required this.onNext,
    required this.onOpen,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final sub = context.appFgSub;
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.appSeparator)),
            ),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTokens.rSm),
                child: _RecipeThumb(
                    recipe: recipe, width: 46, height: 46, iconSize: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(recipe.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: context.appFg,
                        fontSize: 16,
                        height: 1.25,
                        fontWeight: FontWeight.w800)),
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 10, trailing == null ? 16 : 10, 4),
            child: SizedBox(
              height: 40,
              child: Row(children: [
                Expanded(
                  child: Text(sectionLabel.toUpperCase(),
                      style: TextStyle(
                          color: sub,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6)),
                ),
                if (trailing != null) trailing!,
              ]),
            ),
          ),
          Expanded(child: body),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: context.appSeparator)),
            ),
            child: Row(children: [
              Expanded(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                      foregroundColor: sub,
                      minimumSize: const Size.fromHeight(48)),
                  onPressed: onNext,
                  icon: Icon(nextIcon, size: 17),
                  label: Text(nextLabel, overflow: TextOverflow.ellipsis),
                ),
              ),
              Container(width: 1, height: 28, color: context.appSeparator),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: AppTokens.accentDeep,
                      minimumSize: const Size.fromHeight(48)),
                  onPressed: onOpen,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Flexible(
                      child: Text(l.recipeMatchOpenRecipe,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded, size: 18),
                  ]),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

/// Seite 2: Zutaten mit Portionen-Regler und „vorrätig".
class _CardIngredients extends ConsumerWidget {
  final RecipeDetail recipe;
  final bool Function(Ingredient)? onHand;
  final VoidCallback onNext;
  final VoidCallback onOpen;
  const _CardIngredients({
    required this.recipe,
    required this.onHand,
    required this.onNext,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final scale =
        ref.watch(recipeMatchProvider.select((s) => s.scaleOf(recipe.id)));
    // Wie Mealie: Portionen, sonst Ergibt-Menge.
    final base = (recipe.servings ?? 0) > 0
        ? recipe.servings!
        : (recipe.yieldQuantity ?? 0);

    // Portionen: mit hinterlegter Zahl in ganzen Portionen, sonst Faktor.
    final String scaleLabel;
    final double? minus;
    final double plus;
    if (base > 0) {
      final portions = base * scale;
      scaleLabel = '${formatQuantity(portions)} ${l.servings}';
      minus = portions - 1 >= 1 ? (portions - 1) / base : null;
      plus = (portions + 1) / base;
    } else {
      scaleLabel = '× ${formatQuantity(scale)}';
      minus = scale - 0.5 >= 0.5 ? scale - 0.5 : null;
      plus = scale + 0.5;
    }
    void setScale(double v) {
      HapticFeedback.selectionClick();
      ref.read(recipeMatchProvider.notifier).setScale(recipe.id, v);
    }

    return _CardSide(
      recipe: recipe,
      sectionLabel: l.ingredients,
      nextLabel: l.instructions,
      nextIcon: Icons.arrow_forward_rounded,
      onNext: onNext,
      onOpen: onOpen,
      trailing: Container(
        decoration: BoxDecoration(
          color: context.appSurface2,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove_rounded, size: 18),
            onPressed: minus == null ? null : () => setScale(minus!),
          ),
          Text(scaleLabel,
              style: TextStyle(
                  color: context.appFg,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add_rounded, size: 18),
            onPressed: () => setScale(plus),
          ),
        ]),
      ),
      body: recipe.recipeIngredient.isEmpty
          ? Center(
              child: Text('—', style: TextStyle(color: context.appFgTertiary)))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              children: [
                for (final ing in recipe.recipeIngredient) ...[
                  if (ing.sectionTitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 2),
                      child: Text(ing.sectionTitle!,
                          style: TextStyle(
                              color: context.appFg,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                    ),
                  if (ing.hasContent)
                    _IngredientRow(
                      parts: ingredientDisplayParts(ing, scale),
                      onHand: onHand?.call(ing) ?? false,
                    ),
                ],
              ],
            ),
    );
  }
}

/// Seite 3: Zubereitungsschritte (Text ohne eingebettete Bilder; Abschnitte
/// und Schritt-Überschriften wie in der Detailansicht).
class _CardSteps extends StatelessWidget {
  final RecipeDetail recipe;
  final VoidCallback onNext;
  final VoidCallback onOpen;
  const _CardSteps({
    required this.recipe,
    required this.onNext,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final steps = recipe.recipeInstructions
        .where((s) =>
            stripMarkdownImages(s.text).trim().isNotEmpty ||
            (s.summary?.trim().isNotEmpty ?? false))
        .toList();
    return _CardSide(
      recipe: recipe,
      sectionLabel: l.instructions,
      nextLabel: l.recipeMatchFlipBack,
      nextIcon: Icons.flip_rounded,
      onNext: onNext,
      onOpen: onOpen,
      body: steps.isEmpty
          ? Center(
              child: Text('—', style: TextStyle(color: context.appFgTertiary)))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              children: [
                for (var i = 0; i < steps.length; i++) ...[
                  if (steps[i].sectionTitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 4),
                      child: Text(steps[i].sectionTitle!,
                          style: TextStyle(
                              color: context.appFg,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppTokens.accentGradient,
                          ),
                          child: Text('${i + 1}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (steps[i].summary?.trim().isNotEmpty ?? false)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(steps[i].summary!.trim(),
                                      style: TextStyle(
                                          color: context.appFg,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700)),
                                ),
                              Text(stripMarkdownImages(steps[i].text).trim(),
                                  style: TextStyle(
                                      color: context.appFg,
                                      fontSize: 14,
                                      height: 1.4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final IngredientDisplay parts;
  final bool onHand;
  const _IngredientRow({required this.parts, required this.onHand});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        border: Border(
            bottom:
                BorderSide(color: context.appSeparator.withValues(alpha: 0.6))),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (parts.amount.isNotEmpty)
          SizedBox(
            width: 78,
            child: Text(parts.amount,
                style: const TextStyle(
                    color: AppTokens.accentDeep,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ),
        Expanded(
          child: Text(parts.name,
              style: TextStyle(color: context.appFg, fontSize: 14)),
        ),
        if (onHand) ...[
          const SizedBox(width: 6),
          RecipeMatchOnHandPill(label: l.recipeMatchOnHand),
        ],
      ]),
    );
  }
}

/// Kleines „vorrätig"-Etikett (Karte + Zutaten-Auswahl).
class RecipeMatchOnHandPill extends StatelessWidget {
  final String label;
  const RecipeMatchOnHandPill({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E9E57);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: green.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
          style: const TextStyle(
              color: green, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

// ── Knöpfe + Tablett-Leiste ──────────────────────────────────────────────

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final double size;
  final bool primary;
  final VoidCallback onTap;

  /// 0 … 1: Karte wird gerade zu diesem Knopf gezogen → er wächst mit.
  final double emphasis;
  const _RoundButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.size,
    required this.onTap,
    this.primary = false,
    this.emphasis = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1 + 0.2 * emphasis,
      child: Tooltip(
        message: tooltip,
        child: Semantics(
          button: true,
          label: tooltip,
          // Schatten/Schein AUSSEN als eigene runde Box: in der Ink-Fläche
          // schneidet Flutter ihn am Rechteck des Knopfs ab (sichtbares
          // oranges Viereck hinter dem Herz).
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: primary ? context.appAccentGlow : context.appShadowSm,
            ),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: Ink(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: primary ? AppTokens.accentGradient : null,
                  color: primary ? null : context.appCard,
                  border: primary
                      ? null
                      : Border.all(
                          color: Color.lerp(context.appSeparator,
                              context.appFgSub, emphasis)!,
                          width: 1 + emphasis),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onTap,
                  child: Icon(icon,
                      size: size * 0.45,
                      color: primary ? Colors.white : context.appFgSub),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Symbol oben auf der Karte, während sie zu ✕ bzw. Herz gezogen wird.
class _DragBadge extends StatelessWidget {
  final bool keep;
  const _DragBadge({required this.keep});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: keep ? AppTokens.accentGradient : null,
        color: keep ? null : Colors.black.withValues(alpha: 0.6),
        border: keep ? null : Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(keep ? Icons.favorite_rounded : Icons.close_rounded,
          size: 32, color: Colors.white),
    );
  }
}

/// Griff am unteren Rand: nach oben wischen öffnet das Tablett. Der
/// wippende Pfeil + Text zeigen die Geste; Antippen öffnet ebenfalls
/// (Bedienungshilfen). Liegt über der System-Gestenleiste (SafeArea), damit
/// der Wisch nicht als „Home" beim System landet.
class _TrayHandle extends StatefulWidget {
  final List<RecipeDetail> recipes;
  final bool highlighted;
  final VoidCallback onOpen;
  const _TrayHandle({
    required this.recipes,
    required this.highlighted,
    required this.onOpen,
  });

  @override
  State<_TrayHandle> createState() => _TrayHandleState();
}

class _TrayHandleState extends State<_TrayHandle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bob = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1100))
    ..repeat(reverse: true);
  double _dragDy = 0;

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final recipes = widget.recipes;
    final thumbs = recipes.reversed.take(3).toList();
    final hl = widget.highlighted;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    const thumb = 26.0;

    // Sichtbar nur eine schmale Pille in der Mitte; die Wischfläche reicht
    // trotzdem über die ganze Breite (leichter zu treffen).
    return Semantics(
      button: true,
      label: '${l.recipeMatchTray}: ${l.recipeMatchSwipeUp}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onOpen,
        onVerticalDragStart: (_) => _dragDy = 0,
        onVerticalDragUpdate: (d) => _dragDy += d.delta.dy,
        onVerticalDragEnd: (d) {
          final vy = d.velocity.pixelsPerSecond.dy;
          if (vy < -_kTraySwipeVelocity || _dragDy < -_kTraySwipeDistance) {
            widget.onOpen();
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Wippender Pfeil nach oben = „hier hochwischen".
            AnimatedBuilder(
              animation: _bob,
              builder: (ctx, child) => Transform.translate(
                offset: Offset(
                    0,
                    reduceMotion
                        ? 0
                        : -3 * Curves.easeInOut.transform(_bob.value)),
                child: child,
              ),
              child: Icon(Icons.keyboard_arrow_up_rounded,
                  size: 22,
                  color: hl ? AppTokens.accentDeep : context.appFgSub),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.fromLTRB(thumbs.isEmpty ? 14 : 6, 5, 14, 5),
              decoration: BoxDecoration(
                color: hl
                    ? AppTokens.accent.withValues(alpha: 0.16)
                    : context.appSurface2,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: hl ? AppTokens.accent : context.appSeparator,
                  width: hl ? 1.5 : 1,
                ),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (thumbs.isNotEmpty) ...[
                  SizedBox(
                    width: thumb + (thumbs.length - 1) * 14,
                    height: thumb,
                    child: Stack(children: [
                      for (var i = 0; i < thumbs.length; i++)
                        Positioned(
                          left: i * 14.0,
                          child: Container(
                            width: thumb,
                            height: thumb,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: context.appSurface2, width: 1.5),
                            ),
                            child: ClipOval(
                              child: _RecipeThumb(
                                  recipe: thumbs[i],
                                  width: thumb,
                                  height: thumb,
                                  iconSize: 12),
                            ),
                          ),
                        ),
                    ]),
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    recipes.isEmpty
                        ? l.recipeMatchSwipeUp
                        : '${l.recipeMatchTray} · ${recipes.length}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: hl ? AppTokens.accentDeep : context.appFg,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Rezeptbild für die Unter-Bildschirme (Tablett, Auswahl, Essensplan).
class RecipeMatchThumb extends StatelessWidget {
  final RecipeDetail recipe;
  final double size;
  const RecipeMatchThumb({super.key, required this.recipe, this.size = 56});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.25),
        child: _RecipeThumb(
            recipe: recipe, width: size, height: size, iconSize: size * 0.4),
      );
}
