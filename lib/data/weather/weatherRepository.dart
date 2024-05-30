import 'package:bfsweather/data/location/locationData.dart';

import 'weatherData.dart';
import 'sources/openweather.dart';

class WeatherRepository {
  final openweatherSource = Openweather();

  Stream<WholeWeatherData> getFor({required LocationData location}) async* {
    //TODO: Implement offline
    yield await openweatherSource.queryFor(location: location);
  }
}
