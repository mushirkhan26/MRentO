import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/utils/url_launcher_helper.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const String supportNumber = "+919460433786"; // TODO: Update with actual number

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primaryBlack,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aapki madad ke liye hum yahan hain',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlack,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Niche diye gaye options se humein contact karein',
              style: TextStyle(fontSize: 14, color: AppColors.grey600),
            ),
            const SizedBox(height: 32),

            _buildBigButton(
              customIcon: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SvgPicture.asset(
                  'assets/icons/call_support_3d.svg',
                  width: 32,
                  height: 32,
                ),
              ),
              title: 'Humein Call Karein',
              subtitle: 'Baat karein hamare support team se',
              color: const Color(0xFFE8F5E9),
              iconColor: Colors.green.shade700,
              onTap: () => UrlLauncherHelper.launchPhoneCall(supportNumber),
            ),

            const SizedBox(height: 16),

            _buildBigButton(
              customIcon: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SvgPicture.asset(
                  'assets/icons/whatsapp_3d.svg',
                  width: 32,
                  height: 32,
                ),
              ),
              title: 'WhatsApp Chat',
              subtitle: 'Message karein jaldi help ke liye',
              color: const Color(0xFFE1F5FE),
              iconColor: Colors.blue.shade700,
              onTap: () => UrlLauncherHelper.launchWhatsApp(
                supportNumber,
                message: "Namaste MRentO Support, mujhe help chahiye.",
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildBigButton(
              customIcon: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SvgPicture.asset(
                  'assets/icons/faq_3d.svg',
                  width: 32,
                  height: 32,
                ),
              ),
              icon: Icons.question_answer_rounded,
              title: 'Sawaal & Jawaab (FAQ)',
              subtitle: 'Common questions ke answers',
              color: const Color(0xFFFFF3E0),
              iconColor: Colors.orange.shade700,
              onTap: () {
                // Future: Navigate to FAQ screen
              },
            ),
            
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),
            
            _buildTile(
              customIcon: SvgPicture.asset('assets/icons/profile_3d.svg', width: 24, height: 24),
              title: 'My Profile',
              onTap: () => context.push(AppRoutes.userProfile),
            ),
            _buildTile(
              customIcon: SvgPicture.asset('assets/icons/location_3d.svg', width: 24, height: 24),
              title: 'Saved Addresses',
              onTap: () => context.push(AppRoutes.addressBook),
            ),
            _buildTile(
              customIcon: SvgPicture.asset('assets/icons/terms_3d.svg', width: 24, height: 24),
              title: 'Terms & Conditions',
              onTap: () {},
            ),

            _buildTile(
              customIcon: SvgPicture.asset('assets/icons/privacy_3d.svg', width: 24, height: 24),
              title: 'Privacy Policy',
              onTap: () {},
            ),
            
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'MRentO v1.0.0 • Made with ❤️ in Jodhpur',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBigButton({
    IconData? icon,
    Widget? customIcon,
    required String title,
    required String subtitle,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: customIcon ?? Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlack,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.grey500),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    IconData? icon,
    Widget? customIcon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: customIcon ?? Icon(icon, color: AppColors.primaryBlack),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    );
  }
}

