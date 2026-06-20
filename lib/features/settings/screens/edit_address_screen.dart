import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/address_model.dart';
import '../../../core/services/location_service.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';

class EditAddressScreen extends StatefulWidget {
  final AddressModel address;

  const EditAddressScreen({super.key, required this.address});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  GoogleMapController? _mapController;
  LatLng _currentMapCenter = const LatLng(26.2389, 73.0243); // Default Jodhpur
  String _currentAddress = 'Fetching address...';
  String _currentLocality = 'Jodhpur';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentAddress = widget.address.streetAddress;
    _currentLocality = widget.address.city;
    // Note: In a real app, we would ideally have lat/lng in the AddressModel
    // For now, we'll start with default or current position
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final position = await LocationService.instance.getCurrentLocation();
    if (position != null && mounted) {
      setState(() {
        _currentMapCenter = LatLng(position.latitude, position.longitude);
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentMapCenter, 16),
      );
      _updateAddressFromCoords(_currentMapCenter);
    }
  }

  Future<void> _updateAddressFromCoords(LatLng coords) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        coords.latitude,
        coords.longitude,
      );
      if (placemarks.isNotEmpty && mounted) {
        Placemark place = placemarks[0];
        setState(() {
          _currentLocality = place.locality ?? 'Unknown';
          _currentAddress = "${place.subLocality ?? ""}, ${place.name ?? ""}";
          if (_currentAddress.startsWith(", ")) {
            _currentAddress = _currentAddress.substring(2);
          }
        });
      }
    } catch (e) {
      debugPrint("Geocoding error: $e");
    }
  }

  void _onCameraMove(CameraPosition position) {
    _currentMapCenter = position.target;
  }

  void _onCameraIdle() {
    _updateAddressFromCoords(_currentMapCenter);
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLoading = true);
    final position = await LocationService.instance.getCurrentLocation(forceRefresh: true);
    setState(() => _isLoading = false);
    
    if (position != null && mounted) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          17,
        ),
      );
    }
  }

  void _saveAndProceed() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final updatedAddress = widget.address.copyWith(
        streetAddress: _currentAddress,
        city: _currentLocality,
        // In a real app, we'd also save the lat/lng here
      );
      context.read<AddressBloc>().add(UpdateAddress(authState.user.userId, updatedAddress));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentMapCenter,
              zoom: 15,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // 2. Custom App Bar / Header
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.primaryBlack),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: AppColors.grey500, size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Search for a new area...',
                          style: TextStyle(color: AppColors.grey500, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Static Center Pin
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlack,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Your order will be delivered here',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const Icon(Icons.location_on, color: AppColors.primaryYellow, size: 48),
                const SizedBox(height: 32), // Offset for the pin tip
              ],
            ),
          ),

          // 4. Use Current Location Button
          Positioned(
            bottom: 240,
            right: 16,
            child: FloatingActionButton.extended(
              onPressed: _useCurrentLocation,
              backgroundColor: Colors.white,
              elevation: 4,
              icon: const Icon(Icons.my_location, color: Colors.green, size: 20),
              label: const Text(
                'Use current location',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // 5. Bottom Address Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Delivering your order to',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlack,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.home, color: AppColors.primaryYellow, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentLocality,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                _currentAddress,
                                style: const TextStyle(
                                  color: AppColors.grey500,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Change', style: TextStyle(color: Colors.green)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveAndProceed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Update the pin & proceed',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.green)),
        ],
      ),
    );
  }
}
