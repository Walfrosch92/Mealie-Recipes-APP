import '../../../core/utils/app_languages.dart';
import '../../../core/utils/platform_features.dart';
import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import '../../../shared/widgets/tap_area.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../cooking_mode/widgets/cooking_mode_fab.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/app_settings.dart';
import '../../../core/models/shopping_reminder_location.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/app_icon_service.dart';
import '../../../core/services/log_manager.dart';
import '../../../core/services/recipe_image_store.dart';
import '../../../core/services/support_mail_service.dart';
import '../../../core/services/wifi_name.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart' show SheetHandle;
import '../../../shared/widgets/liquid_glass.dart';
import '../../auth/providers/biometric_lock_provider.dart';
import '../../auth/services/account_switcher.dart';
import '../../auth/widgets/renew_token_sheet.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../../shopping_list/providers/shopping_list_provider.dart';
import '../../shopping_list/providers/shopping_lists_provider.dart';
import '../services/shopping_reminder_location_service.dart';
import '../../timer/services/notification_service.dart';
import '../../whats_new/whats_new.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // ── Sprung aus der globalen Suche: /settings?section=<key>&t=<ms> ──────
  // scrollt zum Abschnitt und hebt ihn kurz orange hervor.
  final Map<String, GlobalKey> _sectionKeys = {
    for (final k in const [
      'connection',
      'shopping',
      'advanced',
      'personalization',
      'security',
      'developer',
    ])
      k: GlobalKey(),
  };
  String? _handledJump;
  String? _highlight;
  Timer? _highlightTimer;

  void _handleSectionJump(BuildContext context) {
    final Uri uri;
    try {
      uri = GoRouterState.of(context).uri;
    } catch (_) {
      return;
    }
    final section = uri.queryParameters['section'];
    if (section == null) {
      _handledJump = null;
      return;
    }
    final jump = uri.query;
    if (jump == _handledJump) return;
    _handledJump = jump;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _sectionKeys[section]?.currentContext;
      if (!mounted || ctx == null) return;
      Scrollable.ensureVisible(ctx,
          alignment: 0.05,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut);
      setState(() => _highlight = section);
      _highlightTimer?.cancel();
      _highlightTimer = Timer(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _highlight = null);
      });
    });
  }

  // Temp state — only saved on button press, mirrors iOS SetupView
  final _urlCtrl = TextEditingController();
  final _tokenCtrl = TextEditingController();
  final _householdCtrl = TextEditingController();
  // WLAN-Umschaltung: andere Adresse desselben Servers im Heim-WLAN.
  final _wifiUrlCtrl = TextEditingController();
  final _wifiSsidCtrl = TextEditingController();
  bool _readingWifi = false;
  final _hk1 = TextEditingController();
  final _hv1 = TextEditingController();
  final _hk2 = TextEditingController();
  final _hv2 = TextEditingController();
  final _hk3 = TextEditingController();
  final _hv3 = TextEditingController();

  // ID des zuletzt per Login generierten Tokens (für Aufräumen bei Reset) —
  // leer, wenn das aktuelle Token manuell eingegeben wurde. Erneuern (Login
  // ODER manuell einfügen) läuft über den „API-Token erneuern"-Sheet
  // (_openRenewTokenSheet), das Token ist dauerhaft gültig — kein separater
  // Auth-Modus-Zustand nötig, solange kein Sheet offen ist.
  String? _generatedTokenId;

  String _tempLang = 'de';
  String _tempApiVersion = 'v2';
  bool _tempSendHeaders = false;
  bool _tempShowImages = true;
  bool _tempBiometric = false;
  bool _tempLogging = false;
  bool _tempExactQuantities = false;
  bool _tempOfflineImages = false;
  String _tempShoppingListId = '';

  // "Erinnere mich zum Einkaufen" (Issue #29) — bis zu 3 Standorte, siehe
  // _toggleRemindToShop/_addReminderLocation weiter unten.
  bool _tempRemindToShop = false;
  List<ShoppingReminderLocation> _tempReminderLocations = [];
  static const _reminderLocationService = ShoppingReminderLocationService();

  List<Map<String, dynamic>> _shoppingLists = [];
  bool _loadingLists = false;
  bool _saving = false;

  // Autosave: Text-Felder (Server-URL/Token/Haushalt/Header) speichern
  // debounced 800ms nach der letzten Eingabe, damit nicht jeder Tastendruck
  // einen Write auslöst. Toggle/Dropdown/Segmented-Änderungen speichern
  // sofort (gleiches Muster wie Sprache/Theme/Biometrie, die das schon immer
  // taten). Der „Speichern"-Button bleibt als explizite Bestätigung erhalten.
  Timer? _autosaveDebounce;

  void _scheduleAutosave() {
    _autosaveDebounce?.cancel();
    _autosaveDebounce = Timer(const Duration(milliseconds: 800), () {
      if (mounted) _persistAll();
    });
  }

  void _attachAutosaveListeners() {
    for (final c in [
      _urlCtrl,
      _tokenCtrl,
      _householdCtrl,
      _wifiUrlCtrl,
      _wifiSsidCtrl,
      _hk1,
      _hv1,
      _hk2,
      _hv2,
      _hk3,
      _hv3,
    ]) {
      c.addListener(_scheduleAutosave);
    }
  }

  // Alternate App Icon (iOS-only). _iconSupported gated den ganzen Abschnitt;
  // _modernIconActive spiegelt das aktuell gesetzte Icon (vom System geladen).
  bool _iconSupported = false;
  bool _modernIconActive = false;

  bool get _urlValid =>
      _urlCtrl.text.startsWith('http://') ||
      _urlCtrl.text.startsWith('https://');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = ref.read(settingsProvider).valueOrNull;
      if (s != null) {
        _loadFrom(s);
        // Auto-load shopping lists so the dropdown shows names, not the id.
        _fetchShoppingLists();
      }
      _loadAppIconState();
      _attachAutosaveListeners();
    });
  }

  // Aktuellen Alternate-Icon-Zustand vom System holen (iOS). Bestimmt, ob der
  // App-Icon-Abschnitt überhaupt erscheint und welche Option markiert ist.
  Future<void> _loadAppIconState() async {
    if (!Platform.isIOS) return;
    final supported = await AppIconService.supportsAlternateIcons();
    final modern = supported ? await AppIconService.isModernActive() : false;
    if (!mounted) return;
    setState(() {
      _iconSupported = supported;
      _modernIconActive = modern;
    });
  }

  Future<void> _setAppIconModern(bool modern) async {
    if (modern == _modernIconActive) return;
    setState(() => _modernIconActive = modern); // optimistisch
    try {
      await AppIconService.setModern(modern);
    } catch (_) {
      // Fehlgeschlagen → realen Zustand zurückspiegeln.
      if (mounted) _loadAppIconState();
    }
  }

  void _loadFrom(AppSettings s) {
    // Eingetragene Adresse, NICHT die evtl. gerade aktive WLAN-Adresse.
    _urlCtrl.text = s.primaryServerUrl;
    _tokenCtrl.text = s.apiToken;
    _householdCtrl.text = s.householdId;
    _wifiUrlCtrl.text = s.wifiServerUrl;
    _wifiSsidCtrl.text = s.wifiSsid;
    _hk1.text = s.optionalHeaderKey1;
    _hv1.text = s.optionalHeaderValue1;
    _hk2.text = s.optionalHeaderKey2;
    _hv2.text = s.optionalHeaderValue2;
    _hk3.text = s.optionalHeaderKey3;
    _hv3.text = s.optionalHeaderValue3;
    setState(() {
      _tempLang = s.selectedLanguage;
      _tempApiVersion = s.apiVersion;
      _tempSendHeaders = s.sendOptionalHeaders;
      _tempShowImages = s.showRecipeImages;
      _tempBiometric = s.isBiometricLockEnabled;
      _tempLogging = s.enableLogging;
      _tempExactQuantities = s.addExactQuantities;
      _tempOfflineImages = s.offlineRecipeImages;
      _tempShoppingListId = s.shoppingListId;
      _tempRemindToShop = s.remindToShopEnabled;
      _tempReminderLocations = s.shoppingReminderLocations;
      _generatedTokenId =
          s.generatedApiTokenId.isEmpty ? null : s.generatedApiTokenId;
    });
  }

  @override
  void dispose() {
    _highlightTimer?.cancel();
    _autosaveDebounce?.cancel();
    _urlCtrl.dispose();
    _tokenCtrl.dispose();
    _householdCtrl.dispose();
    _wifiUrlCtrl.dispose();
    _wifiSsidCtrl.dispose();
    _hk1.dispose();
    _hv1.dispose();
    _hk2.dispose();
    _hv2.dispose();
    _hk3.dispose();
    _hv3.dispose();
    super.dispose();
  }

  Future<void> _fetchShoppingLists() async {
    if (_urlCtrl.text.isEmpty || _tokenCtrl.text.isEmpty) return;
    setState(() => _loadingLists = true);
    try {
      final tmpSettings = AppSettings(
        serverUrl: _cleanServerUrl,
        apiToken: _tokenCtrl.text.trim(),
        householdId: _householdCtrl.text.trim(),
        sendOptionalHeaders: _tempSendHeaders,
        optionalHeaderKey1: _hk1.text.trim(),
        optionalHeaderValue1: _hv1.text.trim(),
      );
      final svc = ApiService(tmpSettings);
      final lists = await svc.fetchShoppingLists();
      if (!mounted) return;
      setState(() {
        _shoppingLists = lists;
        if (_tempShoppingListId.isEmpty && lists.isNotEmpty) {
          _tempShoppingListId = lists.first['id'] as String? ?? '';
        }
      });
      HapticFeedback.lightImpact();
    } catch (e) {
      HapticFeedback.vibrate();
    } finally {
      if (mounted) setState(() => _loadingLists = false);
    }
  }

  // Token erneuern: öffnet das Sheet mit der Wahl „eigenes Token einfügen"
  // vs. „per Login erzeugen lassen" (mirrors Setup Step 1). Das Sheet
  // validiert selbst (Verbindungstest bzw. Login+Erzeugen) und liefert bei
  // Erfolg (token, generatedId, version) zurück — Persistieren übernimmt
  // weiterhin „Änderungen speichern", wie bei jedem anderen Feld hier.
  Future<void> _openRenewTokenSheet() async {
    final url = _cleanServerUrl;
    if (url.isEmpty) {
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.required)));
      return;
    }
    final result = await showModalBottomSheet<(String, String?, String)>(
      context: context,
      // useRootNavigator: Tab-Screens liegen in einem Branch-Navigator —
      // ohne das Flag läge das Sheet hinter der fixen GlassTabBar.
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => RenewTokenSheet(
        serverUrl: url,
        sendOptionalHeaders: _tempSendHeaders,
        headerKey1: _hk1.text.trim(),
        headerValue1: _hv1.text.trim(),
        headerKey2: _hk2.text.trim(),
        headerValue2: _hv2.text.trim(),
        headerKey3: _hk3.text.trim(),
        headerValue3: _hv3.text.trim(),
      ),
    );
    if (result == null || !mounted) return;
    final (token, generatedId, ver) = result;
    setState(() {
      _tokenCtrl.text = token;
      _generatedTokenId = generatedId;
      _tempApiVersion = ver;
    });
    HapticFeedback.lightImpact();
    final l = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.apiTokenSaveHint)));
    await _fetchShoppingLists();
  }

  // Biometric-Toggle: bei Tap (Aktivieren ODER Deaktivieren) erst eine
  // Biometric-Confirmation verlangen, dann erst die Setting speichern.
  // Mirrors Swifts biometricLockBinding in SetupView: jede Änderung muss
  // durch die biometrische Auth des Systems (oder Geräte-Passcode-Fallback)
  // bestätigt werden.
  Future<void> _toggleBiometric(bool desired) async {
    if (desired == _tempBiometric) return;
    final l = AppLocalizations.of(context)!;
    final ok = await promptBiometricConfirmation(
      localizedReason: l.biometricPrompt,
    );
    if (!ok || !mounted) return;
    setState(() => _tempBiometric = desired);
    // Sofort persistieren — nicht erst beim Speichern-Button warten, sonst
    // wäre der gerade biometrisch bestätigte Wechsel beim nächsten App-
    // Start wieder weg.
    final current =
        ref.read(settingsProvider).valueOrNull ?? const AppSettings();
    await ref
        .read(settingsProvider.notifier)
        .save(current.copyWith(isBiometricLockEnabled: desired));
    // Beim Deaktivieren explizit den Lock-State leeren (falls noch true) —
    // sonst bliebe die Overlay-Sperre auf einem ungesperrten Setup hängen.
    // Beim Aktivieren NICHT lock() rufen, der User hat sich gerade
    // bestätigt; das Lock zündet beim nächsten Background-Wechsel von selbst.
    if (!desired) {
      ref.read(biometricLockProvider.notifier).forceUnlock();
    }
  }

  // -------------------------------------------------------------------------
  // "Erinnere mich zum Einkaufen" (Issue #29) — Geofence-Erinnerung an bis zu
  // 3 gespeicherten Standorten. Mirrors _toggleBiometric: vor dem Aktivieren
  // erst die Voraussetzung (hier: "Immer erlauben"-Standortberechtigung)
  // sichern, sonst feuert die native Geofence nicht bei geschlossener App.
  // -------------------------------------------------------------------------

  Future<void> _toggleRemindToShop(bool desired) async {
    if (desired == _tempRemindToShop) return;
    if (!desired) {
      setState(() => _tempRemindToShop = false);
      await _persistAll();
      return;
    }
    final l = AppLocalizations.of(context)!;
    final status = await _reminderLocationService.ensureAlwaysPermission();
    if (!mounted) return;
    if (status == ShoppingReminderPermissionStatus.grantedAlways) {
      // Ohne Mitteilungen kann die Erinnerung nie erscheinen — vorher wurde
      // das nicht geprüft und die Funktion blieb still.
      final allowed = await NotificationService.requestPermissions() ||
          await NotificationService.notificationsAllowed();
      if (!mounted) return;
      setState(() => _tempRemindToShop = true);
      await _persistAll();
      if (!allowed && mounted) await _showNotificationsOffDialog();
      return;
    }
    if (status == ShoppingReminderPermissionStatus.serviceDisabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.shoppingReminderLocationServiceDisabled)));
      return;
    }
    await _showReminderPermissionDialog(status);
  }

  Future<void> _showNotificationsOffDialog() async {
    final l = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.appCard,
        title: Text(l.shoppingReminderPermissionTitle,
            style: TextStyle(color: ctx.appFg)),
        content: Text(l.shoppingReminderNotificationsOff,
            style: TextStyle(color: ctx.appFgSub)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _reminderLocationService.openAppSettings();
            },
            child: Text(l.openSettings),
          ),
        ],
      ),
    );
  }

  Future<void> _showReminderPermissionDialog(
      ShoppingReminderPermissionStatus status) async {
    final l = AppLocalizations.of(context)!;
    // Bei einer einfachen (noch nicht endgültigen) Ablehnung öffnen die
    // Einstellungen nichts Hilfreiches — der Nutzer kann es einfach erneut
    // versuchen. Bei "immer abgelehnt" bzw. "nur bei Nutzung" ist der
    // Einstellungen-Umweg dagegen der einzige Weg zu "Immer erlauben".
    final canOpenSettings = status != ShoppingReminderPermissionStatus.denied;
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.appCard,
        title: Text(l.shoppingReminderPermissionTitle,
            style: TextStyle(color: ctx.appFg)),
        content: Text(l.shoppingReminderPermissionMessage,
            style: TextStyle(color: ctx.appFgSub)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          if (canOpenSettings)
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _reminderLocationService.openAppSettings();
              },
              child: Text(l.openSettings),
            ),
        ],
      ),
    );
  }

  Future<void> _addReminderLocation() async {
    if (_tempReminderLocations.length >= 3) return;
    final added = await showModalBottomSheet<ShoppingReminderLocation>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => _AddReminderLocationSheet(
        service: _reminderLocationService,
      ),
    );
    if (added == null || !mounted) return;
    setState(() => _tempReminderLocations = [
          ..._tempReminderLocations,
          added,
        ]);
    await _persistAll();
  }

  Future<void> _removeReminderLocation(String id) async {
    setState(() => _tempReminderLocations =
        _tempReminderLocations.where((l) => l.id != id).toList());
    await _persistAll();
  }

  // Schreibt den kompletten aktuellen Formular-Zustand in die Settings —
  // gemeinsam genutzt vom expliziten „Speichern"-Button UND vom Autosave
  // (Debounce-Timer der Text-Felder, sofortiger Aufruf bei Toggle/Dropdown/
  // Segmented-Änderungen). So landet bei JEDER Änderung immer der komplette
  // aktuelle Stand in den Settings — nicht nur das gerade geänderte Feld.
  /// Server-Adresse ohne Leerzeichen und Schrägstrich am Ende — wie im
  /// Setup. Sonst entstehen „…com//api/media/…"-Bildadressen (manche
  /// Proxys liefern dann 404, der Bild-Cache findet sie nicht wieder).
  String get _cleanServerUrl =>
      _urlCtrl.text.trim().replaceAll(RegExp(r'/+$'), '');

  String get _cleanWifiUrl =>
      _wifiUrlCtrl.text.trim().replaceAll(RegExp(r'/+$'), '');

  /// „Aktuelles WLAN übernehmen": Standortberechtigung anfragen (Android/iOS
  /// geben den WLAN-Namen nur damit heraus) und den Namen eintragen.
  Future<void> _useCurrentWifi() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _readingWifi = true);
    String? name;
    try {
      await ensureWifiNamePermission();
      name = await readWifiName();
    } finally {
      if (mounted) setState(() => _readingWifi = false);
    }
    if (!mounted) return;
    if (name == null) {
      HapticFeedback.vibrate();
      messenger.showSnackBar(SnackBar(content: Text(l.wifiNameUnavailable)));
      return;
    }
    HapticFeedback.selectionClick();
    _wifiSsidCtrl.text = name; // Listener → Autosave
  }

  Future<void> _persistAll() async {
    final current =
        ref.read(settingsProvider).valueOrNull ?? const AppSettings();
    final shoppingListChanged = current.shoppingListId != _tempShoppingListId;
    // Neue Liste → auch ihre Abteilungs-Reihenfolge (Mealie speichert sie
    // pro Liste) übernehmen, wie beim Wechsel über das ⋮-Menü.
    List<String>? listOrder;
    if (shoppingListChanged) {
      for (final m in _shoppingLists) {
        if (m['id'] == _tempShoppingListId) {
          final names = labelOrderNames(m);
          if (names.isNotEmpty) listOrder = names;
        }
      }
    }
    await ref.read(settingsProvider.notifier).save(current.copyWith(
          shoppingCategoryOrder: listOrder,
          serverUrl: _cleanServerUrl,
          apiToken: _tokenCtrl.text.trim(),
          householdId: _householdCtrl.text.trim(),
          wifiServerUrl: _cleanWifiUrl,
          wifiSsid: _wifiSsidCtrl.text.trim(),
          shoppingListId: _tempShoppingListId,
          apiVersion: _tempApiVersion,
          selectedLanguage: _tempLang,
          showRecipeImages: _tempShowImages,
          isBiometricLockEnabled: _tempBiometric,
          enableLogging: _tempLogging,
          addExactQuantities: _tempExactQuantities,
          offlineRecipeImages: _tempOfflineImages,
          remindToShopEnabled: _tempRemindToShop,
          shoppingReminderLocations: _tempReminderLocations,
          sendOptionalHeaders: _tempSendHeaders,
          optionalHeaderKey1: _hk1.text.trim(),
          optionalHeaderValue1: _hv1.text.trim(),
          optionalHeaderKey2: _hk2.text.trim(),
          optionalHeaderValue2: _hv2.text.trim(),
          optionalHeaderKey3: _hk3.text.trim(),
          optionalHeaderValue3: _hv3.text.trim(),
          generatedApiTokenId: _generatedTokenId ?? '',
        ));
    // Wechselt die ausgewählte Einkaufsliste, den Provider explizit
    // invalidieren + neu anstoßen — sonst blieb die Anzeige nach A→B→A auf
    // dem zuletzt geladenen Stand hängen, weil niemand aktiv einen Reload
    // erzwungen hat. `ref.read(...)` direkt nach invalidate stößt den neuen
    // Server-Fetch sofort an (nicht erst beim nächsten Tab-Besuch).
    if (shoppingListChanged) {
      ref.invalidate(shoppingListProvider);
      ref.invalidate(shoppingLabelsProvider);
      ref.read(shoppingListProvider);
      ref.read(shoppingLabelsProvider);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    HapticFeedback.lightImpact();
    // Vor dem await greifen, um den BuildContext nicht über die async-Lücke zu
    // verwenden (Settings ist Tab-Root → der ScaffoldMessenger liegt darüber
    // und überlebt damit auch ein evtl. pop()).
    final messenger = ScaffoldMessenger.of(context);
    final l = AppLocalizations.of(context)!;
    // Ausstehenden Debounce überspringen — wir speichern jetzt direkt.
    _autosaveDebounce?.cancel();
    await _persistAll();
    if (!mounted) return;
    setState(() => _saving = false);
    // Sichtbare Bestätigung, dass die Änderungen gespeichert wurden.
    messenger.showSnackBar(
      SnackBar(
        content: Text(l.settingsSaved),
        duration: const Duration(seconds: 2),
      ),
    );
    // Settings wird als Tab-Root via go() erreicht → dann gibt es nichts zu
    // poppen und context.pop() würfe „There is nothing to pop". Nur poppen,
    // wenn die Ansicht tatsächlich auf den Stack gepusht wurde.
    if (context.canPop()) context.pop();
  }

  /// „Rezeptbilder offline speichern". AN lädt sofort alle Bilder der
  /// vorhandenen Rezepte (weitere folgen mit jedem Abgleich), AUS löscht die
  /// gespeicherten Bilder, bei vorhandenen Bildern erst nach Rückfrage, weil
  /// ein versehentliches Ausschalten sonst hunderte MB neu laden ließe.
  Future<void> _toggleOfflineImages(bool v) async {
    if (!v && RecipeImageStore.shared.stats.value.count > 0) {
      final l = AppLocalizations.of(context)!;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          backgroundColor: dialogCtx.appCard,
          title: Text(l.offlineRecipeImagesDisableConfirm,
              style: TextStyle(color: dialogCtx.appFg)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogCtx, false),
                child: Text(l.cancel)),
            FilledButton(
              style: AppTokens.dangerButton,
              onPressed: () => Navigator.pop(dialogCtx, true),
              child: Text(l.delete),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    setState(() => _tempOfflineImages = v);
    await _persistAll();
    if (v) {
      ref.read(recipesProvider.notifier).syncImagesNow();
    } else {
      await RecipeImageStore.shared.removeAll();
    }
  }

  Future<void> _reset() async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      // Dialog liegt auf dem ROOT-Navigator — mit dem Screen-Context würde
      // pop() den Branch-Navigator (die Tab-Seite!) treffen statt den Dialog.
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: dialogCtx.appCard,
        title: Text(l.resetSettingsConfirm,
            style: TextStyle(color: dialogCtx.appFg)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogCtx, false),
              child: Text(l.cancel)),
          FilledButton(
            style: AppTokens.dangerButton,
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: Text(l.resetSettings),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      // Alles weg — auch die gespeicherten Konten. Von der App erzeugte
      // Tokens werden vorher auf dem Server aufgeräumt (best-effort), damit
      // sich im Mealie-Profil nicht bei jedem Reset+Neu-Login weitere
      // ansammeln; manuell eingegebene bleiben (gehören dem Nutzer).
      await resetEverything(ref.read(settingsProvider).valueOrNull);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    // Liste woanders gewechselt (⋮-Menü der Einkaufsliste, Verwaltung)?
    // Formular-Stand nachziehen — sonst schriebe der nächste Autosave
    // (_persistAll) die alte Auswahl zurück.
    ref.listen<String?>(
        settingsProvider.select((a) => a.valueOrNull?.shoppingListId),
        (prev, next) {
      if (next != null && next != _tempShoppingListId) {
        setState(() => _tempShoppingListId = next);
      }
    });
    // Neu angelegte/umbenannte/gelöschte Listen auch im Dropdown zeigen.
    ref.listen<AsyncValue<List<Map<String, dynamic>>>>(shoppingListsProvider,
        (prev, next) {
      final lists = next.valueOrNull;
      if (lists != null && lists.isNotEmpty) {
        setState(() => _shoppingLists = lists);
      }
    });
    // Load settings on first build
    ref.watch(settingsProvider).whenData((s) {
      if (_urlCtrl.text.isEmpty && s.serverUrl.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _loadFrom(s));
      }
    });

    _handleSectionJump(context);

    return Scaffold(
      backgroundColor: context.appBg,
      extendBody: true,
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: WithCookingModeFAB(
        fullWidth: true,
        bottomInset: GlassTabBar.heightOf(context) + 24,
        child: SingleChildScrollView(
          // Kein SafeArea um den Scroll → System-Inset (Gesten/3-Button) additiv
          // ins Bottom-Padding, sonst verdeckt die GlassTabBar das letzte Element.
          // Große Anzeige (Windows/macOS): zentrierte Spalte statt Fensterbreite.
          padding: EdgeInsets.fromLTRB(
              LargeScreen.inset(context, base: 16),
              16,
              LargeScreen.inset(context, base: 16),
              GlassTabBar.heightOf(context) +
                  28 +
                  MediaQuery.paddingOf(context).bottom),
          child: Column(
            children: [
              // ── Verbindung ─────────────────────────────────────────
              _SectionCard(
                key: _sectionKeys['connection'],
                highlighted: _highlight == 'connection',
                title: l.connectionSection,
                icon: Icons.dns_rounded,
                iconColor: Colors.blue,
                child: Column(
                  children: [
                    _ModernField(
                      label: l.serverUrl,
                      icon: Icons.link,
                      controller: _urlCtrl,
                      placeholder: 'https://mealie.example.com',
                      keyboardType: TextInputType.url,
                      onChanged: (_) => setState(() {}),
                    ),
                    // URL warning + auto-fix
                    if (_urlCtrl.text.isNotEmpty && !_urlValid)
                      _UrlWarning(
                        onFix: () => setState(() {
                          _urlCtrl.text = 'https://${_urlCtrl.text}';
                          _urlCtrl.selection = TextSelection.fromPosition(
                              TextPosition(offset: _urlCtrl.text.length));
                        }),
                        l: l,
                      ),
                    const SizedBox(height: 12),
                    _WifiServerBlock(
                      l: l,
                      urlCtrl: _wifiUrlCtrl,
                      ssidCtrl: _wifiSsidCtrl,
                      reading: _readingWifi,
                      onUseCurrent: _useCurrentWifi,
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    _ModernSecureField(
                      label: l.token,
                      icon: Icons.key,
                      controller: _tokenCtrl,
                      placeholder: l.apiTokenPlaceholder,
                    ),
                    const SizedBox(height: 8),
                    // Token ist dauerhaft gültig (kein Ablauf/Refresh nötig) —
                    // dieser Button ist der einzige Weg, es zu ERSETZEN: eigenes
                    // Token einfügen (z. B. nach Widerruf) oder per Benutzer/
                    // Passwort neu einloggen (erzeugt automatisch ein neues).
                    _GradientButton(
                      label: l.renewApiToken,
                      icon: Icons.autorenew_rounded,
                      colors: [
                        Colors.blue,
                        Colors.blue.withValues(alpha: 0.8),
                      ],
                      onTap: _openRenewTokenSheet,
                      fullWidth: true,
                    ),
                    const SizedBox(height: 12),

                    _ModernField(
                      label: l.householdId,
                      icon: Icons.home_rounded,
                      controller: _householdCtrl,
                      placeholder: 'Family',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Einkaufsliste auswählen ─────────────────────────────
              _SectionCard(
                // Plain title without the 🛒 emoji that l.shoppingList carries
                key: _sectionKeys['shopping'],
                highlighted: _highlight == 'shopping',
                title: l.shoppingList.replaceFirst(RegExp(r'^\S+\s+'), ''),
                icon: Icons.format_list_bulleted_rounded,
                iconColor: AppTokens.success,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _shoppingLists.isEmpty
                              ? TapArea(
                                  onTap: _fetchShoppingLists,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: context.appSurface2,
                                      borderRadius:
                                          BorderRadius.circular(AppTokens.rSm),
                                    ),
                                    child: Text(
                                      _tempShoppingListId.isEmpty
                                          ? 'Laden...'
                                          : _tempShoppingListId,
                                      style: TextStyle(color: context.appFgSub),
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: context.appSurface2,
                                    borderRadius:
                                        BorderRadius.circular(AppTokens.rSm),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _shoppingLists.any((l) =>
                                              l['id'] == _tempShoppingListId)
                                          ? _tempShoppingListId
                                          : (_shoppingLists.isNotEmpty
                                              ? _shoppingLists.first['id']
                                                  as String
                                              : null),
                                      isExpanded: true,
                                      dropdownColor: context.appCard,
                                      items: _shoppingLists
                                          .map((lst) =>
                                              DropdownMenuItem<String>(
                                                value: lst['id'] as String,
                                                child: Row(children: [
                                                  Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: AppTokens
                                                                .success),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                  ),
                                                  Text(
                                                      lst['name'] as String? ??
                                                          '',
                                                      style: TextStyle(
                                                          color:
                                                              context.appFg)),
                                                ]),
                                              ))
                                          .toList(),
                                      onChanged: (v) {
                                        setState(() =>
                                            _tempShoppingListId = v ?? '');
                                        _persistAll();
                                      },
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 8),
                        // Green refresh button
                        TapArea(
                          onTap: _loadingLists ? null : _fetchShoppingLists,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppTokens.success,
                                  AppTokens.successLight
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius:
                                  BorderRadius.circular(AppTokens.rSm),
                              boxShadow: [
                                BoxShadow(
                                    color: AppTokens.success
                                        .withValues(alpha: 0.3),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3)),
                              ],
                            ),
                            child: _loadingLists
                                ? const Center(
                                    child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white)))
                                : const Icon(Icons.refresh_rounded,
                                    color: Colors.white, size: 22),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Exakte Mengen statt "1x pro Zutat" übernehmen —
                    // Standard bleibt AUS (= bisheriges Verhalten).
                    _ModernToggle(
                      label: l.exactQuantities,
                      subtitle: l.exactQuantitiesSubtitle,
                      icon: Icons.scale_rounded,
                      value: _tempExactQuantities,
                      onChanged: (v) {
                        setState(() => _tempExactQuantities = v);
                        _persistAll();
                      },
                    ),
                    // "Erinnere mich zum Einkaufen" (Issue #29): Geofence-
                    // Erinnerung an bis zu 3 gespeicherten Standorten — nur
                    // auf Handy/Tablet (Windows: kein Geofencing).
                    if (PlatformFeatures.shoppingReminder)
                      const SizedBox(height: 16),
                    if (PlatformFeatures.shoppingReminder)
                      _ModernToggle(
                        label: l.remindToShop,
                        subtitle: l.remindToShopSubtitle,
                        icon: Icons.location_on_rounded,
                        value: _tempRemindToShop,
                        onChanged: _toggleRemindToShop,
                      ),
                    if (PlatformFeatures.shoppingReminder &&
                        _tempRemindToShop) ...[
                      const SizedBox(height: 12),
                      for (final loc in _tempReminderLocations)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _ReminderLocationTile(
                            location: loc,
                            onDelete: () => _removeReminderLocation(loc.id),
                          ),
                        ),
                      if (_tempReminderLocations.length < 3)
                        TapArea(
                          onTap: _addReminderLocation,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: context.appSurface2,
                              borderRadius:
                                  BorderRadius.circular(AppTokens.rSm),
                              border: Border.all(
                                  color: context.appSeparator, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_location_alt_rounded,
                                    size: 18, color: AppTokens.accentDeep),
                                const SizedBox(width: 6),
                                Flexible(
                                    child: Text(l.shoppingReminderAddLocation,
                                        style: TextStyle(
                                            color: AppTokens.accentDeep,
                                            fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(l.shoppingReminderMaxLocations,
                              style: TextStyle(
                                  color: context.appFgSub, fontSize: 12)),
                        ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Erweiterte Optionen ──────────────────────────────────
              _SectionCard(
                key: _sectionKeys['advanced'],
                highlighted: _highlight == 'advanced',
                title: l.advancedOptions,
                icon: Icons.settings_applications_rounded,
                iconColor: Colors.purple,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.mealieApiVersion,
                        style:
                            TextStyle(color: context.appFgSub, fontSize: 13)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: context.appSurface2,
                        borderRadius: BorderRadius.circular(AppTokens.rXs),
                      ),
                      child: Row(
                        children: ['v2', 'v3'].map((v) {
                          final selected = _tempApiVersion == v;
                          return Expanded(
                            child: TapArea(
                              onTap: () {
                                setState(() => _tempApiVersion = v);
                                _persistAll();
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.all(2),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? context.appCard
                                      : Colors.transparent,
                                  borderRadius:
                                      BorderRadius.circular(AppTokens.rXs),
                                  boxShadow: selected
                                      ? [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.1),
                                              blurRadius: 3)
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  v == 'v2' ? 'v2.8' : 'v3.x',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: selected
                                        ? context.appFg
                                        : context.appFgSub,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ModernToggle(
                      label: l.offlineRecipeImages,
                      subtitle: l.offlineRecipeImagesHint,
                      icon: Icons.download_for_offline_outlined,
                      value: _tempOfflineImages,
                      onChanged: _toggleOfflineImages,
                    ),
                    if (_tempOfflineImages)
                      ValueListenableBuilder<RecipeImageStats>(
                        valueListenable: RecipeImageStore.shared.stats,
                        builder: (context, st, _) {
                          final total =
                              st.total > st.count ? st.total : st.count;
                          final mb = st.bytes / (1024 * 1024);
                          final size = mb >= 1024
                              ? '${(mb / 1024).toStringAsFixed(1)} GB'
                              : '${mb.toStringAsFixed(mb < 10 ? 1 : 0)} MB';
                          return Padding(
                            padding: const EdgeInsets.only(left: 22, top: 4),
                            child: Text(
                              l.offlineRecipeImagesStatus(
                                  st.count, total, size),
                              style: TextStyle(
                                  color: context.appFgSub,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 16),
                    _ModernToggle(
                      label: l.sendOptionalHeaders,
                      icon: Icons.description_outlined,
                      value: _tempSendHeaders,
                      onChanged: (v) {
                        setState(() => _tempSendHeaders = v);
                        _persistAll();
                      },
                    ),
                    if (_tempSendHeaders) ...[
                      const SizedBox(height: 12),
                      ...List.generate(3, (i) {
                        final keyCtrl = [_hk1, _hk2, _hk3][i];
                        final valCtrl = [_hv1, _hv2, _hv3][i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: _SmallField(
                                    label: l.headerNameLabel(i + 1),
                                    controller: keyCtrl,
                                    placeholder: l.name),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _SmallField(
                                    label: l.headerValueLabel(i + 1),
                                    controller: valCtrl,
                                    placeholder: l.value),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Personalisierung ─────────────────────────────────────
              _SectionCard(
                key: _sectionKeys['personalization'],
                highlighted: _highlight == 'personalization',
                title: l.personalization,
                icon: Icons.brush_rounded,
                iconColor: Colors.pink,
                child: Column(
                  children: [
                    // Language
                    _LabelRow(
                      icon: Icons.language_rounded,
                      label: l.language,
                      trailing: TapArea(
                        onTap: () => _showLanguagePicker(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: context.appSurface2,
                            borderRadius: BorderRadius.circular(AppTokens.rSm),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_flagEmoji(_tempLang),
                                  style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 8),
                              Text(_langName(_tempLang),
                                  style: TextStyle(color: context.appFg)),
                              const SizedBox(width: 8),
                              Icon(Icons.unfold_more,
                                  size: 16, color: context.appFgSub),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // App-Icon-Auswahl (nur iOS, nur wenn Alternate Icons
                    // unterstützt werden) — Wechsel zwischen Classic & Modern.
                    if (_iconSupported) ...[
                      const SizedBox(height: 16),
                      _AppIconPickerRow(
                        l: l,
                        modernActive: _modernIconActive,
                        onSelect: _setAppIconModern,
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Nur auf Tablets: Seitenleiste im Querformat an/aus.
                    if (LargeScreen.isTablet(context)) ...[
                      _ModernToggle(
                        label: l.tabletSidebar,
                        subtitle: l.tabletSidebarSubtitle,
                        icon: Icons.view_sidebar_outlined,
                        value: ref
                                .watch(settingsProvider)
                                .valueOrNull
                                ?.tabletSidebar ??
                            true,
                        onChanged: (v) {
                          final s = ref.read(settingsProvider).valueOrNull;
                          if (s == null) return;
                          ref
                              .read(settingsProvider.notifier)
                              .save(s.copyWith(tabletSidebar: v));
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    _ModernToggle(
                      label: l.showRecipeImages,
                      subtitle: l.showRecipeImagesSubtitle,
                      icon: Icons.image_outlined,
                      value: _tempShowImages,
                      onChanged: (v) {
                        setState(() => _tempShowImages = v);
                        _persistAll();
                      },
                    ),
                    const SizedBox(height: 16),
                    // Erscheinungsbild: System / Hell / Dunkel (wirkt sofort)
                    _ThemeModeRow(
                      current: ref.watch(settingsProvider
                              .select((s) => s.valueOrNull?.themeMode)) ??
                          'system',
                      onSelect: (m) {
                        HapticFeedback.selectionClick();
                        final cur = ref.read(settingsProvider).valueOrNull ??
                            const AppSettings();
                        ref
                            .read(settingsProvider.notifier)
                            .save(cur.copyWith(themeMode: m));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Sicherheit ───────────────────────────────────────────
              _SectionCard(
                key: _sectionKeys['security'],
                highlighted: _highlight == 'security',
                title: l.securitySettings,
                icon: Icons.shield_rounded,
                iconColor: const Color(0xFF5C5CE0),
                child: _ModernToggle(
                  // Label + Subtitle aus l10n statt hardcoded Deutsch — die
                  // Bezeichnungen sind plattform-/Sprach-neutral („Biometrie"
                  // statt iOS-spezifischem „Face ID / Touch ID").
                  label: l.biometricLock,
                  subtitle: l.biometricLockDescription,
                  icon: Icons.fingerprint_rounded,
                  value: _tempBiometric,
                  onChanged: (v) => _toggleBiometric(v),
                ),
              ),
              const SizedBox(height: 16),

              // ── Entwickler ───────────────────────────────────────────
              _SectionCard(
                key: _sectionKeys['developer'],
                highlighted: _highlight == 'developer',
                title: l.developer,
                icon: Icons.hardware_rounded,
                iconColor: Colors.orange,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ModernToggle(
                      label: l.enableLogging,
                      subtitle: l.enableLoggingSubtitle,
                      icon: Icons.description_outlined,
                      value: _tempLogging,
                      onChanged: (v) {
                        setState(() {
                          _tempLogging = v;
                          LogManager.shared.enabled = v;
                        });
                        _persistAll();
                      },
                    ),
                    const SizedBox(height: 12),
                    // Log stats
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.appSurface2,
                        borderRadius: BorderRadius.circular(AppTokens.rSm),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  const Icon(Icons.description,
                                      size: 14, color: Colors.blue),
                                  const SizedBox(width: 4),
                                  Text('${LogManager.shared.count}',
                                      style: TextStyle(
                                          color: context.appFg,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                ]),
                                Text(l.entriesLabel,
                                    style: TextStyle(
                                        color: context.appFgSub, fontSize: 12)),
                              ],
                            ),
                          ),
                          Container(
                              width: 1,
                              height: 40,
                              color: context.appSeparator),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    const Icon(Icons.disc_full_rounded,
                                        size: 14, color: AppTokens.success),
                                    const SizedBox(width: 4),
                                    Text(
                                        '${LogManager.shared.sizeKB.toStringAsFixed(1)} KB',
                                        style: TextStyle(
                                            color: context.appFg,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                  ]),
                                  Text(l.fileSize,
                                      style: TextStyle(
                                          color: context.appFgSub,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _GradientButton(
                            label: l.showAction,
                            icon: Icons.remove_red_eye_rounded,
                            colors: [
                              Colors.blue,
                              Colors.blue.withValues(alpha: 0.8)
                            ],
                            onTap: () => _showLogs(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _GradientButton(
                            label: l.delete,
                            icon: Icons.delete_outline_rounded,
                            colors: [
                              Colors.red,
                              Colors.red.withValues(alpha: 0.8)
                            ],
                            onTap: () => setState(() {
                              LogManager.shared.clear();
                            }),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Support-Mail — wahlweise mit den Logs als .txt-Anhang.
                    Builder(
                      builder: (btnCtx) => _GradientButton(
                        label: l.supportContact,
                        icon: Icons.mail_outline_rounded,
                        colors: [
                          Colors.teal,
                          Colors.teal.withValues(alpha: 0.8),
                        ],
                        fullWidth: true,
                        onTap: () => _showSupportDialog(btnCtx),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Changelog jederzeit erneut ansehen.
                    _GradientButton(
                      label: l.changelogTitle,
                      icon: Icons.history_edu_rounded,
                      colors: [
                        AppTokens.accent,
                        AppTokens.accent.withValues(alpha: 0.8),
                      ],
                      fullWidth: true,
                      onTap: () => showWhatsNew(context),
                    ),
                    const SizedBox(height: 4),
                    // Lizenzen der verwendeten Schriften und Pakete.
                    TextButton.icon(
                      onPressed: () => showLicensePage(
                          context: context, applicationName: 'Mealie Recipes'),
                      icon: const Icon(Icons.gavel_rounded, size: 18),
                      label: Text(MaterialLocalizations.of(context)
                          .viewLicensesButtonLabel),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Speichern ────────────────────────────────────────────
              _GradientButton(
                label: l.saveChanges,
                icon: Icons.save_rounded,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
                onTap: _saving ? null : _save,
                fullWidth: true,
                height: 56,
                isLoading: _saving,
              ),
              const SizedBox(height: 12),

              // ── Zurücksetzen ─────────────────────────────────────────
              _GradientButton(
                label: l.resetSettings,
                icon: Icons.refresh_rounded,
                colors: [Colors.red, Colors.red.withValues(alpha: 0.8)],
                onTap: _reset,
                fullWidth: true,
                height: 56,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      // useRootNavigator: Tab-Screens leben seit dem Shell-Umbau in einem
      // Branch-Navigator — ohne das Flag öffnete das Sheet DARIN und lag
      // hinter der fixen GlassTabBar (der letzte Sprach-Eintrag war verdeckt).
      // Auf dem Root-Navigator überlagert es die Leiste wie früher.
      useRootNavigator: true,
      // isScrollControlled: ohne das Flag deckelt das Sheet bei 9/16 der
      // Screen-Höhe — mit 6 Sprachen war der letzte Eintrag (pt) dann nur
      // durch (nicht erkennbares) Scrollen erreichbar. So bekommt das Sheet
      // seine Inhaltshöhe und ALLE Sprachen sind direkt sichtbar; das
      // ScrollView bleibt als Netz für Querformat/Kleinstgeräte.
      isScrollControlled: true,
      builder: (sheetCtx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetCtx).height * 0.75),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l.language,
                      style: TextStyle(
                          color: sheetCtx.appFg,
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                ),
                ...kAppLanguageCodes.map((code) => ListTile(
                      leading: Text(_flagEmoji(code),
                          style: const TextStyle(fontSize: 22)),
                      title: Text(_langName(code),
                          style: TextStyle(color: sheetCtx.appFg)),
                      trailing: _tempLang == code
                          ? const Icon(Icons.check_circle_rounded,
                              color: AppTokens.success)
                          : null,
                      onTap: () {
                        setState(() => _tempLang = code);
                        // Sprache wirkt SOFORT (wie der Theme-Wechsel): direkt in
                        // den Settings persistieren → MaterialApp.locale rebuildet
                        // die ganze App, ohne dass „Speichern" nötig ist.
                        final cur = ref.read(settingsProvider).valueOrNull ??
                            const AppSettings();
                        ref
                            .read(settingsProvider.notifier)
                            .save(cur.copyWith(selectedLanguage: code));
                        // Sheet-Context poppen — der Screen-Context zeigt auf den
                        // Branch-Navigator, das Sheet liegt aber auf dem Root.
                        Navigator.pop(sheetCtx);
                        HapticFeedback.selectionClick();
                      },
                    )),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogs(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final logs = LogManager.shared.getLogs();
    showDialog(
      context: context,
      // Pops müssen den Dialog-Context nutzen (Root- vs. Branch-Navigator).
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: dialogCtx.appCard,
        title: Text(l.logsWithCount(LogManager.shared.count),
            style: TextStyle(color: dialogCtx.appFg)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              logs.isEmpty ? l.noLogs : logs,
              style: TextStyle(
                  color: dialogCtx.appFgSub,
                  fontFamily: 'monospace',
                  fontSize: 11),
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: logs));
                Navigator.pop(dialogCtx);
              },
              child: Text(l.copy)),
          TextButton(
              onPressed: () => Navigator.pop(dialogCtx), child: Text(l.close)),
        ],
      ),
    );
  }

  // Support-Mail: entweder direkt in der Mail-App (Empfänger/Betreff/Text
  // vorausgefüllt, aber ohne Anhang) oder über das Share-Sheet mit den Logs
  // als .txt. Beides zusammen kann keine der beiden Schnittstellen.
  Future<void> _showSupportDialog(BuildContext buttonCtx) async {
    final l = AppLocalizations.of(context)!;
    const address = SupportMailService.supportAddress;
    // Vor dem Dialog auslesen: nach dem await ist der Button-Context nicht
    // mehr garantiert gültig. Ohne diesen Ursprung stürzt das Share-Popover
    // auf dem iPad ab.
    final buttonBox = buttonCtx.findRenderObject() as RenderBox?;
    final shareOrigin = buttonBox == null
        ? null
        : buttonBox.localToGlobal(Offset.zero) & buttonBox.size;

    void copyAddress() {
      Clipboard.setData(const ClipboardData(text: address));
      HapticFeedback.selectionClick();
    }

    final choice = await showDialog<String>(
      context: context,
      // Pops über den Dialog-Context (Root- vs. Branch-Navigator).
      builder: (dialogCtx) => AlertDialog(
        // Querformat/Tastatur: Inhalt scrollt, Knöpfe bleiben sichtbar.
        scrollable: true,
        backgroundColor: dialogCtx.appCard,
        title: Text(l.supportContact, style: TextStyle(color: dialogCtx.appFg)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.supportDialogMessage,
                style: TextStyle(color: dialogCtx.appFgSub, fontSize: 14)),
            const SizedBox(height: 14),
            // Adresse antippbar: fürs Share-Sheet, das kein Empfängerfeld hat.
            InkWell(
              borderRadius: BorderRadius.circular(AppTokens.rXs),
              onTap: () {
                copyAddress();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l.supportAddressCopied(address))));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.alternate_email_rounded,
                        size: 16, color: dialogCtx.appFgSub),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(address,
                          style: TextStyle(
                              color: dialogCtx.appFg,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                    Icon(Icons.copy_rounded,
                        size: 16, color: dialogCtx.appFgSub),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogCtx), child: Text(l.cancel)),
          TextButton(
              onPressed: () => Navigator.pop(dialogCtx, 'plain'),
              child: Text(l.supportWithoutLogs)),
          TextButton(
              onPressed: () => Navigator.pop(dialogCtx, 'logs'),
              child: Text(l.supportWithLogs)),
        ],
      ),
    );
    if (choice == null || !mounted) return;

    if (choice == 'plain') {
      final ok = await SupportMailService.openMailApp(
        subject: l.supportMailSubject,
        languageCode: _tempLang,
        hintLine: l.supportMailHint,
      );
      if (!ok && mounted) {
        // Ohne Mail-App: Adresse in die Zwischenablage UND das Teilen-Menü
        // öffnen, damit man mit Gmail, Outlook o. Ä. trotzdem schreiben kann.
        copyAddress();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.supportNoMailApp(address))));
        await SupportMailService.shareText(
          subject: l.supportMailSubject,
          languageCode: _tempLang,
          hintLine: l.supportMailHint,
          sharePositionOrigin: shareOrigin,
        );
      }
      return;
    }

    if (LogManager.shared.count == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.supportLogsEmpty)));
      return;
    }
    // Adresse in die Zwischenablage, weil das Share-Sheet keinen Empfänger
    // vorbelegen kann (sie steht zusätzlich im Mailtext).
    copyAddress();
    await SupportMailService.shareLogs(
      subject: l.supportMailSubject,
      languageCode: _tempLang,
      hintLine: l.supportMailHint,
      sharePositionOrigin: shareOrigin,
    );
  }

  String _flagEmoji(String code) => appLanguageFlag(code);

  String _langName(String code) => appLanguageName(code);
}

// ─────────────────────────────────────────────────────────────────────────────
// iOS-style SectionCard — mirrors SetupView.SectionCard
// ─────────────────────────────────────────────────────────────────────────────

// ── App-Icon-Auswahl (iOS) ──────────────────────────────────────────────────
// Zwei tappbare Vorschau-Kacheln: Classic (assets/images/app_icon.png) und
// Modern (assets/images/app_icon_modern.png). Die ausgewählte ist umrandet.
class _AppIconPickerRow extends StatelessWidget {
  final AppLocalizations l;
  final bool modernActive;
  final ValueChanged<bool> onSelect;

  const _AppIconPickerRow({
    required this.l,
    required this.modernActive,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.apps_rounded, size: 20, color: context.appFgSub),
            const SizedBox(width: 8),
            Flexible(
                child: Text(l.appIcon,
                    style: TextStyle(color: context.appFg, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _option(context, false, 'assets/images/app_icon.png',
                  'Classic by Walfrosch92'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _option(context, true, 'assets/images/app_icon_modern.png',
                  'Modern by JackWeekes'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _option(
      BuildContext context, bool modern, String asset, String label) {
    final selected = modern == modernActive;
    final primary = Theme.of(context).colorScheme.primary;
    return TapArea(
      onTap: () => onSelect(modern),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.appSurface2,
          borderRadius: BorderRadius.circular(AppTokens.rSm),
          border: Border.all(
            color: selected ? primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTokens.rSm),
              child:
                  Image.asset(asset, width: 56, height: 56, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    size: 16,
                    color: selected ? primary : context.appFgSub),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: context.appFg, fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color iconColor;
  final Widget child;

  /// Kurz orange umrandet nach einem Sprung aus der globalen Suche.
  final bool highlighted;

  const _SectionCard({
    super.key,
    required this.title,
    this.icon,
    required this.iconColor,
    required this.child,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTokens.rLg),
        border: Border.all(
            color: highlighted ? AppTokens.accent : Colors.transparent,
            width: 2),
      ),
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(AppTokens.rLg),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              if (icon != null) ...[
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [iconColor, iconColor.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Icon(icon, size: 22, color: Colors.white),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                  child: Text(title,
                      style: TextStyle(
                          color: context.appFg,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Modern Input Field — mirrors ModernInputField
// ─────────────────────────────────────────────────────────────────────────────

class _ModernField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String placeholder;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const _ModernField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.placeholder,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 14, color: context.appFgSub),
          const SizedBox(width: 4),
          Flexible(
              child: Text(label,
                  style: TextStyle(color: context.appFgSub, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis)),
        ]),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(AppTokens.rSm),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: context.appFgTertiary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: TextStyle(color: context.appFg),
                  keyboardType: keyboardType,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: TextStyle(color: context.appFgSub),
                    border: InputBorder.none,
                  ),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModernSecureField extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String placeholder;

  const _ModernSecureField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.placeholder,
  });

  @override
  State<_ModernSecureField> createState() => _ModernSecureFieldState();
}

class _ModernSecureFieldState extends State<_ModernSecureField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(widget.icon, size: 14, color: context.appFgSub),
          const SizedBox(width: 4),
          Flexible(
              child: Text(widget.label,
                  style: TextStyle(color: context.appFgSub, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis)),
        ]),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(AppTokens.rSm),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  obscureText: _obscure,
                  style: TextStyle(color: context.appFg),
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: TextStyle(color: context.appFgSub),
                    border: InputBorder.none,
                  ),
                ),
              ),
              TapArea(
                minSize: true,
                semanticLabel: _obscure
                    ? AppLocalizations.of(context)!.a11yShowPassword
                    : AppLocalizations.of(context)!.a11yHidePassword,
                onTap: () => setState(() => _obscure = !_obscure),
                child: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                    size: 18, color: context.appFgSub),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmallField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String placeholder;

  const _SmallField({
    required this.label,
    required this.controller,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: context.appFgSub, fontSize: 12)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(AppTokens.rXs),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(color: context.appFg, fontSize: 14),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: context.appFgSub, fontSize: 14),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ModernToggle — mirrors SwiftUI ModernToggle
// ─────────────────────────────────────────────────────────────────────────────

class _ModernToggle extends StatelessWidget {
  final String label;
  final String? subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ModernToggle({
    required this.label,
    this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: context.appFgSub),
            const SizedBox(width: 6),
            Expanded(
              child: Text(label,
                  style: TextStyle(color: context.appFgSub, fontSize: 13)),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeThumbColor: const Color(0xFF30D158),
            ),
          ],
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(left: 22, top: 2),
            child: Text(subtitle!,
                style: TextStyle(
                    color: context.appFgSub.withValues(alpha: 0.7),
                    fontSize: 11)),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// "Erinnere mich zum Einkaufen" (Issue #29) — Zeile für einen gespeicherten
// Standort + Sheet zum Hinzufügen (aktueller Standort ODER Adresssuche,
// beides kostenlos ohne Karten-API — siehe ShoppingReminderLocationService).
// ---------------------------------------------------------------------------

class _ReminderLocationTile extends StatelessWidget {
  final ShoppingReminderLocation location;
  final VoidCallback onDelete;

  const _ReminderLocationTile({required this.location, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.appSurface2,
        borderRadius: BorderRadius.circular(AppTokens.rSm),
      ),
      child: Row(
        children: [
          Icon(Icons.storefront_rounded, size: 18, color: context.appFgSub),
          const SizedBox(width: 10),
          Expanded(
            child: Text(location.name,
                style: TextStyle(color: context.appFg, fontSize: 14),
                overflow: TextOverflow.ellipsis),
          ),
          TapArea(
            minSize: true,
            semanticLabel: AppLocalizations.of(context)!.a11yRemove,
            onTap: onDelete,
            child: Icon(Icons.close_rounded, size: 18, color: context.appFgSub),
          ),
        ],
      ),
    );
  }
}

class _AddReminderLocationSheet extends StatefulWidget {
  final ShoppingReminderLocationService service;

  const _AddReminderLocationSheet({required this.service});

  @override
  State<_AddReminderLocationSheet> createState() =>
      _AddReminderLocationSheetState();
}

class _AddReminderLocationSheetState extends State<_AddReminderLocationSheet> {
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  String _newId() => DateTime.now().microsecondsSinceEpoch.toString();

  Future<void> _useCurrentLocation() async {
    final l = AppLocalizations.of(context)!;
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _error = l.required);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final loc =
          await widget.service.currentLocation(id: _newId(), name: name);
      if (mounted) Navigator.pop(context, loc);
    } catch (_) {
      if (mounted) setState(() => _error = l.shoppingReminderLocationFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _searchAddress() async {
    final l = AppLocalizations.of(context)!;
    final name = _nameCtrl.text.trim();
    final address = _addressCtrl.text.trim();
    if (name.isEmpty || address.isEmpty) {
      setState(() => _error = l.required);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final loc = await widget.service
          .geocodeAddress(id: _newId(), name: name, address: address);
      if (loc == null) {
        if (mounted) {
          setState(() => _error = l.shoppingReminderAddressNotFound);
        }
        return;
      }
      if (mounted) Navigator.pop(context, loc);
    } catch (_) {
      if (mounted) setState(() => _error = l.shoppingReminderAddressNotFound);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

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
      child: SingleChildScrollView(
// Querformat/kleine Displays: Inhalt scrollt statt abgeschnitten zu werden.
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: SheetHandle()),
          const SizedBox(height: 6),
          Center(
            child: Text(l.shoppingReminderAddLocation,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3)),
          ),
          const SizedBox(height: 16),
          _ModernField(
            label: l.shoppingReminderLocationName,
            icon: Icons.storefront_rounded,
            controller: _nameCtrl,
            placeholder: 'Rewe, Aldi, …',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _busy ? null : _useCurrentLocation,
              icon: const Icon(Icons.my_location_rounded),
              label: Text(l.shoppingReminderUseCurrentLocation),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Divider(color: context.appSeparator)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(l.shoppingReminderOrAddress,
                    style: TextStyle(color: context.appFgSub, fontSize: 12)),
              ),
              Expanded(child: Divider(color: context.appSeparator)),
            ],
          ),
          const SizedBox(height: 12),
          _ModernField(
            label: l.shoppingReminderAddress,
            icon: Icons.map_outlined,
            controller: _addressCtrl,
            placeholder: l.shoppingReminderAddressPlaceholder,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _busy ? null : _searchAddress,
              icon: const Icon(Icons.search_rounded),
              label: Text(l.shoppingReminderSearchAddress),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          if (_busy) ...[
            const SizedBox(height: 16),
            const Center(
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))),
          ],
          const SizedBox(height: 16),
        ],
      )),
    );
  }
}

class _LabelRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;

  const _LabelRow({
    required this.icon,
    required this.label,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 14, color: context.appFgSub),
          const SizedBox(width: 4),
          Flexible(
              child: Text(label,
                  style: TextStyle(color: context.appFgSub, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis)),
        ]),
        const SizedBox(height: 6),
        trailing,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Gradient Button — mirrors iOS gradient action buttons
// ─────────────────────────────────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback? onTap;
  final bool fullWidth;
  final double height;
  final bool isLoading;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.colors,
    this.onTap,
    this.fullWidth = false,
    this.height = 48,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return TapArea(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                onTap == null ? [Colors.grey, Colors.grey.shade700] : colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppTokens.rMd),
          boxShadow: onTap != null
              ? [
                  BoxShadow(
                      color: colors.first.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 5))
                ]
              : [],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(label,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// URL Warning
// ─────────────────────────────────────────────────────────────────────────────

/// Verbindung → „Andere Adresse im WLAN": dieselbe Mealie-Instanz unter
/// einer zweiten Adresse (z. B. lokale IP zu Hause, ZeroTier/Tailscale/
/// Domain unterwegs). Der SettingsNotifier schaltet beim WLAN-Wechsel
/// automatisch um. Eingeklappt, solange nichts eingetragen ist.
class _WifiServerBlock extends ConsumerStatefulWidget {
  final AppLocalizations l;
  final TextEditingController urlCtrl;
  final TextEditingController ssidCtrl;
  final bool reading;
  final VoidCallback onUseCurrent;
  final VoidCallback onChanged;

  const _WifiServerBlock({
    required this.l,
    required this.urlCtrl,
    required this.ssidCtrl,
    required this.reading,
    required this.onUseCurrent,
    required this.onChanged,
  });

  @override
  ConsumerState<_WifiServerBlock> createState() => _WifiServerBlockState();
}

class _WifiServerBlockState extends ConsumerState<_WifiServerBlock> {
  late bool _open =
      widget.urlCtrl.text.isNotEmpty || widget.ssidCtrl.text.isNotEmpty;

  @override
  void didUpdateWidget(_WifiServerBlock old) {
    super.didUpdateWidget(old);
    // Werte kommen erst per _loadFrom (nach dem ersten Frame) an.
    if (!_open &&
        (widget.urlCtrl.text.isNotEmpty || widget.ssidCtrl.text.isNotEmpty)) {
      _open = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.l;
    if (!_open) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          onPressed: () => setState(() => _open = true),
          icon: const Icon(Icons.wifi_rounded, size: 18),
          label: Text(l.wifiServerTitle),
        ),
      );
    }
    final s = ref.watch(settingsProvider).valueOrNull;
    String? status;
    if (s != null && s.hasWifiServer) {
      status = s.usingWifiServer
          ? l.wifiServerActive(s.wifiSsid)
          : l.wifiServerStandardActive(s.wifiSsid);
    }
    final urlText = widget.urlCtrl.text.trim();
    final urlInvalid = urlText.isNotEmpty &&
        !urlText.startsWith('http://') &&
        !urlText.startsWith('https://');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: context.appSurface2, width: 1.5),
        borderRadius: BorderRadius.circular(AppTokens.rSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            const Icon(Icons.wifi_rounded, size: 18, color: Colors.blue),
            const SizedBox(width: 6),
            Expanded(
              child: Text(l.wifiServerTitle,
                  style: TextStyle(
                      color: context.appFg,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ),
            IconButton(
              tooltip: l.wifiServerRemove,
              visualDensity: VisualDensity.compact,
              icon:
                  Icon(Icons.close_rounded, size: 18, color: context.appFgSub),
              onPressed: () {
                widget.urlCtrl.clear();
                widget.ssidCtrl.clear();
                setState(() => _open = false);
                widget.onChanged();
              },
            ),
          ]),
          Text(l.wifiServerHint,
              style: TextStyle(
                  color: context.appFgSub, fontSize: 13, height: 1.35)),
          const SizedBox(height: 12),
          _ModernField(
            label: l.wifiSsidLabel,
            icon: Icons.wifi_rounded,
            controller: widget.ssidCtrl,
            placeholder: 'MeinWLAN',
            onChanged: (_) => widget.onChanged(),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: widget.reading ? null : widget.onUseCurrent,
              icon: widget.reading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.my_location_rounded, size: 18),
              label: Text(l.wifiUseCurrent),
            ),
          ),
          _ModernField(
            label: l.wifiServerUrl,
            icon: Icons.lan_rounded,
            controller: widget.urlCtrl,
            placeholder: 'http://192.168.1.10:9000',
            keyboardType: TextInputType.url,
            onChanged: (_) => widget.onChanged(),
          ),
          if (urlInvalid)
            _UrlWarning(
              onFix: () {
                widget.urlCtrl.text = 'http://$urlText';
                widget.urlCtrl.selection = TextSelection.fromPosition(
                    TextPosition(offset: widget.urlCtrl.text.length));
                widget.onChanged();
              },
              l: l,
              fixLabel: '+ http://',
            ),
          if (status != null) ...[
            const SizedBox(height: 10),
            Row(children: [
              Icon(
                  s!.usingWifiServer
                      ? Icons.check_circle_rounded
                      : Icons.public_rounded,
                  size: 15,
                  color:
                      s.usingWifiServer ? AppTokens.success : context.appFgSub),
              const SizedBox(width: 6),
              Expanded(
                child: Text(status,
                    style: TextStyle(color: context.appFgSub, fontSize: 13)),
              ),
            ]),
          ],
        ],
      ),
    );
  }
}

class _UrlWarning extends StatelessWidget {
  final VoidCallback onFix;
  final AppLocalizations l;

  /// Abweichende Beschriftung (WLAN-Adresse: lokal meist `http://`).
  final String? fixLabel;

  const _UrlWarning({required this.onFix, required this.l, this.fixLabel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.red),
          const SizedBox(width: 4),
          Expanded(
            child: Text(l.urlInvalidScheme,
                style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
          TextButton(
            onPressed: onFix,
            child: Text(fixLabel ?? l.urlAddScheme,
                style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Erscheinungsbild-Auswahl (System / Hell / Dunkel)
// ---------------------------------------------------------------------------

class _ThemeModeRow extends StatelessWidget {
  final String current;
  final ValueChanged<String> onSelect;
  const _ThemeModeRow({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final opts = <(String, IconData, String)>[
      ('system', Icons.brightness_auto_rounded, l.themeSystem),
      ('light', Icons.light_mode_rounded, l.themeLight),
      ('dark', Icons.dark_mode_rounded, l.themeDark),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.palette_outlined, size: 18, color: context.appFgSub),
            const SizedBox(width: 8),
            Flexible(
                child: Text(l.theme,
                    style: TextStyle(
                        color: context.appFg,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(AppTokens.rSm),
          ),
          child: Row(
            children: opts.map((o) {
              final active = current == o.$1;
              return Expanded(
                child: TapArea(
                  behavior: HitTestBehavior.opaque,
                  onTap: active ? null : () => onSelect(o.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: active ? context.appCard : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppTokens.rXs),
                      boxShadow: active ? context.appShadowSm : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(o.$2,
                            size: 17,
                            color: active
                                ? AppTokens.accentDeep
                                : context.appFgSub),
                        const SizedBox(width: 6),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(o.$3,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color:
                                      active ? context.appFg : context.appFgSub,
                                  fontSize: 13,
                                  fontWeight: active
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
