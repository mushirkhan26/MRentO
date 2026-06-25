import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_state.dart';
import '../../../core/models/rental_product_model.dart';
import '../../../config/theme/app_colors.dart';

class RecentlyViewedWidget extends StatelessWidget {
  const RecentlyViewedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final List<RentalProductModel> recentItems = state.recentlyViewed;
        
        if (recentItems.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Text(
                'Recently Viewed',
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 18, 
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(
              height: 185,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recentItems.length,
                itemBuilder: (context, index) {
                  final product = recentItems[index];
                  return _buildProductCard(context, product);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductCard(BuildContext context, RentalProductModel product) {
    return GestureDetector(
      onTap: () {
        context.push('/product-details', extra: product);
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 1,
                child: product.images.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: product.images[0],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade100,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      )
                    : Container(
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${product.rentPerDay?.toInt() ?? 0}/day',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.primaryDarkGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
