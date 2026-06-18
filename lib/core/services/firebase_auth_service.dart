import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/base_api/api_response.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Verification ID store karo OTP ke liye
  String? _verificationId;

  Future<ApiResponse<void>> sendOtp(String mobile) async {
    final completer = Completer<ApiResponse<void>>();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$mobile',
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            if (!completer.isCompleted) {
              completer.complete(ApiResponse.success(null, message: 'Auto-verified successfully'));
            }
          } catch (e) {
            if (!completer.isCompleted) {
              completer.complete(ApiResponse.error('Auto-verification fail hua'));
            }
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          if (!completer.isCompleted) {
            completer.complete(ApiResponse.error(_getAuthErrorMessage(e)));
          }
        },

        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          if (!completer.isCompleted) {
            completer.complete(ApiResponse.success(null, message: 'OTP sent successfully'));
          }
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );

      return completer.future;
    } on FirebaseAuthException catch (e) {
      return ApiResponse.error(_getAuthErrorMessage(e));
    } catch (e) {
      return ApiResponse.error('OTP bhejne mein problem hui, dobara try karo');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    try {
      if (_verificationId == null) {
        return ApiResponse.error('Pehle OTP mangao');
      }

      // Firebase credential banao
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      // Firebase mein sign in karo
      final userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return ApiResponse.error('Login fail hua, dobara try karo');
      }

      // JWT token lo
      final token = await firebaseUser.getIdToken();

      // Firestore mein user check/create karo
      final userData = await _getOrCreateUser(
        uid: firebaseUser.uid,
        mobile: mobile,
      );

      return ApiResponse.success({
        'token': token,
        'userId': firebaseUser.uid,
        'name': userData['name'] ?? 'User',
        'email': userData['email'] ?? '',
        'phone': mobile,
        'role': userData['role'] ?? 'customer',
      });
    } on FirebaseAuthException catch (e) {
      return ApiResponse.error(_getAuthErrorMessage(e));
    } catch (e) {
      return ApiResponse.error('Verification fail hua, dobara try karo');
    }
  }


  Future<ApiResponse<Map<String, dynamic>>> refreshToken() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        return ApiResponse.error('User logged in nahi hai');
      }

      // Firebase token force refresh karo
      final token = await firebaseUser.getIdToken(true);

      final userData = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      final data = userData.data() ?? {};

      return ApiResponse.success({
        'token': token,
        'userId': firebaseUser.uid,
        'name': data['name'] ?? 'User',
        'email': data['email'] ?? '',
        'phone': data['mobile'] ?? '',
        'role': data['role'] ?? 'customer',
      });
    } catch (e) {
      return ApiResponse.error('Token refresh fail hua');
    }
  }


  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<ApiResponse<void>> updateFCMToken({
    required String userId,
    required String appToken,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': appToken,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return ApiResponse.success(null, message: 'Token updated');
    } catch (e) {
      return ApiResponse.error('FCM token update fail hua');
    }
  }


  Future<Map<String, dynamic>> _getOrCreateUser({
    required String uid,
    required String mobile,
  }) async {
    final docRef = _firestore.collection('users').doc(uid);
    final doc = await docRef.get();

    if (doc.exists) {
      // User pehle se hai — return karo
      return doc.data() ?? {};
    }

    // Naya user — Firestore mein banao
    final newUser = {
      'userId': uid,
      'mobile': mobile,
      'name': 'User',
      'email': '',
      'role': 'customer',
      'createdAt': FieldValue.serverTimestamp(),
    };

    await docRef.set(newUser);
    return newUser;
  }


  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'Phone number sahi nahi hai';
      case 'invalid-verification-code':
        return 'OTP galat hai, dobara check karo';
      case 'code-expired':
        return 'OTP expire ho gaya, naya OTP mangao';
      case 'too-many-requests':
        return 'Bahut zyada try kiya, thodi der baad try karo';
      case 'quota-exceeded':
        return 'OTP limit exceed ho gayi';
      default:
        return 'Kuch problem hui: ${e.message}';
    }
  }
}