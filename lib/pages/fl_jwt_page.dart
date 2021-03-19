import 'package:fitness_logger_app/services/fl_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
                builder:
                    (BuildContext context, AsyncSnapshot<String?> snapshot) {
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
                  onPressed: () async {
                    await deleteAll();
                  },
                  child: Text('delete')),
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
