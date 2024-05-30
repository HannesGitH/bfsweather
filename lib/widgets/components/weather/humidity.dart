import 'package:flutter/material.dart';

class HumiditySmall extends StatelessWidget {
  const HumiditySmall({
    super.key,
    required this.humidity,
  });

  final int humidity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 30,
      child: RotatedBox(
        quarterTurns: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: humidity / 100,
                borderRadius: BorderRadius.circular(10),
                valueColor: const AlwaysStoppedAnimation(Colors.blue),
              ),
            ),
            Text(
              "$humidity%",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
