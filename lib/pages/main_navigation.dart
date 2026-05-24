import 'package:flutter/material.dart';
import 'beranda_murid.dart';
import 'materi_murid.dart';
import 'riwayat_page.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // List halaman sesuai dengan urutan tombol di bottom navbar figma kamu
  final List<Widget> _pages = [
    const BerandaMurid(),
    const MateriMurid(),
    const Scaffold(body: Center(child: Text('Halaman Forum'))), // Dummy Forum
    const RiwayatPage(),
    const DummyProfilPage(), // Memakai class dummy profil di bawah
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2F66E7),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/home.png', width: 24, height: 24, color: _currentIndex == 0 ? const Color(0xFF2F66E7) : Colors.grey),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/materinavbar.png', width: 24, height: 24, color: _currentIndex == 1 ? const Color(0xFF2F66E7) : Colors.grey),
            label: 'Materi',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/forum.png', width: 24, height: 24, color: _currentIndex == 2 ? const Color(0xFF2F66E7) : Colors.grey),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/history.png', width: 24, height: 24, color: _currentIndex == 3 ? const Color(0xFF2F66E7) : Colors.grey),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/profile.png', width: 24, height: 24, color: _currentIndex == 4 ? const Color(0xFF2F66E7) : Colors.grey),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// --- CLASS HALAMAN PROFIL (Sesuai gambar Figma kamu) ---
class DummyProfilPage extends StatelessWidget {
  const DummyProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black87),
        title: const Text('Profil Saya', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Foto Profil
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.amber[200],
                    backgroundImage: const AssetImage('assets/images/murid.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Color(0xFF2F66E7), shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text('Naysila', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('naysila@student.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_square, size: 16, color: Colors.white),
              label: const Text('Edit Profil', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F66E7),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),
            
            // Informasi Pribadi Card
            _buildSectionTitle('Informasi Pribadi'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildProfileItem(Icons.person_outline, 'Nama Lengkap', 'Naysila'),
                  const Divider(),
                  _buildProfileItem(Icons.mail_outline, 'Email', 'naysila@student.com'),
                  const Divider(),
                  _buildProfileItem(Icons.phone_outlined, 'No. Telepon', '+62 812 3456 7890'),
                  const Divider(),
                  _buildProfileItem(Icons.calendar_today_outlined, 'Tanggal Lahir', '15 Maret 2005'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Paket Aktif Card
            _buildSectionTitle('Paket Aktif'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2F66E7), Color(0xFFF2C94C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('👑 Paket Premium', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(4)),
                        child: const Text('Aktif', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildPremiumCheck('Akses semua materi pembelajaran'),
                  _buildPremiumCheck('Sertifikat digital'),
                  _buildPremiumCheck('Konsultasi dengan mentor'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Berlaku hingga\n15 Maret 2026', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF2F66E7)),
                        child: const Text('Perpanjang', style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Tombol Keluar
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Keluar dari Akun', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFFEAEA)),
                  backgroundColor: const Color(0xFFFFF5F5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: const Color(0xFFE8F0FE), radius: 18, child: Icon(icon, color: const Color(0xFF2F66E7), size: 18)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
        const Spacer(),
        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ],
    );
  }

  Widget _buildPremiumCheck(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}