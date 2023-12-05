// emergency_model.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class EmergencyModel {
  late Position currentPosition;
  String type = '';
  String name = '';
  String email = '';
//get sender current position
  Future<void> getCurrentLocation() async {
    try {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting current location: $e');
    }
  }
}

class EmergencyData {
  final String email;
  final double latitude;
  final double longitude;

  const EmergencyData({
    required this.email,
    required this.latitude,
    required this.longitude,
  });
}
