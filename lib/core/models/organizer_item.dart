// ---------------------------------------------------------------------------
// Mealie-„Organizer": Kategorien, Schlagworte und Utensilien. Alle drei
// laufen serverseitig über dieselbe Schnittstelle `/api/organizers/<pfad>`
// (Liste, Anlegen, Umbenennen per PUT, Löschen) — deshalb EIN Modell und EIN
// Verwaltungs-Bildschirm statt drei Kopien.
// ---------------------------------------------------------------------------

enum OrganizerKind {
  category('categories'),
  tag('tags'),
  tool('tools');

  const OrganizerKind(this.path);

  /// Pfadsegment in `/api/organizers/<path>` — zugleich Route und Cache-Key.
  final String path;

  static OrganizerKind? fromPath(String? path) {
    for (final k in values) {
      if (k.path == path) return k;
    }
    return null;
  }
}

class OrganizerItem {
  final String id;
  final String name;
  final String slug;

  /// Nur Utensilien: Slugs der Haushalte, die das Utensil besitzen (Mealie
  /// „vorhanden"). Muss beim Umbenennen UNVERÄNDERT zurückgeschickt werden —
  /// sonst verlören andere Haushalte ihren Vorhanden-Status.
  final List<String> householdsWithTool;

  const OrganizerItem({
    required this.id,
    required this.name,
    required this.slug,
    this.householdsWithTool = const [],
  });

  factory OrganizerItem.fromJson(Map<String, dynamic> json) => OrganizerItem(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        slug: json['slug']?.toString() ?? '',
        householdsWithTool: (json['householdsWithTool'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'householdsWithTool': householdsWithTool,
      };

  OrganizerItem copyWith({String? name, List<String>? householdsWithTool}) =>
      OrganizerItem(
        id: id,
        name: name ?? this.name,
        slug: slug,
        householdsWithTool: householdsWithTool ?? this.householdsWithTool,
      );
}
