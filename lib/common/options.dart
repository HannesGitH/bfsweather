/// These would normally be settable by the user in a seTtings view and persisted, but not in an MVP
class Options {
  static Options _instance = Options._internal();
  factory Options() => _instance;
  Options._internal() {}

  final unit = Unit.metric;
}

enum Unit {
  metric,
  imperial,
}

extension UnitExtension on Unit {
  String get openweatherName => switch (this) {
        Unit.metric => 'metric',
        Unit.imperial => 'imperial',
      };
}
