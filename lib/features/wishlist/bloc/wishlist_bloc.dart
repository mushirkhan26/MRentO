import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/rental_product_model.dart';
import '../../../core/services/firestore_wishlist_service.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';


class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final FirestoreWishlistService _wishlistService;

  WishlistBloc({FirestoreWishlistService? wishlistService})
      : _wishlistService = wishlistService ?? FirestoreWishlistService(),
        super(WishlistInitial()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<ToggleWishlist>(_onToggleWishlist);
    on<ClearWishlist>(_onClearWishlist);
  }

  Future<void> _onLoadWishlist(
      LoadWishlist event,
      Emitter<WishlistState> emit,
      ) async {
    emit(WishlistLoading());
    final response = await _wishlistService.getWishlist(event.userId);
    if (response.success && response.data != null) {
      emit(WishlistLoaded(response.data!));
    } else {
      emit(WishlistError(response.message ?? 'Wishlist load nahi hui'));
    }
  }

  Future<void> _onToggleWishlist(
      ToggleWishlist event,
      Emitter<WishlistState> emit,
      ) async {
    if (state is WishlistLoaded) {
      final currentItems =
      List<RentalProductModel>.from((state as WishlistLoaded).items);
      final index = currentItems.indexWhere((i) => i.id == event.product.id);

      if (index != -1) {
        // Remove from Firestore
        final response = await _wishlistService.removeFromWishlist(event.userId, event.product.id);
        if (response.success) {
          currentItems.removeAt(index);
          emit(WishlistLoaded(currentItems));
        }
      } else {
        // Add to Firestore
        final response = await _wishlistService.addToWishlist(event.userId, event.product);
        if (response.success) {
          currentItems.add(event.product);
          emit(WishlistLoaded(currentItems));
        }
      }
    }
  }

  Future<void> _onToggleWishlistSync(
      ToggleWishlist event,
      Emitter<WishlistState> emit,
      ) async {
    // Optional: Optimistic UI update could be added here
  }

  Future<void> _onClearWishlist(
      ClearWishlist event,
      Emitter<WishlistState> emit,
      ) async {
    final response = await _wishlistService.clearWishlist(event.userId);
    if (response.success) {
      emit(const WishlistLoaded([]));
    }
  }
}