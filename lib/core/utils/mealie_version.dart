import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cached_json_list.dart';

/// Mealie-Version „v3.28.0" / „3.28.0-beta" → (3, 28); unbekannt → null.
(int, int)? parseMealieVersion(String? v) {
  final m = RegExp(r'(\d+)\.(\d+)').firstMatch(v ?? '');
  if (m == null) return null;
  return (int.parse(m.group(1)!), int.parse(m.group(2)!));
}

/// Ist [version] mindestens [major].[minor]? Unbekannt → false.
bool mealieVersionAtLeast(String? version, int major, int minor) {
  final v = parseMealieVersion(version);
  if (v == null) return false;
  return v.$1 > major || (v.$1 == major && v.$2 >= minor);
}

/// Version des verbundenen Servers (aus /api/app/about, cache-first).
final serverVersionProvider = Provider<String?>((ref) {
  final info = ref.watch(serverInfoProvider).valueOrNull;
  if (info == null || info.isEmpty) return null;
  return info.first['version']?.toString();
});

/// Mealie ≥ 3.29: Mahlzeitplan-Portionen (`recipeScale`), Kalender-Abo
/// (iCal), Zeit-Filter (`total_time_seconds`), Video-/Audio-Anhänge.
final mealie329Provider = Provider<bool>(
    (ref) => mealieVersionAtLeast(ref.watch(serverVersionProvider), 3, 29));
