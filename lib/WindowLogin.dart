import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'Dao.dart';

Future<Response> requisicaoLogin(String? nome, String? senha) async {
  print('Recebendo requisição de login!');

  // Validar parâmetros nulos
  if (nome == null || senha == null) {
    return Response(
      400,
      body: jsonEncode({'success': false, 'message': 'Nome e senha obrigatórios'}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // Usar await para esperar resultado da consulta
  var registro = await selectLoginSenha(nome, senha);

  if (registro.isNotEmpty) {
    print('Usuário localizado!');
    return Response.ok(
      jsonEncode({'success': true, 'message': 'Login bem-sucedido'}),
      headers: {'Content-Type': 'application/json'},
    );
  } else {
    print('Usuário NÃO localizado!');
    return Response.ok(
      jsonEncode({
        'success': false,
        'message': 'Recebi sua requisição mas seu usuário ou senha está incorreto!'
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
