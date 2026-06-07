import 'package:flutter/material.dart';
import 'beranda_guru.dart'; 
import 'materi_guru.dart'; // 1. Pastikan file baru materi_guru.dart sudah di-import di sini 🎯
import 'progres_guru_page.dart'; 
import 'profil_guru_page.dart';

class MainNavigationGuru extends StatefulWidget {
  final int initialIndex;
  const MainNavigationGuru({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationGuru> createState() => _MainNavigationGuruState();
}

class _MainNavigationGuruState extends State<MainNavigationGuru> {
  late int _currentIndex;

  // 2. Daftarkan Class MateriGuruGayaMurid pada Index 1 (Tab Kedua) 🚀
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    
    _pages = [
      const BerandaGuruMain(),          // Index 0: Halaman Beranda Guru Bersih
      const MateriGuruPage(),      // Index 1: Mengarah ke file baru materi_guru.dart yang mirip murid! 🎯
      const Center(child: Text("Halaman Forum Guru", style: TextStyle(fontFamily: 'Poppins'))), // Index 2
      const ProgresGuruPage(),          // Index 3
      const ProfilGuruPage(),           // Index 4
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan IndexedStack agar state halaman tidak ter-reset saat berpindah tab
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFFB703), // Warna kuning emas navigasi gurumu
        unselectedItemColor: const Color(0xFF9CA3AF),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Logika saklar pemindah halaman terpusat 🎯
          });
        },
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins', fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins', fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 24), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment, size: 24), label: "Materi"),
          BottomNavigationBarItem(icon: Icon(Icons.chat, size: 24), label: "Forum"),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up, size: 24), label: "Progres"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded, size: 24), label: "Profil"),
        ],
      ),
    );
  }
}