import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/daily_report_model.dart';

class PdfService {
  static Future<File> generateDailyReport(DailyReport report) async {
    final pdf = pw.Document();

    // Add content to the PDF with standard font
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _buildHeader(report),
          _buildSummary(report),
          _buildPaymentMethods(report),
          _buildTopItems(report),
        ],
      ),
    );

    // Save the PDF
    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/daily_report_${report.date.toString().split(' ')[0]}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildHeader(DailyReport report) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Daily Sales Report',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Date: ${report.date.toString().split(' ')[0]}',
            style: const pw.TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummary(DailyReport report) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 20),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryCard(
            'Total Sales',
            '\$${report.totalSales.toStringAsFixed(2)}',
          ),
          _buildSummaryCard(
            'Transactions',
            report.transactionCount.toString(),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryCard(String title, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPaymentMethods(DailyReport report) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Payment Methods',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          ...report.paymentMethodTotals.entries.map((entry) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 8),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      entry.key,
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                    pw.Text(
                      '\$${entry.value.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  static pw.Widget _buildTopItems(DailyReport report) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Top Selling Items',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              // Header row
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey100),
                children: [
                  _buildTableCell('Item ID', isHeader: true),
                  _buildTableCell('Quantity', isHeader: true),
                ],
              ),
              // Data rows
              ...report.topSellingItems.map((item) => pw.TableRow(
                    children: [
                      _buildTableCell(item.id),
                      _buildTableCell(item.quantity.toString()),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: isHeader ? pw.FontWeight.bold : null,
        ),
      ),
    );
  }

  // ... other helper methods for PDF sections
}
