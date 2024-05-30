import 'package:bfsweather/common/extensions/extensions.dart';
import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/data/weather/weatherData.dart';
import 'package:bfsweather/widgets/components/weather/humidity.dart';
import 'package:bfsweather/widgets/components/weather/temperature.dart';
import 'package:bfsweather/widgets/components/weather/wind.dart';
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
        Text(
          ((ts) =>
                  "${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}")(
              weather.timeStamp),
          style: Theme.of(context).textTheme.labelSmall,
        ),
        Wrap(
          // crossAxisAlignment: CrossAxisAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (dailyTemps != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Temperature(dailyTemps.max),
                  Temperature(dailyTemps.min),
                ],
              ),
            Temperature(
              weather.temp.temp,
              primary: true,
            ),
            if (!omitIcon) ...[
              Image(image: weather.description.iconProvider),
            ],
            HumiditySmall(humidity: weather.humidity),
            // if (today != null) ...[
            //   const SizedBox(width: 10),
            //   Text(today!.),
            // ],
            // // Theme(
            // //     data: Theme.of(context).copyWith(
            // //         iconTheme: Theme.of(context).iconTheme.copyWith(
            // //               size: 10,
            // //             )),
            // //     child:
            Wind(deg: weather.windDeg, speed: weather.windSpeed),
            // // ),
          ]
              .map((e) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: e,
                  ))
              .toList(),
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
