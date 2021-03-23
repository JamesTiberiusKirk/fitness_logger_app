import 'package:fitness_logger_app/router_generator.dart';
import 'package:fitness_logger_app/widgets/drawer.dart';
import 'package:flutter/material.dart';

class FlHomePage extends StatelessWidget {
  Widget _buildCreateTypeButton(context) {
    return ElevatedButton(
      onPressed: () {
        navigatorKey.currentState!.pushNamed('/types');
      },
      child: Text('Types'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: generateDrawer(),
      appBar: AppBar(title: Text('Home')),
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          children: <Widget>[
            _buildCreateTypeButton(context),
          ],
        ),
      ),
    );
  }
}
