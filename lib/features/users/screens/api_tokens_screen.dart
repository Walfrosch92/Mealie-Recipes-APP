import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../webapp_tools/widgets/tool_widgets.dart';

// ---------------------------------------------------------------------------
// Eigene API-Token — wie Profil → API-Token der Mealie-Webapp
// (pages/user/profile/api-tokens.vue). Rechte wie Mealie:
//   • nur eigene Token (Server: Löschen fremder → 403),
//   • sichtbar nur mit „Erweiterte Funktionen" (`advanced`, Webapp-
//     Middleware advanced-only) — der Menüpunkt prüft das.
// Der Token wird nur EINMAL direkt nach dem Erzeugen gezeigt. Das Token, mit
// dem die App selbst angemeldet ist (Benutzer/Passwort-Login), lässt sich
// hier nicht löschen — sonst sperrte man sich aus.
// ---------------------------------------------------------------------------

class ApiTokensScreen extends ConsumerStatefulWidget {
  const ApiTokensScreen({super.key});

  @override
  ConsumerState<ApiTokensScreen> createState() => _ApiTokensScreenState();
}

class _ApiTokensScreenState extends ConsumerState<ApiTokensScreen> {
  final _name = TextEditingController();
  List<Map<String, dynamic>>? _tokens;
  Object? _error;
  bool _busy = false;

  /// Frisch erzeugter Token (nur bis zum Verlassen der Seite sichtbar).
  String? _created;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final t = await ref.read(apiServiceProvider).fetchOwnApiTokens();
      if (!mounted) return;
      setState(() {
        _tokens = t;
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  String get _appTokenId =>
      ref.read(settingsProvider).valueOrNull?.generatedApiTokenId ?? '';

  Future<void> _create() async {
    final l = AppLocalizations.of(context)!;
    final name = _name.text.trim();
    if (name.isEmpty) return;
    setState(() => _busy = true);
    try {
      final (_, token) =
          await ref.read(apiServiceProvider).createApiToken(name);
      if (!mounted) return;
      _name.clear();
      setState(() => _created = token);
      await _load();
    } catch (e) {
      if (mounted) showToolError(context, l.createFailed, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete(Map<String, dynamic> t) async {
    final l = AppLocalizations.of(context)!;
    final name = t['name']?.toString() ?? '';
    final ok = await confirmTool(context,
        message: l.apiTokenDeleteConfirm(name));
    if (!ok || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(apiServiceProvider)
          .deleteLongLiveToken(t['id'].toString());
      await _load();
    } catch (e) {
      if (mounted) showToolError(context, l.deleteFailed, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final tokens = _tokens;
    final appId = _appTokenId;
    return ToolPage(
      title: l.apiTokensTitle,
      description: l.apiTokensDescription,
      busy: _busy,
      onRefresh: _load,
      children: [
        ToolCard(
          title: l.apiTokenGenerate,
          icon: Icons.key_rounded,
          children: [
            TextField(
              controller: _name,
              enabled: !_busy,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _create(),
              decoration: InputDecoration(
                labelText: l.apiTokenNameLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed:
                    _busy || _name.text.trim().isEmpty ? null : _create,
                icon: const Icon(Icons.add_rounded),
                label: Text(l.apiTokenGenerate),
              ),
            ),
            if (_created != null) ...[
              const SizedBox(height: 14),
              ToolNotice(l.apiTokenCopyWarning, danger: true),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.appSurface2,
                  borderRadius: BorderRadius.circular(AppTokens.rSm),
                  border: Border.all(color: context.appSeparator),
                ),
                child: SelectableText(_created!,
                    style: TextStyle(
                        color: context.appFg,
                        fontFamily: 'monospace',
                        fontSize: 12.5)),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: _created!));
                    if (context.mounted) {
                      showToolMessage(context, l.apiTokenCopied);
                    }
                  },
                  icon: const Icon(Icons.copy_rounded),
                  label: Text(l.copy),
                ),
              ),
            ],
          ],
        ),
        if (tokens == null)
          ToolEmpty(
              _error == null
                  ? ''
                  : (mealieErrorMessage(_error!) ?? l.loadFailed),
              loading: _error == null)
        else
          ToolCard(
            title: l.apiTokensActive,
            icon: Icons.vpn_key_rounded,
            children: [
              if (tokens.isEmpty)
                Text(l.apiTokensEmpty,
                    style: TextStyle(color: context.appFgSub))
              else
                for (final t in tokens)
                  _TokenRow(
                    token: t,
                    isApp: appId.isNotEmpty && t['id']?.toString() == appId,
                    onDelete: _busy ? null : () => _delete(t),
                  ),
            ],
          ),
      ],
    );
  }
}

class _TokenRow extends StatelessWidget {
  final Map<String, dynamic> token;
  final bool isApp;
  final VoidCallback? onDelete;
  const _TokenRow({required this.token, required this.isApp, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final created = token['createdAt'];
    final subtitle = [
      if (created != null)
        l.apiTokenCreatedOn(formatToolDate(context, created, time: false)),
      if (isApp) l.apiTokenThisApp,
    ].join(' · ');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(isApp ? Icons.phone_iphone_rounded : Icons.key_rounded,
          color: AppTokens.accentDeep),
      title: Text(token['name']?.toString() ?? '',
          style: TextStyle(color: context.appFg, fontWeight: FontWeight.w600)),
      subtitle: subtitle.isEmpty
          ? null
          : Text(subtitle, style: TextStyle(color: context.appFgSub)),
      trailing: isApp
          ? Tooltip(
              message: l.apiTokenThisAppHint,
              child: Icon(Icons.lock_rounded, color: context.appFgTertiary),
            )
          : IconButton(
              tooltip: l.delete,
              icon: const Icon(Icons.delete_outline_rounded,
                  color: Color(0xFFD9443A)),
              onPressed: onDelete,
            ),
    );
  }
}
