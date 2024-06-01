import 'package:freezed_annotation/freezed_annotation.dart';

class TimeStampJsonConverter extends JsonConverter<DateTime, int> {
  const TimeStampJsonConverter();

  @override
  DateTime fromJson(int json) {
    return DateTime.fromMillisecondsSinceEpoch(json * 1000);
  }

  @override
  int toJson(DateTime object) {
    return object.millisecondsSinceEpoch ~/ 1000;
  }
}

class TakeFirstJsonConverter<T, JSON> extends JsonConverter<T, List<JSON>> {
  const TakeFirstJsonConverter(
      {required this.fromJsonChild, required this.toJsonChild});
  final T Function(JSON) fromJsonChild;
  final JSON Function(T) toJsonChild;

  @override
  T fromJson(List json) {
    return fromJsonChild(json.first);
  }

  @override
  List<JSON> toJson(T object) {
    return [toJsonChild(object)];
  }
}
