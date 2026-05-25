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
import 'core/constants/app_constants.dart';
import 'core/services/location_service.dart';
import 'core/utils/utils.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
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

    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnimation = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
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
    await Future.delayed(const Duration(seconds: 4));
    if (mounted && !_hasStartedLogicCheck) {
      debugPrint("Splash: Safety timer triggered");
      setState(() {
        _safetyTimerTriggered = true;
        _videoEnded = true;
        _showOnboarding = true; // Show new UI
      });
      // We don't run gatekeeper logic automatically anymore, 
      // it will be triggered by "Get started"
    }
  }

  Future<void> _initVideo() async {
    try {
      _videoController = VideoPlayerController.asset('assets/videos/splash.mp4');
      _isVideoControllerCreated = true;
      await _videoController.initialize();
      if (!mounted) return;
      setState(() => _isVideoInitialized = true);

      _videoController.play();
      _videoController.setLooping(false);

      _videoController.addListener(_onVideoUpdate);
    } catch (e) {
      debugPrint("Splash: Video init error: $e");
      if (!_hasStartedLogicCheck && mounted) {
        setState(() {
          _videoEnded = true;
          _showOnboarding = true;
        });
      }
    }
  }

  void _onVideoUpdate() {
    if (!mounted || _videoListenerFired) return;
    final isCompleted = _videoController.value.position >= _videoController.value.duration - const Duration(milliseconds: 100);
    if (isCompleted && !_hasStartedLogicCheck && !_safetyTimerTriggered) {
      debugPrint("Splash: Video completed");
      setState(() {
        _videoListenerFired = true;
        _videoEnded = true;
        _showOnboarding = true; // Show new UI after video
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

    // 3. Location Permission Check
    try {
      final permission = await _handleLocationPermission();
      if (!permission) return; 
    } catch (e) {
      debugPrint("Splash: Location check error: $e");
    }

    // 4. Auth & Routing Check
    _finalizeRouting();
  }

  Future<bool> _handleLocationPermission() async {
    final locationService = LocationService.instance;
    if (!await locationService.isServiceEnabled()) {
      _showLocationDialog("Location Disabled", "Please enable location services to continue.", isSettings: false);
      return false;
    }
    final permission = await locationService.handlePermission();
    if (permission == LocationPermission.denied) {
      _showLocationDialog("Location Required", "This app needs location access to show nearby services.", isSettings: false);
      return false;
    }
    if (permission == LocationPermission.deniedForever) {
      _showLocationDialog("Location Required", "Location permission is permanently denied.", isSettings: true);
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
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => SystemNavigator.pop(), child: const Text("Cancel")),
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
            child: Text(isSettings ? "Open Settings" : "Retry"),
          ),
        ],
      ),
    );
  }

  bool _isVersionOlder(String current, String min) {
    List<int> currentParts = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    List<int> minParts = min.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    while (currentParts.length < 3)currentParts.add(0);
    while (minParts.length < 3) minParts.add(0);
    for (int i = 0; i < 3; i++) {
      if (currentParts[i] < minParts[i]) return true;
      if (currentParts[i] > minParts[i]) return false;
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
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              _hasStartedLogicCheck = false;
              _runGatekeeperLogic();
            },
            child: const Text("Retry"),
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
        title: const Text("Update Required"),
        content: const Text("A new version of the app is available."),
        actions: [
          TextButton(onPressed: () => SystemNavigator.pop(), child: const Text("Exit App")),
          TextButton(
            onPressed: () async {
              if (url != null) {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: const Text("Update Now"),
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

    if (_showOnboarding) {
      return Scaffold(
        backgroundColor: AppColors.primaryDarkGreen,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (i) => setState(() => _currentPage = i),
          children: [
            WelcomePage(onContinue: () => _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut)),
            StatsPage(
              onBack: () => _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
              onNext: () => _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
            ),
            FeaturesPage(
              onBack: () => _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
              onNext: () => _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
            ),
            CityPage(
              onBack: () => _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
              onFinish: _runGatekeeperLogic, // Start original technical checks
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primaryDarkGreen,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (!_videoEnded && _isVideoInitialized && !_isLoading)
            Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: width * 0.8,
                  height: height * 0.3,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
          if (_videoEnded || (!_isVideoInitialized && _safetyTimerTriggered))
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppConstants.logo, width: width * 0.55, height: height * 0.22),
                  const SizedBox(height: 22),
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: const Text(
                      "Loading...",
                      style: TextStyle(
                        color: AppColors.primaryDarkGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (_isLoading)
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(color: Colors.white.withValues(alpha: 0.9)),
            ),
        ],
      ),
    );
  }
}
