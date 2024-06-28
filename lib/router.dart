import 'package:bfsweather/data/location/locationData.dart';
import 'package:bfsweather/models/weatherLocationService.dart';
import 'package:bfsweather/routes/detailed/detailedPage.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'routes/home/homePage.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'coords',
            builder: (context, state) {
              final location =
                  LocationData.fromQueryParams(state.uri.queryParameters);
              ref
                  .read(weatherLocationServiceProvider.notifier)
                  .selectLocation(location);
              return DetailedPage();
            },
          ),
          // GoRoute(
          //   path: ':location',
          //   builder: (context, state) {
          //     final location = state.pathParameters['location'];
          //     return const DetailedPage();
          //   },
          // ),
        ],
      ),
    ],
  );
  return router;
}
