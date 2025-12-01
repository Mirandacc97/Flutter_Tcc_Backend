import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:server_dart/src/database/dao.dart';

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

void main() async { // main agora é async
  final router = Router();
  // Instancia o handler que agora cuida das rotas de usuário
  final usuarioHandler = UsuarioHandler();

  // Abre a conexão global E verifica o schema
  await abreConexaoComServidor(); // Adicionado await

  // CORS preflight
  router.options('/usuarios', (Request request) => Response.ok(''));
  router.options('/login', (Request request) => Response.ok(''));

  // Cadastro de usuário (agora usa o handler)
  router.post('/usuarios', usuarioHandler.cadastrarUsuario);

  // Login (agora usa o handler)
  router.post('/login', usuarioHandler.login);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware())
      .addHandler(router);

  await io.serve(handler, '0.0.0.0', 8080);
  print('Servidor Dart inicializado!');
}