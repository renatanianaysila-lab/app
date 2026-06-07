import 'package:flutter/material.dart';
import 'package:app/routes/index.dart';

// ── IMPORT HALAMAN UNTUK CADANGAN BYPASS ──
import 'package:app/pages/login_screen.dart';       // File Login Screen
import 'package:app/pages/role_page.dart';          // Halaman Pilih Role
import 'package:app/pages/main_navigation.dart';    // Navigasi & Beranda Murid
import 'package:app/pages/main_navigation_guru.dart';// Navigasi & Beranda Guru
import 'package:app/pages/beranda_admin.dart';       // Beranda Admin

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

      // 🔥 GLOBAL FONT
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5F8DFF),
        ),
        useMaterial3: true,
      ),

      // ====================================================================
      // 🚀 SEKARANG DI-BYPASS LANGSUNG KE BERANDA MURID (ANTI-ERROR SERVER)
      // ====================================================================
      // Kode rute resmi dimatikan sementara agar kamu tidak perlu login/fetch server.
      
      //home: const MainNavigation(initialIndex: 0), // <── LANGSUNG JALAN KE BERANDA MURID

      // ====================================================================
      // 🛠️ MENU CADANGAN LAINNYA (Tinggal pindahkan tanda // jika butuh)
      // ====================================================================
      
      // initialRoute: AppRoutes.splash,             // Kembalikan ke Jalur Resmi (Splash)
      // onGenerateRoute: AppRoutes.generateRoute,   // Pasangan Jalur Resmi (Splash)
      
      // home: const LoginScreen(),                  // Cadangan: Langsung ke Halaman Login
      // home: const RolePage(),                     // Cadangan: Langsung ke Pilihan Role
      home: const MainNavigationGuru(initialIndex: 0), // Cadangan: Langsung ke Beranda Guru
      // home: const BerandaAdmin(),                  // Cadangan: Langsung ke Beranda Admin
    );
  }
}