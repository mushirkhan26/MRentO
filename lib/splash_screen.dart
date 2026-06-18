import 'package:delivery_90/features/onboarding/widgets/onboarding_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'config/navigation/app_routes.dart';
import 'config/theme/app_colors.dart';
import 'core/api/network/auth_service.dart';
import 'core/services/location_service.dart';
import 'core/utils/utils.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late VideoPlayerController _videoController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showOnboarding = false;

  bool _isVideoInitialized = false;
  bool _isVideoControllerCreated = false;
  bool _hasStartedLogicCheck = false;
  bool _isLoading = false;
  bool _videoEnded = false;
  bool _safetyTimerTriggered = false;
  bool _videoListenerFired = false;
  bool _waitingForSettingsReturn = false;
  int _authRetryCount = 0;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initVideo();
    _startSafetyTimer();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _waitingForSettingsReturn) {
      _waitingForSettingsReturn = false;
      if (!mounted) return;
      _hasStartedLogicCheck = false;
      _videoListenerFired = false;
      _runGatekeeperLogic();
    }
  }

  Future<void> _startSafetyTimer() async {
    await Future.delayed(const Duration(seconds: 10));
    if (mounted && !_hasStartedLogicCheck && !_videoListenerFired) {
      setState(() {
        _safetyTimerTriggered = true;
        _videoEnded = true;
        _showOnboarding = true;
      });
    }
  }

  Future<void> _initVideo() async {
    try {
      _videoController = VideoPlayerController.asset('assets/videos/splash.mp4');
      _isVideoControllerCreated = true;
      await _videoController.initialize();
      if (!mounted) return;
      setState(() {
        _isVideoInitialized = true;
        _videoController.play();
      });
      _videoController.setLooping(false);
      _videoController.addListener(_onVideoUpdate);
    } catch (e) {
      debugPrint("Splash: Video init error: $e");
      if (mounted) {
        setState(() {
          _videoEnded = true;
          _showOnboarding = true;
        });
      }
    }
  }

  void _onVideoUpdate() {
    if (!mounted || _videoListenerFired) return;
    final isCompleted = _videoController.value.position >=
        _videoController.value.duration - const Duration(milliseconds: 10);
    if (isCompleted && !_hasStartedLogicCheck && !_safetyTimerTriggered) {
      setState(() {
        _videoListenerFired = true;
        _videoEnded = true;
        _showOnboarding = true;
      });
    }
  }

  Future<void> _runGatekeeperLogic() async {
    if (_hasStartedLogicCheck) return;
    _hasStartedLogicCheck = true;

    if (mounted) {
      setState(() => _isLoading = true);
      _pulseController.repeat(reverse: true);
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

  void _showLocationDialog(String title, String message, {required bool isSettings}) {
    if (!mounted) return;
    setState(() => _isLoading = false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.primaryBlack,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Center(
          child: Column(
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        content: Text(message, style: const TextStyle(color: Colors.white60)),
        actions: [
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text("Cancel", style: TextStyle(color: Colors.white38)),
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
    while (c.length < 3) c.add(0);
    while (m.length < 3) m.add(0);
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
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.primaryBlack,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(message, style: const TextStyle(color: Colors.white60)),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              _hasStartedLogicCheck = false;
              _runGatekeeperLogic();
            },
            child: const Text(
              "Retry",
              style: TextStyle(color: AppColors.primaryYellow, fontWeight: FontWeight.bold),
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
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryBlack,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Update Required",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "MRentO ka naya version available hai.",
          style: TextStyle(color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text("Exit App", style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () async {
              if (url != null) {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              }
            },
            child: const Text(
              "Update Now",
              style: TextStyle(color: AppColors.primaryYellow, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_isVideoControllerCreated) {
      _videoController.removeListener(_onVideoUpdate);
      _videoController.dispose();
    }
    _fadeController.dispose();
    _pulseController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = Utils().width(context);
    final height = Utils().height(context);

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
              onContinue: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              ),
            ),
            StatsPage(
              onBack: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              ),
              onNext: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              ),
            ),
            FeaturesPage(
              onBack: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              ),
              onNext: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              ),
            ),
            CityPage(
              onBack: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              ),
              onFinish: _runGatekeeperLogic,
            ),
          ],
        ),
      );
    }

    // Video Splash
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Video
          if (!_videoEnded && _isVideoInitialized && !_isLoading)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),

          // Fallback — agar video load na ho
          if (_videoEnded || (!_isVideoInitialized && _safetyTimerTriggered))
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: width * 0.35,
                    height: width * 0.35,
                    decoration: BoxDecoration(
                      color: AppColors.primaryYellow,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryYellow.withValues(alpha: 0.3),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'MRentO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: const Text(
                      "Loading...",
                      style: TextStyle(
                        color: AppColors.primaryYellow,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Loading overlay
          if (_isLoading)
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                color: AppColors.primaryBlack.withValues(alpha: 0.9),
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