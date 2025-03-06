import 'package:app_ble/features/home/provider.dart';
import 'package:app_ble/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeProvider provider;
  @override
  void initState() {
    provider = Provider.of<HomeProvider>(context, listen: false);
    provider.adapterStateStateSubscription = FlutterBluePlus.adapterState.listen(
      (BluetoothAdapterState state) {
        provider.changeAdapterState(state);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ValueListenableBuilder(
        valueListenable: provider.adapterState,
        builder: (context, state, child) => FloatingActionButton(
          onPressed: () async =>
              state == BluetoothAdapterState.on ? await Navigator.pushNamed(context, AppRoutes.connect) : null,
          child: Icon(
            Icons.bluetooth,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text('home')),
          ],
        ),
      ),
    );
  }
}
