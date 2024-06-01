import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/data/location/sources/locationCache.dart';
import 'package:bfsweather/data/location/sources/openweatherGeocoding.dart';
import 'package:geolocator/geolocator.dart';

class UserPositionSource {
  final _cache = LocationCache();

  final openWGC = OpenweatherGeocoding();

  Future<LocationData?> getUserPosition() async {
    // return null;
    if (!await Geolocator.isLocationServiceEnabled() ||
        !(await Geolocator.checkPermission()).allowed) {
      return null;
    }
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      timeLimit: const Duration(seconds: 5),
    );

    final cached = _cache.get(
      position.latitude.toString(),
      position.longitude.toString(),
      includeSimilar: true,
    );

    return cached ??
        ((LocationData l) => l.copyWith(
                name: l.name == null
                    ? 'Your Location'
                    : 'Your location: ${l.name}'))(
            await openWGC.tryAddName(LocationData(
          lat: position.latitude,
          lng: position.longitude,
        )));
  }
}

extension CheckAllowedLocationPermissionExtension on LocationPermission {
  bool get allowed =>
      this == LocationPermission.whileInUse ||
      this == LocationPermission.always;
}
