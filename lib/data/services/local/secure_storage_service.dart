import 'package:flutter_provider_local_save/configs/getit_config.dart';
import 'package:flutter_provider_local_save/utils/result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // we use a singleton pattern to ensure only one instance of this service exists
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  factory SecureStorageService() {
    return _instance;
  }

  SecureStorageService._internal();

  Future<Result<void>> saveData(String key, String value) async {
    try {
      await locator<FlutterSecureStorage>().write(key: key, value: value);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> readData(String key) async {
    try {
      final value = await locator<FlutterSecureStorage>().read(key: key);
      return Result.ok(value);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> deleteData(String key) async {
    try {
      await locator<FlutterSecureStorage>().delete(key: key);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
