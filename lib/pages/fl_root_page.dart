import 'package:fitness_logger_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class FlRootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthService.authGuard(),
    );
  }
}
