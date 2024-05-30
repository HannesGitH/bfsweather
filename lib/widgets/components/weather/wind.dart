import 'package:flutter/material.dart';

class Wind extends StatelessWidget {
  const Wind({super.key, required this.deg, required this.speed});

  final int deg;
  final double speed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform.rotate(
          angle: deg * (3.14 / 180),
          child: const Icon(
            Icons.navigation,
          ),
        ),
        Text(
          "${speed.toStringAsFixed(1)} m/s",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
