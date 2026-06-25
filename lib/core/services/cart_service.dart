import 'dart:convert';
import '../models/cart_model.dart';
import '../constants/app_constants.dart';
import 'local_storage_service.dart';

class CartService {
  final LocalStorageService _localStorage = LocalStorageService();
  static const String _cartKey = 'cached_cart';

  /// Save cart to local storage
  Future<void> saveCart(CartModel cart) async {
    await _localStorage.saveString(_cartKey, jsonEncode(cart.toJson()));
  }

  /// Load cart from local storage
  Future<CartModel> loadCart() async {
    try {
      final cartJson = await _localStorage.getString(_cartKey);
      if (cartJson != null) {
        return CartModel.fromJson(jsonDecode(cartJson));
      }
    } catch (e) {
      // Log error if needed
    }
    return CartModel.empty();
  }

  /// Centralized calculation logic for the Cart
  CartModel calculateCart(List<CartItem> items, {String? couponCode}) {
    // 1. Calculate Subtotal
    double subtotal = items.fold(0, (sum, item) => sum + item.total);

    // 2. Delivery Fee Logic
    double deliveryFee = (subtotal >= AppConstants.freeDeliveryThreshold || items.isEmpty)
        ? 0
        : AppConstants.baseDeliveryFee;

    // 3. Tax Logic (GST)
    double tax = subtotal * AppConstants.gstRate;

    // 4. Coupon Logic
    // TODO: Fetch discount amount and rules from an API or Coupon model
    double couponDiscount = 0.0;
    if (couponCode?.toUpperCase() == 'MRENTO100') {
      couponDiscount = 100.0;
    }

    return CartModel(
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      couponCode: couponCode,
      couponDiscount: couponDiscount,
    );
  }

  /// Validate Coupon (Future implementation with API)
  Future<bool> validateCoupon(String code) async {
    // TODO: Replace with real API call (e.g., _apiService.validateCoupon(code))
    // Mock API delay
    await Future.delayed(const Duration(milliseconds: 500));
    return code.toUpperCase() == 'MRENTO100';
  }
}
