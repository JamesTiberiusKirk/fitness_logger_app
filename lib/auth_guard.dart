import 'package:fitness_logger_app/fl_secure_storage/fl_secure_storage.dart';
import 'package:fitness_logger_app/pages/fl_jwt_page.dart';
import 'package:fitness_logger_app/pages/fl_loading_page.dart';
import 'package:fitness_logger_app/pages/fl_login_page.dart';
import 'package:flutter/material.dart';
import 'package:fitness_logger_app/services/fl_secure_storage.dart';

FutureBuilder<String?> authGuard(Widget page) {
  return FutureBuilder(
    future: getJwt(),
    builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
      if(snapshot.data!.isEmpty){ // not logged in
        return FlLoginPage();
      } else if (snapshot.data!.isEmpty) { // logged in
        return JwtPage();
      } else { // neither/loading
        return FlLoadingPage();
      }
    },
  );
}
