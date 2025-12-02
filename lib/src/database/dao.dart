import 'package:postgres/postgres.dart';
import 'schema.dart';

final connection = PostgreSQLConnection(
  'localhost',
  5432,
  'postgres',
  username: 'postgres',
  password: 'admin',
);

Future<void> abreConexaoComServidor() async {
  await connection.open();
  print('Conexão com o banco de dados aberta.');

  // Verifica e cria as tabelas necessárias
  await VerificadorSchema.verificarECriarTabelas(connection);
}

class UsuarioDao {
  // Padronizado: parâmetro 'nome' para combinar com o SQL @nome
  Future<List<List<dynamic>>> selectLoginSenha(String nome, String senha) async {
    final results = await connection.query(
      'SELECT * FROM usuario WHERE nome = @nome AND senha = @senha',
      substitutionValues: {'nome': nome, 'senha': senha},
    );

    return results;
  }

  Future<void> insertLoginSenha(String login, String senha) async {
    await connection.query(
      'INSERT INTO usuario (nome, senha) VALUES (@nome, @senha)',
      substitutionValues: {'nome': login, 'senha': senha},
    );
  }
}