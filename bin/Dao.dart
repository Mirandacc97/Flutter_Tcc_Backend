import 'package:postgres/postgres.dart';

final connection = PostgreSQLConnection(
  'localhost',
  5432,
  'postgres', // Nome do seu banco
  username: 'postgres',
  password: 'admin',
);

abreConexaoComServidor() {
  connection.open();
}

Future<List<List<dynamic>>> selectLoginSenha(String nome, String senha) async {
  final results = await connection.query(
    'SELECT * FROM usuario WHERE nome = @nome AND senha = @senha',
    substitutionValues: {'nome': nome, 'senha': senha},
  );

  return results;
}

insertLoginSenha(String nome, String senha) async {
  await connection.query(
    'INSERT INTO usuario (nome, senha) VALUES (@nome, @senha)',
    substitutionValues: {'nome': nome, 'senha': senha},
  );
}