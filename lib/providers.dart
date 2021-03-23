import 'package:fitness_logger_app/services/auth_service.dart';
import 'package:fitness_logger_app/services/fl_api.dart';
import 'package:provider/provider.dart';

generateProviders() {
  return [
    // AuthService Injection
    Provider<AuthService>(
      create: (_) => AuthService(FlAuthApiService.create()),
      dispose: (_, AuthService service) =>
          service.flAuthApiService.client.dispose(),
    ),
    Provider<FlTypesApiService>(
      create: (_) => FlTypesApiService.create(),
      dispose: (_, FlTypesApiService service) => service.client.dispose(),
    ),
  ];
}
