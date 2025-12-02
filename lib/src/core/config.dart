import 'dart:io' show Platform;

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
      dbPort: (int.tryParse(Platform.environment['DB_PORT'] ?? '5432') ?? 5432),
      dbUsername: (Platform.environment['DB_USER'] ?? 'postgres'),
      dbPassword: (Platform.environment['DB_PASS'] ?? 'admin'),
      dbName: (Platform.environment['DB_NAME'] ?? 'postgres'),
      jwtSecret: (Platform.environment['JWT_SECRET'] ?? 'bd2d53e8233f48a60c0d18910a36e648'),
    );
  }
}