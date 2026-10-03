import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../cooking_mode/widgets/cooking_mode_fab.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/async_action_button.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../providers/shopping_list_provider.dart';
import '../services/task_import_models.dart';

// ---------------------------------------------------------------------------
// Generic task import screen — used by both Google Tasks (Android) and
// Apple Reminders (iOS). The caller injects:
//   • title       — AppBar title
//   • fetcher     — async function returning the lists
//   • emptyHint   — text shown when the fetcher returns no lists
//
// Premium-Design (warme Karten, Akzent-Verlauf, Auswahl-Rows mit Check-Kreis),
// 1:1 zu den übrigen redesignten Views (Rezept-Import, Cook-Friends …).
// ---------------------------------------------------------------------------

class TaskImportScreen extends ConsumerStatefulWidget {
  final String title;
  final Future<List<ImportTaskList>> Function() fetcher;
  final String emptyHint;

  /// Optionaler Hook für die Post-Import-Aktion. Wird mit der gewählten
  /// `TaskImportPostAction` und der Liste der importierten Items aufgerufen,
  /// NACHDEM diese in die Mealie-Shopping-List gespeichert wurden.
  /// Plattform-spezifische Implementierungen (Reminders / Google Tasks)
  /// reichen hier ihre complete/delete-Calls rein.
  final Future<void> Function(
      TaskImportPostAction action, List<ImportTaskItem> items)? onPostAction;

  const TaskImportScreen({
    super.key,
    required this.title,
    required this.fetcher,
    required this.emptyHint,
    this.onPostAction,
  });

  @override
  ConsumerState<TaskImportScreen> createState() => _TaskImportScreenState();
}

class _TaskImportScreenState extends ConsumerState<TaskImportScreen> {
  bool _loading = false;
  String? _error;
  List<ImportTaskList> _lists = [];
  final Set<String> _selectedItems = {};
  ImportTaskList? _selectedList;
  // Default „leave" wie in Swifts ReminderImportView — der User soll
  // explizit etwas anderes wählen müssen wenn er in der Quell-App
  // verändern lassen will.
  TaskImportPostAction _postAction = TaskImportPostAction.leave;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final lists = await widget.fetcher();
      setState(() {
        _lists = lists;
        if (lists.isNotEmpty) _selectedList = lists.first;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _import() async {
    if (_selectedList == null || _selectedItems.isEmpty) return;
    final items = _selectedList!.items
        .where((i) => _selectedItems.contains(i.id))
        .toList();
    // 1) Erst Mealie-seitig hinzufügen.
    for (final item in items) {
      await ref.read(shoppingListProvider.notifier).addItem(note: item.title);
    }
    // 2) Optional die Nach-Import-Aktion in der Quell-App (Reminders /
    //    Google Tasks). Spiegelt Swifts switch postAction { ... }.
    if (_postAction != TaskImportPostAction.leave &&
        widget.onPostAction != null) {
      try {
        await widget.onPostAction!(_postAction, items);
      } catch (_) {
        if (mounted) {
          final l = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l.postimportFailed)),
          );
        }
        // Trotzdem mit den geadteten Items weiter — die sind ja schon in
        // Mealie. Mirror Swifts „die Items wurden trotzdem hinzugefügt".
      }
    }
    if (mounted) Navigator.pop(context, items.length);
  }

  void _toggleSelectAll() {
    final all = _selectedList?.items ?? const [];
    setState(() {
      if (_selectedItems.length == all.length) {
        _selectedItems.clear();
      } else {
        _selectedItems
          ..clear()
          ..addAll(all.map((i) => i.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        backgroundColor: context.appBg,
        surfaceTintColor: Colors.transparent,
        title: Text(widget.title),
      ),
      body: WithCookingModeFAB(
        child: SafeArea(
          top: false,
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: AppTokens.accent))
              : _error != null
                  ? _ErrorView(message: _error!, onRetry: _fetch, l: l)
                  : _lists.isEmpty
                      ? _EmptyView(hint: widget.emptyHint, l: l)
                      : _buildContent(l),
        ),
      ),
    );
  }

  Widget _buildContent(AppLocalizations l) {
    final items = _selectedList?.items ?? const <ImportTaskItem>[];
    final allSelected =
        items.isNotEmpty && _selectedItems.length == items.length;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            children: [
              // Listen-Auswahl (nur bei mehreren Quell-Listen).
              if (_lists.length > 1) ...[
                _ListPickerCard(
                  lists: _lists,
                  selected: _selectedList,
                  onChanged: (v) => setState(() {
                    _selectedList = v;
                    _selectedItems.clear();
                  }),
                  l: l,
                ),
                const SizedBox(height: 14),
              ],

              // Post-Import-Aktion (Picker + Hint) — nur wenn der Caller einen
              // onPostAction-Handler bereitstellt.
              if (widget.onPostAction != null) ...[
                _PostActionCard(
                  current: _postAction,
                  onChanged: (v) => setState(() => _postAction = v),
                  l: l,
                ),
                const SizedBox(height: 14),
              ],

              // „Alle auswählen"-Kopf mit Auswahlzähler.
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                child: Row(
                  children: [
                    Text(
                      l.selectAll,
                      style: TextStyle(
                        color: context.appFgSub,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const Spacer(),
                    if (_selectedItems.isNotEmpty)
                      Text(
                        '${_selectedItems.length}/${items.length}',
                        style: const TextStyle(
                          color: AppTokens.accentDeep,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    const SizedBox(width: 10),
                    _CheckCircle(
                      selected: allSelected,
                      onTap: _toggleSelectAll,
                    ),
                  ],
                ),
              ),

              // Auswahl-Rows.
              ...items.map((item) => _ImportItemRow(
                    item: item,
                    selected: _selectedItems.contains(item.id),
                    onTap: () => setState(() {
                      if (!_selectedItems.add(item.id)) {
                        _selectedItems.remove(item.id);
                      }
                    }),
                  )),
            ],
          ),
        ),

        // Import-Button unten — voll-breit, deaktiviert ohne Auswahl.
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            8 + MediaQuery.paddingOf(context).bottom,
          ),
          child: AsyncActionButton(
            expand: true,
            icon: Icons.download_rounded,
            label: _selectedItems.isEmpty
                ? l.importCount(0)
                : l.importCount(_selectedItems.length),
            onPressed: _selectedItems.isEmpty ? null : _import,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Auswahl-Row mit Check-Kreis (warme Karten-Optik).
// ---------------------------------------------------------------------------

class _ImportItemRow extends StatelessWidget {
  final ImportTaskItem item;
  final bool selected;
  final VoidCallback onTap;

  const _ImportItemRow({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTokens.rMd),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: context.appCard,
              borderRadius: BorderRadius.circular(AppTokens.rMd),
              border: Border.all(
                color: selected ? AppTokens.accent : context.appSeparator,
                width: selected ? 1.5 : 1,
              ),
              boxShadow: context.appShadowSm,
            ),
            child: Row(
              children: [
                _CheckCircle(selected: selected, onTap: onTap),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: item.completed ? context.appFgSub : context.appFg,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration:
                          item.completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Runder Auswahl-Indikator: gefüllter Akzent-Kreis mit Haken wenn gewählt,
// sonst leerer umrandeter Kreis.
class _CheckCircle extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  const _CheckCircle({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: selected ? AppTokens.accentGradient : null,
          color: selected ? null : Colors.transparent,
          border: selected
              ? null
              : Border.all(color: context.appSeparator, width: 1.6),
        ),
        child: selected
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 17)
            : null,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Listen-Auswahl als Karte mit Dropdown.
// ---------------------------------------------------------------------------

class _ListPickerCard extends StatelessWidget {
  final List<ImportTaskList> lists;
  final ImportTaskList? selected;
  final ValueChanged<ImportTaskList?> onChanged;
  final AppLocalizations l;

  const _ListPickerCard({
    required this.lists,
    required this.selected,
    required this.onChanged,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.list_rounded, color: AppTokens.accentDeep, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ImportTaskList>(
                isExpanded: true,
                value: selected,
                dropdownColor: context.appCard,
                borderRadius: BorderRadius.circular(AppTokens.rMd),
                items: lists
                    .map((lst) => DropdownMenuItem<ImportTaskList>(
                          value: lst,
                          child: Text(lst.title,
                              style: TextStyle(
                                  color: context.appFg,
                                  fontWeight: FontWeight.w600)),
                        ))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _PostActionCard — Picker (3 Optionen) + Hint in Premium-Karte. Ersetzt die
// vorherige nackte SegmentedButton-Sektion; gleiche Funktion, 1:1 zu Swifts
// `Section { Picker(...).pickerStyle(.segmented) }`.
// ---------------------------------------------------------------------------

class _PostActionCard extends StatelessWidget {
  final TaskImportPostAction current;
  final ValueChanged<TaskImportPostAction> onChanged;
  final AppLocalizations l;

  const _PostActionCard({
    required this.current,
    required this.onChanged,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.postimportAction,
            style: TextStyle(
              color: context.appFgSub,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          SegmentedButton<TaskImportPostAction>(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? AppTokens.accent
                      : context.appSurface2),
              foregroundColor: WidgetStateProperty.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? Colors.white
                      : context.appFg),
              side: WidgetStatePropertyAll(
                  BorderSide(color: context.appSeparator)),
              textStyle: const WidgetStatePropertyAll(
                  TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            segments: [
              ButtonSegment(
                value: TaskImportPostAction.leave,
                label: Text(l.postimportLeave),
              ),
              ButtonSegment(
                value: TaskImportPostAction.complete,
                label: Text(l.postimportComplete),
              ),
              ButtonSegment(
                value: TaskImportPostAction.completeAndDelete,
                label: Text(l.postimportCompleteDelete),
              ),
            ],
            selected: {current},
            showSelectedIcon: false,
            onSelectionChanged: (s) => onChanged(s.first),
          ),
          const SizedBox(height: 8),
          Text(
            l.postimportHint,
            style:
                TextStyle(color: context.appFgSub, fontSize: 11, height: 1.4),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Leerer-/Fehler-Zustand in Premium-Optik.
// ---------------------------------------------------------------------------

class _EmptyView extends StatelessWidget {
  final String hint;
  final AppLocalizations l;
  const _EmptyView({required this.hint, required this.l});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.appSurface2,
              ),
              child: Icon(Icons.inbox_rounded,
                  color: context.appFgTertiary, size: 28),
            ),
            const SizedBox(height: 16),
            Text(hint,
                textAlign: TextAlign.center,
                style: TextStyle(color: context.appFgSub, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final AppLocalizations l;
  const _ErrorView(
      {required this.message, required this.onRetry, required this.l});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: PremiumCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 44, color: context.appFgSub),
              const SizedBox(height: 14),
              Text(message,
                  style: TextStyle(color: context.appFgSub),
                  textAlign: TextAlign.center),
              const SizedBox(height: 18),
              GradientButton(
                label: l.retry,
                icon: Icons.refresh_rounded,
                onTap: onRetry,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
