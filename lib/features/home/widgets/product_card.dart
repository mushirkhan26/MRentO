  import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../search/bloc/search_bloc.dart';
import '../../search/bloc/search_event.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/rental_product_model.dart';

class ProductCard extends StatelessWidget {
  final RentalProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Record as recently viewed
        context.read<SearchBloc>().add(AddToRecentlyViewed(product));
        context.push('/product-details', extra: product);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image + badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
                  child: product.images.isNotEmpty
                      ? Image.network(
                    product.images[0],
                    height: 130, // Reduced from 150
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                      : _placeholder(),
                ),
                // Available / Out of stock badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: product.isAvailable
                          ? AppColors.primaryYellow
                          : AppColors.errorRed.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.isAvailable ? 'Available' : 'Unavailable',
                      style: TextStyle(
                        color: product.isAvailable
                            ? AppColors.primaryBlack
                            : Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Condition badge top-right
                if (product.condition != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified_outlined,
                          size: 14, color: AppColors.primaryBlack),
                    ),
                  ),
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vendor name
                  Text(
                    product.vendorName,
                    style: const TextStyle(
                        color: AppColors.grey707070, fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  // Machine name
                  SizedBox(
                    height: 30, // Slightly reduced from 32
                    child: Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600, height: 1.2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rent per day
                      Expanded(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: product.rentPerDay != null
                                    ? '₹${product.rentPerDay!.toInt()}'
                                    : '₹${product.effectiveDailyRate.toInt()}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlack,
                                ),
                              ),
                              const TextSpan(
                                text: '/din',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.grey707070),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Add button
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryYellow,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add,
                            color: AppColors.primaryBlack, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 130, // Reduced from 150
      width: double.infinity,
      color: AppColors.categoryPowerBg,
      child: const Center(
        child: Icon(Icons.construction_rounded,
            color: AppColors.categoryPowerText, size: 40),
      ),
    );
  }
}
