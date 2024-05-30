import 'package:bfsweather/data/location/locationData.dart';

class HardcodedLocations {
  static const dortmund = LocationData(
    name: 'Dortmund',
    lat: 51.513587,
    lng: 7.465298,
  );
  static const berlin = LocationData(
    name: 'Berlin',
    lat: 52.520008,
    lng: 13.404954,
  );
  static const hamburg = LocationData(
    name: 'Hamburg',
    lat: 53.5510846,
    lng: 9.9936819,
  );

  static const marrakesh = LocationData(
    name: 'Marrakesh',
    lat: 31.6294723,
    lng: -7.9810845,
  );

  final locations = [dortmund, berlin, hamburg, marrakesh];

  LocationData? get(String name) => (locations as List<LocationData?>)
      .firstWhere((location) => location?.name == name, orElse: () => null);

  List<LocationData> search(String name) {
    return locations
        .where(
            (location) => location.name?.toLowerCase().contains(name) ?? false)
        .toList();
  }
}
