// lib/src/domain/usuario_service.dart
import '../database/dao.dart'; // Import corrigido

// Camada de Serviço (Lógica de Negócio)
class UsuarioService {
  // Instanciando o DAO (que atua como Repositório)
  final UsuarioDao _dao = UsuarioDao();

  // Lógica de negócio para login
  Future<Map<String, dynamic>> login(String? nome, String? senha) async {
    print('Recebendo requisição de login (Service)!');

    // Validar parâmetros nulos ou vazios
    if (nome == null || senha == null || nome.isEmpty || senha.isEmpty) {
      return {'success': false, 'message': 'Nome e senha obrigatórios'};
    }

    // Usar await para esperar resultado da consulta
    final registro = await _dao.selectLoginSenha(nome, senha);

    if (registro.isNotEmpty) {
      print('Usuário localizado (Service)!');
      return {'success': true, 'message': 'Login bem-sucedido'};
    } else {
      print('Usuário NÃO localizado (Service)!');
      return {
        'success': false,
        'message': 'Recebi sua requisição mas seu usuário ou senha está incorreto!'
      };
    }
  }

  // Lógica de negócio para cadastro
  Future<Map<String, dynamic>> cadastrar(String? nome, String? senha) async {
    if (nome == null || nome.isEmpty) {
      // Retorna um mapa que o handler usará para definir o status HTTP
      return {'erro': 'Nome é obrigatório', 'status': 400};
    }

    // Em um cenário real, criptografaríamos a senha aqui
    await _dao.insertLoginSenha(nome, (senha ?? ''));

    return {
      'mensagem': 'Usuário cadastrado com sucesso',
      'nome': nome,
      'status': 200
    };
  }
}