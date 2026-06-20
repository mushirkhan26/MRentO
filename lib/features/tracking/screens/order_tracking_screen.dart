import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/order_model.dart';
import '../../../core/services/firestore_order_service.dart';
import '../widgets/live_map_viewer.dart';
import '../widgets/tracking_status_sheet.dart';

enum DeliveryStage { preparing, eightMin, oneMin, delivered }

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final FirestoreOrderService _orderService = FirestoreOrderService();

  DeliveryStage _mapStage(OrderStatus? status) {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.confirmed:
      case OrderStatus.dispatched:
        return DeliveryStage.preparing;
      case OrderStatus.dispatched:
        return DeliveryStage.eightMin;
      case OrderStatus.delivered:
        return DeliveryStage.delivered;
      default:
        return DeliveryStage.preparing;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderModel?>(
      stream: _orderService.streamOrder(widget.orderId),
      builder: (context, snapshot) {
        final order = snapshot.data;
        final stage = _mapStage(order?.status);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // 1. Map Background (Dynamic based on Firestore)
              LiveMapViewer(currentStage: stage),

              // 2. Top Navigation
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Column(
                    children: [
                      _buildAppBar(),
                    ],
                  ),
                ),
              ),

              // 3. Status Badge on Map
              Positioned(
                top: 100,
                left: 20,
                child: _buildMapStatusBadge(order),
              ),

              // 4. Bottom Draggable Status Sheet
              Align(
                alignment: Alignment.bottomCenter,
                child: TrackingStatusSheet(currentStage: stage),
              ),
              
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator(color: AppColors.primaryYellow)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back,
                color: AppColors.bottomNavIconColor),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(backgroundColor: Colors.white),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.help_outline,
                color: AppColors.bottomNavIconColor),
            onPressed: () {},
            style: IconButton.styleFrom(backgroundColor: Colors.white),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.share_outlined,
                color: AppColors.bottomNavIconColor),
            onPressed: () {},
            style: IconButton.styleFrom(backgroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMapStatusBadge(OrderModel? order) {
    String text = "Status: ${order?.status.name.toUpperCase() ?? 'PENDING'}";
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.receipt_long_outlined, size: 14),
          const SizedBox(width: 8),
          Text(text,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}
