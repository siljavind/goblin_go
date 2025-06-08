import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MapboxService {
  MapboxService._();
  static final MapboxService instance = MapboxService._();
  final accessToken = dotenv.env['MAPBOX_TOKEN'];

  Future<bool> isPositionOutside({
    required double longitude,
    required double latitude,
  }) async {
    final url = Uri.parse(
      'https://api.mapbox.com/v4/mapbox.mapbox-streets-v8/tilequery/'
      '$longitude,$latitude.json?radius=1&limit=1&dedupe&layers=building&access_token=$accessToken',
    );

    //TODO: Data is only shown in UI if a breakpoint is applied and hit
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = data['features'] as List?;
      return features!.isEmpty;
    } else {
      throw Exception('Failed to fetch data from Mapbox API');
    }
  }
}
