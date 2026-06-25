import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/firestore_product_service.dart';
import '../../../core/models/rental_product_model.dart';
import '../widgets/rental_duration_selector.dart';
import 'product_details_event.dart';
import 'product_details_state.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final FirestoreProductService _productService;

  ProductDetailsBloc({FirestoreProductService? productService})
      : _productService = productService ?? FirestoreProductService(),
        super(const ProductDetailsState()) {
    on<ProductDetailsStarted>(_onStarted);
    on<ImageIndexChanged>(_onImageIndexChanged);
    on<RentalDurationChanged>(_onRentalDurationChanged);
  }

  Future<void> _onStarted(ProductDetailsStarted event, Emitter<ProductDetailsState> emit) async {
    // If we have initial product data, show it immediately but still fetch fresh data
    if (event.initialProduct != null) {
      final durations = _getDurations(event.initialProduct!);
      emit(state.copyWith(
        status: ProductDetailsStatus.loaded,
        product: event.initialProduct,
        availableDurations: durations,
        selectedDuration: durations.isNotEmpty ? durations.first : null,
      ));
    } else {
      emit(state.copyWith(status: ProductDetailsStatus.loading));
    }

    final response = await _productService.getProductById(event.productId);

    if (response.success && response.data != null) {
      final product = response.data!;
      final durations = _getDurations(product);
      
      emit(state.copyWith(
        status: ProductDetailsStatus.loaded,
        product: product,
        availableDurations: durations,
        selectedDuration: state.selectedDuration ?? (durations.isNotEmpty ? durations.first : null),
      ));
    } else {
      if (state.product == null) {
        emit(state.copyWith(
          status: ProductDetailsStatus.error,
          errorMessage: response.message,
        ));
      }
    }
  }

  List<RentalDurationOption> _getDurations(RentalProductModel product) {
    final List<RentalDurationOption> options = [];
    if (product.rentPerDay != null) {
      options.add(RentalDurationOption(
        label: '1 Din',
        days: 1,
        price: product.rentPerDay!,
        savings: 0,
      ));
    }
    if (product.rentFor3Days != null) {
      options.add(RentalDurationOption(
        label: '3 Din',
        days: 3,
        price: product.rentFor3Days!,
        savings: product.calculateSavingsPercentage(product.rentFor3Days!, 3),
      ));
    }
    if (product.rentPerWeek != null) {
      options.add(RentalDurationOption(
        label: '1 Hafta',
        days: 7,
        price: product.rentPerWeek!,
        savings: product.calculateSavingsPercentage(product.rentPerWeek!, 7),
      ));
    }
    return options;
  }

  void _onImageIndexChanged(ImageIndexChanged event, Emitter<ProductDetailsState> emit) {
    emit(state.copyWith(selectedImageIndex: event.newIndex));
  }

  void _onRentalDurationChanged(RentalDurationChanged event, Emitter<ProductDetailsState> emit) {
    emit(state.copyWith(selectedDuration: event.duration));
  }
}
