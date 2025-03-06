import 'dart:async';
import 'dart:io';

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

    // FlutterBluePlus.onScanResults.listen((results) {
    //   print('results');
    //   print(results.length);
    //   devices.value = results;
    //   devices.notifyListeners();
    // });

    // await FlutterBluePlus.startScan(timeout: Duration(seconds: 20)).whenComplete(() {});

    // print('devices.value.length');
    // print(devices.value.length);

    // await Future.delayed(Duration(seconds: 5));
    // FlutterBluePlus.stopScan();

    isScanning.value = false;
    notifyListeners();
  }

  Future<bool> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    return true;
  }
}
