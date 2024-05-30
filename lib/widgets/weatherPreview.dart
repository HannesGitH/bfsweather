import 'package:bfsweather/common/extensions/extensions.dart';
import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/data/weather/weatherData.dart';
import 'package:bfsweather/widgets/components/weather/temperature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeatherPreview extends StatelessWidget {
  const WeatherPreview({super.key, required this.location, this.onPressed});

  final LocationData location;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 8.0, right: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          // surfaceTintColor: location.weather
          //     .nnThen((x) => temperatureColor(x.current.temp.temp)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        location.name ?? '${location.lat}, ${location.lng}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (location.isLoading)
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Opacity(
                              opacity: 0.2,
                              child: SizedBox(
                                height: 10,
                                child: LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(10),
                                  backgroundColor: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  ...switch (location.weather) {
                    null => [], //[const CircularProgressIndicator()],
                    final weather => [
                        WeatherInstantPreview(
                          weather.current,
                          today: weather.daily.firstOrNull,
                          omitIcon: true,
                        ),
                      ],
                  },
                ],
              ),
            ),
            if (location.weather != null)
              Image(
                image: location.weather!.current.description.iconProviderHD,
                height: 80,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}

class WeatherInstantPreview extends StatelessWidget {
  const WeatherInstantPreview(this.weather,
      {super.key, this.omitIcon = false, this.today});

  final WeatherInstantData weather;
  final WeatherInstantData? today;
  final bool omitIcon;

  @override
  Widget build(BuildContext context) {
    final dailyTemps = today?.temp.when(daily: (d) => d, instant: (i) => null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (dailyTemps != null) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Temperature(dailyTemps.max),
                  Temperature(dailyTemps.min),
                ],
              ),
              const SizedBox(width: 10),
            ],
            Temperature(
              weather.temp.temp,
              primary: true,
            ),
            if (!omitIcon) ...[
              const SizedBox(width: 10),
              Image(image: weather.description.iconProvider),
            ],
            const SizedBox(width: 10),
            SizedBox(
              height: 40,
              width: 10,
              child: RotatedBox(
                quarterTurns: 3,
                child: LinearProgressIndicator(
                  value: weather.humidity / 100,
                  borderRadius: BorderRadius.circular(10),
                  valueColor: const AlwaysStoppedAnimation(Colors.blue),
                ),
              ),
            )
            // if (today != null) ...[
            //   const SizedBox(width: 10),
            //   Text(today!.),
            // ],
          ],
        ),
      ],
    );
  }
}

class HourlyWeatherPreview extends StatelessWidget {
  const HourlyWeatherPreview(this.weather, {super.key});

  final WeatherInstantData weather;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Now", style: Theme.of(context).textTheme.labelMedium),
        Row(
          children: [
            Image(
              image: weather.description.iconProvider,
            ),
            Temperature(weather.temp.temp),
            Text(weather.summary.toString())
          ],
        ),
      ],
    );
  }
}
