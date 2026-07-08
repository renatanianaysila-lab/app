import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEAF6FF),
              Color(0xFFFFF8C7),
            ],
          ),
        ),
        child: Column(
          children: [
            // Konten tengah pakai SafeArea
            SafeArea(
              bottom: false, // ← biarkan bawah bebas
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  Image.asset(
                    'assets/images/logo.png',
                    width: 96,
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'IsyaratKita',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                      letterSpacing: 0.3,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: 90,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4F8DFF),
                          Color(0xFFFFD21F),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Belajar Bahasa Isyarat dengan\nMudah dan Inklusif',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(radius: 4, backgroundColor: Color(0xFF3B82F6)),
                      SizedBox(width: 12),
                      CircleAvatar(radius: 4, backgroundColor: Color(0xFF60A5FA)),
                      SizedBox(width: 12),
                      CircleAvatar(radius: 4, backgroundColor: Color(0xFFFACC15)),
                    ],
                  ),
                ],
              ),
            ),

            // Spacer dorong gambar ke bawah
            const Spacer(),

            // Gambar nempel ke bawah tanpa SafeArea
            Image.asset(
              'assets/images/img.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ],
        ),
      ),
    );
  }
}
