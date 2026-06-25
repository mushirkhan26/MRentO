import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/models/cart_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/cart_service.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService _cartService;

  CartBloc({CartService? cartService})
      : _cartService = cartService ?? CartService(),
        super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
    on<ApplyCoupon>(_onApplyCoupon);
    on<RemoveCoupon>(_onRemoveCoupon);
    on<UndoRemove>(_onUndoRemove);

    // Initial load call
    add(LoadCart());
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart = await _cartService.loadCart();
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError('Cart load nahi hui: $e'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      final List<CartItem> updatedItems = List.from(currentCart.items);

      final index = updatedItems.indexWhere(
            (i) =>
        i.productId == event.item.productId &&
            i.rentalDurationLabel == event.item.rentalDurationLabel,
      );

      if (index != -1) {
        final existing = updatedItems[index];
        final newQty = existing.quantity + event.item.quantity;
        
        if (newQty > AppConstants.maxCartItemQuantity) {
          emit(CartError('Maximum limit ${AppConstants.maxCartItemQuantity} reached'));
          emit(CartLoaded(currentCart));
          return;
        }

        updatedItems[index] = existing.copyWith(quantity: newQty);
      } else {
        if (event.item.quantity > AppConstants.maxCartItemQuantity) {
          emit(CartError('Maximum limit ${AppConstants.maxCartItemQuantity} reached'));
          emit(CartLoaded(currentCart));
          return;
        }
        updatedItems.add(event.item);
      }

      final updatedCart = _cartService.calculateCart(updatedItems, couponCode: currentCart.couponCode);
      await _cartService.saveCart(updatedCart);

      AnalyticsService.instance.logAddToCart(
        productId: event.item.productId,
        productName: event.item.productName,
        price: event.item.price,
        quantity: event.item.quantity,
      );

      emit(CartLoaded(updatedCart));
    }
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCart event,
      Emitter<CartState> emit,
      ) async {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      
      final int itemIndex = currentCart.items.indexWhere((i) => i.productId == event.productId);
      
      if (itemIndex == -1) return; // Item not found, safe return

      final itemToRemove = currentCart.items[itemIndex];

      final updatedItems = List<CartItem>.from(currentCart.items)..removeAt(itemIndex);

      final updatedCart = _cartService.calculateCart(updatedItems, couponCode: currentCart.couponCode);
      await _cartService.saveCart(updatedCart);

      AnalyticsService.instance.logRemoveFromCart(
        productId: itemToRemove.productId,
        productName: itemToRemove.productName,
        price: itemToRemove.price,
      );

      emit(CartLoaded(updatedCart));
    }
  }

  Future<void> _onUpdateQuantity(
      UpdateQuantity event,
      Emitter<CartState> emit,
      ) async {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;

      if (event.quantity > AppConstants.maxCartItemQuantity) {
        emit(CartError('Max limit is ${AppConstants.maxCartItemQuantity}'));
        emit(CartLoaded(currentCart));
        return;
      }

      final updatedItems = currentCart.items
          .map((i) {
        if (i.productId == event.productId) {
          return i.copyWith(quantity: event.quantity);
        }
        return i;
      })
          .where((i) => i.quantity > 0)
          .toList();

      final updatedCart = _cartService.calculateCart(updatedItems, couponCode: currentCart.couponCode);
      await _cartService.saveCart(updatedCart);
      emit(CartLoaded(updatedCart));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    final emptyCart = CartModel.empty();
    await _cartService.saveCart(emptyCart);
    emit(CartLoaded(emptyCart));
  }

  Future<void> _onApplyCoupon(ApplyCoupon event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      
      final isValid = await _cartService.validateCoupon(event.couponCode);
      
      if (isValid) {
        final updatedCart = _cartService.calculateCart(currentCart.items, couponCode: event.couponCode);
        await _cartService.saveCart(updatedCart);
        emit(CartLoaded(updatedCart));
      } else {
        emit(CartError('Invalid coupon code'));
        emit(CartLoaded(currentCart));
      }
    }
  }

  Future<void> _onRemoveCoupon(RemoveCoupon event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      final updatedCart = _cartService.calculateCart(currentCart.items, couponCode: null);
      await _cartService.saveCart(updatedCart);
      emit(CartLoaded(updatedCart));
    }
  }

  Future<void> _onUndoRemove(UndoRemove event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      
      // Duplicate check: Agar item wapis add ho gaya hai, toh undo mat karo
      final bool alreadyExists = currentCart.items.any(
        (i) => i.productId == event.item.productId && 
               i.rentalDurationLabel == event.item.rentalDurationLabel,
      );
      
      if (alreadyExists) return;

      final updatedItems = List<CartItem>.from(currentCart.items)..add(event.item);
      final updatedCart = _cartService.calculateCart(updatedItems, couponCode: currentCart.couponCode);
      await _cartService.saveCart(updatedCart);
      emit(CartLoaded(updatedCart));
    }
  }
}
