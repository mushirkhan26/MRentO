import 'package:equatable/equatable.dart';
import '../../../core/models/rental_product_model.dart'; // ← RentalProductModel

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();
  @override
  List<Object?> get props => [];
}

class LoadWishlist extends WishlistEvent {
  final String userId;
  const LoadWishlist(this.userId);
  @override
  List<Object?> get props => [userId];
}

class ToggleWishlist extends WishlistEvent {
  final String userId;
  final RentalProductModel product;
  const ToggleWishlist({required this.userId, required this.product});
  @override
  List<Object?> get props => [userId, product];
}

class ClearWishlist extends WishlistEvent {
  final String userId;
  const ClearWishlist(this.userId);
  @override
  List<Object?> get props => [userId];
}

class ResetWishlist extends WishlistEvent {}