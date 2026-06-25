import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/rental_product_model.dart'; // ← RentalProductModel

class ProductDetailsInfo extends StatelessWidget {
  final RentalProductModel product; // ← updated
  const ProductDetailsInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primaryBlack,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          product.description,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.grey707070,
            height: 1.6,
          ),
        ),

        // ── Specifications ──────────────────────────────────────
        if (product.specifications.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            'Specifications',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.primaryBlack,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.greyOutline.withValues(alpha: 0.4),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: product.specifications.entries
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                final isLast =
                    entry.key == product.specifications.length - 1;
                final spec = entry.value;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            spec.key,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.grey707070,
                            ),
                          ),
                          Text(
                            spec.value,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      const Divider(height: 1, color: AppColors.dividerColor),
                  ],
                );
              }).toList(),
            ),
          ),
        ],

        // ── What's included ─────────────────────────────────────
        if (product.includes.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text(
            "What's in the box?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.primaryBlack,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: product.includes.map((item) => _chip(item)).toList(),
          ),
        ],

        // ── Tags ────────────────────────────────────────────────
        if (product.tags.isNotEmpty) ...[
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product.tags.map((tag) => _tag(tag)).toList(),
          ),
        ],
      ],
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.categoryCleaningBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 14,
            color: AppColors.categoryCleaningText,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.categoryCleaningText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.exploreBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.greyOutline.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.grey707070,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}