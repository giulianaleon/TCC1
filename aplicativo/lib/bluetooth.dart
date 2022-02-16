import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:ausculta/connection.dart';
import 'package:ausculta/ausculta.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaginaLista extends StatelessWidget {

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione o módulo HC-05'),
        backgroundColor: const Color.fromRGBO(198, 204, 160, 71),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FlutterBluetoothSerial.instance.requestEnable(),
        builder: (context, future) {
          if (future.connectionState == ConnectionState.waiting) {
            print("Aguarde..");
            return Scaffold(
              body: Container(
                height: double.infinity,
                child: const Center(
                  child: Icon(
                    Icons.bluetooth_disabled,
                    size: 200.0,
                    color: Color(0xFF4D7DB4),
                  ),
                ),
              ),
            );
          } else if (future.connectionState == ConnectionState.done) {
            Fluttertoast.showToast(
                msg: "Bluetooth conectado com sucesso!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.lightGreen,
                textColor: Colors.white,
                fontSize: 16.0
            );
            return SelecionaDispositivo();
          } else {
            return SelecionaDispositivo();
          }
        },
      ),
    );
  }
}

//widget sem estado
class SelecionaDispositivo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SelectBondedDevicePage(
      onCahtPage: (device1) {
        BluetoothDevice device = device1;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage(server: device);
            },
          ),
        );
      },
    );
  }
}
