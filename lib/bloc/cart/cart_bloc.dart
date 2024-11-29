import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haron_pos/models/product_model.dart';
import 'package:logger/logger.dart';
import '../../models/cart_item.dart';
import '../../utils/logger.dart';

// Events
abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final Product product;
  final int quantity;

  AddToCartEvent(this.product, this.quantity);
}

class RemoveFromCartEvent extends CartEvent {
  final Product product;
  RemoveFromCartEvent(this.product);
}

class UpdateQuantityEvent extends CartEvent {
  final Product product;
  final int quantity;

  UpdateQuantityEvent(this.product, this.quantity);
}

class SelectPaymentMethodEvent extends CartEvent {
  final String method;
  SelectPaymentMethodEvent(this.method);
}

class ClearCartEvent extends CartEvent {}

// States
abstract class CartState {
  final List<CartItem> items;
  final double total;
  final String selectedPaymentMethod;

  CartState({
    required this.items,
    required this.total,
    this.selectedPaymentMethod = '',
  });
}

class CartInitial extends CartState {
  CartInitial() : super(items: [], total: 0, selectedPaymentMethod: '');
}

class CartUpdated extends CartState {
  CartUpdated({
    required List<CartItem> items,
    required double total,
    String selectedPaymentMethod = '',
  }) : super(
          items: items,
          total: total,
          selectedPaymentMethod: selectedPaymentMethod,
        );
}

class CartBloc extends Bloc<CartEvent, CartState> {
  final logger = Logger();

  CartBloc() : super(CartInitial()) {
    on<AddToCartEvent>((event, emit) {
      try {
        logger.i('Adding product to cart: ${event.product.name}');
        final currentItems = List<CartItem>.from(state.items);
        logger.d('Current items in cart: ${currentItems.length}');

        final existingItemIndex = currentItems
            .indexWhere((item) => item.product.id == event.product.id);

        if (existingItemIndex != -1) {
          logger.d('Updating existing item quantity');
          currentItems[existingItemIndex].quantity += event.quantity;
        } else {
          logger.d('Adding new item to cart');
          currentItems.add(CartItem(
            product: event.product,
            quantity: event.quantity,
          ));
        }

        final total = _calculateTotal(currentItems);
        logger.i('Cart updated - Items: ${currentItems.length}, Total: $total');

        emit(CartUpdated(
          items: currentItems,
          total: total,
          selectedPaymentMethod: state.selectedPaymentMethod,
        ));
      } catch (e, stackTrace) {
        logger.e('Error adding to cart', error: e, stackTrace: stackTrace);
      }
    });

    on<RemoveFromCartEvent>((event, emit) {
      try {
        final currentItems = List<CartItem>.from(state.items);
        currentItems.removeWhere((item) => item.product.id == event.product.id);

        final total = _calculateTotal(currentItems);
        logger.i('Product removed from cart: ${event.product.name}');
        emit(CartUpdated(
          items: currentItems,
          total: total,
          selectedPaymentMethod: state.selectedPaymentMethod,
        ));
      } catch (e, stackTrace) {
        logger.e('Error removing from cart', error: e, stackTrace: stackTrace);
      }
    });

    on<UpdateQuantityEvent>((event, emit) {
      try {
        final currentItems = List<CartItem>.from(state.items);
        final index = currentItems
            .indexWhere((item) => item.product.id == event.product.id);

        if (index != -1) {
          if (event.quantity <= 0) {
            currentItems.removeAt(index);
          } else {
            currentItems[index].quantity = event.quantity;
          }

          final total = _calculateTotal(currentItems);
          logger.i('Cart quantity updated for: ${event.product.name}');
          emit(CartUpdated(
            items: currentItems,
            total: total,
            selectedPaymentMethod: state.selectedPaymentMethod,
          ));
        }
      } catch (e, stackTrace) {
        logger.e('Error updating quantity', error: e, stackTrace: stackTrace);
      }
    });

    on<SelectPaymentMethodEvent>((event, emit) {
      emit(CartUpdated(
        items: state.items,
        total: state.total,
        selectedPaymentMethod: event.method,
      ));
      logger.i('Payment method selected: ${event.method}');
    });

    on<ClearCartEvent>((event, emit) {
      logger.i('Clearing cart');
      emit(CartUpdated(
        items: [],
        total: 0,
        selectedPaymentMethod: '',
      ));
    });
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold(0, (total, item) => total + item.totalWithTax);
  }
}
