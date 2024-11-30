part of 'transaction_bloc_bloc.dart';

@immutable
sealed class TransactionBlocState {}

final class TransactionBlocInitial extends TransactionBlocState {}

final class TransactionLoading extends TransactionBlocState {}

final class TransactionLoaded extends TransactionBlocState {
  final List<TransactionModel> transactions;

  TransactionLoaded(this.transactions);
}

final class TransactionError extends TransactionBlocState {
  final String message;

  TransactionError(this.message);
}
