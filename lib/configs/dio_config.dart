import 'package:dio/dio.dart';
import 'package:flutter_provider_local_save/configs/interceptor/auth_interceptor.dart';

class DioConfig {
  static final DioConfig _instance = DioConfig._internal();
  factory DioConfig() => _instance;
  DioConfig._internal();

  static DioConfig get instance => _instance;

  final Map<String, Dio> _dioInstances = {};

  Dio getDioInstance(String baseUrl, {String? identifier}) {
    final key = identifier ?? baseUrl;

    if (!_dioInstances.containsKey(key)) {
      _dioInstances[key] = _createDio(baseUrl);
    }

    return _dioInstances[key]!;
  }

  Dio _createDio(String baseUrl) {
    final dio = Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => print(object),
      ),
    );

    // Add interceptors here
    return dio;
  }
}
