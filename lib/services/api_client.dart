import 'package:dio/dio.dart';
import '../config/env.dart';
import 'token_storage.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

class ApiClient {
  static Dio? _dio;

  static Dio _instance() {
    if (_dio != null) return _dio!;
    final base = Env.apiBaseUrl.endsWith('/')
        ? Env.apiBaseUrl.substring(0, Env.apiBaseUrl.length - 1)
        : Env.apiBaseUrl;
    final dio = Dio(BaseOptions(
      baseUrl: base,
      contentType: 'application/json',
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    ));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final needsAuth = options.extra['auth'] != false;
        if (needsAuth) {
          final token = await TokenStorage.read();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        handler.next(options);
      },
    ));
    _dio = dio;
    return dio;
  }

  static dynamic _unwrap(Response res) {
    final body = res.data;
    final status = res.statusCode ?? 0;
    if (status >= 200 && status < 300) {
      return body is Map ? body['data'] : body;
    }
    final msg = body is Map && body['message'] != null
        ? body['message'].toString()
        : 'Request failed ($status)';
    throw ApiException(status, msg);
  }

  static Future<dynamic> _send(
    String method,
    String path, {
    Map<String, dynamic>? query,
    Object? body,
    bool auth = true,
  }) async {
    try {
      final res = await _instance().request(
        path,
        data: body,
        queryParameters: query,
        options: Options(method: method, extra: {'auth': auth}),
      );
      return _unwrap(res);
    } on DioException catch (e) {
      if (e.response != null) return _unwrap(e.response!);
      throw ApiException(0, e.message ?? 'Network error');
    }
  }

  static Future<dynamic> get(
    String path, {
    Map<String, String>? query,
    bool auth = true,
  }) =>
      _send('GET', path, query: query, auth: auth);

  static Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) =>
      _send('POST', path, body: body, auth: auth);

  static Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) =>
      _send('PATCH', path, body: body, auth: auth);
}
