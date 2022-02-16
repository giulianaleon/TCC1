import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  List items = List();


  _listarDados() async {
    final url = Uri.parse ('http://192.168.0.37/ausculsensor/pacientes/pacientes_listar.php');
    final response = await http.get(url);
    final map = json.decode(response.body);
    final paciente = map["result"];
    carregando = true;
    this.dados = paciente;
  }

  @override
  void initState(){    //Assim que iniciar a tela, executa esses metodos
    //TODO: implement initState
    super.initState();
    _listarDados();
  }

  String _selectedLocation;

  final controleFrequenciaCardiaca = TextEditingController();
  final controleSaturacao = TextEditingController();
  final controlePressao = TextEditingController();
  final controleTemperatura = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text ("Cadastrar Sessão"),
          backgroundColor: const Color.fromRGBO(198, 204, 160, 71),
        ),
        body: Container(

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
                          Expanded(
                            child:
                            SizedBox(
                              height: 20.0,
                              child: ListView.builder(
                                //shrinkWrap: true,
                                itemCount: this.dados != null ? this.dados.length : 0,  //Se o array for 0, ele não recupera informações
                                itemBuilder: (context, i) {    //Um for que percorre toda a lista de dadps
                                  final paciente = this.dados[i];
                                  print(paciente);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          DropdownButton(
                            hint: const Text('Selecione o Paciente'),
                            onChanged: (newValue) {
                              setState((){
                                _selectedLocation = newValue;
                              });
                            },
                            value: _selectedLocation,
                            items: items.map((location){
                              return DropdownMenuItem(
                                child: Text (location),
                                value: location,
                              );
                            }).toList(),
                          ),

                          const SizedBox(width: 20),

                          TextButton(
                            //onPressed: (),
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
                        ],
                      ),

                      const Text(
                        '-----------------------------------------------',
                        style: TextStyle(
                          fontSize: 50,
                          color: Color.fromRGBO(198, 204, 160, 71),
                          fontWeight: FontWeight.w200,
                          letterSpacing: -10,
                        ),
                      ),

                      const SizedBox(
                        width: 300,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Frequência Cardíaca',
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      const SizedBox(
                        width: 300,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Saturação do Oxigênio',
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 300,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Pressão Arterial',
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 300,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Temperatura Corporal',
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [

                          const SizedBox(width: 90),

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
        )    );
  }
}
