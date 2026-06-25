import 'package:equatable/equatable.dart';
import '../../../core/models/rental_product_model.dart';
import '../widgets/rental_duration_selector.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

class ProductDetailsStarted extends ProductDetailsEvent {
  final String productId;
  final RentalProductModel? initialProduct;
  
  const ProductDetailsStarted({required this.productId, this.initialProduct});

  @override
  List<Object?> get props => [productId, initialProduct];
}

class ImageIndexChanged extends ProductDetailsEvent {
  final int newIndex;
  const ImageIndexChanged(this.newIndex);

  @override
  List<Object?> get props => [newIndex];
}

class RentalDurationChanged extends ProductDetailsEvent {
  final RentalDurationOption duration;
  const RentalDurationChanged(this.duration);

  @override
  List<Object?> get props => [duration];
}
