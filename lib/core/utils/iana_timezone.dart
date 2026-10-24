import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

// ---------------------------------------------------------------------------
// IANA-Zeitzone des Geräts (z. B. „Europe/Vienna") ohne nativen Kanal.
//
// Dart kennt nur Offset und Kürzel („MEZ"/„CEST"), Mealies Kalender-Feed
// braucht aber einen IANA-Namen. Gesucht wird eine Zone mit denselben
// Offsets wie das Gerät im Januar, im Juli und jetzt — damit stimmen auch
// Sommer-/Winterzeit-Wechsel. Welche von mehreren gleichwertigen Zonen
// (Wien/Berlin/Rom) es wird, ist für die Uhrzeiten der Termine egal.
// ---------------------------------------------------------------------------

String? _cached;

String? guessIanaTimeZone() {
  if (_cached != null) return _cached;
  if (tz.timeZoneDatabase.locations.isEmpty) tzdata.initializeTimeZones();

  final now = DateTime.now();
  final probes = [
    DateTime(now.year, 1, 15, 12),
    DateTime(now.year, 7, 15, 12),
    now,
  ];
  bool matches(tz.Location loc) => probes.every((d) =>
      loc.timeZone(d.millisecondsSinceEpoch).offset == d.timeZoneOffset);

  final abbr = now.timeZoneName;
  String? fallback;
  for (final loc in tz.timeZoneDatabase.locations.values) {
    final name = loc.name;
    // Nur echte Regionen (keine „Etc/GMT-2", „CET" o. ä.).
    if (!name.contains('/') || name.startsWith('Etc/')) continue;
    if (!matches(loc)) continue;
    // Gleiches Kürzel (z. B. „CEST") bevorzugen, sonst erste passende Zone.
    if (loc.timeZone(now.millisecondsSinceEpoch).abbreviation == abbr) {
      return _cached = name;
    }
    fallback ??= name;
  }
  return _cached = fallback;
}
