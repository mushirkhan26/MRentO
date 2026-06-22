import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:MRentO/core/utils/alert_utils.dart';
import 'package:MRentO/config/theme/app_colors.dart';
import 'package:MRentO/config/navigation/app_routes.dart';
import 'package:MRentO/core/services/analytics_service.dart';
import 'package:MRentO/widgets/navigation/animated_lottie_icon.dart';

class NavigationHost extends StatefulWidget {
  final Widget child;
  const NavigationHost({super.key, required this.child});

  @override
  State<NavigationHost> createState() => _NavigationHostState();
}

class _NavigationHostState extends State<NavigationHost> {
  int _selectedIndex = 0;
  DateTime? _lastBackPressed;


  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newIndex = _getSelectedIndex(context);
    if (newIndex != _selectedIndex) {
      setState(() => _selectedIndex = newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          if (_selectedIndex != 0) {
            setState(() => _selectedIndex = 0);
            context.go(_routes[0]);
          } else {
            if (_canExit()) {
              SystemNavigator.pop();
            } else {
              if (!mounted) return;
              AlertHelper.snackBarInfo(context, "Back again to exit");
            }
          }
        }
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                if (index != _selectedIndex) {
                  setState(() => _selectedIndex = index);
                  _navigateTo(index);
                }
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.primaryDarkGreen,
              unselectedItemColor: AppColors.grey808080,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              iconSize: 32, // Increased size for detailed 3D icons
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/home.svg',
                    width: 24,
                    height: 24,
                  ),
                  activeIcon: AnimatedLottieIcon(
                    assetPath: 'assets/lottie/home.json',
                    isSelected: _selectedIndex == 0,
                    size: 28,
                    color: AppColors.primaryDarkGreen,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/order.svg',
                    width: 24,
                    height: 24,
                  ),
                  activeIcon: AnimatedLottieIcon(
                    assetPath: 'assets/lottie/order.json',
                    isSelected: _selectedIndex == 1,
                    size: 28,
                    color: AppColors.primaryDarkGreen,
                  ),
                  label: 'My Orders',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/help.svg',
                    width: 24,
                    height: 24,
                  ),
                  activeIcon: AnimatedLottieIcon(
                    assetPath: 'assets/lottie/help.json',
                    isSelected: _selectedIndex == 2,
                    size: 28,
                    color: AppColors.primaryDarkGreen,
                  ),
                  label: 'Help',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _canExit() {
    final now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      return false;
    }
    return true;
  }

  int _getSelectedIndex(BuildContext context) {
    try {
      // GoRouterState.of(context) ka sahi upyog
      final location = GoRouterState.of(context).uri.toString();
      final index = _routes.indexWhere((r) => location.startsWith(r));
      return index == -1 ? 0 : index;
    } catch (e) {
      return 0; // Fallback agar state na mile
    }
  }
  // int _getSelectedIndex(BuildContext context) {
  //   final location = GoRouterState.of(context).uri.toString();
  //   final index = _routes.indexWhere((r) => location.startsWith(r));
  //   return index == -1 ? 0 : index;
  // }

  static const _routes = [
    AppRoutes.homeRoute,
    AppRoutes.ordersRoute,
    AppRoutes.helpRoute,
  ];

  void _navigateTo(int index) {
    String screenName = '';
    switch (index) {
      case 0:
        screenName = 'Home';
        context.go(AppRoutes.homeRoute);
        break;
      case 1:
        screenName = 'Orders';
        context.go(AppRoutes.ordersRoute);
        break;
      case 2:
        screenName = 'Help';
        context.go(AppRoutes.helpRoute);
        break;
    }
    if (screenName.isNotEmpty) {
      AnalyticsService.instance.setCurrentScreen(screenName);
    }
  }
}

