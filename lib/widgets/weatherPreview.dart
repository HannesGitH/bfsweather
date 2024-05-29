import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/data/weather/weatherData.dart';
import 'package:flutter/material.dart';

class WeatherPreview extends StatelessWidget {
  const WeatherPreview({super.key, required this.location, this.weather});

  final LocationData location;
  final WeatherData? weather;

  @override
  Widget build(BuildContext context) {
    return Text("Weather Preview");
  }
}
