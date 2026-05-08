// Native implementation — only compiled on non-web targets
import 'package:path_provider/path_provider.dart';
import 'package:terminate_restart/terminate_restart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/services/downloader.dart';

void nativeInit() {
  TerminateRestart.instance.initialize();
}

Future<void> initHiveNative() async {
  String path;
  if (GetPlatform.isDesktop) {
    path = "${(await getApplicationSupportDirectory()).path}/db";
  } else {
    path = (await getApplicationDocumentsDirectory()).path;
  }
  await Hive.initFlutter(path);
}

GetxController nativeDownloader() => Downloader();
