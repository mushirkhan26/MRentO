import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  // ✅ Hardware categories — fashion categories hata diye
  static const List<Map<String, dynamic>> _categories = [
    {'name': 'Power Tools',  'icon': Icons.construction_rounded,    'bg': AppColors.categoryPowerBg,       'color': AppColors.categoryPowerText},
    {'name': 'Construction', 'icon': Icons.foundation_outlined,      'bg': AppColors.categoryConstructionBg,'color': AppColors.categoryConstructionText},
    {'name': 'Lifting',      'icon': Icons.forklift,                 'bg': AppColors.categoryLiftingBg,     'color': AppColors.categoryLiftingText},
    {'name': 'Cleaning',     'icon': Icons.cleaning_services_outlined,'bg': AppColors.categoryCleaningBg,   'color': AppColors.categoryCleaningText},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Empty state icon
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                  color: AppColors.background, shape: BoxShape.circle),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined,
                      size: 60, color: AppColors.primaryBlack),
                  Positioned(
                    right: 35,
                    bottom: 35,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.close,
                          size: 12, color: AppColors.grey707070),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Cart Khali Hai!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Abhi tak koi machine select nahi ki.\nSahi equipment dhundho aur kaam shuru karo!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.grey707070),
            ),
          ),
          const SizedBox(height: 24),
          // ✅ Updated CTA text
          ElevatedButton.icon(
            onPressed: () => context.go('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryYellow,
              foregroundColor: AppColors.primaryBlack,
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.construction_rounded, size: 18),
            label: const Text('Equipment Dhundho ↗',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 40),

          // Coupon section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.greyE5E7EB),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.confirmation_number_outlined,
                      color: Colors.orange, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Coupons aur offers dekho',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      Text(
                        // ✅ Updated coupon codes
                        'RENT50, FIRSTRENT aur aur bhi...',
                        style: TextStyle(fontSize: 12, color: AppColors.grey707070),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.grey707070),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Categories section header
          Row(
            children: [
              const Expanded(child: Divider()),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Yeh categories try karo',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.grey707070)),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 20),

          // ✅ Hardware categories grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _categories.map((cat) {
                return _buildCategoryItem(
                  cat['name'] as String,
                  cat['icon'] as IconData,
                  cat['bg'] as Color,
                  cat['color'] as Color,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 32),

          // Delivery banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.categoryPowerBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.local_shipping_outlined,
                    color: AppColors.categoryPowerText),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Doorstep Delivery Available',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.categoryPowerText),
                      ),
                      Text(
                        'Equipment ghar pe — booking pe scheduled',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.categoryPowerText),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right,
                    color: AppColors.categoryPowerText),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
      String title,
      IconData icon,
      Color bgColor,
      Color iconColor,
      ) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(title,
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }
}