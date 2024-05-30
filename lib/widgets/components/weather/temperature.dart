import 'package:bfsweather/common/options.dart';
import 'package:flutter/material.dart';

class Temperature extends StatelessWidget {
  const Temperature(
    this.temperature, {
    super.key,
    this.primary = false,
    this.color,
    this.showUnit = true,
    this.autoColor = true,
  }) : assert(color == null || !autoColor,
            "Cannot provide both color and autoColor");

  final double temperature;
  final bool primary;
  final Color? color;
  final bool showUnit;
  final bool autoColor;

  @override
  Widget build(BuildContext context) {
    final color =
        this.color ?? (autoColor ? temperatureColor(temperature) : null);
    return RichText(
      text: TextSpan(
        text: temperature.toStringAsFixed(0),
        style: (primary
                ? Theme.of(context).textTheme.displayLarge
                : Theme.of(context).textTheme.bodyLarge)
            ?.copyWith(color: color),
        children: [
          TextSpan(
            text: '.${temperature.toStringAsFixed(1).split('.').last}',
            style: (primary
                    ? Theme.of(context).textTheme.bodyLarge
                    : Theme.of(context).textTheme.bodySmall)
                ?.copyWith(color: color),
          ),
          // WidgetSpan(
          //   child: Transform.translate(
          //     offset: const Offset(0, -5),
          //     child: Text(
          //       "°",
          //       style: primary
          //           ? Theme.of(context).textTheme.displaySmall
          //           : Theme.of(context).textTheme.bodySmall,
          //     ),
          //   ),
          // ),
          TextSpan(
            text: Options().unit.tempSymbol,
            style: (primary
                    ? Theme.of(context).textTheme.titleLarge
                    : Theme.of(context).textTheme.titleSmall)
                ?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

Color temperatureColor(double temperature) {
  final min = Options().unit.tempMin;
  final max = Options().unit.tempMax;
  final mid = (min + max) / 2;
  const midColor = Colors.white;
  const minColor = Colors.blue;
  const maxColor = Colors.red;

  if (temperature < min) {
    return minColor;
  } else if (temperature > max) {
    return maxColor;
  } else if (temperature < mid) {
    return Color.lerp(minColor, midColor, temperature / mid)!;
  } else {
    return Color.lerp(midColor, maxColor, (temperature - mid) / mid)!;
  }
}
