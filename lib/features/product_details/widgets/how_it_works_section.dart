import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How it works?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primaryBlack,
          ),
        ),
        const SizedBox(height: 16),
        _buildStep(
          icon: Icons.shopping_bag_outlined,
          title: 'Choose Duration',
          description: 'Select how long you need the equipment.',
          isLast: false,
        ),
        _buildStep(
          icon: Icons.local_shipping_outlined,
          title: 'Quick Delivery',
          description: 'Rider picks up and delivers it to your doorstep.',
          isLast: false,
        ),
        _buildStep(
          icon: Icons.verified_outlined,
          title: 'Use & Return',
          description: 'Enjoy using it and return it after your rental ends.',
          isLast: false,
        ),
        _buildStep(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Instant Refund',
          description: 'Security deposit is refunded instantly after pickup.',
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required String description,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: AppColors.primaryDarkYellow),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.grey200,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.primaryBlack,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
