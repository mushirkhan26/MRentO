import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/models/user_model.dart';
import '../../../core/constants/app_constants.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SecureStorageService _secureStorage;
  final LocalStorageService _localStorage;
  final FirebaseAuthService _authService;

  AuthBloc({
    required SecureStorageService secureStorage,
    required LocalStorageService localStorage,
    FirebaseAuthService? authService,
  })  : _secureStorage = secureStorage,
        _localStorage = localStorage,
        _authService = authService ?? FirebaseAuthService(),
        super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<OtpVerificationRequested>(_onOtpVerificationRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  // ─────────────────────────────────────────
  // APP STARTED — Token validity check
  // ─────────────────────────────────────────
  Future<void> _onAppStarted(
      AppStarted event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoading(action: 'appStart'));

      final loggedIn = await _localStorage.isLoggedIn();
      if (!loggedIn) {
        emit(AuthUnauthenticated());
        return;
      }

      final userData = await _secureStorage.getUserData();
      if (userData == null) {
        emit(AuthUnauthenticated());
        return;
      }

      final token = userData['token'] as String?;
      if (token == null || token.isEmpty) {
        await _clearSession();
        emit(AuthUnauthenticated());
        return;
      }

      // Firebase token expired check
      if (_isTokenExpired(token)) {
        debugPrint("AuthBloc: Token expired, refreshing...");
        final refreshed = await _refreshToken();
        if (!refreshed) {
          await _clearSession();
          emit(AuthUnauthenticated());
          return;
        }

        final newUserData = await _secureStorage.getUserData();
        if (newUserData == null) {
          emit(AuthUnauthenticated());
          return;
        }

        emit(AuthAuthenticated(_userFromMap(newUserData)));
        return;
      }

      emit(AuthAuthenticated(_userFromMap(userData)));
    } catch (e) {
      debugPrint("AuthBloc: AppStarted error: $e");
      emit(AuthUnauthenticated());
    }
  }

  // ─────────────────────────────────────────
  // LOGIN — Send OTP via Firebase
  // ─────────────────────────────────────────
  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading(action: 'login'));

    final response = await _authService.sendOtp(event.mobile);

    if (response.success) {
      emit(AuthOtpSent(event.mobile));
    } else {
      emit(AuthError(response.message ?? 'OTP bhejne mein problem hui'));
    }
  }

  // ─────────────────────────────────────────
  // OTP VERIFY — Firebase se verify karo
  // ─────────────────────────────────────────
  Future<void> _onOtpVerificationRequested(
      OtpVerificationRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading(action: 'verify'));

    if (event.otp.length != AppConstants.otpLength) {
      emit(const AuthError('OTP sahi nahi hai'));
      return;
    }

    final response = await _authService.verifyOtp(
      mobile: event.mobile,
      otp: event.otp,
    );

    if (!response.success || response.data == null) {
      emit(AuthError(response.message ?? 'Verification fail hua'));
      return;
    }

    final data = response.data!;
    await _saveAuthData(data);
    
    // Log Analytics Login
    AnalyticsService.instance.logLogin('phone');
    AnalyticsService.instance.setUserId(data['userId']?.toString() ?? '');

    emit(AuthAuthenticated(_userFromMap(data)));
  }

  // ─────────────────────────────────────────
  // LOGOUT
  // ─────────────────────────────────────────
  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    await _authService.logout();
    await _clearSession();
    emit(AuthUnauthenticated());
  }

  // ─────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────
  UserModel _userFromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['userId']?.toString() ?? '',
      name: data['name'] ?? 'User',
      userId: data['userId']?.toString() ?? '',
      email: data['email'],
      mobile: data['phone'],
      role: data['role'] ?? 'customer',
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final response = await _authService.refreshToken();
      if (response.success && response.data != null) {
        await _saveAuthData(response.data!);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    await _secureStorage.saveUserData(
      token: data['token'] ?? '',
      userId: data['userId'] ?? '',
      name: data['name'] ?? 'User',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? 'customer',
    );
    await _localStorage.saveLoggedInUser(
      userId: data['userId'].toString(),
      userName: data['name'],
    );
    await _localStorage.setLoginState(true);
  }

  Future<void> _clearSession() async {
    await _secureStorage.clearUserData();
    await _secureStorage.clearProfileData();
    await _localStorage.setLoginState(false);
    await _localStorage.clearLoggedInUser();
  }

  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      String payload = parts[1];
      while (payload.length % 4 != 0) payload += '=';
      final decoded = json.decode(utf8.decode(base64Url.decode(payload)));
      final exp = decoded['exp'];
      if (exp == null) return false;
      return DateTime.now().isAfter(
        DateTime.fromMillisecondsSinceEpoch(exp * 1000),
      );
    } catch (_) {
      return true;
    }
  }
}