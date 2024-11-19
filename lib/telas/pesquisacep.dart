import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PesquisaCep extends StatefulWidget {
  const PesquisaCep({super.key});

  @override
  State<PesquisaCep> createState() => _PesquisaCepState();
}

class _PesquisaCepState extends State<PesquisaCep> {
  late TextEditingController cepCtrl;
  Future<Map>? cepDados;

  @override
  void initState() {
    super.initState();
    cepCtrl = TextEditingController();
    cepDados = buscaCEP();
  }

  @override
  void dispose() {
    super.dispose();
    cepCtrl.dispose();
  }

  Future<Map> buscaCEP() async {
    try {
      String cep = cepCtrl.text;

      cep = cep.trim();
      if (cep.isEmpty) return {'Erro': 'Digite um CEP válido!'};

      Response resposta =
          await Dio().get('https://brasilapi.com.br/api/cep/v2/$cep');

      if (resposta.statusCode == 200) {
        return resposta.data;
      }

      return {'Erro': 'Erro no servidor.'};
    } on DioException {
      return {'Erro': 'serviço não encontrado.'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextField(
                        decoration:
                            InputDecoration(hintText: 'Forneça um CEP...'),
                        controller: cepCtrl,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              cepDados = buscaCEP();
                            });
                          },
                          icon: Icon(Icons.search)),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                child: FutureBuilder<Map>(
                  future: cepDados,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }

                    Map? dados = snapshot.data;

                    if (dados!.containsKey('Erro')) {
                      return Center(child: Text(dados['Erro']));
                    }

                    return ListView(
                      children: [
                        Card(
                          child: ListTile(
                            title: Text('Cidade'),
                            subtitle: Text(dados['city']),
                            leading: Icon(Icons.location_city),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            title: Text('Logradouro'),
                            subtitle: Text(dados['street']),
                            leading: Icon(Icons.streetview),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
