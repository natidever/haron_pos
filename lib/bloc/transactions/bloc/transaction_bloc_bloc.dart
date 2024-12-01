import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:haron_pos/models/transaction_model.dart';
import 'package:haron_pos/utils/logger.dart';

part 'transaction_bloc_event.dart';
part 'transaction_bloc_state.dart';

class TransactionBloc extends Bloc<TransactionBlocEvent, TransactionBlocState> {
  TransactionBloc() : super(TransactionBlocInitial()) {
    on<LoadTransactionsEvent>((event, emit) async {
      try {
        logger.i('Loading all transactions');
        emit(TransactionLoading());

        final box = await Hive.openBox<TransactionModel>('transactions');
        final transactions = box.values.toList();
        logger.d('Loaded ${transactions.length} transactions from box');

        transactions.sort((a, b) => b.date.compareTo(a.date));
        logger.i('Emitting ${transactions.length} sorted transactions');

        emit(TransactionLoaded(transactions));
      } catch (e, stack) {
        logger.e('Error loading transactions', error: e, stackTrace: stack);
        emit(TransactionError('Failed to load transactions'));
      }
    });

    on<AddTransactionEvent>((event, emit) async {
      try {
        logger.i('Adding new transaction: ${event.transaction.transactionId}');
        final box = await Hive.openBox<TransactionModel>('transactions');
        await box.put(event.transaction.id, event.transaction);
        logger.d('Transaction saved to box');

        final transactions = box.values.toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        logger.i('Emitting ${transactions.length} transactions after add');

        emit(TransactionLoaded(transactions));
      } catch (e, stack) {
        logger.e('Error adding transaction', error: e, stackTrace: stack);
        emit(TransactionError('Failed to add transaction'));
      }
    });

    on<FilterTransactionsEvent>((event, emit) async {
      try {
        logger.i('Starting filter: ${event.filter}');
        final box = await Hive.openBox<TransactionModel>('transactions');
        var transactions = box.values.toList();
        logger.d('Initial transactions count: ${transactions.length}');

        final now = DateTime.now();
        switch (event.filter) {
          case 'Last Minute':
            final oneMinuteAgo = now.subtract(const Duration(minutes: 1));
            logger.d('Filtering from: ${oneMinuteAgo.toString()}');
            transactions = transactions
                .where((t) => t.date.isAfter(oneMinuteAgo))
                .toList();
            logger.d(
                'After Last Minute filter: ${transactions.length} transactions');
            break;
          case 'All Transactions':
            logger.d('No filtering applied - showing all transactions');
            break;
          case 'Today':
            logger.d('Filtering for date: ${now.toString().split(' ')[0]}');
            transactions = transactions
                .where((t) =>
                    t.date.year == now.year &&
                    t.date.month == now.month &&
                    t.date.day == now.day)
                .toList();
            logger.d('After Today filter: ${transactions.length} transactions');
            break;
          case 'Yesterday':
            final yesterday = now.subtract(const Duration(days: 1));
            transactions = transactions
                .where((t) =>
                    t.date.year == yesterday.year &&
                    t.date.month == yesterday.month &&
                    t.date.day == yesterday.day)
                .toList();
            break;
          case 'This Week':
            final weekStart = now.subtract(Duration(days: now.weekday - 1));
            transactions =
                transactions.where((t) => t.date.isAfter(weekStart)).toList();
            break;
          case 'Last Week':
            final lastWeekStart = now.subtract(Duration(days: now.weekday + 6));
            final lastWeekEnd = now.subtract(Duration(days: now.weekday));
            transactions = transactions
                .where((t) =>
                    t.date.isAfter(lastWeekStart) &&
                    t.date.isBefore(lastWeekEnd))
                .toList();
            break;
          case 'This Month':
            transactions = transactions
                .where(
                    (t) => t.date.year == now.year && t.date.month == now.month)
                .toList();
            break;
          case 'Last Month':
            final lastMonth = DateTime(now.year, now.month - 1);
            transactions = transactions
                .where((t) =>
                    t.date.year == lastMonth.year &&
                    t.date.month == lastMonth.month)
                .toList();
            break;
          case 'Last 3 Months':
            final threeMonthsAgo = DateTime(now.year, now.month - 3);
            transactions = transactions
                .where((t) => t.date.isAfter(threeMonthsAgo))
                .toList();
            break;
          case 'This Year':
            transactions =
                transactions.where((t) => t.date.year == now.year).toList();
            break;
          case 'Completed':
            transactions = transactions
                .where((t) => t.status.toLowerCase() == 'completed')
                .toList();
            break;
          case 'Pending':
            transactions = transactions
                .where((t) => t.status.toLowerCase() == 'pending')
                .toList();
            break;
          case 'Failed':
            transactions = transactions
                .where((t) => t.status.toLowerCase() == 'failed')
                .toList();
            break;
        }

        logger.d('Sorting ${transactions.length} transactions by date');
        transactions.sort((a, b) => b.date.compareTo(a.date));

        logger
            .i('Filter complete. Emitting ${transactions.length} transactions');
        emit(TransactionLoaded(transactions));
      } catch (e, stack) {
        logger.e('Error filtering transactions', error: e, stackTrace: stack);
        logger.e('Filter that caused error: ${event.filter}');
        emit(TransactionError('Failed to filter transactions'));
      }
    });

    on<SearchTransactionsEvent>((event, emit) async {
      try {
        final box = await Hive.openBox<TransactionModel>('transactions');
        var transactions = box.values
            .where((t) =>
                t.transactionId
                    .toLowerCase()
                    .contains(event.query.toLowerCase()) ||
                t.amount.toString().contains(event.query) ||
                t.status.toLowerCase().contains(event.query.toLowerCase()))
            .toList();

        transactions.sort((a, b) => b.date.compareTo(a.date));
        emit(TransactionLoaded(transactions));
      } catch (e, stack) {
        logger.e('Error searching transactions', error: e, stackTrace: stack);
        emit(TransactionError('Failed to search transactions'));
      }
    });
  }
}
