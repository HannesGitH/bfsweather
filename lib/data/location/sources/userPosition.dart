import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/data/location/sources/openweatherGeocoding.dart';
import 'package:geolocator/geolocator.dart';

class UserPositionSource {
  final openWGC = OpenweatherGeocoding();

  Future<LocationData?> getUserPosition() async {
    if (!await Geolocator.isLocationServiceEnabled() ||
        !(await Geolocator.checkPermission()).allowed) {
      return null;
    }
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      timeLimit: const Duration(seconds: 5),
    );
    return ((LocationData l) =>
            l.copyWith(name: 'Your location: ${l.name ?? 'Unknown'}'))(
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
