import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class CartDeliveryBanner extends StatelessWidget {
  const CartDeliveryBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.categoryPowerBg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: const Row(
        children: [
          Icon(Icons.local_shipping_outlined,
              size: 16, color: AppColors.categoryPowerText),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Doorstep delivery & pickup available',
              style: TextStyle(
                  color: AppColors.categoryPowerText, fontSize: 12),
            ),
          ),
          Text(
            'Scheduled on booking',
            style: TextStyle(
              color: AppColors.categoryPowerText,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}