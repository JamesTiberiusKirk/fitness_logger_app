// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fl_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$FlAuthApiService extends FlAuthApiService {
  _$FlAuthApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = FlAuthApiService;

  Future<Response> login(User user) {
    final $url = '/auth/login';
    final $body = user;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> register(UserRegistration userReg) {
    final $url = '/auth/register';
    final $body = userReg;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> vefiryMe(Map<String, String> jwt) {
    final $url = '/auth/verify_me';
    final $body = jwt;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }
}

class _$FlTypesApiService extends FlTypesApiService {
  _$FlTypesApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = FlTypesApiService;

  Future<Response> getAll() {
    final $url = '/types/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getById(dynamic tpId) {
    final $url = '/types/';
    final Map<String, dynamic> $params = {'tp_id': tpId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getByTpName(dynamic tpName) {
    final $url = '/types/';
    final Map<String, dynamic> $params = {'tpName': tpName};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getByDescription(dynamic description) {
    final $url = '/types/';
    final Map<String, dynamic> $params = {'description': description};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future newType(FlType newType) {
    final $url = '/types/';
    final $body = newType;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send($request);
  }

  Future updateType(FlType updateType) {
    final $url = '/types/';
    final $body = updateType;
    final $request = Request('PUT', $url, client.baseUrl, body: $body);
    return client.send($request);
  }

  Future delete(String tpId) {
    final $url = '/types/';
    final Map<String, dynamic> $params = {'tp_id': tpId};
    final $request =
        Request('DELETE', $url, client.baseUrl, parameters: $params);
    return client.send($request);
  }
}
