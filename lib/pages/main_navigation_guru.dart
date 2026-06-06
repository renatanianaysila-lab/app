import 'package:flutter/material.dart';
import 'beranda_guru.dart'; // Pastikan nama file beranda gurumu sesuai ya
import 'progres_guru_page.dart'; // File progres yang kita buat tadi
import 'profil_guru_page.dart';

class MainNavigationGuru extends StatefulWidget {
  final int initialIndex;
  const MainNavigationGuru({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationGuru> createState() => _MainNavigationGuruState();
}

class _MainNavigationGuruState extends State<MainNavigationGuru> {
  late int _currentIndex;

  
  final List<Widget> _pages = [
    const BerandaGuruMain(), // Index 0: Tampilan Awal Dashboard Guru kamu
    const Center(child: Text("Halaman Materi Guru")), // Index 1: Sisa kk kelompokmu
    const Center(child: Text("Halaman Forum Guru")),  // Index 2: Sisa kk kelompokmu
    const ProgresGuruPage(),                          // Index 3: Kodingan Progres kita tadi!
    const Center(child: Text("Halaman Profil Guru")), // Index 4: Sisa kk kelompokmu
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFD4A373),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Materi"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Forum"),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: "Progres"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}