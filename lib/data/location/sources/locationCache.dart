import 'package:bfsweather/common/jsonCache.dart';
import 'package:bfsweather/data/location/locationData.dart';

class LocationCache {
  static final LocationCache _instance = LocationCache._internal();
  factory LocationCache() => _instance;
  LocationCache._internal();

  static const String _locationPrefix = 'location/';

  String _cacheName(LocationData location) =>
      _locationPrefix + location.toQueryStr();

  final JsonCache _cache = JsonCache();

  void set(LocationData location) =>
      _cache.set(_cacheName(location), location.toJson());

  LocationData? get(String lat, String lng, {bool includeSimilar = true}) {
    var location = LocationData(lat: double.parse(lat), lng: double.parse(lng));
    try {
      return _cache.get<LocationData>(_cacheName(location));
    } catch (e) {}
    if (includeSimilar) {
      try {
        return getAll().firstWhere((loc) => loc.isApprox(location));
      } catch (e) {}
    }
    return null;
  }

  List<LocationData> getAll() => _cache
      .getAllIn(_locationPrefix)
      .map((json) => LocationData.fromJson(json))
      .toList();
}
