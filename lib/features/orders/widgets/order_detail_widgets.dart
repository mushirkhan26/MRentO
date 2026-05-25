import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class OrderStatusBanner extends StatelessWidget {
  const OrderStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.primaryDarkGreen,
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivered', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text('May 22 • 4:22 PM • 37 min mein aaya!', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: const Text('90-min', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class DeliveryTimeline extends StatelessWidget {
  const DeliveryTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyOutline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timeline, size: 16, color: AppColors.grey707070),
              SizedBox(width: 8),
              Text('Delivery timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 20),
          _timelineStep('Order placed', 'May 22 • 3:45 PM • Payment confirmed', true),
          _timelineStep('Order packed', 'May 22 • 3:52 PM • Jodhpur warehouse', true),
          _timelineStep('Out for delivery', 'May 22 • 3:58 PM • Ramesh Singh • RJ14 SP 4421', true),
          _timelineStep('Delivered', 'May 22 • 4:22 PM • Baldev Nagar, Jodhpur', true, isLast: true),
        ],
      ),
    );
  }

  Widget _timelineStep(String title, String subtitle, bool isDone, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isDone ? AppColors.primaryDarkGreen : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryDarkGreen),
                ),
                child: const Icon(Icons.check, size: 12, color: Colors.white),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: AppColors.primaryDarkGreen),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(subtitle, style: const TextStyle(color: AppColors.grey707070, fontSize: 11)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderItemsList extends StatelessWidget {
  const OrderItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyOutline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.grey707070),
              SizedBox(width: 8),
              Text('Order items (2)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          _itemRow('Manyavar', 'Bandhani Saree', 'Size: Free • Blue • Qty: 1', '₹3,499', 'Local designer', const Color(0xFFF3E5F5)),
          const Divider(height: 24),
          _itemRow('W for Woman', 'Linen Blazer', 'Size: M • Beige • Qty: 1', '₹1,799', 'New arrival', const Color(0xFFFFF3E0)),
        ],
      ),
    );
  }

  Widget _itemRow(String brand, String name, String details, String price, String badge, Color bgColor) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 60,
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
          child: const Center(child: Icon(Icons.image_outlined, color: Colors.black26)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(brand, style: const TextStyle(fontSize: 10, color: AppColors.grey707070)),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(details, style: const TextStyle(fontSize: 11, color: AppColors.grey707070)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(badge, style: const TextStyle(fontSize: 9, color: AppColors.primaryDarkGreen, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}

class OrderInvoiceCard extends StatelessWidget {
  const OrderInvoiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyOutline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.description_outlined, size: 16, color: AppColors.grey707070),
                  SizedBox(width: 8),
                  Text('Invoice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.exploreBackground, borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  children: [
                    Icon(Icons.copy, size: 12, color: AppColors.grey707070),
                    SizedBox(width: 4),
                    Text('Copy', style: TextStyle(fontSize: 10, color: AppColors.grey707070, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _invoiceRow('MRP total', '₹5,798'),
          _invoiceRow('Product discount', '-₹500', isGreen: true),
          _invoiceRow('Coupon (STYLE20)', '-₹0', isGreen: true),
          _invoiceRow('Delivery charge', 'FREE', isGreen: true),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total paid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const Text('₹5,298', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Payment method', style: TextStyle(fontSize: 12, color: AppColors.grey707070)),
              Row(
                children: [
                  const Text('GPay UPI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  Icon(Icons.account_balance_wallet, size: 14, color: AppColors.primaryDarkGreen.withValues(alpha: 0.7)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Order ID', style: TextStyle(fontSize: 12, color: AppColors.grey707070)),
              const Text('#FD28341', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _invoiceRow(String label, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.grey707070, fontSize: 13)),
          Text(value, style: TextStyle(color: isGreen ? AppColors.successColor : AppColors.black121212, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

class OrderRatingCard extends StatelessWidget {
  const OrderRatingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyOutline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.star_outline, size: 16, color: AppColors.grey707070),
              SizedBox(width: 8),
              Text('Rate your order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Delivery aur products ko rate karein', style: TextStyle(color: AppColors.grey707070, fontSize: 12)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.star_outline, size: 30, color: Colors.orangeAccent),
            )),
          ),
          const SizedBox(height: 12),
          const Center(child: Text('Zabardast! — shukriya!', style: TextStyle(color: AppColors.primaryDarkGreen, fontWeight: FontWeight.bold, fontSize: 12))),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Aapka experience likhein... (optional)',
              hintStyle: const TextStyle(fontSize: 12, color: AppColors.grey707070),
              filled: true,
              fillColor: AppColors.exploreBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailAddress extends StatelessWidget {
  const OrderDetailAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyOutline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: AppColors.grey707070),
              SizedBox(width: 8),
              Text('Delivery address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.lightGreenBadge, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.home_outlined, color: AppColors.primaryDarkGreen, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Home — Rahul Sharma', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('12, Baldev Nagar, Near SBI Bank, Jodhpur, Rajasthan — 342001', style: TextStyle(color: AppColors.grey707070, fontSize: 11, height: 1.4)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
