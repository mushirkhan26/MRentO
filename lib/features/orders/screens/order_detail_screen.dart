import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/order_model.dart';
import '../../../core/models/review_model.dart';
import '../../../core/services/firestore_order_service.dart';
import '../../../core/services/firestore_product_service.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../widgets/order_detail_widgets.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final FirestoreOrderService _orderService = FirestoreOrderService();
  final FirestoreProductService _productService = FirestoreProductService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderModel?>(
      stream: _orderService.streamOrder(widget.orderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
                child:
                CircularProgressIndicator(color: AppColors.primaryYellow)),
          );
        }

        final order = snapshot.data;

        if (order == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Order Not Found')),
            body: const Center(child: Text('Order details load nahi ho paaye')),
          );
        }

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
                Text('Order #${order.id.substring(0, 8).toUpperCase()}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black121212)),
                Text(
                  'Placed on ${order.createdAt.toString().split(' ')[0]}',
                  style:
                  const TextStyle(fontSize: 11, color: AppColors.grey707070),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      OrderStatusBanner(
                          status: order.status, date: order.createdAt),
                      DeliveryTimeline(status: order.status),
                      RentalPeriodCard(order: order),
                      OrderItemsList(items: order.items),
                      OrderInvoiceCard(order: order),
                      OrderDetailAddress(address: order.deliveryAddress),
                      if (_canReview(order.status)) _buildReviewEntry(order),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              _buildBottomActions(order),
            ],
          ),
        );
      },
    );
  }

  /// Review tabhi chahiye jab equipment customer ke paas pahunch chuka ho
  bool _canReview(OrderStatus status) {
    return status == OrderStatus.delivered ||
        status == OrderStatus.active ||
        status == OrderStatus.returned;
  }

  Widget _buildReviewEntry(OrderModel order) {
    return GestureDetector(
      onTap: () => _showReviewDialog(order),
      child: const OrderRatingCard(),
    );
  }

  Widget _buildBottomActions(OrderModel order) {
    // "Return" button tabhi dikhana hai jab equipment customer ke paas hai
    final bool canReturn = order.status == OrderStatus.delivered ||
        order.status == OrderStatus.active ||
        order.status == OrderStatus.overdue;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (canReturn)
              Expanded(
                  child: _actionBtn(Icons.assignment_return_outlined, 'Return',
                      Colors.red.shade50, Colors.red)),
            if (canReturn) const SizedBox(width: 12),
            Expanded(
                child: _actionBtn(Icons.refresh, 'Reorder',
                    AppColors.lightGreenBadge, AppColors.primaryDarkGreen)),
            const SizedBox(width: 12),
            Expanded(
                child: _actionBtn(Icons.help_outline, 'Help',
                    AppColors.exploreBackground, AppColors.black121212)),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(
      IconData icon, String label, Color bgColor, Color textColor) {
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
          Text(label,
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  void _showReviewDialog(OrderModel order) {
    if (order.items.isEmpty) return;

    final commentController = TextEditingController();
    double selectedRating = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Rate Equipment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(order.items.first.productName,
                  style: const TextStyle(color: AppColors.grey707070)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.orangeAccent,
                      size: 40,
                    ),
                    onPressed: () =>
                        setModalState(() => selectedRating = index + 1.0),
                  );
                }),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Aapka experience kaisa raha?',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final authState = context.read<AuthBloc>().state;
                    if (authState is AuthAuthenticated) {
                      final review = ReviewModel(
                        id: '',
                        userId: authState.user.userId,
                        userName: authState.user.name,
                        productId: order.items.first.productId,
                        rating: selectedRating,
                        comment: commentController.text,
                        createdAt: DateTime.now(),
                      );
                      await _productService.addReview(review);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Shukriya! Review add ho gaya.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlack,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Submit Review'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}