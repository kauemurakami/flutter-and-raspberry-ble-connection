import 'package:flutter/material.dart';

class NotFoundDevicesWidget extends StatelessWidget {
  const NotFoundDevicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text('Nenhum dispositivo encontrado'),
        )
      ],
    );
  }
}
