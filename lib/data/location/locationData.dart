// ignore_for_file: invalid_annotation_target

import 'package:bfsweather/data/weather/weatherData.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'locationData.freezed.dart';
part 'locationData.g.dart';

const latKey = 'lat';
const lngKey = 'lon';

@freezed
class LocationData with _$LocationData {
  const LocationData._();

  const factory LocationData({
    String? name,
    @JsonKey(name: latKey) required num lat,
    @JsonKey(name: lngKey) required num lng,
    @JsonKey(includeFromJson: false) @Default(false) bool isLoading,
    // @JsonKey(fromJson: WholeWeatherData.fromJson, toJson: WholeWeatherData.toJson)
    WholeWeatherData? weather,
  }) = _LocationData;

  isSameAs(Object other) {
    if (other is LocationData) {
      return other.lat == lat && other.lng == lng;
    }
    return false;
  }

  bool isNearEnoughToProbablyBeTheSame(LocationData other,
      {double tolerance = 0.05}) {
    return (lat - other.lat).abs() < tolerance &&
        (lng - other.lng).abs() < tolerance;
  }

  toQueryStr() => '$latKey=$lat&$lngKey=$lng';

  factory LocationData.fromQueryParams(Map<String, dynamic> dict) =>
      LocationData(
          lat: double.parse(dict[latKey]), lng: double.parse(dict[lngKey]));

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);
}
