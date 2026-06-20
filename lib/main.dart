import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MRentO/config/navigation/app_router.dart';
import 'package:MRentO/config/theme/app_theme.dart';
import 'package:MRentO/core/constants/app_constants.dart';
import 'package:MRentO/core/services/analytics_service.dart';
import 'package:MRentO/core/services/local_storage_service.dart';
import 'package:MRentO/core/services/logger_service.dart';
import 'package:MRentO/core/services/push_notification_service.dart';
import 'package:MRentO/core/socket/socket_service.dart';
import 'package:MRentO/features/auth/bloc/auth_bloc.dart';
import 'package:MRentO/features/auth/bloc/auth_event.dart';
import 'package:MRentO/core/services/secure_storage_service.dart';
import 'package:MRentO/core/services/firebase_auth_service.dart';
import 'package:MRentO/features/cart/bloc/cart_bloc.dart';
import 'package:MRentO/features/cart/bloc/cart_event.dart';
import 'package:MRentO/features/home/bloc/product_bloc.dart';
import 'package:MRentO/features/search/bloc/search_bloc.dart';
import 'package:MRentO/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:MRentO/features/wishlist/bloc/wishlist_event.dart';
import 'package:MRentO/features/wishlist/bloc/wishlist_state.dart';
import 'package:MRentO/features/auth/bloc/auth_state.dart';
import 'package:MRentO/features/tracking/bloc/tracking_bloc.dart';
import 'package:MRentO/features/orders/bloc/orders_bloc.dart';
import 'package:MRentO/features/settings/bloc/address_bloc.dart';
import 'package:MRentO/firebase_options.dart';

import 'features/home/bloc/category_bloc.dart';
import 'features/home/bloc/banner_bloc.dart';
import 'features/home/bloc/banner_event.dart';
import 'features/home/bloc/location_bloc.dart';
import 'features/home/bloc/location_event.dart';
import 'features/notification/bloc/notification_bloc.dart';
import 'features/notification/bloc/notification_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "keys.env");
  await LoggingService.instance.initialize();
  await LocalStorageService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  if (AppConstants.enableCrashlytics) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  if (AppConstants.enableAnalytics) {
    await AnalyticsService.instance.logAppOpen();
  }

  await PushNotificationService().init();
  SocketService.instance.init();

  FirebaseMessaging.onBackgroundMessage(
    PushNotificationService.firebaseMessagingBackgroundHandler,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            secureStorage: SecureStorageService(),
            localStorage: LocalStorageService(),
            authService: FirebaseAuthService(),
          )..add(AppStarted()),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(),
        ),
        BlocProvider(
          create: (_) => LocationBloc()..add(const FetchLocation()),
        ),
        BlocProvider(create: (_) => BannerBloc()..add(FetchBanners())),
        BlocProvider(create: (_) => NotificationBloc()),
        BlocProvider(create: (_) => CartBloc()..add(LoadCart())),
        BlocProvider(create: (_) => ProductBloc()),
        BlocProvider(create: (_) => SearchBloc()),
        BlocProvider(create: (_) => WishlistBloc()),
        BlocProvider(create: (_) => TrackingBloc()),
        BlocProvider(create: (_) => OrdersBloc()),
        BlocProvider(create: (_) => AddressBloc()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.read<WishlistBloc>().add(LoadWishlist(state.user.userId));
        }
      },
      child: MaterialApp.router(
        title: 'MRentO',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
