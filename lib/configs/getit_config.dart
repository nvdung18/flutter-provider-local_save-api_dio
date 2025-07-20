import 'package:flutter_provider_local_save/configs/error/error_handler.dart';
import 'package:flutter_provider_local_save/data/services/local/hive_service.dart';
import 'package:flutter_provider_local_save/data/services/network_handler.dart';
import 'package:flutter_provider_local_save/ui/error/viewmodel/error_viewmodel.dart';
import 'package:flutter_provider_local_save/ui/auth/login/view_model/login_viewmodel.dart';
import 'package:flutter_provider_local_save/ui/home/view_model/home_viewmodel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

class GetItConfig {
  static setup() async {
    // ViewModels
    locator.registerSingleton<LoginViewModel>(LoginViewModel());
    locator.registerSingleton<HomeViewModel>(HomeViewModel());

    // Network Handler
    locator.registerSingleton<NetworkHandler>(NetworkHandler());

    // Local storage
    await setSharedPreferences();
    await setSecureStorage();
    await setHiveService();
    // locator.registerSingleton<HiveService>(HiveService());

    // Error handling
    await setErrorHandle();
  }

  static Future<void> setSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    locator.registerSingleton<SharedPreferences>(sharedPreferences);
  }

  static Future<void> setSecureStorage() async {
    final flutterSecureStorage = FlutterSecureStorage();
    locator.registerSingleton<FlutterSecureStorage>(flutterSecureStorage);
  }

  static Future<void> setHiveService() async {
    locator.registerSingleton<HiveService>(HiveService());
  }

  static Future<void> setErrorHandle() async {
    locator.registerSingleton<ErrorHandler>(ErrorHandler());
    locator.registerSingleton<ErrorViewModel>(ErrorViewModel());
  }
}
