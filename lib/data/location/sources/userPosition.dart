import 'package:bfsweather/data/location/locationData.dart';
import 'package:geolocator/geolocator.dart';

class UserPositionSource {
  Future<LocationData?> getUserPosition() async {
    if (!await Geolocator.isLocationServiceEnabled() ||
        !(await Geolocator.checkPermission()).allowed) {
      return null;
    }
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    return LocationData(
      name: 'My Location',
      lat: position.latitude,
      lng: position.longitude,
    );
  }
}

extension CheckAllowedLocationPermissionExtension on LocationPermission {
  bool get allowed =>
      this == LocationPermission.whileInUse ||
      this == LocationPermission.always;
}
