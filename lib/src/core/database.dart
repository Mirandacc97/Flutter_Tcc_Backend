import 'package:postgres/postgres.dart';
import 'package:server_dart/src/core/config.dart';

// Gerenciador da Conexão com o Banco de Dados
class Database {
  final Config _config;

  PostgreSQLConnection? _conexao;

  Database(this._config);

  PostgreSQLConnection get conexao {
    if (_conexao == null) {
      throw Exception('A conexão com o banco de dados não foi inicializada.');
    }
    return _conexao!;
  }

  // Este método substitui a sua antiga função 'abreConexaoComServidor'
  //
  Future<void> abrirConexao() async {
    print('Iniciando conexão com o banco de dados...');
    try {
      _conexao = PostgreSQLConnection(
        _config.dbHost,
        _config.dbPort,
        _config.dbName,
        username: _config.dbUser,
        password: _config.dbPass,
      );

      await _conexao!.open();

      print('Conexão com o banco de dados estabelecida com sucesso!');
    } catch (e) {
      print('Erro fatal ao conectar no banco de dados: $e');
      throw Exception('Falha ao conectar no banco de dados. Verifique suas '
          'variáveis de ambiente e se o serviço do Postgres está rodando.');
    }
  }

  Future<void> fecharConexao() async {
    if (_conexao != null) {
      await _conexao!.close();
      print('Conexão com o banco de dados fechada.');
    }
  }
}