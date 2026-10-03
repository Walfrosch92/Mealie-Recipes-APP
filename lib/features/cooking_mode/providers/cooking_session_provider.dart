import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/recipe_detail.dart';
import '../../../core/services/watch_bridge.dart';

// ---------------------------------------------------------------------------
// Cooking session state
// ---------------------------------------------------------------------------

class CookingSession {
  final String slug;
  final RecipeDetail recipe;
  final List<bool> completedIngredients;
  final List<bool> completedInstructions;

  /// Abgehakte Utensilien (Mealie `tools`), nur lokal.
  final List<bool> completedTools;
  final double quantityMultiplier;

  /// Aktuelle SEITE des Kochmodus (Name historisch): [toolsPage] (falls
  /// Utensilien hinterlegt) → [prepPage] (Zutaten) → Schritte → Abschluss.
  final int currentInstructionIndex;

  CookingSession({
    required this.slug,
    required this.recipe,
    List<bool>? completedIngredients,
    List<bool>? completedInstructions,
    List<bool>? completedTools,
    this.quantityMultiplier = 1.0,
    this.currentInstructionIndex = 0,
  })  : completedIngredients = completedIngredients ??
            List.filled(recipe.recipeIngredient.length, false),
        completedInstructions = completedInstructions ??
            List.filled(recipe.recipeInstructions.length, false),
        completedTools = (completedTools != null &&
                completedTools.length == recipe.tools.length)
            ? completedTools
            : List.filled(recipe.tools.length, false);

  // ── Seitenaufbau ─────────────────────────────────────────────────────────
  // Utensilien-Seite nur, wenn welche hinterlegt sind — sonst wie bisher
  // (Seite 0 = Zutaten).

  /// 1 wenn es eine Utensilien-Seite gibt, sonst 0.
  int get toolsPageCount => recipe.tools.isNotEmpty ? 1 : 0;

  /// Seite „Zutaten vorbereiten".
  int get prepPage => toolsPageCount;

  /// Seite des ersten Kochschritts; Schritt i liegt auf firstStepPage + i.
  int get firstStepPage => prepPage + 1;

  /// Utensilien + Zutaten + Schritte + Abschluss.
  int get pageCount => firstStepPage + recipe.recipeInstructions.length + 1;

  /// Seitenaufbau-Version für die Persistenz: 2 = mit Utensilien-Seite.
  static const _pageLayout = 2;

  // Persistenz (siehe CookingSessionsNotifier): eine aktive Kochsession muss
  // einen Prozess-Kill überleben — sonst „beendet" ein vom System abgeräumter
  // Hintergrund-Prozess (gesperrtes Gerät + abgelaufener Timer ohne laufenden
  // Foreground-Service) den Kochmodus, sobald der Nutzer die App über die
  // Timer-Benachrichtigung wieder öffnet (Kaltstart → leere Session).
  Map<String, dynamic> toJson() => {
        'slug': slug,
        'recipe': recipe.toJson(),
        'completedIngredients': completedIngredients,
        'completedInstructions': completedInstructions,
        'completedTools': completedTools,
        'quantityMultiplier': quantityMultiplier,
        'currentInstructionIndex': currentInstructionIndex,
        'pageLayout': _pageLayout,
      };

  factory CookingSession.fromJson(Map<String, dynamic> json) {
    final recipe =
        RecipeDetail.fromJson(Map<String, dynamic>.from(json['recipe'] as Map));
    var page = json['currentInstructionIndex'] as int? ?? 0;
    // Vor der Utensilien-Seite gespeicherte Session: ihre Seitenzahl bezog
    // sich auf den alten Aufbau (0 = Zutaten) → um die neue Seite verschieben,
    // damit man nach dem Update beim selben Schritt weiterkocht.
    if ((json['pageLayout'] as int? ?? 1) < _pageLayout &&
        recipe.tools.isNotEmpty) {
      page += 1;
    }
    return CookingSession(
      slug: json['slug'] as String,
      recipe: recipe,
      completedIngredients:
          (json['completedIngredients'] as List?)?.cast<bool>(),
      completedInstructions:
          (json['completedInstructions'] as List?)?.cast<bool>(),
      completedTools: (json['completedTools'] as List?)?.cast<bool>(),
      quantityMultiplier:
          (json['quantityMultiplier'] as num?)?.toDouble() ?? 1.0,
      currentInstructionIndex: page,
    );
  }

  CookingSession copyWith({
    RecipeDetail? recipe,
    List<bool>? completedIngredients,
    List<bool>? completedInstructions,
    List<bool>? completedTools,
    double? quantityMultiplier,
    int? currentInstructionIndex,
  }) {
    return CookingSession(
      slug: slug,
      recipe: recipe ?? this.recipe,
      completedIngredients: completedIngredients ?? this.completedIngredients,
      completedInstructions:
          completedInstructions ?? this.completedInstructions,
      completedTools: completedTools ?? this.completedTools,
      quantityMultiplier: quantityMultiplier ?? this.quantityMultiplier,
      currentInstructionIndex:
          currentInstructionIndex ?? this.currentInstructionIndex,
    );
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

/// In `main()` mit den aus SharedPreferences vorab geladenen Sessions
/// überschrieben (per ProviderScope.overrides), damit der Kochmodus nach einem
/// Prozess-Kill (Kaltstart über die Timer-Benachrichtigung) sofort wieder da
/// ist. Default leer — die App bleibt ohne Override startbar (Tests).
final initialCookingSessionsProvider =
    Provider<List<CookingSession>>((ref) => const []);

final cookingSessionsProvider =
    NotifierProvider<CookingSessionsNotifier, List<CookingSession>>(
        CookingSessionsNotifier.new);

class CookingSessionsNotifier extends Notifier<List<CookingSession>> {
  static const _kKey = 'cooking_sessions_v1';

  /// Signatur des zuletzt an die Uhr gepushten Kochmodus-Navigationszustands
  /// — verhindert redundante Pushes bei Mutationen, die weder „Kochmodus
  /// aktiv" noch die Vor/Zurück-Verfügbarkeit ändern (z. B. Zutat abhaken).
  /// `null` = aktuell kein Kochmodus auf der Uhr gemeldet.
  String? _lastCookingWatchSig;

  @override
  List<CookingSession> build() {
    // Smartwatch: Navigations-Aktionen (vor/zurück) von der Uhr empfangen und
    // auf die "aktive" Session (siehe _pushCookingStateToWatch) anwenden.
    // Idempotent installiert; No-op außerhalb Android/iOS.
    WatchBridge.ensureActionListener();
    WatchBridge.cookingActionHandler = _handleWatchStepAction;
    return ref.read(initialCookingSessionsProvider);
  }

  /// Lädt die persistierten Sessions (Aufruf in `main()` vor runApp).
  static Future<List<CookingSession>> loadPersisted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kKey);
      if (raw == null || raw.isEmpty) return const [];
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => CookingSession.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  /// Schreibt den aktuellen Stand fire-and-forget zurück. Wird nach JEDER
  /// Mutation gerufen — so überlebt der genaue Fortschritt (aktueller Schritt,
  /// abgehakte Zutaten/Schritte, Skalierung) einen Prozess-Kill.
  void _persist() {
    final snapshot = jsonEncode(state.map((s) => s.toJson()).toList());
    SharedPreferences.getInstance()
        .then((p) => p.setString(_kKey, snapshot))
        .catchError((_) => false);
    _pushCookingStateToWatch();
  }

  /// Seitenzahl einer Session (Utensilien?, Zutaten, Schritte, Abschluss) —
  /// siehe [CookingSession.pageCount], mirrors cooking_mode_screen.
  static int _pageCount(CookingSession s) => s.pageCount;

  static int _page(CookingSession s) =>
      s.currentInstructionIndex.clamp(0, _pageCount(s) - 1);

  /// Meldet der Uhr Vor/Zurück-Verfügbarkeit für die „aktive" Kochsession —
  /// bei mehreren gleichzeitig offenen Rezepten (seltener Fall, z. B. Cook-
  /// Friends) bewusst vereinfacht auf die ZUERST gestartete Session (`first`),
  /// analog dazu wie TimerNotifier._updateLiveActivity ohne Rezept-Bezug einen
  /// einzigen Zustand für die Uhr wählt. Kein Kochmodus mehr aktiv → Uhr fällt
  /// auf die Einkaufsliste zurück (clearCookingMode).
  void _pushCookingStateToWatch() {
    final first = state.firstOrNull;
    if (first == null) {
      if (_lastCookingWatchSig != null) {
        _lastCookingWatchSig = null;
        WatchBridge.clearCookingMode();
      }
      return;
    }
    final page = _page(first);
    final pageCount = _pageCount(first);
    final canBack = page > 0;
    final canNext = page < pageCount - 1;
    final sig = '${first.slug}|$page|$pageCount';
    if (sig == _lastCookingWatchSig) return;
    _lastCookingWatchSig = sig;
    WatchBridge.updateCookingMode(canBack: canBack, canNext: canNext);
  }

  /// Wendet eine von der Uhr empfangene Navigations-Aktion (`next`/`previous`)
  /// auf dieselbe „aktive" Session an, die auch an die Uhr gemeldet wurde
  /// (siehe _pushCookingStateToWatch).
  void _handleWatchStepAction(String action) {
    final first = state.firstOrNull;
    if (first == null) return;
    final page = _page(first);
    final pageCount = _pageCount(first);
    final target = action == 'next' ? page + 1 : page - 1;
    if (target < 0 || target >= pageCount) return;
    setInstructionIndex(first.slug, target);
  }

  void startSession(RecipeDetail recipe) {
    // Key sessions by recipe.id (the canonical identifier used by routes/detail)
    final existing = state.indexWhere((s) => s.slug == recipe.id);
    if (existing != -1) return; // already active
    state = [...state, CookingSession(slug: recipe.id, recipe: recipe)];
    _persist();
  }

  void endSession(String slug) {
    state = state.where((s) => s.slug != slug).toList();
    _persist();
  }

  void endAll() {
    state = [];
    _persist();
  }

  CookingSession? getSession(String slug) {
    try {
      return state.firstWhere((s) => s.slug == slug);
    } catch (_) {
      return null;
    }
  }

  void toggleIngredient(String slug, int index) {
    state = state.map((s) {
      if (s.slug != slug) return s;
      final updated = List<bool>.from(s.completedIngredients);
      updated[index] = !updated[index];
      return s.copyWith(completedIngredients: updated);
    }).toList();
    _persist();
  }

  void toggleTool(String slug, int index) {
    state = state.map((s) {
      if (s.slug != slug || index < 0 || index >= s.completedTools.length) {
        return s;
      }
      final updated = List<bool>.from(s.completedTools);
      updated[index] = !updated[index];
      return s.copyWith(completedTools: updated);
    }).toList();
    _persist();
  }

  void toggleInstruction(String slug, int index) {
    state = state.map((s) {
      if (s.slug != slug) return s;
      final updated = List<bool>.from(s.completedInstructions);
      updated[index] = !updated[index];
      return s.copyWith(completedInstructions: updated);
    }).toList();
    _persist();
  }

  void setMultiplier(String slug, double multiplier) {
    state = state.map((s) {
      if (s.slug != slug) return s;
      return s.copyWith(quantityMultiplier: multiplier);
    }).toList();
    _persist();
  }

  void setInstructionIndex(String slug, int index) {
    state = state.map((s) {
      if (s.slug != slug) return s;
      return s.copyWith(currentInstructionIndex: index);
    }).toList();
    _persist();
  }

  // Spiegelt eine im Detail-Screen oder im Kochmodus selbst geänderte
  // Notizliste in eine ggf. aktive Session desselben Rezepts (Rezept-id).
  // No-op, falls dafür keine Session läuft.
  void updateRecipeNotes(String recipeId, List<RecipeNote> notes) {
    state = state.map((s) {
      if (s.slug != recipeId) return s;
      return s.copyWith(recipe: s.recipe.copyWith(notes: notes));
    }).toList();
    _persist();
  }
}
