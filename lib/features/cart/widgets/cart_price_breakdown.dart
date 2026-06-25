import 'package:flutter/material.dart';
import '../../../core/models/cart_model.dart';
import '../../../config/theme/app_colors.dart';

class CartPriceBreakdown extends StatelessWidget {
  final CartModel cart;
  const CartPriceBreakdown({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyE5E7EB),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Price breakdown',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _priceRow('Rental subtotal', '₹${cart.subtotal.toInt()}'),
          if (cart.deliveryFee == 0)
            _priceRow('Delivery fee', 'FREE',
                color: AppColors.successColor, subtitle: '₹49')
          else
            _priceRow('Delivery fee', '₹${cart.deliveryFee.toInt()}'),
          _priceRow('GST (18%)', '₹${cart.tax.toInt()}'),
          if (cart.couponDiscount > 0)
            _priceRow('Coupon discount', '-₹${cart.couponDiscount.toInt()}',
                color: AppColors.successColor),
          if (cart.discount > 0)
            _priceRow('Discount', '-₹${cart.discount.toInt()}',
                color: AppColors.successColor),
          const Divider(height: 24),
          _priceRow('Rental total', '₹${cart.total.toInt()}',
              isBold: true),
          const SizedBox(height: 8),
          if (cart.totalDiscount > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.successColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Yay! You saved ₹${cart.totalDiscount.toInt()} on this order',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryDarkGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 12),
          // ✅ Security deposit — separate refundable line
          if (cart.totalSecurityDeposit > 0)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.categoryPowerBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.security_outlined,
                          size: 14, color: AppColors.categoryPowerText),
                      SizedBox(width: 6),
                      Text('Security deposit (refundable)',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.categoryPowerText)),
                    ],
                  ),
                  Text(
                    '₹${cart.totalSecurityDeposit.toInt()}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.categoryPowerText),
                  ),
                ],
              ),
            ),
          if (cart.totalSecurityDeposit > 0) ...[
            const SizedBox(height: 8),
            const Divider(height: 8),
            const SizedBox(height: 8),
            _priceRow(
              'Grand total (incl. deposit)',
              '₹${cart.grandTotal.toInt()}',
              isBold: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _priceRow(
      String label,
      String value, {
        bool isBold = false,
        Color? color,
        String? subtitle,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isBold ? Colors.black : AppColors.grey707070,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: color ?? (isBold ? Colors.black : Colors.black87),
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (subtitle != null)
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.grey707070,
                        decoration: TextDecoration.lineThrough)),
            ],
          ),
        ],
      ),
    );
  }
}