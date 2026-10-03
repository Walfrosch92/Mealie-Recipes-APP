import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/settings_provider.dart';
import '../../core/utils/media_urls.dart';
import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Benutzer-Avatar: Mealie-Profilbild (/api/media/users/{id}/profile.webp),
// sonst — kein Bild hochgeladen (404) oder offline ohne Cache — der
// Anfangsbuchstabe wie bisher. Genutzt in Kommentaren, Zeitstrahl und
// Benutzerverwaltung.
// ---------------------------------------------------------------------------

/// Hochzählen nach einem Upload → alle Avatare laden ihr Bild neu (Mealie
/// liefert unter derselben URL das neue Bild).
final avatarRevisionProvider = StateProvider<int>((ref) => 0);

String userAvatarUrl(String serverUrl, String userId, {Object? rev}) =>
    '$serverUrl/api/media/users/$userId/profile.webp'
    '${rev == null ? '' : '?v=$rev'}';

class UserAvatar extends ConsumerWidget {
  final String? userId;
  final String name;
  final double radius;

  /// Eigener Benutzer: Platzhalter im App-Verlauf statt dezent getönt.
  final bool highlight;

  /// Mealie `cacheKey` des Benutzers (ändert sich beim Bild-Upload) — für
  /// frische Bilder, wenn andere ihr Bild geändert haben.
  final String? cacheKey;

  /// Eigener Platzhalter statt Anfangsbuchstabe (z. B. Zeitstrahl-Symbol).
  final Widget? fallback;

  const UserAvatar({
    super.key,
    required this.userId,
    required this.name,
    this.radius = 18,
    this.highlight = false,
    this.cacheKey,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).valueOrNull;
    final server = settings?.serverUrl ?? '';
    final rev = ref.watch(avatarRevisionProvider);
    final size = radius * 2;

    final placeholder = fallback ??
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: highlight ? AppTokens.accentGradient : null,
            color: highlight ? null : AppTokens.accent.withValues(alpha: 0.15),
          ),
          child: Text(
            name.trim().isEmpty
                ? '?'
                : name.trim().characters.first.toUpperCase(),
            style: TextStyle(
                color: highlight ? Colors.white : AppTokens.accentDeep,
                fontSize: radius * 0.85,
                fontWeight: FontWeight.w800),
          ),
        );
    final id = userId;
    if (id == null || id.isEmpty || server.isEmpty) return placeholder;

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: userAvatarUrl(server, id,
            rev: '${cacheKey ?? ''}$rev'.isEmpty
                ? null
                : '${cacheKey ?? ''}$rev'),
        httpHeaders: mediaHeaders(settings),
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, __) => placeholder,
        errorWidget: (_, __, ___) => placeholder,
      ),
    );
  }
}
