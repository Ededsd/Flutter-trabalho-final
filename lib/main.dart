import 'package:flutter/material.dart';
import 'package:dev_mobile/telas/formulario.dart';
import 'package:dev_mobile/telas/login.dart';
import 'package:dev_mobile/telas/pesquisacep.dart';
import 'package:get/get.dart';

void main() {
  //runApp(MainApp());
  runApp(
    GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/Formulario',
          page: () => Formulario(),
        ),
        GetPage(
          name: '/PesquisaCEP',
          page: () => PesquisaCep(),
        ),
      ],
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/formulario': (context) => Formulario(),
        '/pesquisacep': (context) => PesquisaCep()
      },
    );
  }
}
