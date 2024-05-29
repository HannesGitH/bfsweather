import 'package:freezed_annotation/freezed_annotation.dart';

part 'weatherData.freezed.dart';
part 'weatherData.g.dart';

@freezed
class WeatherData with _$WeatherData {
  const factory WeatherData({
    required num temp,
  }) = _WeatherData;

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);
}
