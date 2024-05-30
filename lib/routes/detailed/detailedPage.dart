import 'package:bfsweather/data/location/locationData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailedPage extends ConsumerWidget {
  const DetailedPage({
    required this.location,
    super.key,
  });

  final LocationData location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text(location.name ?? 'Unknown Location, WIP'),
        ),
        body: const Center(
          child: Text('WIP'),
        ));
  }
}
