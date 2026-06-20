import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String streetAddress;
  final String city;
  final String state;
  final String zipCode;
  final String tag; // e.g., 'Home', 'Office'
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zipCode,
    this.tag = 'Home',
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      streetAddress: json['streetAddress'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      tag: json['tag'] ?? 'Home',
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'streetAddress': streetAddress,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'tag': tag,
      'isDefault': isDefault,
    };
  }

  AddressModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? streetAddress,
    String? city,
    String? state,
    String? zipCode,
    String? tag,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      tag: tag ?? this.tag,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        streetAddress,
        city,
        state,
        zipCode,
        tag,
        isDefault,
      ];
}
