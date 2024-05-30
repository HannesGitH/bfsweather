import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/models/weatherLocations.dart';
import 'package:bfsweather/router.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'homeModel.freezed.dart';
part 'homeModel.g.dart';

@riverpod
class HomeModel extends _$HomeModel {
  @override
  HomeState build() {
    return const HomeState();
  }

  locationClicked(LocationData location) {
    ref.read(weatherLocationServiceProvider.notifier).selectLocation(location);
    ref.read(routerProvider).go('/coords?${location.toQueryStr()}');
  }

  Future refresh() async {
    await ref.read(weatherLocationServiceProvider.notifier).refreshFavorites();
  }
}

@freezed
class HomeState with _$HomeState {
  const factory HomeState() = _HomeState;
}
