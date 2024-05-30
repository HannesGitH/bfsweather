part of 'extensions.dart';

extension ToHRStringDTExtension on DateTime {
  String toSmallHRString() => ((ts) =>
          "${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}")(
      this);
}
