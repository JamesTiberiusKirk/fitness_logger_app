import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:fitness_logger_app/models/user.dart';
import 'package:fitness_logger_app/router_generator.dart';
import 'package:fitness_logger_app/services/auth_service.dart';
import 'package:fitness_logger_app/models/fl_type.dart';

part 'fl_api.chopper.dart';

const String baseUrl = 'http://api.logger.fitness:80';

@ChopperApi(baseUrl: '/auth')
abstract class FlAuthApiService extends ChopperService {
  @Post(path: '/login')
  Future<Response> login(@Body() User user);

  @Post(path: '/register')
  Future<Response> register(@Body() UserRegistration userReg);

  @Post(path: '/verify_me')
  Future<Response> vefiryMe(@Body() Map<String, String> jwt);

  static FlAuthApiService create() {
    final client = ChopperClient(
      baseUrl: baseUrl,
      services: [
        _$FlAuthApiService(),
      ],
      converter: JsonConverter(),
    );
    return _$FlAuthApiService(client);
  }
}

@ChopperApi(baseUrl: '/types')
abstract class FlTypesApiService extends ChopperService {
  // GET all
  @Get(path: '/')
  Future<Response> getAll();

  // GET by id
  @Get(path: '/')
  Future<Response> getById(@Query('tp_id') tpId);

  // GET by name
  @Get(path: '/')
  Future<Response> getByTpName(@Query('tpName') tpName);

  // GET by description
  @Get(path: '/')
  Future<Response> getByDescription(@Query('description') description);

  // POST
  @Post(path: '/')
  Future newType(@Body() FlType newType);

  // PUT
  @Put(path: '/')
  Future updateType(@Body() FlType updateType);

  // DELETE
  @Delete(path: '/')
  Future delete(@Query('tp_id') String tpId);

  static FlTypesApiService create() {
    final client = ChopperClient(
      baseUrl: baseUrl,
      services: [
        _$FlTypesApiService(),
      ],
      converter: JsonConverter(),
      interceptors: [
        HeadersInterceptor({'Content-Type': 'application/json'}),
        AuthHeadersInterceptor(),
        (Response response) async {
          if (response.statusCode == 401) {
            AuthService.deleteAll();
          }
          return response;
        }
      ],
    );
    return _$FlTypesApiService(client);
  }
}

class AuthHeadersInterceptor implements RequestInterceptor {
  static const String HEADER = 'access-token';

  @override
  FutureOr<Request> onRequest(Request request) async {
    // Map<String, String?> headers = request.headers;

    try {
      final String? jwt = await AuthService.getJwt();
      return applyHeader(request, HEADER, jwt);
    } finally {}
  }
}
