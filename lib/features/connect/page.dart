import 'dart:async';

import 'package:app_ble/features/connect/provider.dart';
import 'package:app_ble/features/home/page.dart';
import 'package:app_ble/widgets/scan_result_tile_widget.dart';
import 'package:app_ble/widgets/system_device_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  late ConnectProvider provider;
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    provider = Provider.of<ConnectProvider>(context, listen: false);

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen(((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {});
      }
    }), onError: (e) {
      print("scan error $e");
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future onScanPressed() async {
    try {
      // `withServices` is required on iOS for privacy purposes, ignored on android.
      var withServices = [Guid("180f")]; // Battery Level Service
      _systemDevices = await FlutterBluePlus.systemDevices(withServices);
    } catch (e, backtrace) {
      print("System Devices Error: $e");
      print(e);
      print("backtrace: $backtrace");
    }
    try {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        webOptionalServices: [
          Guid("180f"), // battery
          Guid("1800"), // generic access
          Guid("6e400001-b5a3-f393-e0a9-e50e24dcca9e"), // Nordic UART
        ],
      );
    } catch (e, backtrace) {
      print("Start Scan Error: $e");
      print(e);
      print("backtrace: $backtrace");
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e, backtrace) {
      print("stop scan error $e");

      print(e);
      print("backtrace: $backtrace");
    }
  }

  void onConnectPressed(BluetoothDevice device) {
    device.connect().catchError((e) {
      print("connect error $e");
    });
    // MaterialPageRoute route = MaterialPageRoute(
    //     builder: (context) => DeviceScreen(device: device), settings: RouteSettings(name: '/DeviceScreen'));
    // Navigator.of(context).push(route);
  }

  Future onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(Duration(milliseconds: 500));
  }

  Widget buildScanButton(BuildContext context) {
    if (FlutterBluePlus.isScanningNow) {
      return FloatingActionButton(
        child: const Icon(Icons.stop),
        onPressed: onStopPressed,
        backgroundColor: Colors.red,
      );
    } else {
      return FloatingActionButton(child: const Text("SCAN"), onPressed: onScanPressed);
    }
  }

  List<Widget> _buildSystemDeviceTiles(BuildContext context) {
    return _systemDevices
        .map(
          (d) => SystemDeviceTile(
            device: d,
            onOpen: () => Navigator.of(context).push(
              MaterialPageRoute(
                //fix this
                builder: (context) => HomePage(),
                settings: RouteSettings(name: '/DeviceScreen'),
              ),
            ),
            onConnect: () => onConnectPressed(d),
          ),
        )
        .toList();
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _scanResults
        .map(
          (r) => ScanResultTile(
            result: r,
            onTap: () => onConnectPressed(r.device),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: Key('value'),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Find Devices'),
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            children: <Widget>[
              ..._buildSystemDeviceTiles(context),
              ..._buildScanResultTiles(context),
            ],
          ),
        ),
        floatingActionButton: buildScanButton(context),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(
  //         'Scan devices',
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () async {
  //         await provider.startScan();
  //       },
  //       child: Icon(Icons.refresh),
  //     ),
  //     body: SafeArea(
  //       child: Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: Column(
  //           children: [
  //             Expanded(
  //               child: ValueListenableBuilder(
  //                 valueListenable: provider.isScanning,
  //                 builder: (context, bool load, child) => load
  //                     ? Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Center(
  //                             child: LinearProgressIndicator(),
  //                           ),
  //                         ],
  //                       )
  //                     : ListView.builder(
  //                         itemCount: 3,
  //                         itemBuilder: (context, index) => Text('data $index'),
  //                       ),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
