import 'package:flutter/material.dart';

import '../../core/api/api_service.dart';

// ---------------------------------------------------------------------------
// Auswahl-Karte „Token erstellen lassen" vs. „Ich habe bereits ein Token" —
// mirrors den Card+ListTile-Look der Sprach-/Exakt-Modus-Auswahl im Setup.
// Genutzt vom Setup-Screen (Erstverbindung) UND dem Token-Erneuern-Sheet der
// Einstellungen (Re-Login) — EIN Widget statt zwei fast identischer Kopien.
// ---------------------------------------------------------------------------

class AuthModeChoiceCard extends StatelessWidget {
  final AuthMode mode;
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AuthModeChoiceCard({
    super.key,
    required this.mode,
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      margin: EdgeInsets.zero,
      color: selected ? primary.withValues(alpha: 0.12) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            selected ? BorderSide(color: primary, width: 1.5) : BorderSide.none,
      ),
      child: ListTile(
        leading: Icon(icon, color: selected ? primary : null),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: selected ? Icon(Icons.check_circle, color: primary) : null,
        onTap: onTap,
      ),
    );
  }
}
