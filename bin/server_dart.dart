import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';
import 'WindowLogin.dart';
import 'Dao.dart';

Middleware _corsMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
        'Access-Control-Allow-Headers': '*',
      });
    };
  };
}

void main() async {
  final router = Router();

  abreConexaoComServidor();

  // CORS preflight
  router.options('/usuarios', (Request request) => Response.ok(''));
  router.options('/login', (Request request) => Response.ok(''));

  // Cadastro de usuário
  router.post('/usuarios', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final nome = data['nome'];
    final senha = data['senha'];

    if (nome == null || nome.toString().isEmpty) {
      return Response(
        400,
        body: jsonEncode({'erro': 'Nome é obrigatório'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    insertLoginSenha(nome, senha);

    return Response.ok(
      jsonEncode({'mensagem': 'Usuário cadastrado com sucesso', 'nome': nome}),
      headers: {'Content-Type': 'application/json'},
    );
  });


  router.post('/login', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    return requisicaoLogin(data['nome'], data['senha']);
  });

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware())
      .addHandler(router);

  await io.serve(handler, '0.0.0.0', 8080);
  print('Servidor Dart inicializado!');
}
