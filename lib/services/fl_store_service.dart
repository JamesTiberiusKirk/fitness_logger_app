


import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoreKeys {
  static final String jwt = 'JWT';
}

abstract class FlStoreService {
  Future<String?> getJwt();
  Future<void> storeJwt(String jwt);
  Future<void> deleteJwt();
}

class FlStoreServiceMobile implements FlStoreService {
  Future<String?> getJwt(){
    final storage = new FlutterSecureStorage();
    return storage.read(key: StoreKeys.jwt);
  }
  Future<void> storeJwt(String jwt){
    final storage = new FlutterSecureStorage();
    return storage.write(key: StoreKeys.jwt, value: jwt);
  }
  Future<void> deleteJwt(){
    final storage = new FlutterSecureStorage();
    return storage.deleteAll();
  }
}

// class FlStoreServiceWeb implements FlStoreService {
//   Future<String?> getJwt(){

//   }
//   Future<String?> storeJwt(String jwt){

//   }
//   Future<void> deleteJwt(){
    
//   }
// }