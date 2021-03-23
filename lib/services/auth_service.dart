import 'package:fitness_logger_app/models/user.dart';
import 'package:fitness_logger_app/pages/fl_home_page.dart';
import 'package:fitness_logger_app/pages/fl_loading_page.dart';
import 'package:fitness_logger_app/pages/fl_login_page.dart';
import 'package:fitness_logger_app/router_generator.dart';
import 'package:fitness_logger_app/services/fl_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class StoreKeys {
  static final String jwt = 'JWT';
}

class AuthService {
  FlAuthApiService flAuthApiService;

  AuthService(this.flAuthApiService);

  Future<bool> login(User user) async {
    try {
      var res = await flAuthApiService.login(user);
      if (res.statusCode == 200) {
        await storeJwt(res.body['jwt']);
        return Future.value(true);
      } else if (res.statusCode == 401) {
        return Future.value(false);
      } else {
        var code = res.statusCode;
        return Future.error('Error from API: $code');
      }
    } finally {}
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
    if (kIsWeb) {
      SharedPreferences.setMockInitialValues({});
      SharedPreferences storage = await SharedPreferences.getInstance();
      await storage.setString(StoreKeys.jwt, jwt);
      return;
    }
    final storage = new FlutterSecureStorage();
    return storage.write(key: StoreKeys.jwt, value: jwt);
  }

  static Future<String?> getJwt() async {
    if (kIsWeb) {
      SharedPreferences.setMockInitialValues({});
      SharedPreferences storage = await SharedPreferences.getInstance();
      String? jwt = storage.getString(StoreKeys.jwt);
      return Future.value(jwt);
    }
    final storage = new FlutterSecureStorage();
    return storage.read(key: StoreKeys.jwt);
  }

  static Future deleteAll() async {
    if (kIsWeb) {
      SharedPreferences.setMockInitialValues({});
      SharedPreferences storage = await SharedPreferences.getInstance();
      return await storage.remove(StoreKeys.jwt);
    }
    navigatorKey.currentState!.pushNamed('/');
    final storage = new FlutterSecureStorage();
    return await storage.deleteAll();
  }
}
