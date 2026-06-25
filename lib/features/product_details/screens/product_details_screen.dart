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
import '../../wishlist/bloc/wishlist_bloc.dart';
import '../../wishlist/bloc/wishlist_event.dart';
import '../../wishlist/bloc/wishlist_state.dart';
import '../bloc/product_details_bloc.dart';
import '../bloc/product_details_event.dart';
import '../bloc/product_details_state.dart';
import '../widgets/product_image_carousel.dart';
import '../widgets/product_header_section.dart';
import '../widgets/rental_duration_selector.dart';
import '../widgets/product_details_info.dart';
import '../widgets/review_section.dart';
import '../widgets/trust_banner.dart';
import '../widgets/how_it_works_section.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  final RentalProductModel? initialProduct;

  const ProductDetailsScreen({
    super.key, 
    required this.productId, 
    this.initialProduct,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsBloc()
        ..add(ProductDetailsStarted(
          productId: productId, 
          initialProduct: initialProduct,
        )),
      child: _ProductDetailsView(productId: productId),
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  final String productId;
  const _ProductDetailsView({required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        if ((state.status == ProductDetailsStatus.initial ||
                state.status == ProductDetailsStatus.loading) &&
            state.product == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primaryYellow),
            ),
          );
        }

        if (state.status == ProductDetailsStatus.error && state.product == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? 'Kuch galat hua'),
                  TextButton(
                    onPressed: () => context
                        .read<ProductDetailsBloc>()
                        .add(ProductDetailsStarted(productId: state.product?.id ?? productId)),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        final product = state.product!;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: _circleIconButton(
              context,
              Icons.close,
              () => Navigator.pop(context),
            ),
            title: Text(
              product.name,
              style: const TextStyle(
                color: AppColors.primaryBlack,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            centerTitle: true,
            actions: [
              _circleIconButton(
                context,
                Icons.share_outlined,
                () {
                  // Share logic
                },
              ),
              const SizedBox(width: 4),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  final String? userId = authState is AuthAuthenticated ? authState.user.id : null;
                  
                  return BlocBuilder<WishlistBloc, WishlistState>(
                    builder: (context, wishlistState) {
                      final isWishlisted = wishlistState is WishlistLoaded &&
                          wishlistState.items.any((i) => i.id == product.id);

                      return _circleIconButton(
                        context,
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        () {
                          if (userId == null) {
                            AlertHelper.snackBarWarning(context, 'Pehle login karein');
                            return;
                          }
                          context
                              .read<WishlistBloc>()
                              .add(ToggleWishlist(userId: userId, product: product));
                          AlertHelper.snackBarSuccess(
                            context,
                            isWishlisted
                                ? 'Wishlist se hataya'
                                : 'Wishlist mein add kiya',
                          );
                        },
                        iconColor: isWishlisted ? Colors.red : AppColors.primaryBlack,
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductImageCarousel(
                        product: product,
                        selectedIndex: state.selectedImageIndex,
                        onPageChanged: (i) => context
                            .read<ProductDetailsBloc>()
                            .add(ImageIndexChanged(i)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProductHeaderSection(product: product),
                            const SizedBox(height: 24),

                            if (state.availableDurations.isNotEmpty)
                              RentalDurationSelector(
                                options: state.availableDurations,
                                selected: state.selectedDuration,
                                onSelected: (dur) => context
                                    .read<ProductDetailsBloc>()
                                    .add(RentalDurationChanged(dur)),
                              ),

                            const SizedBox(height: 32),
                            const TrustBanner(),
                            const SizedBox(height: 32),
                            const HowItWorksSection(),
                            const SizedBox(height: 32),
                            _buildVendorInfoBanner(product),
                            const SizedBox(height: 32),
                            ProductDetailsInfo(product: product),
                            const SizedBox(height: 32),
                            ReviewSection(productId: product.id),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomActions(context, product, state.selectedDuration),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVendorInfoBanner(RentalProductModel product) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.categoryPowerBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.storefront_outlined,
              color: AppColors.primaryBlack,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.vendorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlack,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product.vendorAddress,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.categoryPowerText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: product.stock > 0
                  ? AppColors.categoryCleaningBg
                  : AppColors.errorRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              product.stock > 0
                  ? '${product.stock} available'
                  : 'Out of stock',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: product.stock > 0
                    ? AppColors.categoryCleaningText
                    : AppColors.errorRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton(
    BuildContext context,
    IconData icon,
    VoidCallback onTap, {
    Color iconColor = AppColors.primaryBlack,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.greyE5E7EB),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, RentalProductModel product, RentalDurationOption? selectedDuration) {
    final bool inStock = product.stock > 0;
    final double selectedPrice = selectedDuration?.price ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grey200, width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '₹${selectedPrice.toInt()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          color: AppColors.primaryBlack,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.info_outline, size: 14, color: AppColors.grey400),
                    ],
                  ),
                  const Text(
                    'VIEW DETAILED BILL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AppColors.successColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 180,
              height: 50,
              child: ElevatedButton(
                onPressed: inStock ? () => _rentNow(context, product, selectedDuration) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryYellow,
                  foregroundColor: AppColors.primaryBlack,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      inStock ? 'Rent Now' : 'Out of Stock',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    if (inStock) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _rentNow(BuildContext context, RentalProductModel product, RentalDurationOption? selectedDuration) {
    if (selectedDuration == null) {
      AlertHelper.snackBarWarning(context, 'Pehle rental duration select karo');
      return;
    }
    
    context.read<CartBloc>().add(
      AddToCart(
        CartItem(
          productId: product.id,
          productName: product.name,
          productImage: product.images.isNotEmpty ? product.images.first : null,
          quantity: 1,
          price: selectedDuration.price,
          vendorName: product.vendorName,
          rentalDurationLabel: selectedDuration.label,
          rentalDays: selectedDuration.days,
          securityDeposit: product.securityDeposit,
        ),
      ),
    );
    
    Navigator.pop(context);
    context.push('/checkout');
  }
}
