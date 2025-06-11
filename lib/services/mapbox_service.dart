import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MapboxService {
  static final MapboxService _instance = MapboxService._internal();
  factory MapboxService() => _instance;
  MapboxService._internal();

  final accessToken =
      dotenv.env['MAPBOX_TOKEN'] ??
      () => throw Exception('Mapbox access token is not set in .env file');

  /// Checks if a given position (longitude, latitude) is within a building area.
  Future<bool> isPositionOutside({required double longitude, required double latitude}) async {
    final url = Uri.parse(
      'https://api.mapbox.com/v4/mapbox.mapbox-streets-v8/tilequery/'
      '$longitude,$latitude.json?radius=2&limit=1&layers=building&access_token=$accessToken',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = data['features'] as List;
      return features.isEmpty; // If no features found, it's outside a building
    } else {
      throw Exception('Failed to fetch data from Mapbox API');
    }
  }
}
