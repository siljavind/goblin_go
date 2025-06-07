import 'dart:convert';

import 'package:http/http.dart' as http;

class MapboxService {
  MapboxService._();
  static final MapboxService instance = MapboxService._();
  final String accessToken =
      'pk.eyJ1IjoienlsdmFlIiwiYSI6ImNtYmFyNGlqOTE5aXcya3M2aGtwNWMxcXIifQ.OK1oz05T_DqGDQE7zmV_wA';

  Future<bool> isInBuilding(double longitude, double latitude) async {
    final url = Uri.parse(
      'https://api.mapbox.com/v4/mapbox.mapbox-streets-v8/tilequery/'
      '$longitude,$latitude.json?radius=1&limit=5&dedupe&layers=building&access_token=$accessToken',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = data['features'] as List?;
      return features != null && features.isNotEmpty;
    } else {
      throw Exception('Failed to fetch data from Mapbox API');
    }
  }
}
