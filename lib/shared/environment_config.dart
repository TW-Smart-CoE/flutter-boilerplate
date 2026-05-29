import 'package:flutter_dotenv/flutter_dotenv.dart';

// ignore: non_constant_identifier_names
final Env = dotenv.env;

Future<void> loadEnvironmentConfig() async {
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  switch (env) {
    case 'dev' || 'qa' || 'stage' || 'prod':
      await dotenv.load(fileName: 'config/$env.env');
    default:
      throw Exception('Unknown environment: $env');
  }
}
