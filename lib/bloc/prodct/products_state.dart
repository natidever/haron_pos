part of 'products_bloc.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class ProductLoading extends ProductsState {}

final class ProductLoaded extends ProductsState {}

final class ProductError extends ProductsState {}
