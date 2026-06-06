import 'package:flutter/material.dart';
import 'detail_kelas_guru.dart';

class BerandaGuruMain extends StatefulWidget {
  const BerandaGuruMain({super.key});

  @override
  State<BerandaGuruMain> createState() => _BerandaGuruMainState();
}

class _BerandaGuruMainState extends State<BerandaGuruMain> {
  int _selectedIndex = 0;
  
  // State untuk mengontrol sub-halaman di dalam Tab Beranda
  String _currentSubPage = 'beranda'; // 'beranda' atau 'detail'
  String _selectedClassName = 'Angka 1–10';
  String _selectedClassLevel = 'Dasar';

  @override
  Widget build(BuildContext context) {
    // Menentukan isi konten untuk Tab Beranda (Index 0)
    Widget berandaContent;
    if (_currentSubPage == 'detail') {
      berandaContent = DetailKelasGuru(
        className: _selectedClassName,
        classLevel: _selectedClassLevel,
        onBack: () {
          setState(() {
            _currentSubPage = 'beranda';
          });
        },
      );
    } else {
      berandaContent = _buildBerandaScreen();
    }

    // List halaman utama berdasarkan index navbar
    final List<Widget> _pages = [
      berandaContent, // Tab Beranda bisa berubah jadi Detail tanpa menghilangkan Navbar
      const Center(child: Text('Halaman Materi', style: TextStyle(fontFamily: 'Poppins'))),
      const Center(child: Text('Halaman Forum', style: TextStyle(fontFamily: 'Poppins'))),
      const Center(child: Text('Halaman Progres', style: TextStyle(fontFamily: 'Poppins'))),
      const Center(child: Text('Halaman Profil', style: TextStyle(fontFamily: 'Poppins'))),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(child: _pages[_selectedIndex]),
    );
  }

  Widget _buildBerandaScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(),
          const SizedBox(height: 20),
          _buildSummaryCards(),
          const SizedBox(height: 20),
          _buildRatingBox(),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Kelas Saya!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1A1D2E), fontFamily: 'Poppins'),
            ),
          ),
          const SizedBox(height: 12),
          _buildKelasListHorizontal(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
      child: Row(
        children: [
          const CircleAvatar(radius: 24, backgroundColor: Color(0xFFEEF2FF), child: Icon(Icons.person_outline, color: Color(0xFF3B72FF), size: 28)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Halo, [Nama Guru] 👋', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
                Text('Kelola kelas dan pantau progres yuk!', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6B7280), fontFamily: 'Poppins')),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(12)),
            child: IconButton(icon: const Icon(Icons.notifications, color: Color(0xFF3B72FF)), onPressed: () {}),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildSingleSummaryCard(Icons.people_alt, '128 Siswa')),
          const SizedBox(width: 14),
          Expanded(child: _buildSingleSummaryCard(Icons.menu_book_rounded, '4 Kelas')),
        ],
      ),
    );
  }

  Widget _buildSingleSummaryCard(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFEBEBEB))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF1A1D2E), size: 22),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
        ],
      ),
    );
  }

  Widget _buildRatingBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEBEBEB))),
      child: Column(
        children: [
          const Align(alignment: Alignment.centerLeft, child: Text('Ulasan Guru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A1D2E), fontFamily: 'Poppins'))),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (index) => const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 36))),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_rounded, color: Color(0xFFFFA100), size: 14),
              SizedBox(width: 4),
              Text('4.6  (856 ulasan)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFFFA100), fontFamily: 'Poppins')),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEEF2FF), foregroundColor: const Color(0xFF3B72FF), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [Text('Lihat Detail Ulasan ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'Poppins')), Icon(Icons.arrow_forward_ios_rounded, size: 10)]),
          ),
        ],
      ),
    );
  }

  Widget _buildKelasListHorizontal() {
    // Data kelas menggunakan level kustom pilihanmu: Dasar & Menengah
    final List<Map<String, dynamic>> klsData = [
      {'title': 'Angka 1–10', 'level': 'Dasar', 'ratio': '20/45', 'color': const Color(0xFFFFB703), 'bgColor': const Color(0xFFFFFBEB), 'img': 'assets/images/murid.png'},
      {'title': 'Ekspresi', 'level': 'Menengah', 'ratio': '20/45', 'color': const Color(0xFF00C48C), 'bgColor': const Color(0xFFE8F9F3), 'img': 'assets/images/guru.png'},
    ];

    return SizedBox(
      height: 260,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: klsData.length,
        itemBuilder: (context, index) {
          final kelas = klsData[index];
          return Container(
            width: 180,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 95,
                  decoration: BoxDecoration(color: kelas['bgColor'], borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(kelas['img'], errorBuilder: (context, error, stackTrace) => Icon(Icons.class_outlined, color: kelas['color'].withOpacity(0.5), size: 40), fit: BoxFit.contain),
                ),
                const SizedBox(height: 10),
                Text(kelas['title'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
                const SizedBox(height: 2),
                Text('${kelas['level']} | ${kelas['ratio']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF), fontFamily: 'Poppins')),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedClassName = kelas['title'];
                        _selectedClassLevel = kelas['level'];
                        _currentSubPage = 'detail'; // Buka halaman detail materi tanpa menutup navbar bawah
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: kelas['color'], foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text('Lihat Detail', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, fontFamily: 'Poppins')),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}