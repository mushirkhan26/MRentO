import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/order_model.dart';
import '../../../core/models/address_model.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../cart/bloc/cart_state.dart';
import '../../orders/bloc/orders_bloc.dart';
import '../../orders/bloc/orders_event.dart';
import '../../orders/bloc/orders_state.dart';
import '../../settings/bloc/address_bloc.dart';
import '../../settings/bloc/address_event.dart';
import '../widgets/checkout_step_indicator.dart';
import '../widgets/checkout_address_selector.dart';
import '../widgets/checkout_payment_selector.dart';
import '../widgets/checkout_order_summary.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  AddressModel? _selectedAddress;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<AddressBloc>().add(LoadAddresses(authState.user.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is OrderSuccess) {
          context.read<CartBloc>().add(ClearCart());
          _showSuccessDialog(context, state.order.id);
        } else if (state is OrdersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.exploreBackground,
        appBar: AppBar(
          title: const Text('Checkout',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryBlack,
          centerTitle: true,
        ),
        body: Column(
          children: [
            const CheckoutStepIndicator(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CheckoutAddressSelector(
                      selectedAddress: _selectedAddress,
                      onAddressSelected: (addr) {
                        setState(() => _selectedAddress = addr);
                      },
                    ),
                    const CheckoutPaymentSelector(),
                    const CheckoutOrderSummary(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildStickyFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyFooter() {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, ordersState) {
        final isLoading = ordersState is OrdersLoading;

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
            child: ElevatedButton(
              onPressed: isLoading ? null : _handlePlaceOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: AppColors.primaryBlack,
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryBlack,
                ),
              )
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Paying via UPI',
                          style: TextStyle(
                              fontSize: 10, color: Colors.black54)),
                      Text('Booking Confirm Karo',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.lock_outline, size: 16),
                      SizedBox(width: 4),
                      Text('Secure',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handlePlaceOrder() {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pehle delivery address select karein')),
      );
      return;
    }

    final authState = context.read<AuthBloc>().state;
    final cartState = context.read<CartBloc>().state;

    if (authState is AuthAuthenticated && cartState is CartLoaded) {
      final cart = cartState.cart;
      final userId = authState.user.userId;

      // ── Cart items ko OrderItem mein convert karo, rental fields ke saath ──
      final orderItems = cart.items
          .map((item) => OrderItem(
        productId: item.productId,
        productName: item.productName,
        quantity: item.quantity,
        price: item.price,
        vendorName: item.vendorName,
        rentalDurationLabel: item.rentalDurationLabel,
        rentalDays: item.rentalDays,
        securityDeposit: item.securityDeposit,
      ))
          .toList();

      // ── Rental start/end date: cart items mein agar set hain to wahi use karo,
      //    warna abhi se shuru maan ke rentalDays se end date nikal lo ──
      final DateTime rentalStart = cart.items
          .firstWhere(
            (i) => i.startDate != null,
        orElse: () => cart.items.first,
      )
          .startDate ??
          DateTime.now();

      final int maxRentalDays = cart.items
          .map((i) => i.rentalDays ?? 1)
          .fold(1, (max, days) => days > max ? days : max);

      final DateTime rentalEnd = cart.items
          .firstWhere(
            (i) => i.endDate != null,
        orElse: () => cart.items.first,
      )
          .endDate ??
          rentalStart.add(Duration(days: maxRentalDays));

      final order = OrderModel(
        id: '', // Firestore will generate
        customerId: userId,
        items: orderItems,
        totalAmount: cart.grandTotal, // rental charges + security deposit
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
        deliveryAddress:
        '${_selectedAddress!.tag}: ${_selectedAddress!.streetAddress}, ${_selectedAddress!.city}',
        rentalStartDate: rentalStart,
        rentalEndDate: rentalEnd,
        totalSecurityDeposit: cart.totalSecurityDeposit,
      );

      context.read<OrdersBloc>().add(CreateOrder(order));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pehle login karein aur cart check karein')),
      );
    }
  }

  void _showSuccessDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryYellow.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline,
                  color: AppColors.primaryYellow, size: 60),
            ),
            const SizedBox(height: 24),
            const Text(
              'Booking Confirmed! 🎉',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Aapki rental booking confirm ho gayi!\nEquipment jald hi aapke paas pahunch jaayega.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey707070, height: 1.4),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go(AppRoutes.homeRoute);
                  context.push(AppRoutes.trackOrderRoute, extra: orderId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlack,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Track Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}