import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../cooking_mode/widgets/cooking_mode_fab.dart';

import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../cooking_mode/providers/cooking_session_provider.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../services/cook_friends_service.dart';
import '../../../core/utils/search_match.dart';

class CookFriendsScreen extends ConsumerStatefulWidget {
  /// Recipe identifier (id or slug) the host wants to cook together.
  /// Empty when the user opened the screen just to join an existing session.
  final String slug;

  /// Beitritts-Code aus dem Invite-Deep-Link (mealierecipes://cook?code=…).
  /// Wenn gesetzt, tritt die View beim Öffnen automatisch der Session bei.
  final String code;
  const CookFriendsScreen({super.key, required this.slug, this.code = ''});

  @override
  ConsumerState<CookFriendsScreen> createState() => _CookFriendsScreenState();
}

class _CookFriendsScreenState extends ConsumerState<CookFriendsScreen> {
  final _codeCtrl = TextEditingController();
  bool _navigatedToCooking = false;
  // Host-Option: dürfen Gäste die geteilten Rezepte auf ihrem eigenen Server
  // speichern? Standardmäßig an; der Host kann es beim Erstellen ausschalten.
  bool _allowGuestSave = true;

  // Das zu hostende Rezept. Initial = widget.slug (wenn aus Rezept/Kochmodus
  // gestartet); leer wenn von Home → dann wählt der Host es per Picker.
  late String _hostSlug;

  @override
  void initState() {
    super.initState();
    _hostSlug = widget.slug;
    // Auto-Join, wenn die View über einen Invite-Link geöffnet wurde
    // (mealierecipes://cook?code=…). Code ins Feld spiegeln, damit der User
    // bei einem Fehlschlag (Host nicht im selben WLAN gefunden) erneut
    // versuchen kann. PostFrame, damit der Provider sicher bereit ist.
    if (widget.code.isNotEmpty) {
      _codeCtrl.text = widget.code.toUpperCase();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(cookFriendsProvider.notifier).joinSession(widget.code);
      });
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  void _startHosting() {
    // Kein vorgewähltes Rezept (z. B. von Home gestartet) → erst per Picker
    // wählen, dann hosten. „Picker wie beim Mealplan".
    if (_hostSlug.isEmpty) {
      _pickRecipeAndHost();
      return;
    }
    _hostWith(_hostSlug);
  }

  /// Öffnet den Rezept-Picker; bei Auswahl wird die Host-Session mit dem
  /// gewählten Rezept gestartet.
  Future<void> _pickRecipeAndHost() async {
    final id = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _HostRecipePicker(),
    );
    if (id == null || id.isEmpty || !mounted) return;
    setState(() => _hostSlug = id);
    _hostWith(id);
  }

  void _hostWith(String recipeId) {
    // Sicherstellen dass das Ziel-Rezept als CookingSession aktiv ist —
    // Multi-Recipe-Sharing baut den shared-State ausschließlich aus dem
    // cookingSessionsProvider, also muss das hier garantiert sein.
    final sessions = ref.read(cookingSessionsProvider);
    final hasSession = sessions.any((s) => s.slug == recipeId);
    if (!hasSession) {
      final recipes = ref.read(recipesProvider).valueOrNull ?? const [];
      for (final r in recipes) {
        if (r.id == recipeId || r.slug == recipeId) {
          ref.read(cookingSessionsProvider.notifier).startSession(r);
          break;
        }
      }
    }
    ref
        .read(cookFriendsProvider.notifier)
        .hostSession(allowGuestSave: _allowGuestSave);
  }

  /// Host wechselt in den (geteilten) Kochmodus. Kam die View MIT Rezept
  /// herein (aus dem Kochmodus → Cook-Friends), liegt der Kochmodus i. d. R.
  /// schon im Stack → pop. Wurde das Rezept erst per Picker gewählt (Home),
  /// gibt es keinen Kochmodus darunter → frisch pushen.
  void _enterCooking() {
    if (!mounted) return;
    if (widget.slug.isNotEmpty && context.canPop()) {
      context.pop();
    } else {
      context.push('/cooking/$_hostSlug');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final cfState = ref.watch(cookFriendsProvider);

    // Guest: once the host's first fullStateSync arrives, jump into the
    // shared cooking screen for that recipe. Without this the guest just
    // sits on the lobby with no idea what to cook.
    //
    // Wichtig: context.push (NICHT context.go) — go würde den Stack leeren
    // und der "Fertig"-Button auf der CookingMode hätte nichts zum poppen.
    // Der Recipe-Slug kommt aus recipeJson.id (kanonisch), Fallback auf
    // recipeSlug für Swift-Hosts die noch ohne recipeJson senden.
    ref.listen<CookFriendsState>(cookFriendsProvider, (prev, next) {
      if (_navigatedToCooking) return;

      // GUEST: sobald der erste fullStateSync ankommt, in den geteilten
      // Kochmodus springen.
      if (next.role == CookFriendsRole.guest) {
        final slug = (next.sharedState?.recipeJson?['id'] as String?) ??
            next.sharedState?.recipeSlug;
        if (slug == null || slug.isEmpty) return;
        _navigatedToCooking = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.push('/cooking/$slug');
        });
        return;
      }

      // HOST: sobald der erste Gast beitritt, zurück in den (geteilten)
      // Kochmodus weiterleiten — der Session-Code bleibt bis dahin sichtbar
      // zum Teilen. Der Host hat den Kochmodus i.d.R. bereits im Stack
      // (Kochmodus → Cook-Friends), daher pop statt push; nur wenn kein
      // Kochmodus darunter liegt, frisch öffnen.
      if (next.role == CookFriendsRole.host && _hostSlug.isNotEmpty) {
        final prevCount = prev?.guestCount ?? 0;
        if (prevCount == 0 && next.guestCount > 0) {
          _navigatedToCooking = true;
          WidgetsBinding.instance.addPostFrameCallback((_) => _enterCooking());
        }
      }
    });

    // Snackbar auch hier — falls der Guest beim Empfang der sessionEnded-
    // Message noch in der Lobby steht (CookingMode nicht offen, also der
    // Listener dort feuert nicht).
    ref.listen<int>(cookFriendsRemoteEndedTriggerProvider, (prev, next) {
      if (prev == next) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.hostEndedSessionMessage)),
        );
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l.cookFriends),
        actions: [
          if (cfState.role != CookFriendsRole.none)
            TextButton(
              onPressed: () =>
                  ref.read(cookFriendsProvider.notifier).endSession(),
              child: Text(l.end),
            ),
        ],
      ),
      body: WithCookingModeFAB(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              24,
              24,
              24,
              24 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: cfState.role == CookFriendsRole.none
                ? _buildLobby(context, l, cfState)
                : _buildSession(context, l, cfState),
          ),
        ),
      ),
    );
  }

  String _errorText(AppLocalizations l, CookFriendsErrorCode code) {
    switch (code) {
      case CookFriendsErrorCode.hostNotFound:
        return l.cookFriendsHostNotFound;
      case CookFriendsErrorCode.connectionFailed:
        return l.cookFriendsConnectionFailed;
    }
  }

  Widget _buildLobby(
      BuildContext context, AppLocalizations l, CookFriendsState cfState) {
    // Ohne eigenen Server ist Hosten nicht möglich — der Host baut den
    // geteilten State aus eigenen Rezepten/Kochsessions, die ein nicht
    // eingerichtetes Gerät nicht hat. Daher die Host-Karte dann ausblenden;
    // es bleibt nur „Beitreten". (`!isConfigured` statt des flüchtigen
    // Gastmodus-Flags — robuster.)
    final isGuest =
        ref.watch(settingsProvider).valueOrNull?.isConfigured != true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (cfState.error != null) ...[
          Text(_errorText(l, cfState.error!),
              style: TextStyle(color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 16),
        ],
        // Host (nur wenn KEIN Gastmodus)
        if (!isGuest) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const _IconBadge(icon: Icons.podcasts_rounded),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(l.cookFriendsHost,
                          style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 17,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Host entscheidet, ob Gäste die geteilten Rezepte auf ihrem
                // eigenen Server speichern dürfen.
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  activeThumbColor: AppTokens.accent,
                  value: _allowGuestSave,
                  onChanged: (v) => setState(() => _allowGuestSave = v),
                  title: Text(l.allowGuestSaveRecipes,
                      style: TextStyle(color: context.appFgSub, fontSize: 14)),
                ),
                const SizedBox(height: 8),
                GradientButton(
                  label: l.cookFriendsHost,
                  icon: Icons.podcasts_rounded,
                  onTap: _startHosting,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        // Join
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const _IconBadge(icon: Icons.login_rounded),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(l.cookFriendsJoin,
                        style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 17,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _codeCtrl,
                textCapitalization: TextCapitalization.characters,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: l.cookFriendsEnterCode,
                  filled: true,
                  fillColor: context.appSurface2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTokens.rSm),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GradientButton(
                label: l.cookFriendsJoin,
                icon: Icons.login_rounded,
                onTap: () {
                  if (_codeCtrl.text.trim().length == 6) {
                    ref
                        .read(cookFriendsProvider.notifier)
                        .joinSession(_codeCtrl.text.trim());
                  }
                },
              ),
            ],
          ),
        ),
        // Offer a path out of guest mode: connect to a Mealie server. Only
        // shown when the user hasn't already configured one — otherwise it
        // would be redundant noise.
        if (ref.watch(settingsProvider).valueOrNull?.isConfigured != true) ...[
          const SizedBox(height: 24),
          Center(
            child: TextButton.icon(
              onPressed: () => context.go('/setup'),
              icon: const Icon(Icons.dns_outlined),
              label: Text(l.setupConnectStep),
            ),
          ),
        ],
      ],
    );
  }

  // Host session view — mirrors iOS CookFriendsHostView (img_1634).
  Widget _buildSession(
      BuildContext context, AppLocalizations l, CookFriendsState cfState) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final code = cfState.sessionCode;
    final guestCount = cfState.guestCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header: icon + title + subtitle.
        const SizedBox(height: 8),
        Icon(Icons.groups_2_rounded, color: primary, size: 44),
        const SizedBox(height: 8),
        Text(l.cookWithFriends,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(l.cookFriendsSubtitle,
            textAlign: TextAlign.center,
            style:
                theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
        const SizedBox(height: 28),

        // Session code box.
        Text(l.cookFriendsCode.toUpperCase(),
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
                color: theme.hintColor,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(AppTokens.rLg),
            border: Border.all(color: context.appSeparator, width: 1),
          ),
          alignment: Alignment.center,
          child: ShaderMask(
            shaderCallback: (r) => AppTokens.accentGradient.createShader(r),
            blendMode: BlendMode.srcIn,
            child: Text(
              // Letter-spaced display matches iOS .tracking(12).
              code.split('').join(' '),
              style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 34,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Copy code (sekundär) + share link (Verlauf).
        SecondaryButton(
          label: l.copyCode,
          icon: Icons.copy_rounded,
          onTap: () {
            Clipboard.setData(ClipboardData(text: code));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.copied)),
            );
          },
        ),
        const SizedBox(height: 12),
        GradientButton(
          label: l.shareLink,
          icon: Icons.ios_share_rounded,
          onTap: () {
            final link = 'mealierecipes://cook?code=$code';
            Clipboard.setData(ClipboardData(text: link));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.linkCopied)),
            );
          },
        ),
        const SizedBox(height: 24),

        // Connected friends card.
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.appCard,
            borderRadius: BorderRadius.circular(AppTokens.rLg),
            border: Border.all(color: context.appSeparator, width: 1),
            boxShadow: context.appShadowSm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.connectedFriends,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      guestCount == 0
                          ? l.waitingForFriends
                          : l.cookFriendsConnected(guestCount),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.hintColor),
                    ),
                  ],
                ),
              ),
              if (guestCount == 0)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
        ),

        if (cfState.role == CookFriendsRole.host && _hostSlug.isNotEmpty) ...[
          const SizedBox(height: 24),
          GradientButton(
            label: l.startCooking,
            icon: Icons.local_fire_department_rounded,
            onTap: _enterCooking,
          ),
        ],
      ],
    );
  }
}

// Kleines Verlaufs-Icon-Badge für Karten-Header
class _IconBadge extends StatelessWidget {
  final IconData icon;
  const _IconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: AppTokens.accentGradient,
        boxShadow: context.appAccentGlow,
      ),
      child: Icon(icon, color: Colors.white, size: 21),
    );
  }
}

// ---------------------------------------------------------------------------
// Rezept-Picker zum Hosten (von Home aus) — durchsuchbare Liste, liefert die
// gewählte Rezept-id per Navigator.pop.
// ---------------------------------------------------------------------------

class _HostRecipePicker extends ConsumerStatefulWidget {
  const _HostRecipePicker();

  @override
  ConsumerState<_HostRecipePicker> createState() => _HostRecipePickerState();
}

class _HostRecipePickerState extends ConsumerState<_HostRecipePicker> {
  final _ctrl = TextEditingController();
  String _q = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final recipes = ref.watch(recipesProvider).valueOrNull ?? const [];
    final terms = searchTerms(_q);
    final filtered = terms.isEmpty
        ? recipes
        : recipes
            .where(
                (r) => recipeMatchesSearch(r, terms, includeDescription: false))
            .toList();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.72,
        child: Column(
          children: [
            const Center(child: SheetHandle()),
            const SizedBox(height: 6),
            Text(l.selectRecipe,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _ctrl,
                autofocus: true,
                style: TextStyle(color: context.appFg),
                onChanged: (v) => setState(() => _q = v),
                decoration: InputDecoration(
                  hintText: l.searchRecipe,
                  hintStyle: TextStyle(color: context.appFgTertiary),
                  prefixIcon:
                      Icon(Icons.search_rounded, color: context.appFgSub),
                  filled: true,
                  fillColor: context.appSurface2,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
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
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(l.noRecipesForCategory,
                          style: TextStyle(color: context.appFgSub)))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final r = filtered[i];
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppTokens.accent.withValues(alpha: 0.12),
                            ),
                            child: const Icon(Icons.restaurant_menu_rounded,
                                color: AppTokens.accentDeep, size: 20),
                          ),
                          title: Text(r.name,
                              style: TextStyle(
                                  color: context.appFg,
                                  fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          trailing: Icon(Icons.chevron_right_rounded,
                              color: context.appFgTertiary),
                          onTap: () => Navigator.pop(context, r.id),
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
