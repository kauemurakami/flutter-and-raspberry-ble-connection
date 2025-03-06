import 'package:app_ble/features/connect/provider.dart';
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
  void dispose() {
    provider.dispose();
    super.dispose();
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
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: LinearProgressIndicator(),
                            ),
                          ],
                        )
                      : ValueListenableBuilder(
                          valueListenable: provider.devices,
                          builder: (context, devices, child) => devices.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text('Nenhum dispositivo encontrado'),
                                    )
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: devices.length,
                                  itemBuilder: (context, index) => Text('data $index'),
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
