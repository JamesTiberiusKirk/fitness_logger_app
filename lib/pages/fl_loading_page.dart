import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlLoadingPage extends StatelessWidget {
  // const FlLoadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Linear progress indicator with a fixed color',
              style: Theme.of(context).textTheme.headline6,
            ),
            CircularProgressIndicator(
              value: 15.5,
              semanticsLabel: 'Linear progress indicator',
            ),
          ],
        ),
      ),
    );
  }
}