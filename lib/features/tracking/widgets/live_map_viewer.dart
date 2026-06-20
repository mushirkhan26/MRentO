import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../config/theme/app_colors.dart';
import '../bloc/tracking_bloc.dart';
import '../bloc/tracking_state.dart';
import '../screens/order_tracking_screen.dart';

class LiveMapViewer extends StatefulWidget {
  final DeliveryStage currentStage;

  const LiveMapViewer({super.key, required this.currentStage});

  @override
  State<LiveMapViewer> createState() => _LiveMapViewerState();
}

class _LiveMapViewerState extends State<LiveMapViewer> {
  late GoogleMapController _controller;

  // Jodhpur static coordinates for simulation
  static const LatLng _storeLocation = LatLng(26.2389, 73.0243);
  static const LatLng _customerLocation = LatLng(26.2913, 73.0375);

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initMarkers();
    _initPolylines();
  }

  void _initMarkers() {
    _markers.addAll([
      Marker(
        markerId: const MarkerId('store'),
        position: _storeLocation,
        infoWindow: const InfoWindow(title: 'MRentO Partner'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('customer'),
        position: _customerLocation,
        infoWindow: const InfoWindow(title: 'Aapka Address'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    ]);
  }

  void _initPolylines() {
    _polylines.add(
      const Polyline(
        polylineId: PolylineId('route'),
        points: [_storeLocation, _customerLocation],
        color: AppColors.primaryYellow,
        width: 5,
        geodesic: true,
      ),
    );
  }

  LatLng _getRiderPosition() {
    // Simulating rider movement based on stage
    switch (widget.currentStage) {
      case DeliveryStage.preparing:
        return _storeLocation;
      case DeliveryStage.eightMin:
        return const LatLng(26.2550, 73.0280);
      case DeliveryStage.oneMin:
        return const LatLng(26.2850, 73.0350);
      case DeliveryStage.delivered:
        return _customerLocation;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingBloc, TrackingState>(
      builder: (context, state) {
        LatLng riderPos = _getRiderPosition();

        if (state is TrackingActive && state.latitude != 0 && state.longitude != 0) {
          riderPos = LatLng(state.latitude, state.longitude);
          // Optional: Animate camera to rider position
          _controller.animateCamera(CameraUpdate.newLatLng(riderPos));
        }

        // Add/Update rider marker
        _markers.add(
          Marker(
            markerId: const MarkerId('rider'),
            position: riderPos,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            infoWindow: const InfoWindow(title: 'Rider'),
          ),
        );

        return GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: _storeLocation,
            zoom: 13,
          ),
          markers: _markers,
          polylines: _polylines,
          onMapCreated: (controller) => _controller = controller,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        );
      },
    );
  }
}
