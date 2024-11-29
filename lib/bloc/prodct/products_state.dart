part of 'products_bloc.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class ProductLoading extends ProductsState {}

final class ProductLoaded extends ProductsState {
  final List<Product> products;

  ProductLoaded(this.products);
}

final class ProductError extends ProductsState {
  final String error;

  ProductError(this.error);
}

final class ProductAdding extends ProductsState {}

final class ProductAdded extends ProductsState {}

final class ProductAddingError extends ProductsState {
  final String error;

  ProductAddingError(this.error);
}
