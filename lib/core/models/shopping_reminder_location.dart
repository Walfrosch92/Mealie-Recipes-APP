// ---------------------------------------------------------------------------
// ShoppingReminderLocation — ein gespeicherter Standort (z. B. Supermarkt)
// für die geofence-basierte "Erinnere mich zum Einkaufen"-Funktion
// (Settings > Einkaufsliste). Bis zu 3 Stück, siehe Issue #29.
//
// Kein JsonSerializable/Codegen nötig — einfaches manuelles (de)serialisieren
// wie schon bei AppSettings üblich.
// ---------------------------------------------------------------------------

class ShoppingReminderLocation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  const ShoppingReminderLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lat': latitude,
        'lng': longitude,
      };

  factory ShoppingReminderLocation.fromJson(Map<String, dynamic> json) =>
      ShoppingReminderLocation(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        latitude: (json['lat'] as num?)?.toDouble() ?? 0,
        longitude: (json['lng'] as num?)?.toDouble() ?? 0,
      );
}
