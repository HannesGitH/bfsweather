import 'locationData.dart';
import 'sources/openweatherGeocoding.dart';
import 'sources/hardcodedLocations.dart';

class LocationRepository {
  final openweatherSource = OpenweatherGeocoding();
  final hardcodedSource = HardcodedLocations();

  Future<LocationData> getLocationFromName(String name) async {
    //TODO: Implement offline
    return hardcodedSource.get(name) ?? await openweatherSource.get(name);
  }

  Future<List<LocationData>> search(String name) async {
    return [
      ...hardcodedSource.search(name),
      ...await openweatherSource.search(name),
    ];
  }

  Future<List<LocationData>> getFavorites() async => hardcodedSource.locations;
}
