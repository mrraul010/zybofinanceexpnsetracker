import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://appskilltest.zybotech.in',
        connectTimeout: Duration(seconds: 15),
        receiveTimeout: Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final requiresAuth = options.extra['requiresAuth'] ?? true;

          if (requiresAuth) {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('auth_token');

            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
           
            print('\x1B[33m[REQ] ${options.method} ${options.uri}\x1B[0m');
            if (options.data != null) {
              print('\x1B[33m[DATA] ${options.data}\x1B[0m');
            }
            return handler.next(options);
          },
          onResponse: (response, handler) {
         
            print(
              '\x1B[32m[RES] ${response.statusCode} ${response.requestOptions.uri}\x1B[0m',
            );
            print('\x1B[32m[BODY] ${response.data}\x1B[0m');
            return handler.next(response);
          },
          onError: (DioException e, handler) {
          
            print(
              '\x1B[31m[ERR] ${e.response?.statusCode} ${e.requestOptions.uri}\x1B[0m',
            );
            print('\x1B[31m[MSG] ${e.message}\x1B[0m');
            if (e.response?.data != null) {
              print('\x1B[31m[ERR BODY] ${e.response?.data}\x1B[0m');
            }
            return handler.next(e);
          },
        ),
      );
    }
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
    bool requiresAuth = true,
    bool isFormData = false,
  }) async {
    try {
      final dynamic requestData = (isFormData && data != null)
          ? FormData.fromMap(data)
          : data;
      final response = await _dio.post(
        path,
        data: requestData,

        options: Options(extra: {'requiresAuth': requiresAuth}),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> get(String path, {bool requiresAuth = true}) async {
    try {
      final response = await _dio.get(
        path,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future<Response> delete(
    String path, {
    Map<String, dynamic>? data,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
