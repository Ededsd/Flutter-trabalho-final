import 'package:dio/dio.dart';
import 'package:dev_mobile/modelos/db/banco.dart';

class Usuario {
  String? username;
  String? password;
  String? ultimoLogin;

  Usuario(this.username, this.password, this.ultimoLogin);

  Future<Map?> autentica() async {
    try {
      Response resposta = await Dio().post(
      'https://tarrafa.unimontes.br/aula/autentica',
      data: {'username': username, 'password': password}
      );

      //await Future.delayed(Duration(seconds: 10));

      if(resposta.statusCode == 200) {
        return resposta.data;
      }

    } on DioException {
      return {'resposta':'Erro', 'motivo':'servidor não encontrado'};
    }
    
    return null;

  }

  Future<int> insereUsuario() async {
    final db = await Banco.instance.database;
    return db.rawInsert('''
      INSERT OR REPLACE INTO user (username, password, ultimo_login) 
      VALUES ('$username', '$password', '$ultimoLogin')
    ''');
  }

  Future<int> removeUsuario() async {
    final db = await Banco.instance.database;
    return db.rawDelete('''
      DELETE FROM user WHERE username =  '$username'
    ''');
  }

  static Future<Usuario?> verificaUsuario() async {
    final db = await Banco.instance.database;
    List<Map<String, Object?>> lista = await db.rawQuery('select * from user');

    if(lista.isNotEmpty){
      Map<String, Object?> u = lista.first;
      Usuario usuario = Usuario(u['username'].toString(), u['password'].toString(), u['ultimo_login'].toString());
      return usuario;
    }

    return null;
  }

}