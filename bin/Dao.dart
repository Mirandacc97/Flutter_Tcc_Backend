import 'package:postgres/postgres.dart';

// (Mantenha o código de conexão que já existe aqui)
// Exemplo:
late PostgreSQLConnection connection;
Future<void> abreConexaoComServidor() async {
  connection = PostgreSQLConnection(
      'host', // host
      5432, // porta
      'database', // database
      username: 'user',
      password: 'password'
  );
  await connection.open();
}
// ... Mantenha o resto do seu código de conexão e a função insertLoginSenha

// Função para inserir forma de pagamento
Future<void> insertFormaPagamento(String nome) async {
  try {
    await connection.query(
      "INSERT INTO formas_pagamento (nome) VALUES (@nome)",
      substitutionValues: {
        "nome": nome,
      },
    );
    print('Forma de pagamento inserida com sucesso!');
  } catch (e) {
    print('Erro ao inserir forma de pagamento: $e');
  }
}

// Função para inserir produto
Future<void> insertProduto(String nome, String tipoVenda, double valorVenda) async {
  try {
    await connection.query(
      "INSERT INTO produtos (nome, tipo_venda, valor_venda) VALUES (@nome, @tipoVenda, @valorVenda)",
      substitutionValues: {
        "nome": nome,
        "tipoVenda": tipoVenda,
        "valorVenda": valorVenda,
      },
    );
    print('Produto inserido com sucesso!');
  } catch (e) {
    print('Erro ao inserir produto: $e');
  }
}