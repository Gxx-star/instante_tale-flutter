import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/database/models/book.dart';
import 'package:instant_tale/network/http.dart';
import 'package:instant_tale/ui/page/book_reader_page.dart';
import 'package:instant_tale/ui/page/character_management_page.dart';
import 'package:instant_tale/ui/page/create_book.dart';
import 'package:instant_tale/ui/page/create_character.dart';
import 'package:instant_tale/ui/page/edit_profile_page.dart';
import 'package:instant_tale/ui/page/forget_password_page.dart';
import 'package:instant_tale/ui/page/login_page.dart';
import 'package:instant_tale/ui/page/main_page.dart';
import 'package:instant_tale/ui/page/register_page.dart';
import 'package:instant_tale/ui/page/storybook_plaza_page.dart';
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
  static const String editProfilePage = 'edit-profile-page';
  static const String bookSquare = 'book-square';
  static const String createBook = 'create-book';
  static const String createCharacter = 'create-character';
  static const String bookReader = 'book-reader';
  static const String characterManagementPage = 'character-management-page';
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
      path: '/${AppRouteNames.characterManagementPage}',
      builder: (context, state) => CharacterManagementPage(),
    ),
    GoRoute(
      path: '/${AppRouteNames.bookReader}',
      builder: (context, state) {
        return BookReaderPage();
      },
    ),
    GoRoute(
      path: '/${AppRouteNames.createCharacter}',
      builder: (context, state) => CreateCharacterPage(),
    ),
    GoRoute(
      path: '/${AppRouteNames.createBook}',
      builder: (context, state) => CreateBookPage(),
    ),
    GoRoute(
      path: '/${AppRouteNames.bookSquare}',
      builder: (context, state) => StorybookPlazaPage(),
    ),
    GoRoute(
      path: '/${AppRouteNames.editProfilePage}',
      builder: (context, state) => EditProfilePage(),
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
