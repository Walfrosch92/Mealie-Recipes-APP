import 'dart:async';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/app_settings.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/log_manager.dart';
import '../../../shared/widgets/async_action_button.dart';
import '../../../shared/widgets/auth_mode_choice_card.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/import_language_sheet.dart';
import '../../recipes/providers/recipes_provider.dart';

// ---------------------------------------------------------------------------
// Step-by-step setup:
//   Step 0 — Welcome + large app icon + language selection (asked first)
//   Step 1 — Server URL + API key (+ optional headers) + Connect
//   Step 2 — Haushalt + Einkaufsliste (beides als Dropdown vom Server;
//            Haushalte nicht ladbar → manuelles Textfeld) + Save
//   Step 3 — Einkaufslisten-Modus: exakte Mengen („200 g Butter") vs.
//            1x-Stückkauf — inkl. Erklärung, warum die App Rezeptmengen im
//            einfachen Modus auf „1×" umwandelt.
//   Step 4 — KI-Importsprache
//   Step 5 — Erst-Cache der Rezepte (Fortschritt + rotierende Tipps); der
//            Load startet automatisch, weil recipesProvider auf isConfigured
//            reagiert — dieser Schritt ZEIGT ihn nur und ist überspringbar
//            (der Load läuft dann im Hintergrund weiter).
// ---------------------------------------------------------------------------

const _kSetupLanguages = [
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
];

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlCtrl = TextEditingController();
  final _tokenCtrl = TextEditingController();
  final _householdCtrl = TextEditingController(text: 'Family');

  // Benutzer/Passwort-Login (Default — einfacherer Einstieg als ein manuell
  // im Webapp-Profil erstelltes API-Token). „token" bleibt für OIDC-/LDAP-
  // Nutzer ohne lokales Mealie-Passwort sowie alle, die bewusst ein
  // bestehendes Token verwenden wollen.
  AuthMode _authMode = AuthMode.password;
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  // ID des beim Login erzeugten API-Tokens (für späteres Aufräumen bei
  // Reset) — leer im Token-Modus (manuell eingegebenes Token).
  String? _generatedTokenId;

  int _step = 0;
  String _lang = 'de';
  // Leer = der App-Sprache folgen (AppSettings.importLanguage).
  String _importLang = '';
  String? _error;
  String? _apiVersion;

  // Optional headers
  bool _showHeaders = false;
  final _hk1 = TextEditingController();
  final _hv1 = TextEditingController();
  final _hk2 = TextEditingController();
  final _hv2 = TextEditingController();
  final _hk3 = TextEditingController();
  final _hv3 = TextEditingController();

  List<Map<String, dynamic>> _shoppingLists = [];
  String? _selectedListId;

  // Haushalte vom Server (Dropdown). Leer (Endpoint nicht verfügbar /
  // Fehler) → manuelles Textfeld über _householdCtrl als Fallback.
  List<Map<String, dynamic>> _households = [];
  String? _selectedHouseholdName;

  // Einkaufslisten-Modus (Step 3) — Default AUS wie in den Settings.
  bool _exactQuantities = false;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider).valueOrNull;
    _lang = settings?.selectedLanguage ?? 'de';
    _importLang = settings?.importLanguage ?? '';
    _exactQuantities = settings?.addExactQuantities ?? false;
    // Während der Ersteinrichtung Logging erzwingen, damit ALLE Fehler (z. B.
    // fehlgeschlagene Verbindungstests inkl. Server-Antwort) erfasst werden —
    // sonst sind die „Logs" hier immer leer, weil der Logging-Schalter beim
    // Erstlauf noch aus ist.
    LogManager.shared.pinOn();
    LogManager.shared.log('🛠️ Setup geöffnet — Logging aktiv');
  }

  @override
  void dispose() {
    // Pin aufheben; ab hier gilt wieder die persistierte Logging-Einstellung.
    LogManager.shared.unpin();
    _urlCtrl.dispose();
    _tokenCtrl.dispose();
    _householdCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _hk1.dispose();
    _hv1.dispose();
    _hk2.dispose();
    _hv2.dispose();
    _hk3.dispose();
    _hv3.dispose();
    super.dispose();
  }

  AppSettings _buildSettings({String version = 'v2'}) {
    final base = ref.read(settingsProvider).valueOrNull ?? const AppSettings();
    return base.copyWith(
      serverUrl: _urlCtrl.text.trim().replaceAll(RegExp(r'/$'), ''),
      apiToken: _tokenCtrl.text.trim(),
      // Dropdown-Auswahl (Server-Haushalte) vor dem manuellen Textfeld —
      // gespeichert wird wie bisher der Haushalts-NAME ('Family'-Default).
      householdId: _selectedHouseholdName ?? _householdCtrl.text.trim(),
      apiVersion: version,
      selectedLanguage: _lang,
      sendOptionalHeaders: _showHeaders,
      optionalHeaderKey1: _hk1.text.trim(),
      optionalHeaderValue1: _hv1.text.trim(),
      optionalHeaderKey2: _hk2.text.trim(),
      optionalHeaderValue2: _hv2.text.trim(),
      optionalHeaderKey3: _hk3.text.trim(),
      optionalHeaderValue3: _hv3.text.trim(),
      generatedApiTokenId: _generatedTokenId ?? '',
    );
  }

  // Persist the language immediately so the rest of the setup flow renders in
  // the chosen language (the app is not yet configured, so no redirect fires).
  Future<void> _selectLanguage(String code) async {
    setState(() => _lang = code);
    HapticFeedback.selectionClick();
    final base = ref.read(settingsProvider).valueOrNull ?? const AppSettings();
    await ref
        .read(settingsProvider.notifier)
        .save(base.copyWith(selectedLanguage: code));
  }

  Future<void> _connect() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _error = null);
    if (_authMode == AuthMode.password) {
      await _connectWithPassword();
    } else {
      await _connectWithToken();
    }
  }

  // Klassischer Pfad: manuell eingegebenes API-Token, mit v3→v2-Fallback.
  Future<void> _connectWithToken() async {
    Object? lastError;
    for (final ver in ['v3', 'v2']) {
      final svc = ApiService(_buildSettings(version: ver));
      try {
        LogManager.shared.log('🔌 Verbindungstest [$ver] startet…');
        await svc.testConnection();
        await _loadStep2Data(svc, ver);
        return;
      } catch (e) {
        // Den echten Fehler erfassen statt ihn zu verschlucken — der
        // ApiService-Interceptor loggt zusätzlich Status + Server-Body.
        lastError = e;
        LogManager.shared.log('❌ Verbindungstest [$ver] fehlgeschlagen: $e');
      }
    }
    setState(() {
      _error = AppLocalizations.of(context)!.connectionFailedCheck;
    });
    LogManager.shared.log('❌ Setup-Verbindung endgültig fehlgeschlagen'
        '${lastError != null ? ' — letzter Fehler: $lastError' : ''}');
  }

  // Neuer Pfad: Benutzer/Passwort → kurzlebiges JWT → langlebiges API-Token
  // (POST /api/users/api-tokens). Ab dem erzeugten Token läuft alles wie im
  // Token-Modus weiter — Passwort und JWT werden nirgends gespeichert.
  Future<void> _connectWithPassword() async {
    final username = _usernameCtrl.text.trim();
    final password = _passwordCtrl.text;
    Object? lastError;
    for (final ver in ['v3', 'v2']) {
      // Login MIT leerem Token (noch keins vorhanden) — createLongLiveToken
      // setzt den Bearer für den Erzeugen-Request explizit über das JWT.
      final loginSvc =
          ApiService(_buildSettings(version: ver).copyWith(apiToken: ''));
      try {
        LogManager.shared.log('🔌 Login [$ver] startet…');
        final jwt = await loginSvc.loginWithPassword(username, password);
        final tokenName = 'Mealie Recipes – ${_deviceLabel()}';
        final (id, token) = await loginSvc.createLongLiveToken(jwt, tokenName);
        LogManager.shared.log('🔑 API-Token erzeugt (id=$id)');
        _tokenCtrl.text = token;
        _generatedTokenId = id;
        // Neue Instanz MIT dem frischen Token — households/shopping lists
        // brauchen den Bearer aus dem normalen Interceptor.
        final authedSvc = ApiService(_buildSettings(version: ver));
        await _loadStep2Data(authedSvc, ver);
        return;
      } catch (e) {
        lastError = e;
        LogManager.shared.log('❌ Login [$ver] fehlgeschlagen: $e');
      }
    }
    setState(() => _error = _loginErrorMessage(lastError));
    LogManager.shared.log('❌ Setup-Login endgültig fehlgeschlagen'
        '${lastError != null ? ' — letzter Fehler: $lastError' : ''}');
  }

  String _loginErrorMessage(Object? error) {
    final l = AppLocalizations.of(context)!;
    if (error is DioException && error.response?.statusCode == 401) {
      return l.loginInvalidCredentials;
    }
    return l.connectionFailedCheck;
  }

  String _deviceLabel() {
    if (Platform.isIOS) return 'iOS';
    if (Platform.isAndroid) return 'Android';
    return Platform.operatingSystem;
  }

  // Gemeinsamer Tail für BEIDE Auth-Modi: Einkaufslisten + Haushalte für
  // Step 2 laden. testConnection() prüft dabei nur Erreichbarkeit/Version
  // (/api/app/about ist unauthentifiziert) — im Token-Modus ist das der
  // implizite Auth-Check zusammen mit fetchShoppingLists (401 bei falschem
  // Token); im Passwort-Modus hat der Login bereits authentifiziert.
  Future<void> _loadStep2Data(ApiService svc, String ver) async {
    final lists = await svc.fetchShoppingLists();
    // Haushalte sind fürs Dropdown „nice to have" — ein Fehler hier darf
    // die Einrichtung nicht abbrechen (Fallback: manuelles Textfeld).
    // /api/groups/households listet ALLE Haushalte der Gruppe;
    // /api/households/self liefert den Haushalt des API-Key-Nutzers —
    // er bestimmt die Vorauswahl und springt ein, wenn die Gruppen-
    // Liste nicht ladbar ist.
    List<Map<String, dynamic>> households = const [];
    try {
      households = await svc.fetchHouseholds();
    } catch (e) {
      LogManager.shared.log('⚠️ Haushalte nicht ladbar: $e');
    }
    String? selfHouseholdName;
    try {
      final self = await svc.fetchSelfHousehold();
      selfHouseholdName = (self?['name'] as String?)?.trim();
      if (households.isEmpty && self != null) {
        households = [self];
      }
    } catch (e) {
      LogManager.shared.log('⚠️ Eigener Haushalt nicht ladbar: $e');
    }
    LogManager.shared.log('✅ Verbindungstest [$ver] erfolgreich');
    if (!mounted) return;
    setState(() {
      _apiVersion = ver;
      _shoppingLists = lists;
      _selectedListId = lists.isNotEmpty ? lists.first['id'] as String? : null;
      _households = households;
      // Vorauswahl: Haushalt des API-Keys > bisheriger Wert
      // ('Family'-Default) > erster Haushalt der Liste.
      final names = households
          .map((h) => (h['name'] as String?)?.trim() ?? '')
          .where((n) => n.isNotEmpty)
          .toList();
      final current = _householdCtrl.text.trim();
      _selectedHouseholdName = names.isEmpty
          ? null
          : (selfHouseholdName != null && names.contains(selfHouseholdName)
              ? selfHouseholdName
              : (names.contains(current) ? current : names.first));
      _step = 2;
    });
  }

  Future<void> _save() async {
    final settings = _buildSettings(version: _apiVersion ?? 'v2').copyWith(
      shoppingListId: _selectedListId ?? '',
    );
    await ref.read(settingsProvider.notifier).save(settings);
    // Weiter zum Einkaufslisten-Modus statt direkt in die App: danach folgen
    // noch Importsprache und Erst-Cache der Rezepte (Offline-first-
    // Vorbereitung). Mit dem Save eben ist isConfigured=true geworden →
    // recipesProvider startet den Load selbst und läuft im Hintergrund schon,
    // während die restlichen Schritte sichtbar sind.
    if (mounted) setState(() => _step = 3);
  }

  // Einkaufslisten-Modus sofort persistieren (wie Sprache/Importsprache) —
  // die Wahl bleibt auch erhalten, wenn der Nutzer das Setup hier abbricht.
  Future<void> _selectExactMode(bool exact) async {
    setState(() => _exactQuantities = exact);
    HapticFeedback.selectionClick();
    final base = ref.read(settingsProvider).valueOrNull ?? const AppSettings();
    await ref
        .read(settingsProvider.notifier)
        .save(base.copyWith(addExactQuantities: exact));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      // Persistent log-access button: available on every setup step so der
      // User bei jedem Fehler die Logs ziehen kann. Sichtbarkeit erhöht
      // (gefülltes Icon + Label + Primärfarbe), damit der Knopf auf dem
      // transparenten AppBar nicht mehr untergeht (Issue „Logs not displaying").
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 48,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextButton.icon(
              onPressed: _showLogs,
              icon: Icon(Icons.bug_report_rounded, size: 20, color: primary),
              label: Text(l.logsTitle,
                  style:
                      TextStyle(color: primary, fontWeight: FontWeight.w600)),
              style: TextButton.styleFrom(
                backgroundColor: primary.withValues(alpha: 0.10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _StepIndicator(step: _step),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: switch (_step) {
                  0 => _buildWelcomeStep(l),
                  1 => _buildConnectStep(l),
                  2 => _buildShoppingStep(l),
                  3 => _buildExactModeStep(l),
                  4 => _buildImportLanguageStep(l),
                  _ => _buildCachingStep(l),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Step 0: Welcome + language ──────────────────────────────────────────
  Widget _buildWelcomeStep(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset('assets/images/app_icon.png',
                width: 120, height: 120),
          ),
        ),
        const SizedBox(height: 24),
        Text(l.setupTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(l.selectLanguage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),
        ..._kSetupLanguages.map((code) {
          final selected = _lang == code;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: selected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: selected
                  ? BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 1.5)
                  : BorderSide.none,
            ),
            child: ListTile(
              leading:
                  Text(_flagEmoji(code), style: const TextStyle(fontSize: 24)),
              title: Text(_langName(code)),
              trailing: selected
                  ? Icon(Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () => _selectLanguage(code),
            ),
          );
        }),
        const SizedBox(height: 24),
        GradientButton(
          label: l.setupContinue,
          onTap: () => setState(() => _step = 1),
        ),
        const SizedBox(height: 12),
        // Skip server setup and jump straight to Cook with friends.
        SecondaryButton(
          label: l.guestMode,
          icon: Icons.person_outline,
          onTap: _continueAsGuest,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ── Step 4: KI-Rezeptimport ─────────────────────────────────────────────
  // Nach der Serververbindung, weil die Funktion serverseitig eingerichtet
  // sein muss (OpenAI-Schlüssel in Mealie) — der Hinweis dazu steht hier.
  // Zweiter Zweck: Nutzer, deren Muttersprache die Oberfläche (noch) nicht
  // anbietet, wählen hier ihre Importsprache; die Liste ist deutlich breiter
  // als die 8 App-Sprachen und über das Suchfeld erreichbar.
  Widget _buildImportLanguageStep(AppLocalizations l) {
    final primary = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome_rounded, size: 36, color: primary),
          ),
        ),
        const SizedBox(height: 24),
        Text(l.setupImportLanguageTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text(l.setupImportLanguageBody,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 20),
        // Voraussetzung serverseitig — gleiche Formulierung wie der Hinweis
        // im Import-Screen, damit die Info nicht zweimal anders klingt.
        _InfoBox(
          icon: Icons.info_outline_rounded,
          title: l.openAIHintTitle,
          body: l.openAIHintBody,
        ),
        const SizedBox(height: 20),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: primary, width: 1.5),
          ),
          child: ListTile(
            leading: Text(importLanguageFlag(_importLang, _lang),
                style: const TextStyle(fontSize: 24)),
            title: Text(importLanguageLabel(_importLang, _lang)),
            subtitle:
                _importLang.isEmpty ? Text(l.importLanguageFollowApp) : null,
            trailing: const Icon(Icons.unfold_more),
            onTap: _pickImportLanguage,
          ),
        ),
        const SizedBox(height: 8),
        Text(l.setupImportLanguageSearchHint,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 28),
        GradientButton(
          label: l.setupContinue,
          onTap: () => setState(() => _step = 5),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => setState(() => _step = 3),
          child: Text(l.back),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // Sofort persistieren wie die App-Sprache — der Setup-Flow speichert die
  // restlichen Felder erst am Ende, die Sprachwahl soll aber auch dann
  // erhalten bleiben, wenn der Nutzer die Einrichtung abbricht.
  Future<void> _pickImportLanguage() async {
    final picked = await showImportLanguageSheet(
      context,
      current: _importLang,
      appLanguageLabel: _langName(_lang),
    );
    if (picked == null || !mounted) return;
    setState(() => _importLang = picked);
    final base = ref.read(settingsProvider).valueOrNull ?? const AppSettings();
    await ref
        .read(settingsProvider.notifier)
        .save(base.copyWith(importLanguage: picked));
  }

  // Guest mode is purpose-built for Cook-with-friends — saves the language,
  // marks the app as guest (so the setup redirect won't loop back here) and
  // jumps straight into the Cook Friends lobby, mirroring the iOS guest flow.
  Future<void> _continueAsGuest() async {
    final base = ref.read(settingsProvider).valueOrNull ?? const AppSettings();
    await ref.read(settingsProvider.notifier).save(
          base.copyWith(selectedLanguage: _lang, isGuestMode: true),
        );
    if (mounted) context.go('/cook-friends');
  }

  void _showLogs() {
    final l = AppLocalizations.of(context)!;
    final logs = LogManager.shared.getLogs();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.logsWithCount(LogManager.shared.count)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              logs.isEmpty ? '—' : logs,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: logs));
              Navigator.pop(context);
            },
            child: Text(l.copy),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.close),
          ),
        ],
      ),
    );
  }

  // ── Step 1: Connection ──────────────────────────────────────────────────
  Widget _buildConnectStep(AppLocalizations l) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Text(l.setupConnectStep,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(l.setupSubtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),

          TextFormField(
            controller: _urlCtrl,
            decoration: InputDecoration(
              labelText: l.serverUrl,
              hintText: l.serverUrlPlaceholder,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.dns_outlined),
            ),
            keyboardType: TextInputType.url,
            autocorrect: false,
            onChanged: (_) => setState(() {}),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l.required;
              final url = v.trim();
              if (!url.startsWith('http://') && !url.startsWith('https://')) {
                return l.urlInvalidScheme;
              }
              return null;
            },
          ),
          if (_urlCtrl.text.isNotEmpty &&
              !_urlCtrl.text.startsWith('http://') &&
              !_urlCtrl.text.startsWith('https://'))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, size: 14, color: Colors.red),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(l.urlInvalidScheme,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _urlCtrl.text = 'https://${_urlCtrl.text}';
                      _urlCtrl.selection = TextSelection.fromPosition(
                          TextPosition(offset: _urlCtrl.text.length));
                    }),
                    child: Text(l.urlAddScheme,
                        style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          // Erste Entscheidung: eigenes API-Token vorhanden (OIDC-/LDAP-
          // Nutzer ohne lokales Mealie-Passwort, oder wer bewusst ein
          // bestehendes Token nutzen will) oder per Benutzer/Passwort
          // anmelden — Default, weil einfacher als Profil → API-Tokens.
          Text(l.setupAuthChoiceTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          AuthModeChoiceCard(
            mode: AuthMode.password,
            selected: _authMode == AuthMode.password,
            icon: Icons.auto_awesome_rounded,
            title: l.authModePasswordTitle,
            subtitle: l.authModePasswordSubtitle,
            onTap: () => setState(() {
              _authMode = AuthMode.password;
              _error = null;
            }),
          ),
          const SizedBox(height: 8),
          AuthModeChoiceCard(
            mode: AuthMode.token,
            selected: _authMode == AuthMode.token,
            icon: Icons.key_outlined,
            title: l.authModeTokenTitle,
            subtitle: l.authModeTokenSubtitle,
            onTap: () => setState(() {
              _authMode = AuthMode.token;
              _error = null;
            }),
          ),
          const SizedBox(height: 16),

          if (_authMode == AuthMode.password) ...[
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
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              obscureText: _obscurePassword,
              autocorrect: false,
              validator: (v) => (v == null || v.isEmpty) ? l.required : null,
            ),
            const SizedBox(height: 6),
            Text(l.setupPasswordHint,
                style: Theme.of(context).textTheme.bodySmall),
          ] else
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
            ),
          const SizedBox(height: 8),

          // Haushalt wird NICHT mehr hier getippt — nach dem Verbinden holt
          // die App die Haushalte vom Server und Step 2 bietet sie als
          // Dropdown an (Textfeld-Fallback, falls der Endpoint fehlt).
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.optionalHeaders),
            trailing: Switch(
              value: _showHeaders,
              onChanged: (v) => setState(() => _showHeaders = v),
            ),
          ),
          if (_showHeaders) ...[
            _headerRow(_hk1, _hv1, '1'),
            const SizedBox(height: 8),
            _headerRow(_hk2, _hv2, '2'),
            const SizedBox(height: 8),
            _headerRow(_hk3, _hv3, '3'),
          ],
          const SizedBox(height: 16),

          if (_error != null) ...[
            Text(_error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 16),
          ],

          AsyncActionButton(
            expand: true,
            label:
                _authMode == AuthMode.password ? l.loginAndConnect : l.connect,
            onPressed: _connect,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => setState(() => _step = 0),
            child: Text(l.back),
          ),
        ],
      ),
    );
  }

  // ── Step 2: Haushalt + Einkaufsliste ────────────────────────────────────
  // Beide Werte kommen als Dropdown direkt vom Server (fetchHouseholds /
  // fetchShoppingLists aus _connect). Konnte der Haushalts-Endpoint nicht
  // geladen werden, bleibt das bisherige manuelle Textfeld als Fallback.
  Widget _buildShoppingStep(AppLocalizations l) {
    final householdNames = _households
        .map((h) => (h['name'] as String?)?.trim() ?? '')
        .where((n) => n.isNotEmpty)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(l.setupHouseholdListTitle,
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 24),
        if (householdNames.isNotEmpty)
          DropdownButtonFormField<String>(
            initialValue: _selectedHouseholdName,
            decoration: InputDecoration(
              labelText: l.householdId,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.home_outlined),
            ),
            items: householdNames
                .map((name) => DropdownMenuItem<String>(
                      value: name,
                      child: Text(name),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _selectedHouseholdName = v),
          )
        else ...[
          TextFormField(
            controller: _householdCtrl,
            decoration: InputDecoration(
              labelText: l.householdId,
              hintText: l.householdIdPlaceholder,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.home_outlined),
            ),
          ),
          const SizedBox(height: 6),
          Text(l.setupHouseholdManualHint,
              style: Theme.of(context).textTheme.bodySmall),
        ],
        const SizedBox(height: 16),
        if (_shoppingLists.isNotEmpty)
          DropdownButtonFormField<String>(
            initialValue: _selectedListId,
            decoration: InputDecoration(
              labelText: l.shoppingListLabel,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.format_list_bulleted_rounded),
            ),
            items: _shoppingLists
                .map((list) => DropdownMenuItem<String>(
                      value: list['id'] as String?,
                      child: Text(list['name'] as String? ?? ''),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _selectedListId = v),
          ),
        const SizedBox(height: 24),
        AsyncActionButton(
          expand: true,
          label: l.save,
          onPressed: _save,
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => setState(() => _step = 1),
          child: Text(l.back),
        ),
      ],
    );
  }

  // ── Step 3: Einkaufslisten-Modus (exakte Mengen vs. 1x) ─────────────────
  // Erklärt die Idee hinter der Umwandlung: in den meisten Ländern kauft man
  // nicht aufs Gramm genau ein, deshalb macht der einfache Modus aus jeder
  // Rezeptmenge „1×". Die Wahl wird sofort persistiert (addExactQuantities)
  // und ist später in den Einstellungen änderbar.
  Widget _buildExactModeStep(AppLocalizations l) {
    final primary = Theme.of(context).colorScheme.primary;

    Widget option({
      required bool exact,
      required IconData icon,
      required String title,
      required String body,
    }) {
      final selected = _exactQuantities == exact;
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: selected ? primary.withValues(alpha: 0.12) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: selected
              ? BorderSide(color: primary, width: 1.5)
              : BorderSide.none,
        ),
        child: ListTile(
          leading: Icon(icon, color: selected ? primary : null),
          title: Text(title),
          subtitle: Text(body),
          trailing: selected ? Icon(Icons.check_circle, color: primary) : null,
          onTap: () => _selectExactMode(exact),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.scale_rounded, size: 36, color: primary),
          ),
        ),
        const SizedBox(height: 24),
        Text(l.setupExactTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text(l.setupExactBody,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 20),
        option(
          exact: false,
          icon: Icons.shopping_basket_outlined,
          title: l.setupExactSimpleTitle,
          body: l.setupExactSimpleBody,
        ),
        option(
          exact: true,
          icon: Icons.scale_rounded,
          title: l.setupExactExactTitle,
          body: l.setupExactExactBody,
        ),
        const SizedBox(height: 28),
        GradientButton(
          label: l.setupContinue,
          onTap: () => setState(() => _step = 4),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => setState(() => _step = 2),
          child: Text(l.back),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ── Step 5: Erst-Cache der Rezepte ──────────────────────────────────────
  // Zeigt den inkrementellen Erst-Load (recipesProvider läuft selbstständig,
  // recipeListProgressProvider spiegelt den Fortschritt) mit rotierenden
  // Tipps. „Fertig" gilt auch bei Warm-Cache (Daten da, kein Load gestartet)
  // und bei Fehlschlag (App bleibt nutzbar, die Liste holt später nach) —
  // der User darf hier nie festhängen.
  Widget _buildCachingStep(AppLocalizations l) {
    final recipesAsync = ref.watch(recipesProvider);
    final progress = ref.watch(recipeListProgressProvider);
    final count = recipesAsync.valueOrNull?.length ?? 0;
    final done =
        progress >= 1 || (progress == 0 && count > 0) || recipesAsync.hasError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(done ? l.setupCachingDone : l.setupCachingTitle,
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(l.setupCachingSubtitle,
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 32),
        if (done)
          const Center(
            child:
                Icon(Icons.check_circle_rounded, size: 64, color: Colors.green),
          )
        else ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              // Vor dem ersten Batch (progress 0) unbestimmt animieren.
              value: progress > 0 ? progress : null,
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            progress > 0
                ? '${(progress * 100).round()} % · $count ${l.recipes}'
                : '…',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          // Nur solange wirklich geladen wird: der Erst-Cache läuft im
          // Vordergrund und bricht ab, wenn das System die App suspendiert.
          _InfoBox(
            icon: Icons.warning_amber_rounded,
            title: l.setupCachingKeepOpenTitle,
            body: l.setupCachingKeepOpenBody,
            tint: Colors.orange,
          ),
        ],
        const SizedBox(height: 32),
        _SetupTipsCarousel(tips: [
          l.setupTip1,
          l.setupTip2,
          l.setupTip3,
          l.setupTip4,
          l.setupTip5,
        ]),
        const SizedBox(height: 32),
        if (done)
          GradientButton(
            label: l.setupFinish,
            onTap: () => context.go('/home'),
          )
        else
          SecondaryButton(
            label: l.setupSkipCaching,
            icon: Icons.schedule_rounded,
            onTap: () => context.go('/home'),
          ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _headerRow(
      TextEditingController keyCtrl, TextEditingController valCtrl, String n) {
    final l = AppLocalizations.of(context)!;
    final idx = int.tryParse(n) ?? 0;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: keyCtrl,
            decoration: InputDecoration(
              labelText: l.keyN(idx),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: valCtrl,
            decoration: InputDecoration(
              labelText: l.valueN(idx),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
      ],
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

// ---------------------------------------------------------------------------
// Rotierende Setup-Tipps — klassische „Schon gewusst?"-Karte, wechselt alle
// paar Sekunden per Fade zum nächsten Tipp (Punkte-Indikator darunter).
// ---------------------------------------------------------------------------

class _SetupTipsCarousel extends StatefulWidget {
  final List<String> tips;
  const _SetupTipsCarousel({required this.tips});

  @override
  State<_SetupTipsCarousel> createState() => _SetupTipsCarouselState();
}

class _SetupTipsCarouselState extends State<_SetupTipsCarousel> {
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % widget.tips.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_rounded, size: 18, color: primary),
              const SizedBox(width: 8),
              Text(l.setupTipsHeader,
                  style:
                      TextStyle(fontWeight: FontWeight.w700, color: primary)),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: Text(
              widget.tips[_index],
              key: ValueKey(_index),
              style:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var i = 0; i < widget.tips.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 5),
                  width: i == _index ? 14 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color:
                        i == _index ? primary : primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step progress dots
// ---------------------------------------------------------------------------

// Hinweiskasten im Setup — getönter Hintergrund statt nur Fließtext, damit
// Voraussetzungen (Mealie-Konfiguration) und Warnungen (App offen lassen)
// nicht zwischen den übrigen Absätzen untergehen.
class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  /// Akzentfarbe; ohne Angabe die Primärfarbe des Themes.
  final Color? tint;

  const _InfoBox({
    required this.icon,
    required this.title,
    required this.body,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final color = tint ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(body, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int step;
  const _StepIndicator({required this.step});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (i) {
          final active = i <= step;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == step ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: active ? primary : primary.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}
