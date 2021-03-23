import 'package:fitness_logger_app/providers.dart';
import 'package:fitness_logger_app/router_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_logger_app/fl_theme_data.dart';

void main() => runApp(
      MultiProvider(
        providers: generateProviders(),
        child: MaterialApp(
          title: 'Fitness Logger',
          theme: generateThemeData(),
          initialRoute: '/',
          navigatorKey: navigatorKey,
          onGenerateRoute: RouterGenerator.generateRoute,
        ),
      ),
    );
