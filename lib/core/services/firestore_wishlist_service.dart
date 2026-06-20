import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/base_api/api_response.dart';
import '../models/rental_product_model.dart';

class FirestoreWishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _getWishlistPath(String userId) => 'users/$userId/wishlist';

  Future<ApiResponse<List<RentalProductModel>>> getWishlist(String userId) async {
    try {
      final querySnapshot = await _firestore.collection(_getWishlistPath(userId)).get();

      final items = querySnapshot.docs
          .map((doc) => RentalProductModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      return ApiResponse.success(items);
    } catch (e) {
      return ApiResponse.error('Wishlist load karne mein problem hui: $e');
    }
  }

  Future<ApiResponse<void>> addToWishlist(String userId, RentalProductModel product) async {
    try {
      await _firestore
          .collection(_getWishlistPath(userId))
          .doc(product.id)
          .set(product.toJson());
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Product save nahi ho paya: $e');
    }
  }

  Future<ApiResponse<void>> removeFromWishlist(String userId, String productId) async {
    try {
      await _firestore.collection(_getWishlistPath(userId)).doc(productId).delete();
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Product remove nahi ho paya: $e');
    }
  }

  Future<ApiResponse<void>> clearWishlist(String userId) async {
    try {
      final collection = _firestore.collection(_getWishlistPath(userId));
      final snapshots = await collection.get();
      
      final batch = _firestore.batch();
      for (final doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Wishlist clear nahi ho payi: $e');
    }
  }
}
