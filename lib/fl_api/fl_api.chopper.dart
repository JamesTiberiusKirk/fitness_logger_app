// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fl_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$FlAuthService extends FlAuthService {
  _$FlAuthService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = FlAuthService;

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
