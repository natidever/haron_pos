import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/bloc/theme/theme_bloc.dart';
// import 'package:haron_pos/bloc/transactions/bloc/transaction_bloc.dart';
import 'package:haron_pos/bloc/transactions/bloc/transaction_bloc_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haron_pos/reports/models/daily_report_model.dart';
import 'package:haron_pos/reports/services/pdf_service.dart';
import 'package:haron_pos/reports/widgets/report_dialog.dart';
import 'package:logger/logger.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  var logger = Logger();
  late TransactionDataSource _transactionDataSource;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(LoadTransactionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Transactions',
              style: GoogleFonts.poppins(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                child: ElevatedButton.icon(
                  onPressed: () => _generateReport(context),
                  icon: const Icon(
                    Icons.summarize_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    'Generate Report',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: theme.primaryColor.withOpacity(0.3),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: BlocBuilder<TransactionBloc, TransactionBlocState>(
            builder: (context, state) {
              if (state is TransactionLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is TransactionError) {
                return Center(
                  child: Text(
                    state.message,
                    style: GoogleFonts.poppins(color: Colors.red),
                  ),
                );
              }

              if (state is TransactionLoaded) {
                if (state.transactions.isEmpty &&
                    _selectedFilter == 'All Transactions') {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.receipt_long_outlined,
                              size: 88,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'No Transactions Yet',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'Complete your first sale to see transaction history',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                _transactionDataSource = TransactionDataSource(
                  transactions: state.transactions
                      .map((transaction) => TransactionData(
                            date: transaction.date,
                            transactionId: transaction.transactionId,
                            amount: transaction.amount,
                            status: transaction.status,
                          ))
                      .toList(),
                  context: context,
                );

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Transaction Summary Cards
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                _buildSummaryCard(
                                  context,
                                  'Total Transactions',
                                  state.transactions.length.toString(),
                                  Icons.receipt_long_rounded,
                                ),
                                const SizedBox(width: 8),
                                _buildSummaryCard(
                                  context,
                                  'Total Amount',
                                  '\$${state.transactions.fold(0.0, (sum, item) => sum + item.amount).toStringAsFixed(2)}',
                                  Icons.account_balance_wallet_rounded,
                                ),
                                const SizedBox(width: 8),
                                _buildSummaryCard(
                                  context,
                                  'Completed',
                                  state.transactions
                                      .where((t) =>
                                          t.status.toLowerCase() == 'completed')
                                      .length
                                      .toString(),
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Filter Button (existing code)
                          Container(
                            constraints: const BoxConstraints(maxWidth: 180),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.shadowColor,
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: PopupMenuButton<String>(
                              onSelected: (value) {
                                setState(() {
                                  _selectedFilter = value;
                                });
                                context
                                    .read<TransactionBloc>()
                                    .add(FilterTransactionsEvent(value));
                              },
                              color: theme.cardColor,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.filter_list_rounded,
                                      color: theme.primaryColor,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        'Filter: $_selectedFilter',
                                        style: GoogleFonts.poppins(
                                          color: theme.colorScheme.onBackground,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: theme.primaryColor,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                              itemBuilder: (context) => [
                                'All Transactions',
                                'Last Minute',
                                'Today',
                                'Yesterday',
                                'This Week',
                                'Last Week',
                                'This Month',
                                'Last Month',
                                'Last 3 Months',
                                'This Year',
                                'Completed',
                                'Pending',
                                'Failed'
                              ]
                                  .map((filter) => PopupMenuItem(
                                        value: filter,
                                        child: Row(
                                          children: [
                                            Icon(
                                              _getFilterIcon(filter),
                                              size: 18,
                                              color: theme
                                                  .colorScheme.onBackground
                                                  .withOpacity(0.6),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              filter,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: theme
                                                    .colorScheme.onBackground,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor,
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: state.transactions.isEmpty
                            ? Center(
                                child: Text(
                                  'No transactions found for selected filter',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: theme.colorScheme.onBackground
                                        .withOpacity(0.6),
                                  ),
                                ),
                              )
                            : SfDataGridTheme(
                                data: SfDataGridThemeData(
                                  headerColor: theme.colorScheme.surface,
                                  gridLineColor: theme.dividerColor,
                                  gridLineStrokeWidth: 1,
                                  selectionColor:
                                      theme.primaryColor.withOpacity(0.1),
                                  rowHoverColor: theme.hoverColor,
                                  rowHoverTextStyle: GoogleFonts.poppins(
                                    color: theme.colorScheme.onBackground,
                                  ),
                                ),
                                child: SfDataGrid(
                                  source: _transactionDataSource,
                                  columnWidthMode: ColumnWidthMode.fill,
                                  gridLinesVisibility: GridLinesVisibility.both,
                                  headerGridLinesVisibility:
                                      GridLinesVisibility.both,
                                  rowHeight: 70,
                                  columns: [
                                    GridColumn(
                                      columnName: 'date',
                                      width: 150,
                                      label: _buildColumnHeader(
                                        'Date & Time',
                                        Icons.calendar_today,
                                        theme,
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'transactionId',
                                      width: 140,
                                      label: _buildColumnHeader(
                                        'Transaction ID',
                                        Icons.tag,
                                        theme,
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'amount',
                                      width: 120,
                                      label: _buildColumnHeader(
                                        'Amount',
                                        Icons.attach_money,
                                        theme,
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'status',
                                      width: 120,
                                      label: _buildColumnHeader(
                                        'Status',
                                        Icons.info_outline,
                                        theme,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        );
      },
    );
  }

  Future<void> _generateReport(BuildContext context) async {
    try {
      final report = DailyReport.fromTransactions(
        (context.read<TransactionBloc>().state as TransactionLoaded)
            .transactions,
      );

      final pdfFile = await PdfService.generateDailyReport(report);

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => ReportDialog(
            pdfFile: pdfFile,
          ),
        );
      }
    } catch (e, stack) {
      logger.e('Error generating report', error: e, stackTrace: stack);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error generating report',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  IconData _getFilterIcon(String filter) {
    switch (filter) {
      case 'Last Minute':
        return Icons.timer_outlined;
      case 'All Transactions':
        return Icons.all_inbox_rounded;
      case 'Today':
        return Icons.today_rounded;
      case 'Yesterday':
        return Icons.history_rounded;
      case 'This Week':
        return Icons.calendar_view_week_rounded;
      case 'Last Week':
        return Icons.calendar_view_week_outlined;
      case 'This Month':
        return Icons.calendar_month_rounded;
      case 'Last Month':
        return Icons.calendar_month_outlined;
      case 'Last 3 Months':
        return Icons.calendar_today_rounded;
      case 'This Year':
        return Icons.calendar_view_month_rounded;
      case 'Completed':
        return Icons.check_circle_outline_rounded;
      case 'Pending':
        return Icons.pending_outlined;
      case 'Failed':
        return Icons.error_outline_rounded;
      default:
        return Icons.filter_list_rounded;
    }
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon, {
    Color? color,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: (color ?? theme.primaryColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color ?? theme.primaryColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      color: theme.colorScheme.onBackground,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnHeader(String title, IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.onBackground.withOpacity(0.6),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionDataSource extends DataGridSource {
  final List<TransactionData> transactions;
  final BuildContext context;

  TransactionDataSource({
    required this.transactions,
    required this.context,
  }) {
    dataGridRows = transactions
        .map<DataGridRow>((transaction) => DataGridRow(cells: [
              DataGridCell<DateTime>(
                columnName: 'date',
                value: transaction.date,
              ),
              DataGridCell<String>(
                columnName: 'transactionId',
                value: transaction.transactionId,
              ),
              DataGridCell<double>(
                columnName: 'amount',
                value: transaction.amount,
              ),
              DataGridCell<String>(
                columnName: 'status',
                value: transaction.status,
              ),
            ]))
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final theme = Theme.of(context);

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        // Base text style
        final baseTextStyle = GoogleFonts.poppins(
          color: theme.colorScheme.onBackground,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        );

        switch (cell.columnName) {
          case 'date':
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.center,
              child: Text(
                DateFormat('MMM dd, yyyy\nhh:mm a')
                    .format(cell.value as DateTime),
                style: baseTextStyle.copyWith(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            );

          case 'amount':
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.center,
              child: Text(
                '\$${(cell.value as double).toStringAsFixed(2)}',
                style: baseTextStyle,
                textAlign: TextAlign.center,
              ),
            );

          case 'status':
            final status = (cell.value as String).toLowerCase();
            final color = _getStatusColor(status);

            return Container(
              padding: const EdgeInsets.all(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  cell.value.toString(),
                  style: baseTextStyle.copyWith(
                    color: color,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );

          default:
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.center,
              child: Text(
                cell.value.toString(),
                style: baseTextStyle,
                textAlign: TextAlign.center,
              ),
            );
        }
      }).toList(),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class TransactionData {
  final DateTime date;
  final String transactionId;
  final double amount;
  final String status;

  TransactionData({
    required this.date,
    required this.transactionId,
    required this.amount,
    required this.status,
  });
}
