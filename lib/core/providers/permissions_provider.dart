import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_service.dart';
import '../models/recipe_detail.dart';
import 'cached_json_list.dart';

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

  /// Haushalt-ID → „Bearbeitung von Rezepten aus anderen Haushalten
  /// sperren" (Mealie lock_recipe_edits_from_other_households, Standard an).
  /// null = (noch) nicht bekannt.
  final Map<String, bool>? householdLocksEdits;

  const UserPermissions({
    this.id,
    this.householdId,
    this.admin = false,
    this.canOrganize = false,
    this.canManage = false,
    this.canManageHousehold = false,
    this.canInvite = false,
    this.known = false,
    this.householdLocksEdits,
  });

  UserPermissions withHouseholds(List<Map<String, dynamic>>? households) {
    if (households == null) return this;
    final locks = <String, bool>{};
    for (final h in households) {
      final id = h['id']?.toString();
      final prefs = h['preferences'];
      if (id == null || prefs is! Map) continue;
      final v = prefs['lockRecipeEditsFromOtherHouseholds'];
      // Fehlt das Feld (ältere Mealie-Version ohne die Regel) → nicht sperren.
      locks[id] = v is bool ? v : false;
    }
    return UserPermissions(
      id: id,
      householdId: householdId,
      admin: admin,
      canOrganize: canOrganize,
      canManage: canManage,
      canManageHousehold: canManageHousehold,
      canInvite: canInvite,
      known: known,
      householdLocksEdits: locks,
    );
  }

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

final userPermissionsProvider = Provider<UserPermissions>((ref) =>
    UserPermissions.fromUser(ref.watch(currentUserProvider))
        .withHouseholds(ref.watch(householdsListProvider).valueOrNull));

/// Darf der Nutzer das Rezept bearbeiten? (wie RecipeService.can_update)
/// Admin/Ersteller immer; gesperrte Rezepte nur Ersteller/Admin; Rezepte
/// eines ANDEREN Haushalts nur, wenn dieser Haushalt die Bearbeitung von
/// außen erlaubt (lock_recipe_edits_from_other_households, über
/// /api/groups/households bekannt). Unbekannter Ersteller (alter Cache) oder
/// unbekannte Haushalts-Einstellung → erlaubt (der Server entscheidet).
enum RecipeEditAccess { allowed, locked, otherHousehold }

bool _isOtherHousehold(UserPermissions p, RecipeDetail r) =>
    r.householdId != null &&
    p.householdId != null &&
    r.householdId != p.householdId;

RecipeEditAccess recipeEditAccess(UserPermissions p, RecipeDetail r) {
  if (!p.known || p.admin || r.userId == null || r.userId == p.id) {
    return RecipeEditAccess.allowed;
  }
  if (r.settings?.locked ?? false) return RecipeEditAccess.locked;
  if (_isOtherHousehold(p, r) &&
      (p.householdLocksEdits?[r.householdId] ?? false)) {
    return RecipeEditAccess.otherHousehold;
  }
  return RecipeEditAccess.allowed;
}

/// Löschen: nur Ersteller oder Admin (RecipeService.can_delete).
bool canDeleteRecipe(UserPermissions p, RecipeDetail r) =>
    !p.known || p.admin || r.userId == null || r.userId == p.id;

/// Darf der Nutzer das Rezept SICHER bearbeiten? Wie [recipeEditAccess],
/// aber bei UNBEKANNTER Einstellung des fremden Haushalts vorsichtig
/// (Mealie-Standard: gesperrt). Für Abläufe, die vorher wissen müssen, ob
/// ein PATCH durchgeht (Duplikate zusammenführen).
bool canSurelyEditRecipe(UserPermissions p, RecipeDetail r) {
  if (!p.known || p.admin || r.userId == p.id) return true;
  if (recipeEditAccess(p, r) != RecipeEditAccess.allowed) return false;
  if (_isOtherHousehold(p, r)) {
    return p.householdLocksEdits?[r.householdId] == false;
  }
  return true;
}
