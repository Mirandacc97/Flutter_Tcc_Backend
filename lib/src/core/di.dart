import 'package.get_it/get_it.dart';
import 'package:postgres/postgres.dart';
import 'package:server_dart/src/core/config.dart';

//Injeção de Dependência (Service Locator)
final sl = GetIt.instance;

// Função para registrar todas as dependências da aplicação.
void registerDependencies(Config config, PostgreSQLConnection conexao) {

  sl.registerSingleton<Config>(config);

  sl.registerSingleton<PostgreSQLConnection>(conexao);

  // ---- DAOs (Data Access Objects) ----

  sl.registerLazySingleton<UsuarioDao>(
    // O GetIt é inteligente. Ao criar o UsuarioDao, ele verá
    // que o construtor precisa de uma 'PostgreSQLConnection'.
    // Ele vai automaticamente procurar no 'sl' por ela
    // (que já registramos acima) e injetá-la.
    () => UsuarioDao(sl<PostgreSQLConnection>()),
  );

  // ---- Services (Lógica de Negócios) ----

  sl.registerLazySingleton<AuthService>(
    // O AuthService precisa do UsuarioDao e do jwtSecret (do Config).
    // O 'sl()' é um atalho para 'sl<NomeDaClasse>()'.
    () => AuthService(sl<UsuarioDao>(), sl<Config>().jwtSecret),
  );

  // ---- Controllers (Camada da API) ----

  sl.registerFactory<AuthController>(
    () => AuthController(sl<AuthService>()),
  );
}