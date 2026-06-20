import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class FetchLocation extends LocationEvent {
  final bool forceRefresh;

  const FetchLocation({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class SetManualLocation extends LocationEvent {
  final String address;

  const SetManualLocation(this.address);

  @override
  List<Object?> get props => [address];
}
