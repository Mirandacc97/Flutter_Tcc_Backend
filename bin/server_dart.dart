import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:server_dart/src/database/dao.dart'; //
import 'package:server_dart/src/domain/usuario_service.dart'; //

// Inicializa o Service
final _usuarioService = UsuarioService();

Future<Response> login(Request request) async {
  try {
    final body = await request.readAsString();
    final dados = jsonDecode(body);

    // Chama o service que já trata a lógica
    final resultado = await _usuarioService.login(
        dados['login'],
        dados['senha']
    );

    // Retorna 200, mas o conteúdo JSON dirá se foi success: true ou false
    return Response.ok(
      jsonEncode(resultado),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'success': false, 'message': 'Erro server: $e'}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> cadastrarUsuario(Request request) async {
  // Mantenha seu código de cadastro se quiser, ou ignore por enquanto
  return Response.ok('Ignorado para o teste de login');
}

Middleware _corsMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      // FIX CRÍTICO: Se for OPTIONS, retorna 200 OK na hora e nem chama o router.
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization',
        });
      }

      // Se não for OPTIONS, processa normalmente
      final response = await innerHandler(request);

      // Adiciona os headers na resposta normal também
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization',
      });
    };
  };
}

void main() async {
  final router = Router();
  await abreConexaoComServidor(); //

  router.post('/login', login);
  // router.post('/usuarios', cadastrarUsuario);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware())
      .addHandler(router);

  // '0.0.0.0' é CRUCIAL para o emulador enxergar o PC
  await io.serve(handler, '0.0.0.0', 8080);
  print('SERVIDOR RODANDO: Aguardando login...');
}