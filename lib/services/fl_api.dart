import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:fitness_logger_app/fl_secure_storage/fl_secure_storage.dart';
import 'package:fitness_logger_app/models/user.dart';
import 'package:http/http.dart' as http;

part 'fl_api.chopper.dart';

// final String serverHost = 'localhost:80';
// const String serverHost = '192.168.100.24:80';
const String serverHost = 'http://api.logger.fitness';

class UriPaths {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyMe = '/auth/verify_me';
}

Future<bool> flLogin(User user) async {
  var res = await http.post(Uri.http(serverHost, UriPaths.login),
      body: user.toJson(), encoding: Encoding.getByName('application/json'));

  if (res.statusCode == 200) {
    var resBody = json.decode(res.body);
    await storeJwt(resBody['jwt']);
    print(resBody['jwt']);
    print('jwt added');
    return true;
  }
  return false;
}

Future<bool> flRegister(UserRegistration userReg) async {
  var res = await http.post(Uri.http(serverHost, UriPaths.register),
      body: userReg.toJson(), encoding: Encoding.getByName('application/json'));
  if (res.statusCode == 200) return true;
  return false;
}


@ChopperApi(baseUrl: '/auth')
abstract class FlAuthService extends ChopperService {

  @Post(path: '/login')
  Future<Response> login(@Body() User user);

  @Post(path: '/register')
  Future<Response> register(@Body() UserRegistration userReg);

  @Post(path: '/verify_me')
  Future<Response> vefiryMe(@Body() Map<String, String> jwt);

  static FlAuthService create(){
    final client = ChopperClient(
      baseUrl: 'http://api.logger.fitness:80',
      services: [
        _$FlAuthService(),
      ],
      converter: JsonConverter(),
    );
    return _$FlAuthService(client);
  }

}

// @ChopperApi(baseUrl: serverHost+'/types')
// abstract class FlTypesService extends ChopperService {

// }
