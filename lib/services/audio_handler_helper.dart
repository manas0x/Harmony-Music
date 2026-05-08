// ignore_for_file: constant_identifier_names
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';

// Native-only imports moved here or handled via conditional imports in helper
import 'audio_handler_io_stub.dart'
    if (dart.library.io) 'audio_handler_io.dart';

void initNativeAudioConfig(dynamic player) {
  if (!kIsWeb) {
    nativeAudioConfig(player);
  }
}

Future<String?> getCacheDirPath() async {
  if (kIsWeb) return null;
  return await nativeCacheDir();
}

void createDir(String path) {
  if (!kIsWeb) {
    nativeCreateDir(path);
  }
}

bool dirExists(String path) {
  if (kIsWeb) return false;
  return nativeDirExists(path);
}

bool fileExists(String path) {
  if (kIsWeb) return false;
  return nativeFileExists(path);
}

String getFileUri(String path) {
  if (kIsWeb) return path;
  return "file://$path";
}

dynamic dynamicNativeFile(String path) {
  if (kIsWeb) return null;
  return nativeFile(path);
}

