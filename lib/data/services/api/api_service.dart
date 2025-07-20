import 'package:dio/dio.dart';
import 'package:flutter_provider_local_save/configs/dio_config.dart';
import 'package:flutter_provider_local_save/data/services/api/post/post_api.dart';
import 'package:flutter_provider_local_save/data/services/api/user/user_api.dart';

class ApiService {
  static final Map<String, dynamic> _serviceInstances = {};

  static T getService<T>(
    String serviceKey,
    Dio dioInstance,
    T Function(Dio) serviceFactory,
  ) {
    if (!_serviceInstances.containsKey(serviceKey)) {
      _serviceInstances[serviceKey] = serviceFactory(dioInstance);
    }
    return _serviceInstances[serviceKey] as T;
  }

  static UserApi getUserApi({required String baseUrl}) {
    final dio = DioConfig.instance.getDioInstance(baseUrl);

    return getService<UserApi>('UserApi_$baseUrl', dio, (dio) => UserApi(dio));
  }

  static PostApi getPostApi({required String baseUrl}) {
    final dio = DioConfig.instance.getDioInstance(baseUrl);

    return getService<PostApi>('PostApi_$baseUrl', dio, (dio) => PostApi(dio));
  }
}
