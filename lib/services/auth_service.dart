import 'package:fitness_logger_app/models/user.dart';
import 'package:fitness_logger_app/pages/fl_home_page.dart';
import 'package:fitness_logger_app/pages/fl_loading_page.dart';
import 'package:fitness_logger_app/pages/fl_login_page.dart';
import 'package:fitness_logger_app/router_generator.dart';
import 'package:fitness_logger_app/services/fl_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoreKeys {
  static final String jwt = 'JWT';
}

class AuthService {
  FlAuthApiService flAuthApiService;

  AuthService(this.flAuthApiService);

  Future<bool> login(User user) async {
    print(user);
    try {
      var res = await flAuthApiService.login(user);
      if (res.statusCode == 200) {
        print(res.body['jwt']);
        await storeJwt(res.body['jwt']);
        return Future.value(true);
      } else if (res.statusCode == 401) {
        return Future.value(false);
      } else {
        print('error in else');
        var code = res.statusCode;
        return Future.error('Error from API: $code');
      }
    } catch (err) {
      print('error in catch');
      print(err.toString());
      return Future.error(err.toString());
      // return Future.value(false);
    }
  }

  static FutureBuilder authGuard({Widget? page}) {
    return FutureBuilder(
      future: AuthService.getJwt(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return FlLoadingPage();
        } else if (snapshot.hasData) {
          return page != null ? page : FlHomePage();
        }
        return FlLoginPage();
      },
    );
  }

  static Future<void> storeJwt(String jwt) async {
    final storage = new FlutterSecureStorage();
    return storage.write(key: StoreKeys.jwt, value: jwt);
  }

  static Future<String?> getJwt() async {
    final storage = new FlutterSecureStorage();
    return storage.read(key: StoreKeys.jwt);
  }

  static Future deleteAll() async {
    navigatorKey.currentState!.pushNamed('/');
    final storage = new FlutterSecureStorage();
    return await storage.deleteAll();
  }
}
