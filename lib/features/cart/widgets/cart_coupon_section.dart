import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/app_colors.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class CartCouponSection extends StatefulWidget {
  const CartCouponSection({super.key});

  @override
  State<CartCouponSection> createState() => _CartCouponSectionState();
}

class _CartCouponSectionState extends State<CartCouponSection> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        // Stop loading on success or error
        if (state is CartLoaded || state is CartError) {
          setState(() => _isLoading = false);
        }
      },
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final bool isLoaded = state is CartLoaded;
          final String? appliedCoupon = isLoaded ? state.cart.couponCode : null;
          final double couponDiscount = isLoaded ? state.cart.couponDiscount : 0.0;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: appliedCoupon != null
                      ? AppColors.primaryDarkGreen.withValues(alpha: 0.3)
                      : AppColors.greyE5E7EB),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                        appliedCoupon != null
                            ? Icons.verified_outlined
                            : Icons.confirmation_number_outlined,
                        size: 16,
                        color: appliedCoupon != null
                            ? AppColors.primaryDarkGreen
                            : Colors.grey),
                    const SizedBox(width: 8),
                    Text(appliedCoupon != null ? 'Coupon Applied' : 'Coupon code',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: appliedCoupon != null
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: appliedCoupon != null
                                ? AppColors.primaryDarkGreen
                                : Colors.grey)),
                  ],
                ),
                const SizedBox(height: 12),
                if (appliedCoupon == null)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          enabled: !_isLoading,
                          decoration: InputDecoration(
                            hintText: 'Try MRENTO100',
                            hintStyle: const TextStyle(fontSize: 13),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 38,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_controller.text.isNotEmpty) {
                                    setState(() => _isLoading = true);
                                    context
                                        .read<CartBloc>()
                                        .add(ApplyCoupon(_controller.text));
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlack,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Apply',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDarkGreen.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.primaryDarkGreen.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appliedCoupon.toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryDarkGreen),
                            ),
                            Text(
                              'Saved ₹${couponDiscount.toInt()} on this order',
                              style: const TextStyle(
                                  fontSize: 10, color: AppColors.primaryDarkGreen),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<CartBloc>().add(RemoveCoupon());
                            _controller.clear();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.errorColor,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('REMOVE',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
