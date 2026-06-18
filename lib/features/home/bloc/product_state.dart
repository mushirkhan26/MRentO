import 'package:equatable/equatable.dart';
import '../../../core/models/rental_product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

// Pagination ke liye — neeche loader dikhao
class ProductLoadingMore extends ProductState {
  final List<RentalProductModel> products;
  final String category;

  const ProductLoadingMore(this.products, this.category);

  @override
  List<Object?> get props => [products, category];
}

class ProductLoaded extends ProductState {
  final List<RentalProductModel> products;
  final String category;

  const ProductLoaded(this.products, this.category);

  @override
  List<Object?> get props => [products, category];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}