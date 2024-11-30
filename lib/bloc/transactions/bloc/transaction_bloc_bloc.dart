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
        emit(TransactionLoading());

        final box = await Hive.openBox<TransactionModel>('transactions');
        final transactions = box.values.toList();

        // Sort by date, newest first
        transactions.sort((a, b) => b.date.compareTo(a.date));

        emit(TransactionLoaded(transactions));
      } catch (e, stack) {
        logger.e('Error loading transactions', error: e, stackTrace: stack);
        emit(TransactionError('Failed to load transactions'));
      }
    });

    on<AddTransactionEvent>((event, emit) async {
      try {
        final box = await Hive.openBox<TransactionModel>('transactions');
        await box.put(event.transaction.id, event.transaction);

        final transactions = box.values.toList()
          ..sort((a, b) => b.date.compareTo(a.date));

        emit(TransactionLoaded(transactions));
      } catch (e, stack) {
        logger.e('Error adding transaction', error: e, stackTrace: stack);
        emit(TransactionError('Failed to add transaction'));
      }
    });

    on<FilterTransactionsEvent>((event, emit) async {
      try {
        final box = await Hive.openBox<TransactionModel>('transactions');
        var transactions = box.values.toList();

        final now = DateTime.now();
        switch (event.filter) {
          case 'Today':
            transactions = transactions
                .where((t) =>
                    t.date.year == now.year &&
                    t.date.month == now.month &&
                    t.date.day == now.day)
                .toList();
            break;
          case 'This Week':
            final weekStart = now.subtract(Duration(days: now.weekday - 1));
            transactions =
                transactions.where((t) => t.date.isAfter(weekStart)).toList();
            break;
          case 'This Month':
            transactions = transactions
                .where(
                    (t) => t.date.year == now.year && t.date.month == now.month)
                .toList();
            break;
        }

        transactions.sort((a, b) => b.date.compareTo(a.date));
        emit(TransactionLoaded(transactions));
      } catch (e, stack) {
        logger.e('Error filtering transactions', error: e, stackTrace: stack);
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
                t.amount.toString().contains(event.query))
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
