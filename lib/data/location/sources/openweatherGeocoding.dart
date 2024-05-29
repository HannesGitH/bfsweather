import 'dart:convert';

import 'package:bfsweather/data/location/locationData.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

class OpenweatherGeocoding {
  static const directQueryUrl =
      'http://api.openweathermap.org/geo/1.0/direct?q=';
  final limit = 10;

  final _apiKey = dotenv.env['OPENWEATHER_API_KEY'];

  Future<List<LocationData>> search(String name) =>
      _fetchLocations('$name&limit=$limit');

  Future<LocationData> get(String name) => _fetchLocations('$name&limit=1')
      .then((locationList) => locationList.first);

  Future<List<LocationData>> _fetchLocations(String query) async {
    final url = '$directQueryUrl$query&appid=$_apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> jsonEncodedLocations =
          jsonDecode(response.body);
      final data = jsonEncodedLocations
          .map((json) => LocationData.fromJson(json))
          .toList();
      return data;
    } else {
      throw Exception('Failed to load location data');
    }
  }
}
