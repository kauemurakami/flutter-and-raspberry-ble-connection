import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class HomeProvider extends ChangeNotifier {
  final ValueNotifier<String> temperature = ValueNotifier("0");
  ValueNotifier<BluetoothAdapterState> adapterState = ValueNotifier(BluetoothAdapterState.unknown);
  late StreamSubscription<BluetoothAdapterState> adapterStateStateSubscription;

  readTemperature() {}

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
