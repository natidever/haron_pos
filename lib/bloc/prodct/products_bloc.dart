import 'package:hive/hive.dart';
import 'package:bloc/bloc.dart';
import 'package:haron_pos/models/product_model.dart';
import 'package:haron_pos/utils/logger.dart';
import 'package:meta/meta.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsInitial()) {
    on<LoadProductsEvent>((event, emit) async {
      try {
        logger.i('Loading products from database');
        emit(ProductLoading());

        final box = await Hive.openBox<Product>('products');
        final products = box.values.toList();

        logger.i('Loaded ${products.length} products');
        emit(ProductLoaded(products));
      } catch (e, stackTrace) {
        logger.e('Error loading products', error: e, stackTrace: stackTrace);
        emit(ProductError(e.toString()));
      }
    });

    on<AddProductEvent>((event, emit) async {
      try {
        emit(ProductAdding());

        // Get the products box
        final box = await Hive.openBox<Product>('products');

        // Generate a unique ID
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        logger.d('Generated product ID: $id');

        final productWithId = Product(
          id: id,
          name: event.product.name,
          image: event.product.image,
          category: event.product.category,
          price: event.product.price,
          description: event.product.description,
          quantityInStock: event.product.quantityInStock,
          sku: event.product.sku,
          barcode: event.product.barcode,
          supplier: event.product.supplier,
          discount: event.product.discount,
          taxRate: event.product.taxRate,
        );
        logger.i('Saving product to Hive: ${productWithId.name}');
        await box.put(id, productWithId);

        logger.i('Product successfully added to database');
        emit(ProductAdded());

        // After adding, reload the products
        final products = box.values.toList();
        emit(ProductLoaded(products));
      } catch (e, stackTrace) {
        logger.e('Error adding product', error: e, stackTrace: stackTrace);
        emit(ProductAddingError(e.toString()));
      }
    });

    on<ClearProductsEvent>((event, emit) async {
      try {
        logger.i('Clearing all products from database');
        emit(ProductLoading());

        final box = await Hive.openBox<Product>('products');
        await box.clear(); // This will delete all products

        logger.i('All products cleared from database');
        emit(ProductLoaded([]));
      } catch (e, stackTrace) {
        logger.e('Error clearing products', error: e, stackTrace: stackTrace);
        emit(ProductError(e.toString()));
      }
    });
  }
}
