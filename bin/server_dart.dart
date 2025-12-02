import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:server_dart/src/database/dao.dart';

final _dao = UsuarioDao();

Future<Response> login(Request request) async {
  try {
    final body = await request.readAsString();
    final dados = jsonDecode(body);
    final String? nome = dados['login'];
    final String? senha = dados['senha'];

    if (nome == null || senha == null || nome.isEmpty || senha.isEmpty) {
      return Response.ok(
        jsonEncode({'success': false, 'message': 'Nome e senha obrigatórios'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final registro = await _dao.selectLoginSenha(nome, senha);

    if (registro.isNotEmpty) {
      return Response.ok(
        jsonEncode({'success': true, 'message': 'Login bem-sucedido'}),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      return Response.ok(
        jsonEncode({
          'success': false,
          'message': 'Usuário ou senha incorretos'
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'success': false, 'message': 'Erro interno: $e'}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> cadastrarUsuario(Request request) async {
  try {
    final body = await request.readAsString();
    final dados = jsonDecode(body);
    final String? nome = dados['nome'];
    final String? senha = dados['senha'];

    if (nome == null || nome.isEmpty) {
      return Response.ok(
        jsonEncode({'erro': 'Nome é obrigatório', 'status': 400}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    await _dao.insertLoginSenha(nome, (senha ?? ''));

    return Response.ok(
      jsonEncode({
        'mensagem': 'Usuário cadastrado com sucesso',
        'nome': nome,
        'status': 200
      }),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'erro': 'Erro ao cadastrar: $e'}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

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

  await abreConexaoComServidor();

  router.options('/usuarios', (Request request) => Response.ok(''));
  router.options('/login', (Request request) => Response.ok(''));

  router.post('/usuarios', cadastrarUsuario);
  router.post('/login', login);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware())
      .addHandler(router);

  await io.serve(handler, '0.0.0.0', 8080);
  print('Servidor Dart inicializado!');
}