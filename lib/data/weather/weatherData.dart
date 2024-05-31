// ignore_for_file: invalid_annotation_target

import 'package:bfsweather/common/parsers.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weatherData.freezed.dart';
part 'weatherData.g.dart';

@freezed
class WholeWeatherData with _$WholeWeatherData {
  const factory WholeWeatherData({
    required WeatherInstantData current,
    @JsonKey(name: 'minutely') List<MinuteRainData>? urgentRainForecast,
    required List<WeatherInstantData> hourly,
    required List<WeatherInstantData> daily,
  }) = _WholeWeatherData;

  factory WholeWeatherData.fromJson(Map<String, dynamic> json) =>
      _$WholeWeatherDataFromJson(json);
}

@freezed
class WeatherInstantData with _$WeatherInstantData {
  const factory WeatherInstantData({
    @JsonKey(name: 'dt') @TimeStampJsonConverter() required DateTime timeStamp,
    @TimeStampJsonConverter() int? sunrise,
    @TimeStampJsonConverter() int? sunset,
    required WeatherTempUnion temp,
    @JsonKey(name: 'feels_like') required WeatherTempFeltUnion feelsLike,
    required int pressure,
    required int humidity,
    @JsonKey(name: 'dew_point') required double dewPoint,
    required int uvi,
    required int clouds,
    int? visibility,
    @JsonKey(name: 'wind_speed') required double windSpeed,
    @JsonKey(name: 'wind_deg') required int windDeg,
    @JsonKey(name: 'weather')
    @TakeFirstWeatherDescriptionConverter()
    required WeatherDescription description,
    @JsonKey(name: 'pop') double? precipitationProbability,
    //rain and snow are missing for now
    // only on daily:
    String? summary,
    @TimeStampJsonConverter() DateTime? moonrise,
    @TimeStampJsonConverter() DateTime? moonset,
    @JsonKey(name: 'moon_phase') num? moonPhase,
  }) = _WeatherInstantData;

  factory WeatherInstantData.fromJson(Map<String, dynamic> json) =>
      _$WeatherInstantDataFromJson(json);
}

@freezed
class MinuteRainData with _$MinuteRainData {
  const factory MinuteRainData({
    @JsonKey(name: 'dt') @TimeStampJsonConverter() required DateTime timeStamp,
    required double precipitation,
  }) = _MinuteRainData;

  factory MinuteRainData.fromJson(Map<String, dynamic> json) =>
      _$MinuteRainDataFromJson(json);
}

@freezed
class WeatherDescription with _$WeatherDescription {
  const WeatherDescription._();
  const factory WeatherDescription({
    required String main,
    required String description,
    @JsonKey(name: 'icon') required String iconId,
  }) = _WeatherDescription;

  ImageProvider get iconProvider =>
      AssetImage('assets/icons/weather/$iconId.png');

  ImageProvider get iconProviderHD => AssetImage(
      'assets/icons/weather/4.0x/$iconId.png'); //this is not how variants should be used, ideally we also have a HD image to use for larger layouts

  factory WeatherDescription.fromJson(Map<String, dynamic> json) =>
      _$WeatherDescriptionFromJson(json);
}

@freezed
class WeatherDailyTemps with _$WeatherDailyTemps {
  const factory WeatherDailyTemps({
    required double day,
    required double min,
    required double max,
    required double night,
    required double eve,
    required double morn,
  }) = _WeatherDailyTemps;

  factory WeatherDailyTemps.fromJson(Map<String, dynamic> json) =>
      _$WeatherDailyTempsFromJson(json);
}

@freezed
class WeatherTempUnion with _$WeatherTempUnion {
  const WeatherTempUnion._();
  const factory WeatherTempUnion.daily(WeatherDailyTemps daily) = _Daily;
  const factory WeatherTempUnion.instant(num instant) = _Instant;

  num get temp => when(
        daily: (daily) => daily.day,
        instant: (instant) => instant,
      );

  factory WeatherTempUnion.fromJson(dynamic json) => json is num
      ? WeatherTempUnion.instant(json)
      : WeatherTempUnion.daily(
          WeatherDailyTemps.fromJson(json as Map<String, dynamic>));
}

@freezed
class WeatherDailyFeltTemps with _$WeatherDailyFeltTemps {
  const factory WeatherDailyFeltTemps({
    required double day,
    required double night,
    required double eve,
    required double morn,
  }) = _WeatherDailyFeltTemps;

  factory WeatherDailyFeltTemps.fromJson(Map<String, dynamic> json) =>
      _$WeatherDailyFeltTempsFromJson(json);
}

@freezed
class WeatherTempFeltUnion with _$WeatherTempFeltUnion {
  const WeatherTempFeltUnion._();
  const factory WeatherTempFeltUnion.dailyf(WeatherDailyFeltTemps daily) =
      _Dailyf;
  const factory WeatherTempFeltUnion.instantf(num instant) = _Instantf;

  get temp => when(
        dailyf: (daily) => daily.day,
        instantf: (instant) => instant,
      );

  factory WeatherTempFeltUnion.fromJson(dynamic json) => json is num
      ? WeatherTempFeltUnion.instantf(json)
      : WeatherTempFeltUnion.dailyf(
          WeatherDailyFeltTemps.fromJson(json as Map<String, dynamic>));
}

class TakeFirstWeatherDescriptionConverter
    extends TakeFirstJsonConverter<WeatherDescription, dynamic> {
  const TakeFirstWeatherDescriptionConverter()
      : super(
            fromJsonChild:
                // WeatherDescription.fromJson,
                _weatherDescriptionFromJson,
            toJsonChild: _weatherDescriptionToJson);
  // // extends JsonConverter<WeatherDescription, List<Map<String, dynamic>>> {
  // // const TakeFirstWeatherDescriptionConverter();
  // // @override
  // // WeatherDescription fromJson(json) {
  // //   return WeatherDescription.fromJson(json.first);
  // // }
  // // @override
  // // List<Map<String, dynamic>> toJson(object) {
  // //   return [object.toJson()];
  // // }
}

Map<String, dynamic> _weatherDescriptionToJson(WeatherDescription instance) =>
    instance.toJson();
WeatherDescription _weatherDescriptionFromJson(json) =>
    WeatherDescription.fromJson(json);
