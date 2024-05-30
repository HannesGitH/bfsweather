import 'package:bfsweather/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await dotenv.load(
    fileName:
        ".env.${const String.fromEnvironment('ENV', defaultValue: 'dev')}",
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      theme: ThemeData(
        // i have not tuned the light theme that why we default to dark
        colorSchemeSeed: Colors.orange.shade800,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        // colorSchemeSeed: Colors.orange.shade800,
        colorSchemeSeed: Colors.purple,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
