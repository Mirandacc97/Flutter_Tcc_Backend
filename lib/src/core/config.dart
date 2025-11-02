//Gerenciador de Configuração (env vars)

import 'dart:io' show Platform;

class Config {
  final String dbHost;
  final int dbPort;
  final String dbName;
  final String dbUser;
  final String dbPass;
  final String jwtSecret;

  Config._({
    required this.dbHost,
    required this.dbPort,
    required this.dbName,
    required this.dbUser,
    required this.dbPass,
    required this.jwtSecret,
  });

  factory Config.fromEnv() {
    final chavePadrao = Platform.environment['JWT_SECRET'] ?? 'SUA_CHAVE_SECRETA_PADRAO_MUDE_ISSO_EM_PRODUCAO';

    if (chavePadrao == 'SUA_CHAVE_SECRETA_PADRAO_MUDE_ISSO_EM_PRODUCAO') {
      print('=' * 80);
      print('AVISO DE SEGURANÇA: A CHAVE SECRETA (JWT_SECRET) ESTÁ USANDO O VALOR PADRÃO.');
      print('Por favor, defina a variável de ambiente JWT_SECRET para um valor longo e seguro.');
      print('=' * 80);
    }

    return Config._(dbHost: (Platform.environment['DB_HOST'] ?? 'localhost'),
      dbPort: (int.tryParse(Platform.environment['DB_PORT'] ?? '5432',) ?? 5432),
      dbName: (Platform.environment['DB_NAME'] ?? 'postgres'),
      dbUser: (Platform.environment['DB_USER'] ?? 'postgres'),
      dbPass: (Platform.environment['DB_PASS'] ?? 'admin'),
      jwtSecret: chavePadrao,);
  }
}