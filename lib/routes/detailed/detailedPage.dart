import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/models/weatherLocationService.dart';
import 'package:bfsweather/widgets/weatherPreview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailedPage extends ConsumerWidget {
  const DetailedPage({
    required LocationData location,
    super.key,
  }) : this.passedLocation = location;

  final LocationData passedLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LocationData location =
        switch (switch (ref.watch(weatherLocationServiceProvider)) {
      AsyncData(:final value) => switch (value.currentLocation) {
          null => null,
          final l => l,
        },
      _ => null,
    }) {
      null => ((l) {
          ref.read(weatherLocationServiceProvider.notifier).selectLocation(l);
          return l;
        })(passedLocation),
      final l => l,
    };
    return Scaffold(
        appBar: AppBar(
          title: Text(location.name ?? 'Unknown Location, WIP'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('WIP'),
              WeatherPreview(
                  location: location,
                  onPressed: () {
                    //only needed to not be disabled and allow scrolling hourly data
                  }),
            ],
          ),
        ));
  }
}
