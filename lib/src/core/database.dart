import 'package:postgres/postgres.dart';
import 'config.dart';

class Database {
  final Config _config;
  PostgreSQLConnection? _connection;

  Database(this._config);

  Future<PostgreSQLConnection> database() async {
    _connection ??= PostgreSQLConnection(
      _config.dbHost,
      _config.dbPort,
      _config.dbName,
      username: _config.dbUsername,
      password: _config.dbPassword,
    );

    // [CORREÇÃO] Usamos 'isClosed' pois 'isOpen' não existe nessa versão
    if (_connection!.isClosed) {
      await _connection!.open();
    }

    return _connection!;
  }
}