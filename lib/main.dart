import 'package:flutter/material.dart';
import 'package:flutter_application_bl/Db/Model/bluetooth_model.dart';
import 'package:flutter_application_bl/pages/bluetooth.dart';
import 'package:flutter_application_bl/pages/offed_bluetooth.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hive_flutter/hive_flutter.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(BluetoothDeviceModelAdapter().typeId)) {
    Hive.registerAdapter(BluetoothDeviceModelAdapter());
  }
  await Hive.openBox<BluetoothDeviceModel>('settings');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return const DeviceScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}
