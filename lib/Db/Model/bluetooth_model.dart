import 'package:hive/hive.dart';
part 'bluetooth_model.g.dart';

@HiveType(typeId: 1)
class BluetoothDeviceModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String id;

  BluetoothDeviceModel({required this.name, required this.id});
}
