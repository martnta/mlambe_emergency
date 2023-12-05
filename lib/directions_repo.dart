import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'env.dart';
import 'models/directions.dart';

///fetching directions from google
///
class DirectionsRepository {
  static const String _baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json";

  late final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    @required LatLng? origin,
    @required LatLng? destination,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'origin': '${origin?.latitude},${origin?.longitude}',
          'destination': '${destination?.latitude},${destination?.longitude}',
          'key': googleAPIKey,
        },
        options: Options(
          headers: {
            // Add headers if needed
          },
        ),
      );
//if response.status is ok!
      if (response.statusCode == 200) {
        return Directions.fromMap(response.data);
      } else {
        throw Exception(
            'Failed to get directions. Status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('DioError: $e');
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
