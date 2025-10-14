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
  router.options('/formas-pagamento', (Request request) => Response.ok('')); // NOVO
  router.options('/produtos', (Request request) => Response.ok('')); // NOVO


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

  // --- NOVAS ROTAS ---

  // Cadastro de Forma de Pagamento
  router.post('/formas-pagamento', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);
    final nome = data['nome'];

    if (nome == null || nome.isEmpty) {
      return Response.badRequest(body: 'O nome é obrigatório.');
    }

    await insertFormaPagamento(nome);
    return Response.ok(jsonEncode({'mensagem': 'Forma de pagamento cadastrada!'}));
  });

  // Cadastro de Produto
  router.post('/produtos', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final nome = data['nome'];
    final tipoVenda = data['tipo_venda'];
    final valorVenda = data['valor_venda'];

    if (nome == null || tipoVenda == null || valorVenda == null) {
      return Response.badRequest(body: 'Todos os campos são obrigatórios.');
    }

    await insertProduto(nome, tipoVenda, (valorVenda as num).toDouble());
    return Response.ok(jsonEncode({'mensagem': 'Produto cadastrado!'}));
  });


  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware())
      .addHandler(router);

  await io.serve(handler, '0.0.0.0', 8080);
  print('Servidor Dart inicializado!');
}