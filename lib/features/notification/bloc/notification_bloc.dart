import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/firestore_notification_service.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FirestoreNotificationService _service;

  NotificationBloc({FirestoreNotificationService? service})
      : _service = service ?? FirestoreNotificationService(),
        super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkAsRead);
  }

  Future<void> _onLoadNotifications(
      LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    final response = await _service.getNotifications(event.userId);
    if (response.success && response.data != null) {
      emit(NotificationLoaded(response.data!));
    } else {
      emit(NotificationError(response.message ?? 'Notifications load nahi hue'));
    }
  }

  Future<void> _onMarkAsRead(
      MarkNotificationAsRead event, Emitter<NotificationState> emit) async {
    await _service.markAsRead(event.userId, event.notificationId);
    // Reload
    add(LoadNotifications(event.userId));
  }
}
