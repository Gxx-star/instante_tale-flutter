import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/network/http.dart';
import 'package:instant_tale/ui/page/book_reader_page.dart';
import 'package:instant_tale/ui/page/character_management_page.dart';
import 'package:instant_tale/ui/page/create_book.dart';
import 'package:instant_tale/ui/page/create_character.dart';
import 'package:instant_tale/ui/page/edit_profile_page.dart';
import 'package:instant_tale/ui/page/forget_password_page.dart';
import 'package:instant_tale/ui/page/login_page.dart';
import 'package:instant_tale/ui/page/main_page.dart';
import 'package:instant_tale/ui/page/my_book_page.dart';
import 'package:instant_tale/ui/page/privacy_security_page.dart';
import 'package:instant_tale/ui/page/register_page.dart';
import 'package:instant_tale/ui/page/book_square_page.dart';
import 'package:instant_tale/ui/theme.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppGlobals().init();
  Http.init();
  await SentryFlutter.init((options) {
    options.dsn =
        'https://03af318b985646603bd4e28d1c40721b@o4510541825048577.ingest.us.sentry.io/4510541825376256';
    // Adds request headers and IP for users, for more info visit:
    // https://docs.sentry.io/platforms/dart/guides/flutter/data-management/data-collected/
    options.sendDefaultPii = true;
    options.enableUserInteractionTracing = false;
    options.enableAutoSessionTracking = false;
    options.maxBreadcrumbs = 50;
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1.0;
    // The sampling rate for profiling is relative to tracesSampleRate
    // Setting to 1.0 will profile 100% of sampled transactions:
    options.profilesSampleRate = 1.0;
  }, appRunner: () => runApp(SentryWidget(child: ProviderScope(child: MyApp()))));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 914),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) => MaterialApp.router(
        routerConfig: _router,
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
      ),
    );
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
  static const String privacySecurityPage = 'privacy-security-page';
  static const String setPasswordPage = 'set-password-page';
  static const String myBooksPage = 'my-books-page';
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
      path: '/${AppRouteNames.myBooksPage}',
      builder: (context, state) {
        return MyBooksPage();
      },
    ),
    GoRoute(
      path: '/${AppRouteNames.setPasswordPage}',
      builder: (context, state) => SetPasswordPage(),
    ),
    GoRoute(
      path: '/${AppRouteNames.privacySecurityPage}',
      builder: (context, state) => PrivacySecurityPage(),
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
      builder: (context, state) => BookSquarePage(),
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
