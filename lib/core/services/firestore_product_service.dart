import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/rental_product_model.dart';
import '../../../core/models/category_model.dart';
import '../../../core/models/review_model.dart';
import '../api/base_api/api_response.dart';

class FirestoreProductService {
  static final FirestoreProductService _instance =
  FirestoreProductService._internal();
  factory FirestoreProductService() => _instance;
  FirestoreProductService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─────────────────────────────────────────
  // GET CATEGORIES
  // ─────────────────────────────────────────
  Future<ApiResponse<List<CategoryModel>>> getCategories() async {
    try {
      final snapshot = await _firestore
          .collection('categories')
          .orderBy('order') // Console mein order field rakho
          .get();

      final categories = snapshot.docs
          .map((doc) => CategoryModel.fromJson({...doc.data(), '_id': doc.id}))
          .toList();

      return ApiResponse.success(categories);
    } catch (e) {
      return ApiResponse.error('Categories load nahi hui: $e');
    }
  }

  // ─────────────────────────────────────────
  // GET RENTAL PRODUCTS BY CATEGORY
  // ─────────────────────────────────────────
  Future<ApiResponse<List<RentalProductModel>>> getProductsByCategory({
    required String categoryId,
    int limit = 20,
    DocumentSnapshot? lastDoc, // Pagination ke liye
  }) async {
    try {
      Query query = _firestore
          .collection('products')
          .where('categoryId', isEqualTo: categoryId)
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      // Pagination — agle page ke liye
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();

      final products = snapshot.docs
          .map((doc) => RentalProductModel.fromJson(
          {...doc.data() as Map<String, dynamic>, '_id': doc.id}))
          .toList();

      return ApiResponse.success(products);
    } catch (e) {
      return ApiResponse.error('Products load nahi hue: $e');
    }
  }

  // ─────────────────────────────────────────
  // GET SINGLE RENTAL PRODUCT
  // ─────────────────────────────────────────
  Future<ApiResponse<RentalProductModel>> getProductById(String productId) async {
    try {
      final doc = await _firestore
          .collection('products')
          .doc(productId)
          .get();

      if (!doc.exists) {
        return ApiResponse.error('Product nahi mila');
      }

      final product = RentalProductModel.fromJson({
        ...doc.data()!,
        '_id': doc.id,
      });

      return ApiResponse.success(product);
    } catch (e) {
      return ApiResponse.error('Product load nahi hua: $e');
    }
  }

  // ─────────────────────────────────────────
  // SEARCH RENTAL PRODUCTS
  // ─────────────────────────────────────────
  Future<ApiResponse<List<RentalProductModel>>> searchProducts(String query) async {
    try {
      // Firestore mein full-text search nahi hota
      // name field mein basic search — production mein Algolia use karo
      final snapshot = await _firestore
          .collection('products')
          .where('isAvailable', isEqualTo: true)
          .orderBy('name')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .limit(20)
          .get();

      final products = snapshot.docs
          .map((doc) => RentalProductModel.fromJson({
        ...doc.data(),
        '_id': doc.id,
      }))
          .toList();

      return ApiResponse.success(products);
    } catch (e) {
      return ApiResponse.error('Search fail hua: $e');
    }
  }

  // ─────────────────────────────────────────
  // ADD REVIEW
  // ─────────────────────────────────────────
  Future<ApiResponse<void>> addReview(ReviewModel review) async {
    try {
      await _firestore
          .collection('products')
          .doc(review.productId)
          .collection('reviews')
          .add(review.toJson());
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Review add nahi ho paya: $e');
    }
  }
}
