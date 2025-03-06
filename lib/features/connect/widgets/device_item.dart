import 'package:app_ble/features/connect/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

class DeviceItemWidget extends StatelessWidget {
  const DeviceItemWidget({super.key, required this.device});
  final ScanResult device;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final success = await context.read<ConnectProvider>().connectToDevice(device.device);
        if (success) {
          if (context.mounted) {
            Navigator.pop(context, device.device);
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao se conectar'),
              ),
            );
          }
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(device.device.advName),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'conectar',
                        style: TextStyle(fontSize: 13.0, color: Colors.purple),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
