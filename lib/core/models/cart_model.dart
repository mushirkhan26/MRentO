class CartModel {
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;

  CartModel({
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    double? discount,
  }) : discount = discount ?? 0.0;

  double get total => subtotal + deliveryFee + tax - discount;
  double get mrpTotal => items.fold(0, (sum, item) => sum + (item.originalPrice ?? item.price) * item.quantity);
  double get productDiscount => mrpTotal - subtotal;

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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'discount': discount,
    };
  }
}

class CartItem {
  final String productId;
  final String productName;

  // ── Legacy (fashion) fields ──
  // size/color/brand ab bhi rakhe hain taaki abhi compile na toote.
  // Phase 3 me product_details + cart widgets update hone ke baad
  // inhe vendorName/rentalDurationLabel se replace karke hata sakte ho.
  final String? brand;
  final String? size;
  final String? color;

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
    this.size,
    this.color,
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

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      brand: json['brand'],
      size: json['size'],
      color: json['color'],
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
      'size': size,
      'color': color,
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