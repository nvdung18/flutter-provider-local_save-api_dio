import 'package:flutter/foundation.dart';
import 'package:flutter_provider_local_save/configs/getit_config.dart';
import 'package:flutter_provider_local_save/data/services/api/user/user_api.dart';
import 'package:flutter_provider_local_save/data/services/network_handler.dart';
import 'package:flutter_provider_local_save/domain/models/user/login_request_model.dart';
import 'package:flutter_provider_local_save/domain/models/user/login_response_model.dart';
import 'package:flutter_provider_local_save/domain/models/user/user_model.dart';
import 'package:flutter_provider_local_save/utils/index.dart';
import 'package:flutter_provider_local_save/utils/result.dart';

class AuthRepository extends ChangeNotifier {
  final UserApi userApi;

  AuthRepository({required this.userApi});

  Future<Result<LoginResponseModel>> login(
    String username,
    String password,
  ) async {
    final request = LoginRequestModel(username: username, password: password);
    return await locator<NetworkHandler>().safeApiCall(
      () => userApi.login(request),
    );
  }

  Future<Result<List<UserModel>>> getUsers() async {
    return await locator<NetworkHandler>().safeApiCall<List<UserModel>>(
      () async => await userApi.getUsers(), // Đảm bảo trả về Future<dynamic>
      mapper: (data) =>
          Utils.parseListResponse<UserModel>(data, 'users', UserModel.fromJson),
    );
  }
}
