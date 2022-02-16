import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:ausculta/device.dart';

//contém estado
class SelectBondedDevicePage extends StatefulWidget {
  // Se verdadeiro, no início da página, é realizada a descoberta dos dispositivos vinculados.
  // Então, se não estiverem disponíveis, serão desabilitados da seleção.

  final bool checkAvailability;
  final Function onCahtPage;

  const SelectBondedDevicePage(
      {this.checkAvailability = true, @required this.onCahtPage});

  @override
  _SelectBondedDevicePage createState() =>  _SelectBondedDevicePage();
}

enum _DeviceAvailability {
  no,
  maybe,
  yes,
}

class _DeviceWithAvailability extends BluetoothDevice {
  BluetoothDevice device;
  _DeviceAvailability availability;
  int rssi;

  _DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}

class _SelectBondedDevicePage extends State<SelectBondedDevicePage> {
  List<_DeviceWithAvailability> devices = <_DeviceWithAvailability>[];

  // Disponibilidade
  StreamSubscription<BluetoothDiscoveryResult> _discoveryStreamSubscription;
  bool _isDiscovering;

  _SelectBondedDevicePage();

  @override
  void initState() {
    super.initState();

    _isDiscovering = widget.checkAvailability;

    if (_isDiscovering) {
      _startDiscovery();
    }

    // Configure uma lista dos dispositivos vinculados
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices
            .map(
              (device) => _DeviceWithAvailability(
            device,
            widget.checkAvailability
                ? _DeviceAvailability.maybe
                : _DeviceAvailability.yes,
          ),
        )
            .toList();
      });
    });
  }

  void _startDiscovery() {
    print("Início da descoberta de dispositivos!");
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
          setState(() {
            Iterator i = devices.iterator;
            while (i.moveNext()) {
              var _device = i.current;
              if (_device.device == r.device) {
                _device.availability = _DeviceAvailability.yes;
                _device.rssi = r.rssi;
              }
            }
          });
        });

  void _restartDiscovery() {
    setState(() {
      _isDiscovering = true;
    });

    _startDiscovery();
  }


    _discoveryStreamSubscription.onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _discoveryStreamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDeviceListEntry> list = devices
        .map(
          (_device) => BluetoothDeviceListEntry(
        device: _device.device,
        // rssi: _device.rssi,
        // enabled: _device.availability == _DeviceAvailability.yes,
        onTap: () {
          widget.onCahtPage(_device.device);
        },
      ),
    )
        .toList();
    return ListView(
      children: list,
    );
  }
}