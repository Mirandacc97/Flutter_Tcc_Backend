import 'package:postgres/postgres.dart';
import 'config.dart';

// Gerenciador de Conexão com o Banco
class Database {
  final Config _config;

  // A conexão DEVE ser anulável ('?') para corrigir o erro da sua imagem
  PostgreSQLConnection? _connection;

  Database(this._config);

  // Retorna a conexão, abrindo-a se necessário
  Future<PostgreSQLConnection> database() async {
    // Se _connection for nula, cria uma nova instância
    // Isto agora é válido porque _connection é anulável
    _connection ??= PostgreSQLConnection(
      _config.dbHost,
      _config.dbPort,
      _config.dbName,
      username: _config.dbUsername,
      password: _config.dbPassword,
    );

    // Se a conexão não estiver aberta, abre
    // Usamos '!' pois garantimos que não é nula na linha acima
    if (!_connection!.isOpen) {
      await _connection!.open();
    }

    return _connection!;
  }
}