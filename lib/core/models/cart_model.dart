class CartModel {
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final String? couponCode;
  final double couponDiscount;

  CartModel({
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    double? discount,
    this.couponCode,
    double? couponDiscount,
  }) : discount = discount ?? 0.0,
       couponDiscount = couponDiscount ?? 0.0;

  double get total => subtotal + deliveryFee + tax - discount - couponDiscount;
  double get mrpTotal => items.fold(0, (sum, item) => sum + (item.originalPrice ?? item.price) * item.quantity);
  double get productDiscount => mrpTotal - subtotal;
  double get totalDiscount => discount + couponDiscount;

  /// Total refundable security deposit across all rental items
  double get totalSecurityDeposit =>
      items.fold(0, (sum, item) => sum + item.totalSecurityDeposit);

  /// Amount payable at checkout including refundable security deposit
  double get grandTotal => total + totalSecurityDeposit;

  factory CartModel.empty() {
    return CartModel(
      items: [],
      subtotal: 0.0,
      deliveryFee: 0.0,
      tax: 0.0,
      discount: 0.0,
      couponDiscount: 0.0,
    );
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: (json['items'] as List?)
          ?.map((item) => CartItem.fromJson(item))
          .toList() ??
          [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      couponCode: json['couponCode'],
      couponDiscount: (json['couponDiscount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'discount': discount,
      'couponCode': couponCode,
      'couponDiscount': couponDiscount,
    };
  }
}

class CartItem {
  final String productId;
  final String productName;
  final String? brand;
  final String? productImage;
  final int quantity;
  final double price; // rental rate for the selected duration
  final double? originalPrice;
  final List<String>? badges;

  // ── Rental-specific fields ──
  final String? vendorName;
  final String? rentalDurationLabel; // e.g. "1 Day", "3 Days", "1 Week"
  final int? rentalDays; // numeric duration in days, for calculations
  final DateTime? startDate;
  final DateTime? endDate;
  final double securityDeposit; // refundable deposit per unit

  CartItem({
    required this.productId,
    required this.productName,
    this.brand,
    this.productImage,
    required this.quantity,
    required this.price,
    this.originalPrice,
    this.badges,
    this.vendorName,
    this.rentalDurationLabel,
    this.rentalDays,
    this.startDate,
    this.endDate,
    double? securityDeposit,
  }) : securityDeposit = securityDeposit ?? 0.0;

  double get total => price * quantity;

  /// Total refundable security deposit for this line item
  double get totalSecurityDeposit => securityDeposit * quantity;

  CartItem copyWith({
    String? productId,
    String? productName,
    String? brand,
    String? productImage,
    int? quantity,
    double? price,
    double? originalPrice,
    List<String>? badges,
    String? vendorName,
    String? rentalDurationLabel,
    int? rentalDays,
    DateTime? startDate,
    DateTime? endDate,
    double? securityDeposit,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      brand: brand ?? this.brand,
      productImage: productImage ?? this.productImage,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      badges: badges ?? this.badges,
      vendorName: vendorName ?? this.vendorName,
      rentalDurationLabel: rentalDurationLabel ?? this.rentalDurationLabel,
      rentalDays: rentalDays ?? this.rentalDays,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      securityDeposit: securityDeposit ?? this.securityDeposit,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      brand: json['brand'],
      productImage: json['productImage'],
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      badges: (json['badges'] as List?)?.map((e) => e.toString()).toList(),
      vendorName: json['vendorName'],
      rentalDurationLabel: json['rentalDurationLabel'],
      rentalDays: (json['rentalDays'] as num?)?.toInt(),
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString())
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'].toString())
          : null,
      securityDeposit: (json['securityDeposit'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'brand': brand,
      'productImage': productImage,
      'quantity': quantity,
      'price': price,
      'originalPrice': originalPrice,
      'badges': badges,
      'vendorName': vendorName,
      'rentalDurationLabel': rentalDurationLabel,
      'rentalDays': rentalDays,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'securityDeposit': securityDeposit,
    };
  }
}
