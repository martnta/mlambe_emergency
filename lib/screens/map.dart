import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mlambe_emergency/models/directions.dart';
import 'package:mlambe_emergency/screens/chat.dart';
import 'package:mlambe_emergency/screens/emergency.dart';

import '../directions_repo.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  _MapPageState() {
    //initialisation
    _destination = Marker(
      markerId: MarkerId('Destination'),
      infoWindow: const InfoWindow(title: 'Destination'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: const LatLng(-15.6445, 35.0174), // Destination coordinates
    );
  }
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-15.798283, 35.005829), // Blantyre, Malawi
    zoom: 11.5,
  );

  late GoogleMapController _googleMapController;
  Marker? _origin;
  late Marker _destination;
  late Directions? _info = null;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mlambe Emergency',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            )),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              if (_origin != null) _origin!,
              _destination,
            },
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.purpleAccent,
                  width: 5,
                  points: _info!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
          ),
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 10.0))
                    ]),
                child: Text(
                  '${_info?.totalDistance}, ${_info?.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.location_on),
      ),
    );
  }

//getting current location with geolocator

  void _getCurrentLocation() async {
    try {
      print("getting location...");
      final currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print("Current position: $currentPosition");

      final pos = LatLng(currentPosition.latitude, currentPosition.longitude!);

      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // Show a dialog to ask the user whether to start tracking the destination
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Start Tracking?'),
            content:
                const Text('Do you want to start tracking the destination?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _startTrackingDestination(); // Start tracking
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  // Optionally, you can handle not starting tracking here
                },
                child: const Text('No'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error: $e');
      // Handle other errors (e.g., Geolocator errors)
    }
  }

//tracking method
  void _startTrackingDestination() async {
    try {
      final directions = await DirectionsRepository().getDirections(
        origin: _origin?.position,
        destination: _destination.position,
      );

      if (directions != null) {
        setState(() {
          _info = directions;
        });
        _googleMapController.animateCamera(
          _info != null
              ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
              : CameraUpdate.newCameraPosition(_initialCameraPosition),
        );
      } else {
        // Handle directions fetch failure
        _showDirectionFetch();
      }
    } catch (e) {
      print('Error: $e');
      // Handle other errors
    }
  }

  void _showDirectionFetch() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start Tracking Destination?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Do you want to start tracking the destination?'),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Current Position:'),
                  Text(
                    '${_origin?.position.latitude}, ${_origin?.position.longitude}',
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Destination:'),
                  Text(
                    '${_destination.position.latitude}, ${_destination.position.longitude}',
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _startTrackingDestination(); // Start tracking
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Optionally, you can handle not starting tracking here
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
