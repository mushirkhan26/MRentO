import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/services/location_service.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService _locationService = LocationService.instance;

  LocationBloc() : super(LocationInitial()) {
    on<FetchLocation>(_onFetchLocation);
    on<SetManualLocation>(_onSetManualLocation);
  }

  void _onSetManualLocation(
    SetManualLocation event,
    Emitter<LocationState> emit,
  ) {
    // We don't have coordinates for manual city selection in this simple mock
    // In a real app, we'd fetch them or have them predefined
    emit(LocationLoaded(
      position: Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      ),
      address: event.address,
    ));
  }

  Future<void> _onFetchLocation(
    FetchLocation event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final permission = await _locationService.handlePermission();
      if (!_locationService.isPermissionGranted(permission)) {
        emit(const LocationError('Location permission denied. Please enable it in settings.'));
        return;
      }

      final position = await _locationService.getCurrentLocation(
        forceRefresh: event.forceRefresh,
      );

      if (position != null) {
        String address = "Location detected";
        try {
          print('DEBUG: Fetching placemarks for ${position.latitude}, ${position.longitude}');
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          ).timeout(const Duration(seconds: 5));
          
          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            print('DEBUG: Placemark found: ${place.toJson()}');
            // Format: subLocality, locality
            String subLocality = place.subLocality ?? "";
            String locality = place.locality ?? "";
            String name = place.name ?? "";
            
            if (subLocality.isNotEmpty && locality.isNotEmpty) {
              address = "$subLocality, $locality";
            } else if (locality.isNotEmpty) {
              address = locality;
            } else if (subLocality.isNotEmpty) {
              address = subLocality;
            } else if (name.isNotEmpty) {
              address = name;
            } else {
              address = "Location detected";
            }
          }
        } catch (e) {
          print('DEBUG: Geocoding error: $e');
          // Fallback message instead of just coordinates
          if (e.toString().contains('MissingPluginException')) {
            address = "Location detected (Restart App)";
          } else {
            address = "${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
          }
        }
        
        emit(LocationLoaded(position: position, address: address));
      } else {
        emit(const LocationError('Could not fetch current location.'));
      }
    } catch (e) {
      emit(LocationError('Error: ${e.toString()}'));
    }
  }
}
