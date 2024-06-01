import 'package:bfsweather/data/location/locationData.dart';

import 'weatherData.dart';
import 'sources/weatherCache.dart';
import 'sources/openweather.dart';

class WeatherRepository {
  final openweatherSource = Openweather();
  final _cache = WeatherCache();

  Stream<(WholeWeatherData, AdditionalWeatherInfo)> getFor(
      {required LocationData location}) async* {
    final cached = _cache.get(location);
    if (cached != null) {
      yield (cached, AdditionalWeatherInfo(isOfflineData: true));
      if (DateTime.now().difference(cached.current.timeStamp).inMinutes < 1) {
        // Don't refresh if the data is less than a minute old, it's probably still accurate and we can keep the API calls down
        yield (cached, AdditionalWeatherInfo());
        return;
      }
    }
    try {
      final fresh = await openweatherSource.queryFor(location: location);
      yield (fresh, AdditionalWeatherInfo());
      _cache.set(fresh, forLocation: location);
    } catch (e) {}
  }
}

class AdditionalWeatherInfo {
  final bool isOfflineData;

  AdditionalWeatherInfo({this.isOfflineData = false});
}
