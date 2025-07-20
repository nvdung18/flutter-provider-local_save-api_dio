import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_provider_local_save/configs/error/error_handler.dart';
import 'package:flutter_provider_local_save/configs/getit_config.dart';
import 'package:flutter_provider_local_save/data/services/local/hive_service.dart';
import 'package:flutter_provider_local_save/routing/router.dart';
import 'package:flutter_provider_local_save/ui/auth/login/view_model/login_viewmodel.dart';
import 'package:flutter_provider_local_save/ui/error/widgets/global_error_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await GetItConfig.setup();

  locator<ErrorHandler>().initialize();
  locator<HiveService>().init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => locator<LoginViewModel>(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'News App',
      routerConfig: router(locator<LoginViewModel>()),
      builder: (context, widget) => GlobalErrorScreen(child: widget!),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
