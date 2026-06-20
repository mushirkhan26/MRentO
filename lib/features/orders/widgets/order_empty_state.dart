import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import 'order_card_widgets.dart';

class OrderEmptyState extends StatelessWidget {
  const OrderEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.receipt_long_outlined,
                      size: 60, color: AppColors.primaryBlack),
                  Positioned(
                    bottom: 35,
                    left: 30,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryYellow,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.construction_outlined,
                          size: 12, color: AppColors.primaryBlack),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Koi booking nahi abhi tak',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pehli machine rent karo aur kaam\nshuru karo aaj hi!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.grey707070),
          ),
          const SizedBox(height: 32),
          OrderActionButton(
            label: 'Equipment Dhundho ↗',
            isPrimary: true,
            onPressed: () => context.go('/home'),
          ),
          const SizedBox(height: 12),
          OrderActionButton(
            label: 'Categories dekho ↗',
            isPrimary: false,
            onPressed: () => context.go('/home'),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.dividerColor)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Kyun MRentO?',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.grey707070)),
              ),
              const Expanded(child: Divider(color: AppColors.dividerColor)),
            ],
          ),
          const SizedBox(height: 20),
          // ✅ Rental-appropriate features — fashion features hata diye
          _buildFeatureItem(
            'Verified Machines',
            'Quality-checked equipment, har baar',
            AppColors.categoryPowerBg,
            AppColors.categoryPowerText,
          ),
          _buildFeatureItem(
            'Doorstep Delivery & Pickup',
            'Ghar pe aata hai, wapas bhi le jaata hai',
            AppColors.categoryLiftingBg,
            AppColors.categoryLiftingText,
          ),
          _buildFeatureItem(
            'Security Deposit — 100% Refundable',
            'Machine wapas karo, deposit turant pao',
            AppColors.categoryCleaningBg,
            AppColors.categoryCleaningText,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
      String title,
      String subtitle,
      Color bgColor,
      Color iconColor,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.greyOutline.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.check_circle_outline,
                color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.grey707070)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right,
              color: AppColors.grey707070, size: 16),
        ],
      ),
    );
  }
}