import 'package:bfsweather/common/extensions/extensions.dart';
import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/data/weather/weatherData.dart';
import 'package:bfsweather/data/weather/weatherRepository.dart';
import 'package:bfsweather/widgets/components/weather/humidity.dart';
import 'package:bfsweather/widgets/components/weather/rain.dart';
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          title(context),
                          if (location.isLoading) loader(),
                        ],
                      ),
                      ...switch (location.weather) {
                        null => [
                            const Text("No weather data available, loading..."),
                          ], //[const CircularProgressIndicator()],
                        final weather => [
                            WeatherInstantPreview(
                              weather.current,
                              weatherMeta: location.meta?.weatherMeta,
                              today: weather.daily.firstOrNull,
                              omitIcon: true,
                            ),
                          ],
                      },
                    ],
                  ),
                ),
                if (location.weather != null) ...[
                  if (location.weather?.urgentRainForecast != null) ...[
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: SizedBox(
                        height: 50,
                        // width: 100,
                        child: UrgentRainForecast(
                            precipitationData:
                                location.weather!.urgentRainForecast!.thin(4)),
                      ),
                    ),
                  ],
                  Image(
                    image: location.weather!.current.description.iconProviderHD,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ]
              ],
            ),
            if (location.weather != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  child: HourlyWeatherPreview(location.weather!.hourly),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Text title(BuildContext context) {
    return Text(
      location.name ?? '${location.lat}, ${location.lng}',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Expanded loader() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
    );
  }
}

class WeatherInstantPreview extends StatelessWidget {
  const WeatherInstantPreview(this.weather,
      {super.key, this.omitIcon = false, this.today, this.weatherMeta});

  final WeatherInstantData weather;
  final WeatherInstantData? today;
  final bool omitIcon;
  final AdditionalWeatherInfo? weatherMeta;

  @override
  Widget build(BuildContext context) {
    final dailyTemps = today?.temp.when(daily: (d) => d, instant: (i) => null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              weather.timeStamp.toSmallHRString(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            if (weatherMeta?.isOfflineData == true) ...[
              const SizedBox(width: 10),
              const Icon(
                Icons.cloud_off_outlined,
                size: 15,
              ),
            ],
          ],
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
                    padding: const EdgeInsets.only(right: 15.0),
                    child: e,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class HourlyWeatherPreview extends StatelessWidget {
  const HourlyWeatherPreview(this.foreCast, {super.key});

  final List<WeatherInstantData> foreCast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: foreCast
            .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Temperature(e.temp.temp),
                      Image(image: e.description.iconProvider),
                      Text(
                        e.timeStamp.toSmallHRString(),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
