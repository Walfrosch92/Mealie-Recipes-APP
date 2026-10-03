import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/async_action_button.dart';
import '../widgets/tool_widgets.dart';

// ---------------------------------------------------------------------------
// Administration (nur Admins) — Mealie /admin/site-settings: Konfigurations-
// Prüfungen (Version, Server-Basis-URL, LDAP/OIDC, E-Mail + Test-Mail),
// Website-Statistik und allgemeine Infos; dazu Einstiege in Sicherungen und
// Wartung. Werte 1:1 aus /api/admin/about(/statistics|/check).
// ---------------------------------------------------------------------------

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  Map<String, dynamic>? _about;
  Map<String, dynamic>? _stats;
  Map<String, dynamic>? _check;
  Object? _error;
  final _email = TextEditingController();
  ({bool ok, String? error})? _mailResult;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final api = ref.read(apiServiceProvider);
    try {
      final r = await Future.wait([
        api.fetchAdminAbout(),
        api.fetchAdminStatistics(),
        api.fetchAdminConfigCheck(),
      ]);
      if (!mounted) return;
      setState(() {
        _about = r[0];
        _stats = r[1];
        _check = r[2];
        _error = null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _sendTestMail() async {
    final l = AppLocalizations.of(context)!;
    final to = _email.text.trim();
    if (!to.contains('@')) {
      showToolMessage(context, l.adminEmailInvalid);
      return;
    }
    try {
      final r = await ref.read(apiServiceProvider).sendTestEmail(to);
      if (!mounted) return;
      setState(() => _mailResult =
          (ok: r['success'] == true, error: r['error']?.toString()));
    } catch (e) {
      if (!mounted) return;
      setState(() => _mailResult = (ok: false, error: mealieErrorMessage(e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final about = _about, stats = _stats, check = _check;
    String yesNo(dynamic v) => v == true ? l.yesLabel : l.noLabel;

    return ToolPage(
      title: l.adminTitle,
      onRefresh: _load,
      children: [
        // ── Einstiege ──────────────────────────────────────────────────
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _NavTile(
                icon: Icons.backup_rounded,
                title: l.backupsTitle,
                onTap: () => context.push('/admin/backups')),
            _NavTile(
                icon: Icons.build_circle_rounded,
                title: l.maintenanceTitle,
                onTap: () => context.push('/admin/maintenance')),
          ],
        ),
        const SizedBox(height: 14),
        if (about == null || stats == null || check == null)
          ToolEmpty(
              _error == null
                  ? ''
                  : (mealieErrorMessage(_error!) ?? l.loadFailed),
              loading: _error == null)
        else ...[
          // ── Konfiguration ────────────────────────────────────────────
          ToolCard(
            title: l.adminConfiguration,
            icon: Icons.fact_check_rounded,
            children: [
              ToolStatusRow(
                ok: check['isUpToDate'] == true,
                title: l.adminAppVersion,
                detail: check['isUpToDate'] == true
                    ? l.adminUpToDate
                    : l.adminVersionOutdated(about['version']?.toString() ?? '',
                        about['versionLatest']?.toString() ?? ''),
              ),
              ToolStatusRow(
                ok: check['baseUrlSet'] == true,
                title: l.adminBaseUrl,
                detail: check['baseUrlSet'] == true
                    ? l.adminBaseUrlOk
                    : l.adminBaseUrlError,
              ),
              for (final (name, ready, disabled, envVar) in [
                (
                  'LDAP',
                  check['ldapReady'],
                  check['ldapDisabled'],
                  'LDAP_AUTH_ENABLED'
                ),
                (
                  'OIDC',
                  check['oidcReady'],
                  check['oidcDisabled'],
                  'OIDC_AUTH_ENABLED'
                ),
              ])
                ToolStatusRow(
                  ok: ready == true,
                  title: disabled == true
                      ? l.adminAuthDisabled(name)
                      : (ready == true
                          ? l.adminAuthReady(name)
                          : l.adminAuthNotReady(name)),
                  detail: disabled == true
                      ? l.adminAuthDisabledText(envVar)
                      : (ready == true
                          ? l.adminAuthSuccessText(name)
                          : l.adminAuthErrorText(name)),
                ),
            ],
          ),

          // ── E-Mail ───────────────────────────────────────────────────
          ToolCard(
            title: l.adminEmailStatus,
            icon: Icons.mail_rounded,
            children: [
              ToolStatusRow(
                ok: check['emailReady'] == true,
                title: l.adminEmailConfigured,
                detail: check['emailReady'] == true ? null : l.adminNotReady,
              ),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: l.adminTestEmailAddress,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                AsyncActionButton(
                  icon: Icons.send_rounded,
                  label: l.adminSendTestEmail,
                  onPressed: check['emailReady'] == true ? _sendTestMail : null,
                ),
              ]),
              if (_mailResult != null)
                ToolStatusRow(
                  ok: _mailResult!.ok,
                  title: l.adminEmailTestResult(
                      _mailResult!.ok ? l.adminSucceeded : l.adminFailed),
                  detail: _mailResult!.error,
                ),
            ],
          ),

          // ── Statistik ────────────────────────────────────────────────
          ToolCard(
            title: l.adminSiteStatistics,
            icon: Icons.bar_chart_rounded,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _Stat(l.recipes, stats['totalRecipes']),
                  _Stat(l.adminStatUsers, stats['totalUsers']),
                  _Stat(l.adminStatHouseholds, stats['totalHouseholds']),
                  _Stat(l.adminStatGroups, stats['totalGroups']),
                  _Stat(l.adminUncategorized, stats['uncategorizedRecipes']),
                  _Stat(l.adminUntagged, stats['untaggedRecipes']),
                ],
              ),
            ],
          ),

          // ── Allgemein ────────────────────────────────────────────────
          ToolCard(
            title: l.adminGeneralAbout,
            icon: Icons.info_outline_rounded,
            children: [
              ToolInfoRow(l.adminVersion, about['version']?.toString() ?? ''),
              ToolInfoRow(l.adminBuild, about['buildId']?.toString() ?? ''),
              ToolInfoRow(
                  l.adminApplicationMode,
                  about['production'] == true
                      ? l.adminProduction
                      : l.adminDevelopment),
              ToolInfoRow(l.adminDemoStatus,
                  about['demoStatus'] == true ? l.adminDemo : l.adminNotDemo),
              ToolInfoRow(l.adminApiPort, about['apiPort']?.toString() ?? ''),
              ToolInfoRow(l.adminApiDocs,
                  about['apiDocs'] == true ? l.enabledLabel : l.disabledLabel),
              ToolInfoRow(
                  l.adminDatabaseType, about['dbType']?.toString() ?? ''),
              if ((about['dbUrl']?.toString() ?? '').isNotEmpty)
                ToolInfoRow(l.adminDatabaseUrl, about['dbUrl'].toString()),
              ToolInfoRow(
                  l.adminDefaultGroup, about['defaultGroup']?.toString() ?? ''),
              ToolInfoRow(l.adminDefaultHousehold,
                  about['defaultHousehold']?.toString() ?? ''),
              ToolInfoRow(l.adminAllowSignup, yesNo(about['allowSignup'])),
              ToolInfoRow(l.adminAllowPasswordLogin,
                  yesNo(about['allowPasswordLogin'])),
              ToolInfoRow(l.adminScraperVersion,
                  about['recipeScraperVersion']?.toString() ?? ''),
            ],
          ),
        ],
      ],
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _NavTile(
      {required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 240,
        child: Material(
          color: context.appCard,
          borderRadius: BorderRadius.circular(AppTokens.rMd),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTokens.rMd),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTokens.rMd),
                border: Border.all(color: context.appSeparator),
              ),
              child: Row(children: [
                Icon(icon, color: AppTokens.accentDeep),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title,
                      style: TextStyle(
                          color: context.appFg,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                ),
                Icon(Icons.chevron_right_rounded, color: context.appFgTertiary),
              ]),
            ),
          ),
        ),
      );
}

class _Stat extends StatelessWidget {
  final String label;
  final dynamic value;
  const _Stat(this.label, this.value);

  @override
  Widget build(BuildContext context) => Container(
        width: 170,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.appSurface2,
          borderRadius: BorderRadius.circular(AppTokens.rSm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${value ?? 0}',
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 24,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(color: context.appFgSub, fontSize: 12.5)),
          ],
        ),
      );
}
