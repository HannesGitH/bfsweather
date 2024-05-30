import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/data/location/locationRepository.dart';
import 'package:bfsweather/data/weather/weatherData.dart';
import 'package:bfsweather/data/weather/weatherRepository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weatherLocations.freezed.dart';
part 'weatherLocations.g.dart';

@freezed
class WeatherLocationState with _$WeatherLocationState {
  const factory WeatherLocationState({
    @Default([]) List<LocationData> favorites,
    List<LocationData>? searchResults,
    String? currentSearch,
    LocationData? currentLocation,
  }) = _WeatherLocationState;
}

@riverpod
class WeatherLocationService extends _$WeatherLocationService {
  final locationRepository = LocationRepository();
  final weatherRepository = WeatherRepository();

  @override
  FutureOr<WeatherLocationState> build() async {
    //XXX: favorites isn't implemented rn, but it will be the hardcoded locations for now

    final favorites = await locationRepository.getFavorites();

    _loadWeatherForFavorites();

    return WeatherLocationState(
      favorites: favorites,
    );
  }

  _loadWeatherForFavorites() async {
    final favorites = (await future).favorites;
    for (final location in favorites) {
      final weatherS = weatherRepository.getFor(location: location);
      await for (final weather in weatherS) {
        // in case the state/favorites have changed since the request was made
        final prevState = (await future);
        final prevFavorites = [...prevState.favorites];
        final indexToReplace = prevFavorites.indexOf(location);
        prevFavorites[indexToReplace] = location.copyWith(weather: weather);
        state = AsyncData(prevState.copyWith(favorites: prevFavorites));
      }
    }
  }
}
