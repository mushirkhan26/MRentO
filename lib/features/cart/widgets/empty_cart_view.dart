import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/navigation/app_routes.dart';
import '../../search/widgets/recently_viewed_widget.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  static const List<Map<String, dynamic>> _categories = [
    {'id': 'power-tools', 'name': 'Power Tools', 'icon': Icons.construction_rounded, 'bg': AppColors.categoryPowerBg, 'color': AppColors.categoryPowerText},
    {'id': 'construction', 'name': 'Construction', 'icon': Icons.foundation_outlined, 'bg': AppColors.categoryConstructionBg, 'color': AppColors.categoryConstructionText},
    {'id': 'lifting', 'name': 'Lifting', 'icon': Icons.forklift, 'bg': AppColors.categoryLiftingBg, 'color': AppColors.categoryLiftingText},
    {'id': 'cleaning', 'name': 'Cleaning', 'icon': Icons.cleaning_services_outlined, 'bg': AppColors.categoryCleaningBg, 'color': AppColors.categoryCleaningText},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Empty state Lottie Animation
          Center(
            child: Lottie.asset(
              'assets/lottie/cartEmpty.json',
              width: 170,
              height: 170,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                      color: AppColors.background, shape: BoxShape.circle),
                  child: const Icon(Icons.shopping_bag_outlined,
                      size: 60, color: AppColors.primaryBlack),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Aapka Cart Khali Hai!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              
              'Sahi machine dhundhein aur apna kaam aaj hi shuru karein!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.grey707070, height: 1.4),
            ),
          ),
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.homeRoute),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryYellow,
                  foregroundColor: AppColors.primaryBlack,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.search, size: 18),
                label: const Text('Browse Karein', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.wishlistRoute),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlack,
                  side: const BorderSide(color: AppColors.greyE5E7EB),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.favorite_border, size: 18),
                label: const Text('Wishlist', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Coupon section (Interactive)
          InkWell(
            onTap: () => _showCouponInfo(context),
            child: Container(
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
                    child: const Icon(Icons.confirmation_number_outlined, color: Colors.orange, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Available Coupons & Offers',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text(
                          'MRENTO100, FIRSTRENT aur aur bhi...',
                          style: TextStyle(fontSize: 11, color: AppColors.grey707070),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.grey707070, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Categories section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text('Explore Categories', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                return _buildCategoryItem(
                  context,
                  cat['id'] as String,
                  cat['name'] as String,
                  cat['icon'] as IconData,
                  cat['bg'] as Color,
                  cat['color'] as Color,
                );
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Recently Viewed Section
          const RecentlyViewedWidget(),
          
          const SizedBox(height: 24),

          // Delivery banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.categoryPowerBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.local_shipping_outlined, color: AppColors.categoryPowerText),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Doorstep Delivery & Pickup',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.categoryPowerText),
                      ),
                      Text(
                        'Scheduled at your convenience',
                        style: TextStyle(fontSize: 11, color: AppColors.categoryPowerText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    String id,
    String title,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return InkWell(
      onTap: () {
        // Navigate to search with category filter
        context.push(AppRoutes.searchRoute, extra: title);
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showCouponInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Available Coupons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _couponTile('MRENTO100', 'Flat ₹100 OFF on your order'),
            const Divider(),
            _couponTile('FIRSTRENT', 'Free delivery on your first rental'),
            const Divider(),
            _couponTile('RENT50', 'Get 50% OFF on security deposit'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlack,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _couponTile(String code, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryYellow.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.primaryYellow),
            ),
            child: Text(code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(desc, style: const TextStyle(fontSize: 13, color: AppColors.grey707070))),
        ],
      ),
    );
  }
}
