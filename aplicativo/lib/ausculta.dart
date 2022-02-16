import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


/*void main() {
  runApp(Ausculta());
}

class Ausculta extends StatelessWidget {
  Ausculta({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage (),
    );
  }
}*/

class HomePage extends StatefulWidget {
  //const HomePage ({key}) : super(key: key);

  const HomePage(
      {this.server}
      );

  final BluetoothDevice server;


  @override
  _Ausculta createState() => new _Ausculta();
}

class _Ausculta extends State<HomePage> {

  BluetoothConnection connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;


  List item = List();
  String nomeSelecionado;

  List itemProfissional = List();
  String nomeSelecionadoProfissional;


  Future _listarDadosPaciente() async {
    final url = Uri.parse ('http://192.168.0.37/ausculsensor/pacientes/pacientes_listar.php');
    final response = await http.get(url, headers: {"Accept" : "application/json"});
    final jsonBody = response.body;
    Map<String, dynamic> map = json.decode(jsonBody);
    List<dynamic> jsonData = map["result"];

    setState(() {
      item = jsonData;
    });
    //print(jsonBody);
  }

  Future _listarDadosProfissional() async {
    final url = Uri.parse ('http://192.168.0.37/ausculsensor/profissional/profissional_listar.php');
    final response = await http.get(url, headers: {"Accept" : "application/json"});
    final jsonBody = response.body;
    Map<String, dynamic> map = json.decode(jsonBody);
    List<dynamic> jsonData = map["result"];

    setState(() {
      itemProfissional = jsonData;
    });
    //print(jsonBody);
  }

  @override
  void initState(){    //Assim que iniciar a tela, executa esses metodos
    //TODO: implement initState
    super.initState();
    _listarDadosPaciente();
    _listarDadosProfissional();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Conectado ao dispositivo');
      connection = _connection;
      connection.output
          .add(utf8.encode("3" + "\r\n")); //comunicação estabelecida
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Desconectando localmente!');
        } else {
          print('Desconectado remotamente!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Não é possível conectar, ocorreu uma exceção');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  //recebe dados via bluetooth
   _onDataReceived(Uint8List data) async {
    print("Recebendo uma mensagem do módulo!");

    String entrada = String.fromCharCodes(data);

    print(entrada);

    //variavel receptora de valores via bluetooth
    int dadosBluetooth = int.parse(entrada);

    print(dadosBluetooth);
    print("ENTROU");

    setState(() {
      _grafico(dadosBluetooth);
    });

  }

  _grafico(int dados) async{
    print (dados);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text ("Ausculta Pulmonar Automática"),
        backgroundColor: const Color.fromRGBO(198, 204, 160, 71),
        centerTitle: true,
      ),

      body:  SingleChildScrollView(
          child: Column(
            children: [

              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/fundonovo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children:   [

                            DropdownButton(
                              value: nomeSelecionado,
                              hint: const Text('Selecione o Paciente'),
                              items: item.map((list){
                                return DropdownMenuItem(
                                  child: Text(list['nome']),
                                  value: list['nome'],
                                );
                              },).toList(),
                              onChanged: (value){
                                setState(() {
                                  nomeSelecionado = value;
                                });
                              },
                            ),

                            const SizedBox(height: 8),

                            DropdownButton(
                              value: nomeSelecionadoProfissional,
                              hint: const Text('Selecione o Profissional'),
                              items: itemProfissional.map((list){
                                return DropdownMenuItem(
                                  child: Text(list['nome']),
                                  value: list['nome'],
                                );
                              },).toList(),
                              onChanged: (value){
                                setState(() {
                                  nomeSelecionadoProfissional = value;
                                });
                              },
                            ),

                            const Text(
                              '-------------------------------------------------------------',
                              style: TextStyle(
                                fontSize: 50,
                                color: Color.fromRGBO(198, 204, 160, 71),
                                fontWeight: FontWeight.w200,
                                letterSpacing: -10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    TextButton(
                      //onPressed: (),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(198, 204, 160, 71),
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('FIM DA SESSÃO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          //onPressed: (),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(198, 204, 160, 71),
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text('Analisar Sessão',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
      ),    );
  }
}
