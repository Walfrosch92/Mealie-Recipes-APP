import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/models/timeline_event.dart';
import '../../../core/services/local_cache.dart';
import '../../../core/services/log_manager.dart';
import '../../recipes/providers/recipes_provider.dart';

// ---------------------------------------------------------------------------
// Zeitleiste — Cache-first (Offline-Prinzip): sofort den letzten Stand aus
// dem lokalen Cache, im Hintergrund frisch vom Server; schlägt das fehl,
// bleibt der Cache stehen.
//
//   recipeTimelineProvider(recipeId) — Einträge EINES Rezepts (Detailansicht)
//   globalTimelineProvider           — alle Rezepte, seitenweise (Home-Kachel)
// ---------------------------------------------------------------------------

final recipeTimelineProvider = AsyncNotifierProvider.family<
    RecipeTimelineNotifier, List<TimelineEvent>, String>(
  RecipeTimelineNotifier.new,
);

class RecipeTimelineNotifier
    extends FamilyAsyncNotifier<List<TimelineEvent>, String> {
  String get _key => 'timeline_$arg';

  @override
  Future<List<TimelineEvent>> build(String arg) async {
    final api = ref.watch(apiServiceProvider);
    final cached = (await LocalCache.loadJsonList(_key))
        .map(TimelineEvent.tryParse)
        .whereType<TimelineEvent>()
        .toList();
    Future<List<TimelineEvent>> fetch() async {
      final fresh = await api.fetchTimelineEvents(recipeId: arg, perPage: 200);
      await LocalCache.saveJsonList(_key, fresh.map((e) => e.toJson()));
      return fresh;
    }

    if (cached.isNotEmpty) {
      Future(() async {
        try {
          state = AsyncData(await fetch());
        } catch (_) {/* Cache behalten */}
      });
      return cached;
    }
    try {
      return await fetch();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _store(List<TimelineEvent> list) async {
    state = AsyncData(list);
    await LocalCache.saveJsonList(_key, list.map((e) => e.toJson()));
  }

  void insertLocal(TimelineEvent ev) {
    final list = [...state.valueOrNull ?? const <TimelineEvent>[], ev]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _store(list);
  }

  void _replace(TimelineEvent ev) {
    final list = [
      for (final e in state.valueOrNull ?? const <TimelineEvent>[])
        e.id == ev.id ? ev : e,
    ];
    _store(list);
  }

  Future<void> delete(TimelineEvent ev) async {
    await ref.read(apiServiceProvider).deleteTimelineEvent(ev.id);
    await _store([
      for (final e in state.valueOrNull ?? const <TimelineEvent>[])
        if (e.id != ev.id) e,
    ]);
    if (ref.exists(globalTimelineProvider)) {
      ref.read(globalTimelineProvider.notifier).removeLocal(ev.id);
    }
  }

  Future<void> updateMessage(TimelineEvent ev, String message) async {
    final updated = ev.copyWith(message: message.trim());
    await ref.read(apiServiceProvider).updateTimelineEvent(updated);
    _replace(updated);
    if (ref.exists(globalTimelineProvider)) {
      ref.read(globalTimelineProvider.notifier).replaceLocal(updated);
    }
  }
}

/// Ergebnis von [recordRecipeMade].
enum MadeThisResult { ok, imageFailed }

/// „Ich hab's gekocht" — wie der Dialog der Mealie-Webapp:
///  1. Zeitleisten-Eintrag (Typ `comment`, Betreff „Name hat das gekocht")
///  2. `lastMade` setzen, falls der Zeitpunkt neuer ist
///  3. optionales Foto an den Eintrag hängen
/// Wirft, wenn der Eintrag selbst nicht angelegt werden konnte. Läuft über
/// den [container] (`ProviderScope.containerOf(context)`), darf also auch
/// nach dem Schließen eines Screens weiterlaufen (Kochmodus-Abschluss).
Future<MadeThisResult> recordRecipeMade(
  ProviderContainer container, {
  required RecipeDetail recipe,
  required String subject,
  String? message,
  DateTime? when,
  File? photo,
  List<ReferencedRecipe> childRecipes = const [],
  String Function(String parentName)? childMessage,
}) async {
  final api = container.read(apiServiceProvider);
  final timestamp = when ?? DateTime.now();
  var ev = await api.createTimelineEvent(
    recipeId: recipe.id,
    subject: subject,
    message: message,
    timestamp: timestamp,
  );

  final last = DateTime.tryParse(recipe.lastMade ?? '');
  if (last == null || timestamp.isAfter(last)) {
    try {
      await api.updateLastMade(recipe.slug, timestamp);
      await container.read(recipesProvider.notifier).upsertOne(
          recipe.copyWith(lastMade: timestamp.toUtc().toIso8601String()));
    } catch (e) {
      LogManager.shared.log('⚠️ Zuletzt gekocht nicht gesetzt: $e');
    }
  }

  // Verlinkte Unterrezepte (Webapp: Häkchen im Dialog) — eigener Eintrag
  // „Gemacht für <Rezept>" ohne Foto, lastMade nur wenn neuer. Fehler hier
  // brechen den Haupteintrag nicht ab.
  final all = container.read(recipesProvider).valueOrNull ?? const [];
  for (final child in childRecipes) {
    try {
      await api.createTimelineEvent(
        recipeId: child.id,
        subject: subject,
        message: childMessage?.call(recipe.name),
        timestamp: timestamp,
      );
      RecipeDetail? full;
      for (final r in all) {
        if (r.id == child.id) full = r;
      }
      final childLast = DateTime.tryParse(full?.lastMade ?? '');
      if (childLast == null || timestamp.isAfter(childLast)) {
        await api.updateLastMade(child.slug, timestamp);
        if (full != null) {
          await container.read(recipesProvider.notifier).upsertOne(
              full.copyWith(lastMade: timestamp.toUtc().toIso8601String()));
        }
      }
      if (container.exists(recipeTimelineProvider(child.id))) {
        container.invalidate(recipeTimelineProvider(child.id));
      }
    } catch (e) {
      LogManager.shared.log('⚠️ Zeitleiste Unterrezept ${child.slug}: $e');
    }
  }

  var result = MadeThisResult.ok;
  if (photo != null) {
    try {
      await api.uploadTimelineEventImage(ev.id, photo);
      ev = ev.copyWith(hasImage: true);
    } catch (e) {
      LogManager.shared.log('❌ Zeitleisten-Foto fehlgeschlagen: $e');
      result = MadeThisResult.imageFailed;
    }
  }

  try {
    container.read(recipeTimelineProvider(recipe.id).notifier).insertLocal(ev);
  } catch (_) {/* Provider evtl. nicht aktiv */}
  container.invalidate(globalTimelineProvider);
  return result;
}

// ---------------------------------------------------------------------------
// Rezeptübergreifende Zeitleiste (Home-Kachel)
// ---------------------------------------------------------------------------

class GlobalTimelineState {
  final List<TimelineEvent> events;
  final bool hasMore;
  final bool loadingMore;
  const GlobalTimelineState(
      {this.events = const [], this.hasMore = true, this.loadingMore = false});

  GlobalTimelineState copyWith(
          {List<TimelineEvent>? events, bool? hasMore, bool? loadingMore}) =>
      GlobalTimelineState(
        events: events ?? this.events,
        hasMore: hasMore ?? this.hasMore,
        loadingMore: loadingMore ?? this.loadingMore,
      );
}

final globalTimelineProvider =
    AsyncNotifierProvider<GlobalTimelineNotifier, GlobalTimelineState>(
        GlobalTimelineNotifier.new);

class GlobalTimelineNotifier extends AsyncNotifier<GlobalTimelineState> {
  static const _key = 'timeline_all';
  static const _perPage = 30;
  int _page = 1;

  @override
  Future<GlobalTimelineState> build() async {
    final api = ref.watch(apiServiceProvider);
    _page = 1;
    final cached = (await LocalCache.loadJsonList(_key))
        .map(TimelineEvent.tryParse)
        .whereType<TimelineEvent>()
        .toList();
    Future<GlobalTimelineState> fetch() async {
      final fresh = await api.fetchTimelineEvents(page: 1, perPage: _perPage);
      await LocalCache.saveJsonList(_key, fresh.map((e) => e.toJson()));
      return GlobalTimelineState(
          events: fresh, hasMore: fresh.length >= _perPage);
    }

    if (cached.isNotEmpty) {
      Future(() async {
        try {
          state = AsyncData(await fetch());
        } catch (_) {/* Cache behalten */}
      });
      return GlobalTimelineState(events: cached, hasMore: false);
    }
    return fetch();
  }

  Future<void> refresh() async {
    try {
      final api = ref.read(apiServiceProvider);
      final fresh = await api.fetchTimelineEvents(page: 1, perPage: _perPage);
      _page = 1;
      await LocalCache.saveJsonList(_key, fresh.map((e) => e.toJson()));
      state = AsyncData(GlobalTimelineState(
          events: fresh, hasMore: fresh.length >= _perPage));
    } catch (_) {/* Stand behalten */}
  }

  Future<void> loadMore() async {
    final cur = state.valueOrNull;
    if (cur == null || !cur.hasMore || cur.loadingMore) return;
    state = AsyncData(cur.copyWith(loadingMore: true));
    try {
      final next = await ref
          .read(apiServiceProvider)
          .fetchTimelineEvents(page: _page + 1, perPage: _perPage);
      _page++;
      final seen = cur.events.map((e) => e.id).toSet();
      state = AsyncData(GlobalTimelineState(
        events: [...cur.events, ...next.where((e) => !seen.contains(e.id))],
        hasMore: next.length >= _perPage,
      ));
    } catch (_) {
      state = AsyncData(cur.copyWith(loadingMore: false));
    }
  }

  void _set(List<TimelineEvent> events) {
    final cur = state.valueOrNull;
    if (cur == null) return;
    state = AsyncData(cur.copyWith(events: events));
    LocalCache.saveJsonList(_key, events.map((e) => e.toJson()));
  }

  void removeLocal(String id) {
    final cur = state.valueOrNull;
    if (cur == null) return;
    _set(cur.events.where((e) => e.id != id).toList());
  }

  void replaceLocal(TimelineEvent ev) {
    final cur = state.valueOrNull;
    if (cur == null) return;
    _set([for (final e in cur.events) e.id == ev.id ? ev : e]);
  }
}
