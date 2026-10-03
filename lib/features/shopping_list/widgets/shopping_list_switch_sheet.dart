import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart' show SheetHandle;
import '../providers/shopping_lists_provider.dart';

/// Aktive Einkaufsliste wechseln (⋮-Menü der Einkaufsliste) — dieselbe
/// Auswahl wie in den Einstellungen. Nur Wechseln; Verwalten geht über die
/// Home-Kachel „Einkaufslisten".
Future<void> showShoppingListSwitchSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: context.appCard,
      builder: (_) => const _SwitchSheet(),
    );

class _SwitchSheet extends ConsumerWidget {
  const _SwitchSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final async = ref.watch(shoppingListsProvider);
    final activeId =
        ref.watch(settingsProvider).valueOrNull?.shoppingListId ?? '';
    final lists = async.valueOrNull ?? const <Map<String, dynamic>>[];

    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SheetHandle(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(l.switchListTitle,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
          ),
          if (async.isLoading && lists.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (lists.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l.foodsUnitsEmpty,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.appFgSub)),
            )
          else
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  for (final m in lists)
                    ListTile(
                      leading: Icon(
                        m['id'] == activeId
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: m['id'] == activeId
                            ? AppTokens.accent
                            : context.appFgTertiary,
                      ),
                      title: Text(shoppingListName(m),
                          style: TextStyle(
                              color: context.appFg,
                              fontWeight: m['id'] == activeId
                                  ? FontWeight.w700
                                  : FontWeight.w500)),
                      onTap: () async {
                        HapticFeedback.selectionClick();
                        final nav = Navigator.of(context);
                        await ref
                            .read(shoppingListsProvider.notifier)
                            .select(m);
                        nav.pop();
                      },
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
