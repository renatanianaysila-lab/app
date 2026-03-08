import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app/pages/login_screen.dart';

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
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
              Color(0xFFDCE6F1),
              Color(0xFFF6E9A6),
            ],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              const SizedBox(height: 80),

              // LOGO
              Image.asset(
                'assets/images/logo.png',
                width: 120,
              ),

              const SizedBox(height: 20),

              // NAMA APLIKASI
             const Text(
  'MY IsyaratKita',
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: 0.5,
    color: Color(0xFF2F3A45),
  ),
),

              const SizedBox(height: 8),

              // GARIS WARNA
              Container(
                width: 80,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4A7BD1),
                      Color(0xFFF2C94C),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // DESKRIPSI
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Belajar Bahasa Isyarat dengan\nMudah dan Inklusif",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // TITIK SLIDER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(Colors.blue),
                  const SizedBox(width: 8),
                  _dot(Colors.blue),
                  const SizedBox(width: 8),
                  _dot(Colors.amber),
                ],
              ),

              const Spacer(),

              // GAMBAR ORANG
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

  Widget _dot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}