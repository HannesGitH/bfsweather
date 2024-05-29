import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/data/location/locationRepository.dart';
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

    for (final location in favorites) {
      weatherRepository.getFor(location: location).then((weather) async {
        final prevState = (await future);
        final prevFavorites = [...prevState.favorites];
        prevFavorites.remove(location);
        prevFavorites.add(location.copyWith(weather: weather));
        state = AsyncData(prevState.copyWith(favorites: favorites));
      });
    }

    return WeatherLocationState(
      favorites: favorites,
    );
  }
}
