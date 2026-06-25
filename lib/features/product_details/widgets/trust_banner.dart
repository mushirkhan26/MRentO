import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class TrustBanner extends StatelessWidget {
  const TrustBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey200.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(Icons.verified_user_rounded, '100% Verified\nEquipment'),
              _buildItem(Icons.security_rounded, 'Safe Security\nDeposit'),
              _buildItem(Icons.assignment_return_rounded, 'Hassle-free\nReturns'),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryYellow.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.flash_on_rounded, size: 16, color: AppColors.primaryDarkYellow),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'MRentO Assured: Quality checked before every delivery',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDarkYellow,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, size: 24, color: AppColors.primaryDarkYellow),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlack,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
