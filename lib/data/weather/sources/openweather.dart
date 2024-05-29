import 'dart:convert';

import 'package:bfsweather/common/options.dart';
import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/data/weather/weatherData.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

class Openweather {
  static const onecallQueryUrl =
      'https://api.openweathermap.org/data/3.0/onecall?';

  final _apiKey = dotenv.env['OPENWEATHER_API_KEY'];

  Future<WholeWeatherData> queryFor({required LocationData location}) =>
      _fetchWeather('lat=${location.lat}&lon=${location.lng}');

  Future<WholeWeatherData> _fetchWeather(String query) async {
    final units = Options().unit.openweatherName;
    final url = '$onecallQueryUrl$query&units=$units&appid=$_apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonEncodedWeather = jsonDecode(response.body);
      return WholeWeatherData.fromJson(jsonEncodedWeather);
    } else {
      throw Exception("Failed to load weather data");
    }
  }
}
