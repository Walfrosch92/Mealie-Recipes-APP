import '../../features/recipes/providers/user_ratings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../features/mealplan/providers/mealplan_provider.dart';
import '../../features/recipes/providers/favorites_provider.dart';
import '../../features/recipes/providers/recipes_provider.dart';
import '../../features/shopping_list/providers/foods_units_provider.dart';
import '../../features/shopping_list/providers/shopping_list_provider.dart';
import '../api/api_service.dart';

/// „Jetzt synchronisieren" (Konto-Menü am Start-Tab): alle Rezepte neu inkl.
/// Bild-Cache, dazu Essensplan, Favoriten, Einkaufsliste und Kataloge frisch
/// vom Server. Bewusst nur als Menüpunkt, nie als Geste — ein Voll-Abgleich
/// kostet eine Anfrage pro Rezept.
Future<void> syncEverythingNow(BuildContext context, WidgetRef ref) async {
  final l = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  HapticFeedback.mediumImpact();
  messenger.showSnackBar(SnackBar(content: Text(l.syncStarted)));
  ref.invalidate(mealplanProvider);
  ref.invalidate(favoritesProvider);
  ref.invalidate(userRatingsProvider);
  ref.invalidate(shoppingListProvider);
  ref.invalidate(shoppingLabelsProvider);
  ref.invalidate(foodsCatalogProvider);
  ref.invalidate(unitsCatalogProvider);
  ref.invalidate(currentUserProvider);
  await ref.read(recipesProvider.notifier).forceFullSync();
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(l.syncDone)));
}
