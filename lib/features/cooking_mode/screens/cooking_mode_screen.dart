import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/utils/ingredient_display.dart'
    show formatQuantity, ingredientDisplayParts;
import '../../../core/utils/yield_format.dart';
import '../../../core/utils/cooking_step_utils.dart';
import '../../../core/utils/markdown_parse.dart';
import '../../../shared/widgets/markdown_text.dart' show openMarkdownLink;
import '../../../core/services/log_manager.dart';
import '../../../core/services/wake_lock.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/ingredient_section_header.dart';
import '../../../shared/widgets/photo_source_sheet.dart';
import '../../timeline/providers/timeline_provider.dart';
import '../../timeline/widgets/made_this_sheet.dart';
import '../../cook_friends/services/cook_friends_service.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../../recipes/widgets/recipe_comments_section.dart';
import '../../recipes/widgets/recipe_notes_list.dart';
import '../../timer/providers/timer_provider.dart';
import '../providers/cooking_session_provider.dart';
import '../../../shared/widgets/recipe_image.dart';
import '../../../core/utils/search_match.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CookingModeScreen — mirrors iOS CookingModeView + CookingRecipeDetailView
// ─────────────────────────────────────────────────────────────────────────────

class CookingModeScreen extends ConsumerStatefulWidget {
  final String slug; // recipe id (UUID)
  const CookingModeScreen({super.key, required this.slug});

  @override
  ConsumerState<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends ConsumerState<CookingModeScreen> {
  // „Zuletzt gekocht" beim Abschluss zum Server syncen? Toggle auf der
  // „Guten Appetit"-Seite, Default AN — greift nur beim dortigen „Beenden",
  // NICHT beim Abbrechen über ⋮-Menü oder ×-Tag (nicht fertig gekocht).
  bool _syncLastMade = true;

  /// Optionaler Kommentar auf der „Guten Appetit"-Seite — wird beim
  /// „Beenden" als Mealie-Kommentar zum Rezept gespeichert.
  final _doneCommentCtrl = TextEditingController();

  /// Optionales Foto für den Zeitleisten-Eintrag („hat das gekocht"), der
  /// beim „Beenden" zusammen mit „Zuletzt gekocht" angelegt wird.
  File? _donePhoto;

  @override
  void initState() {
    super.initState();
    WakeLock.enable();
  }

  @override
  void dispose() {
    WakeLock.disable();
    _doneCommentCtrl.dispose();
    super.dispose();
  }

  void _dismiss() {
    // „Pausieren": Kochmodus verlassen, aber Kochsession + (bei Gästen) die
    // Cook-Friends-Verbindung AKTIV lassen → der Flammen-FAB (unten rechts,
    // inkl. laufendem Timer) holt den Kochmodus zurück, solange der Host nicht
    // beendet hat. Gilt jetzt auch für einen Gast MIT eigenem Server.
    //
    // Ausnahme: ein Gast OHNE eigenen Server (rein über die App einer fremden
    // Kochsession beigetreten) darf nicht pausieren — er hat keinen sinnvollen
    // „pausierten" Ort. Für ihn ist das Verlassen ein sauberes Disconnecten
    // (Host bekommt connectionLost, guestCount runter). Der „Pausieren"-Button
    // wird ihm gar nicht erst gezeigt; dieser Pfad greift bei ihm nur noch über
    // die Leer-Ansicht (_EmptyStateView), wo die Session ohnehin schon weg ist.
    final cf = ref.read(cookFriendsProvider);
    final hasOwnServer =
        ref.read(settingsProvider).valueOrNull?.isConfigured ?? false;
    if (cf.role == CookFriendsRole.guest && !hasOwnServer) {
      ref.read(cookFriendsProvider.notifier).endSession();
    }
    // Robust: bei leerem Navigator-Stack auf /home fallback statt no-op
    // (Vorher konnte der Button "nichts tun" wenn die Route via go entered
    // wurde und der Stack damit leer war).
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final sessions = ref.watch(cookingSessionsProvider);
    final session = sessions.where((s) => s.slug == widget.slug).firstOrNull;

    // Wenn der Host die Cook-Friends-Session beendet während der Guest noch
    // hier ist (sharedState wird null + role wird none): zur cook_friends-
    // View bzw. Home zurück, sonst hängt der Guest in einer „toten" Cooking-
    // Mode ohne Sync. Wir poppen nur einmal, daher der ref.listen-Guard.
    ref.listen<CookFriendsState>(cookFriendsProvider, (prev, next) {
      if (prev?.role == CookFriendsRole.guest &&
          next.role == CookFriendsRole.none) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        });
      }
    });

    // Snackbar zeigen wenn der Host die Session via Trigger beendet hat.
    // Der Trigger wird in cook_friends_service._applyMessage bei sessionEnded
    // hochgezählt (nur für Guests).
    ref.listen<int>(cookFriendsRemoteEndedTriggerProvider, (prev, next) {
      if (prev == next) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.hostEndedSessionMessage),
            duration: const Duration(seconds: 3),
          ),
        );
      });
    });

    if (session == null) {
      return _EmptyStateView(onDismiss: _dismiss, l: l);
    }

    // Im Kochmodus AUCH fertige (klingelnde) Timer zeigen — nur so bleibt das
    // Chip sichtbar, über das der Nutzer den Dauerton stoppen kann. Vorher
    // verschwand der fertige Timer aus der Leiste und der Alarm ließ sich nur
    // noch durch Beenden des Kochmodus (stopAll) abschalten.
    final activeTimers = ref.watch(timerProvider).toList();

    final steps = session.recipe.recipeInstructions;
    final stepCount = steps.length;
    // [Utensilien, falls hinterlegt] → Zutaten vorbereiten → Kochschritte →
    // „Guten Appetit"-Abschluss (siehe CookingSession.pageCount).
    final pageCount = session.pageCount;
    final prepPage = session.prepPage;
    final firstStepPage = session.firstStepPage;
    final page = session.currentInstructionIndex.clamp(0, pageCount - 1);
    final isFinalPage = page == pageCount - 1;
    final completedCount = session.completedInstructions.where((c) => c).length;
    // Fortschritt = geschaffte Schritte / Gesamt: auf Schritt k sind k-1
    // geschafft, mit jedem Weiterblättern wächst der Balken um 1/n (vorher
    // zählten NUR abgehakte Schritte → wer nur wischte, sah nie Fortschritt).
    // Vorab abgehakte Schritte zählen, falls das mehr ist; Vorbereitungs-
    // seiten = 0, Abschluss-Seite = 100 %.
    final progress = cookingProgress(
        page: page,
        firstStepPage: firstStepPage,
        stepCount: stepCount,
        completedCount: completedCount,
        isFinalPage: isFinalPage);

    final cfRole = ref.watch(cookFriendsProvider).role;
    final isGuest = cfRole == CookFriendsRole.guest;
    // „Eigener Server eingerichtet?" — unterscheidet einen vollwertigen Nutzer
    // (der nur gerade einer fremden Kochsession beigetreten ist) vom reinen
    // serverlosen Gast.
    final hasOwnServer =
        ref.watch(settingsProvider).valueOrNull?.isConfigured ?? false;
    // Pausieren (= Kochmodus verlassen, Session bleibt aktiv, Rückkehr über den
    // Flammen-FAB inkl. Timer) darf JEDER außer einem serverlosen Gast. Der
    // serverlose Gast kann den Kochmodus nur über das ⋮-Menü „beenden".
    final canPause = !isGuest || hasOwnServer;
    final canUploadOwn = isGuest &&
        hasOwnServer &&
        (ref.watch(cookFriendsProvider).sharedState?.allowGuestSave ?? false);
    // „Zuletzt gekocht"-Sync nur, wenn das Rezept vom EIGENEN Server kommt:
    // ein Cook-Friends-Gast kocht das Rezept des Hosts — der Slug existiert
    // auf seinem Server nicht.
    final canSyncLastMade = hasOwnServer && !isGuest;

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        backgroundColor: context.appBg,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        // „Pausieren": verlässt den Kochmodus, die Session bleibt aktiv
        // (über den Flammen-FAB wieder aufrufbar). Breiter, damit längere
        // Übersetzungen (z. B. FR „Mettre en pause") nicht umbrechen. Einem
        // serverlosen Gast (canPause == false) wird kein Pausieren angeboten —
        // er beendet ausschließlich über das ⋮-Menü.
        leadingWidth: 132,
        leading: canPause
            ? TextButton(
                onPressed: _dismiss,
                child: Text(l.pause,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    softWrap: false,
                    style: const TextStyle(
                        color: AppTokens.accentDeep,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
              )
            : null,
        // Header: Rezepttitel (Fortschritt darunter als Bar).
        title: Text(session.recipe.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: context.appFg,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2)),
        actions: [
          // Zutaten schnell erreichbar (Bottom-Sheet) — Schritt bleibt im Fokus.
          IconButton(
            tooltip: l.ingredients,
            icon:
                Icon(Icons.format_list_bulleted_rounded, color: context.appFg),
            onPressed: () => _openIngredients(context, session),
          ),
          // Sekundäre Aktionen im Overflow, damit der Header ruhig bleibt.
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: context.appFg),
            color: context.appCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTokens.rMd),
              side: BorderSide(color: context.appSeparator),
            ),
            onSelected: (v) {
              switch (v) {
                case 'timer':
                  _openAddTimer(context, session);
                  break;
                case 'add':
                  _openAddRecipeSheet(context);
                  break;
                case 'notes':
                  _openNotesSheet(context, session, editable: !isGuest);
                  break;
                case 'friends':
                  context.push('/cook-friends?slug=${session.recipe.id}');
                  break;
                case 'upload':
                  _uploadToOwnServer(context, session.recipe);
                  break;
                case 'end':
                  _confirmEndCookingMode(context);
                  break;
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                  value: 'timer',
                  child: _menuRow(context, Icons.timer_outlined, l.addTimer)),
              if (!isGuest)
                PopupMenuItem(
                    value: 'add',
                    child: _menuRow(
                        context, Icons.add_rounded, l.cookingModeAddRecipe)),
              PopupMenuItem(
                  value: 'notes',
                  child:
                      _menuRow(context, Icons.sticky_note_2_outlined, l.notes)),
              PopupMenuItem(
                  value: 'friends',
                  child: _menuRow(
                      context, Icons.group_add_rounded, l.cookFriends)),
              if (canUploadOwn)
                PopupMenuItem(
                    value: 'upload',
                    child: _menuRow(context, Icons.cloud_upload_outlined,
                        l.uploadToOwnServer)),
              const PopupMenuDivider(),
              // Kochmodus wirklich beenden (Session schließen) — im Gegensatz
              // zu „Fertig" (oben links), das nur pausiert/verlässt.
              PopupMenuItem(
                value: 'end',
                child: _menuRow(
                    context, Icons.stop_circle_outlined, l.endCookingMode,
                    destructive: true),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: CookProgressBar(value: progress),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Aktive Timer (falls vorhanden) oben.
            if (activeTimers.isNotEmpty)
              _TimerOverlayBar(
                session: session,
                activeTimers: activeTimers,
                l: l,
              ),
            // Multi-Rezept: kompakter Wechsler (nur bei >1 Session); × beendet
            // ein einzelnes Rezept (nur außerhalb des Gastmodus).
            if (sessions.length > 1)
              _RecipeSwitcher(
                sessions: sessions,
                currentSlug: widget.slug,
                canEnd: !isGuest,
                onEndRecipe: _endOneRecipe,
              ),
            // [Utensilien] → Zutaten vorbereiten → Schritte → „Guten
            // Appetit"; jede Schrittseite zeigt genau EINEN Kochschritt.
            Expanded(
              child: page < prepPage
                  ? _ToolsView(slug: session.slug, l: l)
                  : page == prepPage
                      ? _PrepView(slug: session.slug, l: l)
                      : isFinalPage
                          ? _DonePage(
                              l: l,
                              showSyncToggle: canSyncLastMade,
                              syncValue: _syncLastMade,
                              onSyncChanged: (v) =>
                                  setState(() => _syncLastMade = v),
                              // Kommentar nur für Rezepte des eigenen Servers und
                              // nur, wenn sie am Rezept nicht deaktiviert sind.
                              commentController: canSyncLastMade &&
                                      !(session.recipe.settings
                                              ?.disableComments ??
                                          false)
                                  ? _doneCommentCtrl
                                  : null,
                              // Foto nur, wenn beim Beenden auch wirklich ein
                              // Zeitleisten-Eintrag entsteht (Schalter an).
                              photo: _donePhoto,
                              onPickPhoto: canSyncLastMade && _syncLastMade
                                  ? () async {
                                      final f =
                                          await pickPhotoWithSource(context);
                                      if (f != null && mounted) {
                                        setState(() => _donePhoto = f);
                                      }
                                    }
                                  : null,
                              onRemovePhoto: () =>
                                  setState(() => _donePhoto = null),
                            )
                          : _StepView(
                              session: session,
                              stepIndex: page - firstStepPage,
                              stepNumber: page - firstStepPage + 1,
                              l: l),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _StepNavBar(
        slug: session.slug,
        page: page,
        pageCount: pageCount,
        firstStepPage: firstStepPage,
        isStepDone: page >= firstStepPage &&
            !isFinalPage &&
            (page - firstStepPage) < session.completedInstructions.length &&
            session.completedInstructions[page - firstStepPage],
        // Vorbereitungsseiten: „Fertig", wenn alles auf DIESER Seite
        // abgehakt ist (Utensilien bzw. Zutaten).
        allIngredientsDone: page < prepPage
            ? session.completedTools.isNotEmpty &&
                session.completedTools.every((c) => c)
            : session.completedIngredients.isNotEmpty &&
                session.completedIngredients.every((c) => c),
        l: l,
        // „Beenden" auf der Abschluss-Seite: nur dieses (fertige) Rezept
        // beenden; bei mehreren offenen Rezepten zu einem anderen wechseln.
        onEnd: () => _finishRecipe(session, canSyncLastMade),
      ),
    );
  }

  // Abschluss über die „Guten Appetit"-Seite: je nach Toggle erst „Zuletzt
  // gekocht" zum Server syncen (Webapp-Endpoint last-made), dann das Rezept
  // beenden. Fire-and-forget: der Abschluss darf nicht am Netz hängen; bei
  // Fehlschlag bleibt lastMade unverändert (nur Log). Container statt ref,
  // weil der Screen nach dem Beenden bereits disposed sein kann.
  void _finishRecipe(CookingSession session, bool canSync) {
    final comment = _doneCommentCtrl.text.trim();
    _doneCommentCtrl.clear();
    if (canSync && comment.isNotEmpty) {
      // Im Hintergrund wie lastMade: der Screen ist gleich weg, daher über
      // den Container statt über `ref`.
      final container = ProviderScope.containerOf(context, listen: false);
      final recipe = session.recipe;
      Future(() async {
        try {
          final c = await container
              .read(apiServiceProvider)
              .addRecipeComment(recipe.id, comment);
          RecipeDetail latest = recipe;
          for (final r
              in container.read(recipesProvider).valueOrNull ?? const []) {
            if (r.id == recipe.id) latest = r;
          }
          await container
              .read(recipesProvider.notifier)
              .upsertOne(latest.copyWith(comments: [...latest.comments, c]));
          container.invalidate(recipeDetailProvider(session.slug));
        } catch (e) {
          LogManager.shared
              .log('💬 Kommentar aus dem Kochmodus fehlgeschlagen: $e');
        }
      });
    }
    final photo = _donePhoto;
    _donePhoto = null;
    if (canSync && _syncLastMade) {
      // Wie „Ich hab's gekocht" der Webapp: Zeitleisten-Eintrag + lastMade
      // (+ optionales Foto). Betreff jetzt bauen — nach dem Beenden gibt es
      // keinen Context mehr.
      final container = ProviderScope.containerOf(context, listen: false);
      final subject = AppLocalizations.of(context)!.timelineUserMadeThis(
          currentUserDisplayName(ref.read(currentUserProvider)));
      final recipe = session.recipe;
      final id = session.slug; // Rezept-UUID = Key der Detail-Provider-Familie
      Future(() async {
        try {
          await recordRecipeMade(container,
              recipe: recipe, subject: subject, photo: photo);
        } catch (e) {
          // Zeitleiste nicht erreichbar (z. B. sehr alter Server) → wie
          // bisher wenigstens „Zuletzt gekocht" setzen.
          LogManager.shared
              .log('🍳 Zeitleiste fehlgeschlagen (${recipe.slug}): $e');
          try {
            await container
                .read(apiServiceProvider)
                .updateLastMade(recipe.slug, DateTime.now());
          } catch (e) {
            LogManager.shared
                .log('🍳 lastMade-Sync fehlgeschlagen (${recipe.slug}): $e');
          }
        }
        // Detail neu laden, damit „Zuletzt gekocht" sofort das neue Datum
        // zeigt.
        container.invalidate(recipeDetailProvider(id));
      });
    }
    _endOneRecipe(session.slug);
  }

  Widget _menuRow(BuildContext context, IconData icon, String label,
      {bool destructive = false}) {
    final color = destructive ? const Color(0xFFE53935) : context.appFg;
    return Row(
      children: [
        Icon(icon, size: 19, color: color),
        const SizedBox(width: 10),
        Text(label,
            style: TextStyle(
                color: color,
                fontWeight: destructive ? FontWeight.w600 : null)),
      ],
    );
  }

  // „Kochmodus beenden" (⋮-Menü): beendet ALLE offenen Rezepte (für einzelne
  // Rezepte gibt es das × am Tag) — mit entsprechender Warnung.
  Future<void> _confirmEndCookingMode(BuildContext context) async {
    final l = AppLocalizations.of(context)!;
    final count = ref.read(cookingSessionsProvider).length;
    final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: context.appCard,
            title:
                Text(l.endCookingMode, style: TextStyle(color: context.appFg)),
            content: Text(
                count > 1
                    ? l.endCookingModeConfirmAll(count)
                    : l.endCookingModeConfirm,
                style: TextStyle(color: context.appFgSub)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l.cancel)),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935)),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l.end),
              ),
            ],
          ),
        ) ??
        false;
    if (!ok) return;
    _endAllCookingMode();
  }

  // ALLE Kochsessions schließen + Cook-Friends beenden + Kochmodus verlassen.
  void _endAllCookingMode() {
    if (!mounted) return;
    final cf = ref.read(cookFriendsProvider);
    if (cf.role != CookFriendsRole.none) {
      // Gast: disconnect; Host: Session beenden (Broadcast an alle Gäste).
      ref.read(cookFriendsProvider.notifier).endSession();
    }
    ref.read(cookingSessionsProvider.notifier).endAll();
    // „Beenden" beendet AUCH laufende Timer — anders als „Pausieren", das sie
    // samt Kochsession aktiv lässt (Flammen-FAB mit Timer bleibt). Ohne das
    // tickte ein Timer ohne Kochmodus und damit ohne sichtbaren/stoppbaren
    // Indikator weiter (es gibt keinen Timer ohne Kochmodus).
    ref.read(timerProvider.notifier).stopAll();
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  // Schließt die aktuelle Kochsession und verlässt den Kochmodus (ohne Dialog).
  // Genutzt vom Bestätigungs-Dialog UND vom „Beenden"-Button der Abschluss-Seite.
  void _endCookingModeNow(String slug) {
    if (!mounted) return;
    // Gast: sauber aus der Cook-Friends-Session disconnecten.
    final cf = ref.read(cookFriendsProvider);
    if (cf.role == CookFriendsRole.guest) {
      ref.read(cookFriendsProvider.notifier).endSession();
    }
    // Diese Kochsession schließen (anders als „Pausieren", das sie aktiv lässt).
    ref.read(cookingSessionsProvider.notifier).endSession(slug);
    // Host: wenn keine Session mehr offen ist, auch die Cook-Friends-Session
    // beenden (Broadcast sessionEnded an alle Gäste).
    final remaining = ref.read(cookingSessionsProvider);
    if (remaining.isEmpty) {
      // Kochmodus ist komplett zu → laufende Timer mitbeenden (wie in
      // _endAllCookingMode). Sind noch andere Rezepte offen, bleibt der Timer.
      ref.read(timerProvider.notifier).stopAll();
      // Host: zusätzlich die Cook-Friends-Session beenden (Broadcast
      // sessionEnded an alle Gäste).
      if (ref.read(cookFriendsProvider).role == CookFriendsRole.host) {
        ref.read(cookFriendsProvider.notifier).endSession();
      }
    }
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  // Ein einzelnes Rezept aus der Multi-Rezept-Session entfernen (× am Tag).
  void _endOneRecipe(String slug) {
    final sessions = ref.read(cookingSessionsProvider);
    if (sessions.length <= 1) {
      // Letztes Rezept → kompletter Beenden-Flow (inkl. Verlassen).
      _endCookingModeNow(slug);
      return;
    }
    final wasCurrent = slug == widget.slug;
    ref.read(cookingSessionsProvider.notifier).endSession(slug);
    if (wasCurrent) {
      final remaining = ref
          .read(cookingSessionsProvider)
          .where((s) => s.slug != slug)
          .toList();
      if (remaining.isNotEmpty) context.go('/cooking/${remaining.first.slug}');
    }
  }

  // Timer-Sheet aus dem ⋮-Menü öffnen (gleiches Sheet wie die Timer-Leiste).
  void _openAddTimer(BuildContext context, CookingSession session) {
    final l = AppLocalizations.of(context)!;
    showAddTimerSheet(context, ref, session.recipe.name, l);
  }

  void _openIngredients(BuildContext context, CookingSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _IngredientsSheet(slug: session.slug),
    );
  }

  // Rezeptnotizen als Referenz-Sheet — bleibt fürs Kochen zugänglich, ohne
  // den schritt-fokussierten Screen zu verlassen. Ein Gast (fremde Session)
  // sieht Notizen nur lesend, da sein Server das Rezept nicht kennt.
  void _openNotesSheet(BuildContext context, CookingSession session,
      {required bool editable}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _NotesSheet(recipe: session.recipe, editable: editable),
    );
  }

  Future<void> _openAddRecipeSheet(BuildContext context) async {
    final picked = await showModalBottomSheet<RecipeDetail>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddRecipeSheet(),
    );
    if (picked == null) return;
    ref.read(cookingSessionsProvider.notifier).startSession(picked);
    if (!context.mounted) return;
    context.go('/cooking/${picked.id}');
  }

  // ── Geteiltes Rezept auf den eigenen Server speichern (Gast) ──────────────
  // Legt das Rezept auf dem EIGENEN Mealie-Server des Gasts an (apiService
  // nutzt die lokalen Settings, nicht die des Hosts). Mealie-Flow: POST mit
  // Name → neuer Slug, dann PATCH mit den vollen Daten.
  Future<void> _uploadToOwnServer(
      BuildContext context, RecipeDetail recipe) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final api = ref.read(apiServiceProvider);
    messenger.showSnackBar(SnackBar(content: Text(l.uploadingRecipe)));
    try {
      final created = await api.createRecipe({'name': recipe.name});
      try {
        await api.updateRecipe(
            created.slug, _ownServerPayload(created, recipe));
      } catch (_) {
        // PATCH fehlgeschlagen → die eben angelegte leere Hülle wieder löschen,
        // sonst sammeln sich bei jedem Fehlversuch Duplikate (Name (1),(2),…).
        try {
          await api.deleteRecipe(created.slug);
        } catch (_) {/* best-effort cleanup */}
        rethrow;
      }
      // Bild übernehmen. Bevorzugt die vom Host mitgesendeten Bildbytes
      // (SharedRecipe.imageBase64) — die liegen auch dann vor, wenn Host & Gast
      // UNTERSCHIEDLICHE Server nutzen (dann existiert recipe.id auf dem
      // Gast-Server nicht, ein Fetch liefe ins 404). Fallback (gleicher
      // Server): Original vom eigenen Server laden. Schlägt beides fehl, wird
      // das Bild übersprungen — der Rest des Rezepts ist trotzdem gespeichert.
      try {
        final sharedB64 = ref
            .read(cookFriendsProvider)
            .sharedState
            ?.findRecipe(recipe.id)
            ?.imageBase64;
        final List<int> bytes = (sharedB64 != null && sharedB64.isNotEmpty)
            ? base64Decode(sharedB64)
            : await api.fetchRecipeImageBytes(recipe.id);
        if (bytes.isNotEmpty) {
          await api.uploadRecipeImageBytes(created.slug, bytes,
              extension: 'webp');
        }
      } catch (_) {/* Bild ist optional */}
      if (!mounted) return;
      messenger
          .showSnackBar(SnackBar(content: Text(l.recipeUploadedToOwnServer)));
    } catch (e, st) {
      // Den echten Fehler NICHT verschlucken (war vorher `catch (_)`): ein
      // Dio-Fehler (401/403/422/404) landet zwar via API-Interceptor im
      // In-App-Log, ein TypeError aber nicht. Bei Mealie steckt im 422-Body die
      // exakte Validierungs-Ursache ({"detail":[{"loc":[...],"msg":...}]}).
      // debugPrint geht in Konsole UND (via LogManager.attach) ins In-App-Log.
      if (e is DioException) {
        debugPrint('❌ Rezept-Upload fehlgeschlagen: '
            'HTTP ${e.response?.statusCode} Body: ${e.response?.data}');
      } else {
        debugPrint('❌ Rezept-Upload fehlgeschlagen: $e\n$st');
      }
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l.recipeUploadFailed)));
    }
  }

  /// Baut die Mealie-PATCH-Payload aus dem geteilten RecipeDetail — spiegelt
  /// das Format aus RecipeEditScreen._buildPayload (Note-Ingredients mit
  /// disableAmount, Instructions als {text,title,summary,ingredientReferences},
  /// Zeiten als human-readable Strings). `created` liefert id/slug des neuen
  /// Rezepts auf dem eigenen Server.
  Map<String, dynamic> _ownServerPayload(
      RecipeDetail created, RecipeDetail src) {
    String minToStr(int? mins) {
      final m = mins ?? 0;
      if (m <= 0) return '';
      final h = m ~/ 60;
      final mm = m % 60;
      if (h == 0) return mm == 1 ? '1 Minute' : '$mm Minuten';
      if (mm == 0) return h == 1 ? '1 Stunde' : '$h Stunden';
      final hp = h == 1 ? '1 Stunde' : '$h Stunden';
      final mp = mm == 1 ? '1 Minute' : '$mm Minuten';
      return '$hp $mp';
    }

    String fmtQty(double q) =>
        q == q.truncateToDouble() ? q.truncate().toString() : q.toString();

    final instructions = src.recipeInstructions
        .where((i) => i.text.trim().isNotEmpty)
        .map((i) => {
              'text': i.text.trim(),
              'title':
                  (i.title?.trim().isEmpty ?? true) ? null : i.title!.trim(),
              'summary': i.heading,
              'ingredientReferences': <String>[],
            })
        .toList();

    final ingredients = src.recipeIngredient
        .map((ing) {
          final parts = <String>[];
          if ((ing.quantity ?? 0) > 0) parts.add(fmtQty(ing.quantity!));
          if (ing.unit?.name?.isNotEmpty == true) parts.add(ing.unit!.name!);
          if (ing.food?.name?.isNotEmpty == true) {
            parts.add(ing.food!.name!);
          } else if (ing.referencedRecipe != null) {
            // Das Unterrezept liegt auf dem Host-Server; als Text mitnehmen.
            parts.add(ing.referencedRecipe!.name);
          }
          if (ing.note?.isNotEmpty == true) parts.add(ing.note!);
          return <String, dynamic>{
            'note': parts.join(' ').trim(),
            'disableAmount': true,
            'quantity': 0,
            'unit': null,
            'food': null,
            // Abschnitt („Knusperboden" …) mitnehmen, sonst geht die
            // Gruppierung beim Speichern auf dem eigenen Server verloren.
            'title': ing.sectionTitle,
          };
        })
        .where((m) => (m['note'] as String).isNotEmpty || m['title'] != null)
        .toList();

    final prep = minToStr(src.prepTime);
    final perform = minToStr(src.cookTime);
    final total = minToStr(src.totalTime);

    return <String, dynamic>{
      'id': created.id,
      'slug': created.slug,
      'name': src.name,
      'description':
          (src.description?.isNotEmpty ?? false) ? src.description : null,
      if (prep.isNotEmpty) 'prepTime': prep,
      if (perform.isNotEmpty) 'performTime': perform,
      if (total.isNotEmpty) 'totalTime': total,
      if (src.recipeYield?.isNotEmpty ?? false) 'recipeYield': src.recipeYield,
      'recipeInstructions': instructions,
      'recipeIngredient': ingredients,
      // Mealie verlangt bei jedem Note-Eintrag das Pflichtfeld `title` — fehlt
      // es, antwortet der Server mit 422 (loc: [notes, n, title]). `n.title`
      // ist im Modell ohnehin nicht-nullable.
      if (src.notes.isNotEmpty)
        'notes':
            src.notes.map((n) => {'title': n.title, 'text': n.text}).toList(),
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add-Recipe-Sheet — Bottom-Sheet mit Suchfeld + Live-Result-Liste über
// dem lokalen Recipe-Cache (recipesProvider). Tap auf Treffer = pop mit
// dem ausgewählten Recipe; _openAddRecipeSheet startet dann die Session
// und navigiert.
// ─────────────────────────────────────────────────────────────────────────────

class _AddRecipeSheet extends ConsumerStatefulWidget {
  const _AddRecipeSheet();

  @override
  ConsumerState<_AddRecipeSheet> createState() => _AddRecipeSheetState();
}

class _AddRecipeSheetState extends ConsumerState<_AddRecipeSheet> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final recipesAsync = ref.watch(recipesProvider);
    // Aktive Sessions ausblenden — kein „Rezept zur Session hinzufügen das
    // schon in der Session ist".
    final activeIds =
        ref.watch(cookingSessionsProvider).map((s) => s.recipe.id).toSet();
    final results = recipesAsync.when(
      data: (all) {
        var list = all.where((r) => !activeIds.contains(r.id)).toList();
        final terms = searchTerms(_query);
        if (terms.isNotEmpty) {
          list = list.where((r) => recipeMatchesSearch(r, terms)).toList();
        }
        list.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        return list;
      },
      loading: () => const <RecipeDetail>[],
      error: (_, __) => const <RecipeDetail>[],
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) => Container(
        decoration: BoxDecoration(
          color: context.appBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            const SheetHandle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(l.cookingModeAddRecipe,
                        style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: context.appFg,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3)),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: context.appFgSub),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                controller: _controller,
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: l.cookingModeAddRecipeSearchHint,
                  hintStyle: TextStyle(color: context.appFgTertiary),
                  prefixIcon:
                      Icon(Icons.search_rounded, color: context.appFgSub),
                  filled: true,
                  fillColor: context.appSurface2,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTokens.rSm),
                    borderSide: BorderSide(color: context.appSeparator),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTokens.rSm),
                    borderSide:
                        const BorderSide(color: AppTokens.accent, width: 1.5),
                  ),
                ),
              ),
            ),
            Divider(color: context.appSeparator, height: 1),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: EdgeInsets.zero,
                itemCount: results.length,
                separatorBuilder: (_, __) => Divider(
                  color: context.appSeparator,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (_, i) {
                  final r = results[i];
                  return ListTile(
                    title: Text(r.name, style: TextStyle(color: context.appFg)),
                    subtitle: r.description == null || r.description!.isEmpty
                        ? null
                        : Text(r.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: context.appFgSub)),
                    onTap: () => Navigator.of(ctx).pop(r),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state — mirrors iOS emptyStateView
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyStateView extends StatelessWidget {
  final VoidCallback onDismiss;
  final AppLocalizations l;

  const _EmptyStateView({required this.onDismiss, required this.l});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        backgroundColor: context.appBg,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 92,
        leading: TextButton(
          onPressed: onDismiss,
          child: Text(l.done,
              maxLines: 1,
              softWrap: false,
              style: const TextStyle(
                  color: AppTokens.accentDeep, fontWeight: FontWeight.w700)),
        ),
        title: Text(l.cookingMode,
            style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: context.appFg,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2)),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTokens.accent.withValues(alpha: 0.12),
                  ),
                  child: const Icon(Icons.ramen_dining_rounded,
                      size: 48, color: AppTokens.accentDeep),
                ),
                const SizedBox(height: 20),
                Text(l.noActiveRecipes,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: context.appFg,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3)),
                const SizedBox(height: 8),
                Text(l.startRecipeToCook,
                    style: TextStyle(color: context.appFgSub, fontSize: 15),
                    textAlign: TextAlign.center),
                const SizedBox(height: 28),
                GradientButton(
                  label: l.browseRecipes,
                  icon: Icons.menu_book_rounded,
                  onTap: onDismiss,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Timer Overlay Bar — mirrors iOS CookingTimersOverlay
// ─────────────────────────────────────────────────────────────────────────────

class _TimerOverlayBar extends ConsumerStatefulWidget {
  final CookingSession session;
  final List<RecipeTimer> activeTimers;
  final AppLocalizations l;

  const _TimerOverlayBar({
    required this.session,
    required this.activeTimers,
    required this.l,
  });

  @override
  ConsumerState<_TimerOverlayBar> createState() => _TimerOverlayBarState();
}

class _TimerOverlayBarState extends ConsumerState<_TimerOverlayBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appBg,
        border:
            Border(bottom: BorderSide(color: context.appSeparator, width: 0.5)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Active timer chips
            ...widget.activeTimers
                .map((t) => _TimerChip(key: ValueKey(t.id), timer: t)),

            // Add timer button (+ Timer pill)
            GestureDetector(
              onTap: () => _showAddTimer(context),
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppTokens.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_circle_outline_rounded,
                        color: AppTokens.accentDeep, size: 15),
                    const SizedBox(width: 5),
                    Text(widget.l.timer,
                        style: const TextStyle(
                            color: AppTokens.accentDeep,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTimer(BuildContext context) =>
      showAddTimerSheet(context, ref, widget.session.recipe.name, widget.l);
}

// Wiederverwendbares „Neuer Timer"-Sheet — genutzt von der Timer-Leiste und
// dem ⋮-Menü („Timer hinzufügen").
void showAddTimerSheet(
    BuildContext context, WidgetRef ref, String recipeName, AppLocalizations l,
    {String? initialName, int? initialMinutes}) {
  final nameCtrl = TextEditingController(text: initialName ?? '');
  double minutes = (initialMinutes ?? 10).clamp(1, 600).toDouble();
  // Obergrenze 2 h, bei längeren Vorschlägen (Schmorgerichte) entsprechend
  // mehr, damit der Vorschlagswert einstellbar bleibt.
  final maxMinutes = math.max(120, minutes.ceil()).toDouble();

  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    backgroundColor: context.appCard,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => StatefulBuilder(
      builder: (ctx, setS) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(ctx).bottom +
              MediaQuery.paddingOf(ctx).bottom,
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
            Text(l.newTimer,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3)),
            const SizedBox(height: 14),
            TextField(
              controller: nameCtrl,
              style: TextStyle(color: context.appFg),
              decoration: InputDecoration(
                hintText: l.timerNamePlaceholder,
                hintStyle: TextStyle(color: context.appFgTertiary),
                filled: true,
                fillColor: context.appSurface2,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTokens.rSm),
                    borderSide:
                        BorderSide(color: context.appSeparator, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTokens.rSm),
                    borderSide:
                        const BorderSide(color: AppTokens.accent, width: 1.5)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(l.durationLabel,
                    style: TextStyle(
                        color: context.appFgSub, fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline_rounded,
                      color: AppTokens.accentDeep),
                  onPressed: () =>
                      setS(() => minutes = (minutes - 1).clamp(1, maxMinutes)),
                ),
                Text('${minutes.round()} ${l.minAbbreviation}',
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: context.appFg,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_rounded,
                      color: AppTokens.accentDeep),
                  onPressed: () =>
                      setS(() => minutes = (minutes + 1).clamp(1, maxMinutes)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: minutes,
              min: 1,
              max: maxMinutes,
              divisions: maxMinutes.round() - 1,
              activeColor: AppTokens.accent,
              onChanged: (v) => setS(() => minutes = v),
            ),
            const SizedBox(height: 8),
            GradientButton(
              label: l.start,
              icon: Icons.timer_outlined,
              onTap: () {
                final name = nameCtrl.text.trim().isEmpty
                    ? l.timer
                    : nameCtrl.text.trim();
                ref.read(timerProvider.notifier).addTimer(
                      name: name,
                      recipeName: recipeName,
                      minutes: minutes.round(),
                    );
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
}

/// Runder Knopf im Timer-Chip mit großer Tippfläche (≈ 42 pt).
class _ChipButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ChipButton(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }
}

// Timer chip widget — mirrors iOS CookingTimerChip.
// Ist der Timer fertig (Dauerton klingelt), wackelt + hüpft das Chip als
// Aufmerksamkeits-Signal und ein Tap auf das GANZE Chip beendet den Ton
// (entfernt den fertigen Timer → stoppt den Alarm, siehe TimerNotifier.stop).
class _TimerChip extends ConsumerStatefulWidget {
  final RecipeTimer timer;
  const _TimerChip({super.key, required this.timer});

  @override
  ConsumerState<_TimerChip> createState() => _TimerChipState();
}

class _TimerChipState extends ConsumerState<_TimerChip>
    with SingleTickerProviderStateMixin {
  // Treibt das „Wackeln + Hüpfen" eines fertigen, klingelnden Timer-Chips.
  late final AnimationController _wobble;

  @override
  void initState() {
    super.initState();
    _wobble = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    if (widget.timer.isFinished) _wobble.repeat();
  }

  @override
  void didUpdateWidget(covariant _TimerChip old) {
    super.didUpdateWidget(old);
    // Beim Übergang laufend → fertig die Animation starten, sonst stoppen.
    if (widget.timer.isFinished) {
      if (!_wobble.isAnimating) _wobble.repeat();
    } else if (_wobble.isAnimating) {
      _wobble.stop();
      _wobble.value = 0;
    }
  }

  @override
  void dispose() {
    _wobble.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timer = widget.timer;
    final l = AppLocalizations.of(context)!;
    final isExpiring = timer.remainingSeconds < 60 && !timer.isFinished;
    final chipColor = timer.isFinished
        ? Colors.green.withValues(alpha: 0.15)
        : isExpiring
            ? Colors.red.withValues(alpha: 0.15)
            : context.appSurface2;
    final borderColor = timer.isFinished
        ? Colors.green
        : isExpiring
            ? Colors.red
            : context.appSeparator;

    // Größer als früher (Name/Zeit 13/15 pt, Knöpfe 30 pt mit großzügiger
    // Tippfläche), damit Pause/Stopp auch mit nassen Fingern treffen.
    final chip = Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.fromLTRB(14, 8, 6, 8),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(timer.name,
                  style: TextStyle(
                      color: context.appFg,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              Text(
                timer.isFinished ? l.finished : timer.displayTime,
                style: TextStyle(
                    color: isExpiring ? Colors.red : context.appFgSub,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()]),
              ),
            ],
          ),
          const SizedBox(width: 6),
          // Fertig: ein Icon, das das Antippen zum Stummschalten andeutet (das
          // ganze Chip ist tappbar, siehe unten). Sonst Pause/Play + Stop.
          if (timer.isFinished)
            const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.notifications_off_rounded,
                  color: Colors.green, size: 26),
            )
          else ...[
            _ChipButton(
              icon: timer.isRunning
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_filled_rounded,
              color: AppTokens.accentDeep,
              onTap: () =>
                  ref.read(timerProvider.notifier).togglePause(timer.id),
            ),
            _ChipButton(
              icon: Icons.cancel_rounded,
              color: context.appFgTertiary,
              onTap: () =>
                  ref.read(timerProvider.notifier).removeTimer(timer.id),
            ),
          ],
        ],
      ),
    );

    // Laufender Timer: Chip steht still, Steuer-Icons handhaben die Taps.
    if (!timer.isFinished) return chip;

    // Fertiger Timer: ganzes Chip wackelt/hüpft und beendet bei Tap den Ton.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => ref.read(timerProvider.notifier).removeTimer(timer.id),
      child: AnimatedBuilder(
        animation: _wobble,
        builder: (context, child) {
          final v = _wobble.value; // 0..1, wiederholt
          final angle = math.sin(v * 2 * math.pi * 2) * 0.08; // wackeln
          final dy = -math.sin(v * math.pi).abs() * 5; // hüpfen (rauf/runter)
          return Transform.translate(
            offset: Offset(0, dy),
            child: Transform.rotate(angle: angle, child: child),
          );
        },
        child: chip,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Ingredient row — mirrors iOS ingredientRow
// ─────────────────────────────────────────────────────────────────────────────

/// Verlinktes Rezept (Mealie „Rezept als Zutat", z. B. Béchamelsauce in der
/// Lasagne) als WEITERES Rezept in denselben Kochmodus holen und dorthin
/// wechseln. Menge = Chargen des Unterrezepts, deshalb Portionsfaktor des
/// Hauptrezepts × Menge. Läuft das Unterrezept schon, wird nur gewechselt
/// (Fortschritt und eigene Portionswahl bleiben).
bool _isLinkedRecipe(Ingredient ing) =>
    ing.referencedRecipe != null && ing.food?.name?.isNotEmpty != true;

Future<void> _cookLinkedRecipe(BuildContext context, WidgetRef ref,
    Ingredient ing, double parentMultiplier) async {
  final linked = ing.referencedRecipe;
  if (linked == null) return;
  HapticFeedback.selectionClick();
  // Aus einem Bottom-Sheet heraus (Zutaten-Sheet): erst schließen, sonst
  // bliebe es über dem neuen Rezept liegen.
  final nav = Navigator.of(context);
  if (ModalRoute.of(context) is PopupRoute) nav.pop();

  RecipeDetail? sub;
  for (final r in ref.read(recipesProvider).valueOrNull ?? const []) {
    if (r.id == linked.id) {
      sub = r;
      break;
    }
  }
  if (sub == null) {
    try {
      sub = await ref.read(apiServiceProvider).fetchRecipeDetail(linked.id);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.errorLoadingRecipe)));
      return;
    }
  }
  final sessions = ref.read(cookingSessionsProvider.notifier);
  final alreadyCooking = sessions.getSession(sub.id) != null;
  sessions.startSession(sub);
  if (!alreadyCooking) {
    final qty = (ing.quantity ?? 0) > 0 ? ing.quantity! : 1.0;
    final factor = parentMultiplier * qty;
    if (factor != 1.0) sessions.setMultiplier(sub.id, factor);
  }
  if (!context.mounted) return;
  context.go('/cooking/${sub.id}');
}

class _IngredientRow extends StatelessWidget {
  final String text;
  final String? note;
  final bool done;
  final VoidCallback onTap;

  /// Verlinktes Rezept: Tap auf das Symbol holt es in den Kochmodus.
  final VoidCallback? onOpenLinked;

  const _IngredientRow({
    required this.text,
    this.note,
    required this.done,
    required this.onTap,
    this.onOpenLinked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Haken „poppt" beim Abhaken.
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.elasticOut,
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                  done ? Icons.check_circle_rounded : Icons.circle_outlined,
                  key: ValueKey(done),
                  color: done ? const Color(0xFF34A853) : context.appFgTertiary,
                  size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: done ? context.appFgTertiary : context.appFg,
                      fontSize: 15,
                      decoration: done ? TextDecoration.lineThrough : null,
                      decorationColor: context.appFgTertiary,
                    ),
                  ),
                  if (note != null && note!.isNotEmpty)
                    Text(note!,
                        style:
                            TextStyle(color: context.appFgSub, fontSize: 12)),
                ],
              ),
            ),
            if (onOpenLinked != null) _LinkedRecipeButton(onTap: onOpenLinked!),
          ],
        ),
      ),
    );
  }
}

/// Rundes „Mitkochen"-Symbol für verlinkte Rezepte.
class _LinkedRecipeButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LinkedRecipeButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            gradient: AppTokens.accentGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.menu_book_rounded,
              color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Schritt-fokussierter Kochmodus — neue UI-Bausteine
// ─────────────────────────────────────────────────────────────────────────────

// Mengen-Formatierung (Brüche): geteilte Logik mit der Rezept-Detailansicht
// (core/utils/ingredient_display.dart::formatQuantity) — vorher hatte der
// Kochmodus eine eigene, ältere Kopie mit einem kleineren Bruch-Set (kein
// ⅙/⅕/⅒) und ohne das "< Bruch"-Fallback für krumme Kleinmengen, wodurch
// dieselbe Zutat im Kochmodus anders (und falsch) formatiert wurde als in
// der Detailansicht bzw. in der Mealie-Webapp.

// Vom Host per P2P mitgeschickte Bildbytes (Gast ohne eigenen Server).
Uint8List? _sharedImageBytes(WidgetRef ref, String recipeId) {
  final shared = ref.watch(cookFriendsProvider).sharedState;
  if (shared == null) return null;
  for (final r in shared.recipes) {
    if (r.recipeId == recipeId &&
        r.imageBase64 != null &&
        r.imageBase64!.isNotEmpty) {
      try {
        return base64Decode(r.imageBase64!);
      } catch (_) {
        return null;
      }
    }
  }
  return null;
}

// Visueller Fortschrittsbalken (Verlauf), animiert.
/// Fortschritt im Kochmodus (0…1): geschaffte Schritte / Gesamt. Auf Schritt
/// k sind k-1 geschafft; vorab abgehakte zählen, falls mehr. Vorbereitungs-
/// seiten = 0, Abschluss-Seite = 1.
double cookingProgress({
  required int page,
  required int firstStepPage,
  required int stepCount,
  required int completedCount,
  required bool isFinalPage,
}) {
  if (isFinalPage) return 1.0;
  if (stepCount == 0) return 0.0;
  final passed = (page - firstStepPage).clamp(0, stepCount);
  return math.max(passed, completedCount) / stepCount;
}

/// Oranger Fortschrittsbalken unter der Kopfzeile des Kochmodus.
class CookProgressBar extends StatelessWidget {
  final double value;
  const CookProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final pct = (value.clamp(0.0, 1.0) * 100).round();
    return Semantics(
      value: '$pct%',
      child: Container(
        height: 6,
        color: context.appSurface2,
        child: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedFractionallySizedBox(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            widthFactor: value.clamp(0.0, 1.0),
            // Volle Höhe erzwingen: ohne heightFactor bekommt die Füllung
            // (DecoratedBox ohne Kind) nur lockere Vorgaben und schrumpft auf
            // Höhe 0 → der Balken war nie zu sehen.
            heightFactor: 1.0,
            child: const DecoratedBox(
              decoration: BoxDecoration(gradient: AppTokens.accentGradient),
            ),
          ),
        ),
      ),
    );
  }
}

// Kompakter Multi-Rezept-Wechsler (nur bei mehreren aktiven Sessions).
// × an jedem Tag beendet das einzelne Rezept (wenn [canEnd]).
class _RecipeSwitcher extends ConsumerWidget {
  final List<CookingSession> sessions;
  final String currentSlug;
  final bool canEnd;
  final void Function(String slug) onEndRecipe;
  const _RecipeSwitcher({
    required this.sessions,
    required this.currentSlug,
    required this.canEnd,
    required this.onEndRecipe,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: context.appSeparator, width: 0.5)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: sessions.map((s) {
            final sel = s.slug == currentSlug;
            final fg = sel ? Colors.white : context.appFgSub;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: sel ? null : () => context.go('/cooking/${s.slug}'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.only(
                      left: 14, right: canEnd ? 6 : 14, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    gradient: sel ? AppTokens.accentGradient : null,
                    color: sel ? null : context.appSurface2,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        s.recipe.name,
                        style: TextStyle(
                          color: fg,
                          fontSize: 13,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w600,
                        ),
                      ),
                      if (canEnd) ...[
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => onEndRecipe(s.slug),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Icon(Icons.close_rounded,
                                size: 16,
                                color:
                                    sel ? Colors.white : context.appFgTertiary),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Abschluss-Seite — „Guten Appetit". Erscheint immer als letzte Seite.
class _DonePage extends StatelessWidget {
  final AppLocalizations l;

  /// Toggle „Zuletzt gekocht aktualisieren" — nur sichtbar, wenn das Rezept
  /// vom eigenen Server kommt (kein Cook-Friends-Gast, Server konfiguriert).
  final bool showSyncToggle;
  final bool syncValue;
  final ValueChanged<bool> onSyncChanged;

  /// Optionaler Kommentar (null = Feld ausblenden).
  final TextEditingController? commentController;
  final File? photo;
  final VoidCallback? onPickPhoto;
  final VoidCallback onRemovePhoto;

  const _DonePage({
    required this.l,
    required this.showSyncToggle,
    required this.syncValue,
    required this.onSyncChanged,
    this.commentController,
    this.photo,
    this.onPickPhoto,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        // Wischen schließt die Tastatur des Kommentarfelds.
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTokens.accentGradient,
                boxShadow: context.appAccentGlow,
              ),
              child: const Icon(Icons.restaurant_rounded,
                  color: Colors.white, size: 52),
            ),
            const SizedBox(height: 28),
            Text(l.bonAppetit,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5)),
            const SizedBox(height: 10),
            Text(l.recipeFinished,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: context.appFgSub,
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w500)),
            if (showSyncToggle) ...[
              const SizedBox(height: 28),
              // Entscheidet, ob der „Beenden"-Button das heutige Datum als
              // „Zuletzt gekocht" zum Server schreibt (Webapp-Feld lastMade).
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: context.appCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.appSeparator, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.history_rounded,
                        size: 20, color: context.appFgSub),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.syncLastCooked,
                              style: TextStyle(
                                  color: context.appFg,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          Text(l.syncLastCookedSubtitle,
                              style: TextStyle(
                                  color: context.appFgSub, fontSize: 12)),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: syncValue,
                      onChanged: onSyncChanged,
                      activeThumbColor: const Color(0xFF30D158),
                    ),
                  ],
                ),
              ),
            ],
            if (onPickPhoto != null) ...[
              const SizedBox(height: 14),
              // Foto für den Zeitleisten-Eintrag (optional).
              if (photo == null)
                OutlinedButton.icon(
                  onPressed: onPickPhoto,
                  icon: const Icon(Icons.add_a_photo_rounded),
                  label: Text(l.cookingDonePhotoHint),
                )
              else
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(photo!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Material(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: const CircleBorder(),
                        child: IconButton(
                          tooltip: l.timelineRemovePhoto,
                          icon: const Icon(Icons.close_rounded,
                              color: Colors.white),
                          onPressed: onRemovePhoto,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
            if (commentController != null) ...[
              const SizedBox(height: 14),
              // Optionaler Kommentar — wird beim „Beenden" gespeichert.
              TextField(
                controller: commentController,
                minLines: 2,
                maxLines: 5,
                // Mehrzeilig → die Eingabetaste macht nur einen Zeilenumbruch,
                // iOS hat keine Taste zum Einklappen. Tippen daneben schließt
                // die Tastatur (sonst steckte man im Kochmodus fest).
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(color: context.appFg, fontSize: 14),
                decoration: InputDecoration(
                  labelText: l.cookingDoneCommentLabel,
                  hintText: l.cookingDoneCommentHint,
                  prefixIcon: Icon(Icons.chat_bubble_outline_rounded,
                      color: context.appFgSub),
                  filled: true,
                  fillColor: context.appCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: context.appSeparator),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: context.appSeparator),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Genau EIN Kochschritt — groß, gut lesbar, Bild + Timer-Chips.
class _StepView extends ConsumerWidget {
  final CookingSession session;
  final int stepIndex;
  final int stepNumber; // 1-basierte Anzeige
  final AppLocalizations l;
  const _StepView(
      {required this.session,
      required this.stepIndex,
      required this.stepNumber,
      required this.l});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = session.recipe;
    final steps = recipe.recipeInstructions;
    if (steps.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(l.noActiveTimers == '' ? '' : '—',
              style: TextStyle(color: context.appFgSub)),
        ),
      );
    }

    final step = steps[stepIndex];
    final settings = ref.watch(settingsProvider).valueOrNull;
    final serverUrl = settings?.serverUrl ?? '';
    final token = settings?.apiToken ?? '';
    final done = stepIndex < session.completedInstructions.length &&
        session.completedInstructions[stepIndex];

    // Schrittbild: Markdown-Bild im Text (Mealie hat kein Step-Image-Feld) →
    // sonst Fallback aufs Rezept-Hauptbild.
    final embedded =
        serverUrl.isEmpty ? null : stepImageUrl(step.text, serverUrl);
    final mainUrl =
        '$serverUrl/api/media/recipes/${recipe.id}/images/original.webp';
    // Ein GAST sieht ein Rezept, das auf dem HOST-Server liegt — sein eigener
    // serverUrl kann recipe.id nicht ausliefern (404). Daher immer die vom Host
    // per P2P mitgesendeten Bildbytes nutzen, nicht nur im server-losen
    // Gastmodus (serverUrl.isEmpty). Host/Solo lädt weiter per Netzwerk.
    final isGuest =
        ref.watch(cookFriendsProvider).role == CookFriendsRole.guest;
    final sharedBytes = (isGuest || serverUrl.isEmpty)
        ? _sharedImageBytes(ref, recipe.id)
        : null;
    final displayText = stripMarkdownImages(step.text);
    final timers = extractStepTimers(step.text);
    final section = instructionSectionAt(steps, stepIndex);

    Widget image;
    if (sharedBytes != null) {
      image = Image.memory(sharedBytes,
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => _stepImgPlaceholder(context));
    } else if (embedded != null) {
      image = CachedNetworkImage(
        imageUrl: embedded,
        httpHeaders: {'Authorization': 'Bearer $token'},
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        placeholder: (_, __) => _stepImgPlaceholder(context),
        errorWidget: (_, __, ___) => _stepImgPlaceholder(context),
      );
    } else {
      // Rezept-Hauptbild → Offline-Kopie, falls gespeichert.
      image = RecipeImage(
        recipeId: recipe.id,
        imageUrl: mainUrl,
        httpHeaders: {'Authorization': 'Bearer $token'},
        width: double.infinity,
        height: 220,
        placeholder: _stepImgPlaceholder,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bild des aktuellen Schritts + Schritt-Badge.
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTokens.rLg),
            child: Stack(
              children: [
                SizedBox(width: double.infinity, height: 220, child: image),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: AppTokens.accentGradient,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0x59FF7800),
                            blurRadius: 12,
                            offset: Offset(0, 4))
                      ],
                    ),
                    child: Text(l.stepNumber(stepNumber),
                        style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
                if (done)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF34A853),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_rounded,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(l.finished,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Abschnitt (Mealie-Titel, gilt bis zum nächsten) auf JEDER Seite
          // des Abschnitts — beim Kochen sieht man immer, woran man gerade
          // ist („Füllung"), nicht nur auf dessen erstem Schritt.
          if (section != null) ...[
            Row(
              children: [
                const Icon(Icons.segment_rounded,
                    color: AppTokens.accentDeep, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(section,
                      style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: AppTokens.accentDeep,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3)),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          // Überschrift dieses Schritts (Mealie `summary`).
          if (step.heading != null) ...[
            Text(step.heading!,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3)),
            const SizedBox(height: 10),
          ],
          // Große, gut lesbare Anweisung — erkannte Zutaten orange + antippbar.
          _StepText(
            text: displayText.isEmpty ? '—' : displayText,
            ingredients: recipe.recipeIngredient,
            multiplier: session.quantityMultiplier,
            dimmed: done,
            serverUrl: serverUrl,
          ),
          // Explizit verknüpfte Zutaten des Schritts (Mealie
          // `ingredientReferences`) — als eigene Karte unterm Text, skaliert
          // mit der Portionswahl. In Zutaten-Reihenfolge, wie im Mealie-Web.
          Builder(builder: (context) {
            final refSet = step.ingredientRefs.toSet();
            final linked = recipe.recipeIngredient
                .where((ing) =>
                    ing.referenceId != null && refSet.contains(ing.referenceId))
                .toList();
            if (linked.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: _LinkedIngredientsCard(
                ingredients: linked,
                multiplier: session.quantityMultiplier,
                dimmed: done,
                l: l,
                onOpenLinked: isGuest
                    ? null
                    : (ing) => _cookLinkedRecipe(
                        context, ref, ing, session.quantityMultiplier),
              ),
            );
          }),
          if (timers.isNotEmpty) ...[
            const SizedBox(height: 20),
            _StepTimerChips(timers: timers, recipeName: recipe.name, l: l),
          ],
        ],
      ),
    );
  }

  Widget _stepImgPlaceholder(BuildContext context) => Container(
        color: context.appSurface2,
        child: Icon(Icons.restaurant_rounded,
            color: context.appFgTertiary, size: 56),
      );
}

// Verknüpfte Zutaten eines Schritts (Mealie `ingredientReferences`) als
// kompakte Karte: Mini-Label + eine Zeile pro Zutat, Mengen skaliert.
class _LinkedIngredientsCard extends StatelessWidget {
  final List<Ingredient> ingredients;
  final double multiplier;
  final bool dimmed;
  final AppLocalizations l;
  final void Function(Ingredient)? onOpenLinked;

  const _LinkedIngredientsCard({
    required this.ingredients,
    required this.multiplier,
    required this.dimmed,
    required this.l,
    this.onOpenLinked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: context.appSurface2,
        borderRadius: BorderRadius.circular(AppTokens.rMd),
        border: Border.all(color: context.appSeparator),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.ingredients.toUpperCase(),
            style: TextStyle(
              color: context.appFgTertiary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          for (final (i, ing) in ingredients.indexed) ...[
            if (i > 0) const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(Icons.shopping_basket_rounded,
                      size: 15,
                      color: dimmed
                          ? context.appFgTertiary
                          : AppTokens.accentDeep),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _scaledIngredientText(ing, multiplier),
                    style: TextStyle(
                      color: dimmed ? context.appFgSub : context.appFg,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
                if (onOpenLinked != null && _isLinkedRecipe(ing))
                  _LinkedRecipeButton(onTap: () => onOpenLinked!(ing)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// Timer-Vorschläge des aktuellen Schritts — ein Tap startet den Timer.
class _StepTimerChips extends ConsumerWidget {
  final List<StepTimer> timers;
  final String recipeName;
  final AppLocalizations l;
  const _StepTimerChips(
      {required this.timers, required this.recipeName, required this.l});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: timers.map((t) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            ref.read(timerProvider.notifier).addTimer(
                  name: '${l.timer} ${t.label}',
                  recipeName: recipeName,
                  minutes: t.minutes,
                );
          },
          // Lang drücken: Zeit anpassen und Namen vergeben, bevor der Timer
          // startet (vorbelegt mit dem Vorschlag aus dem Rezepttext).
          onLongPress: () {
            HapticFeedback.mediumImpact();
            showAddTimerSheet(context, ref, recipeName, l,
                initialName: '${l.timer} ${t.label}',
                initialMinutes: t.minutes);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              gradient: AppTokens.accentGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x40FF7800),
                    blurRadius: 10,
                    offset: Offset(0, 3))
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined, color: Colors.white, size: 18),
                const SizedBox(width: 7),
                Text('${l.timer} ${t.label}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Feste Bottom-Navigation: ←  ✓  → (große Touch-Flächen, einhändig).
class _StepNavBar extends ConsumerWidget {
  final String slug;
  final int page; // 0 = Zutaten-Vorbereitung, 1.. = Kochschritt
  final int pageCount;

  /// Seite des ersten Kochschritts (davor: Utensilien/Zutaten).
  final int firstStepPage;
  final bool isStepDone;
  final bool allIngredientsDone;
  final AppLocalizations l;
  final VoidCallback onEnd;
  const _StepNavBar({
    required this.slug,
    required this.page,
    required this.pageCount,
    required this.firstStepPage,
    required this.isStepDone,
    required this.allIngredientsDone,
    required this.l,
    required this.onEnd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.read(cookingSessionsProvider.notifier);
    // Utensilien- und Zutaten-Seite: nichts abzuhaken, nur „Weiter".
    final isPrep = page < firstStepPage;
    final isFinal = page == pageCount - 1;

    void goTo(int p) {
      if (p < 0 || p >= pageCount) return;
      HapticFeedback.selectionClick();
      n.setInstructionIndex(slug, p);
    }

    void doneAndNext() {
      HapticFeedback.mediumImpact();
      // Auf der Vorbereitungs-Seite gibt es keinen Schritt zum Abhaken →
      // einfach weiter zum ersten Kochschritt.
      if (!isPrep && !isFinal && !isStepDone) {
        final stepIndex = page - firstStepPage;
        n.toggleInstruction(slug, stepIndex);
        final cf = ref.read(cookFriendsProvider);
        if (cf.role != CookFriendsRole.none) {
          ref.read(cookFriendsProvider.notifier).sendMessage(
              PeerMessage.toggleInstruction(recipeId: slug, index: stepIndex));
        }
      }
      if (page < pageCount - 1) n.setInstructionIndex(slug, page + 1);
    }

    // Mittel-Button: Abschluss → „Beenden"; Vorbereitung → „Weiter" bzw.
    // „Fertig" wenn alle Zutaten abgehakt; sonst „Erledigt".
    final centerLabel = isFinal
        ? l.end
        : (isPrep ? (allIngredientsDone ? l.done : l.next) : l.finished);
    final centerIcon = isFinal
        ? Icons.check_circle_rounded
        : (isPrep
            ? (allIngredientsDone
                ? Icons.check_rounded
                : Icons.arrow_forward_rounded)
            : (isStepDone ? Icons.check_circle_rounded : Icons.check_rounded));
    final centerOnTap = isFinal ? onEnd : doneAndNext;

    return Container(
      decoration: BoxDecoration(
        color: context.appCard,
        border: Border(top: BorderSide(color: context.appSeparator, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              _NavSquare(
                icon: Icons.arrow_back_rounded,
                enabled: page > 0,
                semantic: l.back,
                onTap: () => goTo(page - 1),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Semantics(
                  button: true,
                  label: centerLabel,
                  child: GestureDetector(
                    onTap: centerOnTap,
                    child: Container(
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: AppTokens.accentGradient,
                        borderRadius: BorderRadius.circular(AppTokens.rMd),
                        boxShadow: context.appAccentGlow,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(centerIcon, color: Colors.white, size: 26),
                          const SizedBox(width: 9),
                          Text(centerLabel,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _NavSquare(
                icon: Icons.arrow_forward_rounded,
                enabled: page < pageCount - 1,
                semantic: l.next,
                onTap: () => goTo(page + 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavSquare extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final String semantic;
  final VoidCallback onTap;
  const _NavSquare({
    required this.icon,
    required this.enabled,
    required this.semantic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: semantic,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(AppTokens.rMd),
            border: Border.all(color: context.appSeparator, width: 1),
          ),
          child: Icon(icon,
              size: 26, color: enabled ? context.appFg : context.appFgTertiary),
        ),
      ),
    );
  }
}

// Führende Zahl aus einem (skalierten) Yield-Text, z. B. „4 Portionen" → „4",
// „4" → „4". Null wenn keine Zahl enthalten (dann neutrale Überschrift).
String? _yieldCount(String s) {
  final m = RegExp(r'(\d+(?:[.,/]\d+)?)').firstMatch(s);
  return m?.group(1);
}

// Skalierte Anzeige einer Zutat (z. B. „400 g Erdäpfel"). Verhält sich exakt
// wie die Detailansicht: bei unparsten Zutaten (Menge steckt im Notiz-Text)
// wird die führende Zahl IM Text skaliert (`_scaledNote`), sonst das
// `quantity`-Feld.
String _scaledIngredientText(Ingredient ing, double m) {
  final hasQty = (ing.quantity ?? 0) > 0;
  final hasUnit = ing.unit?.name?.isNotEmpty == true;
  final hasFood = ing.food?.name?.isNotEmpty == true;
  if (!hasFood && ing.referencedRecipe != null) {
    // Verlinktes Rezept — gleiche Darstellung wie in der Detailansicht.
    final (:amount, :name) = ingredientDisplayParts(ing, m);
    return '$amount $name'.trim();
  }
  if (ing.disableAmount == true || (!hasQty && !hasFood && !hasUnit)) {
    return _scaledNote(ing.note, m);
  }
  final parts = <String>[
    if (hasQty) formatQuantity((ing.quantity ?? 0) * m),
    if (hasUnit) ing.unit!.name!,
  ];
  if (hasFood) {
    parts.add(ing.food!.name!);
    if (ing.note?.isNotEmpty == true) parts.add('(${ing.note})');
  } else if (ing.note?.isNotEmpty == true) {
    parts.add(ing.note!);
  }
  return parts.join(' ').trim();
}

// Skaliert nur die FÜHRENDE Zahl in einem freien Notiz-Text (jede Sprache/
// Einheit bleibt erhalten). Behandelt Ganzzahlen, „0,5"/„0.5" und „1/2".
// Spiegelt `_scaledNote` der Detailansicht.
String _scaledNote(String? note, double m) {
  if (note == null || note.trim().isEmpty) return '';
  final trimmed = note.trim();
  final match =
      RegExp(r'^(\d+(?:[.,]\d+)?(?:/\d+(?:[.,]\d+)?)?)(.*)$', dotAll: true)
          .firstMatch(trimmed);
  if (match == null) return note; // keine führende Zahl → unverändert
  final numberStr = match.group(1)!;
  final rest = match.group(2) ?? '';
  double? parsed;
  if (numberStr.contains('/')) {
    final p = numberStr.split('/');
    final a = double.tryParse(p[0].replaceAll(',', '.'));
    final b = p.length == 2 ? double.tryParse(p[1].replaceAll(',', '.')) : null;
    if (a != null && b != null && b != 0) parsed = a / b;
  } else {
    parsed = double.tryParse(numberStr.replaceAll(',', '.'));
  }
  if (parsed == null) return note;
  return '${formatQuantity(parsed * m)}$rest';
}

// Einheiten, Mengenwörter und häufige Qualifizierer (mehrsprachig), die KEINE
// Lebensmittel sind und daher nicht als Highlight-Kandidat zählen.
const _ingredientStopwords = <String>{
  // Einheiten / Mengen
  'gramm', 'gr', 'kg', 'mg', 'milliliter', 'liter', 'dl', 'cl',
  'esslöffel', 'essloeffel', 'teelöffel', 'teeloeffel', 'msp', 'messerspitze',
  'prise', 'prisen', 'stück', 'stueck', 'stk', 'handvoll', 'bund', 'dose',
  'dosen', 'packung', 'päckchen', 'paeckchen', 'zehe', 'zehen', 'scheibe',
  'scheiben', 'blatt', 'blätter', 'blaetter', 'tasse', 'tassen', 'glas',
  'cup', 'cups', 'tbsp', 'tsp', 'tablespoon', 'teaspoon', 'pound', 'ounce',
  'clove', 'cloves', 'slice', 'slices', 'pinch', 'can', 'cucharada',
  'cucharadita', 'taza', 'tazas', 'pizca', 'diente', 'cuillère', 'cuillere',
  'cuillères', 'gousse', 'gousses', 'tranche', 'tranches', 'eetlepel',
  'theelepel', 'snufje', 'teen', 'tenen', 'plakje',
  // Füllwörter
  'und', 'oder', 'mit', 'ohne', 'etwas', 'nach', 'zum', 'zur', 'von', 'pro',
  'ca', 'etwa', 'optional', 'bzw', 'sowie', 'evtl', 'and', 'with', 'for',
  'the', 'fresh', 'dried', 'ground', 'whole', 'chopped',
  // Häufige Qualifizierer
  'festkochende', 'festkochend', 'mehlig', 'mehlige', 'gelbe', 'gelber',
  'rote', 'roter', 'grüne', 'grüner', 'gruene', 'gruener', 'weiße', 'weißer',
  'weisse', 'weisser', 'schwarzer', 'schwarze', 'schwarz', 'getrocknet',
  'getrocknete', 'getrockneter', 'getrocknetem', 'gehackt', 'gehackte',
  'gehackter', 'gemahlen', 'gemahlene', 'gemahlener', 'ganzer', 'ganze',
  'ganz', 'edelsüßes', 'edelsüß', 'edelsuesses', 'fein', 'feine', 'feiner',
  'grob', 'grobe', 'klein', 'kleine', 'groß', 'große', 'gross', 'grosse',
  'frisch', 'frische', 'frischer', 'frischen', 'warm', 'warme', 'kalt',
  'kalte', 'lauwarm', 'reife', 'reifer', 'mild', 'milde', 'scharf', 'scharfe',
};

// Sehr kurze (< 3 Zeichen) Wörter, die TROTZDEM echte Lebensmittel sind und
// als Highlight-Kandidat zählen dürfen (de „Ei"/„Öl", nl „Ei"). Sie matchen
// NUR exakt (die Substring-Regel greift erst ab 4 Zeichen), daher ungefährlich:
// ein Treffer braucht das ganze Wort „Ei"/„Öl" als eigenes Wort im Schritttext —
// „zwei"/„Eis"/„Fleisch" lösen es NICHT aus.
const _shortFoodWords = <String>{'ei', 'öl'};

// Artikel (bestimmt + unbestimmt) aller fünf App-Sprachen (de/en/es/fr/nl).
// Sie dürfen NIE als Zutat hervorgehoben werden — weder als Schritt-Token
// (sonst leuchtet z. B. „eine" auf, weil es als Teilwort in „SchwEINEfleisch"
// steckt) noch als Zutaten-Kandidat. Bewusst getrennt von _ingredientStopwords,
// damit die Absicht „Artikel immer ausnehmen" klar bleibt.
const _articleWords = <String>{
  // Deutsch
  'der', 'die', 'das', 'den', 'dem', 'des',
  'ein', 'eine', 'einen', 'einem', 'einer', 'eines',
  // Englisch
  'the', 'a', 'an',
  // Spanisch
  'el', 'la', 'los', 'las', 'un', 'una', 'unos', 'unas',
  // Französisch
  'le', 'les', 'une', 'du', 'de',
  // Niederländisch
  'het', 'een',
};

// Häufige Präpositionen aller fünf App-Sprachen (de/en/es/fr/nl). Wie Artikel
// dürfen sie nie als Zutat hervorgehoben werden — vor allem nicht per Teilwort
// (z. B. „ohne" steckt in „Bohne"). Token- UND Kandidaten-seitig ausgeschlossen.
const _prepositionWords = <String>{
  // Deutsch
  'in', 'im', 'ins', 'auf', 'mit', 'ohne', 'aus', 'bei', 'nach', 'von', 'vor',
  'zu', 'zur', 'zum', 'über', 'unter', 'durch', 'für', 'gegen', 'um', 'an',
  'am', 'bis', 'seit', 'neben', 'zwischen', 'ab',
  // Englisch
  'on', 'at', 'with', 'without', 'for', 'of', 'to', 'from', 'into', 'onto',
  'over', 'under', 'by', 'off', 'out',
  // Spanisch
  'en', 'con', 'sin', 'por', 'para', 'sobre', 'bajo', 'entre', 'hasta',
  'desde', 'hacia',
  // Französisch
  'dans', 'avec', 'sans', 'sur', 'sous', 'pour', 'par', 'vers', 'chez',
  // Niederländisch
  'op', 'met', 'zonder', 'uit', 'naar', 'van', 'voor', 'onder', 'door', 'tot',
  'tussen', 'aan',
};

// Highlight-Kandidaten einer Zutat: alle „echten" Wörter aus dem Food-Namen
// (sonst der Notiz) — Einheiten, Zahlen, Füllwörter & Qualifizierer raus.
// Dadurch wird z. B. bei „400 Gramm festkochende Erdäpfel" das Wort „Erdäpfel"
// erkannt (nicht das Mengen-/Adjektiv-Wort).
List<String> _ingredientCandidateWords(Ingredient ing) {
  final src = (ing.food?.name?.trim().isNotEmpty == true)
      ? ing.food!.name!
      : (ing.note ?? '');
  final out = <String>[];
  for (final raw in src.split(RegExp(r'[\s,;()/.]+'))) {
    final w = raw
        .replaceAll(RegExp(r'[^\p{L}\p{N}]', unicode: true), '')
        .toLowerCase();
    if (w.length < 3 && !_shortFoodWords.contains(w)) continue;
    if (RegExp(r'^\d+$').hasMatch(w)) continue;
    if (_ingredientStopwords.contains(w) ||
        _articleWords.contains(w) ||
        _prepositionWords.contains(w)) {
      continue;
    }
    if (!out.contains(w)) out.add(w);
  }
  return out;
}

// Geteilte, abhakbare Zutatenliste (skalierte Mengen). Genutzt vom
// Vorbereitungs-Schritt UND vom Zutaten-Bottom-Sheet.
class _IngredientList extends ConsumerWidget {
  final String slug;
  final EdgeInsetsGeometry padding;

  /// Optionaler Abschluss NACH der letzten Zutat (z. B. der Notizen-Hinweis
  /// auf der Vorbereiten-Seite) — bleibt beim zweiten Verwendungsort
  /// (Zutaten-Sheet) standardmäßig weg.
  final Widget? footer;
  const _IngredientList({
    required this.slug,
    this.padding = const EdgeInsets.fromLTRB(16, 4, 16, 24),
    this.footer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref
        .watch(cookingSessionsProvider)
        .where((s) => s.slug == slug)
        .firstOrNull;
    if (session == null) return const SizedBox.shrink();
    final m = session.quantityMultiplier;
    final ings = session.recipe.recipeIngredient;
    final hasFooter = footer != null;

    return ListView.builder(
      padding: padding,
      itemCount: ings.length + (hasFooter ? 1 : 0),
      itemBuilder: (_, i) {
        if (hasFooter && i == ings.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: footer,
          );
        }
        final ing = ings[i];
        final done = i < session.completedIngredients.length &&
            session.completedIngredients[i];
        // Index bleibt 1:1 zu completedIngredients (und den Kochen-mit-
        // Freunden-Nachrichten): Abschnittstitel werden deshalb IN die Zeile
        // der Zutat gerendert statt als eigene Listeneinträge.
        final section = ing.sectionTitle;
        final header = section == null
            ? null
            : IngredientSectionHeader(
                title: section, isFirst: i == 0, horizontalPadding: 0);
        if (!ing.hasContent) return header ?? const SizedBox.shrink();
        final isGuest =
            ref.read(cookFriendsProvider).role == CookFriendsRole.guest;
        final row = _IngredientRow(
          onOpenLinked: (_isLinkedRecipe(ing) && !isGuest)
              ? () => _cookLinkedRecipe(context, ref, ing, m)
              : null,
          text: _scaledIngredientText(ing, m),
          note:
              ing.note?.isNotEmpty == true && ing.food?.name?.isNotEmpty == true
                  ? ing.note!
                  : null,
          done: done,
          onTap: () {
            HapticFeedback.selectionClick();
            ref
                .read(cookingSessionsProvider.notifier)
                .toggleIngredient(slug, i);
            final cf = ref.read(cookFriendsProvider);
            if (cf.role != CookFriendsRole.none) {
              ref.read(cookFriendsProvider.notifier).sendMessage(
                  PeerMessage.toggleIngredient(recipeId: slug, index: i));
            }
          },
        );
        if (header == null) return row;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [header, row],
        );
      },
    );
  }
}

// Erste Kochmodus-Seite, wenn in Mealie Utensilien hinterlegt sind: „Bitte
// folgende Utensilien bereitlegen" — gleicher Aufbau wie die Zutaten-Seite.
class _ToolsView extends ConsumerWidget {
  final String slug;
  final AppLocalizations l;
  const _ToolsView({required this.slug, required this.l});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref
        .watch(cookingSessionsProvider)
        .where((s) => s.slug == slug)
        .firstOrNull;
    if (session == null) return const SizedBox.shrink();
    final tools = session.recipe.tools;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  gradient: AppTokens.accentGradient,
                  boxShadow: context.appAccentGlow,
                ),
                child: const Icon(Icons.kitchen_rounded,
                    color: Colors.white, size: 23),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(l.prepareTools,
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: context.appFg,
                        fontSize: 21,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3)),
              ),
            ],
          ),
        ),
        Divider(color: context.appSeparator, height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: tools.length,
            itemBuilder: (_, i) => _IngredientRow(
              text: tools[i].name,
              done: i < session.completedTools.length &&
                  session.completedTools[i],
              onTap: () {
                HapticFeedback.selectionClick();
                ref.read(cookingSessionsProvider.notifier).toggleTool(slug, i);
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Kochmodus-Seite „Bitte folgende Zutaten vorbereiten" + Zutatenliste.
class _PrepView extends ConsumerWidget {
  final String slug;
  final AppLocalizations l;
  const _PrepView({required this.slug, required this.l});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref
        .watch(cookingSessionsProvider)
        .where((s) => s.slug == slug)
        .firstOrNull;
    if (session == null) return const SizedBox.shrink();
    final recipe = session.recipe;
    final m = session.quantityMultiplier;
    // Portionszahl aus dem (skalierten) Yield ziehen. Das lokalisierte Wort
    // „Portionen" steckt bereits in der Übersetzung — hier nur die Zahl.
    final yieldStr = (recipe.recipeYield ?? '').trim();
    final servings = yieldStr.isEmpty
        ? null
        : _yieldCount(scaleYield(recipe.recipeYield!, m));
    final heading = servings != null
        ? l.prepareIngredientsFor(servings)
        : l.prepareIngredients;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  gradient: AppTokens.accentGradient,
                  boxShadow: context.appAccentGlow,
                ),
                child: const Icon(Icons.shopping_basket_rounded,
                    color: Colors.white, size: 23),
              ),
              const SizedBox(width: 14),
              Expanded(
                // „… für X Portionen vorbereiten" (Wort lokalisiert) bzw.
                // neutral, wenn keine Portionszahl hinterlegt ist.
                child: Text(heading,
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: context.appFg,
                        fontSize: 21,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3)),
              ),
            ],
          ),
        ),
        Divider(color: context.appSeparator, height: 1),
        Expanded(
          child: _IngredientList(
              slug: slug,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              // Hinweis-Chip nach der letzten Zutat, nur wenn das Rezept
              // Notizen hat — öffnet sie schreibgeschützt in einem kleinen,
              // unter dem Chip verankerten Fenster (Bearbeiten bleibt dem
              // ⋮-Menü-Sheet vorbehalten).
              footer: () {
                // Kommentare nur, wenn vorhanden und nicht deaktiviert.
                final showComments = recipe.comments.isNotEmpty &&
                    !(recipe.settings?.disableComments ?? false);
                return recipe.notes.isNotEmpty || showComments
                    ? _PrepFooter(recipe: recipe, showComments: showComments)
                    : null;
              }()),
        ),
      ],
    );
  }
}

// Notiz-Hinweis-Chip auf der Vorbereiten-Seite. Öffnet ein eigenes, unter dem
// Chip verankertes Overlay statt showMenu/showModalBottomSheet: PopupMenuEntry
// bräuchte eine FESTE Höhe (Notiztext ist aber beliebig lang) und ein
// Bottom-Sheet wäre kein „kleines Fenster" mehr. Schreibgeschützt
// (`RecipeNotesList(editable:false)` blendet Bearbeiten-Icons + Add-Button
// automatisch aus).
class _ExpandableHint extends StatefulWidget {
  final IconData icon;
  final String title;
  final int count;
  final Widget child;
  const _ExpandableHint({
    required this.icon,
    required this.title,
    required this.count,
    required this.child,
  });

  @override
  State<_ExpandableHint> createState() => _ExpandableHintState();
}

class _ExpandableHintState extends State<_ExpandableHint> {
  // Inline statt Overlay: ein OverlayEntry zeichnet IMMER oberhalb der
  // gesamten Seite — inklusive der fixen bottomNavigationBar (Vor/Zurück +
  // Mitte-Button) — und deckt sie ab, sobald der Inhalt lang genug ist, um
  // unter den Button zu reichen. Als Teil der ganz normalen ListView (siehe
  // _IngredientList-Footer) wächst der Platzbedarf stattdessen einfach mit
  // in die Liste hinein und bleibt über sie erreichbar/scrollbar — die
  // Buttons darunter sind nie verdeckt, weil sie außerhalb des scrollbaren
  // Bereichs liegen.
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.appCard,
                borderRadius: BorderRadius.circular(AppTokens.rMd),
                border: Border.all(color: context.appSeparator),
                boxShadow: context.appShadowSm,
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      gradient: AppTokens.accentGradient,
                      boxShadow: context.appAccentGlow,
                    ),
                    child: Icon(widget.icon, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(widget.title,
                        style: TextStyle(
                            color: context.appFg,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ),
                  // Anzahl wie bei den Abschnitten der Detailansicht
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTokens.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text('${widget.count}',
                        style: const TextStyle(
                            color: AppTokens.accentDeep,
                            fontSize: 12,
                            fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(Icons.expand_more_rounded,
                        size: 20, color: context.appFgTertiary),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: _expanded
              ? Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: widget.child,
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

/// Unter der Zutatenliste der Vorbereitungsseite: Notizen und — darunter —
/// Kommentare, jeweils aufklappbar und nur zum Lesen (Bearbeiten/Schreiben
/// bleibt der Detailansicht bzw. dem ⋮-Menü vorbehalten).
class _PrepFooter extends StatelessWidget {
  final RecipeDetail recipe;
  final bool showComments;
  const _PrepFooter({required this.recipe, required this.showComments});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (recipe.notes.isNotEmpty)
          _ExpandableHint(
            icon: Icons.sticky_note_2_rounded,
            title: l.notes,
            count: recipe.notes.length,
            child: RecipeNotesList(
                recipe: recipe, editable: false, showHeader: false),
          ),
        if (recipe.notes.isNotEmpty && showComments) const SizedBox(height: 10),
        if (showComments)
          _ExpandableHint(
            icon: Icons.forum_rounded,
            title: l.commentsTitle,
            count: recipe.comments.length,
            child: RecipeCommentsSection(recipe: recipe, readOnly: true),
          ),
      ],
    );
  }
}

// Zutaten-Bottom-Sheet — bereits skalierte Mengen, abhakbar; Schritt bleibt
// im Fokus dahinter.
class _IngredientsSheet extends ConsumerWidget {
  final String slug;
  const _IngredientsSheet({required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref
        .watch(cookingSessionsProvider)
        .where((s) => s.slug == slug)
        .firstOrNull;
    if (session == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    final recipe = session.recipe;
    final m = session.quantityMultiplier;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.72,
      child: Column(
        children: [
          const SheetHandle(),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(l.ingredients,
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: context.appFg,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3)),
                const Spacer(),
                if ((recipe.recipeYield ?? '').trim().isNotEmpty)
                  Text(scaleYield(recipe.recipeYield!, m),
                      style: TextStyle(
                          color: context.appFgSub,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: context.appSeparator, height: 1),
          Expanded(child: _IngredientList(slug: slug)),
        ],
      ),
    );
  }
}

// Notizen-Sheet — zeigt/bearbeitet die Mealie-Rezeptnotizen (Titel+Text)
// während des Kochens, ohne den Schritt-Screen zu verlassen. Nutzt dieselbe
// RecipeNotesList wie die Detailansicht, damit Änderungen an beiden Stellen
// konsistent bleiben (persistRecipeNotes spiegelt die Session zurück).
class _NotesSheet extends StatelessWidget {
  final RecipeDetail recipe;
  final bool editable;
  const _NotesSheet({required this.recipe, required this.editable});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    // Feste Höhe (wie _IngredientsSheet) — sonst wirft Expanded bei
    // unbegrenzten Constraints in einer mainAxisSize.min-Column.
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: SheetHandle()),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(l.notes,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3)),
          ),
          const SizedBox(height: 8),
          Divider(color: context.appSeparator, height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: RecipeNotesList(
                  recipe: recipe, editable: editable, showHeader: false),
            ),
          ),
        ],
      ),
    );
  }
}

// Schritt-Text mit hervorgehobenen, antippbaren Zutaten-Wörtern.
// Erkannte Zutaten werden orange dargestellt; ein Tap zeigt die (skalierte)
// Zutat (z. B. „400 g Erdäpfel") als Snackbar.
class _StepText extends StatefulWidget {
  final String text;
  final List<Ingredient> ingredients;
  final double multiplier;
  final bool dimmed;

  /// Basis für relative Markdown-Link-URLs.
  final String serverUrl;

  const _StepText({
    required this.text,
    required this.ingredients,
    required this.multiplier,
    this.dimmed = false,
    this.serverUrl = '',
  });

  @override
  State<_StepText> createState() => _StepTextState();
}

class _StepTextState extends State<_StepText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Alte Recognizer freigeben (Liste wird pro Build neu aufgebaut).
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();

    final base = TextStyle(
      color: widget.dimmed ? context.appFgSub : context.appFg,
      fontSize: 21,
      height: 1.5,
      fontWeight: FontWeight.w500,
    );

    // Markdown: Block-Marker zu Klartext (kein Block-Layout im Kochmodus),
    // dann Inline-Segmente (fett/kursiv/Code/Links) parsen. Zutaten-
    // Highlighting läuft anschließend INNERHALB der Text-Segmente weiter.
    final flat = flattenMarkdownBlockMarkers(widget.text);
    final segments = parseInlineMarkdown(flat);
    final plainOnly = segments.length == 1 && segments.first.isPlain;

    // Kandidaten-Wörter → Zutat (exakte Map + Liste für Prefix-/Plural-Match).
    final exact = <String, Ingredient>{};
    final list = <(String, Ingredient)>[];
    for (final ing in widget.ingredients) {
      for (final w in _ingredientCandidateWords(ing)) {
        exact.putIfAbsent(w, () => ing);
        list.add((w, ing));
      }
    }
    if (plainOnly && exact.isEmpty) return Text(flat, style: base);

    Ingredient? matchFor(String token) {
      final t = token.toLowerCase();
      if (t.length < 2) return null;
      // Artikel (der/die/das/the/eine/le/la/…) und Präpositionen (in/auf/mit/
      // ohne/with/…) werden in ALLEN Sprachen nie hervorgehoben — auch dann
      // nicht, wenn sie als Teilwort in einer Zutat stecken (z. B. „eine" in
      // „Schweinefleisch", „ohne" in „Bohne").
      if (_articleWords.contains(t) || _prepositionWords.contains(t)) {
        return null;
      }
      // 1) Exakter Treffer. Auch sehr kurze Lebensmittel wie „Ei"/„Öl": Tokens
      //    sind ganze Wörter, deshalb matchen „zwei"/„Eis" hier NICHT „ei".
      final e = exact[t];
      if (e != null) return e;
      // 2) Teilwort-/Substring-Treffer („Buchstabe für Buchstabe"), BEIDSEITIG:
      //    die Zutat „Spinat" steckt in „Babyspinat"/„Cremespinat"/
      //    „Spinatblatt" → wird hervorgehoben; umgekehrt steckt das Schrittwort
      //    „Spinat" in der zusammengesetzten Zutat „Blattspinat". Deckt zugleich
      //    Flexion/Plural ab („Eier"→„Eiern", „Tomate"→„Tomaten", „Zwiebel"→
      //    „Zwiebeln", „Mehl"→„Mehls"). Das ENTHALTENE Wort muss >= 4 Zeichen
      //    lang sein, damit kurze Wörter wie „Ei" nicht als Teil von „zwei"/
      //    „Eis"/„Fleisch" false-positive matchen (die laufen nur über 1).
      for (final (c, ing) in list) {
        if (c.length >= 4 && t.contains(c)) return ing;
        if (t.length >= 4 && c.contains(t)) return ing;
      }
      return null;
    }

    // Segmente rendern: Links antippbar (Akzent), Code monospaced, im übrigen
    // Text wortweise Zutaten-Treffer markieren (wie bisher).
    final spans = <InlineSpan>[];
    for (final seg in segments) {
      final segStyle = _segmentStyle(context, seg);
      if (seg.linkUrl != null) {
        final url = seg.linkUrl!;
        final rec = TapGestureRecognizer()
          ..onTap = () => openMarkdownLink(url, serverUrl: widget.serverUrl);
        _recognizers.add(rec);
        spans.add(TextSpan(text: seg.text, style: segStyle, recognizer: rec));
      } else if (seg.code) {
        spans.add(TextSpan(text: seg.text, style: segStyle));
      } else {
        spans.addAll(_ingredientSpans(context, seg.text, segStyle, matchFor));
      }
    }

    return Text.rich(TextSpan(style: base, children: spans));
  }

  /// Wortweises Zutaten-Highlighting innerhalb eines Segments; [segStyle]
  /// (fett/kursiv aus Markdown) bleibt auf den Nicht-Treffern erhalten.
  List<InlineSpan> _ingredientSpans(BuildContext context, String text,
      TextStyle? segStyle, Ingredient? Function(String) matchFor) {
    final tokenRe = RegExp(r'[\p{L}]+', unicode: true);
    final spans = <InlineSpan>[];
    var last = 0;
    for (final mt in tokenRe.allMatches(text)) {
      final ing = matchFor(mt.group(0)!);
      if (ing == null) continue;
      if (mt.start > last) {
        spans.add(
            TextSpan(text: text.substring(last, mt.start), style: segStyle));
      }
      final rec = TapGestureRecognizer()
        ..onTap = () => _showIngredient(context, ing);
      _recognizers.add(rec);
      spans.add(TextSpan(
        text: text.substring(mt.start, mt.end),
        style: (segStyle ?? const TextStyle())
            .copyWith(color: AppTokens.accentDeep, fontWeight: FontWeight.w700),
        recognizer: rec,
      ));
      last = mt.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last), style: segStyle));
    }
    return spans;
  }

  /// Markdown-Stil eines Segments als Overlay über dem Basis-Stil.
  TextStyle? _segmentStyle(BuildContext context, MdSegment seg) {
    if (seg.isPlain) return null;
    var st = const TextStyle();
    if (seg.bold) st = st.copyWith(fontWeight: FontWeight.w700);
    if (seg.italic) st = st.copyWith(fontStyle: FontStyle.italic);
    if (seg.code) {
      st = st.copyWith(
        fontFamily: 'monospace',
        backgroundColor: context.appSurface2,
      );
    }
    final decorations = <TextDecoration>[
      if (seg.strike) TextDecoration.lineThrough,
      if (seg.linkUrl != null) TextDecoration.underline,
    ];
    if (decorations.isNotEmpty) {
      st = st.copyWith(decoration: TextDecoration.combine(decorations));
    }
    if (seg.linkUrl != null) {
      st = st.copyWith(
        color: AppTokens.accentDeep,
        fontWeight: seg.bold ? FontWeight.w800 : FontWeight.w600,
        decorationColor: AppTokens.accent.withValues(alpha: 0.55),
      );
    }
    return st;
  }

  void _showIngredient(BuildContext context, Ingredient ing) {
    HapticFeedback.selectionClick();
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: context.appCard,
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTokens.rMd),
        side: BorderSide(color: context.appSeparator),
      ),
      content: Row(
        children: [
          const Icon(Icons.shopping_basket_rounded,
              color: AppTokens.accentDeep, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(_scaledIngredientText(ing, widget.multiplier),
                style: TextStyle(
                    color: context.appFg,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    ));
  }
}
