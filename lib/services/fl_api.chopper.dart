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

class _$FlTGroupsApiService extends FlTGroupsApiService {
  _$FlTGroupsApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = FlTGroupsApiService;

  Future<Response> getAll() {
    final $url = '/tracking/group/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getById(String tgId) {
    final $url = '/tracking/group/';
    final Map<String, dynamic> $params = {'tgId': tgId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> start(Map<String, String> body) {
    final $url = '/tracking/group/start/';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> stop(String tgId) {
    final $url = '/tracking/group/stop/';
    final Map<String, dynamic> $params = {'tgId': tgId};
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> updateGroup(FlGroup flGroup) {
    final $url = '/tracking/group/';
    final $body = flGroup;
    final $request = Request('PUT', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> deleteGroup(String tgId) {
    final $url = '/tracking/group/';
    final Map<String, dynamic> $params = {'tgId': tgId};
    final $request =
        Request('DELETE', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }
}

class _$FlTPointsApiService extends FlTPointsApiService {
  _$FlTPointsApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = FlTPointsApiService;

  Future<Response> getByTgId(String tgId) {
    final $url = '/tracking/point/';
    final Map<String, dynamic> $params = {'tgId': tgId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getByTpTypeId(String tpTypeId) {
    final $url = '/tracking/point/';
    final Map<String, dynamic> $params = {'tpTypeId': tpTypeId};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> createTrackingPoint(FlTrackingPoint trackingPoint) {
    final $url = '/tracking/point/';
    final $body = trackingPoint;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> deleteTrackingPoint(String tpId) {
    final $url = '/tracking/point/';
    final Map<String, dynamic> $params = {'tp_id': tpId};
    final $request =
        Request('DELETE', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> addSet(String tpId, FlSet setToAdd) {
    final $url = '/tracking/point/set/';
    final Map<String, dynamic> $params = {'tpId': tpId};
    final $body = setToAdd;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> updateSet(String tpId, FlSet setToAdd) {
    final $url = '/tracking/point/set/';
    final Map<String, dynamic> $params = {'tpId': tpId};
    final $body = setToAdd;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }
}
