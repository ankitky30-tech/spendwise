import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/expense.dart';

class ExportUtils {
  static Future<String> exportCSV(List<Expense> expenses) async {
    final rows = [
      ['Title', 'Amount', 'Category', 'Date', 'Note'],
      ...expenses.map((e) => [
        e.title,
        e.amount.toStringAsFixed(2),
        e.category,
        DateFormat('yyyy-MM-dd').format(e.date),
        e.note ?? '',
      ]),
    ];
    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/spendwise_export.csv';
    await File(path).writeAsString(csv);
    return path;
  }

  static Future<void> exportPDF(List<Expense> expenses, double total) async {
    final pdf = pw.Document();
    final fmt = DateFormat('MMM dd, yyyy');
    final currFmt = NumberFormat.currency(symbol: '\$');

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Header(level: 0, child: pw.Text('SpendWise — Expense Report',
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold))),
        pw.SizedBox(height: 8),
        pw.Text('Total: ${currFmt.format(total)}',
          style: const pw.TextStyle(fontSize: 14, color: PdfColors.purple700)),
        pw.SizedBox(height: 16),
        pw.Table.fromTextArray(
          headers: ['Title', 'Amount', 'Category', 'Date'],
          data: expenses.map((e) => [
            e.title,
            currFmt.format(e.amount),
            e.category,
            fmt.format(e.date),
          ]).toList(),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.purple700),
          cellHeight: 28,
          cellAlignments: {0: pw.Alignment.centerLeft},
        ),
      ],
    ));

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}