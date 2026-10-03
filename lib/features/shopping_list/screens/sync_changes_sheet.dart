import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/shopping_item.dart';
import '../../../core/utils/ingredient_display.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/async_action_button.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../providers/pending_changes_provider.dart';
import '../providers/shopping_list_provider.dart';

// ---------------------------------------------------------------------------
// SyncChangesSheet — Port von Swift SyncChangesView, im Premium-Design.
//
// Wird als fullscreen-Modal aufgerufen, sobald shoppingSyncTriggerProvider
// hochzählt UND pending changes vorhanden sind. Pro Sektion eine Liste der
// Konflikte; pro Konflikt ein Toggle: links = lokale Änderung, rechts =
// Server-Stand. Im Default ist „lokal" aktiv (mirrors Swift `?? true`).
// "Jetzt synchronisieren" (unten, AsyncActionButton) ruft
// ShoppingListNotifier.syncPendingChangesToServer mit den ausgewählten Seiten
// auf und schliesst das Sheet.
// ---------------------------------------------------------------------------

class SyncChangesSheet extends ConsumerStatefulWidget {
  const SyncChangesSheet({super.key});

  @override
  ConsumerState<SyncChangesSheet> createState() => _SyncChangesSheetState();
}

class _SyncChangesSheetState extends ConsumerState<SyncChangesSheet> {
  final Map<String, bool> _useLocalCheck = {};
  final Map<String, bool> _useLocalQuantity = {};
  final Map<String, bool> _useLocalCategory = {};
  bool _syncing = false;

  bool _useLocal(Map<String, bool> map, String id) => map[id] ?? true;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final pending = ref.watch(pendingShoppingChangesProvider);
    final local = ref.watch(shoppingListProvider).valueOrNull ?? const [];
    final server = ref.watch(shoppingServerSnapshotProvider);
    final labels = ref.watch(shoppingLabelsProvider).valueOrNull ?? const [];

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        backgroundColor: context.appBg,
        surfaceTintColor: Colors.transparent,
        title: Text(l.syncChangesTitle),
        leading: TextButton(
          onPressed: _syncing ? null : () => Navigator.pop(context),
          child: Text(l.cancel,
              style: TextStyle(
                  color:
                      _syncing ? context.appFgTertiary : AppTokens.accentDeep,
                  fontWeight: FontWeight.w600)),
        ),
        leadingWidth: 100,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                children: [
                  if (pending.checks.isNotEmpty)
                    _Section(
                      title: l.syncSectionChecked,
                      children: pending.checks.map((c) {
                        final localItem = _findItem(local, c.itemId);
                        final serverItem = _findItem(server, c.itemId);
                        if (localItem == null || serverItem == null) {
                          return const SizedBox.shrink();
                        }
                        return _ConflictRow(
                          title: localItem.displayName,
                          localValue: c.checked ? '✓' : '○',
                          serverValue: serverItem.checked ? '✓' : '○',
                          useLocal: _useLocal(_useLocalCheck, c.itemId),
                          onChanged: (v) =>
                              setState(() => _useLocalCheck[c.itemId] = v),
                          localLabel: l.syncLocalLabel,
                          serverLabel: l.syncServerLabel,
                        );
                      }).toList(),
                    ),
                  if (pending.quantities.isNotEmpty)
                    _Section(
                      title: l.syncSectionQuantity,
                      children: pending.quantities.map((c) {
                        final localItem = _findItem(local, c.itemId);
                        final serverItem = _findItem(server, c.itemId);
                        if (localItem == null || serverItem == null) {
                          return const SizedBox.shrink();
                        }
                        return _ConflictRow(
                          title: localItem.displayName,
                          localValue: formatQuantity(c.quantity),
                          serverValue: formatQuantity(serverItem.quantity ?? 1),
                          useLocal: _useLocal(_useLocalQuantity, c.itemId),
                          onChanged: (v) =>
                              setState(() => _useLocalQuantity[c.itemId] = v),
                          localLabel: l.syncLocalLabel,
                          serverLabel: l.syncServerLabel,
                        );
                      }).toList(),
                    ),
                  if (pending.categories.isNotEmpty)
                    _Section(
                      title: l.syncSectionCategory,
                      children: pending.categories.map((c) {
                        final localItem = _findItem(local, c.itemId);
                        final serverItem = _findItem(server, c.itemId);
                        if (localItem == null || serverItem == null) {
                          return const SizedBox.shrink();
                        }
                        final localName = labels
                            .firstWhere(
                              (lab) => lab.id == c.labelId,
                              orElse: () =>
                                  const ShoppingLabel(id: '', name: '—'),
                            )
                            .name;
                        final serverName = labels
                            .firstWhere(
                              (lab) => lab.id == serverItem.label?.id,
                              orElse: () =>
                                  const ShoppingLabel(id: '', name: '—'),
                            )
                            .name;
                        return _ConflictRow(
                          title: localItem.displayName,
                          localValue: localName,
                          serverValue: serverName,
                          useLocal: _useLocal(_useLocalCategory, c.itemId),
                          onChanged: (v) =>
                              setState(() => _useLocalCategory[c.itemId] = v),
                          localLabel: l.syncLocalLabel,
                          serverLabel: l.syncServerLabel,
                        );
                      }).toList(),
                    ),
                  if (pending.adds.isNotEmpty)
                    _Section(
                      title: l.syncSectionAdditions,
                      children: pending.adds.map((a) {
                        final labelName = a.labelId == null
                            ? null
                            : labels
                                .firstWhere(
                                  (lab) => lab.id == a.labelId,
                                  orElse: () =>
                                      const ShoppingLabel(id: '', name: '—'),
                                )
                                .name;
                        return _AddRow(note: a.note, labelName: labelName);
                      }).toList(),
                    ),
                ],
              ),
            ),
            // „Jetzt synchronisieren" unten (AsyncActionButton mit Inline-
            // Spinner). SafeArea(top:false) konsumiert den System-Inset bereits.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: AsyncActionButton(
                expand: true,
                icon: Icons.sync_rounded,
                label: l.syncNow,
                onPressed: () => _runSync(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ShoppingItem? _findItem(List<ShoppingItem> list, String id) {
    for (final i in list) {
      if (i.id == id) return i;
    }
    return null;
  }

  Future<void> _runSync(BuildContext context) async {
    setState(() => _syncing = true);
    try {
      await ref.read(shoppingListProvider.notifier).syncPendingChangesToServer(
            selectedCheckChanges: Map<String, bool>.from(_useLocalCheck),
            selectedQuantityChanges: Map<String, bool>.from(_useLocalQuantity),
            selectedCategoryChanges: Map<String, bool>.from(_useLocalCategory),
          );
      if (context.mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }
}

// ---------------------------------------------------------------------------
// Section & ConflictRow — mirrors iOS SyncChangesView Section + SyncConflict-
// ComparisonRow. Toggle-Semantik exakt wie Swift: links=local, rechts=server,
// `useLocal: Bool` Binding (Toggle ist invertiert: rechte Seite → !useLocal).
// ---------------------------------------------------------------------------

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
            child: Text(title,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3)),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _ConflictRow extends StatelessWidget {
  final String title;
  final String localValue;
  final String serverValue;
  final bool useLocal;
  final ValueChanged<bool> onChanged;
  final String localLabel;
  final String serverLabel;

  const _ConflictRow({
    required this.title,
    required this.localValue,
    required this.serverValue,
    required this.useLocal,
    required this.onChanged,
    required this.localLabel,
    required this.serverLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: context.appFg,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _SidePill(
                    label: localLabel,
                    value: localValue,
                    active: useLocal,
                    alignEnd: false,
                  ),
                ),
                Switch.adaptive(
                  // Switch: false=links/local, true=rechts/server
                  value: !useLocal,
                  onChanged: (v) => onChanged(!v),
                  activeThumbColor: AppTokens.accent,
                ),
                Expanded(
                  child: _SidePill(
                    label: serverLabel,
                    value: serverValue,
                    active: !useLocal,
                    alignEnd: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Eine Seite (lokal/Server) des Konflikts: aktive Seite wird mit Akzent
// hervorgehoben, die inaktive gedämpft.
class _SidePill extends StatelessWidget {
  final String label;
  final String value;
  final bool active;
  final bool alignEnd;

  const _SidePill({
    required this.label,
    required this.value,
    required this.active,
    required this.alignEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: context.appFgSub, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value,
            textAlign: alignEnd ? TextAlign.end : TextAlign.start,
            style: TextStyle(
                color: active ? AppTokens.accentDeep : context.appFgTertiary,
                fontSize: 15,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600)),
      ],
    );
  }
}

// Neu-hinzugefügter Artikel (keine Konfliktseite) als Karte mit Akzent-Badge.
class _AddRow extends StatelessWidget {
  final String note;
  final String? labelName;
  const _AddRow({required this.note, required this.labelName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: AppTokens.accentGradient,
                boxShadow: context.appAccentGlow,
              ),
              child:
                  const Icon(Icons.add_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note,
                      style: TextStyle(
                          color: context.appFg, fontWeight: FontWeight.w700)),
                  if (labelName != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(labelName!,
                          style:
                              TextStyle(color: context.appFgSub, fontSize: 12)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
