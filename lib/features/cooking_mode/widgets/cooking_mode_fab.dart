import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../shared/widgets/draggable_overlay.dart';
import '../../timer/providers/timer_provider.dart';
import '../providers/cooking_session_provider.dart';

// Frei beweglicher Standort des Kochmodus-FAB (Delta zum Standard-Anker
// unten-rechts). Provider-gehalten, damit die Position über alle Screens
// (jeder hat seine eigene WithCookingModeFAB-Instanz) konsistent bleibt.
// In-Memory pro Session.
final cookingFabOffsetProvider = StateProvider<Offset?>((ref) => null);

// ---------------------------------------------------------------------------
// CookingModeFAB — 1:1 port of iOS CookingModeFAB.swift
//
// Swift:
//   if activeSessionCount > 0 {
//       Button { showCookingMode = true } label: { fabContent }
//           .frame(minWidth: 44, minHeight: 44)
//           .fullScreenCover(isPresented: $showCookingMode) { CookingModeView() }
//   }
//
// fabContent:
//   ZStack {
//       Circle().fill(.orange).frame(56).shadow(.black 30 %, r 8, y 4)
//       if hasActiveTimers {
//           Circle().stroke(.orange.opacity(0.5), lineWidth: 3)
//               .frame(isPulsing ? 70 : 56)
//               .opacity(isPulsing ? 0 : 1)
//       }
//       ZStack(alignment: .topTrailing) {
//           Image(systemName: "flame.fill").font(.title2).foregroundColor(.white)
//           if activeSessionCount > 1 {
//               Text("\(count)").font(.caption2.bold().monospacedDigit())
//                   .foregroundColor(.orange).frame(20)
//                   .background(Circle().fill(.white))
//                   .offset(x: 8, y: -8)
//           }
//       }
//   }
//
// Pulse: withAnimation(.easeInOut(1.5).repeatForever(autoreverses: false))
// ---------------------------------------------------------------------------

class CookingModeFAB extends ConsumerStatefulWidget {
  const CookingModeFAB({super.key});

  @override
  ConsumerState<CookingModeFAB> createState() => _CookingModeFABState();
}

class _CookingModeFABState extends ConsumerState<CookingModeFAB>
    with SingleTickerProviderStateMixin {
  static const _fabSize = 56.0;
  static const _orange = Color(0xFFFF9500); // SwiftUI .orange

  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _syncPulse(bool hasActiveTimers) {
    if (hasActiveTimers) {
      if (!_pulse.isAnimating) _pulse.repeat();
    } else {
      if (_pulse.isAnimating) _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final sessions = ref.watch(cookingSessionsProvider);
    if (sessions.isEmpty) return const SizedBox.shrink();

    final timers = ref.watch(timerProvider);
    final activeCount = sessions.length;
    final hasActiveTimers = timers.any((t) => t.isRunning && !t.isFinished);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _syncPulse(hasActiveTimers));

    // Läuft ein Timer, wird er IN den Flammen-Badge integriert: EIN Badge,
    // gleich hoch wie bisher, nur BREITER (Pillenform) mit dem Countdown links
    // der Flamme. Bei mehreren Timern die kürzeste Restzeit. Ohne Timer bleibt
    // der runde Badge wie bisher. Dieser Flammen-Badge ist der EINZIGE
    // Timer-Indikator außerhalb des Kochmodus-Screens — einen separaten globalen
    // Timer-Chip gibt es nicht (Timer existieren nur im Kochmodus).
    final soonest = _soonestTimer(timers);

    final badge = soonest == null
        ? _fabContent(activeCount, hasActiveTimers)
        : _fabContentWithTimer(activeCount, soonest, l);

    return Semantics(
      button: true,
      label: l.openCookingMode,
      hint: l.activeRecipes(activeCount),
      child: Material(
        color: Colors.transparent,
        child: InkResponse(
          radius: _fabSize / 2 + 8,
          onTap: () =>
              GoRouter.of(context).push('/cooking/${sessions.first.slug}'),
          // Sanftes Einploppen, wenn der FAB erscheint (erste aktive Session).
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 420),
            curve: Curves.elasticOut,
            builder: (_, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: badge,
          ),
        ),
      ),
    );
  }

  /// Timer mit der kürzesten Restzeit (abgelaufene zählen als 0 → werden zuerst
  /// angezeigt). null wenn keine Timer.
  RecipeTimer? _soonestTimer(List<RecipeTimer> timers) {
    RecipeTimer? best;
    for (final t in timers) {
      if (best == null || t.remainingSeconds < best.remainingSeconds) best = t;
    }
    return best;
  }

  /// Flammen-Badge in Pillenform mit integriertem Timer-Countdown: gleiche Höhe
  /// (`_fabSize`) wie der runde Badge, nur breiter. Countdown links, Flamme
  /// rechts (Identität bleibt am bottom-right-Anker). Gleiches Orange + Schatten
  /// wie der runde Badge — bewusst KEIN Rot/Grün, damit es EIN Flammen-Badge
  /// bleibt; die Zeit selbst signalisiert den Zustand.
  Widget _fabContentWithTimer(
      int activeCount, RecipeTimer t, AppLocalizations l) {
    final finished = t.isFinished;
    return SizedBox(
      height: 80, // gleicher vertikaler Footprint wie _fabContent → kein Sprung
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: _fabSize,
            padding: const EdgeInsets.fromLTRB(18, 0, 6, 0),
            decoration: BoxDecoration(
              color: _orange,
              borderRadius: BorderRadius.circular(_fabSize / 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(finished ? Icons.alarm_on_rounded : Icons.timer_rounded,
                    color: Colors.white, size: 19),
                const SizedBox(width: 7),
                Text(finished ? l.finished : t.displayTime,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFeatures: [FontFeature.tabularFigures()])),
                const SizedBox(width: 12),
                // Flamme am rechten Ende — leicht abgesetzter Kreis, damit sie
                // sich vom Countdown abhebt und als „der Badge" lesbar bleibt.
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                  child: const Icon(Icons.local_fire_department_rounded,
                      color: Colors.white, size: 26),
                ),
              ],
            ),
          ),
          if (activeCount > 1)
            Positioned(
              top: (80 - _fabSize) / 2 - 2,
              right: 0,
              child: _countBadge(activeCount),
            ),
        ],
      ),
    );
  }

  /// Kleiner Zähler-Punkt (Anzahl aktiver Rezepte) — geteilt zwischen rundem und
  /// Pillen-Badge.
  Widget _countBadge(int activeCount) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          '$activeCount',
          style: const TextStyle(
            color: _orange,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }

  Widget _fabContent(int activeCount, bool hasActiveTimers) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          if (hasActiveTimers)
            AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) {
                final t = _pulse.value;
                final size = _fabSize + (70 - _fabSize) * t;
                final opacity = (1 - t).clamp(0.0, 1.0);
                return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _orange.withValues(alpha: 0.5 * opacity),
                      width: 3,
                    ),
                  ),
                );
              },
            ),
          Container(
            width: _fabSize,
            height: _fabSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _orange,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          if (activeCount > 1)
            Positioned(
              top: (80 - _fabSize) / 2 - 8,
              right: (80 - _fabSize) / 2 - 8,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    '$activeCount',
                    style: const TextStyle(
                      color: _orange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// WithCookingModeFAB — 1:1 port of Swift's WithCookingModeFAB modifier:
//
//   content.overlay(alignment: .bottomTrailing) {
//       CookingModeFAB().padding(.trailing, 20).padding(.bottom, 20)
//   }
//
// Apply per-screen (HomeScreen, RecipeDetailScreen) the same way Swift does
// via `.withCookingModeFAB()`. Other screens deliberately don't get the FAB,
// matching iOS behavior. When the CookingModeScreen is pushed it sits on top
// of the previous route, so the underlying screen's FAB is naturally hidden
// — no global state flag needed.
// ---------------------------------------------------------------------------

class WithCookingModeFAB extends ConsumerWidget {
  final Widget child;

  /// Zusätzlicher Abstand von unten — auf Screens mit der GlassTabBar wird
  /// hier die Bar-Höhe übergeben, damit der FAB nicht über der Navigation klebt.
  final double bottomInset;

  const WithCookingModeFAB({
    super.key,
    required this.child,
    this.bottomInset = 20,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offset = ref.watch(cookingFabOffsetProvider);
    return Stack(
      children: [
        Positioned.fill(child: child),
        // Der FAB ist per Drag frei beweglich (Standard: unten rechts).
        DraggableOverlay(
          offset: offset,
          onMoved: (o) => ref.read(cookingFabOffsetProvider.notifier).state = o,
          defaultRight: 20,
          defaultBottom: bottomInset,
          child: const SafeArea(child: CookingModeFAB()),
        ),
      ],
    );
  }
}
