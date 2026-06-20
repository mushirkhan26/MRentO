import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/base_api/api_response.dart';
import '../models/order_model.dart';

class FirestoreOrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'orders';

  Future<ApiResponse<List<OrderModel>>> getOrders(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('customerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final orders = querySnapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      return ApiResponse.success(orders);
    } catch (e) {
      return ApiResponse.error('Orders fetch karne mein problem hui: $e');
    }
  }

  Future<ApiResponse<OrderModel>> createOrder(OrderModel order) async {
    try {
      final docRef = await _firestore.collection(_collection).add(order.toJson());
      final createdOrder = OrderModel.fromJson({...order.toJson(), 'id': docRef.id});
      return ApiResponse.success(createdOrder);
    } catch (e) {
      return ApiResponse.error('Order create nahi ho paya: $e');
    }
  }

  Stream<OrderModel?> streamOrder(String orderId) {
    return _firestore
        .collection(_collection)
        .doc(orderId)
        .snapshots()
        .map((doc) => doc.exists ? OrderModel.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}) : null);
  }

  Future<ApiResponse<void>> updateStatus(String orderId, OrderStatus status) async {
    try {
      await _firestore.collection(_collection).doc(orderId).update({
        'status': status.name,
      });
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Status update fail hua: $e');
    }
  }
}
