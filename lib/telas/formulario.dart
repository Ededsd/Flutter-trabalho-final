import 'package:flutter/material.dart';
import 'package:dev_mobile/modelos/usuario.dart';
import 'package:get/get.dart';

class Formulario extends StatefulWidget {
  const Formulario({super.key});

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [formulario(), botoes()],
      ),
    );
  }

  //Widgets da tela Formulario
  Widget botoes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              if (_keyForm.currentState!.validate() == true) {
                _keyForm.currentState!.save();
                print(formularioSalvo);
              }
            },
            child: Text('Salvar'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(onPressed: () {}, child: Text('Enviar')),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Usuario.verificaUsuario().then((usuario) {
                if (usuario != null) {
                  usuario.removeUsuario().then(
                    (retorno) {
                      if (retorno > 0) {
                        //Navigator.pushReplacementNamed(context, '/');
                        Get.toNamed('/');
                      }
                    },
                  );
                }
              });
            },
            child: Text('Logout'),
          ),
        )
      ],
    );
  }

  final _keyForm = GlobalKey<FormState>();
  Map<String, String> formularioSalvo = {};

  Widget formulario() {
    return Form(
      key: _keyForm,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            child: TextFormField(
              onSaved: (valor) {
                formularioSalvo['nome'] = valor!;
              },
              validator: (entrada) {
                if (entrada!.isEmpty) {
                  return 'Nome requerido.';
                } else if (entrada.contains(' ') == false) {
                  return 'Forneça um nome completo.';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          ),
          Padding(
            child: TextFormField(
              onSaved: (valor) {
                formularioSalvo['email'] = valor!;
              },
              validator: (entrada) {
                if (entrada!.contains('@') == false) {
                  return 'Insira um email válido.';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: '<seu_id>@dominio.com',
                hintStyle: TextStyle(color: Colors.black26),
                border: OutlineInputBorder(),
              ),
            ),
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          ),
        ],
      ),
    );
  }
}
