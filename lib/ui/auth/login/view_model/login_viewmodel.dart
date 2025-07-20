import 'package:flutter/foundation.dart';
import 'package:flutter_provider_local_save/configs/getit_config.dart';
import 'package:flutter_provider_local_save/data/repositories/auth/auth_repository.dart';
import 'package:flutter_provider_local_save/data/services/api/api_service.dart';
import 'package:flutter_provider_local_save/data/services/local/secure_storage_service.dart';
import 'package:flutter_provider_local_save/ui/error/viewmodel/error_viewmodel.dart';
import 'package:flutter_provider_local_save/utils/constant.dart';
import 'package:flutter_provider_local_save/utils/result.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepositoryDummyBase = AuthRepository(
    userApi: ApiService.getUserApi(baseUrl: KUrls.DUMMY_BASE),
  );

  bool? _isAuthenticated;

  Future<void> fetchToken() async {
    final result = await SecureStorageService().readData(
      KSecureStorageKeys.ACCESS_TOKEN,
    );
    switch (result) {
      case Ok(value: final accessToken):
        {
          _isAuthenticated = accessToken != null;
          break;
        }
      case Error(error: final e):
        locator<ErrorViewModel>().setError(e);
        _isAuthenticated = false;
        break;
    }
  }

  Future<bool> get isAuthenticated async {
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    await fetchToken();
    return _isAuthenticated ?? false;
  }

  Future<bool> login(String username, String password) async {
    final result = await _authRepositoryDummyBase.login(username, password);
    switch (result) {
      case Ok(value: final loginResponse):
        {
          await SecureStorageService().saveData(
            KSecureStorageKeys.ACCESS_TOKEN,
            loginResponse.accessToken,
          );
          await SecureStorageService().saveData(
            KSecureStorageKeys.REFRESH_TOKEN,
            loginResponse.refreshToken,
          );
          _isAuthenticated = true;
          break;
        }
      case Error(error: final e):
        locator<ErrorViewModel>().setError(e);
        break;
    }
    notifyListeners();
    return true;
  }
}
