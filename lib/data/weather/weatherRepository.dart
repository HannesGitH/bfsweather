import 'package:bfsweather/data/location/locationData.dart';

import 'weatherData.dart';
import 'sources/openweather.dart';

class WeatherRepository {
  final openweatherSource = Openweather();

  Future<WholeWeatherData> getFor({required LocationData location}) async {
    //TODO: Implement offline
    return await openweatherSource.queryFor(location: location);
  }
}
