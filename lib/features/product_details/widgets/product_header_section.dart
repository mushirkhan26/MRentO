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
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            color: AppColors.primaryBlack,
          ),
        ),


        const SizedBox(height: 12),

        // Rental pricing row
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (product.rentPerDay != null) ...[
              const Text(
                '₹',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryBlack,
                ),
              ),
              Text(
                '${product.rentPerDay!.toInt()}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryBlack,
                ),
              ),
              const Text(
                ' /day',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),

        // Security deposit info - Highlighted
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F7FF), // Light blue tint for security/trust
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.infoColor.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                size: 20,
                color: AppColors.infoColor,
              ),

              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 13, color: AppColors.primaryBlack),
                        children: [
                          const TextSpan(text: 'Security Deposit: '),
                          TextSpan(
                            text: '₹${product.securityDeposit.toInt()}',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '100% Refundable instantly after return',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.infoColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}