import 'package:fitness_logger_app/router_generator.dart';
import 'package:flutter/material.dart';
import 'package:fitness_logger_app/pages/fl_login_page.dart';
import 'package:fitness_logger_app/services/fl_api.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: FlRoot(),
        initialRoute: '/',
        onGenerateRoute: RouterGenerator.generateRoute,
      ),
    );

class FlRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // FlAuthService Injection
        Provider<FlAuthService>(
          create: (_) => FlAuthService.create(),
          dispose: (_, FlAuthService service) => service.client.dispose(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fitness LoggerUpdate'),
          centerTitle: true,
        ),
        body: FlLoginPage(),
      ),
    );
  }
}
