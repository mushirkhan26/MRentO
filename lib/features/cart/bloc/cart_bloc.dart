import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/cart_model.dart';
import '../../../core/constants/app_constants.dart'; // ← constants use karo
import '../../../core/services/local_storage_service.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import 'dart:convert';

class CartBloc extends Bloc<CartEvent, CartState> {
  final LocalStorageService _localStorage = LocalStorageService();
  static const String _cartKey = 'cached_cart';

  CartBloc() : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cartJson = await _localStorage.getString(_cartKey);
      CartModel cart;
      if (cartJson != null) {
        cart = CartModel.fromJson(jsonDecode(cartJson));
      } else {
        cart = CartModel.empty();
      }
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError('Cart load nahi hui: $e'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      final List<CartItem> updatedItems = List.from(currentCart.items);

      // Same product + same duration → quantity badhao
      final index = updatedItems.indexWhere(
            (i) =>
        i.productId == event.item.productId &&
            i.rentalDurationLabel == event.item.rentalDurationLabel,
      );

      if (index != -1) {
        final existing = updatedItems[index];
        updatedItems[index] = CartItem(
          productId: existing.productId,
          productName: existing.productName,
          brand: existing.brand,
          productImage: existing.productImage,
          quantity: existing.quantity + event.item.quantity,
          price: existing.price,
          originalPrice: existing.originalPrice,
          badges: existing.badges,
          vendorName: existing.vendorName,
          rentalDurationLabel: existing.rentalDurationLabel,
          rentalDays: existing.rentalDays,
          startDate: existing.startDate,
          endDate: existing.endDate,
          securityDeposit: existing.securityDeposit,
        );
      } else {
        updatedItems.add(event.item);
      }

      final updatedCart = _calculateCart(updatedItems);
      await _saveCart(updatedCart);
      emit(CartLoaded(updatedCart));
    }
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCart event,
      Emitter<CartState> emit,
      ) async {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      final updatedItems = currentCart.items
          .where((i) => i.productId != event.productId)
          .toList();

      final updatedCart = _calculateCart(updatedItems);
      await _saveCart(updatedCart);
      emit(CartLoaded(updatedCart));
    }
  }

  Future<void> _onUpdateQuantity(
      UpdateQuantity event,
      Emitter<CartState> emit,
      ) async {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      final updatedItems = currentCart.items
          .map((i) {
        if (i.productId == event.productId) {
          return CartItem(
            productId: i.productId,
            productName: i.productName,
            brand: i.brand,
            productImage: i.productImage,
            quantity: event.quantity,
            price: i.price,
            originalPrice: i.originalPrice,
            badges: i.badges,
            vendorName: i.vendorName,
            rentalDurationLabel: i.rentalDurationLabel,
            rentalDays: i.rentalDays,
            startDate: i.startDate,
            endDate: i.endDate,
            securityDeposit: i.securityDeposit,
          );
        }
        return i;
      })
          .where((i) => i.quantity > 0)
          .toList();

      final updatedCart = _calculateCart(updatedItems);
      await _saveCart(updatedCart);
      emit(CartLoaded(updatedCart));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    final emptyCart = CartModel.empty();
    await _saveCart(emptyCart);
    emit(CartLoaded(emptyCart));
  }

  /// Cart totals calculate — AppConstants se consistent values use karo
  CartModel _calculateCart(List<CartItem> items) {
    double subtotal = items.fold(0, (sum, item) => sum + item.total);

    // ✅ AppConstants.freeDeliveryThreshold = 999.0, baseDeliveryFee = 49.0
    double deliveryFee = subtotal >= AppConstants.freeDeliveryThreshold
        ? 0
        : AppConstants.baseDeliveryFee;

    // 18% GST on rental equipment
    double tax = subtotal * 0.18;

    return CartModel(
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
    );
    // Note: securityDeposit cart.totalSecurityDeposit se alag track hota hai
    // cart_price_breakdown.dart me use `cart.totalSecurityDeposit` to display it
  }

  Future<void> _saveCart(CartModel cart) async {
    await _localStorage.saveString(_cartKey, jsonEncode(cart.toJson()));
  }
}