import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class FreeDeliveryPromo extends StatelessWidget {
  const FreeDeliveryPromo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_outlined,
                  size: 16, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Free delivery on orders above ₹999',
                style: TextStyle(fontSize: 12, color: Colors.brown),
              ),
            ],
          ),
          Text(
            'Applied ✓',
            style: TextStyle(
                fontSize: 12,
                color: Colors.green,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ✅ Trust Banner for Security Deposit
class SecurityDepositBanner extends StatelessWidget {
  const SecurityDepositBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4), // Very light green for trust/safety
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCFCE7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.verified_user_outlined, size: 20, color: Colors.green),
              SizedBox(width: 8),
              Text(
                '100% Refundable Deposit',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.green),
              ),
            ],
          ),

          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 13, color: Color(0xFF166534), height: 1.4),
              children: [
                TextSpan(text: 'Aapki security deposit safe hai. '),
                TextSpan(
                  text: 'Machine wapas milte hi turant refund ho jayegi.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' Zero tension!'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}