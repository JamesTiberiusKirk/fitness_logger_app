import 'package:fitness_logger_app/router_generator.dart';
import 'package:fitness_logger_app/services/auth_service.dart';
import 'package:flutter/material.dart';

Widget generateDrawer() {
  return Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text(
            'Fitness Logger',
            style: TextStyle(fontSize: 36),
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Home'),
          onTap: () {
            navigatorKey.currentState!.popUntil(ModalRoute.withName('/'));
          },
        ),
        ListTile(
          title: Text('Item 2'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                AuthService.deleteAll();
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ],
    ),
  );
  // return Drawer(
  //   child: Column(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: [
  //       ElevatedButton(
  //         onPressed: () {
  //           AuthService.deleteAll();
  //         },
  //         child: Text('Log Out'),
  //       )
  //     ],
  //   ),
  // );
}
