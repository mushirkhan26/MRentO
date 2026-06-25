import 'package:equatable/equatable.dart';
import '../../../core/models/rental_product_model.dart';
import '../widgets/rental_duration_selector.dart';

enum ProductDetailsStatus { initial, loading, loaded, error }

class ProductDetailsState extends Equatable {
  final ProductDetailsStatus status;
  final RentalProductModel? product;
  final int selectedImageIndex;
  final RentalDurationOption? selectedDuration;
  final List<RentalDurationOption> availableDurations;
  final String? errorMessage;

  const ProductDetailsState({
    this.status = ProductDetailsStatus.initial,
    this.product,
    this.selectedImageIndex = 0,
    this.selectedDuration,
    this.availableDurations = const [],
    this.errorMessage,
  });

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    RentalProductModel? product,
    int? selectedImageIndex,
    RentalDurationOption? selectedDuration,
    List<RentalDurationOption>? availableDurations,
    String? errorMessage,
  }) {
    return ProductDetailsState(
      status: status ?? this.status,
      product: product ?? this.product,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      selectedDuration: selectedDuration ?? this.selectedDuration,
      availableDurations: availableDurations ?? this.availableDurations,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, product, selectedImageIndex, selectedDuration, availableDurations, errorMessage];
}
