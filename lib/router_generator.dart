import 'package:fitness_logger_app/services/fl_secure_storage.dart';
import 'package:fitness_logger_app/main.dart';
import 'package:fitness_logger_app/pages/fl_jwt_page.dart';
import 'package:fitness_logger_app/pages/fl_login_page.dart';
import 'package:flutter/material.dart';


class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => FlRoot());
      case '/jwt':
        return MaterialPageRoute(builder: (_) => JwtPage());
      default:
        return _errorRoute();
    }
  }

  // static Route<dynamic> authGuard() async{
  //   final jwt = await getJwt();
  //   return MaterialPageRoute(builder: (_){
  //     return FlLoginPage();
  //   });
  // }
  
  static FutureBuilder<String?> authGuard(MaterialPageRoute page){
    return FutureBuilder(
      future: getJwt(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data.isEmpty) return page;
        return FlLoginPage();
      },
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
