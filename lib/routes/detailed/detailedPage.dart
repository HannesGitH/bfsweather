import 'dart:ui';

import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/data/weather/weatherData.dart';
import 'package:bfsweather/models/weatherLocationService.dart';
import 'package:bfsweather/widgets/weatherPreview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailedPage extends ConsumerWidget {
  const DetailedPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherLocationService =
        ref.read(weatherLocationServiceProvider.notifier);

    final LocationData? location =
        (switch (ref.watch(weatherLocationServiceProvider)) {
      AsyncData(:final value) => value.currentLocation,
      _ => null,
    });
    return Scaffold(
        appBar: AppBar(
          title: Hero(
              tag: location.hashCode,
              child: Material(
                  textStyle: Theme.of(context).textTheme.headlineSmall,
                  child: Text(location?.name ?? 'Unknown Location ..'))),
        ),
        body: Center(
          child: RefreshIndicator(
            onRefresh: weatherLocationService.refreshCurrent,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: ListView(
                children: [
                  const Text('WIP'),
                  HeroMode(
                    enabled: false,
                    child: location != null
                        ? WeatherPreview(
                            location: location,
                            // onPressed: () {
                            //   //only needed to not be disabled and allow scrolling hourly data
                            // },
                          )
                        : const CircularProgressIndicator(),
                  ),
                  ...switch (location?.weather) {
                    null => [],
                    WholeWeatherData w => [
                        _label("2 Day Hourly Forecast"),
                        HourlyWeatherPreview(w.hourly),
                      ],
                  }
                ],
              ),
            ),
          ),
        ));
  }

  Widget _label(label) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(label),
      );
}
