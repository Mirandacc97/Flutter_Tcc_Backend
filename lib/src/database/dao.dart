// lib/src/database/dao.dart
import 'package:postgres/postgres.dart';
import 'schema.dart'; // Importar o novo verificador

final connection = PostgreSQLConnection(
  'localhost',
  5432,
  'postgres', // Nome do seu banco
  username: 'postgres',
  password: 'admin',
);

// Agora é async para esperar a verificação do schema
Future<void> abreConexaoComServidor() async {
  await connection.open();
  print('Conexão com o banco de dados aberta.');

  // Chamar o verificador de schema APÓS abrir a conexão
  await VerificadorSchema.verificarE_CriarTabelas(connection);
}

// Classe DAO (Repositório) para isolar as queries de Usuário
class UsuarioDao {
  Future<List<List<dynamic>>> selectLoginSenha(String nome, String senha) async {
    final results = await connection.query(
      'SELECT * FROM usuario WHERE nome = @nome AND senha = @senha',
      substitutionValues: {'nome': nome, 'senha': senha},
    );

    return results;
  }

  Future<void> insertLoginSenha(String nome, String senha) async {
    await connection.query(
      'INSERT INTO usuario (nome, senha) VALUES (@nome, @senha)',
      substitutionValues: {'nome': nome, 'senha': senha},
    );
  }
}