import 'package:flutter/material.dart';
import 'package:flutter_provider_local_save/configs/getit_config.dart';
import 'package:flutter_provider_local_save/routing/routes.dart';
import 'package:flutter_provider_local_save/ui/auth/login/view_model/login_viewmodel.dart';
import 'package:flutter_provider_local_save/ui/auth/login/widgets/login_screen.dart';
import 'package:flutter_provider_local_save/ui/core/ui/widget_tree.dart';
import 'package:flutter_provider_local_save/ui/home/widgets/home_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter router(LoginViewModel loginViewModel) => GoRouter(
  initialLocation: KRoutes.home,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: loginViewModel,
  routes: [
    GoRoute(
      path: KRoutes.login,
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: KRoutes.home,
      builder: (context, state) {
        return const WidgetTree();
      },
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final isAuthenticated = await locator<LoginViewModel>().isAuthenticated;
  final loggingIn = state.matchedLocation == KRoutes.login;

  if (isAuthenticated) {
    return !loggingIn ? null : KRoutes.home;
  }
  return loggingIn ? null : KRoutes.login;
}
