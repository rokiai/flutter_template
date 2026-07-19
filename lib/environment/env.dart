import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(
    varName: 'API_BASE_URL',
    defaultValue: 'https://jsonplaceholder.typicode.com',
  )
  static final String apiBaseUrl = _Env.apiBaseUrl;

  @EnviedField(varName: 'SENTRY_DSN', obfuscate: true, defaultValue: '')
  static final String sentryDsn = _Env.sentryDsn;
}
