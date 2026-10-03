import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/app_settings.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/utils/platform_features.dart';
import '../../webapp_tools/widgets/recipe_web_tools.dart';
import '../../../core/api/api_service.dart';
import '../../../core/services/log_manager.dart';
import '../../../core/utils/ingredient_display.dart' as ingdisp;
import '../../../core/utils/yield_format.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/ingredient_section_header.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/markdown_text.dart';
import '../../../shared/widgets/send_fly_animation.dart';
import '../providers/detail_sections.dart';
import '../providers/recipes_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/recipe_comments_section.dart';
import '../widgets/recipe_assets_section.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../timeline/widgets/recipe_timeline_section.dart';
import '../widgets/recipe_notes_list.dart';
import '../../cooking_mode/providers/cooking_session_provider.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../../mealplan/providers/mealplan_provider.dart';
import '../../shopping_list/providers/shopping_list_provider.dart';
import '../../recipe_send/services/recipe_send_service.dart';
import '../services/recipe_pdf_service.dart';
import '../../../shared/widgets/recipe_image.dart';
import '../../../shared/widgets/recipe_image_viewer.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final String slug;
  const RecipeDetailScreen({super.key, required this.slug});

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  double _multiplier = 1.0;
  int _detailTab = 0; // 0 = Zutaten, 1 = Zubereitung
  final Set<int> _checkedIngredients = {};

  /// Abgehakte Utensilien (nur lokal, wie die Zutaten-Häkchen).
  final Set<int> _checkedTools = {};
  final Set<int> _completedSteps = {};
  // Busy-Flags für die „in den Wagen"-Buttons (zeigen die Warenkorb-Animation).
  bool _addingAll = false;
  bool _addingSelected = false;

  // Hero-Bild bewusst STARR (2026-09-27, User-Wunsch): der frühere
  // Stretchy-Header (Bild wächst beim Herunterziehen, BouncingScrollPhysics)
  // wackelte. Jetzt klemmt die Seite oben (ClampingScrollPhysics, kein
  // Android-Stretch), das Bild behält seine 320 px — Tippen öffnet es groß
  // (showRecipeImageViewer).

  // Zurück: nur poppen, wenn der Stack das hergibt — sonst hart auf die
  // Rezeptliste. Verhindert „There is nothing to pop", falls die Detailansicht
  // ausnahmsweise nicht gepusht (sondern als Stack-Wurzel) erreicht wurde.
  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/recipes');
    }
  }

  Future<void> _toggleFavorite(RecipeDetail recipe) async {
    HapticFeedback.lightImpact();
    try {
      await ref
          .read(favoritesProvider.notifier)
          .toggle(id: recipe.id, slug: recipe.slug);
    } catch (_) {
      if (!mounted) return;
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.errorLoadingRecipe)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Rezept war in dieser Sitzung schon offen (Provider lebt noch): still
    // beim Server nachsehen, ob es inzwischen woanders geändert wurde.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(recipeDetailProvider(widget.slug).notifier).checkForUpdates();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final recipeAsync = ref.watch(recipeDetailProvider(widget.slug));
    final settings = ref.watch(settingsProvider).valueOrNull;

    return recipeAsync.when(
      loading: () => Scaffold(
        backgroundColor: context.appBg,
        appBar: AppBar(
          leading: _BackButton(onTap: () => _goBack(context)),
          title: Text(l.details),
        ),
        body: Center(
            child: Text(l.loadingRecipe,
                style: TextStyle(color: context.appFgSub))),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: context.appBg,
        appBar: AppBar(
          leading: _BackButton(onTap: () => _goBack(context)),
          title: Text(l.details),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l.errorLoadingRecipe,
                  style: TextStyle(color: context.appFgSub)),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.refresh(recipeDetailProvider(widget.slug)),
                child: Text(l.retry),
              ),
            ],
          ),
        ),
      ),
      data: (recipe) => _buildDetail(context, recipe, settings),
    );
  }

  Widget _buildDetail(
      BuildContext context, RecipeDetail recipe, AppSettings? settings) {
    final l = AppLocalizations.of(context)!;

    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    const ctaBarHeight = 56.0;
    final ctaReserve = ctaBarHeight + bottomSafe + 30;
    final isFavorite =
        ref.watch(favoritesProvider).valueOrNull?.contains(recipe.id) ?? false;

    return Scaffold(
      backgroundColor: context.appBg,
      extendBodyBehindAppBar: true,
      body: WithCookingModeFAB(
        bottomInset: ctaReserve + 8,
        child: Stack(
          children: [
            ScrollConfiguration(
              // kein Android-Stretch-Overscroll, der das Bild verzerren würde
              behavior:
                  ScrollConfiguration.of(context).copyWith(overscroll: false),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(bottom: ctaReserve),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full-bleed Hero-Header: Bild + Scrim + Blur-Nav + Titel/Meta
                    _HeroHeader(
                      recipe: recipe,
                      settings: settings,
                      multiplier: _multiplier,
                      isFavorite: isFavorite,
                      onFavorite: () => _toggleFavorite(recipe),
                      onBack: () => _goBack(context),
                      onMore: () => _showMoreOptionsSheet(context, recipe),
                    ),

                    // Inhalts-Sheet mit abgerundeter Oberkante, das den Hero überlappt
                    Transform.translate(
                      offset: const Offset(0, -22),
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.appBg,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24)),
                        ),
                        // Große Anzeige (Windows/macOS): Inhalt als zentrierte
                        // Lesespalte statt über die ganze Fensterbreite.
                        padding: EdgeInsets.only(
                          top: 10,
                          left: LargeScreen.inset(context),
                          right: LargeScreen.inset(context),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Grip
                            Center(
                              child: Container(
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: context.appSeparator,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Bewertung (antippbar)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: _RatingRow(
                                recipe: recipe,
                                onRate: (v) => _setRating(recipe, v),
                              ),
                            ),

                            // Description
                            if (recipe.description != null &&
                                recipe.description!.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 12, 16, 0),
                                child: Text(
                                  recipe.description!,
                                  style: TextStyle(
                                      color: context.appFgSub, fontSize: 14),
                                ),
                              ),

                            // Ursprüngliche URL (Mealie `orgURL`) — nur wenn
                            // eine Web-Adresse hinterlegt ist.
                            if (_originalUri(recipe) != null)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 12, 16, 0),
                                child: _OriginalUrlButton(
                                    uri: _originalUri(recipe)!),
                              ),

                            const SizedBox(height: 16),

                            // Aktionen zwischen Beschreibung und Zutaten/Zubereitung:
                            // „Zutaten in den Warenkorb" + „Mahlzeit planen".
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: _ActionButton(
                                icon: Icons.shopping_cart_outlined,
                                label: l.addAllIngredients,
                                color: const Color(0xFF0A84FF),
                                busy: _addingAll,
                                onTap: () =>
                                    _addAllIngredients(context, recipe),
                              ),
                            ),
                            if (_checkedIngredients.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: _ActionButton(
                                  icon: Icons.playlist_add_check,
                                  label: l.addSelectedIngredients,
                                  color: const Color(0xFF30D158),
                                  busy: _addingSelected,
                                  onTap: () =>
                                      _addSelectedIngredients(context, recipe),
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: _ActionButton(
                                icon: Icons.calendar_month_outlined,
                                label: l.planMeal,
                                color: const Color(0xFF0A84FF),
                                onTap: () => _showPlanSheet(context, recipe),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Segment-Control: Zutaten | Zubereitung (wie im Mockup)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: _SegmentControl(
                                labels: [l.ingredients, l.instructions],
                                selected: _detailTab,
                                onChanged: (i) =>
                                    setState(() => _detailTab = i),
                              ),
                            ),
                            const SizedBox(height: 16),

                            if (_detailTab == 0) ...[
                              // Portionen-Stepper
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: _PortionStepper(
                                  recipeYield: recipe.recipeYield,
                                  multiplier: _multiplier,
                                  onChanged: (v) =>
                                      setState(() => _multiplier = v),
                                ),
                              ),
                              const SizedBox(height: 6),
                              _IngredientsContent(
                                recipe: recipe,
                                multiplier: _multiplier,
                                checked: _checkedIngredients,
                                onToggleCheck: (i) {
                                  setState(() {
                                    if (_checkedIngredients.contains(i)) {
                                      _checkedIngredients.remove(i);
                                    } else {
                                      _checkedIngredients.add(i);
                                    }
                                  });
                                },
                              ),
                              const SizedBox(height: 4),
                            ] else ...[
                              _InstructionsContent(
                                recipe: recipe,
                                settings: settings,
                                completed: _completedSteps,
                                onToggle: (i) {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    if (_completedSteps.contains(i)) {
                                      _completedSteps.remove(i);
                                    } else {
                                      _completedSteps.add(i);
                                    }
                                  });
                                },
                              ),
                            ],

                            const SizedBox(height: 16),

                            // Tags
                            if (recipe.tags.isNotEmpty ||
                                recipe.recipeCategory.isNotEmpty) ...[
                              _TagsSection(recipe: recipe),
                              const SizedBox(height: 16),
                            ],

                            // Nährwerte (Mealie `nutrition`) — wie im Web nur, wenn am Rezept
                            // „Nährwerte anzeigen" aktiv ist und Werte hinterlegt sind.
                            if (recipe.nutrition.isNotEmpty &&
                                (recipe.settings?.showNutrition ?? true)) ...[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: _NutritionSection(
                                    nutrition: recipe.nutrition),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Benötigte Utensilien (Mealie `tools`) — nur wenn hinterlegt,
                            // sonst bleibt die Ansicht wie bisher.
                            if (recipe.tools.isNotEmpty) ...[
                              _ToolsSection(
                                tools: recipe.tools,
                                checked: _checkedTools,
                                onToggle: (i) {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    if (!_checkedTools.remove(i)) {
                                      _checkedTools.add(i);
                                    }
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Anhänge (Mealie `assets`: PDFs, Bilder, Textdateien).
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: RecipeAssetsSection(
                                recipe: recipe,
                                editable: recipeEditAccess(
                                        ref.watch(userPermissionsProvider),
                                        recipe) ==
                                    RecipeEditAccess.allowed,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Notizen (Mealie-Rezeptnotizen: Titel+Text, inline editierbar).
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: RecipeNotesList(
                                  recipe: recipe,
                                  // Notizen gehören zum Rezept → gleiche Regel wie Bearbeiten.
                                  editable: recipeEditAccess(
                                          ref.watch(userPermissionsProvider),
                                          recipe) ==
                                      RecipeEditAccess.allowed,
                                  collapsible: true),
                            ),

                            // Kommentare (Mealie) unter den Notizen — wie im Web ausgeblendet,
                            // wenn sie am Rezept deaktiviert sind.
                            if (!(recipe.settings?.disableComments ??
                                false)) ...[
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: RecipeCommentsSection(recipe: recipe),
                              ),
                            ],

                            // Zeitleiste („Ich hab's gekocht" mit Foto) — wie die Webapp.
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: RecipeTimelineSection(recipe: recipe),
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Sticky „Kochen starten"-CTA
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _StartCookingCTA(
                label: l.startCooking,
                onTap: () {
                  final n = ref.read(cookingSessionsProvider.notifier);
                  n.startSession(recipe);
                  // Skalierung/Portionen aus der Detailansicht übernehmen — der
                  // Kochmodus rechnet NICHT neu, sondern nutzt diesen Multiplikator.
                  n.setMultiplier(recipe.id, _multiplier);
                  context.push('/cooking/${recipe.id}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addAllIngredients(
      BuildContext context, RecipeDetail recipe) async {
    if (_addingAll) return;
    final l = AppLocalizations.of(context)!;
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings == null || settings.shoppingListId.isEmpty) return;
    final notifier = ref.read(shoppingListProvider.notifier);
    setState(() => _addingAll = true);
    // Vom Server abgelehnte Zutaten (HTTP 422/500) zählen — vorher wurden
    // die still verschluckt und der Erfolgs-Snackbar log.
    var failed = 0;
    // „Im Haushalt vorrätig" überspringen (Mealie-Web wählt sie ab).
    var skipped = 0;
    try {
      final onHand = await notifier.onHandChecker();
      bool skipIf(Ingredient ing) {
        final hit = onHand(ing);
        if (hit) skipped++;
        return hit;
      }

      // Wie Mealies „Zur Einkaufsliste" (inkl. Rezept-Verknüpfung), dann
      // einmal refreshen, damit die Server-Labels gemeinsam ankommen.
      failed = await notifier.addRecipe(
        shoppingListId: settings.shoppingListId,
        recipe: recipe,
        multiplier: _multiplier,
        skipIf: skipIf,
      );
      await notifier.refresh();
    } finally {
      if (mounted) setState(() => _addingAll = false);
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failed > 0
            ? l.addIngredientsFailedCount(failed)
            : skipped > 0
                ? l.addIngredientsSkippedOnHand(skipped)
                : l.addIngredientsMessage),
        duration: Duration(seconds: skipped > 0 ? 3 : 2),
      ),
    );
  }

  // Add only the checked ingredients to the shopping list.
  Future<void> _addSelectedIngredients(
      BuildContext context, RecipeDetail recipe) async {
    if (_addingSelected) return;
    final l = AppLocalizations.of(context)!;
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings == null || settings.shoppingListId.isEmpty) return;
    final notifier = ref.read(shoppingListProvider.notifier);
    final indices = _checkedIngredients.toList()..sort();
    setState(() => _addingSelected = true);
    var failed = 0;
    try {
      failed = await notifier.addRecipe(
        shoppingListId: settings.shoppingListId,
        recipe: recipe,
        multiplier: _multiplier,
        ingredients: [
          for (final i in indices)
            if (i >= 0 && i < recipe.recipeIngredient.length)
              recipe.recipeIngredient[i],
        ],
      );
      await notifier.refresh();
    } finally {
      if (mounted) setState(() => _addingSelected = false);
    }
    setState(() => _checkedIngredients.clear());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failed == 0
            ? l.addIngredientsMessage
            : l.addIngredientsFailedCount(failed)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Set the recipe rating via the dedicated ratings endpoint (no full PATCH).
  // Uses recipe.slug (the ratings endpoint expects the slug, not the id).
  Future<void> _setRating(RecipeDetail recipe, double rating) async {
    final newRating =
        recipe.rating == rating ? 0.0 : rating; // tap again = clear
    HapticFeedback.selectionClick();
    try {
      await ref.read(apiServiceProvider).setRating(recipe.slug, newRating);
      // Nur das EINE Rezept neu holen: das invalidate lässt den Detail-
      // Provider rebuilden (1 Request) und der synct die Liste über
      // upsertOne. Der frühere Voll-`refresh()` der Rezeptliste lud für
      // einen Sterne-Tap ALLE Rezepte neu (150+ Requests).
      ref.invalidate(recipeDetailProvider(widget.slug));
    } catch (e) {
      // „Fehler obwohl gespeichert": auf Mobilfunk kann die ANTWORT des
      // Servers verloren gehen (Timeout/Abbruch nach dem Commit) — der POST
      // war dann erfolgreich, nur das Echo fehlte. Deshalb erst den echten
      // Server-Stand prüfen und nur meckern, wenn die Bewertung wirklich
      // nicht angekommen ist. Der Original-Fehler landet in den Logs.
      LogManager.shared.log('⭐️ Rating-Call fehlgeschlagen (${recipe.slug}, '
          '→ ${newRating.round()}): $e — verifiziere Server-Stand');
      var saved = false;
      try {
        final fresh =
            await ref.read(apiServiceProvider).fetchRecipeDetail(widget.slug);
        saved = (fresh.rating ?? 0).round() == newRating.round();
      } catch (_) {/* Server nicht erreichbar → als echten Fehler melden */}
      if (!mounted) return;
      if (saved) {
        ref.invalidate(recipeDetailProvider(widget.slug));
        return;
      }
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.ratingFailed)),
      );
    }
  }

  // Chooser vor dem eigentlichen Senden: „An Gerät senden" (bestehender
  // Peer-Flow) vs. „Als PDF exportieren" (neu). Beide sind „Rezept teilen" —
  // ein gemeinsamer Einstieg über das bestehende Share-Icon statt ein
  // weiteres Icon in die ohnehin schon fünf Buttons breite Hero-Leiste zu
  // quetschen (siehe cookbook_edit_screen-Fix für dasselbe Overflow-Risiko).
  // Vereinheitlichtes "Mehr"-Sheet (3-Punkte-Button im Hero-Header): fasst
  // Teilen (An Gerät senden + Als PDF exportieren), Bearbeiten und Löschen
  // flach in EINEM Sheet zusammen — ersetzt das frühere separate
  // Teilen-Zwischen-Sheet. Der Favoriten-Button bleibt unverändert direkt
  // im Header sichtbar, ist also nicht Teil dieses Menüs.
  void _showMoreOptionsSheet(BuildContext context, RecipeDetail recipe) {
    final l = AppLocalizations.of(context)!;
    final perms = ref.read(userPermissionsProvider);
    final editLocked =
        recipeEditAccess(perms, recipe) == RecipeEditAccess.locked;
    final mayDelete = canDeleteRecipe(perms, recipe);
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      backgroundColor: context.appCard,
      useRootNavigator: true,
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SheetHandle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              child: Text(l.recipeOptionsTitle,
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: context.appFg,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3)),
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppTokens.accent.withValues(alpha: 0.12),
                ),
                child: const Icon(Icons.devices_rounded,
                    color: AppTokens.accentDeep, size: 20),
              ),
              title: Text(l.sendToDevice,
                  style: TextStyle(
                      color: context.appFg, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(sheetCtx);
                _showSendSheet(context, recipe);
              },
            ),
            // Builder liefert einen eigenen Button-Context fürs Popover —
            // dessen RenderBox verankert das Share-Sheet (nötig, sonst
            // lehnt share_plus mit „sharePositionOrigin must be set" ab).
            // VOR dem Navigator.pop() auslesen: danach ist der Context nicht
            // mehr garantiert gültig (mirrors _showSupportDialog).
            Builder(
              builder: (btnCtx) => ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.red.withValues(alpha: 0.12),
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded,
                      color: Colors.red, size: 20),
                ),
                title: Text(l.exportAsPdf,
                    style: TextStyle(
                        color: context.appFg, fontWeight: FontWeight.w600)),
                onTap: () {
                  final box = btnCtx.findRenderObject() as RenderBox?;
                  final origin = box == null
                      ? null
                      : box.localToGlobal(Offset.zero) & box.size;
                  Navigator.pop(sheetCtx);
                  _exportPdf(context, recipe, sharePositionOrigin: origin);
                },
              ),
            ),
            // Desktop: Webapp-Funktionen (Duplizieren, Freigabe-Link,
            // Export, Rezept-Aktionen) in einem eigenen Sheet.
            if (PlatformFeatures.webAppTools)
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppTokens.accent.withValues(alpha: 0.12),
                  ),
                  child: const Icon(Icons.dashboard_customize_rounded,
                      color: AppTokens.accentDeep, size: 20),
                ),
                title: Text(l.recipeWebToolsMenu,
                    style: TextStyle(
                        color: context.appFg, fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  showRecipeWebToolsSheet(context, ref, recipe, _multiplier);
                },
              ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppTokens.accent.withValues(alpha: 0.12),
                ),
                child: const Icon(Icons.edit_outlined,
                    color: AppTokens.accentDeep, size: 20),
              ),
              title: Text(l.edit,
                  style: TextStyle(
                      color: context.appFg, fontWeight: FontWeight.w600)),
              // Gesperrtes Rezept eines anderen: wie in Mealie nur der
              // Ersteller/Admin → ausgegraut mit Begründung.
              subtitle: editLocked
                  ? Text(l.recipeLockedHint,
                      style: TextStyle(color: context.appFgSub, fontSize: 12))
                  : null,
              enabled: !editLocked,
              onTap: () {
                Navigator.pop(sheetCtx);
                context.push('/recipes/${recipe.id}/edit');
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.red.withValues(alpha: 0.12),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    color: Colors.red, size: 20),
              ),
              title: Text(l.delete,
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w600)),
              // Löschen dürfen nur Ersteller und Admins (Mealie can_delete).
              subtitle: mayDelete
                  ? null
                  : Text(l.recipeDeleteOwnerOnlyHint,
                      style: TextStyle(color: context.appFgSub, fontSize: 12)),
              enabled: mayDelete,
              onTap: () {
                Navigator.pop(sheetCtx);
                _confirmDelete(context, recipe);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // Erzeugt das PDF (Bild eingebettet, keine Server-Referenz mehr danach)
  // und öffnet das System-Share-Sheet. Läuft im Hintergrund — der Screen
  // bleibt bedienbar, ein Snackbar zeigt Fortschritt/Ergebnis.
  Future<void> _exportPdf(BuildContext context, RecipeDetail recipe,
      {Rect? sharePositionOrigin}) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final api = ref.read(apiServiceProvider);
    messenger.showSnackBar(SnackBar(
      content: Text(l.generatingPdf),
      duration: const Duration(seconds: 30),
      behavior: SnackBarBehavior.floating,
    ));
    try {
      await RecipePdfService.exportAndShare(
        recipe: recipe,
        api: api,
        multiplier: _multiplier,
        includeImage: true,
        labels: RecipePdfLabels(
          servings: l.servings,
          time: l.recipeTime,
          rating: l.rating,
          ingredients: l.ingredients,
          instructions: l.instructions,
          notes: l.notes,
          generatedBy: 'Mealie Recipes',
        ),
        sharePositionOrigin: sharePositionOrigin,
      );
      messenger.hideCurrentSnackBar();
    } catch (e) {
      LogManager.shared.log('⚠️ PDF-Export fehlgeschlagen: $e');
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(
        content: Text(l.pdfExportFailed),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  void _showSendSheet(BuildContext context, RecipeDetail recipe) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      backgroundColor: context.appCard,
      // Keine vorberechneten peers mehr — das BottomSheet ist ein
      // ConsumerWidget und macht selbst ein `ref.watch(recipeSendProvider)`,
      // damit Peers die nach dem Öffnen entdeckt werden live in der Liste
      // erscheinen (vorher: ref.read = einmaliger Snapshot, neue Devices
      // tauchten nie auf).
      builder: (_) => _SendSheet(recipe: recipe),
    );
  }

  void _showPlanSheet(BuildContext context, RecipeDetail recipe) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      backgroundColor: context.appCard,
      isScrollControlled: true,
      builder: (_) => _PlanSheet(recipe: recipe),
    );
  }

  void _confirmDelete(BuildContext context, RecipeDetail recipe) {
    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.appCard,
        title:
            Text(l.confirmDeleteTitle, style: TextStyle(color: context.appFg)),
        content: Text(l.confirmDeleteMessage,
            style: TextStyle(color: context.appFgSub)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(apiServiceProvider).deleteRecipe(recipe.id);
              } catch (e) {
                // Vorher unbehandelt: ohne Recht passierte schlicht nichts.
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(mealieErrorMessage(e) ?? l.deleteFailed)));
                }
                return;
              }
              ref.read(recipesProvider.notifier).removeById(recipe.id);
              if (context.mounted) _goBack(context);
            },
            child: Text(l.delete),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action button (full width, colored)
// ---------------------------------------------------------------------------

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool busy;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.busy = false,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  // Eager in initState erzeugen — NICHT als `late`-Lazy-Initializer. Sonst
  // würde der Controller bei einem nie „busy" gewesenen Button erst in
  // dispose() (erster Zugriff) erzeugt; das vsync/TickerMode-Lookup am bereits
  // deaktivierten Widget wirft dann „Looking up a deactivated widget's
  // ancestor is unsafe" beim Zurücknavigieren.
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100));
    if (widget.busy) _ctrl.repeat();
  }

  @override
  void didUpdateWidget(covariant _ActionButton old) {
    super.didUpdateWidget(old);
    if (widget.busy && !_ctrl.isAnimating) {
      _ctrl.repeat();
    } else if (!widget.busy && _ctrl.isAnimating) {
      _ctrl.stop();
      _ctrl.reset();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.busy ? null : widget.onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: widget.busy
            // Während die App im Hintergrund hinzufügt: Warenkorb fährt
            // wiederholt von links nach rechts durch den Button, bis fertig.
            ? LayoutBuilder(
                builder: (context, c) {
                  const cartSize = 24.0;
                  return AnimatedBuilder(
                    animation: _ctrl,
                    builder: (context, _) {
                      final dx =
                          (c.maxWidth + cartSize) * _ctrl.value - cartSize;
                      return Stack(
                        children: [
                          Positioned(
                            left: dx,
                            top: 0,
                            bottom: 0,
                            child: const Center(
                              child: Icon(Icons.shopping_cart,
                                  color: Colors.white, size: cartSize),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(widget.label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ],
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Segment-Control (Zutaten | Zubereitung) — Premium-Redesign
// ---------------------------------------------------------------------------

class _SegmentControl extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  const _SegmentControl({
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.appSeparator, width: 1),
        boxShadow: context.appShadowSm,
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = i == selected;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (active) return;
                HapticFeedback.selectionClick();
                onChanged(i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: active ? AppTokens.accentGradient : null,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: active
                      ? const [
                          BoxShadow(
                              color: Color(0x40FF7800),
                              blurRadius: 10,
                              offset: Offset(0, 3))
                        ]
                      : null,
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    color: active ? Colors.white : context.appFgSub,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Portionen-Stepper — +/- steppt WIE BISHER immer den Multiplikator um 0,5
// (1×, 1.5×, 2×, …). ZUSÄTZLICH — wenn der Yield eine erkennbare Zahl enthält
// — zeigt die Mitte statt des rohen Multiplikators die daraus resultierende
// Portionenzahl an, und diese Zahl ist antippbar für eine EXAKTE Eingabe
// (setzt den Multiplikator direkt aus Zieleingabe/Basis). Ein Rezept für 6
// Portionen erreicht so auch 4 — mit reinen 0,5er-Schritten (0.5×→3, 1×→6,
// 1.5×→9, …) war das nie möglich, die 0,5er-Schritte bleiben aber als
// schnelle Option erhalten. Ohne erkennbare Zahl im Yield (Freitext) zeigt
// die Mitte weiterhin nur den Multiplikator, nicht antippbar.
// ---------------------------------------------------------------------------

class _PortionStepper extends StatelessWidget {
  final String? recipeYield;
  final double multiplier;
  final ValueChanged<double> onChanged;
  const _PortionStepper({
    required this.recipeYield,
    required this.multiplier,
    required this.onChanged,
  });

  String _fmtMult(double m) =>
      m == m.truncateToDouble() ? '${m.truncate()}×' : '$m×';

  // Rundet auf 2 Nachkommastellen, BEVOR auf Ganzzahligkeit geprüft wird —
  // sonst zeigt z. B. 6 × (5/6) durch Float-Rundung 4.999999999999999 statt
  // sauber „5" an, und wiederholtes Stepping würde diesen Fehler aufsummieren.
  double _clean(double v) => double.parse(v.toStringAsFixed(2));

  String _fmtServings(double v) {
    final c = _clean(v);
    return c == c.truncateToDouble()
        ? c.truncate().toString()
        : c.toStringAsFixed(1);
  }

  // Erste Zahl im UNSKALIERTEN Yield-Text — die Basis, auf die sich eine
  // eingegebene/gesteppte Zielportionenzahl bezieht (z. B. „6" aus
  // „6 Portionen"). `null` bei Freitext ohne Zahl.
  double? _baseServings() {
    final y = recipeYield;
    if (y == null) return null;
    final m = RegExp(r'\d+([.,]\d+)?').firstMatch(y);
    if (m == null) return null;
    return double.tryParse(m.group(0)!.replaceAll(',', '.'));
  }

  Future<void> _promptExactServings(
      BuildContext context, double base, double current) async {
    final l = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: _fmtServings(current));
    final typed = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.appCard,
        title: Text(l.servings, style: TextStyle(color: context.appFg)),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(color: context.appFg),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(
                ctx, double.tryParse(controller.text.replaceAll(',', '.'))),
            child: Text(l.save),
          ),
        ],
      ),
    );
    controller.dispose();
    if (typed == null || typed <= 0) return;
    onChanged((typed / base).clamp(0.01, 999.0));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final base = _baseServings();
    // Gereinigter aktueller Zielwert — Basis für Anzeige UND beide Stepper-
    // Buttons, damit wiederholtes Antippen nicht winzige Float-Reste aufbaut.
    final current = base != null ? _clean(base * multiplier) : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.appSeparator, width: 1),
        boxShadow: context.appShadowSm,
      ),
      child: Row(
        children: [
          Text(l.servings,
              style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: context.appFg,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2)),
          const Spacer(),
          // +/- steppen IMMER den Multiplikator um 0,5 — unverändert zum
          // bisherigen Verhalten, unabhängig davon, ob die Mitte gleich die
          // Portionenzahl oder den rohen Multiplikator zeigt.
          _stepBtn(context, Icons.remove_rounded,
              () => onChanged((multiplier - 0.5).clamp(0.5, 20.0))),
          if (base != null && current != null)
            GestureDetector(
              onTap: () => _promptExactServings(context, base, current),
              child: Container(
                constraints: const BoxConstraints(minWidth: 44),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  _fmtServings(current),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: AppTokens.accentDeep,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline,
                      decorationColor: AppTokens.accentDeep,
                      decorationStyle: TextDecorationStyle.dotted),
                ),
              ),
            )
          else
            SizedBox(
              width: 44,
              child: Text(
                _fmtMult(multiplier),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: context.appFg,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          _stepBtn(context, Icons.add_rounded,
              () => onChanged((multiplier + 0.5).clamp(0.5, 20.0))),
        ],
      ),
    );
  }

  Widget _stepBtn(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.appSurface2,
          border: Border.all(color: context.appSeparator),
        ),
        child: Icon(icon, size: 18, color: AppTokens.accentDeep),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ingredients content
// ---------------------------------------------------------------------------

class _IngredientsContent extends StatelessWidget {
  final RecipeDetail recipe;
  final double multiplier;
  final Set<int> checked;
  final ValueChanged<int> onToggleCheck;

  const _IngredientsContent({
    required this.recipe,
    required this.multiplier,
    required this.checked,
    required this.onToggleCheck,
  });

  @override
  Widget build(BuildContext context) {
    final ingredients = recipe.recipeIngredient;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...ingredients.asMap().entries.expand((entry) {
          final i = entry.key;
          final ing = entry.value;
          final isChecked = checked.contains(i);
          // Menge (hervorgehoben) vom Namen trennen — wie im Mockup.
          final (:amount, :name) =
              ingdisp.ingredientDisplayParts(ing, multiplier);
          // Mealie-Abschnitt („Knusperboden", „Füllung" …) beginnt an dieser
          // Zutat. Reine Überschriftzeilen ohne Inhalt zeigen nur den Titel.
          final section = ing.sectionTitle;

          return [
            if (section != null)
              IngredientSectionHeader(title: section, isFirst: i == 0),
            if (ing.hasContent)
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onToggleCheck(i);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(color: context.appSeparator, width: 0.5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Checkbox (abgerundetes Quadrat, Verlauf wenn aktiv)
                      Container(
                        width: 23,
                        height: 23,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          gradient: isChecked ? AppTokens.accentGradient : null,
                          border: isChecked
                              ? null
                              : Border.all(
                                  color: context.appFgTertiary, width: 2),
                        ),
                        child: isChecked
                            ? const Icon(Icons.check_rounded,
                                size: 15, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Text.rich(
                          TextSpan(children: [
                            if (amount.isNotEmpty)
                              TextSpan(
                                text: '$amount ',
                                style: TextStyle(
                                  color: isChecked
                                      ? context.appFgTertiary
                                      : AppTokens.accentDeep,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            TextSpan(text: name),
                          ]),
                          style: TextStyle(
                            color: isChecked
                                ? context.appFgTertiary
                                : context.appFg,
                            fontSize: 15,
                            height: 1.3,
                            decoration:
                                isChecked ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      // Verlinktes Rezept (Mealie „Rezept als Zutat"): öffnen.
                      if (ing.referencedRecipe != null &&
                          ing.food?.name?.isNotEmpty != true)
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => context
                              .push('/recipes/${ing.referencedRecipe!.id}'),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(Icons.menu_book_rounded,
                                size: 20, color: AppTokens.accentDeep),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ];
        }),
        const SizedBox(height: 4),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Instructions content
// ---------------------------------------------------------------------------

class _InstructionsContent extends StatelessWidget {
  final RecipeDetail recipe;
  final AppSettings? settings;
  final Set<int> completed;
  final ValueChanged<int> onToggle;

  const _InstructionsContent({
    required this.recipe,
    required this.settings,
    required this.completed,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final steps = recipe.recipeInstructions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: steps.asMap().entries.expand((entry) {
        final i = entry.key;
        final step = entry.value;
        final done = completed.contains(i);
        // Mealie-Abschnitt („Boden", „Füllung" …) — gleiche Optik wie die
        // Zutaten-Abschnitte, über dem ersten Schritt des Abschnitts.
        final section = step.sectionTitle;

        return [
          if (section != null)
            IngredientSectionHeader(title: section, isFirst: i == 0),
          GestureDetector(
            onTap: () => onToggle(i),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: context.appSeparator, width: 0.5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: done
                            ? const Color(0xFF30D158)
                            : context.appFgTertiary,
                        width: 1.5,
                      ),
                      color: done
                          ? const Color(0xFF30D158).withValues(alpha: 0.2)
                          : Colors.transparent,
                    ),
                    child: done
                        ? const Icon(Icons.check,
                            size: 14, color: Color(0xFF30D158))
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Schritt-Überschrift (Mealie `summary`) — im Web
                        // steht sie anstelle von „Schritt 1".
                        if (step.heading != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              step.heading!,
                              style: TextStyle(
                                color: done
                                    ? context.appFgTertiary
                                    : context.appFg,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                decoration:
                                    done ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                        MarkdownText(
                          text: step.text,
                          serverUrl: settings?.serverUrl,
                          apiToken: settings?.apiToken,
                          style: TextStyle(
                            color:
                                done ? context.appFgTertiary : context.appFgSub,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Utensilien — gleiche Zeilen-Optik wie die Zutaten (abhakbares Kästchen)
// ---------------------------------------------------------------------------

class _ToolsSection extends ConsumerWidget {
  final List<RecipeTool> tools;
  final Set<int> checked;
  final ValueChanged<int> onToggle;

  const _ToolsSection({
    required this.tools,
    required this.checked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final expanded = isDetailSectionExpanded(ref, DetailSection.tools);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(
            icon: Icons.kitchen_rounded,
            title: l.toolsTitle,
            count: tools.length,
            expanded: expanded,
            onToggle: () => toggleDetailSection(ref, DetailSection.tools),
          ),
        ),
        CollapsibleBody(
          expanded: expanded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < tools.length; i++)
                _ToolRow(
                  name: tools[i].name,
                  isChecked: checked.contains(i),
                  onTap: () => onToggle(i),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Nährwerte — Kacheln im 2er-Raster, Werte pro Portion. Mealie speichert sie
// als Text ohne Einheit („74.9"); die Einheit kommt hier dazu, Zahlen werden
// im Format der App-Sprache angezeigt (de: „74,9").
// ---------------------------------------------------------------------------

class _NutritionSection extends ConsumerWidget {
  final Map<String, String> nutrition;
  const _NutritionSection({required this.nutrition});

  static const _units = {
    'calories': 'kcal',
    'cholesterolContent': 'mg',
    'sodiumContent': 'mg',
  };

  String _label(AppLocalizations l, String key) => switch (key) {
        'calories' => l.nutritionCalories,
        'fatContent' => l.nutritionFat,
        'saturatedFatContent' => l.nutritionSaturatedFat,
        'transFatContent' => l.nutritionTransFat,
        'unsaturatedFatContent' => l.nutritionUnsaturatedFat,
        'cholesterolContent' => l.nutritionCholesterol,
        'sodiumContent' => l.nutritionSodium,
        'carbohydrateContent' => l.nutritionCarbohydrates,
        'fiberContent' => l.nutritionFiber,
        'sugarContent' => l.nutritionSugar,
        'proteinContent' => l.nutritionProtein,
        _ => key,
      };

  /// Reine Zahl → lokal formatiert + Einheit; Text mit eigener Einheit
  /// („1015 kcal") bleibt, wie er ist.
  String _value(BuildContext context, String key, String raw) {
    final number = double.tryParse(raw.trim().replaceAll(',', '.'));
    if (number == null) return raw;
    final locale = Localizations.localeOf(context).toString();
    final formatted = NumberFormat.decimalPattern(locale)
        .format(double.parse(number.toStringAsFixed(1)));
    return '$formatted ${_units[key] ?? 'g'}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final expanded = isDetailSectionExpanded(ref, DetailSection.nutrition);
    final entries = nutrition.entries.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          icon: Icons.local_fire_department_rounded,
          title: l.nutritionTitle,
          expanded: expanded,
          onToggle: () => toggleDetailSection(ref, DetailSection.nutrition),
          trailing: Text(l.nutritionPerServing,
              style: TextStyle(color: context.appFgTertiary, fontSize: 12)),
        ),
        CollapsibleBody(
          expanded: expanded,
          child: LayoutBuilder(builder: (context, box) {
            const gap = 10.0;
            final tileWidth = (box.maxWidth - gap) / 2;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final e in entries)
                  Container(
                    width: tileWidth,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: e.key == 'calories'
                        ? BoxDecoration(
                            gradient: AppTokens.accentGradient,
                            borderRadius: BorderRadius.circular(AppTokens.rMd),
                          )
                        : detailCardDecoration(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_label(l, e.key),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: e.key == 'calories'
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : context.appFgSub,
                                fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(_value(context, e.key, e.value),
                            style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                color: e.key == 'calories'
                                    ? Colors.white
                                    : context.appFg,
                                fontSize: 16,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class _ToolRow extends StatelessWidget {
  final String name;
  final bool isChecked;
  final VoidCallback onTap;

  const _ToolRow(
      {required this.name, required this.isChecked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: context.appSeparator, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 23,
              height: 23,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                gradient: isChecked ? AppTokens.accentGradient : null,
                border: isChecked
                    ? null
                    : Border.all(color: context.appFgTertiary, width: 2),
              ),
              child: isChecked
                  ? const Icon(Icons.check_rounded,
                      size: 15, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: isChecked ? context.appFgTertiary : context.appFg,
                  fontSize: 15,
                  height: 1.3,
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tags section
// ---------------------------------------------------------------------------

class _TagsSection extends StatelessWidget {
  final RecipeDetail recipe;
  const _TagsSection({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.tags,
              style: TextStyle(
                  color: context.appFgSub,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              ...recipe.recipeCategory.map((c) => _TagPill(label: c.name)),
              ...recipe.tags.map((t) => _TagPill(label: t.name)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  final String label;
  const _TagPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: context.appSurface2,
        borderRadius: BorderRadius.circular(14),
      ),
      child:
          Text(label, style: TextStyle(color: context.appFgSub, fontSize: 13)),
    );
  }
}

// ---------------------------------------------------------------------------
// Send to device sheet
// ---------------------------------------------------------------------------

class _SendSheet extends ConsumerWidget {
  final RecipeDetail recipe;
  const _SendSheet({required this.recipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    // Live-Watch: peers werden während der Sheet-Anzeige weiter entdeckt
    // (mDNS resolved-Events brauchen auf manchen Routern bis zu 2 s).
    final peersAsync = ref.watch(recipeSendProvider);
    final peers = peersAsync.valueOrNull ?? const <RecipePeer>[];
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetHandle(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
            child: Text(l.sendToDevice,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3)),
          ),
          if (peers.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(height: 12),
                  Text(l.searchingDevices,
                      style: TextStyle(color: context.appFgSub)),
                ],
              ),
            )
          else
            ...peers.map((peer) => ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: peer.remembered
                          ? context.appSurface2
                          : AppTokens.accent.withValues(alpha: 0.12),
                    ),
                    child: Icon(
                        peer.remembered
                            ? Icons.schedule_send_rounded
                            : Icons.devices_rounded,
                        color: peer.remembered
                            ? context.appFgSub
                            : AppTokens.accentDeep,
                        size: 20),
                  ),
                  title: Text(peer.name,
                      style: TextStyle(
                          color: context.appFg, fontWeight: FontWeight.w600)),
                  // Nur aus dem Mealie-Postfach bekannt: wird beim nächsten
                  // Öffnen der App auf dem Gerät zugestellt.
                  subtitle: peer.remembered
                      ? Text(l.sendPeerOfflineHint,
                          style: TextStyle(
                              color: context.appFgSub, fontSize: 12.5))
                      : null,
                  trailing: Icon(Icons.send_rounded,
                      color: context.appFgTertiary, size: 18),
                  onTap: () async {
                    // Overlay/Messenger VOR dem Schließen des Sheets greifen,
                    // damit Effekt und Rückmeldung das Sheet überleben.
                    final overlay = Overlay.of(context, rootOverlay: true);
                    final messenger = ScaffoldMessenger.of(context);
                    HapticFeedback.mediumImpact();
                    Navigator.pop(context);
                    showSendFlyAnimation(overlay);
                    SendOutcome outcome;
                    try {
                      outcome = await ref
                          .read(recipeSendProvider.notifier)
                          .sendRecipe(peer: peer, recipe: recipe);
                    } catch (_) {
                      return;
                    }
                    final msg = switch (outcome) {
                      SendOutcome.delivered => null,
                      SendOutcome.mailbox => l.sendDeliveredLater(peer.name),
                      SendOutcome.queued => l.sendQueuedOffline,
                    };
                    if (msg != null) {
                      messenger.showSnackBar(SnackBar(
                          content: Text(msg),
                          duration: const Duration(seconds: 4)));
                    }
                  },
                )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Plan meal sheet
// ---------------------------------------------------------------------------

class _PlanSheet extends ConsumerStatefulWidget {
  final RecipeDetail recipe;
  const _PlanSheet({required this.recipe});

  @override
  ConsumerState<_PlanSheet> createState() => _PlanSheetState();
}

class _PlanSheetState extends ConsumerState<_PlanSheet> {
  DateTime _date = DateTime.now();
  String _mealType = 'dinner';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: SheetHandle()),
          const SizedBox(height: 6),
          Text(l.planMeal,
              style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: context.appFg,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime.now().subtract(const Duration(days: 7)),
                lastDate: DateTime.now().add(const Duration(days: 60)),
              );
              if (d != null) setState(() => _date = d);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.appCard,
                borderRadius: BorderRadius.circular(AppTokens.rSm),
                border: Border.all(color: context.appSeparator, width: 1),
                boxShadow: context.appShadowSm,
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      color: AppTokens.accentDeep, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
                    style: TextStyle(
                        color: context.appFg,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MealTypeBtn(
                label: l.breakfast,
                selected: _mealType == 'breakfast',
                onTap: () => setState(() => _mealType = 'breakfast'),
              ),
              const SizedBox(width: 8),
              _MealTypeBtn(
                label: l.lunch,
                selected: _mealType == 'lunch',
                onTap: () => setState(() => _mealType = 'lunch'),
              ),
              const SizedBox(width: 8),
              _MealTypeBtn(
                label: l.dinner,
                selected: _mealType == 'dinner',
                onTap: () => setState(() => _mealType = 'dinner'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GradientButton(
            label: l.save,
            icon: Icons.event_available_rounded,
            onTap: () async {
              final dateStr =
                  '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}';
              await ref.read(mealplanProvider.notifier).addEntry(
                    date: dateStr,
                    entryType: _mealType,
                    recipeId: widget.recipe.id,
                    title: widget.recipe.name,
                  );
              if (context.mounted) Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _MealTypeBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _MealTypeBtn(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            gradient: selected ? AppTokens.accentGradient : null,
            color: selected ? null : context.appSurface2,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? const [
                    BoxShadow(
                        color: Color(0x40FF7800),
                        blurRadius: 10,
                        offset: Offset(0, 3))
                  ]
                : null,
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? Colors.white : context.appFgSub,
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              )),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared back button
// ---------------------------------------------------------------------------

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Icon(Icons.chevron_left, color: context.appFg, size: 22),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Premium-Redesign: Full-bleed Hero-Header
// ---------------------------------------------------------------------------

class _HeroHeader extends StatelessWidget {
  final RecipeDetail recipe;
  final AppSettings? settings;
  final double multiplier;
  final VoidCallback onBack;
  final VoidCallback onMore;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const _HeroHeader({
    required this.recipe,
    required this.settings,
    required this.multiplier,
    required this.onBack,
    required this.onMore,
    required this.isFavorite,
    required this.onFavorite,
  });

  String get _imageUrl =>
      '${settings?.serverUrl ?? ''}/api/media/recipes/${recipe.id}/images/original.webp';

  String _fmtTime(int min) {
    if (min < 60) return '$min min';
    final h = min ~/ 60;
    final m = min % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  @override
  Widget build(BuildContext context) {
    final token = settings?.apiToken ?? '';
    final topPad = MediaQuery.paddingOf(context).top;
    // „Rezeptbilder anzeigen" gilt nur für Listen (so steht es auch in der
    // Einstellung) — das Titelbild im Rezept selbst ist immer sichtbar.

    // Feste Höhe 320 (große Anzeige unter Windows/macOS: 460), Bild starr. Tippen aufs Bild öffnet die große Ansicht
    // (Blur-Nav und Titel/Meta liegen darüber und behalten ihre Taps).
    return SizedBox(
      height: LargeScreen.isWide(context) ? 460 : 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () => showRecipeImageViewer(
              context,
              recipeId: recipe.id,
              imageUrl: _imageUrl,
              httpHeaders: {'Authorization': 'Bearer $token'},
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Bild
                Hero(
                  tag: 'recipe-image-${recipe.id}',
                  child: RecipeImage(
                    recipeId: recipe.id,
                    imageUrl: _imageUrl,
                    httpHeaders: {'Authorization': 'Bearer $token'},
                    placeholder: (_) => _placeholder(),
                  ),
                ),

                // Scrim
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x59000000),
                        Color(0x00000000),
                        Color(0x00000000),
                        Color(0xCC000000),
                      ],
                      stops: [0.0, 0.22, 0.5, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Blur-Nav
          Positioned(
            top: topPad + 8,
            left: 14,
            right: 14,
            child: Row(
              children: [
                _GlassCircleButton(
                    icon: Icons.chevron_left_rounded, onTap: onBack, size: 26),
                const Spacer(),
                _GlassCircleButton(
                    icon: isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFavorite ? const Color(0xFFFF4D6D) : Colors.white,
                    onTap: onFavorite),
                const SizedBox(width: 10),
                _GlassCircleButton(
                    icon: Icons.more_vert_rounded, onTap: onMore),
              ],
            ),
          ),

          // Titel + Meta
          Positioned(
            left: 18,
            right: 18,
            bottom: 34,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (recipe.tags.isNotEmpty || recipe.recipeCategory.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Wrap(
                      spacing: 7,
                      runSpacing: 6,
                      children: [
                        ...recipe.recipeCategory
                            .take(2)
                            .map((c) => _HeroChip(label: c.name)),
                        ...recipe.tags
                            .take(2)
                            .map((t) => _HeroChip(label: t.name)),
                      ],
                    ),
                  ),
                Text(
                  recipe.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: Colors.white,
                    fontSize: 25,
                    height: 1.12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    shadows: [Shadow(color: Color(0x80000000), blurRadius: 12)],
                  ),
                ),
                const SizedBox(height: 10),
                _HeroMetaRow(
                    recipe: recipe, multiplier: multiplier, fmt: _fmtTime),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8B06A), Color(0xFFC2693A)],
          ),
        ),
        child: const Center(
          child:
              Icon(Icons.restaurant_rounded, color: Colors.white54, size: 56),
        ),
      );
}

class _HeroMetaRow extends StatelessWidget {
  final RecipeDetail recipe;
  final double multiplier;
  final String Function(int) fmt;
  const _HeroMetaRow(
      {required this.recipe, required this.multiplier, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    final t = recipe.totalTime ?? recipe.prepTime ?? recipe.cookTime;
    if ((t ?? 0) > 0) items.add(_item(Icons.schedule_rounded, fmt(t!)));
    if ((recipe.recipeYield ?? '').trim().isNotEmpty) {
      items.add(_item(Icons.restaurant_rounded,
          scaleYield(recipe.recipeYield!, multiplier)));
    }
    if ((recipe.rating ?? 0) > 0) {
      items.add(_item(Icons.star_rounded, recipe.rating!.toStringAsFixed(1)));
    }
    // „Zuletzt gekocht" — Mealies lastMade (UTC) als lokales Kurzdatum.
    final lastMade = DateTime.tryParse(recipe.lastMade ?? '');
    if (lastMade != null) {
      final l = AppLocalizations.of(context)!;
      final date =
          MaterialLocalizations.of(context).formatShortDate(lastMade.toLocal());
      items.add(_item(Icons.history_rounded, '${l.lastCooked}: $date'));
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
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      );
}

class _HeroChip extends StatelessWidget {
  final String label;
  const _HeroChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          ),
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class _GlassCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color? color;
  const _GlassCircleButton({
    required this.icon,
    required this.onTap,
    this.size = 22,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Icon(icon, color: color ?? Colors.white, size: size),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Antippbare Bewertung (aus dem alten Header übernommen)
// ---------------------------------------------------------------------------

class _RatingRow extends StatelessWidget {
  final RecipeDetail recipe;
  final void Function(double rating) onRate;
  const _RatingRow({required this.recipe, required this.onRate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (i) {
          final filled = (recipe.rating ?? 0) >= i + 1;
          final half = !filled &&
              (recipe.rating ?? 0) > i &&
              (recipe.rating ?? 0) < i + 1;
          return GestureDetector(
            onTap: () => onRate((i + 1).toDouble()),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(right: 3),
              child: TweenAnimationBuilder<double>(
                key: ValueKey('star-$i-${filled || half}'),
                tween: Tween(begin: 0.6, end: 1.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.elasticOut,
                builder: (_, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Icon(
                  half
                      ? Icons.star_half_rounded
                      : (filled
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded),
                  color: Colors.amber,
                  size: 24,
                ),
              ),
            ),
          );
        }),
        if ((recipe.rating ?? 0) > 0) ...[
          const SizedBox(width: 6),
          Text(recipe.rating!.toStringAsFixed(1),
              style: TextStyle(
                  color: context.appFgSub,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sticky „Kochen starten"-CTA
// ---------------------------------------------------------------------------

class _StartCookingCTA extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _StartCookingCTA({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    return Container(
      // Knopf auf großer Anzeige (Windows/macOS) so breit wie die Lesespalte.
      padding: EdgeInsets.fromLTRB(18 + LargeScreen.inset(context), 14,
          18 + LargeScreen.inset(context), bottomSafe + 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.appBg.withValues(alpha: 0.0),
            context.appBg.withValues(alpha: 0.85),
            context.appBg,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
      child: BounceTap(
        onTap: onTap,
        scale: 0.97,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: AppTokens.accentGradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x73FF7800),
                  blurRadius: 22,
                  offset: Offset(0, 10)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_fire_department_rounded,
                  color: Colors.white, size: 22),
              const SizedBox(width: 9),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ursprüngliche URL als öffnbare http(s)-Adresse, sonst `null`.
Uri? _originalUri(RecipeDetail recipe) {
  final raw = recipe.orgUrl?.trim() ?? '';
  if (raw.isEmpty) return null;
  final uri = Uri.tryParse(raw);
  if (uri == null || !(uri.scheme == 'http' || uri.scheme == 'https')) {
    return null;
  }
  return uri.host.isEmpty ? null : uri;
}

/// Knopf „Ursprüngliche URL" mit Domain — öffnet die Quelle im Browser.
class _OriginalUrlButton extends StatelessWidget {
  final Uri uri;
  const _OriginalUrlButton({required this.uri});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final host = uri.host.startsWith('www.') ? uri.host.substring(4) : uri.host;
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: AppTokens.accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => openMarkdownLink(uri.toString()),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.open_in_new_rounded,
                    size: 16, color: AppTokens.accentDeep),
                const SizedBox(width: 8),
                Flexible(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: l.originalUrlLabel,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(
                          text: ' · $host',
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppTokens.accentDeep, fontSize: 13.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
