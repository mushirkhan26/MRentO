import 'package:equatable/equatable.dart';
import '../../../core/models/rental_product_model.dart'; // ← RentalProductModel

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();
  @override
  List<Object?> get props => [];
}

class LoadWishlist extends WishlistEvent {}

class ToggleWishlist extends WishlistEvent {
  final RentalProductModel product; // ← updated
  const ToggleWishlist(this.product);
  @override
  List<Object?> get props => [product];
}

class ClearWishlist extends WishlistEvent {}