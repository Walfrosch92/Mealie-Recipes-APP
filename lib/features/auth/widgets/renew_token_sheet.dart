import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/sheet_title.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/app_settings.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/async_action_button.dart';
import '../../../shared/widgets/auth_mode_choice_card.dart';
import '../../../shared/widgets/gradient_button.dart' show SheetHandle;
import '../../users/providers/users_provider.dart' show userDisplayName;

class _WrongAccount implements Exception {
  _WrongAccount(this.name);
  final String name;
}

// ─────────────────────────────────────────────────────────────────────────────
// „API-Token erneuern"-Sheet — gleiche Wahl wie Setup Step 1 (eigenes Token
// einfügen vs. per Login erzeugen lassen), aber als Re-Login-Flow: prüft im
// Token-Zweig die Verbindung (testConnection + fetchShoppingLists, validiert
// den Bearer implizit), im Passwort-Zweig läuft Login→Token-Erzeugung wie im
// Setup. Liefert bei Erfolg (token, generatedId, version) an den Aufrufer;
// PERSISTIERT NICHTS selbst — das übernimmt weiterhin „Änderungen speichern".
// ─────────────────────────────────────────────────────────────────────────────

class RenewTokenSheet extends StatefulWidget {
  final String serverUrl;
  final bool sendOptionalHeaders;
  final String headerKey1;
  final String headerValue1;
  final String headerKey2;
  final String headerValue2;
  final String headerKey3;
  final String headerValue3;

  /// Überschrift (Standard: „API-Token erneuern").
  final String? title;

  /// Benutzername vorausfüllen (erneute Anmeldung bei einem gespeicherten
  /// Konto).
  final String initialUsername;

  /// Anfangs gewählte Anmeldeart.
  final AuthMode initialMode;

  /// Wenn gesetzt: das Token MUSS zu diesem Mealie-Benutzer gehören, sonst
  /// Fehler (ein erzeugtes Token wird dann wieder gelöscht). Schutz davor,
  /// dass beim Wechsel zu Konto A versehentlich mit B angemeldet wird und
  /// die abgelegten Daten von A unter B's Token weiterlaufen.
  final String? expectedUserId;

  const RenewTokenSheet({
    super.key,
    this.title,
    this.initialUsername = '',
    this.initialMode = AuthMode.password,
    this.expectedUserId,
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
  State<RenewTokenSheet> createState() => _RenewTokenSheetState();
}

class _RenewTokenSheetState extends State<RenewTokenSheet> {
  final _formKey = GlobalKey<FormState>();
  final _tokenCtrl = TextEditingController();
  late final _usernameCtrl =
      TextEditingController(text: widget.initialUsername);
  final _passwordCtrl = TextEditingController();
  late AuthMode _mode = widget.initialMode;
  String? _error;

  /// Gehört [token] zum erwarteten Benutzer? Ein falsches, gerade erzeugtes
  /// Token wird wieder gelöscht.
  Future<void> _verifyUser(
      String ver, String token, String? generatedId) async {
    final expected = widget.expectedUserId;
    if (expected == null) return;
    final svc = ApiService(_probeSettings(ver).copyWith(apiToken: token));
    final me = await svc.fetchCurrentUser();
    if (me['id']?.toString() == expected) return;
    if (generatedId != null) {
      try {
        await svc.deleteLongLiveToken(generatedId);
      } catch (_) {}
    }
    throw _WrongAccount(userDisplayName(me));
  }

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
          await _verifyUser(ver, token, null);
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
          await _verifyUser(ver, token, id);
          if (!mounted) return;
          Navigator.pop(context, (token, id, ver));
          return;
        }
      } on _WrongAccount catch (e) {
        if (!mounted) return;
        setState(() =>
            _error = AppLocalizations.of(context)!.wrongAccountError(e.name));
        return;
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
      child: AutofillGroup(
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
                child: SheetTitle(widget.title ?? l.renewApiToken),
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
                  // Passwort-Manager / Schlüsselbund: Feld als Benutzername melden.
                  autofillHints: const [AutofillHints.username],
                  textInputAction: TextInputAction.next,
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
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? l.required : null,
                ),
                const SizedBox(height: 6),
                Text(l.setupPasswordHint,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
              const SizedBox(height: 16),
              if (_error != null) ...[
                Text(_error!, style: TextStyle(color: AppTokens.danger)),
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
      )),
    );
  }
}
