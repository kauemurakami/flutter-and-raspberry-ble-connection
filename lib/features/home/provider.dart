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
    BluetoothCharacteristic? targetCharacteristic;

    await device.connect();

    // Note: You must call discoverServices after every re-connection!
    List<BluetoothService> services = await device.discoverServices();

    for (BluetoothService service in services) {
      if (service.uuid.toString().toLowerCase() == BluetoothUUIDs.serviceUUID) {
        print("Serviço encontrado: ${service.uuid}");

        for (BluetoothCharacteristic c in service.characteristics) {
          if (c.uuid.toString().toLowerCase() == BluetoothUUIDs.characteristicUUID) {
            print("Característica encontrada: ${c.uuid}");
            targetCharacteristic = c; // Armazena a characteristic na variável
            break;
          }
        }
        if (targetCharacteristic != null) {
          break; // Sai do loop de serviços também
        }
      }

      // final subscription = targetCharacteristic!.onValueReceived.listen((value) async {
      //   List<int> value = await targetCharacteristic!.read();
      //   print("Valor inicial: ${String.fromCharCodes(value)}");
      //   temperature.value = String.fromCharCodes(value);
      //   notifyListeners();
      // });

      // device.cancelWhenDisconnected(subscription);

      // await targetCharacteristic.setNotifyValue(true);

      // List<BluetoothService> services = await device.discoverServices();
      // for (BluetoothService service in services) {
      //   print('service');
      //   print(service.serviceUuid);
      //   print(service.uuid);
      //   print('/service');

      //   // do something with service
      //   var characteristics = service.characteristics;
      //   for (BluetoothCharacteristic c in characteristics) {
      //     // print(c.characteristicUuid);

      //     if (c.properties.read) {
      //       List<int> value = await c.read();
      //       print(String.fromCharCodes(value));
      //     }
      //   }
    }
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
