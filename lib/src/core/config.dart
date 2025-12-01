import 'dart:io' show Platform;

// Gerenciador de Configuração
class Config {
  final String dbHost;
  final int dbPort;
  final String dbUsername;
  final String dbPassword;
  final String dbName;
  final String jwtSecret;

  Config._({
    required this.dbHost,
    required this.dbPort,
    required this.dbUsername,
    required this.dbPassword,
    required this.dbName,
    required this.jwtSecret,
  });

  factory Config() {
    return Config._(
      dbHost: (Platform.environment['DB_HOST'] ?? 'localhost'),
      dbPort: (int.tryParse(Platform.environment['DB_PORT'] ?? '5432',) ?? 5432),
      dbUsername: (Platform.environment['DB_USER'] ?? 'postgres'),
      dbPassword: (Platform.environment['DB_PASS'] ?? '1234'),
      dbName: (Platform.environment['DB_NAME'] ?? 'postgres'),
      jwtSecret: (Platform.environment['JWT_SECRET'] ?? 'bd2d53e8233f48a60c0d18910a36e648'),
    );
  }

  // Gera a chave de segurança para o JWT
  JwtClaimSet _claimSet(String issuer) => JwtClaimSet(
    issuer: issuer,
    maxAge: const Duration(days: 1),
  );

  // Gera um token
  String gerarToken(String issuer) {
    final claimSet = _claimSet(issuer);
    return issueJwtHS256(claimSet, jwtSecret);
  }

  // Valida um token
  bool validarToken(String token) {
    try {
      verifyJwtHS256Signature(token, jwtSecret);
      return true;
    } catch (e) {
      return false;
    }
  }
}