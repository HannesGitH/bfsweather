import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/data/weather/weatherData.dart';
import 'package:flutter/material.dart';

class WeatherPreview extends StatelessWidget {
  const WeatherPreview({super.key, required this.location});

  final LocationData location;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(location.name),
          Text(location.weather?.current.description.main ?? 'loading..'),
        ],
      ),
    );
  }
}
