import 'package:flutter/material.dart';
import 'package:app/pages/splash_screen.dart';
import 'package:app/pages/login_screen.dart';
import 'package:app/pages/sign_up_page.dart';
import 'package:app/pages/forgot_password_page.dart';
import 'package:app/pages/konten_screen.dart'; 
import 'auth_route.dart';
import 'package:app/pages/role_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String konten = '/konten'; // ← tambah

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
        final role = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => SignUpPage(role: role),
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
      case konten: // ← tambah
        return MaterialPageRoute(
          builder: (_) => const KontenScreen(),
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
