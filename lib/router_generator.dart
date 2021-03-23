import 'package:fitness_logger_app/pages/types/fl_create_type_page.dart';
import 'package:fitness_logger_app/pages/fl_home_page.dart';
import 'package:fitness_logger_app/pages/fl_root_page.dart';
import 'package:fitness_logger_app/pages/fl_jwt_page.dart';
import 'package:fitness_logger_app/pages/types/fl_types_list_page.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => FlRootPage());
      case '/jwt':
        return MaterialPageRoute(builder: (_) => JwtPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => FlHomePage());
      case '/types':
        return MaterialPageRoute(builder: (_) => FlTypesListPage());
      case '/types/create':
        return MaterialPageRoute(builder: (_) => FlCreateTypePage());
      default:
        return _errorRoute();
    }
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
