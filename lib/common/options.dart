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

extension UnitNameExtension on Unit {
  String get openweatherName => switch (this) {
        Unit.metric => 'metric',
        Unit.imperial => 'imperial',
      };
}

extension UnitSymbolExtension on Unit {
  String get tempSymbol => switch (this) {
        Unit.metric => '°C',
        Unit.imperial => '°F',
      };
}

extension UnitMinMaxExtension on Unit {
  double get tempMin => switch (this) {
        Unit.metric => -15.0,
        Unit.imperial => 5.0,
      };

  double get tempMax => switch (this) {
        Unit.metric => 50.0,
        Unit.imperial => 120.0,
      };
}
