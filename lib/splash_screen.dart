import 'package:MRentO/features/onboarding/widgets/onboarding_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'config/navigation/app_routes.dart';
import 'config/theme/app_colors.dart';
import 'core/api/network/auth_service.dart';
import 'core/services/local_storage_service.dart';
import 'core/services/location_service.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final PageController _pageController = PageController();
  int _currentPage=0;
  bool _showOnboarding = false;

  // Animation states from user snippet
  bool isVisible = false;
  bool showLogo = true;
  bool isCircle = false;
  bool showText = false;
  double bgProgress = 0.0;

  bool _hasStartedLogicCheck = false;
  bool _isLoading = false;
  bool _waitingForSettingsReturn = false;
  int _authRetryCount = 0;

  final AuthService _authService = AuthService();
  final LocalStorageService _storage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _initSplash();
  }

  Future<void> _initSplash() async {
    // Start animation sequence from user snippet
    if (!mounted) return;

    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    setState(() {
      bgProgress = 1.0;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      isVisible = true;
    });

    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;
    setState(() {
      showLogo = false;
      isCircle = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      showText = true;
    });

    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    // After animation, proceed with original logic
    final seen = await _storage.hasSeenOnboarding();
    if (seen) {
      _runGatekeeperLogic();
    } else {
      setState(() {
        _showOnboarding = true;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _waitingForSettingsReturn) {
      _waitingForSettingsReturn = false;
      if (!mounted) return;
      _hasStartedLogicCheck = false;
      _runGatekeeperLogic();
    }
  }

  Future<void> _runGatekeeperLogic() async {
    if (_hasStartedLogicCheck) return;
    _hasStartedLogicCheck = true;

    if (mounted) {
      setState(() => _isLoading = true);
      await _fadeController.forward();
    }

    // 1. Internet Check
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      _showErrorDialog("No Internet", "Please check your internet connection.");
      return;
    }

    // 2. App Version Check
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final versionResponse = await _authService.checkAppVersion();
      if (versionResponse.success && versionResponse.data != null) {
        final minVersion = versionResponse.data!['minVersion'] ?? "1.0.0";
        final forceUpdate = versionResponse.data!['forceUpdate'] ?? false;
        if (forceUpdate && _isVersionOlder(currentVersion, minVersion)) {
          _showUpdateDialog(versionResponse.data!['updateUrl']);
          return;
        }
      }
    } catch (e) {
      debugPrint("Splash: Version check error: $e");
    }

    // 3. Location Check
    try {
      final permission = await _handleLocationPermission();
      if (!permission) return;
    } catch (e) {
      debugPrint("Splash: Location check error: $e");
    }

    // Mark onboarding as seen
    await _storage.setSeenOnboarding(true);

    // 4. Auth Routing
    _finalizeRouting();
  }

  Future<bool> _handleLocationPermission() async {
    final locationService = LocationService.instance;
    if (!await locationService.isServiceEnabled()) {
      _showLocationDialog(
        "Location Disabled",
        "Please enable location services to continue.",
        isSettings: false,
      );
      return false;
    }
    final permission = await locationService.handlePermission();
    if (permission == LocationPermission.denied) {
      _showLocationDialog(
        "Location Required",
        "MRentO ko aapki location chahiye nearby vendors dikhane ke liye.",
        isSettings: false,
      );
      return false;
    }
    if (permission == LocationPermission.deniedForever) {
      _showLocationDialog(
        "Location Required",
        "Location permission permanently denied hai.",
        isSettings: true,
      );
      return false;
    }
    await locationService.getCurrentLocation();
    return true;
  }

  void _showLocationDialog(String title, String message,
      {required bool isSettings}) {
    if (!mounted) return;
    setState(() => _isLoading = false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) =>
          AlertDialog(
            backgroundColor: AppColors.primaryBlack,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Center(
              child: Column(
                children: [
                  Text(title, style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            content: Text(
                message, style: const TextStyle(color: Colors.white60)),
            actions: [
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text(
                    "Cancel", style: TextStyle(color: Colors.white38)),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  if (isSettings) {
                    _waitingForSettingsReturn = true;
                    await LocationService.instance.openSettings();
                  } else {
                    _hasStartedLogicCheck = false;
                    _runGatekeeperLogic();
                  }
                },
                child: Text(
                  isSettings ? "Open Settings" : "Retry",
                  style: const TextStyle(
                    color: AppColors.primaryYellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  bool _isVersionOlder(String current, String min) {
    List<int> c = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    List<int> m = min.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    while (c.length < 3) {
      c.add(0);
    }
    while (m.length < 3) {
      m.add(0);
    }
    for (int i = 0; i < 3; i++) {
      if (c[i] < m[i]) return true;
      if (c[i] > m[i]) return false;
    }
    return false;
  }

  void _finalizeRouting() {
    if (!mounted) return;
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is AuthInitial) {
      if (_authRetryCount >= 5) {
        context.go(AppRoutes.loginRoute);
        return;
      }
      _authRetryCount++;
      Future.delayed(const Duration(milliseconds: 500), _finalizeRouting);
      return;
    }
    final currentState = authBloc.state;
    if (currentState is AuthAuthenticated) {
      context.go(AppRoutes.homeRoute);
    } else {
      context.go(AppRoutes.loginRoute);
    }
  }

  void _showErrorDialog(String title, String message) {
    if (!mounted) return;
    setState(() => _isLoading = false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) =>
          AlertDialog(
            backgroundColor: AppColors.primaryBlack,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Text(title, style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
            content: Text(
                message, style: const TextStyle(color: Colors.white60)),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  _hasStartedLogicCheck = false;
                  _runGatekeeperLogic();
                },
                child: const Text(
                  "Retry",
                  style: TextStyle(color: AppColors.primaryYellow,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
    );
  }

  void _showUpdateDialog(String? url) {
    setState(() => _isLoading = false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(
            backgroundColor: AppColors.primaryBlack,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text(
              "Update Required",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              "MRentO ka naya version available hai.",
              style: TextStyle(color: Colors.white60),
            ),
            actions: [
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text(
                    "Exit App", style: TextStyle(color: Colors.white38)),
              ),
              TextButton(
                onPressed: () async {
                  if (url != null) {
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                          uri, mode: LaunchMode.externalApplication);
                    }
                  }
                },
                child: const Text(
                  "Update Now",
                  style: TextStyle(color: AppColors.primaryYellow,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Onboarding pages
    if (_showOnboarding) {
      return Scaffold(
        backgroundColor: AppColors.primaryBlack,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (i) => setState(() => _currentPage = i),
          children: [
            WelcomePage(
              onGetStarted: () =>
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
            ),
            StatsPage(
              onBack: () =>
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
              onNext: () =>
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
            ),
            FeaturesPage(
              onBack: () =>
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
              onNext: () =>
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
            ),
            CityPage(
              onBack: () =>
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
              onCitySelected: (city) => _runGatekeeperLogic(),
            ),
          ],
        ),
      );
    }

    // Animated Splash (Logo morphing into dot + Name)
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: bgProgress),
            duration: const Duration(milliseconds: 700),
            builder: (context, value, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(Colors.white, Colors.white, value)!,
                      Color.lerp(Colors.white, Colors.white, value)!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSize(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOutExpo,
                        child: showText
                            ? RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "MRent",
                                      style: TextStyle(
                                          color: AppColors.primaryBlack),
                                    ),
                                    TextSpan(
                                      text: "O",
                                      style: TextStyle(
                                          color: AppColors.primaryYellow),
                                    ),
                                  ],
                                ),
                              )
                            : const Text(""),
                      ),
                      if (showText) const SizedBox(width: 8),
                      AnimatedOpacity(
                        opacity: isVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 2500),
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.elasticOut,
                          padding: EdgeInsets.only(top: isVisible ? 20 : 300),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutExpo,
                            transform: Matrix4.rotationZ(
                              isCircle ? 3.14159 / 7 : 0.0,
                            ),
                            width: isCircle ? 12 : 120,
                            height: isCircle ? 12 : 120,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlack,
                              borderRadius: BorderRadius.circular(
                                isCircle ? 60 : 10,
                              ),
                            ),
                            child: Center(
                              child: AnimatedOpacity(
                                opacity: showLogo ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 500),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Loading overlay (gatekeeper logic ke waqt)
          if (_isLoading)
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                color: AppColors.primaryBlack.withValues(alpha: 0.7),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryYellow,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}