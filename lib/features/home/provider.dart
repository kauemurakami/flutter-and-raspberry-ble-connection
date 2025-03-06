import 'dart:async';

import 'package:app_ble/core/constants/bluetooth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class HomeProvider extends ChangeNotifier {
  final ValueNotifier<String> temperature = ValueNotifier("0");
  ValueNotifier<BluetoothAdapterState> adapterState = ValueNotifier(BluetoothAdapterState.unknown);
  late StreamSubscription<BluetoothAdapterState> adapterStateStateSubscription;
  late StreamSubscription characteristicSubscription;
  // late Stream<List<int>> streamCharacteristic;
  // ValueNotifier<bool> initializeCStream = ValueNotifier(true);
  readTemperature() {}

  connectDevice(BluetoothDevice device) async {
    await device.connect();

    List<BluetoothService> services = await device.discoverServices();
    BluetoothService service = services.firstWhere((BluetoothService s) {
      return s.uuid == Guid(BluetoothUUIDs.serviceUUID);
    });

    BluetoothCharacteristic characteristic = service.characteristics.firstWhere((c) {
      return c.uuid == Guid(BluetoothUUIDs.characteristicUUID);
    });

    await characteristic.setNotifyValue(true);

    characteristicSubscription = characteristic.onValueReceived.listen((value) {
      if (value.isNotEmpty) {
        String tempString = String.fromCharCodes(value); // Converte para String
        print("Temperatura recebida: $tempString");
        // Atualiza a variável `temperature`
        temperature.value = tempString;
        notifyListeners();
      }
    });
  }

  changeAdapterState(BluetoothAdapterState state) {
    adapterState.value = state;
    notifyListeners();
  }

  @override
  void dispose() {
    characteristicSubscription.cancel();
    adapterStateStateSubscription.cancel();
    super.dispose();
  }
}
