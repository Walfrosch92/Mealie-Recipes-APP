import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_service.dart';
import '../models/recipe_detail.dart';

// ---------------------------------------------------------------------------
// Rechte des angemeldeten Nutzers — gespiegelt aus Mealies Server-Regeln
// (mealie/routes/_base/checks.py, services/recipe/recipe_service.py), damit
// die App Knöpfe passend anbietet statt erst beim Server zu scheitern.
//
// Der Server bleibt die Instanz: wo die App etwas nicht sicher wissen kann
// (Bearbeiten von Rezepten eines ANDEREN Haushalts hängt von dessen
// Einstellung ab), bietet sie die Aktion an und zeigt bei Ablehnung eine
// verständliche Meldung (siehe mealieErrorMessage / 403).
// ---------------------------------------------------------------------------

class UserPermissions {
  final String? id;
  final String? householdId;
  final bool admin;
  final bool canOrganize;
  final bool canManage;
  final bool canManageHousehold;
  final bool canInvite;

  /// false = Nutzer (noch) unbekannt (offline ohne Cache) → nichts sperren.
  final bool known;

  const UserPermissions({
    this.id,
    this.householdId,
    this.admin = false,
    this.canOrganize = false,
    this.canManage = false,
    this.canManageHousehold = false,
    this.canInvite = false,
    this.known = false,
  });

  factory UserPermissions.fromUser(Map<String, dynamic>? me) {
    if (me == null || me['id'] == null) return const UserPermissions();
    bool b(String k) => me[k] == true;
    return UserPermissions(
      id: me['id'].toString(),
      householdId: me['householdId']?.toString(),
      admin: b('admin'),
      canOrganize: b('canOrganize'),
      canManage: b('canManage'),
      canManageHousehold: b('canManageHousehold'),
      canInvite: b('canInvite'),
      known: true,
    );
  }

  /// Kategorien, Schlagworte und Lebensmittel anlegen/ändern/löschen
  /// (Mealie `can_organize`; Admins dürfen alles).
  bool get mayOrganize => !known || admin || canOrganize;

  /// Benutzerverwaltung sichtbar: Admin (alle Nutzer), Verwalten (Rechte
  /// im Haushalt) oder Einladen.
  bool get mayManageUsers => known && (admin || canManage || canInvite);
}

final userPermissionsProvider = Provider<UserPermissions>(
    (ref) => UserPermissions.fromUser(ref.watch(currentUserProvider)));

/// Darf der Nutzer das Rezept bearbeiten? (wie RecipeService.can_update)
/// Admin/Ersteller immer; gesperrte Rezepte nur Ersteller/Admin. Rezepte
/// eines anderen Haushalts: hängt von dessen Einstellung ab → erlaubt
/// (Server entscheidet). Unbekannter Ersteller (alter Cache) → erlaubt.
enum RecipeEditAccess { allowed, locked }

RecipeEditAccess recipeEditAccess(UserPermissions p, RecipeDetail r) {
  if (!p.known || p.admin || r.userId == null || r.userId == p.id) {
    return RecipeEditAccess.allowed;
  }
  if (r.settings?.locked ?? false) return RecipeEditAccess.locked;
  return RecipeEditAccess.allowed;
}

/// Löschen: nur Ersteller oder Admin (RecipeService.can_delete).
bool canDeleteRecipe(UserPermissions p, RecipeDetail r) =>
    !p.known || p.admin || r.userId == null || r.userId == p.id;
