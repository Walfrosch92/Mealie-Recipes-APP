import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' show Rect;

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/utils/ingredient_display.dart';
import '../../../core/utils/yield_format.dart';

// ---------------------------------------------------------------------------
// RecipePdfService — generiert ein eigenständiges Rezept-PDF (Bild als Bytes
// EINGEBETTET, keine Server-URLs) und öffnet danach das System-Share-Sheet
// (Mail/WhatsApp/…). Kein Swift-Original — reine App-eigene Funktion, siehe
// [[project-flutter-migration]]. Sobald die PDF-Datei erzeugt ist, braucht sie
// keine Verbindung zum Mealie-Server mehr, da Bild + Text vollständig
// eingebettet sind statt referenziert.
//
// Dependency `pdf`: einzige reine-Dart-Bibliothek zum Erzeugen von PDFs, kein
// SDK/Core-Äquivalent vorhanden, keine native Plattform-Anbindung nötig.
// `share_plus` + `path_provider` sind bereits Projekt-Dependencies (mirrors
// SupportMailService.shareLogs). Wiederverwendet die Skalierungs-Logik aus
// core/utils/ingredient_display.dart und yield_format.dart — dieselbe wie im
// Detail-Screen, damit das PDF exakt zeigt, was gerade auf dem Screen steht.
// ---------------------------------------------------------------------------

/// Vom Aufrufer übergebene, bereits lokalisierte Beschriftungen — der Service
/// selbst hat keinen BuildContext.
class RecipePdfLabels {
  final String servings;
  // Ein einziger Zeit-Wert statt getrennter Prep/Cook/Total-Labels — mirrors
  // die on-screen _HeroMetaRow (Icon + EIN Zeitwert, totalTime ?? prepTime ??
  // cookTime), damit das PDF nicht mehr zeigt als der Detail-Screen selbst.
  final String time;
  final String rating;
  final String ingredients;
  final String instructions;
  final String notes;
  final String generatedBy;

  const RecipePdfLabels({
    required this.servings,
    required this.time,
    required this.rating,
    required this.ingredients,
    required this.instructions,
    required this.notes,
    required this.generatedBy,
  });
}

class RecipePdfService {
  RecipePdfService._();

  static const _accent = PdfColor.fromInt(0xFFFF8A00);
  static const _accentDeep = PdfColor.fromInt(0xFFFF6A00);
  static const _textDark = PdfColor.fromInt(0xFF1A1A1A);
  static const _textSub = PdfColor.fromInt(0xFF666666);

  /// Baut das PDF, schreibt es in den Temp-Ordner und öffnet das
  /// System-Share-Sheet. Netzwerkfehler beim Bild-Fetch sind NICHT fatal —
  /// das PDF wird dann ohne Bild erzeugt statt komplett abzubrechen.
  static Future<void> exportAndShare({
    required RecipeDetail recipe,
    required ApiService api,
    required double multiplier,
    required bool includeImage,
    required RecipePdfLabels labels,
    // Ursprung des Share-Popovers (mirrors SupportMailService.shareLogs) —
    // ohne das lehnt share_plus die Freigabe mit einer PlatformException ab
    // ("sharePositionOrigin must be set"), nicht nur auf dem iPad.
    Rect? sharePositionOrigin,
  }) async {
    Uint8List? imageBytes;
    if (includeImage) {
      try {
        final bytes = await api.fetchRecipeImageBytes(recipe.id);
        if (bytes.isNotEmpty) imageBytes = Uint8List.fromList(bytes);
      } catch (_) {
        // Kein Bild verfügbar (404/offline) — PDF trotzdem erzeugen.
      }
    }

    final baseFontData =
        await rootBundle.load('assets/fonts/Inter-Variable.ttf');
    final headingFontData =
        await rootBundle.load('assets/fonts/PlusJakartaSans-Variable.ttf');
    final baseFont = pw.Font.ttf(baseFontData);
    final headingFont = pw.Font.ttf(headingFontData);

    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4.copyWith(
        marginLeft: 32,
        marginRight: 32,
        marginTop: 36,
        marginBottom: 36,
      ),
      theme: pw.ThemeData.withFont(base: baseFont, bold: headingFont),
      footer: (context) => pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(top: 8),
        child: pw.Text(
          '${labels.generatedBy} · ${context.pageNumber}/${context.pagesCount}',
          style: pw.TextStyle(font: baseFont, fontSize: 8, color: _textSub),
        ),
      ),
      build: (context) => _buildContent(
        recipe: recipe,
        multiplier: multiplier,
        imageBytes: imageBytes,
        baseFont: baseFont,
        headingFont: headingFont,
        labels: labels,
      ),
    ));

    final bytes = await doc.save();
    final dir = await getTemporaryDirectory();
    final fileName = _sanitizeFileName(
        recipe.name.trim().isEmpty ? 'Rezept' : recipe.name.trim());
    final file = File('${dir.path}/$fileName.pdf');
    await file.writeAsBytes(bytes, flush: true);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/pdf')],
      subject: recipe.name,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  static List<pw.Widget> _buildContent({
    required RecipeDetail recipe,
    required double multiplier,
    required Uint8List? imageBytes,
    required pw.Font baseFont,
    required pw.Font headingFont,
    required RecipePdfLabels labels,
  }) {
    final widgets = <pw.Widget>[];

    // Titel
    widgets.add(pw.Text(recipe.name,
        style:
            pw.TextStyle(font: headingFont, fontSize: 24, color: _textDark)));

    // Kategorien/Tags-Chips
    final chips = [
      ...recipe.recipeCategory.map((c) => c.name),
      ...recipe.tags.map((t) => t.name),
    ];
    if (chips.isNotEmpty) {
      widgets.add(pw.SizedBox(height: 8));
      widgets.add(pw.Wrap(
        spacing: 6,
        runSpacing: 6,
        children: chips
            .map((c) => pw.Container(
                  padding:
                      const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFFFFF1E0),
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
                  ),
                  child: pw.Text(c,
                      style: pw.TextStyle(
                          font: baseFont, fontSize: 8.5, color: _accentDeep)),
                ))
            .toList(),
      ));
    }

    widgets.add(pw.SizedBox(height: 14));

    // Bild
    if (imageBytes != null) {
      widgets.add(pw.Container(
        width: double.infinity,
        height: 200,
        margin: const pw.EdgeInsets.only(bottom: 14),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey200,
          borderRadius: pw.BorderRadius.circular(10),
        ),
        child: pw.ClipRRect(
          horizontalRadius: 10,
          verticalRadius: 10,
          child: pw.Image(pw.MemoryImage(imageBytes), fit: pw.BoxFit.cover),
        ),
      ));
    }

    // Meta-Zeile: Portionen + EINE Zeitangabe + Bewertung — mirrors die
    // on-screen _HeroMetaRow-Reihenfolge/-Auswahl (siehe RecipePdfLabels.time).
    final metaItems = <(String, String)>[];
    final t = recipe.totalTime ?? recipe.prepTime ?? recipe.cookTime;
    if ((t ?? 0) > 0) {
      metaItems.add((labels.time, _fmtTime(t!)));
    }
    if ((recipe.recipeYield ?? '').isNotEmpty) {
      metaItems
          .add((labels.servings, scaleYield(recipe.recipeYield!, multiplier)));
    }
    if ((recipe.rating ?? 0) > 0) {
      metaItems.add((labels.rating, recipe.rating!.toStringAsFixed(1)));
    }
    if (metaItems.isNotEmpty) {
      widgets.add(pw.Wrap(
        spacing: 18,
        runSpacing: 8,
        children: metaItems
            .map((m) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(m.$1,
                        style: pw.TextStyle(
                            font: baseFont, fontSize: 8, color: _textSub)),
                    pw.Text(m.$2,
                        style: pw.TextStyle(
                            font: headingFont,
                            fontSize: 12.5,
                            color: _textDark)),
                  ],
                ))
            .toList(),
      ));
      widgets.add(pw.SizedBox(height: 16));
    }

    // Beschreibung
    final desc = _stripMarkdown(recipe.description ?? '');
    if (desc.isNotEmpty) {
      widgets.add(pw.Text(desc,
          style: pw.TextStyle(
              font: baseFont,
              fontSize: 10.5,
              color: _textSub,
              lineSpacing: 2)));
      widgets.add(pw.SizedBox(height: 18));
    }

    // Zutaten
    if (recipe.recipeIngredient.isNotEmpty) {
      widgets.add(_sectionHeader(labels.ingredients, headingFont));
      widgets.add(pw.SizedBox(height: 8));
      for (final ing in recipe.recipeIngredient) {
        final section = ing.sectionTitle;
        if (section != null) {
          widgets.add(pw.Padding(
            padding: pw.EdgeInsets.only(
                top: identical(ing, recipe.recipeIngredient.first) ? 0 : 8,
                bottom: 5),
            child: pw.Text(section,
                style: pw.TextStyle(
                    font: headingFont, fontSize: 11, color: _accentDeep)),
          ));
        }
        if (!ing.hasContent) continue;
        final (:amount, :name) = ingredientDisplayParts(ing, multiplier);
        widgets.add(pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 12,
                child: pw.Text('•',
                    style: pw.TextStyle(
                        font: baseFont, fontSize: 11, color: _accent)),
              ),
              pw.Expanded(
                child: pw.RichText(
                  text: pw.TextSpan(children: [
                    if (amount.isNotEmpty)
                      pw.TextSpan(
                          text: '$amount  ',
                          style: pw.TextStyle(
                              font: headingFont,
                              fontSize: 10.5,
                              color: _accentDeep)),
                    pw.TextSpan(
                        text: name,
                        style: pw.TextStyle(
                            font: baseFont, fontSize: 10.5, color: _textDark)),
                  ]),
                ),
              ),
            ],
          ),
        ));
      }
      widgets.add(pw.SizedBox(height: 18));
    }

    // Zubereitung
    if (recipe.recipeInstructions.isNotEmpty) {
      widgets.add(_sectionHeader(labels.instructions, headingFont));
      widgets.add(pw.SizedBox(height: 8));
      for (var i = 0; i < recipe.recipeInstructions.length; i++) {
        final step = recipe.recipeInstructions[i];
        final section = step.sectionTitle;
        final text = _stripMarkdown(step.text);
        if (section != null) {
          widgets.add(pw.Padding(
            padding: pw.EdgeInsets.only(top: i == 0 ? 0 : 6, bottom: 6),
            child: pw.Text(section,
                style: pw.TextStyle(
                    font: headingFont, fontSize: 11, color: _accentDeep)),
          ));
        }
        widgets.add(pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 12),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 20,
                height: 20,
                alignment: pw.Alignment.center,
                decoration: const pw.BoxDecoration(
                    shape: pw.BoxShape.circle, color: _accent),
                child: pw.Text('${i + 1}',
                    style: pw.TextStyle(
                        font: headingFont,
                        fontSize: 9.5,
                        color: PdfColors.white)),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (step.heading != null)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 3),
                        child: pw.Text(step.heading!,
                            style: pw.TextStyle(
                                font: headingFont,
                                fontSize: 10.5,
                                color: _textDark)),
                      ),
                    pw.Text(text,
                        style: pw.TextStyle(
                            font: baseFont,
                            fontSize: 10.5,
                            color: _textDark,
                            lineSpacing: 2)),
                  ],
                ),
              ),
            ],
          ),
        ));
      }
      widgets.add(pw.SizedBox(height: 10));
    }

    // Notizen
    if (recipe.notes.isNotEmpty) {
      widgets.add(_sectionHeader(labels.notes, headingFont));
      widgets.add(pw.SizedBox(height: 8));
      for (final n in recipe.notes) {
        if (n.title.isNotEmpty) {
          widgets.add(pw.Text(n.title,
              style: pw.TextStyle(
                  font: headingFont, fontSize: 10.5, color: _textDark)));
          widgets.add(pw.SizedBox(height: 2));
        }
        if (n.text.isNotEmpty) {
          widgets.add(pw.Text(_stripMarkdown(n.text),
              style: pw.TextStyle(
                  font: baseFont,
                  fontSize: 10,
                  color: _textSub,
                  lineSpacing: 2)));
        }
        widgets.add(pw.SizedBox(height: 8));
      }
    }

    return widgets;
  }

  static pw.Widget _sectionHeader(String label, pw.Font headingFont) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label,
            style: pw.TextStyle(
                font: headingFont, fontSize: 13.5, color: _accentDeep)),
        pw.SizedBox(height: 4),
        pw.Container(height: 1.2, width: 36, color: _accent),
      ],
    );
  }

  static String _fmtTime(int minutes) {
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  /// Sehr einfache Markdown→Klartext-Reduktion (keine volle Markdown-Engine
  /// im PDF — Bilder/Links werden auf ihren Text reduziert, Formatierungs-
  /// Marker entfernt). Bewusst simpel gehalten, reicht für Rezept-Notizen.
  static String _stripMarkdown(String s) {
    var t = s;
    t = t.replaceAll(RegExp(r'!\[[^\]]*\]\([^)]*\)'), '');
    t = t.replaceAllMapped(
        RegExp(r'\[([^\]]*)\]\([^)]*\)'), (m) => m.group(1) ?? '');
    t = t.replaceAllMapped(RegExp(r'\*\*([^*]+)\*\*'), (m) => m.group(1) ?? '');
    t = t.replaceAllMapped(RegExp(r'__([^_]+)__'), (m) => m.group(1) ?? '');
    t = t.replaceAllMapped(RegExp(r'\*([^*]+)\*'), (m) => m.group(1) ?? '');
    t = t.replaceAll(RegExp(r'^#{1,6}\s*', multiLine: true), '');
    t = t.replaceAll(RegExp(r'^>\s?', multiLine: true), '');
    t = t.replaceAll('`', '');
    return t.trim();
  }

  static String _sanitizeFileName(String name) {
    final cleaned = name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '-').trim();
    return cleaned.isEmpty ? 'Rezept' : cleaned;
  }
}
