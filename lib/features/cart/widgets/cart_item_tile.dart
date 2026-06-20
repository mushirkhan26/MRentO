import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/cart_model.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyE5E7EB),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Container(
            width: 80,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.categoryPowerBg,
              borderRadius: BorderRadius.circular(8),
              image: item.productImage != null
                  ? DecorationImage(
                image: NetworkImage(item.productImage!),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: item.productImage == null
                ? const Center(
              child: Icon(Icons.construction_outlined,
                  color: AppColors.categoryPowerText, size: 32),
            )
                : null,
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vendor name + remove button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (item.vendorName != null)
                      Row(
                        children: [
                          const Icon(Icons.storefront_outlined,
                              size: 11, color: AppColors.grey707070),
                          const SizedBox(width: 3),
                          Text(
                            item.vendorName!,
                            style: const TextStyle(
                                fontSize: 10, color: AppColors.grey707070),
                          ),
                        ],
                      )
                    else
                      const SizedBox.shrink(),
                    GestureDetector(
                      onTap: () => context
                          .read<CartBloc>()
                          .add(RemoveFromCart(item.productId)),
                      child: const Icon(Icons.close,
                          size: 16, color: AppColors.grey707070),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Product name
                Text(
                  item.productName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Rental duration info
                if (item.rentalDurationLabel != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryYellow.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${item.rentalDurationLabel} rental',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlack),
                    ),
                  ),
                const SizedBox(height: 8),

                // Price
                Row(
                  children: [
                    Text(
                      '₹${item.price.toInt()}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    if (item.securityDeposit > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        '+ ₹${item.securityDeposit.toInt()} deposit',
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.grey707070),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Quantity controls
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyOutline),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    _qtyBtn(Icons.remove, () {
                      context.read<CartBloc>().add(
                        UpdateQuantity(
                            item.productId, item.quantity - 1),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _qtyBtn(Icons.add, () {
                      context.read<CartBloc>().add(
                        UpdateQuantity(
                            item.productId, item.quantity + 1),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16, color: AppColors.grey707070),
      ),
    );
  }
}