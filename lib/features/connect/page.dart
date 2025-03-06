import 'package:app_ble/features/connect/provider.dart';
import 'package:app_ble/features/connect/widgets/device_item.dart';
import 'package:app_ble/features/connect/widgets/not_found_devices.dart';
import 'package:app_ble/widgets/linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  late ConnectProvider provider;

  @override
  void initState() {
    super.initState();

    provider = Provider.of<ConnectProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan devices',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await provider.startScan();
        },
        child: Icon(Icons.refresh),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: provider.isScanning,
                  builder: (context, bool load, child) => load
                      ? LoadingWidget()
                      : ValueListenableBuilder(
                          valueListenable: provider.devices,
                          builder: (context, devices, child) => devices.isEmpty
                              ? NotFoundDevicesWidget()
                              : ListView.builder(
                                  itemCount: devices.length,
                                  itemBuilder: (context, index) => DeviceItemWidget(
                                    device: devices[index],
                                  ),
                                ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
