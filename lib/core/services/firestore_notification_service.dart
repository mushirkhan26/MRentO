import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/base_api/api_response.dart';
import '../models/notification_model.dart';

class FirestoreNotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _getUserPath(String userId) => 'users/$userId/notifications';

  Future<ApiResponse<List<NotificationModel>>> getNotifications(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_getUserPath(userId))
          .orderBy('createdAt', descending: true)
          .get();

      final notifications = querySnapshot.docs
          .map((doc) => NotificationModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      return ApiResponse.success(notifications);
    } catch (e) {
      return ApiResponse.error('Notifications load karne mein problem hui: $e');
    }
  }

  Future<ApiResponse<void>> markAsRead(String userId, String notificationId) async {
    try {
      await _firestore
          .collection(_getUserPath(userId))
          .doc(notificationId)
          .update({'isRead': true});
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Update fail hua: $e');
    }
  }
}
