import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../model/birth_chart_models.dart';

class PdfService {
  static Future<void> generate(BirthChartReport report) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (context) => [
            // Header
            _buildHeader(report),
            pw.SizedBox(height: 16),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 16),

            // Birth Details
            _sectionTitle('Birth Details'),
            _infoRow('Name', report.name),
            _infoRow('Date & Time', _formatDateTime(report.dateTime)),
            _infoRow('Place', report.placeOfBirth),
            _infoRow('Nakshatra', '${report.birthDetails.nakshatra} (Pada ${report.birthDetails.nakshatraPada})'),
            _infoRow('Chandra Rasi', report.birthDetails.chandraRasi),
            _infoRow('Soorya Rasi', report.birthDetails.sooryaRasi),
            _infoRow('Zodiac (Ascendant)', report.birthDetails.zodiac),
            pw.SizedBox(height: 16),

            // Planet Positions Table
            _sectionTitle('Planet Positions'),
            _planetTable(report.planets, report.ascendant),
            pw.SizedBox(height: 16),

            // Dosha Section
            _sectionTitle('Dosha Analysis'),
            _infoRow('Mangal Dosha', report.mangalDosha.isManglik ? 'Yes (Manglik)' : 'No'),
            if (report.mangalDosha.description.isNotEmpty)
              pw.Text(report.mangalDosha.description, style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 6),
            _infoRow('Kaal Sarp Dosha', report.kaalSarp.hasDosha ? report.kaalSarp.doshaType : 'Not Present'),
            if (report.kaalSarp.description.isNotEmpty)
              pw.Text(report.kaalSarp.description, style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 16),

            // Yoga Details
            _sectionTitle('Yoga Details'),
            ..._buildYogaList(report.yogaDetails),
            pw.SizedBox(height: 16),

            // Vimsottari Dasha
            _sectionTitle('Vimsottari Dasha'),
            _dashaTimeline(report.dasha),
            pw.SizedBox(height: 16),

            // Sade Sati
            _sectionTitle('Sade Sati'),
            _infoRow('Status', report.sadeSati.isCurrentlyInSadeSati ? 'Active' : 'Not Active'),
            if (report.sadeSati.transitPhase.isNotEmpty)
              _infoRow('Phase', report.sadeSati.transitPhase),
            if (report.sadeSati.description.isNotEmpty)
              pw.Text(report.sadeSati.description, style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 16),

            // Kundli Chart (Text representation)
            _sectionTitle('Kundli Chart (Houses)'),
            _kundliChartText(report.planets),
          ],
        ),
      );

      // ✅ Save and share the PDF (download / save)
      final Uint8List bytes = await pdf.save();
      await Printing.sharePdf(
        bytes: bytes,
        filename: '${report.name}_Birth_Chart_Report.pdf',
      );
    } catch (e) {
      debugPrint('PDF generation error: $e');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────
  //  Helper widgets
  // ─────────────────────────────────────────────────────────────

  static pw.Widget _buildHeader(BirthChartReport report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          report.name,
          style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          'Birth Chart Report',
          style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
        ),
      ],
    );
  }

  static pw.Widget _sectionTitle(String title) {
    return pw.Column(
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Divider(thickness: 0.5),
        pw.SizedBox(height: 8),
      ],
    );
  }

  static pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }

  static pw.Widget _planetTable(List<Planet> planets, Planet? ascendant) {
    final headers = ['Planet', 'Rasi', 'Lord', 'Degree', 'Bhava'];
    final rows = <List<String>>[];

    for (final p in planets) {
      rows.add([
        p.name,
        p.rasi,
        p.rasiLord,
        p.degree.toStringAsFixed(2),
        p.position.toString(),
      ]);
    }

    if (ascendant != null) {
      rows.add([
        'Ascendant',
        ascendant.rasi,
        ascendant.rasiLord,
        ascendant.degree.toStringAsFixed(2),
        ascendant.position.toString(),
      ]);
    }

    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(2),
        3: pw.FlexColumnWidth(2),
        4: pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: headers.map((h) => _cell(h, bold: true)).toList(),
        ),
        ...rows.map((row) => pw.TableRow(
          children: row.map((cell) => _cell(cell)).toList(),
        )),
      ],
    );
  }

  static pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static List<pw.Widget> _buildYogaList(YogaResult yogaResult) {
    final list = <pw.Widget>[];

    void addYogas(String title, List<YogaInfo> yogas) {
      final present = yogas.where((y) => y.hasYoga).toList();
      if (present.isNotEmpty) {
        list.add(pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)));
        for (final y in present) {
          list.add(pw.Padding(
            padding: const pw.EdgeInsets.only(left: 12, top: 4),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('• ${y.name}', style:  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                if (y.description.isNotEmpty)
                  pw.Text(y.description, style: const pw.TextStyle(fontSize: 9)),
              ],
            ),
          ));
        }
        list.add(pw.SizedBox(height: 8));
      }
    }

    addYogas('Major Yogas', yogaResult.majorYogas);
    addYogas('Chandra Yogas', yogaResult.chandraYogas);
    addYogas('Soorya Yogas', yogaResult.sooryaYogas);
    addYogas('Inauspicious Yogas', yogaResult.inauspiciousYogas);

    if (list.isEmpty) {
      list.add(pw.Text('No significant yogas found.'));
    }
    return list;
  }

  static pw.Widget _dashaTimeline(DashaResult dasha) {
    final children = <pw.Widget>[
      pw.Text('Dasha Balance: ${dasha.dashaBalance}', style:  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 8),
    ];

    for (final m in dasha.mahadashas) {
      children.add(
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Row(
            children: [
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  m.lord,
                  style: m.isCurrentlyActive
                      ? pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.red)
                      : null,
                ),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Text('${m.start.year} - ${m.end.year}'),
              ),
            ],
          ),
        ),
      );
    }
    return pw.Column(children: children);
  }

  static pw.Widget _kundliChartText(List<Planet> planets) {
    // Group planets by house (1-12)
    final Map<int, List<String>> houseMap = {};
    for (final p in planets) {
      final house = p.position;
      houseMap.putIfAbsent(house, () => []).add(p.name);
    }

    final tableRows = <pw.TableRow>[];
    for (int i = 1; i <= 12; i += 3) {
      final row = [
        _houseCell(i, houseMap[i] ?? []),
        _houseCell(i + 1, houseMap[i + 1] ?? []),
        _houseCell(i + 2, houseMap[i + 2] ?? []),
      ];
      tableRows.add(pw.TableRow(children: row));
    }

    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      children: tableRows,
    );
  }

  static pw.Widget _houseCell(int houseNumber, List<String> planets) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Column(
        children: [
          pw.Text('House $houseNumber', style:  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ...planets.map((p) => pw.Text(p, style: const pw.TextStyle(fontSize: 9))),
        ],
      ),
    );
  }

  static String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}