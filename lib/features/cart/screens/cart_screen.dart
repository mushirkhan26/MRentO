import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/cart_model.dart';
import '../widgets/cart_delivery_banner.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_promo_cards.dart';
import '../widgets/cart_coupon_section.dart';
import '../widgets/cart_price_breakdown.dart';
import '../widgets/empty_cart_view.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Cart',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoaded) {
                  return Text(
                    '${state.cart.items.length} items',
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        actions: const [
          // Removed Deposit badge for a cleaner look as per feedback
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            final cart = state.cart;
            if (cart.items.isEmpty) return const EmptyCartView();

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 16),
                    children: [
                      const CartDeliveryBanner(),
                      ...cart.items.map((item) => CartItemTile(item: item)),
                      const FreeDeliveryPromo(),
                      const SecurityDepositBanner(), // ✅ updated
                      const CartCouponSection(),
                      CartPriceBreakdown(cart: cart),
                    ],
                  ),
                ),
                SafeArea(
                  top: false,
                  child: _buildStickyFooter(context, cart),
                ),
              ],
            );
          } else if (state is CartError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  Widget _buildStickyFooter(BuildContext context, CartModel cart) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -4))
        ],
      ),
      child: ElevatedButton(
        onPressed: () => context.push('/checkout'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryYellow,
          foregroundColor: AppColors.primaryBlack,
          padding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total: ₹${cart.grandTotal.toInt()}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w900)),
                Text('${cart.items.length} item${cart.items.length > 1 ? 's' : ''} select kiye',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
            const Row(
              children: [
                Text('Checkout Karein',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w900)),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}