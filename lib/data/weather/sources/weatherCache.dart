import 'package:bfsweather/common/jsonCache.dart';
import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/data/weather/weatherData.dart';
import 'package:flutter/foundation.dart';

class WeatherCache {
  static final WeatherCache _instance = WeatherCache._internal();
  factory WeatherCache() => _instance;
  WeatherCache._internal();

  static const String _weatherPrefix = 'weather/';

  String _cacheName(LocationData location) =>
      _weatherPrefix + location.toQueryStr();

  final JsonCache _cache = JsonCache();

  void set(WholeWeatherData weather, {required LocationData forLocation}) =>
      _cache.set(_cacheName(forLocation), weather.toJson());

  WholeWeatherData? get(LocationData location,
      {bool includeNearLocations = true}) {
    try {
      final ret = WholeWeatherData.fromJson(_cache.get(_cacheName(location)));
      return ret;
    } catch (e) {
      debugPrint('couldnt get weather: $e');
    }
    if (includeNearLocations) {
      try {
        final nearKey = _cache
            .keysIn(_weatherPrefix)
            .map((key) => LocationData.fromQueryStr(key))
            .firstWhere((loc) => loc.isApprox(location));
        return _cache.get<WholeWeatherData>(_cacheName(nearKey));
      } catch (e) {}
    }
    return null;
  }

  // useless
  List<WholeWeatherData> getAll() => _cache
      .getAllIn(_weatherPrefix)
      .map((json) => WholeWeatherData.fromJson(json))
      .toList();
}
