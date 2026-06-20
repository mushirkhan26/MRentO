import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/firestore_address_service.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final FirestoreAddressService _addressService;

  AddressBloc({FirestoreAddressService? addressService})
      : _addressService = addressService ?? FirestoreAddressService(),
        super(AddressInitial()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<AddAddress>(_onAddAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<DeleteAddress>(_onDeleteAddress);
    on<SetDefaultAddress>(_onSetDefaultAddress);
  }

  Future<void> _onLoadAddresses(LoadAddresses event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    final response = await _addressService.getAddresses(event.userId);
    if (response.success && response.data != null) {
      emit(AddressLoaded(response.data!));
    } else {
      emit(AddressError(response.message ?? 'Addresses load nahi hue'));
    }
  }

  Future<void> _onAddAddress(AddAddress event, Emitter<AddressState> emit) async {
    final response = await _addressService.addAddress(event.userId, event.address);
    if (response.success) {
      add(LoadAddresses(event.userId));
      emit(const AddressActionSuccess('Address add ho gaya!'));
    } else {
      emit(AddressError(response.message ?? 'Address save nahi hua'));
    }
  }

  Future<void> _onUpdateAddress(UpdateAddress event, Emitter<AddressState> emit) async {
    final response = await _addressService.updateAddress(event.userId, event.address);
    if (response.success) {
      add(LoadAddresses(event.userId));
      emit(const AddressActionSuccess('Address update ho gaya!'));
    } else {
      emit(AddressError(response.message ?? 'Address update nahi hua'));
    }
  }

  Future<void> _onDeleteAddress(DeleteAddress event, Emitter<AddressState> emit) async {
    final response = await _addressService.deleteAddress(event.userId, event.addressId);
    if (response.success) {
      add(LoadAddresses(event.userId));
      emit(const AddressActionSuccess('Address delete ho gaya!'));
    } else {
      emit(AddressError(response.message ?? 'Address delete nahi hua'));
    }
  }

  Future<void> _onSetDefaultAddress(SetDefaultAddress event, Emitter<AddressState> emit) async {
    final response = await _addressService.setDefaultAddress(event.userId, event.addressId);
    if (response.success) {
      add(LoadAddresses(event.userId));
    } else {
      emit(AddressError(response.message ?? 'Default address set nahi hua'));
    }
  }
}
