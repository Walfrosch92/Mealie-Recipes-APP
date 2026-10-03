import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/api/api_service.dart';
import '../../../shared/theme/app_colors.dart';

/// JSON-Editor der Webapp: das komplette Rezept als JSON bearbeiten (nur
/// „Erweiterte Funktionen"). Lädt immer den aktuellen Server-Stand.
/// Kommentare verwaltet Mealie separat — sie werden nicht mitgeschickt.
class RecipeJsonEditorScreen extends ConsumerStatefulWidget {
  final String recipeId;
  const RecipeJsonEditorScreen({super.key, required this.recipeId});

  @override
  ConsumerState<RecipeJsonEditorScreen> createState() =>
      _RecipeJsonEditorScreenState();
}

class _RecipeJsonEditorScreenState
    extends ConsumerState<RecipeJsonEditorScreen> {
  final _ctrl = TextEditingController();
  String _initial = '';
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final raw =
          await ref.read(apiServiceProvider).fetchRecipeRaw(widget.recipeId);
      raw.remove('comments');
      _initial = const JsonEncoder.withIndent('  ').convert(raw);
      _ctrl.text = _initial;
      if (mounted) setState(() => _loading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = mealieErrorMessage(e) ?? e.toString();
        });
      }
    }
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    Map<String, dynamic> data;
    try {
      final decoded = jsonDecode(_ctrl.text);
      if (decoded is! Map) throw const FormatException();
      data = Map<String, dynamic>.from(decoded)..remove('comments');
    } catch (_) {
      setState(() => _error = l.jsonInvalid);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(apiServiceProvider).patchRecipe(widget.recipeId, data);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l.saveSuccess),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ));
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = mealieErrorMessage(e) ?? e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return PopScope(
      canPop: _ctrl.text == _initial,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final nav = Navigator.of(context);
        final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: ctx.appCard,
                content: Text(l.discardChangesConfirm),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l.cancel)),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(l.discardChanges),
                  ),
                ],
              ),
            ) ??
            false;
        if (ok) {
          _ctrl.text = _initial;
          nav.pop(false);
        }
      },
      child: Scaffold(
        backgroundColor: context.appBg,
        appBar: AppBar(
          title: Text(l.jsonEditorTitle),
          actions: [
            TextButton(
              onPressed: _loading || _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l.save,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_error != null)
                      Container(
                        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            Text(_error!, style: const TextStyle(fontSize: 13)),
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          controller: _ctrl,
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          autocorrect: false,
                          enableSuggestions: false,
                          keyboardType: TextInputType.multiline,
                          textAlignVertical: TextAlignVertical.top,
                          onChanged: (_) => setState(() {}),
                          style: TextStyle(
                              fontFamily: 'monospace',
                              fontFamilyFallback: const ['Menlo', 'Courier'],
                              fontSize: 12.5,
                              color: context.appFg),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: context.appSurface2,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
