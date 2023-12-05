import 'dart:js';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/emergency.dart';
import '../screens/email/email.dart';

class EmergencyController {
  final EmergencyModel _model = EmergencyModel();
  late final TextEditingController name;
  late final TextEditingController type;
  late final TextEditingController email;

  EmergencyController() {
    name = TextEditingController();
    email = TextEditingController();
    type = TextEditingController();
  }

//submiting functtion
  Future<void> submitEmergency() async {
    try {
      await _model.getCurrentLocation();

      final emergencyData = {
        'type': type.text,
        'name': name.text,
        'email': email.text,
        'status': 'unattended',
        'latitude': _model.currentPosition.latitude.toDouble(),
        'longitude': _model.currentPosition.longitude.toDouble(),
      };

      final dio = Dio();
      dio.options.headers["Content-Type"] =
          "application/json"; // Set content type
      final response = await dio.post(
        'http://localhost:5000/api/emergency/addemg/', // Use http for Flutter web
        data: emergencyData,
      );
      print('emergencyData: $emergencyData');

      if (response.statusCode == 200) {
        // Success
        print('Emergency data sent successfully: ${response.data}');
      } else {
        // Handle error
        print('Error sending emergency data: ${response.data}');
      }
    } catch (e) {
      print('Error: $e');
      // Handle other errors
    }
  }
}
