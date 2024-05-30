part of 'extensions.dart';

extension NullableThenExtension<T extends Object> on T? {
  R? nnThen<R>(R Function(T) callback) => this != null ? callback(this!) : null;
}
