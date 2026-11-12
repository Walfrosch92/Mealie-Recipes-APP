import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/platform_features.dart';

// ---------------------------------------------------------------------------
// Zweispalten-Ansicht der Desktop-Apps (Windows/macOS, Fenster ≥ 1100 px):
// Rezeptliste links + Rezept rechts, Essensplan + ziehbare Rezeptliste.
// ---------------------------------------------------------------------------

/// Ab dieser Fensterbreite zeigen Rezepte/Essensplan zwei Spalten.
const kTwoPaneMinWidth = 1100.0;

bool twoPaneAvailable(BuildContext context) =>
    PlatformFeatures.webAppTools &&
    MediaQuery.sizeOf(context).width >= kTwoPaneMinWidth;

/// Im Rezepte-Tab rechts angezeigtes Rezept (ID), `null` = keins.
final paneRecipeProvider = StateProvider<String?>((ref) => null);

/// Stellt Rezeptkarten in der linken Spalte um: Antippen zeigt das Rezept
/// rechts an, statt eine neue Seite zu öffnen.
class RecipePaneScope extends InheritedWidget {
  final void Function(String recipeId) onOpen;
  final String? selectedId;
  const RecipePaneScope({
    super.key,
    required this.onOpen,
    required this.selectedId,
    required super.child,
  });

  static RecipePaneScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RecipePaneScope>();

  @override
  bool updateShouldNotify(RecipePaneScope old) =>
      old.selectedId != selectedId || old.onOpen != onOpen;
}
