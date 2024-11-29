part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}

final class AddProductEvent extends ProductsEvent {
  final Product product;

  AddProductEvent(this.product);
}

final class LoadProductsEvent extends ProductsEvent {}

final class ClearProductsEvent extends ProductsEvent {}
