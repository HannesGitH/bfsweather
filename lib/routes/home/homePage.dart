import 'package:bfsweather/models/weatherLocations.dart';
import 'package:bfsweather/widgets/weatherPreview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BFS Weather"),
      ),
      body: ref.watch(weatherLocationServiceProvider).when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
            data: (state) => switch (state.favorites) {
              [] => const Text(
                  "No favorites, and adding them is not supported currently, lol"),
              final list => ListView(
                  children: list
                      .map((location) => WeatherPreview(location: location))
                      .toList(),
                ),
            },
          ),
    );
  }
}
