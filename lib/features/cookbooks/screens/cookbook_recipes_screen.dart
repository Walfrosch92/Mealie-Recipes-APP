import 'package:flutter/material.dart';
import '../../../shared/widgets/shimmer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/cookbook_summary.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/log_manager.dart';
import '../../../core/utils/mealie_version.dart';
import '../../../core/utils/platform_features.dart';
import '../../../shared/widgets/markdown_text.dart';
import '../../webapp_tools/widgets/tool_widgets.dart' show saveBytesWithDialog;
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/animations.dart';
import '../../cooking_mode/widgets/cooking_mode_fab.dart';
// RecipeCard wird 1:1 aus der Rezeptliste wiederverwendet (public dort).
import '../../recipes/screens/recipe_list_screen.dart';
import '../providers/cookbooks_provider.dart';
import '../../../shared/widgets/error_view.dart';

// ---------------------------------------------------------------------------
// CookbookRecipesScreen — Rezepte EINES Kochbuchs. OFFLINE-FIRST: die
// gecachte ID-Liste rendert sofort (aufgelöst gegen den lokalen Rezept-
// Cache), der queryFilter wird im Hintergrund frisch aufgelöst; offline
// bleibt der Cache-Stand stehen. Nur beim allerersten Öffnen ohne Cache
// braucht es den Server (sonst Fehler + Retry).
//
// Sonderfälle (Webapp-Spiegel):
//   • queryFilterString leer → Server liefert ALLE Rezepte, wird so gezeigt.
//   • items:[] → eigener Empty-State „Keine Rezepte entsprechen diesem Filter".
// ---------------------------------------------------------------------------

class CookbookRecipesScreen extends ConsumerWidget {
  final String cookbookId;
  const CookbookRecipesScreen({super.key, required this.cookbookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider).valueOrNull;
    final recipesAsync = ref.watch(cookbookRecipesProvider(cookbookId));

    // Name für die AppBar aus der Kochbuch-Liste auflösen (deep-link-sicher:
    // der Screen bekommt nur die id über die Route).
    final books = ref.watch(cookbooksProvider).valueOrNull ?? const [];
    var title = l.cookbooks;
    CookbookSummary? book;
    for (final c in books) {
      if (c.id == cookbookId) {
        title = c.name;
        book = c;
        break;
      }
    }
    final description = book?.description?.trim() ?? '';
    // Kopfzeile der Liste: Beschreibung (Markdown wie die Webapp ab 3.31).
    final header = description.isEmpty ? 0 : 1;

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        title: Text(title),
        actions: [
          // PDF des ganzen Kochbuchs rendert der Server (Mealie ≥ 3.31).
          if (book != null && ref.watch(mealie331Provider))
            _CookbookPdfButton(cookbook: book),
        ],
      ),
      body: WithCookingModeFAB(
        child: SafeArea(
          top: false,
          child: recipesAsync.when(
            loading: () => const ListSkeleton(
                rows: 6,
                thumbSize: 116,
                thumbRadius: AppTokens.rLg,
                spacing: 14),
            error: (e, _) => ErrorRetryView(
              error: e,
              onRetry: () =>
                  ref.invalidate(cookbookRecipeIdsProvider(cookbookId)),
            ),
            data: (recipes) => recipes.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.filter_alt_off_rounded,
                              size: 56, color: context.appFgTertiary),
                          const SizedBox(height: 14),
                          Text(l.cookbookNoMatches,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: context.appFgSub, fontSize: 15)),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    // Kein invalidate (würde die Liste in den Spinner
                    // kippen): reload() holt den Server-Stand und lässt bei
                    // Offline den aktuellen Cache-Stand stehen.
                    onRefresh: () => ref
                        .read(cookbookRecipeIdsProvider(cookbookId).notifier)
                        .reload(),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                      itemCount: recipes.length + header,
                      itemBuilder: (ctx, index) {
                        if (index < header) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(2, 2, 2, 14),
                            child: MarkdownText(
                              text: description,
                              style: TextStyle(
                                  color: context.appFgSub,
                                  fontSize: 14,
                                  height: 1.4),
                              serverUrl: settings?.serverUrl,
                              apiToken: settings?.apiToken,
                            ),
                          );
                        }
                        final i = index - header;
                        return EntranceOnce(
                          id: 'cookbook-recipe-${recipes[i].id}',
                          index: i,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: RecipeCard(
                              recipe: recipes[i],
                              showImage: settings?.showRecipeImages ?? true,
                              baseUrl: settings?.serverUrl ?? '',
                              token: settings?.apiToken ?? '',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// „Als PDF exportieren" — das ganze Kochbuch mit Deckblatt und Inhalts-
// verzeichnis, vom Server gerendert (GET …/cookbooks/{id}/pdf, Mealie ≥ 3.31).
// Ein großes Kochbuch braucht eine Weile: der Knopf zeigt solange einen
// Fortschrittsring, die Liste bleibt bedienbar. Mobil → Teilen-Sheet,
// Desktop → Speichern-Dialog.
// ---------------------------------------------------------------------------

class _CookbookPdfButton extends ConsumerStatefulWidget {
  final CookbookSummary cookbook;
  const _CookbookPdfButton({required this.cookbook});

  @override
  ConsumerState<_CookbookPdfButton> createState() => _CookbookPdfButtonState();
}

class _CookbookPdfButtonState extends ConsumerState<_CookbookPdfButton> {
  bool _busy = false;

  String get _fileName {
    final slug = widget.cookbook.slug?.trim() ?? '';
    final base = slug.isNotEmpty ? slug : widget.cookbook.name.trim();
    final safe = base.replaceAll(RegExp(r'[\\/:*?"<>|\x00-\x1F]'), '_').trim();
    return '${safe.isEmpty ? 'cookbook' : safe}.pdf';
  }

  Future<void> _export() async {
    if (_busy) return;
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    // Ursprung des Teilen-Popovers (iPad verlangt ihn).
    final box = context.findRenderObject() as RenderBox?;
    final origin =
        box == null ? null : box.localToGlobal(Offset.zero) & box.size;
    final settings = ref.read(settingsProvider).valueOrNull;
    setState(() => _busy = true);
    messenger.showSnackBar(SnackBar(
      content: Text(l.generatingPdf),
      duration: const Duration(minutes: 5),
    ));
    try {
      final bytes = await ref.read(apiServiceProvider).exportCookbookPdf(
          widget.cookbook.id,
          includeImages: settings?.showRecipeImages ?? true);
      if (bytes.isEmpty) throw StateError('Empty PDF');
      messenger.hideCurrentSnackBar();
      if (PlatformFeatures.webAppTools) {
        if (await saveBytesWithDialog(bytes, _fileName)) {
          messenger.showSnackBar(SnackBar(content: Text(l.fileSaved)));
        }
      } else {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$_fileName');
        await file.writeAsBytes(bytes, flush: true);
        await SharePlus.instance.share(ShareParams(
          files: [XFile(file.path, mimeType: 'application/pdf')],
          subject: widget.cookbook.name,
          sharePositionOrigin: origin,
        ));
      }
    } catch (e) {
      LogManager.shared.log('⚠️ Kochbuch-PDF fehlgeschlagen: $e');
      messenger.hideCurrentSnackBar();
      // Grund nennen (offline, Zeitüberschreitung …) statt nur „fehlgeschlagen".
      messenger.showSnackBar(
          SnackBar(content: Text(userErrorMessage(e, l.pdfExportFailed))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return IconButton(
      tooltip: l.exportAsPdf,
      onPressed: _busy ? null : _export,
      icon: _busy
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(Icons.picture_as_pdf_rounded, color: context.appFg),
    );
  }
}
