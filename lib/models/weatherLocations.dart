import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/data/location/locationRepository.dart';
import 'package:bfsweather/data/weather/weatherData.dart';
import 'package:bfsweather/data/weather/weatherRepository.dart';
import 'package:bfsweather/router.dart';
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

  selectLocation(LocationData location) async {
    state = AsyncData((await future).copyWith(currentLocation: location));
  }

  _loadWeatherForFavorites() async {
    final favorites = (await future).favorites;
    for (final location in favorites) {
      await _replaceLocation(location, location.copyWith(isLoading: true));
      final weatherS = weatherRepository.getFor(location: location);
      var newLocation = location;
      await for (final weather in weatherS) {
        newLocation = newLocation.copyWith(weather: weather);
        await _replaceLocation(location, newLocation);
      }
      await _replaceLocation(location, newLocation.copyWith(isLoading: false));
    }
  }

  _replaceLocation(LocationData oldLocation, LocationData newLocation) async {
    final prevState = (await future);
    final prevFavorites = [...prevState.favorites];
    final indexToReplace =
        prevFavorites.indexWhere((element) => element.isSameAs(oldLocation));
    // if (indexToReplace == -1) return;
    prevFavorites[indexToReplace] = newLocation;
    state = AsyncData(prevState.copyWith(favorites: prevFavorites));
  }

  Future refreshFavorites() => _loadWeatherForFavorites();
}
