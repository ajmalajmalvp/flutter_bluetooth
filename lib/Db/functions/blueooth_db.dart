import 'package:flutter/material.dart';
import 'package:flutter_application_bl/Db/Model/bluetooth_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:get/get.dart';

ValueNotifier<List<BluetoothDeviceModel>> bluetoothModelNotifier =
    ValueNotifier([]);

Future<void> addData(BluetoothDeviceModel value) async {
  final bluetoothModel =
      await Hive.openBox<BluetoothDeviceModel>("bluetooth_db");
  await bluetoothModel.add(value);
  bluetoothModelNotifier.value.add(value);
  bluetoothModelNotifier.notifyListeners();
}

Future<void> getAllData() async {
  final bluetoothDb = await Hive.openBox<BluetoothDeviceModel>("bluetooth_db");
  bluetoothModelNotifier.value.clear();
  bluetoothModelNotifier.value.addAll(bluetoothDb.values);
}
