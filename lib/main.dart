// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:fitness_logger_app/pages/fl_login_page.dart';
import 'package:fitness_logger_app/fl_api/fl_api.dart';
import 'package:provider/provider.dart';

import 'fl_secure_storage/fl_secure_storage.dart';

void main() => runApp(
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FlRoot(),
        routes: <String, WidgetBuilder>{
          '/jwt': (BuildContext _c) => JwtPage(),
        },
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

class JwtPage extends StatefulWidget {
  @override
  JwtPageState createState() => JwtPageState();
}

class JwtPageState extends State<JwtPage> {
  Future<String?>? _jwt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jwt Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: <Widget>[
              FutureBuilder<String?>(
                future: _jwt,
                builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  return Text(
                    '${snapshot.data}',
                    style: Theme.of(context).textTheme.headline4,
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _jwt = getJwt();
                    print(_jwt);
                  });
                },
                child: Text('Get JWT'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
                child: Text('Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
