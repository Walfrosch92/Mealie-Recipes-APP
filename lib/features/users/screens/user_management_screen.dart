import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/api/api_service.dart';
import '../../../core/providers/cached_json_list.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/utils/search_match.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/read_only_banner.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
import '../providers/users_provider.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/photo_source_sheet.dart';

// ---------------------------------------------------------------------------
// Benutzerverwaltung — wie in der Mealie-Webapp, abgestuft nach Rechten:
//  • Admin:        alle Benutzer — erstellen, bearbeiten (Name, Benutzername,
//                  E-Mail, Haushalt, Administrator, erweiterte Funktionen,
//                  Berechtigungen), löschen, Link zum Zurücksetzen des
//                  Passworts, gesperrte Benutzer zurücksetzen.
//  • „Verwalten":  Mitglieder des eigenen Haushalts + deren Berechtigungen
//                  (die eigenen lehnt Mealie ab).
//  • „Einladen":   Einladungslink erzeugen, teilen, per E-Mail senden.
//  • Jeder:        das eigene Konto — Profilbild, Name, Benutzername, E-Mail,
//                  Passwort ändern (nicht bei LDAP/OIDC). Rechte, Haushalt
//                  und Administrator-Status des eigenen Kontos bleiben fest.
// Der Server prüft alles selbst; die App zeigt nur Passendes an.
// ---------------------------------------------------------------------------

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  String _query = '';

  void _snack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _error(String fallback, Object e) {
    final detail = mealieErrorMessage(e);
    _snack(detail ?? fallback);
  }

  Future<void> _openUser(Map<String, dynamic>? user) async {
    final perms = ref.read(userPermissionsProvider);
    if (!perms.admin && user != null && user['id'] == perms.id) {
      await showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: context.appCard,
        builder: (_) => _SelfSheet(user: user),
      );
    } else if (perms.admin) {
      await showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: context.appCard,
        builder: (_) => _AdminUserSheet(user: user),
      );
    } else if (perms.canManage && user != null && user['id'] != perms.id) {
      await showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: context.appCard,
        builder: (_) => _PermissionsSheet(user: user),
      );
    }
  }

  Future<void> _invite() => showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: context.appCard,
        builder: (_) => const _InviteSheet(),
      );

  Future<void> _unlock() async {
    final l = AppLocalizations.of(context)!;
    try {
      final n = await ref.read(apiServiceProvider).unlockLockedUsers();
      _snack(l.lockedUsersReset(n));
    } catch (e) {
      _error(l.saveFailed, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final perms = ref.watch(userPermissionsProvider);
    final async = ref.watch(usersProvider);
    final canInvite = perms.admin || perms.canInvite;

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Text(l.userManagementTitle),
        actions: [
          if (perms.admin)
            IconButton(
              icon: const Icon(Icons.person_add_alt_1_rounded),
              tooltip: l.createUserTitle,
              onPressed: () => _openUser(null),
            ),
          if (canInvite || perms.admin)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded),
              color: context.appCard,
              onSelected: (v) => v == 'invite' ? _invite() : _unlock(),
              itemBuilder: (_) => [
                if (canInvite)
                  PopupMenuItem(
                    value: 'invite',
                    child: Row(children: [
                      const Icon(Icons.link_rounded, size: 20),
                      const SizedBox(width: 12),
                      Text(l.inviteAction),
                    ]),
                  ),
                if (perms.admin)
                  PopupMenuItem(
                    value: 'unlock',
                    child: Row(children: [
                      const Icon(Icons.lock_open_rounded, size: 20),
                      const SizedBox(width: 12),
                      Flexible(child: Text(l.resetLockedUsersAction)),
                    ]),
                  ),
              ],
            ),
        ],
      ),
      body: WithCookingModeFAB(
        child: SafeArea(
          top: false,
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(mealieErrorMessage(e) ?? e.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: context.appFgSub)),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => ref.invalidate(usersProvider),
                      child: Text(l.retry),
                    ),
                  ],
                ),
              ),
            ),
            data: (users) {
              final terms = searchTerms(_query);
              final shown = users
                  .where((u) => terms.every(normalizeForSearch([
                        u['fullName'],
                        u['username'],
                        u['email'],
                      ].whereType<String>().join(' '))
                          .contains))
                  .toList();
              return Column(
                children: [
                  if (!perms.admin && perms.canManage)
                    ReadOnlyBanner(text: l.membersPermissionsHint),
                  if (!perms.mayManageUsers)
                    ReadOnlyBanner(text: l.ownAccountHint),
                  if (perms.mayManageUsers)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: TextField(
                        onChanged: (v) => setState(() => _query = v),
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          hintText: l.search,
                          prefixIcon: Icon(Icons.search_rounded,
                              color: context.appFgSub),
                          filled: true,
                          fillColor: context.appCard,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTokens.rSm),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: ref.read(usersProvider.notifier).refresh,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: shown.length,
                        itemBuilder: (_, i) {
                          final u = shown[i];
                          final isMe = u['id'] == perms.id;
                          final tappable =
                              perms.admin || perms.canManage || isMe;
                          return EntranceOnce(
                            id: 'user-${u['id']}',
                            index: i,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _UserCard(
                                user: u,
                                isMe: isMe,
                                showHousehold: perms.admin,
                                onTap: tappable ? () => _openUser(u) : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final bool isMe;
  final bool showHousehold;
  final VoidCallback? onTap;

  const _UserCard({
    required this.user,
    required this.isMe,
    required this.showHousehold,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final name = userDisplayName(user);
    final sub = [
      if (((user['username'] as String?) ?? '').isNotEmpty &&
          user['username'] != name)
        '@${user['username']}',
      if (showHousehold && ((user['household'] as String?) ?? '').isNotEmpty)
        user['household'] as String,
    ].join(' · ');
    Widget badge(String text, {bool strong = false}) => Container(
          margin: const EdgeInsets.only(left: 6),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: strong
                ? AppTokens.accent.withValues(alpha: 0.18)
                : context.appSurface2,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(text,
              style: TextStyle(
                  color: strong ? AppTokens.accentDeep : context.appFgSub,
                  fontSize: 11,
                  fontWeight: FontWeight.w700)),
        );
    final permIcons = <IconData>[
      if (user['canOrganize'] == true) Icons.category_rounded,
      if (user['canManage'] == true) Icons.settings_rounded,
      if (user['canManageHousehold'] == true) Icons.home_rounded,
      if (user['canInvite'] == true) Icons.person_add_alt_rounded,
    ];
    return BounceTap(
      onTap: onTap,
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: context.appCard,
          borderRadius: BorderRadius.circular(AppTokens.rMd),
          border: Border.all(color: context.appSeparator, width: 1),
          boxShadow: context.appShadowSm,
        ),
        child: Row(
          children: [
            UserAvatar(
              userId: user['id']?.toString(),
              name: name,
              radius: 20,
              cacheKey: user['cacheKey']?.toString(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Flexible(
                      child: Text(name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: context.appFg,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                    ),
                    if (isMe) badge(l.youLabel),
                    if (user['admin'] == true)
                      badge(l.administratorLabel, strong: true),
                  ]),
                  if (sub.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(sub,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: context.appFgSub, fontSize: 12.5)),
                    ),
                  if (permIcons.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(children: [
                        for (final i in permIcons)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child:
                                Icon(i, size: 15, color: context.appFgTertiary),
                          ),
                      ]),
                    ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right_rounded, color: context.appFgTertiary),
          ],
        ),
      ),
    );
  }
}

// ── Berechtigungs-Schalter (geteilt) ─────────────────────────────────────

class _PermissionSwitches extends StatelessWidget {
  final Map<String, bool> values;
  final ValueChanged<MapEntry<String, bool>> onChanged;
  const _PermissionSwitches({required this.values, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final labels = {
      'canInvite': l.permCanInvite,
      'canManage': l.permCanManage,
      'canManageHousehold': l.permCanManageHousehold,
      'canOrganize': l.permCanOrganize,
    };
    return Column(
      children: [
        for (final e in labels.entries)
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(e.value,
                style: TextStyle(color: context.appFg, fontSize: 14)),
            value: values[e.key] ?? false,
            activeTrackColor: AppTokens.accent,
            onChanged: (v) => onChanged(MapEntry(e.key, v)),
          ),
      ],
    );
  }
}

Widget _sheetTitle(BuildContext context, String text) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(text,
          style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              color: context.appFg,
              fontSize: 20,
              fontWeight: FontWeight.w800)),
    );

Widget _section(BuildContext context, String text) => Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(text,
          style: TextStyle(
              color: context.appFg, fontSize: 14, fontWeight: FontWeight.w700)),
    );

// ── Admin: erstellen / bearbeiten ────────────────────────────────────────

class _AdminUserSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic>? user;
  const _AdminUserSheet({this.user});

  @override
  ConsumerState<_AdminUserSheet> createState() => _AdminUserSheetState();
}

class _AdminUserSheetState extends ConsumerState<_AdminUserSheet> {
  Map<String, dynamic>? get _u => widget.user;
  bool get _isNew => _u == null;

  late final _fullName =
      TextEditingController(text: (_u?['fullName'] as String?) ?? '');
  late final _username =
      TextEditingController(text: (_u?['username'] as String?) ?? '');
  late final _email =
      TextEditingController(text: (_u?['email'] as String?) ?? '');
  final _password = TextEditingController();
  late bool _admin = _u?['admin'] == true;
  late bool _advanced = _u?['advanced'] == true;
  late final Map<String, bool> _perms = {
    for (final k in [
      'canInvite',
      'canManage',
      'canManageHousehold',
      'canOrganize'
    ])
      k: _u?[k] == true,
  };
  String? _householdId;
  // Cache-first (auch offline auswählbar).
  List<Map<String, dynamic>> get _households =>
      ref.read(householdsListProvider).valueOrNull ?? const [];
  bool _saving = false;
  bool _uploadingImage = false;
  final Set<String> _missing = {};

  @override
  void initState() {
    super.initState();
    _householdId =
        (_u?['householdId'] ?? ref.read(userPermissionsProvider).householdId)
            ?.toString();
  }

  @override
  void dispose() {
    for (final c in [_fullName, _username, _email, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _householdName(String? id) {
    for (final h in _households) {
      if (h['id'] == id) return h['name']?.toString();
    }
    return null;
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    _missing.clear();
    if (_fullName.text.trim().isEmpty) _missing.add('fullName');
    if (_username.text.trim().isEmpty) _missing.add('username');
    if (_email.text.trim().isEmpty) _missing.add('email');
    if (_isNew && _password.text.isEmpty) _missing.add('password');
    if (_missing.isNotEmpty) {
      setState(() {});
      return;
    }
    setState(() => _saving = true);
    final household = _householdName(_householdId);
    final data = <String, dynamic>{
      'fullName': _fullName.text.trim(),
      'username': _username.text.trim(),
      'email': _email.text.trim(),
      'admin': _admin,
      'advanced': _advanced,
      ..._perms,
      if (household != null) 'household': household,
      if (household != null) 'householdId': _householdId,
    };
    try {
      final n = ref.read(usersProvider.notifier);
      if (_isNew) {
        final me = ref.read(currentUserProvider);
        await n.create({
          ...data,
          'password': _password.text,
          if (me?['group'] != null) 'group': me!['group'],
        });
      } else {
        await n.saveUser(_u!['id'] as String, data);
      }
      nav.pop();
      messenger.showSnackBar(
          SnackBar(content: Text(_isNew ? l.userCreated : l.userUpdated)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(
          content: Text(mealieErrorMessage(e) ??
              (_isNew ? l.createFailed : l.saveFailed))));
    }
  }

  /// Profilbild setzen (Kamera/Fotos). Mealie erlaubt das Admins für alle.
  Future<void> _changeImage() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final file = await pickPhotoWithSource(context);
    if (file == null || !mounted) return;
    setState(() => _uploadingImage = true);
    try {
      await ref
          .read(apiServiceProvider)
          .uploadUserImage(_u!['id'] as String, await file.readAsBytes());
      // Alle Avatare (Liste, Kommentare, Zeitstrahl) laden das neue Bild.
      ref.read(avatarRevisionProvider.notifier).state++;
      messenger.showSnackBar(SnackBar(content: Text(l.profileImageUpdated)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(
          content: Text(mealieErrorMessage(e) ?? l.profileImageFailed)));
    } finally {
      if (mounted) setState(() => _uploadingImage = false);
    }
  }

  Future<void> _resetLink() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final token = await ref
          .read(apiServiceProvider)
          .createPasswordResetToken(_email.text.trim());
      final server = ref.read(settingsProvider).valueOrNull?.serverUrl ?? '';
      final link = '$server/reset-password/?token=$token';
      await Clipboard.setData(ClipboardData(text: link));
      messenger.showSnackBar(SnackBar(
        content: Text(l.passwordResetLinkCopied),
        action: SnackBarAction(
            label: l.assetsShare, onPressed: () => Share.share(link)),
      ));
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(mealieErrorMessage(e) ?? l.saveFailed)));
    }
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: ctx.appCard,
            content: Text(l.userDeleteConfirm(userDisplayName(_u!)),
                style: TextStyle(color: ctx.appFg)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l.cancel)),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l.delete),
              ),
            ],
          ),
        ) ??
        false;
    if (!ok) return;
    try {
      await ref.read(usersProvider.notifier).delete(_u!['id'] as String);
      nav.pop();
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(mealieErrorMessage(e) ?? l.deleteFailed)));
    }
  }

  Widget _field(TextEditingController c, String label, String key,
          {bool obscure = false, TextInputType? type}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          obscureText: obscure,
          keyboardType: type,
          autocorrect: false,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            labelText: label,
            errorText: _missing.contains(key)
                ? AppLocalizations.of(context)!.required
                : null,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTokens.rSm)),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isMe = _u?['id'] == ref.watch(userPermissionsProvider).id;
    ref.watch(householdsListProvider);
    final knownHousehold = _households.any((h) => h['id'] == _householdId);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sheetTitle(context, _isNew ? l.createUserTitle : l.editUserTitle),
          if (!_isNew)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(children: [
                UserAvatar(
                  userId: _u!['id']?.toString(),
                  name: userDisplayName(_u!),
                  radius: 30,
                  cacheKey: _u!['cacheKey']?.toString(),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: _uploadingImage ? null : _changeImage,
                      icon: _uploadingImage
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.photo_camera_rounded, size: 18),
                      label: Text(l.changeProfileImage),
                    ),
                  ),
                ),
              ]),
            ),
          Flexible(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _field(_fullName, l.fullNameLabel, 'fullName'),
                  _field(_username, l.usernameLabel, 'username'),
                  _field(_email, l.emailLabel, 'email',
                      type: TextInputType.emailAddress),
                  if (_isNew)
                    _field(_password, l.passwordLabel, 'password',
                        obscure: true),
                  if (_households.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: DropdownButtonFormField<String>(
                        initialValue: knownHousehold ? _householdId : null,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l.householdLabel,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTokens.rSm)),
                        ),
                        items: [
                          for (final h in _households)
                            DropdownMenuItem(
                                value: h['id'].toString(),
                                child: Text(h['name']?.toString() ?? '')),
                        ],
                        onChanged: (v) => setState(() => _householdId = v),
                      ),
                    ),
                  _section(context, l.permissionsTitle),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.administratorLabel,
                        style: TextStyle(color: context.appFg, fontSize: 14)),
                    // Mealie verbietet, sich selbst zu degradieren.
                    subtitle: isMe
                        ? Text(l.noPermissionDemoteSelf,
                            style: TextStyle(
                                color: context.appFgSub, fontSize: 12))
                        : null,
                    value: _admin,
                    activeTrackColor: AppTokens.accent,
                    onChanged: isMe ? null : (v) => setState(() => _admin = v),
                  ),
                  _PermissionSwitches(
                    values: _perms,
                    onChanged: (e) => setState(() => _perms[e.key] = e.value),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.advancedFeaturesLabel,
                        style: TextStyle(color: context.appFg, fontSize: 14)),
                    value: _advanced,
                    activeTrackColor: AppTokens.accent,
                    onChanged: (v) => setState(() => _advanced = v),
                  ),
                  if (!_isNew) ...[
                    const SizedBox(height: 8),
                    if (isMe && usesMealiePassword(_u!))
                      OutlinedButton.icon(
                        onPressed: _saving
                            ? null
                            : () => showChangePasswordSheet(context),
                        icon: const Icon(Icons.password_rounded),
                        label: Text(l.changePasswordAction),
                      )
                    else
                      OutlinedButton.icon(
                        onPressed: _saving ? null : _resetLink,
                        icon: const Icon(Icons.key_rounded),
                        label: Text(l.passwordResetLinkAction),
                      ),
                    if (!isMe)
                      TextButton.icon(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.red),
                        onPressed: _saving ? null : _delete,
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: Text(l.delete),
                      ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: AppTokens.accent,
                padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : Text(_isNew ? l.createUserTitle : l.save),
          ),
        ],
      ),
    );
  }
}

// ── Eigenes Konto (jeder Benutzer) ───────────────────────────────────────

/// Passwort ändern geht nur bei Mealie-eigener Anmeldung — LDAP lehnt der
/// Server ab, bei OIDC gibt es kein Mealie-Passwort (wie in der Webapp).
bool usesMealiePassword(Map<String, dynamic> user) {
  final m = user['authMethod']?.toString();
  return m == null || m.isEmpty || m.toLowerCase() == 'mealie';
}

class _SelfSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> user;
  const _SelfSheet({required this.user});

  @override
  ConsumerState<_SelfSheet> createState() => _SelfSheetState();
}

class _SelfSheetState extends ConsumerState<_SelfSheet> {
  Map<String, dynamic> get _u => widget.user;
  late final _fullName =
      TextEditingController(text: (_u['fullName'] as String?) ?? '');
  late final _username =
      TextEditingController(text: (_u['username'] as String?) ?? '');
  late final _email =
      TextEditingController(text: (_u['email'] as String?) ?? '');
  bool _saving = false;
  bool _uploadingImage = false;
  final Set<String> _missing = {};

  @override
  void dispose() {
    for (final c in [_fullName, _username, _email]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    _missing.clear();
    if (_fullName.text.trim().isEmpty) _missing.add('fullName');
    if (_username.text.trim().isEmpty) _missing.add('username');
    if (_email.text.trim().isEmpty) _missing.add('email');
    if (_missing.isNotEmpty) {
      setState(() {});
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(usersProvider.notifier).saveSelf({
        'fullName': _fullName.text.trim(),
        'username': _username.text.trim(),
        'email': _email.text.trim(),
      });
      nav.pop();
      messenger.showSnackBar(SnackBar(content: Text(l.userUpdated)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
          SnackBar(content: Text(mealieErrorMessage(e) ?? l.saveFailed)));
    }
  }

  Future<void> _changeImage() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final file = await pickPhotoWithSource(context);
    if (file == null || !mounted) return;
    setState(() => _uploadingImage = true);
    try {
      await ref
          .read(apiServiceProvider)
          .uploadUserImage(_u['id'] as String, await file.readAsBytes());
      ref.read(avatarRevisionProvider.notifier).state++;
      messenger.showSnackBar(SnackBar(content: Text(l.profileImageUpdated)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(
          content: Text(mealieErrorMessage(e) ?? l.profileImageFailed)));
    } finally {
      if (mounted) setState(() => _uploadingImage = false);
    }
  }

  Widget _field(TextEditingController c, String label, String key,
          {TextInputType? type}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          keyboardType: type,
          autocorrect: false,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            labelText: label,
            errorText: _missing.contains(key)
                ? AppLocalizations.of(context)!.required
                : null,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTokens.rSm)),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final canChangePassword = usesMealiePassword(_u);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sheetTitle(context, l.myAccountTitle),
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(children: [
              UserAvatar(
                userId: _u['id']?.toString(),
                name: userDisplayName(_u),
                radius: 30,
                cacheKey: _u['cacheKey']?.toString(),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: _uploadingImage ? null : _changeImage,
                    icon: _uploadingImage
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.photo_camera_rounded, size: 18),
                    label: Text(l.changeProfileImage),
                  ),
                ),
              ),
            ]),
          ),
          Flexible(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _field(_fullName, l.fullNameLabel, 'fullName'),
                  _field(_username, l.usernameLabel, 'username'),
                  _field(_email, l.emailLabel, 'email',
                      type: TextInputType.emailAddress),
                  if (canChangePassword)
                    OutlinedButton.icon(
                      onPressed: _saving
                          ? null
                          : () => showChangePasswordSheet(context),
                      icon: const Icon(Icons.password_rounded),
                      label: Text(l.changePasswordAction),
                    )
                  else
                    Text(
                        l.passwordManagedExternally(
                            _u['authMethod']?.toString() ?? ''),
                        style:
                            TextStyle(color: context.appFgSub, fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: AppTokens.accent,
                padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : Text(l.save),
          ),
        ],
      ),
    );
  }
}

Future<void> showChangePasswordSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.appCard,
      builder: (_) => const _ChangePasswordSheet(),
    );

/// Wie Profil → Passwort ändern in der Webapp: aktuelles + neues Passwort
/// (mind. 8 Zeichen, von Mealie vorgegeben) + Bestätigung.
class _ChangePasswordSheet extends ConsumerStatefulWidget {
  const _ChangePasswordSheet();

  @override
  ConsumerState<_ChangePasswordSheet> createState() =>
      _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends ConsumerState<_ChangePasswordSheet> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  final Map<String, String> _errors = {};
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_current, _next, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    _errors.clear();
    if (_current.text.isEmpty) _errors['current'] = l.required;
    if (_next.text.length < 8) _errors['next'] = l.passwordTooShort;
    if (_confirm.text != _next.text) _errors['confirm'] = l.passwordsDoNotMatch;
    if (_errors.isNotEmpty) {
      setState(() {});
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(apiServiceProvider)
          .changeOwnPassword(_current.text, _next.text);
      nav.pop();
      messenger.showSnackBar(SnackBar(content: Text(l.passwordUpdated)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(
          content: Text(mealieErrorMessage(e) ?? l.passwordChangeFailed)));
    }
  }

  Widget _field(TextEditingController c, String label, String key) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            labelText: label,
            errorText: _errors[key],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTokens.rSm)),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sheetTitle(context, l.changePasswordAction),
          _field(_current, l.currentPasswordLabel, 'current'),
          _field(_next, l.newPasswordLabel, 'next'),
          _field(_confirm, l.confirmPasswordLabel, 'confirm'),
          const SizedBox(height: 8),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: AppTokens.accent,
                padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: _saving ? null : _submit,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : Text(l.changePasswordAction),
          ),
        ],
      ),
    );
  }
}

// ── „Verwalten" (kein Admin): Berechtigungen eines Mitglieds ─────────────

class _PermissionsSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> user;
  const _PermissionsSheet({required this.user});

  @override
  ConsumerState<_PermissionsSheet> createState() => _PermissionsSheetState();
}

class _PermissionsSheetState extends ConsumerState<_PermissionsSheet> {
  late final Map<String, bool> _perms = {
    for (final k in [
      'canInvite',
      'canManage',
      'canManageHousehold',
      'canOrganize'
    ])
      k: widget.user[k] == true,
  };
  bool _saving = false;

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    setState(() => _saving = true);
    try {
      await ref.read(usersProvider.notifier).setPermissions(
            widget.user['id'] as String,
            canManageHousehold: _perms['canManageHousehold']!,
            canManage: _perms['canManage']!,
            canInvite: _perms['canInvite']!,
            canOrganize: _perms['canOrganize']!,
          );
      nav.pop();
      messenger.showSnackBar(SnackBar(content: Text(l.userUpdated)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
          SnackBar(content: Text(mealieErrorMessage(e) ?? l.saveFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sheetTitle(context, userDisplayName(widget.user)),
          _section(context, l.permissionsTitle),
          _PermissionSwitches(
            values: _perms,
            onChanged: (e) => setState(() => _perms[e.key] = e.value),
          ),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: AppTokens.accent,
                padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: _saving ? null : _save,
            child: Text(l.save),
          ),
        ],
      ),
    );
  }
}

// ── Einladen ─────────────────────────────────────────────────────────────

class _InviteSheet extends ConsumerStatefulWidget {
  const _InviteSheet();

  @override
  ConsumerState<_InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends ConsumerState<_InviteSheet> {
  final _uses = TextEditingController(text: '1');
  final _email = TextEditingController();
  String? _link;
  String? _token;
  bool _busy = false;

  @override
  void dispose() {
    _uses.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final uses = int.tryParse(_uses.text.trim()) ?? 1;
      final token = await ref
          .read(apiServiceProvider)
          .createInviteToken(uses: uses < 1 ? 1 : uses);
      final server = ref.read(settingsProvider).valueOrNull?.serverUrl ?? '';
      setState(() {
        _token = token;
        _link = '$server/register?token=$token';
      });
      messenger.showSnackBar(SnackBar(content: Text(l.inviteCreated)));
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(mealieErrorMessage(e) ?? l.createFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sendEmail() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final email = _email.text.trim();
    if (email.isEmpty || _token == null) return;
    setState(() => _busy = true);
    try {
      final ok =
          await ref.read(apiServiceProvider).sendInviteEmail(email, _token!);
      messenger.showSnackBar(SnackBar(
          content: Text(ok ? l.inviteEmailSent : l.inviteEmailFailed)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(l.inviteEmailFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sheetTitle(context, l.inviteAction),
            if (_link == null) ...[
              TextField(
                controller: _uses,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l.inviteUsesLabel,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTokens.rSm)),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: AppTokens.accent,
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: _busy ? null : _create,
                icon: const Icon(Icons.link_rounded),
                label: Text(l.inviteLinkTitle),
              ),
            ] else ...[
              _section(context, l.inviteLinkTitle),
              SelectableText(_link!,
                  style: TextStyle(color: context.appFg, fontSize: 13)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        Clipboard.setData(ClipboardData(text: _link!)),
                    icon: const Icon(Icons.copy_rounded),
                    label: Text(l.copyLinkAction),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Share.share(_link!),
                    icon: const Icon(Icons.ios_share_rounded),
                    label: Text(l.assetsShare),
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: l.inviteEmailHint,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTokens.rSm)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send_rounded),
                    tooltip: l.send,
                    onPressed: _busy ? null : _sendEmail,
                  ),
                ),
                onSubmitted: (_) => _sendEmail(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
