// Web stub — all native-only functions are no-ops
import 'package:get/get.dart';

void nativeInit() {}

Future<void> initHiveNative() async {}

GetxController nativeDownloader() => _NoOpDownloader();

class _NoOpDownloader extends GetxController {}
