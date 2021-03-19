import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoreKeys {
  static final String jwt = 'JWT';
}

Future<void> storeJwt(String jwt) async {
  final storage = new FlutterSecureStorage();
  return storage.write(key: StoreKeys.jwt, value: jwt);
}

Future<String?> getJwt() async {
  final storage = new FlutterSecureStorage();
  return storage.read(key: StoreKeys.jwt);
}

Future deleteAll() {
  final storage = new FlutterSecureStorage();
  return storage.deleteAll();
}
