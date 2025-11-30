import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../domain/usuario_service.dart'; // Import corrigido

// Camada de Controle (Handler/Controller)
class UsuarioHandler {
  final UsuarioService _service = UsuarioService();

  // Handler para a rota /login
  Future<Response> login(Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    // Chama o serviço para executar a lógica de negócio
    final resultado = await _service.login(data['nome'], data['senha']);

    // O handler formata a resposta HTTP baseado no que o serviço retornou
    if (resultado['success'] == true) {
      return Response.ok(
        jsonEncode(resultado),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      // Mantém 200 OK mas com {success: false}, como no código original
      return Response.ok(
        jsonEncode(resultado),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // Handler para a rota /usuarios (cadastro)
  Future<Response> cadastrarUsuario(Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    // Chama o serviço para cadastrar
    final resultado = await _service.cadastrar(data['nome'], data['senha']);

    // O serviço nos diz qual status usar
    final int status = (resultado['status'] as int);

    return Response(
      status,
      body: jsonEncode(resultado),
      headers: {'Content-Type': 'application/json'},
    );
  }
}