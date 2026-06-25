enum ListingType { rent, buy, both }
enum RentalDuration { perDay, threeDays, weekly }

class RentalProductModel {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String? brand;
  final String vendorId;
  final String vendorName;
  final String vendorAddress;   // Rider yahan se pickup karega
  final List<String> images;
  final int stock;              // Kitne units available hain
  final bool isAvailable;
  final String unit;

  // Rental specific fields
  final ListingType listingType;
  final double? rentPerDay;
  final double? rentFor3Days;
  final double? rentPerWeek;
  final double securityDeposit;
  final double? buyPrice;       // Agar buy bhi kar sakte hain

  // Specs
  final Map<String, String> specifications; // {"Power": "750W", "Weight": "2.5kg"}
  final List<String> includes;              // ["Drill bits", "Carry case"]
  final String? condition;                  // "New", "Like New", "Good"
  final double rating;
  final int reviewCount;
  final List<String> tags;

  RentalProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    this.brand,
    required this.vendorId,
    required this.vendorName,
    required this.vendorAddress,
    required this.images,
    required this.stock,
    this.isAvailable = true,
    this.unit = 'pcs',
    this.listingType = ListingType.rent,
    this.rentPerDay,
    this.rentFor3Days,
    this.rentPerWeek,
    this.securityDeposit = 500.0,
    this.buyPrice,
    this.specifications = const {},
    this.includes = const [],
    this.condition = 'Good',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.tags = const [],
  });

  // Sabse sasta rental option
  double get cheapestRent => rentPerDay ?? rentFor3Days ?? rentPerWeek ?? 0.0;

  // Daily rate calculate karo
  double get effectiveDailyRate {
    if (rentPerDay != null) return rentPerDay!;
    if (rentFor3Days != null) return rentFor3Days! / 3;
    if (rentPerWeek != null) return rentPerWeek! / 7;
    return 0.0;
  }

  /// Calculate savings percentage compared to daily rate
  int calculateSavingsPercentage(double durationPrice, int days) {
    if (rentPerDay == null || days <= 1) return 0;
    final double standardPrice = rentPerDay! * days;
    if (standardPrice <= durationPrice) return 0;
    return (((standardPrice - durationPrice) / standardPrice) * 100).round();
  }

  factory RentalProductModel.fromJson(Map<String, dynamic> json) {
    return RentalProductModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      brand: json['brand']?.toString(),
      vendorId: json['vendorId']?.toString() ?? '',
      vendorName: json['vendorName']?.toString() ?? '',
      vendorAddress: json['vendorAddress']?.toString() ?? '',
      images: List<String>.from(json['images'] ?? []),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      unit: json['unit']?.toString() ?? 'pcs',
      listingType: _parseListingType(json['listingType']),
      rentPerDay: (json['rentPerDay'] as num?)?.toDouble(),
      rentFor3Days: (json['rentFor3Days'] as num?)?.toDouble(),
      rentPerWeek: (json['rentPerWeek'] as num?)?.toDouble(),
      securityDeposit: (json['securityDeposit'] as num?)?.toDouble() ?? 500.0,
      buyPrice: (json['buyPrice'] as num?)?.toDouble(),
      specifications: Map<String, String>.from(json['specifications'] ?? {}),
      includes: List<String>.from(json['includes'] ?? []),
      condition: json['condition']?.toString() ?? 'Good',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  static ListingType _parseListingType(dynamic value) {
    switch (value?.toString()) {
      case 'buy': return ListingType.buy;
      case 'both': return ListingType.both;
      default: return ListingType.rent;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'brand': brand,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'vendorAddress': vendorAddress,
      'images': images,
      'stock': stock,
      'isAvailable': isAvailable,
      'unit': unit,
      'listingType': listingType.name,
      'rentPerDay': rentPerDay,
      'rentFor3Days': rentFor3Days,
      'rentPerWeek': rentPerWeek,
      'securityDeposit': securityDeposit,
      'buyPrice': buyPrice,
      'specifications': specifications,
      'includes': includes,
      'condition': condition,
      'rating': rating,
      'reviewCount': reviewCount,
      'tags': tags,
    };
  }
}