import '../../../core/utils/platform_features.dart';
import 'dart:async';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
import '../../../core/services/local_cache.dart';
import '../../../core/services/log_manager.dart';
import '../../../core/services/recipe_detail_cache.dart';
import '../../../core/services/recipe_image_store.dart';
import '../../../core/services/support_mail_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/async_action_button.dart';
import '../../../shared/widgets/auth_mode_choice_card.dart';
import '../../../shared/widgets/gradient_button.dart' show SheetHandle;
import '../../../shared/widgets/import_language_sheet.dart';
import '../../../shared/widgets/liquid_glass.dart';
import '../../auth/providers/biometric_lock_provider.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../../shopping_list/providers/foods_units_provider.dart';
import '../../shopping_list/providers/pending_changes_provider.dart';
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
  // Temp state — only saved on button press, mirrors iOS SetupView
  final _urlCtrl = TextEditingController();
  final _tokenCtrl = TextEditingController();
  final _householdCtrl = TextEditingController();
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
  // Leer = der App-Sprache folgen (AppSettings.importLanguage).
  String _tempImportLang = '';
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
    _urlCtrl.text = s.serverUrl;
    _tokenCtrl.text = s.apiToken;
    _householdCtrl.text = s.householdId;
    _hk1.text = s.optionalHeaderKey1;
    _hv1.text = s.optionalHeaderValue1;
    _hk2.text = s.optionalHeaderKey2;
    _hv2.text = s.optionalHeaderValue2;
    _hk3.text = s.optionalHeaderKey3;
    _hv3.text = s.optionalHeaderValue3;
    setState(() {
      _tempLang = s.selectedLanguage;
      _tempImportLang = s.importLanguage;
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
    _autosaveDebounce?.cancel();
    _urlCtrl.dispose();
    _tokenCtrl.dispose();
    _householdCtrl.dispose();
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
        serverUrl: _urlCtrl.text.trim(),
        apiToken: _tokenCtrl.text.trim(),
        householdId: _householdCtrl.text.trim(),
        sendOptionalHeaders: _tempSendHeaders,
        optionalHeaderKey1: _hk1.text.trim(),
        optionalHeaderValue1: _hv1.text.trim(),
      );
      final svc = ApiService(tmpSettings);
      final lists = await svc.fetchShoppingLists();
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
      setState(() => _loadingLists = false);
    }
  }

  // Token erneuern: öffnet das Sheet mit der Wahl „eigenes Token einfügen"
  // vs. „per Login erzeugen lassen" (mirrors Setup Step 1). Das Sheet
  // validiert selbst (Verbindungstest bzw. Login+Erzeugen) und liefert bei
  // Erfolg (token, generatedId, version) zurück — Persistieren übernimmt
  // weiterhin „Änderungen speichern", wie bei jedem anderen Feld hier.
  Future<void> _openRenewTokenSheet() async {
    final url = _urlCtrl.text.trim();
    if (url.isEmpty) {
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.required)));
      return;
    }
    final result = await showModalBottomSheet<(String, String?, String)>(
      context: context,
      backgroundColor: context.appCard,
      // useRootNavigator: Tab-Screens liegen in einem Branch-Navigator —
      // ohne das Flag läge das Sheet hinter der fixen GlassTabBar.
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => _RenewTokenSheet(
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
        backgroundColor: context.appCard,
        title: Text(l.shoppingReminderPermissionTitle,
            style: TextStyle(color: context.appFg)),
        content: Text(l.shoppingReminderNotificationsOff,
            style: TextStyle(color: context.appFgSub)),
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
        backgroundColor: context.appCard,
        title: Text(l.shoppingReminderPermissionTitle,
            style: TextStyle(color: context.appFg)),
        content: Text(l.shoppingReminderPermissionMessage,
            style: TextStyle(color: context.appFgSub)),
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
      backgroundColor: context.appCard,
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
          serverUrl: _urlCtrl.text.trim(),
          apiToken: _tokenCtrl.text.trim(),
          householdId: _householdCtrl.text.trim(),
          shoppingListId: _tempShoppingListId,
          apiVersion: _tempApiVersion,
          selectedLanguage: _tempLang,
          importLanguage: _tempImportLang,
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
        behavior: SnackBarBehavior.floating,
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
          backgroundColor: context.appCard,
          title: Text(l.offlineRecipeImagesDisableConfirm,
              style: TextStyle(color: context.appFg)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogCtx, false),
                child: Text(l.cancel)),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
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
        backgroundColor: context.appCard,
        title: Text(l.resetSettingsConfirm,
            style: TextStyle(color: context.appFg)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogCtx, false),
              child: Text(l.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: Text(l.resetSettings),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      // App-generiertes Token vorher aufräumen (best-effort) — sonst sammelt
      // sich im Mealie-Profil bei jedem Reset+Neu-Login ein weiteres Token
      // an. Manuell eingegebene Tokens (generatedApiTokenId leer) bleiben
      // unangetastet — die gehören dem Nutzer, nicht der App.
      final currentSettings = ref.read(settingsProvider).valueOrNull;
      if (currentSettings != null &&
          currentSettings.generatedApiTokenId.isNotEmpty) {
        try {
          await ApiService(currentSettings)
              .deleteLongLiveToken(currentSettings.generatedApiTokenId);
        } catch (e) {
          LogManager.shared
              .log('⚠️ Generiertes API-Token konnte nicht gelöscht werden: $e');
        }
      }
      await ref.read(settingsProvider.notifier).reset();
      // Voller Cache-Wipe: SharedPreferences ist durch reset() bereits
      // geleert, aber die file-basierten Caches (RecipeDetail-File-Cache
      // im application-Cache-Directory) und die in-memory-Provider-States
      // bleiben sonst stehen. Issue: „App reset doesn't clear local cache".
      await RecipeDetailCacheManager.shared.clear();
      await RecipeImageStore.shared.removeAll();
      // Belt-and-suspenders: SharedPreferences-Cache-Keys explizit nochmal
      // ausschreiben falls neue Caches dazukommen die _prefs.clear() noch
      // nicht abdeckt. LocalCache.saveX([]) ist no-op aber sichert die Form.
      await LocalCache.saveShoppingItems(const []);
      await LocalCache.saveShoppingLabels(const []);
      await LocalCache.saveFoodsCatalog(const []);
      await LocalCache.saveUnitsCatalog(const []);
      await LocalCache.saveCurrentUser(null);
      // Falls das Gerät noch die alten Rezept-Keys mitschleppt: mit weg.
      await LocalCache.purgeLegacyRecipeCaches();
      // In-memory Provider-States invalidieren — sonst zeigen Home/Listen
      // den letzten geladenen Stand bis zum nächsten App-Start.
      ref.invalidate(recipesProvider);
      ref.invalidate(shoppingListProvider);
      ref.invalidate(shoppingLabelsProvider);
      ref.invalidate(foodsCatalogProvider);
      ref.invalidate(unitsCatalogProvider);
      ref.invalidate(currentUserProvider);
      ref.invalidate(pendingShoppingChangesProvider);
      if (mounted) context.go('/setup');
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

    return Scaffold(
      backgroundColor: context.appBg,
      extendBody: true,
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: WithCookingModeFAB(
        bottomInset: GlassTabBar.height + 24,
        child: SingleChildScrollView(
          // Kein SafeArea um den Scroll → System-Inset (Gesten/3-Button) additiv
          // ins Bottom-Padding, sonst verdeckt die GlassTabBar das letzte Element.
          // Große Anzeige (Windows/macOS): zentrierte Spalte statt Fensterbreite.
          padding: EdgeInsets.fromLTRB(
              LargeScreen.inset(context, base: 16),
              16,
              LargeScreen.inset(context, base: 16),
              GlassTabBar.height + 28 + MediaQuery.paddingOf(context).bottom),
          child: Column(
            children: [
              // ── Verbindung ─────────────────────────────────────────
              _SectionCard(
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
                title: l.shoppingList.replaceFirst(RegExp(r'^\S+\s+'), ''),
                icon: Icons.format_list_bulleted_rounded,
                iconColor: Colors.green,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _shoppingLists.isEmpty
                              ? GestureDetector(
                                  onTap: _fetchShoppingLists,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: context.appSurface2,
                                      borderRadius: BorderRadius.circular(12),
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
                                    borderRadius: BorderRadius.circular(12),
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
                                                            color:
                                                                Colors.green),
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
                        GestureDetector(
                          onTap: _loadingLists ? null : _fetchShoppingLists,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.green, Color(0xFF2ECC71)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.green.withValues(alpha: 0.3),
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
                        GestureDetector(
                          onTap: _addReminderLocation,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: context.appSurface2,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: context.appSeparator, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_location_alt_rounded,
                                    size: 18, color: AppTokens.accentDeep),
                                const SizedBox(width: 6),
                                Text(l.shoppingReminderAddLocation,
                                    style: TextStyle(
                                        color: AppTokens.accentDeep,
                                        fontWeight: FontWeight.w600)),
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: ['v2', 'v3'].map((v) {
                          final selected = _tempApiVersion == v;
                          return Expanded(
                            child: GestureDetector(
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
                                  borderRadius: BorderRadius.circular(7),
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
                title: l.personalization,
                icon: Icons.brush_rounded,
                iconColor: Colors.pink,
                child: Column(
                  children: [
                    // Language
                    _LabelRow(
                      icon: Icons.language_rounded,
                      label: l.language,
                      trailing: GestureDetector(
                        onTap: () => _showLanguagePicker(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: context.appSurface2,
                            borderRadius: BorderRadius.circular(12),
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
                    const SizedBox(height: 16),
                    // Sprache des KI-Rezeptimports — kann bewusst von der
                    // App-Sprache abweichen (deutlich mehr Sprachen), damit
                    // Rezepte auch in Muttersprachen ankommen, die die
                    // Oberfläche nicht anbietet.
                    _LabelRow(
                      icon: Icons.translate_rounded,
                      label: l.importLanguage,
                      subtitle: l.importLanguageSubtitle,
                      trailing: GestureDetector(
                        onTap: _showImportLanguagePicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: context.appSurface2,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  importLanguageFlag(
                                      _tempImportLang, _tempLang),
                                  style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 8),
                              Text(
                                  importLanguageLabel(
                                      _tempImportLang, _tempLang),
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
                        borderRadius: BorderRadius.circular(12),
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
                                        size: 14, color: Colors.green),
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
                            icon: Icons.delete_rounded,
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
      backgroundColor: context.appCard,
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
                          color: context.appFg,
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                ),
                ...[
                  'de',
                  'en',
                  'fr',
                  'es',
                  'hu',
                  'nl',
                  'nb',
                  'pl',
                  'pt',
                  'sl'
                ].map((code) => ListTile(
                      leading: Text(_flagEmoji(code),
                          style: const TextStyle(fontSize: 22)),
                      title: Text(_langName(code),
                          style: TextStyle(color: context.appFg)),
                      trailing: _tempLang == code
                          ? const Icon(Icons.check_circle, color: Colors.green)
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
        backgroundColor: context.appCard,
        title: Text(l.logsWithCount(LogManager.shared.count),
            style: TextStyle(color: context.appFg)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              logs.isEmpty ? l.noLogs : logs,
              style: TextStyle(
                  color: context.appFgSub,
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

  // Importsprache: wie der App-Sprachpicker sofort persistiert (und nicht erst
  // beim „Änderungen speichern"), damit der nächste Import ohne Umweg in der
  // gewünschten Sprache ankommt.
  Future<void> _showImportLanguagePicker() async {
    final picked = await showImportLanguageSheet(
      context,
      current: _tempImportLang,
      appLanguageLabel: _langName(_tempLang),
    );
    if (picked == null || !mounted) return;
    setState(() => _tempImportLang = picked);
    final cur = ref.read(settingsProvider).valueOrNull ?? const AppSettings();
    await ref
        .read(settingsProvider.notifier)
        .save(cur.copyWith(importLanguage: picked));
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
        backgroundColor: context.appCard,
        title: Text(l.supportContact, style: TextStyle(color: context.appFg)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.supportDialogMessage,
                style: TextStyle(color: context.appFgSub, fontSize: 14)),
            const SizedBox(height: 14),
            // Adresse antippbar: fürs Share-Sheet, das kein Empfängerfeld hat.
            InkWell(
              borderRadius: BorderRadius.circular(10),
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
                        size: 16, color: context.appFgSub),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(address,
                          style: TextStyle(
                              color: context.appFg,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                    Icon(Icons.copy_rounded, size: 16, color: context.appFgSub),
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
        // Ohne Mail-App bleibt nur die Adresse — die soll der Nutzer nicht
        // abtippen müssen.
        copyAddress();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.supportNoMailApp(address))));
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

  String _flagEmoji(String code) => switch (code) {
        'de' => '🇩🇪',
        'en' => '🇬🇧',
        'fr' => '🇫🇷',
        'es' => '🇪🇸',
        'hu' => '🇭🇺',
        'nl' => '🇳🇱',
        'nb' => '🇳🇴',
        'pl' => '🇵🇱',
        'pt' => '🇧🇷',
        'sl' => '🇸🇮',
        _ => '🌍',
      };

  String _langName(String code) => switch (code) {
        'de' => 'Deutsch',
        'en' => 'English',
        'fr' => 'Français',
        'es' => 'Español',
        'hu' => 'Magyar',
        'nl' => 'Nederlands',
        'nb' => 'Norsk (bokmål)',
        'pl' => 'Polski',
        'pt' => 'Português (Brasil)',
        'sl' => 'Slovenščina',
        _ => code,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// „API-Token erneuern"-Sheet — gleiche Wahl wie Setup Step 1 (eigenes Token
// einfügen vs. per Login erzeugen lassen), aber als Re-Login-Flow: prüft im
// Token-Zweig die Verbindung (testConnection + fetchShoppingLists, validiert
// den Bearer implizit), im Passwort-Zweig läuft Login→Token-Erzeugung wie im
// Setup. Liefert bei Erfolg (token, generatedId, version) an den Aufrufer;
// PERSISTIERT NICHTS selbst — das übernimmt weiterhin „Änderungen speichern".
// ─────────────────────────────────────────────────────────────────────────────

class _RenewTokenSheet extends StatefulWidget {
  final String serverUrl;
  final bool sendOptionalHeaders;
  final String headerKey1;
  final String headerValue1;
  final String headerKey2;
  final String headerValue2;
  final String headerKey3;
  final String headerValue3;

  const _RenewTokenSheet({
    required this.serverUrl,
    required this.sendOptionalHeaders,
    required this.headerKey1,
    required this.headerValue1,
    required this.headerKey2,
    required this.headerValue2,
    required this.headerKey3,
    required this.headerValue3,
  });

  @override
  State<_RenewTokenSheet> createState() => _RenewTokenSheetState();
}

class _RenewTokenSheetState extends State<_RenewTokenSheet> {
  final _formKey = GlobalKey<FormState>();
  final _tokenCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  AuthMode _mode = AuthMode.password;
  String? _error;

  @override
  void dispose() {
    _tokenCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  AppSettings _probeSettings(String ver) => AppSettings(
        serverUrl: widget.serverUrl,
        apiVersion: ver,
        sendOptionalHeaders: widget.sendOptionalHeaders,
        optionalHeaderKey1: widget.headerKey1,
        optionalHeaderValue1: widget.headerValue1,
        optionalHeaderKey2: widget.headerKey2,
        optionalHeaderValue2: widget.headerValue2,
        optionalHeaderKey3: widget.headerKey3,
        optionalHeaderValue3: widget.headerValue3,
      );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _error = null);
    Object? lastError;
    for (final ver in ['v3', 'v2']) {
      try {
        if (_mode == AuthMode.token) {
          final token = _tokenCtrl.text.trim();
          final svc = ApiService(_probeSettings(ver).copyWith(apiToken: token));
          await svc.testConnection();
          // fetchShoppingLists validiert implizit den Bearer (401 bei
          // falschem Token) — testConnection allein prüft nur Erreichbarkeit.
          await svc.fetchShoppingLists();
          if (!mounted) return;
          Navigator.pop(context, (token, null, ver));
          return;
        } else {
          final loginSvc = ApiService(_probeSettings(ver));
          final jwt = await loginSvc.loginWithPassword(
              _usernameCtrl.text.trim(), _passwordCtrl.text);
          final device = Platform.isIOS
              ? 'iOS'
              : (Platform.isAndroid ? 'Android' : Platform.operatingSystem);
          final (id, token) = await loginSvc.createLongLiveToken(
              jwt, 'Mealie Recipes – $device');
          if (!mounted) return;
          Navigator.pop(context, (token, id, ver));
          return;
        }
      } catch (e) {
        lastError = e;
      }
    }
    if (!mounted) return;
    final l = AppLocalizations.of(context)!;
    setState(() {
      _error =
          (lastError is DioException && lastError.response?.statusCode == 401)
              ? (_mode == AuthMode.password
                  ? l.loginInvalidCredentials
                  : l.connectionFailedCheck)
              : l.connectionFailedCheck;
    });
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: SheetHandle()),
              const SizedBox(height: 6),
              Center(
                child: Text(l.renewApiToken,
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: context.appFg,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3)),
              ),
              const SizedBox(height: 16),
              Text(l.setupAuthChoiceTitle,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              AuthModeChoiceCard(
                mode: AuthMode.password,
                selected: _mode == AuthMode.password,
                icon: Icons.auto_awesome_rounded,
                title: l.authModePasswordTitle,
                subtitle: l.authModePasswordSubtitle,
                onTap: () => setState(() {
                  _mode = AuthMode.password;
                  _error = null;
                }),
              ),
              const SizedBox(height: 8),
              AuthModeChoiceCard(
                mode: AuthMode.token,
                selected: _mode == AuthMode.token,
                icon: Icons.key_outlined,
                title: l.authModeTokenTitle,
                subtitle: l.authModeTokenSubtitle,
                onTap: () => setState(() {
                  _mode = AuthMode.token;
                  _error = null;
                }),
              ),
              const SizedBox(height: 16),
              if (_mode == AuthMode.token)
                TextFormField(
                  controller: _tokenCtrl,
                  decoration: InputDecoration(
                    labelText: l.apiToken,
                    hintText: l.apiTokenPlaceholder,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.key_outlined),
                  ),
                  obscureText: true,
                  autocorrect: false,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l.required : null,
                )
              else ...[
                TextFormField(
                  controller: _usernameCtrl,
                  decoration: InputDecoration(
                    labelText: l.username,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  autocorrect: false,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l.required : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordCtrl,
                  decoration: InputDecoration(
                    labelText: l.password,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  autocorrect: false,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? l.required : null,
                ),
                const SizedBox(height: 6),
                Text(l.setupPasswordHint,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
              const SizedBox(height: 16),
              if (_error != null) ...[
                Text(_error!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
                const SizedBox(height: 16),
              ],
              AsyncActionButton(
                expand: true,
                label:
                    _mode == AuthMode.password ? l.loginAndConnect : l.connect,
                onPressed: _submit,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
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
            Text(l.appIcon,
                style: TextStyle(color: context.appFg, fontSize: 15)),
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
    return GestureDetector(
      onTap: () => onSelect(modern),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.appSurface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
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

  const _SectionCard({
    required this.title,
    this.icon,
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(20),
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
              Text(title,
                  style: TextStyle(
                      color: context.appFg,
                      fontSize: 17,
                      fontWeight: FontWeight.w600)),
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
          Text(label, style: TextStyle(color: context.appFgSub, fontSize: 13)),
        ]),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: Colors.grey,
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
          Text(widget.label,
              style: TextStyle(color: context.appFgSub, fontSize: 13)),
        ]),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(12),
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
              GestureDetector(
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
            borderRadius: BorderRadius.circular(10),
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
        borderRadius: BorderRadius.circular(12),
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
          GestureDetector(
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
      ),
    );
  }
}

class _LabelRow extends StatelessWidget {
  final IconData icon;
  final String label;

  /// Optionale Erklärzeile unter dem Label — nur dort gesetzt, wo das Label
  /// allein nicht verrät, was die Einstellung bewirkt.
  final String? subtitle;
  final Widget trailing;

  const _LabelRow({
    required this.icon,
    required this.label,
    required this.trailing,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 14, color: context.appFgSub),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: context.appFgSub, fontSize: 13)),
        ]),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!,
              style: TextStyle(color: context.appFgTertiary, fontSize: 12)),
        ],
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
    return GestureDetector(
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
          borderRadius: BorderRadius.circular(16),
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

class _UrlWarning extends StatelessWidget {
  final VoidCallback onFix;
  final AppLocalizations l;

  const _UrlWarning({required this.onFix, required this.l});

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
            child: Text(l.urlAddScheme, style: const TextStyle(fontSize: 12)),
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
            Text(l.theme,
                style: TextStyle(
                    color: context.appFg,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: context.appSurface2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: opts.map((o) {
              final active = current == o.$1;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: active ? null : () => onSelect(o.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: active ? context.appCard : Colors.transparent,
                      borderRadius: BorderRadius.circular(9),
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
