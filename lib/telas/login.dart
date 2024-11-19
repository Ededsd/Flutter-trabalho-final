// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:dev_mobile/modelos/usuario.dart';
import 'package:intl/intl.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool mostraBotaoLogin = true;

  @override
  void initState() {
    super.initState();

    Usuario.verificaUsuario().then((user) {
      if (user != null) Navigator.pushNamed(context, '/formulario');
    });
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: criaImagem('assets/unimontes-logo.png'),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              child: criaBarraTexto(usernameController, 'Username'),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 300,
              child: criaBarraTexto(passwordController, 'Password'),
            ),
            SizedBox(
              height: 10,
            ),
            mostraBotaoLogin
                ? botaoLogin()
                : SizedBox(
                    width: 300,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget botaoLogin() {
    return ElevatedButton(
      onPressed: () {
        DateTime data = DateTime.now();
        String dataLogin = DateFormat('dd-MM-yyyy - kk:mm').format(data);
        Usuario u = Usuario(
            usernameController.text, passwordController.text, dataLogin);

        setState(() {
          mostraBotaoLogin = false;
        });

        u.autentica().then((resposta) {
          if (resposta != null) {
            if (resposta['resposta'] != 'ok') {
              criaMensagem(context, resposta['motivo']);
              setState(() {
                mostraBotaoLogin = true;
              });
            } else {
              u.insereUsuario().then((resposta) {
                if (resposta > 0) {
                  Navigator.pushReplacementNamed(context, '/pesquisacep');
                } else {
                  criaMensagem(context, 'Erro ao tentar conectar ao banco.');
                }
              });
            }
          }
        });
      },
      child: Text('Entrar'),
    );
  }

//
//
//
//
//
  Image criaImagem(String caminho) {
    return Image.asset(caminho, errorBuilder: (context, error, stackTrace) {
      return Text('Imagem não encontrada');
    });
  }

  Widget criaBarraTexto(TextEditingController controlObject, String texto) {
    return TextField(
        controller: controlObject,
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: texto));
  }

  ScaffoldFeatureController criaMensagem(BuildContext context, String texto) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }
}
