part of 'transaction_bloc_bloc.dart';

@immutable
sealed class TransactionBlocEvent {}

class LoadTransactionsEvent extends TransactionBlocEvent {}

class AddTransactionEvent extends TransactionBlocEvent {
  final TransactionModel transaction;

  AddTransactionEvent(this.transaction);
}

class FilterTransactionsEvent extends TransactionBlocEvent {
  final String filter;

  FilterTransactionsEvent(this.filter);
}

class SearchTransactionsEvent extends TransactionBlocEvent {
  final String query;

  SearchTransactionsEvent(this.query);
}
