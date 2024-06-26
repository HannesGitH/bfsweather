import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/data/location/sources/userPosition.dart';
import 'package:bfsweather/models/weatherLocationService.dart';
import 'package:bfsweather/router.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'homeModel.freezed.dart';
part 'homeModel.g.dart';

@riverpod
class HomeModel extends _$HomeModel {
  @override
  HomeState build() {
    _showUserPositionButton.then((value) => state = state.copyWith(
          showUserPositionButton: value,
        ));
    return const HomeState();
  }

  locationClicked(LocationData location) {
    final weatherLocations = ref.read(weatherLocationServiceProvider.notifier);
    weatherLocations.selectLocation(location);
    ref
        .read(routerProvider)
        .push('/coords?${location.toQueryStr()}')
        .then((_) => weatherLocations.deselect());
  }

  Future refresh() async {
    await ref.read(weatherLocationServiceProvider.notifier).refreshFavorites();
  }

  activateMyLocation() async {
    final perms = await Geolocator.checkPermission();
    if (!perms.allowed) {
      await Geolocator.requestPermission();
    }
    refresh();
  }

  Future<bool> get _showUserPositionButton async =>
      !(await Geolocator.checkPermission()).allowed;
}

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(true) bool showUserPositionButton,
  }) = _HomeState;
}
