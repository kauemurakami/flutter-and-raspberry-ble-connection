import 'dart:async';

import 'package:app_ble/core/constants/bluetooth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class HomeProvider extends ChangeNotifier {
  final ValueNotifier<String> temperature = ValueNotifier("0");
  ValueNotifier<BluetoothAdapterState> adapterState = ValueNotifier(BluetoothAdapterState.unknown);
  late StreamSubscription<BluetoothAdapterState> adapterStateStateSubscription;

  readTemperature() {}

  connectDevice(BluetoothDevice device) async {
    await device.connect();

    // Note: You must call discoverServices after every re-connection!
    List<BluetoothService> services = await device.discoverServices();
    BluetoothService service = services.firstWhere((BluetoothService s) {
      print('service');
      print(s.uuid);
      print(Guid(BluetoothUUIDs.serviceUUID));
      print('/service');

      return s.uuid == Guid(BluetoothUUIDs.serviceUUID);
    });

    BluetoothCharacteristic characteristic = service.characteristics.firstWhere((c) {
      print('characteristic');
      print(c.uuid);
      print(Guid(BluetoothUUIDs.characteristicUUID));
      print('/characteristic');

      return c.uuid == Guid(BluetoothUUIDs.characteristicUUID);
    });
    // var v = await characteristic.read();
    // print(String.fromCharCodes(v));
    await characteristic.setNotifyValue(true);

    List<int> v = await characteristic.read();
    print(String.fromCharCodes(v));

    characteristic.onValueReceived.listen((value) {
      if (value.isNotEmpty) {
        String tempString = String.fromCharCodes(value); // Converte para String
        print("Temperatura recebida: $tempString");

        // Atualiza a variável `temperature`
        temperature.value = tempString;
        notifyListeners();
      }
    });

    // final subscription = characteristic.onValueReceived.listen((value) async {
    //   List<int> value = await characteristic.read();
    //   print("Valor inicial: ${String.fromCharCodes(value)}");
    //   temperature.value = String.fromCharCodes(value);
    //   notifyListeners();
    // });
    // device.cancelWhenDisconnected(subscription);
  }

  changeAdapterState(BluetoothAdapterState state) {
    adapterState.value = state;
    notifyListeners();
  }

  @override
  void dispose() {
    adapterStateStateSubscription.cancel();
    super.dispose();
  }
}
