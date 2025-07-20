import 'package:dio/dio.dart';
import 'package:flutter_provider_local_save/domain/models/user/login_request_model.dart';
import 'package:flutter_provider_local_save/domain/models/user/login_response_model.dart';
import 'package:flutter_provider_local_save/domain/models/user/user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  @POST('/auth/login')
  Future<LoginResponseModel> login(@Body() LoginRequestModel request);
  @GET('/users')
  Future<dynamic> getUsers();
}
