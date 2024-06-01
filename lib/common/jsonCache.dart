import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Cache {
  static final Cache _instance = Cache._internal();
  factory Cache() => _instance;
  Cache._internal() {
    getApplicationDocumentsDirectory().then((dir) {
      cacheDir = Directory('${dir.path}/cache1')..create(recursive: true);
    });
  }
  late Directory cacheDir;

  final Map<String, dynamic> _cache = {};

  void set(String key, dynamic value, {bool persist = true}) {
    _cache[key] = value;
    if (persist) {
      File('${cacheDir.path}/$key')
          .create(recursive: true)
          .then((f) => f.writeAsString(value.toString()));
    }
  }

  T get<T>(String key) {
    final ret = _cache[key] ?? File('${cacheDir.path}/$key').readAsStringSync();
    _cache[key] = ret;
    try {
      return ret as T;
    } catch (e) {
      throw 'Cache value for key $key is not of type $T';
    }
  }

  List<String> get activeKeys => _cache.keys.toList();
  String get cachePath => cacheDir.path;
}

class JsonCache {
  static final JsonCache _instance = JsonCache._internal();
  factory JsonCache() => _instance;
  JsonCache._internal();

  final Cache _cache = Cache();

  void set(String key, dynamic value, {bool persist = true}) =>
      _cache.set('json/$key', jsonEncode(value), persist: persist);

  T get<T>(String key) => jsonDecode(_cache.get<String>('json/$key')) as T;

  String get cachePath => '${_cache.cachePath}/json';
  Directory get cacheDir => Directory(cachePath);

  List<String> get activeKeys => _cache.activeKeys
      .where((key) => key.startsWith('json/'))
      .map((key) => key.substring(5))
      .toList();

  List<String> keysIn(String relPath) => Directory('$cachePath/$relPath')
      .listSync()
      .whereType<File>()
      .map((file) => file.path.split('/').last)
      .toList();

  List<T> getAllIn<T>(String relPath) =>
      keysIn(relPath).map((key) => get<T>(key)).toList();
}
