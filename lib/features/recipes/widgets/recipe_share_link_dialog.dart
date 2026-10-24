import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr/qr.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../webapp_tools/widgets/tool_widgets.dart';

// ---------------------------------------------------------------------------
// Freigabe-Links eines Rezepts (Mealie „Rezept teilen"): Der SERVER erzeugt
// pro Link ein Token mit Ablaufdatum; wer den Link hat, sieht das Rezept im
// Browser ohne Konto. Wie in Mealie 3.29 lässt sich jeder Link auch als
// QR-Code zeigen (zum Abscannen mit der Handykamera) und als Bild teilen.
// Rechte: Mealie erlaubt das jedem angemeldeten Nutzer der Gruppe.
// Früher nur in den Desktop-Werkzeugen, jetzt auf allen Plattformen.
// ---------------------------------------------------------------------------

Future<void> showRecipeShareLinkDialog(
        BuildContext context, RecipeDetail recipe) =>
    showDialog<void>(
        context: context,
        builder: (_) => RecipeShareLinkDialog(recipe: recipe));

/// Basis der Webapp-Links: `{server}/g/{gruppe}`.
String recipeWebBase(WidgetRef ref) {
  final server = (ref.read(settingsProvider).valueOrNull?.serverUrl ?? '')
      .replaceAll(RegExp(r'/+$'), '');
  final group = ref.read(currentUserProvider)?['groupSlug']?.toString() ?? '';
  return '$server/g/$group';
}

class RecipeShareLinkDialog extends ConsumerStatefulWidget {
  final RecipeDetail recipe;
  const RecipeShareLinkDialog({super.key, required this.recipe});

  @override
  ConsumerState<RecipeShareLinkDialog> createState() =>
      _RecipeShareLinkDialogState();
}

class _RecipeShareLinkDialogState extends ConsumerState<RecipeShareLinkDialog> {
  List<Map<String, dynamic>>? _tokens;
  DateTime _expires = DateTime.now().add(const Duration(days: 30));
  bool _busy = false;

  /// Gerade als QR-Code angezeigter Link (null = Liste).
  String? _qrLink;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list =
          await ref.read(apiServiceProvider).fetchShareTokens(widget.recipe.id);
      if (mounted) setState(() => _tokens = list);
    } catch (e) {
      if (!mounted) return;
      setState(() => _tokens ??= const []);
      showToolError(context, AppLocalizations.of(context)!.loadFailed, e);
    }
  }

  String _link(String tokenId) => '${recipeWebBase(ref)}/shared/r/$tokenId';

  Future<void> _guard(String fail, Future<void> Function() op) async {
    setState(() => _busy = true);
    try {
      await op();
    } catch (e) {
      if (mounted) showToolError(context, fail, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _copy(String link) async {
    final l = AppLocalizations.of(context)!;
    await Clipboard.setData(ClipboardData(text: link));
    if (mounted) showToolMessage(context, l.recipeShareCopied);
  }

  /// QR-Code als PNG teilen (Fotos sichern, Messenger, Drucken …).
  Future<void> _shareQrImage(String link, BuildContext buttonContext) async {
    final box = buttonContext.findRenderObject() as RenderBox?;
    final origin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;
    try {
      final bytes = await renderQrPng(link);
      final dir = await getTemporaryDirectory();
      final name = widget.recipe.slug.isEmpty ? 'recipe' : widget.recipe.slug;
      final file = File('${dir.path}/$name-qr.png');
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path, mimeType: 'image/png')],
        text: '${widget.recipe.name}\n$link',
        sharePositionOrigin: origin,
      ));
    } catch (e) {
      if (mounted) {
        showToolError(
            context, AppLocalizations.of(context)!.recipeShareQrFailed, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: context.appCard,
      title: Text(l.recipeShareLink),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: _qrLink != null ? _qrView(l, _qrLink!) : _listView(l),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(l.close)),
      ],
    );
  }

  Widget _qrView(AppLocalizations l, String link) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            // Immer weißer Grund mit Rand, auch im Dark Mode — sonst lesen
            // manche Kameras den Code nicht.
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              width: 220,
              height: 220,
              child: CustomPaint(painter: _QrPainter(link)),
            ),
          ),
          const SizedBox(height: 12),
          Text(l.recipeShareScanQr,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.appFgSub, fontSize: 13)),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => setState(() => _qrLink = null),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: Text(l.back),
              ),
              OutlinedButton.icon(
                onPressed: () => _copy(link),
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: Text(l.copy),
              ),
              Builder(
                builder: (bctx) => FilledButton.icon(
                  onPressed: () => _shareQrImage(link, bctx),
                  icon: const Icon(Icons.ios_share_rounded, size: 18),
                  label: Text(l.recipeShareQrShare),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _listView(AppLocalizations l) {
    final tokens = _tokens;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.recipeShareDescription,
            style: TextStyle(color: context.appFgSub, fontSize: 13)),
        const SizedBox(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_rounded),
                title: Text(l.recipeShareExpiration),
                subtitle: Text(
                    MaterialLocalizations.of(context).formatMediumDate(_expires),
                    style: TextStyle(color: context.appFg)),
                onTap: () async {
                  final now = DateTime.now();
                  final d = await showDatePicker(
                    context: context,
                    initialDate: _expires,
                    firstDate: now,
                    lastDate: DateTime(now.year + 10),
                  );
                  if (d != null) setState(() => _expires = d);
                },
              ),
            ),
            FilledButton.icon(
              onPressed: _busy
                  ? null
                  : () => _guard(l.createFailed, () async {
                        await ref
                            .read(apiServiceProvider)
                            .createShareToken(widget.recipe.id, _expires);
                        await _load();
                      }),
              icon: const Icon(Icons.add_link_rounded),
              label: Text(l.recipeShareCreate),
            ),
          ],
        ),
        const Divider(),
        if (tokens == null)
          const ToolEmpty('', loading: true)
        else if (tokens.isEmpty)
          ToolEmpty(l.recipeShareEmpty)
        else
          for (final t in tokens)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.link_rounded),
              title: SelectableText(_link(t['id'].toString()),
                  style: TextStyle(color: context.appFg, fontSize: 13)),
              subtitle: Text(
                  l.recipeShareExpiresAt(
                      formatToolDate(context, t['expiresAt'], time: false)),
                  style: TextStyle(color: context.appFgSub, fontSize: 12)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: l.recipeShareShowQr,
                    icon: const Icon(Icons.qr_code_2_rounded),
                    onPressed: () =>
                        setState(() => _qrLink = _link(t['id'].toString())),
                  ),
                  IconButton(
                    tooltip: l.copy,
                    icon: const Icon(Icons.copy_rounded),
                    onPressed: () => _copy(_link(t['id'].toString())),
                  ),
                  IconButton(
                    tooltip: l.delete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: _busy
                        ? null
                        : () => _guard(l.deleteFailed, () async {
                              await ref
                                  .read(apiServiceProvider)
                                  .deleteShareToken(t['id'].toString());
                              await _load();
                            }),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// QR-Code zeichnen (Paket `qr` berechnet die Module, gemalt wird selbst).
// ---------------------------------------------------------------------------

QrImage _qrImage(String data) => QrImage(
    QrCode.fromData(data: data, errorCorrectLevel: QrErrorCorrectLevel.M));

void _paintQr(Canvas canvas, Size size, QrImage qr) {
  final n = qr.moduleCount;
  final cell = size.shortestSide / n;
  final paint = Paint()
    ..color = Colors.black
    ..isAntiAlias = false;
  for (var y = 0; y < n; y++) {
    for (var x = 0; x < n; x++) {
      if (qr.isDark(y, x)) {
        // Minimal überlappend, damit keine Haarlinien zwischen Modulen
        // entstehen.
        canvas.drawRect(
            Rect.fromLTWH(x * cell, y * cell, cell + 0.5, cell + 0.5), paint);
      }
    }
  }
}

class _QrPainter extends CustomPainter {
  final String data;
  final QrImage _qr;
  _QrPainter(this.data) : _qr = _qrImage(data);

  @override
  void paint(Canvas canvas, Size size) => _paintQr(canvas, size, _qr);

  @override
  bool shouldRepaint(_QrPainter old) => old.data != data;
}

/// QR-Code als PNG (weißer Rand = „Ruhezone", die Scanner brauchen).
Future<Uint8List> renderQrPng(String data, {int size = 1024}) async {
  final qr = _qrImage(data);
  final quiet = size * 0.08;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
      Paint()..color = Colors.white);
  canvas.translate(quiet, quiet);
  _paintQr(canvas, Size.square(size - 2 * quiet), qr);
  final image = await recorder.endRecording().toImage(size, size);
  final png = await image.toByteData(format: ui.ImageByteFormat.png);
  return png!.buffer.asUint8List();
}
