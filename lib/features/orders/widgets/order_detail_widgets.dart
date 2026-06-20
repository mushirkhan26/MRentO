import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/order_model.dart';
import 'package:intl/intl.dart';

class OrderStatusBanner extends StatelessWidget {
  final OrderStatus status;
  final DateTime date;
  const OrderStatusBanner({super.key, required this.status, required this.date});

  String get _label {
    switch (status) {
      case OrderStatus.pending: return 'Booking pending';
      case OrderStatus.confirmed: return 'Booking confirmed';
      case OrderStatus.dispatched: return 'Out for delivery';
      case OrderStatus.delivered: return 'Equipment delivered';
      case OrderStatus.active: return 'Rental active';
      case OrderStatus.returned: return 'Equipment returned';
      case OrderStatus.overdue: return 'Return overdue';
      case OrderStatus.cancelled: return 'Booking cancelled';
    }
  }

  Color get _bgColor {
    switch (status) {
      case OrderStatus.overdue: return AppColors.errorRed;
      case OrderStatus.cancelled: return AppColors.grey500;
      default: return AppColors.primaryDarkGreen;
    }
  }

  IconData get _icon {
    switch (status) {
      case OrderStatus.overdue: return Icons.warning_amber_rounded;
      case OrderStatus.cancelled: return Icons.cancel_outlined;
      case OrderStatus.returned: return Icons.assignment_turned_in_outlined;
      default: return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgColor,
      ),
      child: Row(
        children: [
          Icon(_icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_label.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                Text(
                    '${DateFormat('MMM dd').format(date)} • ${DateFormat('jm').format(date)}',
                    style:
                    const TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12)),
            child: const Text('90-min',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class DeliveryTimeline extends StatelessWidget {
  final OrderStatus status;
  const DeliveryTimeline({super.key, required this.status});

  // Kis tareeke se pata chale ki step done hai — sequence ke hisaab se
  bool _isStepDone(int stepIndex) {
    const sequence = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.dispatched,
      OrderStatus.delivered,
    ];
    if (status == OrderStatus.cancelled) return stepIndex == 0;
    // active/returned/overdue sab delivered ke baad ke states hain
    final effectiveStatus =
    (status == OrderStatus.active ||
        status == OrderStatus.returned ||
        status == OrderStatus.overdue)
        ? OrderStatus.delivered
        : status;
    final currentIndex = sequence.indexOf(effectiveStatus);
    return stepIndex <= currentIndex;
  }

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
              Text('Delivery timeline',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 20),
          _timelineStep(
              'Order placed', 'Humein aapka order mil gaya hai', _isStepDone(0)),
          _timelineStep('Booking confirmed', 'Vendor ne booking accept kar li',
              _isStepDone(1)),
          _timelineStep('Out for delivery',
              'Rider aapke address ke liye nikal chuka hai', _isStepDone(2)),
          _timelineStep('Delivered', 'Equipment safely deliver ho gaya',
              _isStepDone(3),
              isLast: true),
        ],
      ),
    );
  }

  Widget _timelineStep(String title, String subtitle, bool isDone,
      {bool isLast = false}) {
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
                child: isDone
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                      width: 2,
                      color: isDone
                          ? AppColors.primaryDarkGreen
                          : AppColors.greyOutline.withValues(alpha: 0.3)),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.grey707070, fontSize: 11)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Rental period card — sirf tab dikhao jab dates set hon
class RentalPeriodCard extends StatelessWidget {
  final OrderModel order;
  const RentalPeriodCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    if (order.rentalStartDate == null || order.rentalEndDate == null) {
      return const SizedBox.shrink();
    }

    final isOverdue = order.isOverdue;
    final daysLeft = order.daysRemaining;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOverdue
            ? AppColors.errorRed.withValues(alpha: 0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOverdue
              ? AppColors.errorRed.withValues(alpha: 0.3)
              : AppColors.greyOutline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month_outlined,
                  size: 16,
                  color: isOverdue ? AppColors.errorRed : AppColors.grey707070),
              const SizedBox(width: 8),
              Text('Rental period',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isOverdue ? AppColors.errorRed : Colors.black)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _dateBlock(
                    'From', DateFormat('dd MMM, yyyy').format(order.rentalStartDate!)),
              ),
              const Icon(Icons.arrow_forward, size: 16, color: AppColors.grey400),
              Expanded(
                child: _dateBlock(
                    'To', DateFormat('dd MMM, yyyy').format(order.rentalEndDate!)),
              ),
            ],
          ),
          if (isOverdue) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Return date ${-(daysLeft ?? 0)} din pehle nikal gayi — jald wapas karein',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.errorRed,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ] else if (daysLeft != null &&
              daysLeft >= 0 &&
              order.status != OrderStatus.returned) ...[
            const SizedBox(height: 12),
            Text(
              daysLeft == 0
                  ? 'Aaj return karna hai'
                  : '$daysLeft din baaki hain return karne mein',
              style: const TextStyle(fontSize: 11, color: AppColors.grey707070),
            ),
          ],
        ],
      ),
    );
  }

  Widget _dateBlock(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 10, color: AppColors.grey707070)),
        const SizedBox(height: 2),
        Text(date,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}

class OrderItemsList extends StatelessWidget {
  final List<OrderItem> items;
  const OrderItemsList({super.key, required this.items});

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
          Row(
            children: [
              const Icon(Icons.inventory_2_outlined,
                  size: 16, color: AppColors.grey707070),
              const SizedBox(width: 8),
              Text('Order items (${items.length})',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Column(
            children: [
              _itemRow(item),
              if (item != items.last) const Divider(height: 24),
            ],
          )),
        ],
      ),
    );
  }

  Widget _itemRow(OrderItem item) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 60,
          decoration: BoxDecoration(
              color: AppColors.categoryPowerBg,
              borderRadius: BorderRadius.circular(8)),
          child: const Center(
              child:
              Icon(Icons.handyman_outlined, color: AppColors.primaryBlack)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.vendorName ?? 'MRentO Partner',
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.grey707070)),
              Text(item.productName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              Text(
                  'Qty: ${item.quantity}'
                      '${item.rentalDurationLabel != null ? ' • ${item.rentalDurationLabel}' : ''}',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.grey707070)),
              if (item.securityDeposit > 0)
                Text(
                  'Deposit: ₹${item.totalSecurityDeposit.toInt()}',
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.grey400),
                ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('₹${item.total.toInt()}',
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const Text('Rental',
                style: TextStyle(
                    fontSize: 9,
                    color: AppColors.primaryDarkGreen,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}

class OrderInvoiceCard extends StatelessWidget {
  final OrderModel order;
  const OrderInvoiceCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // totalAmount mein rental charges hain (deposit alag se track hota hai)
    final rentalSubtotal = order.totalAmount / 1.18;
    final tax = order.totalAmount - rentalSubtotal;
    final grandTotal = order.totalAmount + order.totalSecurityDeposit;

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
                  Icon(Icons.description_outlined,
                      size: 16, color: AppColors.grey707070),
                  SizedBox(width: 8),
                  Text('Invoice',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.exploreBackground,
                    borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  children: [
                    Icon(Icons.copy, size: 12, color: AppColors.grey707070),
                    SizedBox(width: 4),
                    Text('Copy ID',
                        style: TextStyle(
                            fontSize: 10,
                            color: AppColors.grey707070,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _invoiceRow('Rental subtotal', '₹${rentalSubtotal.toInt()}'),
          _invoiceRow('GST (18%)', '₹${tax.toInt()}'),
          _invoiceRow('Delivery charge', 'FREE', isGreen: true),
          if (order.totalSecurityDeposit > 0)
            _invoiceRow('Security deposit (refundable)',
                '₹${order.totalSecurityDeposit.toInt()}'),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Grand Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('₹${grandTotal.toInt()}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          if (order.totalSecurityDeposit > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: order.securityRefunded
                    ? AppColors.successColor.withValues(alpha: 0.1)
                    : AppColors.categoryPowerBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    order.securityRefunded
                        ? Icons.check_circle_outline
                        : Icons.info_outline,
                    size: 14,
                    color: order.securityRefunded
                        ? AppColors.successColor
                        : AppColors.categoryPowerText,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      order.securityRefunded
                          ? 'Security deposit refund ho chuka hai'
                          : 'Deposit equipment return hone ke baad refund hoga',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: order.securityRefunded
                            ? AppColors.successColor
                            : AppColors.categoryPowerText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Order ID',
                  style: TextStyle(fontSize: 12, color: AppColors.grey707070)),
              Text('#${order.id.substring(0, 8).toUpperCase()}',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
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
          Text(label,
              style: const TextStyle(color: AppColors.grey707070, fontSize: 13)),
          Text(value,
              style: TextStyle(
                  color: isGreen ? AppColors.successColor : AppColors.black121212,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ],
      ),
    );
  }
}

class OrderDetailAddress extends StatelessWidget {
  final String address;
  const OrderDetailAddress({super.key, required this.address});

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
              Icon(Icons.location_on_outlined,
                  size: 16, color: AppColors.grey707070),
              SizedBox(width: 8),
              Text('Delivery address',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.lightGreenBadge,
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.home_outlined,
                    color: AppColors.primaryDarkGreen, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(address,
                    style: const TextStyle(
                        color: AppColors.grey707070, fontSize: 11, height: 1.4)),
              ),
            ],
          ),
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
              Text('Rate your experience',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Rental quality aur delivery ko rate karein',
              style: TextStyle(color: AppColors.grey707070, fontSize: 12)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                5,
                    (i) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.star_outline,
                      size: 30, color: Colors.orangeAccent),
                )),
          ),
        ],
      ),
    );
  }
}