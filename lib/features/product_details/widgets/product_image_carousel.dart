import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/rental_product_model.dart'; // ← RentalProductModel
import 'product_badge.dart';

class ProductImageCarousel extends StatelessWidget {
  final RentalProductModel product; // ← updated
  final int selectedIndex;
  final ValueChanged<int> onPageChanged;

  const ProductImageCarousel({
    super.key,
    required this.product,
    required this.selectedIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final images = product.images;
    final imageCount = images.isEmpty ? 1 : images.length;

    return Stack(
      children: [
        Container(
          height: 380,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.greyOutline.withValues(alpha: 0.2),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: images.isEmpty
                ? const Center(
              child: Icon(
                Icons.construction_outlined,
                size: 80,
                color: Colors.black12,
              ),
            )
                : PageView.builder(
              itemCount: images.length,
              onPageChanged: onPageChanged,
              itemBuilder: (context, index) {
                return Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryYellow,
                        strokeWidth: 2,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stack) {
                    return const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 60,
                        color: Colors.black12,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        // Condition badge (New / Like New / Good)
        if (product.condition != null)
          Positioned(
            top: 25,
            left: 35,
            child: ProductBadge(
              label: product.condition!,
              bgColor: AppColors.primaryBlack,
              textColor: Colors.white,
              icon: Icons.verified_outlined,
            ),
          ),
        // Vendor name top-right
        Positioned(
          top: 25,
          right: 35,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              product.vendorName,
              style: const TextStyle(
                color: AppColors.primaryBlack,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Dot indicators
        if (imageCount > 1)
          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imageCount,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: index == selectedIndex ? 18 : 6,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: index == selectedIndex
                        ? AppColors.primaryBlack
                        : AppColors.primaryBlack.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
          ),
        // Image count badge (Blinkit style)
        if (imageCount > 1)
          Positioned(
            bottom: 25,
            right: 35,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${selectedIndex + 1}/$imageCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}