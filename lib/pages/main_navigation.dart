import 'package:flutter/material.dart';

import 'beranda_murid.dart';
import 'materi_murid.dart';
import 'forum_page.dart' as forum;
import 'riwayat_page.dart';
import 'profile_page.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 4);
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const BerandaMurid(),
      const MateriMurid(),
      const forum.ForumPage(),
      const RiwayatPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _changeTab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2F66E7),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: [
          _buildNavItem(
            iconPath: 'assets/images/home.png',
            label: 'Beranda',
            index: 0,
          ),
          _buildNavItem(
            iconPath: 'assets/images/materinavbar.png',
            label: 'Materi',
            index: 1,
          ),
          _buildNavItem(
            iconPath: 'assets/images/forum.png',
            label: 'Forum',
            index: 2,
          ),
          _buildNavItem(
            iconPath: 'assets/images/navbarriwayat.png',
            label: 'Riwayat',
            index: 3,
          ),
          _buildNavItem(
            iconPath: 'assets/images/profile.png',
            label: 'Profil',
            index: 4,
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required String iconPath,
    required String label,
    required int index,
  }) {
    final bool isActive = _currentIndex == index;

    return BottomNavigationBarItem(
      icon: Image.asset(
        iconPath,
        width: 24,
        height: 24,
        color: isActive ? const Color(0xFF2F66E7) : Colors.grey,
        errorBuilder: (_, __, ___) {
          return Icon(
            Icons.circle,
            size: 24,
            color: isActive ? const Color(0xFF2F66E7) : Colors.grey,
          );
        },
      ),
      label: label,
    );
  }
}
