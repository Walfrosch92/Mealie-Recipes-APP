import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/mealplan_entry.dart';
import '../models/shopping_item.dart';

// ---------------------------------------------------------------------------
// Drucken (Desktop, System-Druckdialog über das Paket `printing`): schlichte
// A4-PDFs für Einkaufsliste und Wochenplan. Rezepte druckt
// RecipePdfService.printRecipe (dasselbe PDF wie „Als PDF exportieren").
// ---------------------------------------------------------------------------

const _accent = PdfColor.fromInt(0xFFFF8A00);
const _textSub = PdfColor.fromInt(0xFF666666);
const _line = PdfColor.fromInt(0xFFDDDDDD);

Future<(pw.Font, pw.Font)> _fonts() async {
  final base =
      pw.Font.ttf(await rootBundle.load('assets/fonts/Inter-Variable.ttf'));
  final heading = pw.Font.ttf(
      await rootBundle.load('assets/fonts/PlusJakartaSans-Variable.ttf'));
  return (base, heading);
}

pw.Widget _title(String text, String? subtitle, pw.Font heading) =>
    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text(text,
          style: pw.TextStyle(font: heading, fontSize: 22, color: _accent)),
      if (subtitle != null) ...[
        pw.SizedBox(height: 2),
        pw.Text(subtitle,
            style: const pw.TextStyle(fontSize: 11, color: _textSub)),
      ],
      pw.SizedBox(height: 14),
    ]);

/// Offene Artikel der Einkaufsliste, nach Abteilung gruppiert, mit Kästchen
/// zum Abhaken auf Papier.
Future<void> printShoppingList({
  required String title,
  required List<ShoppingItem> items,
  required String otherLabel,
}) async {
  final (base, heading) = await _fonts();
  final open = items.where((i) => !i.checked).toList();
  final groups = <String, List<ShoppingItem>>{};
  for (final i in open) {
    final name = (i.label?.name.trim().isNotEmpty ?? false)
        ? i.label!.name.trim()
        : otherLabel;
    groups.putIfAbsent(name, () => []).add(i);
  }
  final names = groups.keys.toList()
    ..sort((a, b) => a == otherLabel
        ? 1
        : b == otherLabel
            ? -1
            : a.toLowerCase().compareTo(b.toLowerCase()));

  final doc = pw.Document();
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4.copyWith(
        marginLeft: 36, marginRight: 36, marginTop: 36, marginBottom: 36),
    theme: pw.ThemeData.withFont(base: base, bold: heading),
    build: (ctx) => [
      _title(title, null, heading),
      for (final g in names) ...[
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8, bottom: 4),
          child: pw.Text(g.toUpperCase(),
              style: pw.TextStyle(
                  font: heading,
                  fontSize: 10,
                  color: _textSub,
                  letterSpacing: 1)),
        ),
        for (final i in groups[g]!)
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 5),
            decoration: const pw.BoxDecoration(
                border:
                    pw.Border(bottom: pw.BorderSide(color: _line, width: .5))),
            child: pw.Row(children: [
              pw.Container(
                width: 11,
                height: 11,
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: _textSub, width: .8),
                    borderRadius: pw.BorderRadius.circular(2)),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                  child: pw.Text(i.displayName,
                      style: const pw.TextStyle(fontSize: 12))),
            ]),
          ),
      ],
    ],
  ));
  await Printing.layoutPdf(name: title, onLayout: (_) => doc.save());
}

/// Wochenplan als Aushang: sieben Tage, je Tag die Mahlzeiten.
Future<void> printWeekPlan({
  required String title,
  required String subtitle,
  required List<(String dayLabel, List<MealplanEntry> entries)> days,
  required String Function(String type) mealLabel,
  required String emptyLabel,
}) async {
  final (base, heading) = await _fonts();
  final doc = pw.Document();
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4.copyWith(
        marginLeft: 36, marginRight: 36, marginTop: 36, marginBottom: 36),
    theme: pw.ThemeData.withFont(base: base, bold: heading),
    build: (ctx) => [
      _title(title, subtitle, heading),
      for (final (label, entries) in days)
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 8),
          decoration: const pw.BoxDecoration(
              border:
                  pw.Border(bottom: pw.BorderSide(color: _line, width: .5))),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                width: 130,
                child: pw.Text(label,
                    style: pw.TextStyle(font: heading, fontSize: 12)),
              ),
              pw.Expanded(
                child: entries.isEmpty
                    ? pw.Text(emptyLabel,
                        style:
                            const pw.TextStyle(fontSize: 11, color: _textSub))
                    : pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          for (final e in entries)
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(bottom: 3),
                              child: pw.RichText(
                                text: pw.TextSpan(children: [
                                  pw.TextSpan(
                                      text: '${mealLabel(e.entryType)}: ',
                                      style: const pw.TextStyle(
                                          fontSize: 11, color: _textSub)),
                                  pw.TextSpan(
                                      text: e.recipe?.name ??
                                          e.title ??
                                          e.text ??
                                          '—',
                                      style: const pw.TextStyle(fontSize: 12)),
                                ]),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
    ],
  ));
  await Printing.layoutPdf(name: title, onLayout: (_) => doc.save());
}
