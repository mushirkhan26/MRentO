import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/rental_product_model.dart';
import '../../../core/models/cart_model.dart';
import '../../../core/utils/alert_utils.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../bloc/wishlist_bloc.dart';
import '../bloc/wishlist_event.dart';
import '../bloc/wishlist_state.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  void _loadWishlist() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<WishlistBloc>().add(LoadWishlist(authState.user.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.exploreBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack,
        foregroundColor: Colors.white,
        title: BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            final count =
            state is WishlistLoaded ? state.items.length : 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Saved Equipment',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text('$count items saved',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.white60)),
              ],
            );
          },
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return const Center(child: Text('Pehle login karein'));
          }
          final userId = authState.user.userId;
          
          return BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, state) {
              if (state is WishlistLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is WishlistLoaded) {
                if (state.items.isEmpty) return _buildEmptyState(context);

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    return _WishlistItemTile(
                      product: state.items[index],
                      userId: userId,
                    );
                  },
                );
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
                color: AppColors.background, shape: BoxShape.circle),
            child: const Icon(Icons.favorite_border,
                size: 56, color: AppColors.primaryBlack),
          ),
          const SizedBox(height: 20),
          const Text('Koi machine save nahi ki',
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Equipment dekho aur dil pasand\nmachines yahan save karo',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey707070),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryYellow,
              foregroundColor: AppColors.primaryBlack,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Equipment Dhundho ↗',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _WishlistItemTile extends StatelessWidget {
  final RentalProductModel product;
  final String userId;

  const _WishlistItemTile({required this.product, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greyE5E7EB),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: product.images.isNotEmpty
                ? Image.network(
              product.images.first,
              width: 80,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _imgPlaceholder(),
            )
                : _imgPlaceholder(),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vendor + remove button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.storefront_outlined,
                            size: 11, color: AppColors.grey707070),
                        const SizedBox(width: 3),
                        Text(product.vendorName,
                            style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.grey707070)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => context
                          .read<WishlistBloc>()
                          .add(ToggleWishlist(userId: userId, product: product)),
                      child: const Icon(Icons.favorite,
                          size: 18, color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Name
                Text(product.name,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                // Availability badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: product.isAvailable
                        ? AppColors.categoryCleaningBg
                        : AppColors.errorRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    product.isAvailable ? 'Available' : 'Not Available',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: product.isAvailable
                            ? AppColors.categoryCleaningText
                            : AppColors.errorRed),
                  ),
                ),
                const SizedBox(height: 8),
                // Price row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    product.rentPerDay != null
                        ? RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text:
                          '₹${product.rentPerDay!.toInt()}',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlack),
                        ),
                        const TextSpan(
                          text: '/din',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColors.grey707070),
                        ),
                      ]),
                    )
                        : const SizedBox(),
                    // Add to cart
                    if (product.isAvailable)
                      GestureDetector(
                        onTap: () => _addToCart(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryYellow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Add to Cart',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlack)),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context) {
    context.read<CartBloc>().add(
      AddToCart(
        CartItem(
          productId: product.id,
          productName: product.name,
          productImage:
          product.images.isNotEmpty ? product.images.first : null,
          quantity: 1,
          price: product.rentPerDay ?? product.effectiveDailyRate,
          vendorName: product.vendorName,
          rentalDurationLabel: '1 Din',
          rentalDays: 1,
          securityDeposit: product.securityDeposit,
        ),
      ),
    );
    AlertHelper.snackBarSuccess(
        context, '${product.name} cart mein add hua!');
  }

  Widget _imgPlaceholder() {
    return Container(
      width: 80,
      height: 90,
      color: AppColors.categoryPowerBg,
      child: const Center(
        child: Icon(Icons.construction_rounded,
            color: AppColors.categoryPowerText, size: 32),
      ),
    );
  }
}