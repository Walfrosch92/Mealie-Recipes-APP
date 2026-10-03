// ---------------------------------------------------------------------------
// CookbookSummary — Mealie-Kochbuch (GET /api/households/cookbooks).
//
// Ein Kochbuch ist KEIN Organizer am Rezept (wie Kategorie/Tag), sondern eine
// serverseitig gespeicherte Query: `queryFilterString` wird opak an
// GET /api/recipes?queryFilter=… durchgereicht, der Server wertet ihn aus.
// Leerer Filter → Mealie liefert ALLE Rezepte (Webapp-Verhalten).
//
// fromJson/toJson bewusst von Hand statt json_serializable: das Modell ist
// klein und so hängt kein build_runner-Lauf an der Datei.
// ---------------------------------------------------------------------------

class CookbookSummary {
  final String id;
  final String name;
  final String? slug;
  final String? description;
  final String queryFilterString;
  final int position;
  final bool public;

  const CookbookSummary({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.queryFilterString = '',
    this.position = 0,
    this.public = false,
  });

  factory CookbookSummary.fromJson(Map<String, dynamic> json) {
    return CookbookSummary(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      queryFilterString: json['queryFilterString'] as String? ?? '',
      position: (json['position'] as num?)?.toInt() ?? 0,
      public: json['public'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'description': description,
        'queryFilterString': queryFilterString,
        'position': position,
        'public': public,
      };

  CookbookSummary copyWith({
    String? name,
    String? description,
    String? queryFilterString,
    bool? public,
  }) {
    return CookbookSummary(
      id: id,
      name: name ?? this.name,
      slug: slug,
      description: description ?? this.description,
      queryFilterString: queryFilterString ?? this.queryFilterString,
      position: position,
      public: public ?? this.public,
    );
  }
}
