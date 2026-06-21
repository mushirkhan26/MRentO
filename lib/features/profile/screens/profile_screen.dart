import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/navigation/app_routes.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_summary_cards.dart';
import '../widgets/profile_referral_banner.dart';
import '../widgets/profile_menu_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _locationAccess = true;
  // ✅ _aiStylist removed — fashion-specific, not relevant for rental
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.exploreBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileHeader(),
            const ProfileSummaryCards(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const ProfileReferralBanner(),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'MY ACTIVITY'),
                  _buildActivitySection(),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'ACCOUNT'),
                  _buildAccountSection(),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'PREFERENCES'),
                  _buildPreferencesSection(),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'SUPPORT'),
                  _buildSupportSection(),
                  const SizedBox(height: 32),
                  // ✅ Updated app name
                  const Text(
                    'MRentO v1.0.0 • Made with ❤️ in Jodhpur',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySection() {
    return SectionCard(children: [
      ProfileTile(
        icon: Icons.receipt_long_outlined,
        iconBg: AppColors.categoryPowerBg,
        iconColor: AppColors.categoryPowerText,
        title: 'My Bookings',
        subtitle: 'Orders and rental history',
        onTap: () => context.push(AppRoutes.ordersRoute),
      ),
      ProfileTile(
        customIcon: SvgPicture.asset('assets/icons/wishlist_3d.svg', width: 20, height: 20),
        iconBg: AppColors.categoryCleaningBg,
        iconColor: AppColors.categoryCleaningText,
        title: 'Saved Equipment',
        subtitle: 'Wishlisted items',
        onTap: () => context.push(AppRoutes.wishlistRoute),
      ),
      ProfileTile(
        customIcon: SvgPicture.asset('assets/icons/reviews_3d.svg', width: 20, height: 20),
        iconBg: AppColors.categoryMeasurementBg,
        iconColor: AppColors.categoryMeasurementText,
        title: 'My Reviews',
        subtitle: '4 reviews diye',
        onTap: () {},
      ),
      ProfileTile(
        customIcon: SvgPicture.asset('assets/icons/coupons_3d.svg', width: 20, height: 20),
        iconBg: AppColors.categoryConstructionBg,
        iconColor: AppColors.categoryConstructionText,
        title: 'Coupons & Offers',
        subtitle: '3 coupons available',
        trailing: const CountBadge(
            text: '3 new',
            bg: AppColors.categoryCleaningBg,
            textCol: AppColors.categoryCleaningText),
        onTap: () {},
        isLast: true,
      ),
    ]);
  }

  Widget _buildAccountSection() {
    return SectionCard(children: [
      ProfileTile(
        customIcon: SvgPicture.asset('assets/icons/location_3d.svg', width: 20, height: 20),
        iconBg: AppColors.categoryLiftingBg,
        iconColor: AppColors.categoryLiftingText,
        title: 'Saved Addresses',
        subtitle: 'Manage delivery addresses',
        onTap: () => context.push(AppRoutes.addressBook),
      ),
      ProfileTile(
        icon: Icons.payment_outlined,
        iconBg: AppColors.categoryMeasurementBg,
        iconColor: AppColors.categoryMeasurementText,
        title: 'Payment Methods',
        subtitle: 'Manage UPI and cards',
        onTap: () {},
      ),
      ProfileTile(
        customIcon: SvgPicture.asset('assets/icons/profile_3d.svg', width: 20, height: 20),
        iconBg: AppColors.gray50,
        iconColor: AppColors.grey707070,
        title: 'Personal Details',
        subtitle: 'Update profile info',
        onTap: () {},
        isLast: true,
      ),
    ]);
  }

  Widget _buildPreferencesSection() {
    return SectionCard(children: [
      ProfileTile(
        customIcon: SvgPicture.asset('assets/icons/notifications_3d.svg', width: 20, height: 20),
        iconBg: AppColors.categoryMeasurementBg,
        iconColor: AppColors.categoryMeasurementText,
        title: 'Notifications',
        subtitle: 'Booking updates, offers',
        onTap: () => context.push(AppRoutes.notifications),
      ),
      SwitchTile(
        customIcon: SvgPicture.asset('assets/icons/location_3d.svg', width: 20, height: 20),
        iconBg: AppColors.categoryCleaningBg,
        iconColor: AppColors.categoryCleaningText,
        title: 'Location Access',
        subtitle: 'Nearby vendor detection',
        value: _locationAccess,
        onChanged: (v) => setState(() => _locationAccess = v),
      ),
      SwitchTile(
        icon: Icons.dark_mode_outlined,
        iconBg: AppColors.gray50,
        iconColor: AppColors.primaryBlack,
        title: 'Dark Mode',
        subtitle: 'App theme',
        value: _darkMode,
        onChanged: (v) => setState(() => _darkMode = v),
        isLast: true,
      ),
    ]);
  }

  Widget _buildSupportSection() {
    return SectionCard(children: [
      ProfileTile(
        customIcon: SvgPicture.asset('assets/icons/help_3d.svg', width: 20, height: 20),
        iconBg: AppColors.categoryCleaningBg,
        iconColor: AppColors.categoryCleaningText,
        title: 'Help & Support',
        subtitle: 'Chat, call, FAQ',
        onTap: () => context.push(AppRoutes.helpRoute),
      ),
      ProfileTile(
        customIcon: SvgPicture.asset('assets/icons/terms_3d.svg', width: 20, height: 20),
        iconBg: AppColors.gray50,
        iconColor: AppColors.grey707070,
        title: 'Terms & Privacy',
        subtitle: 'Policies aur conditions',
        onTap: () {},
      ),
      ProfileTile(
        customIcon: SvgPicture.asset('assets/icons/logout_3d.svg', width: 20, height: 20),
        iconBg: const Color(0xFFFFEBEE),
        iconColor: AppColors.errorRed,
        title: 'Log Out',
        subtitle: 'Sign out from your account',
        onTap: () {
          context.read<AuthBloc>().add(LogoutRequested());
          context.go(AppRoutes.loginRoute);
        },
        isLast: true,
      ),
    ]);
  }
}