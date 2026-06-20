import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  static AnalyticsService get instance => _instance;

  late FirebaseAnalytics _analytics;

  AnalyticsService._internal() {
    _analytics = FirebaseAnalytics.instance;
  }

  Future<void> logLogin(String method) async {
    if (!AppConstants.enableAnalytics) return;
    debugPrint('📊 Analytics: Logging Login (Method: $method)');
    await _analytics.logLogin(loginMethod: method);
  }

  Future<void> logSignUp(String method) async {
    if (!AppConstants.enableAnalytics) return;
    debugPrint('📊 Analytics: Logging SignUp (Method: $method)');
    await _analytics.logSignUp(signUpMethod: method);
  }

  Future<void> logAddToCart({
    required String productId,
    required String productName,
    required double price,
    String? category,
    int quantity = 1,
  }) async {
    if (!AppConstants.enableAnalytics) return;
    debugPrint('📊 Analytics: Adding to Cart: $productName');
    await _analytics.logAddToCart(
      items: [
        AnalyticsEventItem(
          itemId: productId,
          itemName: productName,
          itemCategory: category,
          price: price,
          quantity: quantity,
        ),
      ],
      value: price * quantity,
      currency: 'INR',
    );
  }

  Future<void> logRemoveFromCart({
    required String productId,
    required String productName,
    required double price,
  }) async {
    if (!AppConstants.enableAnalytics) return;
    await _analytics.logEvent(
      name: 'remove_from_cart',
      parameters: {
        'item_id': productId,
        'item_name': productName,
        'price': price,
      },
    );
  }

  Future<void> logBeginCheckout({
    required double value,
    required List<AnalyticsEventItem> items,
  }) async {
    if (!AppConstants.enableAnalytics) return;
    await _analytics.logBeginCheckout(
      value: value,
      currency: 'INR',
      items: items,
    );
  }

  Future<void> logPurchase({
    required double value,
    required String transactionId,
    required List<AnalyticsEventItem> items,
  }) async {
    if (!AppConstants.enableAnalytics) return;
    await _analytics.logPurchase(
      value: value,
      currency: 'INR',
      transactionId: transactionId,
      items: items,
    );
  }

  Future<void> logSearch(String searchTerm) async {
    if (!AppConstants.enableAnalytics) return;
    debugPrint('📊 Analytics: Searching: $searchTerm');
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  Future<void> logViewItem({
    required String productId,
    required String productName,
    String? category,
  }) async {
    if (!AppConstants.enableAnalytics) return;
    debugPrint('📊 Analytics: Viewing Item: $productName');
    await _analytics.logViewItem(
      items: [
        AnalyticsEventItem(
          itemId: productId,
          itemName: productName,
          itemCategory: category,
        ),
      ],
    );
  }

  Future<void> logAppOpen() async {
    if (!AppConstants.enableAnalytics) return;
    await _analytics.logAppOpen();
  }
  
  Future<void> setCurrentScreen(String screenName) async {
    if (!AppConstants.enableAnalytics) return;
    debugPrint('📊 Analytics: Screen View: $screenName');
    await _analytics.logScreenView(screenName: screenName);
  }

  Future<void> setUserId(String userId) async {
    if (!AppConstants.enableAnalytics) return;
    await _analytics.setUserId(id: userId);
  }

  Future<void> setUserProperty({required String name, required String value}) async {
    if (!AppConstants.enableAnalytics) return;
    await _analytics.setUserProperty(name: name, value: value);
  }

  FirebaseAnalyticsObserver getObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }
}
