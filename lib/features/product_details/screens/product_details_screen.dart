import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/rental_product_model.dart'; // ← RentalProductModel
import '../../../core/models/cart_model.dart';
import '../../../core/utils/alert_utils.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../wishlist/bloc/wishlist_bloc.dart';
import '../../wishlist/bloc/wishlist_event.dart';
import '../../wishlist/bloc/wishlist_state.dart';
import '../widgets/product_image_carousel.dart';
import '../widgets/product_header_section.dart';
import '../widgets/rental_duration_selector.dart'; // ← NEW (replaces size_selector)
import '../widgets/product_details_info.dart';
import '../widgets/review_section.dart';
// Note: color_selector, size_selector, ai_try_on_banner — ab use nahi ho rahe
// Phase 4 me delete kar sakte ho

class ProductDetailsScreen extends StatefulWidget {
  final RentalProductModel product; // ← RentalProductModel

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedImageIndex = 0;
  RentalDurationOption? _selectedDuration;

  /// Available durations based on what vendor has set
  List<RentalDurationOption> get _availableDurations {
    final List<RentalDurationOption> options = [];
    if (widget.product.rentPerDay != null) {
      options.add(RentalDurationOption(
        label: '1 Din',
        days: 1,
        price: widget.product.rentPerDay!,
      ));
    }
    if (widget.product.rentFor3Days != null) {
      options.add(RentalDurationOption(
        label: '3 Din',
        days: 3,
        price: widget.product.rentFor3Days!,
      ));
    }
    if (widget.product.rentPerWeek != null) {
      options.add(RentalDurationOption(
        label: '1 Hafta',
        days: 7,
        price: widget.product.rentPerWeek!,
      ));
    }
    return options;
  }

  @override
  void initState() {
    super.initState();
    final durations = _availableDurations;
    if (durations.isNotEmpty) {
      _selectedDuration = durations.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: _circleIconButton(
          Icons.close,
              () => Navigator.pop(context),
        ),
        title: const Text(
          'Equipment details',
          style: TextStyle(
            color: AppColors.primaryBlack,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final String? userId = authState is AuthAuthenticated ? authState.user.id : null;
              
              return BlocBuilder<WishlistBloc, WishlistState>(
                builder: (context, state) {
                  final isWishlisted = state is WishlistLoaded &&
                      state.items.any((i) => i.id == widget.product.id);

                  return _circleIconButton(
                    isWishlisted ? Icons.favorite : Icons.favorite_border,
                    () {
                      if (userId == null) {
                        AlertHelper.snackBarWarning(context, 'Pehle login karein');
                        return;
                      }
                      context
                          .read<WishlistBloc>()
                          .add(ToggleWishlist(userId: userId, product: widget.product));
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
                    product: widget.product,
                    selectedIndex: _selectedImageIndex,
                    onPageChanged: (i) =>
                        setState(() => _selectedImageIndex = i),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name, vendor, pricing, deposit
                        ProductHeaderSection(product: widget.product),
                        const SizedBox(height: 24),

                        // Rental duration selector
                        if (_availableDurations.isNotEmpty)
                          RentalDurationSelector(
                            options: _availableDurations,
                            selected: _selectedDuration,
                            onSelected: (dur) =>
                                setState(() => _selectedDuration = dur),
                          ),

                        const SizedBox(height: 24),

                        // Vendor info banner (AI try-on ki jagah)
                        _buildVendorInfoBanner(),

                        const SizedBox(height: 32),

                        // Description, specs, includes, tags
                        ProductDetailsInfo(product: widget.product),
                        const SizedBox(height: 32),

                        ReviewSection(productId: widget.product.id),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  /// Vendor info banner — ai_try_on_banner ki jagah
  Widget _buildVendorInfoBanner() {
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
                  widget.product.vendorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlack,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.product.vendorAddress,
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
          // Stock badge
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: widget.product.stock > 0
                  ? AppColors.categoryCleaningBg
                  : AppColors.errorRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.product.stock > 0
                  ? '${widget.product.stock} available'
                  : 'Out of stock',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: widget.product.stock > 0
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

  Widget _buildBottomActions() {
    final bool inStock = widget.product.stock > 0;
    final double selectedPrice = _selectedDuration?.price ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Price display
            Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.greyOutline.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '₹${selectedPrice.toInt()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryBlack,
                    ),
                  ),
                  Text(
                    _selectedDuration?.label ?? '',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.grey707070,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Add to Cart
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: inStock ? _addToCart : null,
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
                      const Icon(Icons.add_shopping_cart_outlined, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          inStock ? 'Cart mein add karo' : 'Out of stock',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Rent Now (direct checkout)
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: inStock ? _rentNow : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlack,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Rent Now ↗',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart() {
    if (_selectedDuration == null) {
      AlertHelper.snackBarWarning(context, 'Pehle rental duration select karo');
      return;
    }
    context.read<CartBloc>().add(
      AddToCart(
        CartItem(
          productId: widget.product.id,
          productName: widget.product.name,
          productImage: widget.product.images.isNotEmpty
              ? widget.product.images.first
              : null,
          quantity: 1,
          price: _selectedDuration!.price,
          vendorName: widget.product.vendorName,
          rentalDurationLabel: _selectedDuration!.label,
          rentalDays: _selectedDuration!.days,
          securityDeposit: widget.product.securityDeposit,
        ),
      ),
    );
    AlertHelper.snackBarSuccess(
      context,
      '${widget.product.name} cart mein add hua!',
    );
  }

  void _rentNow() {
    if (_selectedDuration == null) {
      AlertHelper.snackBarWarning(context, 'Pehle rental duration select karo');
      return;
    }
    _addToCart();
    Navigator.pop(context);
    context.push('/checkout');
  }
}