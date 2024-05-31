import 'package:bfsweather/fragments/settingsDrawer.dart';
import 'package:bfsweather/models/weatherLocationService.dart';
import 'package:bfsweather/routes/home/homeModel.dart';
import 'package:bfsweather/widgets/weatherPreview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeModel = ref.read(homeModelProvider.notifier);
    final homeState = ref.watch(homeModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("BFS Expert Weather"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ref.watch(weatherLocationServiceProvider).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error: $error'),
            data: (state) => switch (state.favorites) {
              [] => const Text(
                  "No favorites, and adding them is not supported currently, lol"),
              final list => RefreshIndicator(
                  onRefresh: homeModel.refresh,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: ListView(
                      children: list
                          .map((location) => WeatherPreview(
                                location: location,
                                onPressed: () =>
                                    homeModel.locationClicked(location),
                              ))
                          .toList(),
                    ),
                  ),
                ),
            },
          ),
      floatingActionButton: homeState.showUserPositionButton
          ? FloatingActionButton(
              onPressed: homeModel.activateMyLocation,
              child: const Icon(Icons.my_location_sharp),
            )
          : null,
      drawer: const SettingsDrawer(),
    );
  }
}
