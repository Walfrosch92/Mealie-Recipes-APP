import 'package:bonsoir/bonsoir.dart';

// ---------------------------------------------------------------------------
// Ziel-Adresse eines per mDNS gefundenen Geräts (Kochen mit Freunden,
// Senden an). bonsoir liefert seit 7.x ALLE Adressen eines Dienstes statt
// nur einer. IPv4 zuerst: IPv6-Link-Local-Adressen (fe80::) brauchen eine
// Scope-ID, die Dart-Sockets nicht mitbekommen, und scheitern sonst beim
// Verbinden. Ohne IPv4 die erste IPv6-Adresse.
// ---------------------------------------------------------------------------

String? preferredHostAddress(BonsoirService service) =>
    pickHostAddress(service.hostAddresses);

String? pickHostAddress(List<String> addresses) {
  final usable = [
    for (final a in addresses)
      if (a.trim().isNotEmpty) a.trim(),
  ];
  for (final a in usable) {
    if (!a.contains(':')) return a;
  }
  for (final a in usable) {
    if (!a.toLowerCase().startsWith('fe80')) return a;
  }
  return usable.firstOrNull;
}
