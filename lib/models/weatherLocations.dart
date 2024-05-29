import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/data/location/locationRepository.dart';
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

  @override
  FutureOr<WeatherLocationState> build() async {
    //XXX: favorites isn't implemented rn, but it will be the hardcoded locations for now
    return WeatherLocationState(
      favorites: await locationRepository.getFavorites(),
    );
  }
}
