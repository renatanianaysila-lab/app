// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'sign_up_page.dart';

class RolePage extends StatelessWidget {
  const RolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              const Text(
                "Pilih Role Anda",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Bergabunglah dengan IsyaratKita untuk pengalaman belajar bahasa isyarat yang inklusif",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 20),

              // ─── ROLE CARD MURID ─────────────────────────────────────────
              roleCard(
                imagePath: "assets/images/murid.png",
                colorTop: const Color(0xFF5B8DEF),
                title: "Murid",
                description:
                    "Akses materi bahasa isyarat dan kuis interaktif untuk meningkatkan kemampuan komunikasi Anda.",
                points: const [
                  "Materi pembelajaran lengkap",
                  "Kuis interaktif dan menarik",
                  "Lacak progres belajar Anda",
                ],
                buttonText: "Pilih Murid",
                buttonColor: const Color(0xFF5B8DEF),
                icon: Icons.school,
                  onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignUpPage(role: "murid"),
                        ),
                      );
                },
              ),

              const SizedBox(height: 20),

              // ─── ROLE CARD GURU ───────────────────────────────────────────
              roleCard(
                imagePath: "assets/images/guru.png",
                colorTop: const Color(0xFFF4C542),
                title: "Guru",
                description:
                    "Kelola materi pembelajaran dan pantau aktivitas murid untuk pengalaman mengajar yang efektif.",
                points: const [
                  "Buat dan kelola materi",
                  "Pantau progres murid",
                  "Dashboard analitik lengkap",
                ],
                buttonText: "Pilih Guru",
                buttonColor: const Color(0xFFF4C542),
                icon: Icons.menu_book_rounded,
                  onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignUpPage(role: "guru"),
                        ),
                      );
                },
              ),

              const SizedBox(height: 20),

              // ─── ROLE CARD ADMIN ──────────────────────────────────────────
              roleCard(
                imagePath: "assets/images/admin.png",
                colorTop: const Color(0xFF4CAF7D),
                title: "Admin",
                description:
                    "Kelola seluruh konten, pengguna, dan pantau aktivitas platform IsyaratKita.",
                points: const [
                  "Kelola konten & materi",
                  "Manajemen pengguna",
                  "Pantau laporan & aktivitas",
                ],
                buttonText: "Pilih Admin",
                buttonColor: const Color(0xFF4CAF7D),
                icon: Icons.admin_panel_settings,
                  onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignUpPage(role: "admin"),
                        ),
                      );
                    },
                  ),

              const SizedBox(height: 20),

              // ─── INFORMASI PENTING ────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "Informasi Penting",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Anda dapat mengubah role kapan saja melalui pengaturan akun.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget roleCard({
    required String imagePath,
    required Color colorTop,
    required String title,
    required String description,
    required List<String> points,
    required String buttonText,
    required Color buttonColor,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: colorTop,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                height: 120,
                errorBuilder: (_, __, ___) {
                  return Icon(
                    icon,
                    size: 80,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              CircleAvatar(
                backgroundColor: colorTop.withOpacity(0.2),
                child: Icon(icon, color: colorTop),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            description,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),

          const SizedBox(height: 10),

          Column(
            children: points
                .map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: colorTop, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(point)),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(buttonText),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
