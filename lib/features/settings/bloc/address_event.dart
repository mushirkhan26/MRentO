import 'package:equatable/equatable.dart';
import '../../../core/models/address_model.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddresses extends AddressEvent {
  final String userId;
  const LoadAddresses(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddAddress extends AddressEvent {
  final String userId;
  final AddressModel address;
  const AddAddress(this.userId, this.address);

  @override
  List<Object?> get props => [userId, address];
}

class UpdateAddress extends AddressEvent {
  final String userId;
  final AddressModel address;
  const UpdateAddress(this.userId, this.address);

  @override
  List<Object?> get props => [userId, address];
}

class DeleteAddress extends AddressEvent {
  final String userId;
  final String addressId;
  const DeleteAddress(this.userId, this.addressId);

  @override
  List<Object?> get props => [userId, addressId];
}

class SetDefaultAddress extends AddressEvent {
  final String userId;
  final String addressId;
  const SetDefaultAddress(this.userId, this.addressId);

  @override
  List<Object?> get props => [userId, addressId];
}
