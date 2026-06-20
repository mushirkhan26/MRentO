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

// ✅ Security deposit banner — Try & Return ki jagah
class SecurityDepositBanner extends StatelessWidget {
  const SecurityDepositBanner({super.key});

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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security_outlined, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Security Deposit',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Aapki security deposit 100% refundable hai — machine wapas karte hi refund ho jaati hai. Zero tension.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}