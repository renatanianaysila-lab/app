import 'package:flutter/material.dart';
import 'package:app/routes/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IsyaratKita',
      debugShowCheckedModeBanner: false,

      // ── GLOBAL THEME CONFIGURATION ──
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5F8DFF),
        ),
        useMaterial3: true,
      ),

      // ── JALUR RUTE RESMI APLIKASI ──
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}