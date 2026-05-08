import 'dart:io';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

void nativeAudioConfig(dynamic player) {
  if (GetPlatform.isWindows || GetPlatform.isLinux) {
    JustAudioMediaKit.title = 'Harmony music';
    JustAudioMediaKit.protocolWhitelist = const ['http', 'https', 'file'];
  }
}

Future<String> nativeCacheDir() async {
  return (await getTemporaryDirectory()).path;
}

void nativeCreateDir(String path) {
  Directory(path).createSync(recursive: true);
}

bool nativeDirExists(String path) {
  return Directory(path).existsSync();
}

bool nativeFileExists(String path) {
  return File(path).existsSync();
}

File nativeFile(String path) {
  return File(path);
}

