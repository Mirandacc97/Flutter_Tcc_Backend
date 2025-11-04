import 'package:get_it/get_it.dart';

import 'package.get_it/get_it.dart';
import 'package:postgres/postgres.dart';
import 'package:server_dart/src/core/config.dart';

//Injeção de Dependência (Service Locator)
final sl = GetIt.instance;

// Função para registrar todas as dependências da aplicação.
void registerDependencies(Config config, PostgreSQLConnection conexao) {

  sl.registerSingleton<Config>(config);

  sl.registerSingleton<PostgreSQLConnection>(conexao);

  sl.registerLazySingleton<UsuarioDao>(
    () => UsuarioDao(sl<PostgreSQLConnection>()),
  );

  // ---- Services (Lógica de Negócios) ----

  sl.registerLazySingleton<AuthService>(
    () => AuthService(sl<UsuarioDao>(), sl<Config>().jwtSecret),
  );

  // ---- Controllers (Camada da API) ----

  sl.registerFactory<AuthController>(
    () => AuthController(sl<AuthService>()),
  );
}