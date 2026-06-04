import 'package:flutter/material.dart';

class BerandaGuruMain extends StatefulWidget {
  const BerandaGuruMain({super.key});

  @override
  State<BerandaGuruMain> createState() => _BerandaGuruMainState();
}

class _BerandaGuruMainState extends State<BerandaGuruMain> {
  // Index navbar yang aktif (0: Beranda, 1: Materi)
  int _selectedIndex = 0;
  
  // State manajemen level (Sesuai seleramu: Dasar, Menengah, Lanjutan)
  String _selectedLevel = 'Dasar';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Shortcut Pintas: Klik 'Lihat Detail' di Beranda -> Pindah Tab ke Materi + Set Levelnya
  void _pindahKeMateri(String level) {
    setState(() {
      _selectedIndex = 1;      // Pindah tab aktif ke 'Materi' (Ikon bawah auto berubah kuning)
      _selectedLevel = level;  // Set filter level otomatis sesuai kelasnya
    });
  }

  @override
  Widget build(BuildContext context) {
    // List halaman utama agar Navigasi Bawah tetap stand by dan kelihatan berubah
    final List<Widget> _pages = [
      _buildBerandaScreen(),
      _buildMateriScreen(),
      const Center(child: Text('Halaman Forum', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold))),
      const Center(child: Text('Halaman Progres', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold))),
      const Center(child: Text('Halaman Profil', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold))),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(child: _pages[_selectedIndex]),
      
      // ─── BOTTOM NAVIGATION BAR (Selalu Kelihatan & Ikut Berubah Efeknya) ───
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFFB703),   // Kuning emas pas aktif
        unselectedItemColor: const Color(0xFF9CA3AF), // Abu-abu pas pasif
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontFamily: 'Poppins',
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          fontSize: 11,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 24),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, size: 24),
            label: 'Materi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, size: 24),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up, size: 24),
            label: 'Progres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded, size: 24),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SCREEN 1: TAMPILAN BERANDA UTAMA
  // ═══════════════════════════════════════════════════════════════════════════
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A1D2E),
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildKelasListHorizontal(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SCREEN 2: TAMPILAN HALAMAN MATERI (Look Murid, Versi Kelola Guru)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildMateriScreen() {
    return Column(
      children: [
        // Custom Header Bar Materi
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: const Text(
            'Materi Pembelajaran',
            style: TextStyle(
              color: Color(0xFF1A1D2E),
              fontWeight: FontWeight.w900,
              fontFamily: 'Poppins',
              fontSize: 18,
            ),
          ),
        ),
        
        // Search Bar Pencarian Materi
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.toLowerCase();
                });
              },
              decoration: const InputDecoration(
                hintText: 'Cari materi pembelajaran...',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontFamily: 'Poppins', fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Color(0xFF9CA3AF)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),

        // Tab Filter Level Pas Banget (Dasar, Menengah, Lanjutan)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildLevelTab('Dasar'),
              const SizedBox(width: 8),
              _buildLevelTab('Menengah'),
              const SizedBox(width: 8),
              _buildLevelTab('Lanjutan'),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Daftar Materi yang diajar sesuai Level Aktif (Tanpa Info Progress Persen)
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              if (_selectedLevel == 'Dasar') ...[
                _buildMateriListCard(
                  icon: '#',
                  title: 'Angka 1–10',
                  subTitle: '1 Video',
                  color: const Color(0xFFFFB703),
                  bgColor: const Color(0xFFFFFBEB),
                ),
                _buildMateriListCard(
                  icon: '😊',
                  title: 'Ekspresi',
                  subTitle: '5 Video',
                  color: const Color(0xFF00C48C),
                  bgColor: const Color(0xFFE8F9F3),
                ),
              ] else if (_selectedLevel == 'Menengah') ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      'Belum ada materi di tingkat Menengah.',
                      style: TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontSize: 13),
                    ),
                  ),
                ),
              ] else ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      'Belum ada materi di tingkat Lanjutan.',
                      style: TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ─── WIDGET DETAIL KOMPONEN BERANDA ───
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFEEF2FF),
            child: Icon(Icons.person_outline, color: Color(0xFF3B72FF), size: 28),
          ),
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
    final List<Map<String, dynamic>> klsData = [
      {'title': 'Angka 1–10', 'level': 'Dasar', 'ratio': '20/45', 'color': const Color(0xFFFFB703), 'bgColor': const Color(0xFFFFFBEB), 'img': 'assets/images/murid.png'},
      {'title': 'Ekspresi', 'level': 'Dasar', 'ratio': '20/45', 'color': const Color(0xFF00C48C), 'bgColor': const Color(0xFFE8F9F3), 'img': 'assets/images/guru.png'},
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
                    // SEKARANG KLIK LIHAT DETAIL LANGSUNG SWITCH TAB DAN IKUT MERUBAH NAVIGASI NYALA KUNING!
                    onPressed: () => _pindahKeMateri(kelas['level']),
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

  // ─── WIDGET DETAIL KOMPONEN HALAMAN MATERI ───
  Widget _buildLevelTab(String levelName) {
    final bool isActive = _selectedLevel == levelName;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLevel = levelName;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF3B72FF) : const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            levelName,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: isActive ? Colors.white : const Color(0xFF3B72FF), fontFamily: 'Poppins'),
          ),
        ),
      ),
    );
  }

  Widget _buildMateriListCard({required String icon, required String title, required String subTitle, required Color color, required Color bgColor}) {
    if (_searchQuery.isNotEmpty && !title.toLowerCase().contains(_searchQuery)) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBEB))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(icon, style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(subTitle, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF), fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_up_rounded, size: 16, color: Color(0xFF9CA3AF)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(10)),
                  child: Text(_selectedLevel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF3B72FF), fontFamily: 'Poppins')),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEBEBEB)),
          
          // List materi video & kuis (Murni Info Materi tanpa kemajuan/progress persen milik murid)
          _buildSubMateriRow(Icons.play_circle_fill_rounded, 'Dasar Bahasa Isyarat - $title', const Color(0xFF3B72FF)),
          _buildSubMateriRow(Icons.assignment_turned_in_rounded, 'Kuis Evaluasi: $title', const Color(0xFF00C48C)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSubMateriRow(IconData iconData, String text, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(iconData, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A1D2E), fontFamily: 'Poppins'))),
          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }
}