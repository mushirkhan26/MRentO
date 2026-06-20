import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/firestore_order_service.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final FirestoreOrderService _orderService;

  OrdersBloc({FirestoreOrderService? orderService})
      : _orderService = orderService ?? FirestoreOrderService(),
        super(OrdersInitial()) {
    on<FetchOrders>(_onFetchOrders);
    on<CreateOrder>(_onCreateOrder);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
  }

  Future<void> _onFetchOrders(FetchOrders event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading());
    final response = await _orderService.getOrders(event.userId);
    if (response.success && response.data != null) {
      emit(OrdersLoaded(response.data!));
    } else {
      emit(OrdersError(response.message ?? 'Orders load nahi hue'));
    }
  }

  Future<void> _onCreateOrder(CreateOrder event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading());
    final response = await _orderService.createOrder(event.order);
    if (response.success && response.data != null) {
      final orderId = response.data!.id;
      
      // Log Analytics Purchase
      AnalyticsService.instance.logPurchase(
        value: event.order.totalAmount,
        transactionId: orderId,
        items: event.order.items.map((i) => AnalyticsEventItem(
          itemId: i.productId,
          itemName: i.productName,
          price: i.price,
          quantity: i.quantity,
        )).toList(),
      );

      emit(OrderSuccess(response.data!));
    } else {
      emit(OrdersError(response.message ?? 'Order fail hua'));
    }
  }

  Future<void> _onUpdateOrderStatus(UpdateOrderStatus event, Emitter<OrdersState> emit) async {
    final response = await _orderService.updateStatus(event.orderId, event.status);
    if (response.success) {
      // Refresh current list if loaded
      if (state is OrdersLoaded) {
        final currentOrders = (state as OrdersLoaded).orders;
        final updatedOrders = currentOrders.map((o) {
          if (o.id == event.orderId) {
            return o; // In real case we'd fetch again or update local
          }
          return o;
        }).toList();
        // Trigger re-fetch for simplicity or update locally
        // add(FetchOrders(currentOrders.first.customerId)); 
      }
    }
  }
}
