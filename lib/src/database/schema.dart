import 'package:postgres/postgres.dart';

class VerificadorSchema {

  static const _tabelaUsuario = '''
  CREATE TABLE IF NOT EXISTS usuario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL UNIQUE, 
    senha VARCHAR(255) NOT NULL
  );
  ''';

  static Future<void> verificarECriarTabelas(PostgreSQLConnection conexao) async {
    print('Verificando integridade');
    try {
      await conexao.query(_tabelaUsuario);
      print('Procedimento finalizado com sucesso.');
    } catch (e) {
      print('Erro ao verificar/criar tabelas: $e');
    }
  }
}