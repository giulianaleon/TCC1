import 'package:ausculta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(CriarConta());
}

class CriarConta extends StatelessWidget {
  CriarConta({key}) : super(key: key);

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
  State<HomePage> createState() => _CriarProfissionalPageState();
}

class _CriarProfissionalPageState extends State<HomePage> {

  TextEditingController nomeP = TextEditingController();
  TextEditingController idadeP = TextEditingController();
  TextEditingController sexoP = TextEditingController();
  TextEditingController cpfP = TextEditingController();
  TextEditingController crefitoP = TextEditingController();
  TextEditingController telefoneP = TextEditingController();
  TextEditingController emailP = TextEditingController();
  TextEditingController senhaP = TextEditingController();

  Future registrar() async{
    var url = Uri.parse ('http://192.168.0.37/ausculsensor/profissional/inserir.php');
    var response = await http.post(url, body: {
      "nome" : nomeP.text,
      "idade" : idadeP.text,
      "sexo" : sexoP.text,
      "cpf" : cpfP.text,
      "crefito" : crefitoP.text,
      "telefone" : telefoneP.text,
      "senha" : senhaP.text,
      "email" : emailP.text,
    });

    var data = jsonDecode(response.body);
    print(data);

    if(data == 2){
      Fluttertoast.showToast(
          msg: "Usuário já existente!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }else{
      Fluttertoast.showToast(
          msg: "Registrado com sucesso!",
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
          title: const Text ("Nova Conta"),
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

                          SizedBox(
                            width: 250,
                            child: TextField(
                              controller: nomeP,
                              decoration: const InputDecoration(
                                labelText: 'Nome',
                                icon: Icon(Icons.account_circle),
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 250,
                            child: TextField(
                              controller: idadeP,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Idade',
                                icon: Icon(Icons.account_circle),
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 250,
                            child: TextField(
                              controller: sexoP,
                              decoration: const InputDecoration(
                                labelText: 'Sexo',
                                icon: Icon(Icons.account_circle),
                              ),
                            ),
                          ),


                           SizedBox(
                            width: 250,
                            child: TextField(
                              controller: cpfP,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'CPF',
                                icon: Icon(Icons.person_pin_circle_sharp),
                              ),
                            ),
                          ),

                           SizedBox(
                            width: 250,
                            child: TextField(
                              controller: crefitoP,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Crefito',
                                icon: Icon(Icons.badge),
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 250,
                            child: TextField(
                              controller: emailP,
                              decoration: const InputDecoration(
                                labelText: 'E-mail',
                                icon: Icon(Icons.alternate_email),
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 250,
                            child: TextField(
                              controller: senhaP,
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                labelText: 'Senha',
                                icon: Icon(Icons.vpn_key),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: (){
                          registrar();
                          nomeP.text="";
                          idadeP.text="";
                          sexoP.text="";
                          cpfP.text="";
                          crefitoP.text="";
                          emailP.text="";
                          senhaP.text="";
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(198, 204, 160, 71),
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text('CRIAR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),

                      ),

                      const SizedBox(width: 8),

                      TextButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TelaLogin()),
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
                        child: const Text('VOLTAR',
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
            )
        )     );
  }

}
