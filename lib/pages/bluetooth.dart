import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_bl/Db/Model/bluetooth_model.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Db/functions/blueooth_db.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();

    searchBluetoothDevices();
  }

  @override
  Widget build(BuildContext context) {
    getAllData();
    return _mainWidget();
  }

  //Widgets

  Widget _mainWidget() {
    return RefreshIndicator(
      onRefresh: () =>
          FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4)),
      child: ValueListenableBuilder(
          valueListenable: bluetoothModelNotifier,
          builder: (context, value, child) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Bluetooth Devices'),
              ),
              body: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(devices[index].name),
                    subtitle: Text(devices[index].id.toString()),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        connectToDevice(devices[index]);
                        // await devices[index].connect();
                        // log("conected");
                      },
                      child: const Text("Connect"),
                    ),
                    onTap: () async {
                      // value.clear();
                      log(value[index].name.toString());
                      addData(
                        BluetoothDeviceModel(
                          name: devices[index].name,
                          id: devices[index].id.toString(),
                        ),
                      );
                      
                    },
                  );
                },
              ),
            );
          }),
    );
  }

  // start scan
  searchBluetoothDevices() async {
    if (await Permission.bluetooth.request().isGranted) {
      flutterBlue.startScan(timeout: const Duration(seconds: 4));
      var subscription = flutterBlue.scanResults.listen((results) {
        for (ScanResult r in results) {
          print('${r.device.name} found! rssi: ${r.rssi}');
          setState(() {
            devices.add(r.device);
          });
        }
      });
    } else {
      // Request location permission
      await Permission.location.request();
    }
  }

  //connect device
  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      // Do something with the service
      log("${service.deviceId.toString()} device id");
    });
  }
}
