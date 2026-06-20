import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/app_colors.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_state.dart';

class CheckoutOrderSummary extends StatelessWidget {
  const CheckoutOrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is! CartLoaded) return const SizedBox.shrink();
        final cart = state.cart;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppColors.greyOutline.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order summary (${cart.items.length})',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Edit cart',
                          style: TextStyle(
                              color: AppColors.primaryYellow,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 12),
              // Dynamic Thumbnails
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return _itemThumb(item.productImage);
                  },
                ),
              ),
              const SizedBox(height: 24),
              _summaryRow('Items (rental)', '₹${cart.subtotal.toInt()}'),
              const SizedBox(height: 12),
              _summaryRow('Delivery fee', 
                  cart.deliveryFee == 0 ? 'FREE' : '₹${cart.deliveryFee.toInt()}',
                  isFree: cart.deliveryFee == 0),
              const SizedBox(height: 12),
              _summaryRow('GST (18%)', '₹${cart.tax.toInt()}'),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Grand Total',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('₹${cart.grandTotal.toInt()}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 16),
              // Security deposit note
              if (cart.totalSecurityDeposit > 0)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.categoryPowerBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.security_outlined,
                          size: 14, color: AppColors.categoryPowerText),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '₹${cart.totalSecurityDeposit.toInt()} Security deposit added — 100% refundable',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.categoryPowerText),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              _deliveryInfoBanner(),
            ],
          ),
        );
      },
    );
  }

  Widget _itemThumb(String? imageUrl) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
          color: AppColors.exploreBackground,
          borderRadius: BorderRadius.circular(8),
          image: imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(imageUrl), fit: BoxFit.cover)
              : null),
      child: imageUrl == null
          ? const Center(
              child: Icon(Icons.construction_outlined,
                  size: 20, color: Colors.black26),
            )
          : null,
    );
  }

  Widget _summaryRow(String label, String value,
      {bool isFree = false, String? originalVal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.grey707070, fontSize: 14)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                color: isFree
                    ? AppColors.successColor
                    : AppColors.primaryBlack,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            if (originalVal != null)
              Text(originalVal,
                  style: const TextStyle(
                      color: AppColors.grey707070,
                      fontSize: 10,
                      decoration: TextDecoration.lineThrough)),
          ],
        ),
      ],
    );
  }

  Widget _deliveryInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.categoryPowerBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.local_shipping_outlined,
              size: 18, color: AppColors.categoryPowerText),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery Scheduled',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.categoryPowerText)),
                Text('Booking confirm hone ke baad date & time notify ki jaayegi',
                    style: TextStyle(
                        fontSize: 10,
                        color: AppColors.categoryPowerText)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
