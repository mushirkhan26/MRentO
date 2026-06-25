import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
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
        elevation: 0,
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
                    '${state.cart.items.length} items select kiye',
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.cart.items.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white70),
                  onPressed: () => _confirmClearCart(context),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
          buildWhen: (previous, current) {
            // Agar pehle se CartLoaded tha, toh Error state pe pura screen change mat karo
            // Sirf Loading aur Loaded states pe rebuild hone do, ya fir agar pehli baar error aaye
            if (current is CartError && previous is CartLoaded) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            if (state is CartLoading) {
              return _buildShimmerLoading();
            } else if (state is CartLoaded) {
              final cart = state.cart;
              if (cart.items.isEmpty) return const EmptyCartView();

              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<CartBloc>().add(LoadCart());
                      },
                      color: AppColors.primaryYellow,
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 16),
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const CartDeliveryBanner(),
                          ...cart.items.map((item) => CartItemTile(item: item)),
                          const FreeDeliveryPromo(),
                          const SecurityDepositBanner(),
                          const CartCouponSection(),
                          CartPriceBreakdown(cart: cart),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: _buildStickyFooter(context, cart),
                  ),
                ],
              );
            } else if (state is CartError) {
              return _buildErrorView(context, state.message);
            }
            return _buildErrorView(context, 'Something went wrong');
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message),
          TextButton(
            onPressed: () => context.read<CartBloc>().add(LoadCart()),
            child: const Text('Retry Karein'),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmClearCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart?'),
        content: const Text('Kya aap saare items remove karna chahte hain?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              context.read<CartBloc>().add(ClearCart());
              Navigator.pop(context);
            },
            child: const Text('CLEAR', style: TextStyle(color: AppColors.errorColor)),
          ),
        ],
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
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black54)),
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
