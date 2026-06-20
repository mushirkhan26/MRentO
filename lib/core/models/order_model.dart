enum OrderStatus {
  pending,      // Order place hua, vendor confirm karne wala hai
  confirmed,    // Vendor ne accept kar liya
  dispatched,   // Rider equipment lekar nikal gaya
  delivered,    // Equipment customer ke paas pahunch gaya
  active,       // Rental period chal raha hai
  returned,     // Equipment wapas aa gaya, deposit refund ho sakta hai
  overdue,      // Return date nikal gayi, abhi tak wapas nahi aaya
  cancelled,
}

class OrderModel {
  final String id;
  final String customerId;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final String deliveryAddress;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final double? driverLat;
  final double? driverLng;

  // ── Rental-specific fields ──
  final DateTime? rentalStartDate;
  final DateTime? rentalEndDate;
  final double totalSecurityDeposit;   // Sum of all items' deposits
  final bool securityRefunded;         // Return ke baad deposit wapas hua ya nahi

  OrderModel({
    required this.id,
    required this.customerId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.deliveryAddress,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.driverLat,
    this.driverLng,
    this.rentalStartDate,
    this.rentalEndDate,
    double? totalSecurityDeposit,
    this.securityRefunded = false,
  }) : totalSecurityDeposit = totalSecurityDeposit ?? 0.0;

  /// Kitne din baaki hain return karne mein (negative = overdue)
  int? get daysRemaining {
    if (rentalEndDate == null) return null;
    return rentalEndDate!.difference(DateTime.now()).inDays;
  }

  /// Status overdue ho sakta hai agar end date nikal gayi aur abhi tak return nahi hua
  bool get isOverdue {
    if (rentalEndDate == null) return false;
    if (status == OrderStatus.returned || status == OrderStatus.cancelled) {
      return false;
    }
    return DateTime.now().isAfter(rentalEndDate!);
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      items: (json['items'] as List?)
          ?.map((item) => OrderItem.fromJson(item))
          .toList() ??
          [],
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: OrderStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      deliveryAddress: json['deliveryAddress'] ?? '',
      driverId: json['driverId'],
      driverName: json['driverName'],
      driverPhone: json['driverPhone'],
      driverLat: (json['driverLat'] as num?)?.toDouble(),
      driverLng: (json['driverLng'] as num?)?.toDouble(),
      rentalStartDate: json['rentalStartDate'] != null
          ? DateTime.tryParse(json['rentalStartDate'].toString())
          : null,
      rentalEndDate: json['rentalEndDate'] != null
          ? DateTime.tryParse(json['rentalEndDate'].toString())
          : null,
      totalSecurityDeposit:
      (json['totalSecurityDeposit'] as num?)?.toDouble() ?? 0.0,
      securityRefunded: json['securityRefunded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'deliveryAddress': deliveryAddress,
      'driverId': driverId,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'driverLat': driverLat,
      'driverLng': driverLng,
      'rentalStartDate': rentalStartDate?.toIso8601String(),
      'rentalEndDate': rentalEndDate?.toIso8601String(),
      'totalSecurityDeposit': totalSecurityDeposit,
      'securityRefunded': securityRefunded,
    };
  }

  OrderModel copyWith({
    String? id,
    String? customerId,
    List<OrderItem>? items,
    double? totalAmount,
    OrderStatus? status,
    DateTime? createdAt,
    String? deliveryAddress,
    String? driverId,
    String? driverName,
    String? driverPhone,
    double? driverLat,
    double? driverLng,
    DateTime? rentalStartDate,
    DateTime? rentalEndDate,
    double? totalSecurityDeposit,
    bool? securityRefunded,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      driverLat: driverLat ?? this.driverLat,
      driverLng: driverLng ?? this.driverLng,
      rentalStartDate: rentalStartDate ?? this.rentalStartDate,
      rentalEndDate: rentalEndDate ?? this.rentalEndDate,
      totalSecurityDeposit:
      totalSecurityDeposit ?? this.totalSecurityDeposit,
      securityRefunded: securityRefunded ?? this.securityRefunded,
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price; // selected rental duration ka rate

  // ── Rental-specific fields ──
  final String? vendorName;
  final String? rentalDurationLabel; // "1 Din", "3 Din", "1 Hafta"
  final int? rentalDays;
  final double securityDeposit; // per-unit deposit

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    this.vendorName,
    this.rentalDurationLabel,
    this.rentalDays,
    double? securityDeposit,
  }) : securityDeposit = securityDeposit ?? 0.0;

  double get total => price * quantity;
  double get totalSecurityDeposit => securityDeposit * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      vendorName: json['vendorName'],
      rentalDurationLabel: json['rentalDurationLabel'],
      rentalDays: (json['rentalDays'] as num?)?.toInt(),
      securityDeposit: (json['securityDeposit'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'vendorName': vendorName,
      'rentalDurationLabel': rentalDurationLabel,
      'rentalDays': rentalDays,
      'securityDeposit': securityDeposit,
    };
  }
}