part of 'extensions.dart';

extension ThinningExtension on List {
  List<T> thin<T>(int thinning) {
    if (thinning <= 1) {
      return this.cast<T>();
    }
    final result = <T>[];
    for (var i = 0; i < length; i += thinning) {
      result.add(this[i] as T);
    }
    return result;
  }
}
