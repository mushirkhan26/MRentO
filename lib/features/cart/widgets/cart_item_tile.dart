import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/cart_model.dart';
import '../../../core/constants/app_constants.dart';
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image with Hero animation
          Hero(
            tag: 'cart_item_${item.productId}',
            child: Container(
              width: 85,
              height: 95,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.greyOutline.withValues(alpha: 0.5)),
                image: item.productImage != null
                    ? DecorationImage(
                        image: NetworkImage(item.productImage!),
                        fit: BoxFit.contain,
                      )
                    : null,
              ),
              child: item.productImage == null
                  ? const Center(
                      child: Icon(Icons.image_not_supported_outlined,
                          color: AppColors.grey707070, size: 28),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.vendorName != null)
                  Text(
                    'Sold by: ${item.vendorName!}',
                    style: TextStyle(
                        fontSize: 10,
                        color: AppColors.grey707070.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 2),
                Text(
                  item.productName,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                if (item.rentalDurationLabel != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryYellow.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${item.rentalDurationLabel} Plan',
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryBlack),
                    ),
                  ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '₹${item.price.toInt()}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(width: 4),
                    if (item.securityDeposit > 0)
                      Flexible(
                        child: Text(
                          '+ ₹${item.securityDeposit.toInt()} deposit',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.grey707070,
                              fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Side controls: Remove & Quantity
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.delete_outline,
                    size: 20, color: AppColors.errorColor),
                onPressed: () => _handleRemove(context),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlack,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _qtyBtn(Icons.remove, Colors.white, () {
                      if (item.quantity > 1) {
                        HapticFeedback.lightImpact();
                        context.read<CartBloc>().add(
                              UpdateQuantity(item.productId, item.quantity - 1),
                            );
                      }
                    }),
                    Text(
                      '${item.quantity}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14),
                    ),
                    _qtyBtn(Icons.add, Colors.white, () {
                      if (item.quantity < AppConstants.maxCartItemQuantity) {
                        HapticFeedback.lightImpact();
                        context.read<CartBloc>().add(
                              UpdateQuantity(item.productId, item.quantity + 1),
                            );
                      } else {
                        HapticFeedback.vibrate();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Max limit reached for this item'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
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

  void _handleRemove(BuildContext context) {
    HapticFeedback.mediumImpact();
    final cartBloc = context.read<CartBloc>();
    cartBloc.add(RemoveFromCart(item.productId));

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.productName} removed'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppColors.primaryYellow,
          onPressed: () {
            cartBloc.add(UndoRemove(item));
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }
}
