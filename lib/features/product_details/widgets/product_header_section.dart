import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/rental_product_model.dart'; // ← RentalProductModel
import 'product_badge.dart';

class ProductHeaderSection extends StatelessWidget {
  final RentalProductModel product; // ← updated
  const ProductHeaderSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vendor name + rating
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.storefront_outlined,
                  size: 14,
                  color: AppColors.grey707070,
                ),
                const SizedBox(width: 4),
                Text(
                  product.vendorName,
                  style: const TextStyle(
                    color: AppColors.grey707070,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            if (product.reviewCount > 0)
              ProductBadge(
                label: '★ ${product.rating} · ${product.reviewCount} reviews',
                bgColor: AppColors.primaryYellow.withValues(alpha: 0.2),
                textColor: AppColors.primaryDarkYellow,
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Product name
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlack,
          ),
        ),
        const SizedBox(height: 10),

        // Rental pricing row
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (product.rentPerDay != null) ...[
              Text(
                '₹${product.rentPerDay!.toInt()}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlack,
                ),
              ),
              const Text(
                '/din',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey707070,
                ),
              ),
            ],
            if (product.rentFor3Days != null) ...[
              const SizedBox(width: 12),
              ProductBadge(
                label: '3 din: ₹${product.rentFor3Days!.toInt()}',
                bgColor: AppColors.primaryYellow.withValues(alpha: 0.15),
                textColor: AppColors.primaryBlack,
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),

        // Security deposit info
        Row(
          children: [
            const Icon(
              Icons.security_outlined,
              size: 14,
              color: AppColors.grey707070,
            ),
            const SizedBox(width: 4),
            Text(
              'Security deposit: ₹${product.securityDeposit.toInt()} (refundable)',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.grey707070,
              ),
            ),
          ],
        ),
      ],
    );
  }
}