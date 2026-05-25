import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../widgets/order_detail_widgets.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.exploreBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black121212),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order $orderId', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black121212)),
            const Text('May 22, 2024 · 3:45 PM', style: TextStyle(fontSize: 11, color: AppColors.grey707070)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline, color: AppColors.black121212), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share_outlined, color: AppColors.black121212), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const OrderStatusBanner(),
                  const DeliveryTimeline(),
                  const OrderItemsList(),
                  const OrderInvoiceCard(),
                  const OrderDetailAddress(),
                  const OrderRatingCard(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(child: _actionBtn(Icons.assignment_return_outlined, 'Return', Colors.red.shade50, Colors.red)),
            const SizedBox(width: 12),
            Expanded(child: _actionBtn(Icons.refresh, 'Reorder', AppColors.lightGreenBadge, AppColors.primaryDarkGreen)),
            const SizedBox(width: 12),
            Expanded(child: _actionBtn(Icons.help_outline, 'Help', AppColors.exploreBackground, AppColors.black121212)),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
