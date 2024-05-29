// ignore_for_file: invalid_annotation_target

import 'package:bfsweather/data/weather/weatherData.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'locationData.freezed.dart';
part 'locationData.g.dart';

const latKey = 'lat';
const lngKey = 'lon';

@freezed
class LocationData with _$LocationData {
  const factory LocationData({
    required String name,
    @JsonKey(name: latKey) required num lat,
    @JsonKey(name: lngKey) required num lng,
    // @JsonKey(fromJson: WholeWeatherData.fromJson, toJson: WholeWeatherData.toJson)
    WholeWeatherData? weather,
  }) = _LocationData;

  factory LocationData.fromQueryParams(Map<String, dynamic> dict) =>
      LocationData.fromJson(dict);

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);
}
