import 'package:app_ble/features/connect/page.dart';
import 'package:app_ble/features/connect/provider.dart';
import 'package:app_ble/features/home/page.dart';
import 'package:app_ble/features/home/provider.dart';
import 'package:app_ble/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Map<String, Widget Function(BuildContext)> getAppRoutes() => {
      AppRoutes.home: (context) => ChangeNotifierProvider(
            create: (_) => HomeProvider(),
            builder: (__, ___) => HomePage(),
          ),
      AppRoutes.connect: (context) => ChangeNotifierProvider(
            create: (_) => ConnectProvider(),
            builder: (__, ___) => ConnectPage(),
          ),
    };
