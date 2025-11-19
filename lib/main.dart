import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/database/models/book.dart';
import 'package:instant_tale/network/http.dart';
import 'package:instant_tale/ui/page/forget_password_page.dart';
import 'package:instant_tale/ui/page/login_page.dart';
import 'package:instant_tale/ui/page/main_page.dart';
import 'package:instant_tale/ui/page/register_page.dart';
import 'package:instant_tale/ui/theme.dart';

import 'features/book/book_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppGlobals().init();
  Http.init();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router, theme: AppTheme.light);
  }
}

class AppRouteNames {
  static const String login = 'login';
  static const String register = 'register';
  static const String forgetPassword = 'forget-password';
  static const String main = 'main';
  static const String homeTab = 'home-tab';
  static const String myTab = 'my-tab';
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) {
        return AppGlobals().isLoggedIn
            ? '/${AppRouteNames.main}'
            : '/${AppRouteNames.login}';
      },
    ),
    GoRoute(
      path: '/${AppRouteNames.login}',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/${AppRouteNames.register}',
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: '/${AppRouteNames.forgetPassword}',
      builder: (context, state) => ForgetPasswordPage(),
    ),
    GoRoute(
      path: '/${AppRouteNames.main}',
      builder: (context, state) => MainPage(),
    ),
  ],
);
