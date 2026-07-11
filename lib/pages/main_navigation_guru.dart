// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'beranda_guru.dart'; 
import 'materi_guru.dart'; 
import 'progres_guru_page.dart'; 
import 'profil_guru_page.dart';
import 'forum_page.dart';

class MainNavigationGuru extends StatefulWidget {
  final int initialIndex;
  const MainNavigationGuru({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationGuru> createState() => _MainNavigationGuruState();
}

class _MainNavigationGuruState extends State<MainNavigationGuru> {
  late int _currentIndex;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    
    String currentGuruId = 'G0001'; 
    String currentUsernameGuru = '@budi_guru'; 

    _pages = [
      // Index 0: Beranda
      BerandaGuruMain(
        onChangeTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

      // Index 1: Materi
      MateriGuruPage(
        guruId: currentGuruId,
      ),

      // Index 2: Forum
      const ForumPage(),

      // Index 3: Progres
      const ProgresGuruPage(),

      // Index 4: Profil
      const ProfilGuruPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFFB703), 
        unselectedItemColor: const Color(0xFF9CA3AF),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; 
          });
        },
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins', fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins', fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 24), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment, size: 24), label: 'Materi'),
          BottomNavigationBarItem(icon: Icon(Icons.chat, size: 24), label: 'Forum'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up, size: 24), label: 'Progres'),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 24), label: 'Profil'),
        ],
      ),
    );
  }
}
