import 'package:dio/dio.dart';
import 'package:flutter_provider_local_save/configs/getit_config.dart';
import 'package:flutter_provider_local_save/utils/constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await locator<FlutterSecureStorage>().read(
      key: KSecureStorageKeys.ACCESS_TOKEN,
    ); // Đổi thành async
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await locator<FlutterSecureStorage>().delete(
        key: KSecureStorageKeys.ACCESS_TOKEN,
      );
      // Navigate to login or refresh token
    }
    handler.next(err);
  }
}
