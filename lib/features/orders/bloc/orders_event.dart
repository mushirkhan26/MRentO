import 'package:equatable/equatable.dart';
import '../../../core/models/order_model.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class FetchOrders extends OrdersEvent {
  final String userId;
  const FetchOrders(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateOrder extends OrdersEvent {
  final OrderModel order;
  const CreateOrder(this.order);

  @override
  List<Object?> get props => [order];
}

class UpdateOrderStatus extends OrdersEvent {
  final String orderId;
  final OrderStatus status;
  const UpdateOrderStatus(this.orderId, this.status);

  @override
  List<Object?> get props => [orderId, status];
}
