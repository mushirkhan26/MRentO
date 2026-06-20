import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final String userId;
  const LoadNotifications(this.userId);
  @override
  List<Object?> get props => [userId];
}

class MarkNotificationAsRead extends NotificationEvent {
  final String userId;
  final String notificationId;
  const MarkNotificationAsRead(this.userId, this.notificationId);
  @override
  List<Object?> get props => [userId, notificationId];
}
