import 'dart:convert';
import 'package:dio/dio.dart';

class ApiEndPoint {
  static String auth = "/user/register";
}

class ApiService {
  final Dio _dio;

  static const String baseUrl =
      'https://backend-infra-200499489667.us-central1.run.app/';

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth tokens or logging here
          print('Request[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('Error[${e.response?.statusCode}] => MESSAGE: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    return await _dio.get(endpoint, queryParameters: params);
  }

  Future<Response> post(
    String endpoint, {
    required Map<String, dynamic> data,
  }) async {
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    return await _dio.put(endpoint, data: jsonEncode(data));
  }

  Future<Response> delete(String endpoint, {dynamic data}) async {
    return await _dio.delete(endpoint, data: jsonEncode(data));
  }
}
