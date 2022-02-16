import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends StatelessWidget {
  final Function onTap;
  final BluetoothDevice device;

  BluetoothDeviceListEntry({this.onTap, @required this.device});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(Icons.bluetooth),
      title: Text(device.name ?? "Dispositivo indisponível"),
      subtitle: Text(device.address.toString()),
      trailing: ElevatedButton(
        child: Text('CONECTAR'),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(primary: Color(0xFF4D7DB4)),
      ),
    );
  }
}