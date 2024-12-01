import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/daily_report_model.dart';
import 'package:flutter/services.dart';

class PdfService {
  static Future<File> generateDailyReport(DailyReport report) async {
    final pdf = pw.Document();

    // Use a Unicode-compatible font
    final ttf = await pw.Font.ttf(
        await rootBundle.load('assets/fonts/OpenSans-Regular.ttf'));

    // Create a base style with our custom font
    final baseStyle = pw.TextStyle(font: ttf);
    final boldStyle = pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold);

    // Add content to the PDF with Unicode font
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttf, // Use same font for bold text
        ),
        build: (context) => [
          _buildHeader(report, boldStyle, baseStyle),
          _buildSummary(report, boldStyle, baseStyle),
          _buildPaymentMethods(report, boldStyle, baseStyle),
          _buildTopItems(report, boldStyle, baseStyle),
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

  static pw.Widget _buildHeader(
      DailyReport report, pw.TextStyle boldStyle, pw.TextStyle baseStyle) {
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
            style: boldStyle.copyWith(fontSize: 24),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Date: ${report.date.toString().split(' ')[0]}',
            style: baseStyle.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummary(
      DailyReport report, pw.TextStyle boldStyle, pw.TextStyle baseStyle) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 20),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryCard(
            'Total Sales',
            '\$${report.totalSales.toStringAsFixed(2)}',
            boldStyle,
            baseStyle,
          ),
          _buildSummaryCard(
            'Transactions',
            report.transactionCount.toString(),
            boldStyle,
            baseStyle,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryCard(String title, String value,
      pw.TextStyle boldStyle, pw.TextStyle baseStyle) {
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
            style: boldStyle.copyWith(fontSize: 14),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            value,
            style: baseStyle.copyWith(fontSize: 20),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPaymentMethods(
      DailyReport report, pw.TextStyle boldStyle, pw.TextStyle baseStyle) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Payment Methods',
            style: boldStyle.copyWith(fontSize: 18),
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
                      style: baseStyle.copyWith(fontSize: 14),
                    ),
                    pw.Text(
                      '\$${entry.value.toStringAsFixed(2)}',
                      style: boldStyle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  static pw.Widget _buildTopItems(
      DailyReport report, pw.TextStyle boldStyle, pw.TextStyle baseStyle) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Top Selling Items',
            style: boldStyle.copyWith(fontSize: 18),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              // Header row
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey100),
                children: [
                  _buildTableCell('Item ID',
                      isHeader: true,
                      boldStyle: boldStyle,
                      baseStyle: baseStyle),
                  _buildTableCell('Quantity',
                      isHeader: true,
                      boldStyle: boldStyle,
                      baseStyle: baseStyle),
                ],
              ),
              // Data rows
              ...report.topSellingItems.map((item) => pw.TableRow(
                    children: [
                      _buildTableCell(item.id,
                          boldStyle: boldStyle, baseStyle: baseStyle),
                      _buildTableCell(item.quantity.toString(),
                          boldStyle: boldStyle, baseStyle: baseStyle),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTableCell(String text,
      {bool isHeader = false,
      pw.TextStyle? boldStyle,
      pw.TextStyle? baseStyle}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: isHeader ? boldStyle?.fontWeight : null,
          font: isHeader ? boldStyle?.font : baseStyle?.font,
        ),
      ),
    );
  }

  // ... other helper methods for PDF sections
}
