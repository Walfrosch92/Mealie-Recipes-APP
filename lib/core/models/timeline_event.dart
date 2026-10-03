// ---------------------------------------------------------------------------
// Mealie-Zeitleiste eines Rezepts (RecipeTimelineEventOut).
//
// Die Webapp legt beim „Ich hab's gekocht" einen Eintrag vom Typ `comment`
// mit dem Betreff „<Name> hat das gekocht" an, setzt `lastMade` und lädt ein
// optionales Foto per PUT …/events/{id}/image hoch. `system`-Einträge
// („Rezept erstellt") schreibt der Server selbst, `info` sind Hinweise.
// Das Foto liegt unter
//   /api/media/recipes/{recipeId}/images/timeline/{id}/{original|min-original|tiny-original}.webp
// ---------------------------------------------------------------------------

class TimelineEvent {
  final String id;
  final String recipeId;
  final String userId;
  final String subject;

  /// `comment`, `info` oder `system`.
  final String eventType;
  final String message;
  final bool hasImage;

  /// ISO-8601 wie vom Server (UTC, evtl. ohne Zonenangabe).
  final String timestamp;

  const TimelineEvent({
    required this.id,
    required this.recipeId,
    required this.userId,
    required this.subject,
    required this.eventType,
    required this.message,
    required this.hasImage,
    required this.timestamp,
  });

  static TimelineEvent? tryParse(dynamic raw) {
    if (raw is! Map) return null;
    final id = raw['id']?.toString();
    if (id == null || id.isEmpty) return null;
    return TimelineEvent(
      id: id,
      recipeId: raw['recipeId']?.toString() ?? '',
      userId: raw['userId']?.toString() ?? '',
      subject: raw['subject']?.toString() ?? '',
      eventType: raw['eventType']?.toString() ?? 'info',
      message: (raw['eventMessage'] ?? raw['message'])?.toString() ?? '',
      hasImage: raw['image']?.toString() == 'has image',
      timestamp: raw['timestamp']?.toString() ?? '',
    );
  }

  bool get isSystem => eventType == 'system';

  DateTime? get timestampLocal {
    if (timestamp.isEmpty) return null;
    final hasZone = timestamp.endsWith('Z') ||
        RegExp(r'[+-]\d\d:?\d\d$').hasMatch(timestamp);
    return DateTime.tryParse(hasZone ? timestamp : '${timestamp}Z')?.toLocal();
  }

  TimelineEvent copyWith({String? message, bool? hasImage}) => TimelineEvent(
        id: id,
        recipeId: recipeId,
        userId: userId,
        subject: subject,
        eventType: eventType,
        message: message ?? this.message,
        hasImage: hasImage ?? this.hasImage,
        timestamp: timestamp,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'recipeId': recipeId,
        'userId': userId,
        'subject': subject,
        'eventType': eventType,
        'eventMessage': message,
        'image': hasImage ? 'has image' : 'does not have image',
        'timestamp': timestamp,
      };
}
