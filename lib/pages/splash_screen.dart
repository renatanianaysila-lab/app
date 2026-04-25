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
        child: SafeArea(
          child: Column(
            children: [

              const Spacer(),

              // LOGO
              Image.asset(
                'assets/images/logo.png',
                width: 90,
              ),

              const SizedBox(height: 16),

              // TITLE
              const Text(
                'IsyaratKita',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 10),

              // GARIS
              Container(
                width: 90,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.yellow],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // DESKRIPSI
              const Text(
                'Belajar Bahasa Isyarat dengan\nMudah dan Inklusif',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              // DOTS
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 4, backgroundColor: Colors.blue),
                  SizedBox(width: 12),
                  CircleAvatar(radius: 4, backgroundColor: Colors.blueAccent),
                  SizedBox(width: 12),
                  CircleAvatar(radius: 4, backgroundColor: Colors.amber),
                ],
              ),

              const Spacer(),

              // GAMBAR BAWAH
              Image.asset(
                'assets/images/img.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}