import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectProvider extends ChangeNotifier {
  final ValueNotifier<List<ScanResult>> devices = ValueNotifier([]);
  ValueNotifier<bool> isScanning = ValueNotifier(false);

  Future<void> startScan() async {
    isScanning.value = true;
    devices.value.clear();
    devices.notifyListeners();
    notifyListeners();

    await FlutterBluePlus.startScan(timeout: Duration(seconds: 20));

    // Stream para capturar os dispositivos encontrados
    final subscription = FlutterBluePlus.onScanResults.listen((results) {
      if (results.isNotEmpty) {
        devices.value = results;
        devices.notifyListeners();
        print("Dispositivos encontrados: ${devices.value.length}");
      }
    });

    await Future.delayed(Duration(seconds: 5));
    await FlutterBluePlus.stopScan();
    // FlutterBluePlus.cancelWhenScanComplete(subscription);
    await subscription.cancel();
    isScanning.value = false;
    notifyListeners();
  }

  Future<bool> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    return true;
  }
}
