import 'package:app_ble/routes/app_routes.dart';
import 'package:app_ble/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if your terminal doesn't support color you'll see annoying logs like `\x1B[1;35m`
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

// optional
  FlutterBluePlus.logs.listen((String s) {
    // send logs anywhere you want
    print(s);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App BLE connect with Raspbarry Pi Pico W',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoutes.home,
      routes: getAppRoutes(),
    );
  }
}
