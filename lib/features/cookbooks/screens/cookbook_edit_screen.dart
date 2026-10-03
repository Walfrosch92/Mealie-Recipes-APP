import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/models/cookbook_summary.dart';
import '../../../core/services/log_manager.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/async_action_button.dart';
import '../../../shared/widgets/query_filter_editor.dart';
import '../providers/cookbooks_provider.dart';

// ---------------------------------------------------------------------------
// Kochbuch erstellen/bearbeiten — mirrors die Mealie-Webapp-Maske „Ein
// Kochbuch erstellen": Name, Beschreibung, Öffentlich-Schalter und ein
// Filter-Baukasten (mehrere Zeilen [Feld] [Operator] [Werte], AND-verknüpft),
// aus dem serverseitig ein `queryFilterString` gebaut wird — GENAU das Feld,
// das `CookbookRecipesScreen` bereits opak an GET /api/recipes?queryFilter=…
// durchreicht (siehe cookbooks_provider.dart). Die eigentliche Baukasten↔
// String-Logik steckt in `core/utils/cookbook_query_filter.dart` (pur,
// getestet in test/cookbook_query_filter_test.dart) — dort auch der
// Konfidenz-Hinweis zu den sechs Attribut-Pfaden.
//
// Zusätzlich zum Baukasten gibt es einen Experten-Modus (Roh-Text), der den
// `queryFilterString` direkt editierbar macht — das ist KEIN Webapp-Feature,
// sondern das Sicherheitsnetz dieser App: lässt sich ein beim Bearbeiten
// geladener Bestandsfilter nicht in Zeilen zerlegen (z. B. weil er in der
// Webapp mit OR/Klammern gebaut wurde), springt die App automatisch in
// diesen Modus statt den Filter beim Speichern stillschweigend zu ersetzen.
// ---------------------------------------------------------------------------

class CookbookEditScreen extends ConsumerStatefulWidget {
  /// null = neues Kochbuch anlegen; gesetzt = bestehendes bearbeiten.
  final String? cookbookId;
  const CookbookEditScreen({super.key, this.cookbookId});

  @override
  ConsumerState<CookbookEditScreen> createState() => _CookbookEditScreenState();
}

class _CookbookEditScreenState extends ConsumerState<CookbookEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _filterCtrl = QueryFilterEditorController();
  bool _public = false;
  CookbookSummary? _existing;
  String? _error;

  bool get _isNew => widget.cookbookId == null;

  @override
  void initState() {
    super.initState();
    if (!_isNew) _loadExisting();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _loadExisting() {
    final books = ref.read(cookbooksProvider).valueOrNull ?? const [];
    CookbookSummary? found;
    for (final c in books) {
      if (c.id == widget.cookbookId) {
        found = c;
        break;
      }
    }
    if (found == null) return; // deep-link ohne geladene Liste → leer starten
    _existing = found;
    _nameCtrl.text = found.name;
    _descCtrl.text = found.description ?? '';
    _public = found.public;
    // Der Filter selbst wird vom QueryFilterEditor aus
    // _existing.queryFilterString geladen (inkl. Roh-Modus-Automatik).
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _error = null);
    final l = AppLocalizations.of(context)!;
    final queryFilterString = _filterCtrl.compose();
    try {
      final notifier = ref.read(cookbooksProvider.notifier);
      if (_isNew) {
        await notifier.create(
          name: _nameCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          queryFilterString: queryFilterString,
          public: _public,
        );
      } else {
        await notifier.updateCookbook(_existing!.copyWith(
          name: _nameCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          queryFilterString: queryFilterString,
          public: _public,
        ));
      }
      if (!mounted) return;
      context.pop();
    } catch (e) {
      LogManager.shared.log('❌ Kochbuch speichern fehlgeschlagen: $e');
      if (!mounted) return;
      setState(() => _error = l.saveFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Text(_isNew ? l.cookbookCreateTitle : l.cookbookEditTitle),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: l.cookbookNameLabel,
                  border: const OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.required : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                decoration: InputDecoration(
                  labelText: l.descriptionLabel,
                  border: const OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                minLines: 2,
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              Text(l.cookbookFilterSectionTitle,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              QueryFilterEditor(
                controller: _filterCtrl,
                initialFilter: _existing?.queryFilterString ?? '',
              ),
              const SizedBox(height: 24),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l.cookbookPublicLabel),
                subtitle: Text(l.cookbookPublicSubtitle),
                value: _public,
                onChanged: (v) => setState(() => _public = v),
              ),
              const SizedBox(height: 16),
              if (_error != null) ...[
                Text(_error!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
                const SizedBox(height: 16),
              ],
              AsyncActionButton(
                expand: true,
                label: l.save,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
