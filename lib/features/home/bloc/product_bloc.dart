import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/firestore_product_service.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FirestoreProductService _productService;

  ProductBloc({FirestoreProductService? productService})
      : _productService = productService ?? FirestoreProductService(),
        super(ProductInitial()) {
    on<FetchProductsByCategory>(_onFetchProductsByCategory);
    on<FetchMoreProducts>(_onFetchMoreProducts);
  }

  Future<void> _onFetchProductsByCategory(
      FetchProductsByCategory event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductLoading());

    final response = await _productService.getProductsByCategory(
      categoryId: event.category.toLowerCase(),
    );

    if (response.success && response.data != null) {
      emit(ProductLoaded(response.data!, event.category));
    } else {
      emit(ProductError(response.message ?? 'Products load nahi hue'));
    }
  }

  Future<void> _onFetchMoreProducts(
      FetchMoreProducts event,
      Emitter<ProductState> emit,
      ) async {
    if (state is! ProductLoaded) return;
    final currentState = state as ProductLoaded;

    // Loading indicator show karo neeche
    emit(ProductLoadingMore(currentState.products, currentState.category));

    final response = await _productService.getProductsByCategory(
      categoryId: event.category.toLowerCase(),
      lastDoc: event.lastDoc,
    );

    if (response.success && response.data != null) {
      emit(ProductLoaded(
        [...currentState.products, ...response.data!],
        currentState.category,
      ));
    } else {
      // Error pe purani list wapas
      emit(ProductLoaded(currentState.products, currentState.category));
    }
  }
}