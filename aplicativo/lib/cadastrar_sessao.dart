import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ausculta/criar_paciente.dart';
import 'package:ausculta/ausculta.dart';
import 'package:ausculta/bluetooth.dart';

void main() {
  runApp(const Sessao());
}

class Sessao extends StatelessWidget {
  const Sessao({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage (),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage ({key}) : super(key: key);

  @override
  State<HomePage> createState() => _CadastrarSessao();
}

class _CadastrarSessao extends State<HomePage> {

  var carregando = false;  //Para quando estiver carregando algo dentro do projeto
  var dados;
  var nome;  //Unica variavel que quero buscar do banco
  List item = List();
  String nomeSelecionado;


  Future _listarDados() async {
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

  @override
  void initState(){    //Assim que iniciar a tela, executa esses metodos
    //TODO: implement initState
    super.initState();
    _listarDados();
  }

  String _selectedLocation;

  TextEditingController controleFrequenciaCardiaca = TextEditingController();
  TextEditingController controleSaturacao = TextEditingController();
  TextEditingController controlePressao = TextEditingController();
  TextEditingController controleTemperatura = TextEditingController();

  Future registrar() async{
    var url = Uri.parse ('http://192.168.0.37/ausculsensor/sinais_vitais/inserir.php');
    var response = await http.post(url, body: {
      "freq_cardiaca" : controleFrequenciaCardiaca.text,
      "sat_oxigenio" : controleSaturacao.text,
      "p_arterial" : controlePressao.text,
      "temp_corporal" : controleTemperatura.text,
    });

    var data = jsonDecode(response.body);
    print(data);

    if(data == 2){
      Fluttertoast.showToast(
          msg: "ERRO!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }else{
      Fluttertoast.showToast(
          msg: "Dados registrados com sucesso!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text ("Cadastrar Sessão"),
          backgroundColor: const Color.fromRGBO(198, 204, 160, 71),
        ),
        body: SingleChildScrollView(
          child: Container(

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
                      children:  [

                        Row(
                          children: [
                            const SizedBox(width: 40),
                            DropdownButton(
                              value: nomeSelecionado,
                              hint: const Text('Consulte o nome do paciente'),
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
                          ],
                        ),

                        TextButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CriarPaciente()),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(198, 204, 160, 71),
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text('Novo Paciente',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
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

                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: controleFrequenciaCardiaca,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Frequência Cardíaca',
                              icon: Icon(Icons.graphic_eq),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: controleSaturacao,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Saturação do Oxigênio',
                              icon: Icon(Icons.graphic_eq),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: controlePressao,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Pressão Arterial',
                                icon: Icon(Icons.graphic_eq),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: controleTemperatura,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Temperatura Corporal',
                              icon: Icon(Icons.device_thermostat),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            const SizedBox(width: 90),

                            TextButton(
                              onPressed: (){
                                //registrar();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PaginaLista()),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(198, 204, 160, 71),
                                padding: const EdgeInsets.only(left: 30, right: 30),
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text('Auscultar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )    );
  }
}
