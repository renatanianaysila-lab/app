import 'package:flutter/material.dart';
import 'package:app/pages/splash_screen.dart';
import 'package:app/pages/login_screen.dart';
import 'package:app/pages/sign_up_page.dart';
import 'package:app/pages/forgot_password_page.dart';
import 'package:app/pages/role_page.dart';
import 'package:app/pages/main_navigation.dart'; // 🔥 1. Import file navigasi baru kita
import 'auth_route.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String dashboard = '/dashboard'; // 🔥 2. Tambahkan string rute dashboard baru

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case AuthRoute.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case AuthRoute.signUp:
        return MaterialPageRoute(
          builder: (_) => const SignUpPage(),
          settings: settings,
        );

      case AuthRoute.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordPage(),
          settings: settings,
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const RolePage(),
          settings: settings,
        );

      // 🔥 3. Daftarkan rute dashboard agar mengarah ke MainNavigation
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const MainNavigation(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route tidak ditemukan: ${settings.name}'),
            ),
          ),
        );
    }
  }
}