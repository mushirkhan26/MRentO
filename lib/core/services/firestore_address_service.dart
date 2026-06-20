import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/base_api/api_response.dart';
import '../models/address_model.dart';

class FirestoreAddressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _getUserPath(String userId) => 'users/$userId/addresses';

  Future<ApiResponse<List<AddressModel>>> getAddresses(String userId) async {
    try {
      final querySnapshot = await _firestore.collection(_getUserPath(userId)).get();

      final addresses = querySnapshot.docs
          .map((doc) => AddressModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      return ApiResponse.success(addresses);
    } catch (e) {
      return ApiResponse.error('Addresses load karne mein problem hui: $e');
    }
  }

  Future<ApiResponse<AddressModel>> addAddress(String userId, AddressModel address) async {
    try {
      final docRef = await _firestore.collection(_getUserPath(userId)).add(address.toJson());
      final created = address.copyWith(id: docRef.id);
      return ApiResponse.success(created);
    } catch (e) {
      return ApiResponse.error('Address save nahi ho paya: $e');
    }
  }

  Future<ApiResponse<void>> updateAddress(String userId, AddressModel address) async {
    try {
      await _firestore
          .collection(_getUserPath(userId))
          .doc(address.id)
          .update(address.toJson());
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Address update nahi ho paya: $e');
    }
  }

  Future<ApiResponse<void>> deleteAddress(String userId, String addressId) async {
    try {
      await _firestore.collection(_getUserPath(userId)).doc(addressId).delete();
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Address delete nahi ho paya: $e');
    }
  }

  Future<ApiResponse<void>> setDefaultAddress(String userId, String addressId) async {
    try {
      final batch = _firestore.batch();
      final collectionRef = _firestore.collection(_getUserPath(userId));
      
      final allDocs = await collectionRef.get();
      for (var doc in allDocs.docs) {
        batch.update(doc.reference, {'isDefault': doc.id == addressId});
      }
      
      await batch.commit();
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Default address set nahi ho paya: $e');
    }
  }
}
