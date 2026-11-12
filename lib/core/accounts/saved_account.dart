// ---------------------------------------------------------------------------
// Ein auf diesem Gerät gespeichertes Mealie-Konto (Benutzer wechseln).
// Nur Anzeige- und Zuordnungsdaten — Token liegt im sicheren Speicher,
// alle übrigen Daten im Ablageordner des Kontos (AccountStorage).
// ---------------------------------------------------------------------------

class SavedAccount {
  /// Zufällige, stabile ID (Ordnername der Ablage).
  final String id;

  /// Eingetragene Server-Adresse (nicht die WLAN-Adresse).
  final String serverUrl;

  /// Mealie-Benutzer-ID — Schlüssel für „ist das dasselbe Konto?".
  final String userId;
  final String username;
  final String fullName;
  final String email;
  final bool admin;

  /// Darf mit Face ID / Fingerabdruck (Geräte-Entsperrung) zurückgewechselt
  /// werden? Ohne → Passwort bzw. Token nötig.
  final bool biometricAllowed;

  /// Token wurde per Login von der App erzeugt (sonst manuell eingetragen —
  /// dann gibt es evtl. kein Mealie-Passwort, z. B. OIDC).
  final bool hasGeneratedToken;

  /// Mealie `authMethod` ('Mealie', 'LDAP', 'OIDC').
  final String authMethod;

  final DateTime lastUsed;

  const SavedAccount({
    required this.id,
    required this.serverUrl,
    required this.userId,
    this.username = '',
    this.fullName = '',
    this.email = '',
    this.admin = false,
    this.biometricAllowed = false,
    this.hasGeneratedToken = false,
    this.authMethod = '',
    required this.lastUsed,
  });

  /// Anzeigename: voller Name > Benutzername > E-Mail.
  String get displayName => fullName.trim().isNotEmpty
      ? fullName.trim()
      : (username.trim().isNotEmpty ? username.trim() : email.trim());

  /// Server ohne Schema, für die Unterzeile.
  String get serverLabel => serverUrl.replaceFirst(RegExp(r'^https?://'), '');

  /// Passwort-Anmeldung sinnvoll? (Kein OIDC/LDAP-Konto.)
  bool get canUsePassword {
    final m = authMethod.toLowerCase();
    return m.isEmpty || m == 'mealie';
  }

  /// Selbes Konto auf demselben Server?
  bool matches(String server, String user) =>
      normalizeServer(server) == normalizeServer(serverUrl) && user == userId;

  static String normalizeServer(String s) =>
      s.trim().toLowerCase().replaceAll(RegExp(r'/+$'), '');

  SavedAccount copyWith({
    String? serverUrl,
    String? username,
    String? fullName,
    String? email,
    bool? admin,
    bool? biometricAllowed,
    bool? hasGeneratedToken,
    String? authMethod,
    DateTime? lastUsed,
  }) =>
      SavedAccount(
        id: id,
        serverUrl: serverUrl ?? this.serverUrl,
        userId: userId,
        username: username ?? this.username,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        admin: admin ?? this.admin,
        biometricAllowed: biometricAllowed ?? this.biometricAllowed,
        hasGeneratedToken: hasGeneratedToken ?? this.hasGeneratedToken,
        authMethod: authMethod ?? this.authMethod,
        lastUsed: lastUsed ?? this.lastUsed,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'serverUrl': serverUrl,
        'userId': userId,
        'username': username,
        'fullName': fullName,
        'email': email,
        'admin': admin,
        'biometricAllowed': biometricAllowed,
        'hasGeneratedToken': hasGeneratedToken,
        'authMethod': authMethod,
        'lastUsed': lastUsed.toIso8601String(),
      };

  static SavedAccount? fromJson(Map<String, dynamic> j) {
    final id = j['id']?.toString() ?? '';
    final userId = j['userId']?.toString() ?? '';
    if (id.isEmpty || userId.isEmpty) return null;
    return SavedAccount(
      id: id,
      serverUrl: j['serverUrl']?.toString() ?? '',
      userId: userId,
      username: j['username']?.toString() ?? '',
      fullName: j['fullName']?.toString() ?? '',
      email: j['email']?.toString() ?? '',
      admin: j['admin'] == true,
      biometricAllowed: j['biometricAllowed'] == true,
      hasGeneratedToken: j['hasGeneratedToken'] == true,
      authMethod: j['authMethod']?.toString() ?? '',
      lastUsed: DateTime.tryParse(j['lastUsed']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
