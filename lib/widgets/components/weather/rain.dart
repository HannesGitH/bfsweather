import 'package:bfsweather/data/weather/weatherData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UrgentRainForecast extends StatelessWidget {
  const UrgentRainForecast({super.key, required this.precipitationData});

  final List<MinuteRainData> precipitationData;

  @override
  Widget build(BuildContext context) {
    if (precipitationData.isEmpty ||
        precipitationData.every((element) => element.precipitation == 0)) {
      return Container();
    }
    return StreamBuilder(
        stream:
            Stream.periodic(const Duration(seconds: 5), (_) => DateTime.now()),
        builder: (context, snapshot) {
          final DateTime now = snapshot.data ?? DateTime.now();
          return LineChart(
            LineChartData(
              extraLinesData: ExtraLinesData(
                verticalLines: [
                  VerticalLine(
                    x: now.millisecondsSinceEpoch
                        .toDouble(), // Specify the x-value where you want the vertical bar
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                    strokeWidth: 2, // Thickness of the vertical line/bar
                  ),
                ],
              ),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: precipitationData
                      .asMap()
                      .entries
                      .map((e) => FlSpot(
                          e.value.timeStamp.millisecondsSinceEpoch.toDouble(),
                          e.value.precipitation))
                      .toList(),
                  isCurved: true,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  shadow: const Shadow(
                    color: Colors.blue,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
