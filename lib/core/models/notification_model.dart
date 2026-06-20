import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final String? type; // e.g., 'order_update', 'promo'
  final Map<String, dynamic>? data;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,

    required this.createdAt,
    this.type,
    this.data,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      type: json['type'],
      data: json['data'],
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'type': type,
      'data': data,
      'isRead': isRead,
    };
  }

  @override
  List<Object?> get props => [id, title, body, createdAt, type, data, isRead];
}
