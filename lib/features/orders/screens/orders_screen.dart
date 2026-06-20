import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/order_model.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../bloc/orders_state.dart';
import '../widgets/order_summary_cards.dart';
import '../widgets/order_filter_tabs.dart';
import '../widgets/order_card_widgets.dart';
import '../widgets/order_empty_state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<OrdersBloc>().add(FetchOrders(authState.user.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.exploreBackground,
      appBar: AppBar(
        title: const Text('My Bookings',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primaryBlack,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const OrderFilterTabs(),
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryYellow));
        }

        if (state is OrdersLoaded) {
          if (state.orders.isEmpty) return const OrderEmptyState();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.orders.length,
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return _buildDynamicOrderCard(context, order);
            },
          );
        }

        if (state is OrdersError) {
          return Center(child: Text(state.message));
        }

        return const OrderEmptyState();
      },
    );
  }

  // ── Status display helpers ──────────────────────────────────────────────

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return 'PENDING';
      case OrderStatus.confirmed: return 'CONFIRMED';
      case OrderStatus.dispatched: return 'DISPATCHED';
      case OrderStatus.delivered: return 'DELIVERED';
      case OrderStatus.active: return 'RENTAL ACTIVE';
      case OrderStatus.returned: return 'RETURNED';
      case OrderStatus.overdue: return 'OVERDUE';
      case OrderStatus.cancelled: return 'CANCELLED';
    }
  }

  Color _statusColor(OrderModel order) {
    // isOverdue model khud calculate karta hai — Firestore status overdue
    // marked na bhi ho, end date nikal jaane par bhi red dikhega
    if (order.isOverdue || order.status == OrderStatus.overdue) {
      return AppColors.errorRed;
    }
    switch (order.status) {
      case OrderStatus.delivered:
      case OrderStatus.returned:
        return AppColors.successColor;
      case OrderStatus.active:
        return AppColors.infoColor;
      case OrderStatus.cancelled:
        return AppColors.grey500;
      default:
        return AppColors.warningColor;
    }
  }

  bool _canTrack(OrderStatus status) {
    return status != OrderStatus.delivered &&
        status != OrderStatus.returned &&
        status != OrderStatus.cancelled;
  }

  Widget _buildDynamicOrderCard(BuildContext context, OrderModel order) {
    final color = _statusColor(order);
    final displayLabel =
    order.isOverdue ? 'OVERDUE' : _statusLabel(order.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: BaseOrderCard(
        orderId: order.id.substring(0, 8).toUpperCase(),
        date: 'Placed on ${order.createdAt.toString().split(' ')[0]}',
        itemsCount: order.items.length,
        status: displayLabel,
        statusColor: color,
        statusBg: color.withValues(alpha: 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.handyman_outlined,
                    size: 40, color: AppColors.primaryYellow),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          order.items.isNotEmpty
                              ? order.items[0].productName
                              : 'Rental Equipment',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          order.items.isNotEmpty &&
                              order.items[0].rentalDurationLabel != null
                              ? '${order.items[0].rentalDurationLabel} • ${order.items.length} items'
                              : '${order.items.length} items',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.grey707070)),
                      Text(
                          'Total: ₹${order.totalAmount.toInt()}'
                              '${order.totalSecurityDeposit > 0 ? ' + ₹${order.totalSecurityDeposit.toInt()} deposit' : ''}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.grey707070)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OrderActionButton(
                    label: 'Details',
                    isPrimary: true,
                    onPressed: () =>
                        context.push(AppRoutes.orderDetailRoute, extra: order.id),
                  ),
                ),
                if (_canTrack(order.status)) const SizedBox(width: 12),
                if (_canTrack(order.status))
                  Expanded(
                    child: OrderActionButton(
                      label: 'Track ↗',
                      isPrimary: false,
                      onPressed: () => context.push(AppRoutes.trackOrderRoute,
                          extra: order.id),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}