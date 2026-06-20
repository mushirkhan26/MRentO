import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/base_api/api_response.dart';
import '../models/banner_model.dart';

class FirestoreHomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ApiResponse<List<BannerModel>>> getBanners() async {
    try {
      final querySnapshot = await _firestore.collection('banners').get();

      final banners = querySnapshot.docs
          .map((doc) => BannerModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      return ApiResponse.success(banners);
    } catch (e) {
      return ApiResponse.error('Banners fetch karne mein problem hui: $e');
    }
  }
}
