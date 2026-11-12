import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/accounts/saved_account.dart';
import '../../../core/api/api_service.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/sync_now.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../users/providers/users_provider.dart' show userDisplayName;
import '../services/account_switcher.dart';

// ---------------------------------------------------------------------------
// Start-Tab als Konto-Knopf: statt des Haus-Symbols das (kleine, runde)
// Profilbild des angemeldeten Benutzers. Erster Tipp → Start (wie bisher),
// Tipp auf den schon aktiven Tab → kleines Konto-Menü: Benutzerverwaltung
// (Admin) bzw. eigenes Konto, Abmelden / Benutzer wechseln.
// ---------------------------------------------------------------------------

/// Symbol des Start-Tabs: Profilbild, ohne Benutzer (Gastmodus, noch nicht
/// geladen) das Haus-Symbol.
class AccountTabIcon extends ConsumerWidget {
  final bool active;
  const AccountTabIcon({super.key, required this.active});

  static const double _size = 25;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final id = user?['id']?.toString();
    if (user == null || id == null || id.isEmpty) {
      return Icon(Icons.home_rounded,
          size: 21, color: active ? AppTokens.accent : context.appFgTertiary);
    }
    // Bild reicht bis an den Ring — kein Zwischenraum in Hintergrundfarbe.
    const outer = _size + 4;
    final ring = active ? 2.0 : 1.0;
    return Container(
      width: outer,
      height: outer,
      padding: EdgeInsets.all(ring),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Aktiv: Ring im App-Verlauf (wie die eingefärbten Tab-Symbole).
        gradient: active ? AppTokens.accentGradient : null,
        color: active ? null : context.appFgTertiary.withValues(alpha: 0.5),
      ),
      child: UserAvatar(
        userId: id,
        name: userDisplayName(user),
        radius: (outer - 2 * ring) / 2,
        highlight: true,
        cacheKey: user['cacheKey']?.toString(),
      ),
    );
  }
}

/// Konto-Menü über dem Start-Tab ([anchor] = Kontext des Tabs).
///
/// Desktop-Seitenleiste: Sie liegt außerhalb des Navigators, darum ist dort
/// [anchor] der Navigator-Kontext und [positionFrom] der Knopf, an dem das
/// Menü ausgerichtet wird; [below] klappt es nach unten statt nach oben auf.
Future<void> showAccountMenu(BuildContext anchor, WidgetRef ref,
    {BuildContext? positionFrom, bool below = false}) async {
  final l = AppLocalizations.of(anchor)!;
  final settings = ref.read(settingsProvider).valueOrNull;
  final user = ref.read(currentUserProvider);
  final perms = ref.read(userPermissionsProvider);
  final configured = settings?.isConfigured ?? false;
  final box = (positionFrom ?? anchor).findRenderObject() as RenderBox?;
  final overlay = Navigator.of(anchor, rootNavigator: true)
      .overlay
      ?.context
      .findRenderObject() as RenderBox?;
  if (box == null || overlay == null) return;
  // Über globale Koordinaten: der Knopf muss kein Kind des Overlays sein.
  final topLeft =
      box.localToGlobal(Offset.zero) - overlay.localToGlobal(Offset.zero);
  final position = below
      // Seitenleiste: direkt unter dem Konto-Knopf.
      ? RelativeRect.fromLTRB(
          topLeft.dx + 8,
          topLeft.dy + box.size.height + 4,
          overlay.size.width - topLeft.dx - box.size.width,
          0,
        )
      // Menü klappt NACH OBEN über dem Tab auf (unten ist die Leiste).
      : RelativeRect.fromLTRB(
          topLeft.dx + 8,
          topLeft.dy - 8,
          overlay.size.width - topLeft.dx - box.size.width,
          overlay.size.height - topLeft.dy + 8,
        );

  ref.invalidate(savedAccountsProvider);
  final saved = await ref.read(savedAccountsProvider.future);
  if (!anchor.mounted) return;

  HapticFeedback.selectionClick();
  final name = user == null ? '' : userDisplayName(user);
  final sub = (user?['email'] ?? user?['username'])?.toString() ?? '';
  Widget row(Widget leading, String title, {String? subtitle}) => ListTile(
        contentPadding: EdgeInsets.zero,
        dense: subtitle != null,
        leading: leading,
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: subtitle == null
            ? null
            : Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      );

  final picked = await showMenu<String>(
    context: anchor,
    useRootNavigator: true,
    position: position,
    color: anchor.appCard,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTokens.rMd)),
    items: [
      if (name.isNotEmpty)
        PopupMenuItem<String>(
          enabled: false,
          // Profilbild links, daneben Name und Mailadresse.
          child: Row(
            children: [
              if ((user?['id']?.toString() ?? '').isNotEmpty) ...[
                UserAvatar(
                  userId: user!['id'].toString(),
                  name: name,
                  radius: 20,
                  highlight: true,
                  cacheKey: user['cacheKey']?.toString(),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: anchor.appFg,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                    if (sub.isNotEmpty && sub != name)
                      Text(sub,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: anchor.appFgSub, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      if (configured && user != null)
        perms.admin
            ? PopupMenuItem(
                value: 'users',
                child: row(const Icon(Icons.manage_accounts_rounded),
                    l.userManagementTitle))
            : PopupMenuItem(
                value: 'self',
                child: row(const Icon(Icons.person_rounded), l.myAccountTitle)),
      if (configured)
        PopupMenuItem(
          value: 'sync',
          child: row(const Icon(Icons.sync_rounded), l.syncNow),
        ),
      // Gespeicherte Konten: Tipp = wechseln (mit Entsperren).
      if (saved.accounts.isNotEmpty) const PopupMenuDivider(),
      for (final a in saved.accounts)
        PopupMenuItem(
          value: 'acct:${a.id}',
          child: row(SavedAccountAvatar(account: a, file: saved.avatarFor(a)),
              a.displayName,
              subtitle: a.serverLabel),
        ),
      const PopupMenuDivider(),
      PopupMenuItem(
        value: 'add',
        child: row(const Icon(Icons.person_add_alt_1_rounded),
            configured ? l.addAccount : l.switchUserTitle),
      ),
      if (configured)
        PopupMenuItem(
          value: 'logout',
          child: row(const Icon(Icons.logout_rounded), l.signOutRemoveTitle),
        ),
    ],
  );
  if (picked == null || !anchor.mounted) return;
  switch (picked) {
    case 'users':
      anchor.push('/users');
    case 'self':
      anchor.push('/users?self=1');
    case 'sync':
      await syncEverythingNow(anchor, ref);
    case 'add':
      await switchAccount(anchor, ref);
    case 'logout':
      await logoutAndRemove(anchor, ref);
    default:
      if (picked.startsWith('acct:')) {
        final id = picked.substring(5);
        final target = saved.accounts.where((a) => a.id == id).firstOrNull;
        if (target != null) await switchAccount(anchor, ref, target: target);
      }
  }
}

/// Kleines rundes Profilbild eines gespeicherten Kontos (letztes bekanntes
/// Bild, sonst Anfangsbuchstabe).
class SavedAccountAvatar extends StatelessWidget {
  const SavedAccountAvatar(
      {super.key, required this.account, this.file, this.radius = 16});
  final SavedAccount account;
  final File? file;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final initial = account.displayName.isEmpty
        ? '?'
        : account.displayName.characters.first.toUpperCase();
    final fallback = Container(
      width: radius * 2,
      height: radius * 2,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          shape: BoxShape.circle, gradient: AppTokens.accentGradient),
      child: Text(initial,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: radius * 0.85)),
    );
    final f = file;
    if (f == null) return fallback;
    return ClipOval(
      child: Image.file(f,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback),
    );
  }
}
