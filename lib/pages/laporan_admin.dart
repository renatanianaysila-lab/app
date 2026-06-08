import 'package:flutter/material.dart';
import 'beranda_admin.dart';
import 'pengguna_admin.dart';
import 'konten_screen.dart';

class LaporanAdmin extends StatefulWidget {
  const LaporanAdmin({super.key});

  @override
  State<LaporanAdmin> createState() => _LaporanAdminState();
}

class _LaporanAdminState extends State<LaporanAdmin> {
  int _selectedNav = 4;
  int _selectedTab = 0; // 0 = Moderasi, 1 = Keuangan
  String _searchQuery = '';

  final List<Map<String, dynamic>> _moderasi = [
    {
      'judul': 'Abjad A-Z: Huruf A',
      'penulis': 'Siti Nurhaliza',
      'level': 'Dasar',
      'icon': Icons.abc,
      'iconColor': Colors.white,
      'iconBg': Color(0xFF6C63FF),
    },
    {
      'judul': 'Abjad A-Z: Huruf A',
      'penulis': 'Rahma',
      'level': 'Dasar',
      'icon': Icons.tag,
      'iconColor': Colors.white,
      'iconBg': Color(0xFF4CAF50),
    },
    {
      'judul': 'Ekspresi:',
      'penulis': 'Dika',
      'level': 'Dasar',
      'icon': Icons.emoji_emotions_outlined,
      'iconColor': Colors.white,
      'iconBg': Color(0xFF9C27B0),
    },
    {
      'judul': 'Percakapan Dasar:\nSalam Dasar',
      'penulis': 'Laura',
      'level': 'Dasar',
      'icon': Icons.chat_bubble_outline,
      'iconColor': Colors.white,
      'iconBg': Color(0xFFFF6B35),
    },
  ];

  final List<Map<String, dynamic>> _keuangan = [
    {
      'judul': 'Pembayaran Langganan',
      'penulis': 'Ahmad Rizki',
      'level': 'Pro',
      'icon': Icons.credit_card,
      'iconColor': Colors.white,
      'iconBg': Color(0xFF3B72FF),
    },
    {
      'judul': 'Refund Request',
      'penulis': 'Dewi Lestari',
      'level': 'Basic',
      'icon': Icons.receipt_long,
      'iconColor': Colors.white,
      'iconBg': Color(0xFFF5A623),
    },
    {
      'judul': 'Transaksi Gagal',
      'penulis': 'Budi Santoso',
      'level': 'Pro',
      'icon': Icons.money_off,
      'iconColor': Colors.white,
      'iconBg': Color(0xFFE53E3E),
    },
  ];

  List<Map<String, dynamic>> get _filteredList {
    final source = _selectedTab == 0 ? _moderasi : _keuangan;
    return source.where((item) {
      return _searchQuery.isEmpty ||
          item['judul'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item['penulis'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTabBar(),
                    const SizedBox(height: 16),
                    _buildSearchBar(),
                    const SizedBox(height: 12),
                    _buildList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── TOP BAR ───────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.menu, size: 24, color: Color(0xFF1A1D2E)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Laporan',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1D2E),
                    fontFamily: 'Poppins')),
          ),
          Image.asset('assets/images/loncengadmin.png',
              width: 26,
              height: 26,
              errorBuilder: (_, __, ___) => const Icon(
                  Icons.notifications_none,
                  color: Color(0xFF1A1D2E),
                  size: 26)),
        ],
      ),
    );
  }

  // ─── TAB BAR ───────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildTab(0, 'Moderasi'),
          _buildTab(1, 'Keuangan'),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedTab = index;
          _searchQuery = '';
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF6C63FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                  fontFamily: 'Poppins'),
            ),
          ),
        ),
      ),
    );
  }

  // ─── SEARCH BAR ────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        onChanged: (val) => setState(() => _searchQuery = val),
        style: const TextStyle(
            fontSize: 13, fontFamily: 'Poppins', color: Color(0xFF1A1D2E)),
        decoration: const InputDecoration(
          hintText: 'Cari judul materi',
          hintStyle: TextStyle(
              fontSize: 13, fontFamily: 'Poppins', color: Color(0xFF9CA3AF)),
          prefixIcon:
              Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  // ─── LIST ──────────────────────────────────────────────
  Widget _buildList() {
    final list = _filteredList;
    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text('Tidak ada laporan ditemukan',
              style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9CA3AF),
                  fontFamily: 'Poppins')),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: List.generate(list.length, (i) {
          final isLast = i == list.length - 1;
          return Column(
            children: [
              _buildItem(list[i]),
              if (!isLast)
                const Divider(
                    height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: item['iconBg'] as Color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item['icon'] as IconData,
                color: item['iconColor'] as Color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['judul'] as String,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1D2E),
                        fontFamily: 'Poppins')),
                const SizedBox(height: 2),
                Text('oleh: ${item['penulis']}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9CA3AF),
                        fontFamily: 'Poppins')),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Badge level
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(item['level'] as String,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins')),
              ),
              const SizedBox(height: 6),
              // Tombol Tinjau
              GestureDetector(
                onTap: () => _showTinjauDialog(item),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5A623),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Tinjau',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── DIALOG TINJAU ─────────────────────────────────────
  void _showTinjauDialog(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Tinjau Laporan',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1D2E),
                        fontFamily: 'Poppins')),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(item['judul'] as String,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1D2E),
                    fontFamily: 'Poppins')),
            Text('oleh: ${item['penulis']}',
                style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                    fontFamily: 'Poppins')),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEEEE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('Tolak',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFE53E3E),
                                fontFamily: 'Poppins')),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('Setujui',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Poppins')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ─── BOTTOM NAV ────────────────────────────────────────
  Widget _buildBottomNav() {
    final List<Map<String, String>> items = [
      {'iconPath': 'assets/images/berandaadmin.png', 'label': 'Beranda'},
      {'iconPath': 'assets/images/penggunaadmin.png', 'label': 'Pengguna'},
      {'iconPath': 'assets/images/kontenadmin.png', 'label': 'Konten'},
      {'iconPath': 'assets/images/aktifitasadmin.png', 'label': 'Aktivitas'},
      {'iconPath': 'assets/images/laporanadmin.png', 'label': 'Laporan'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEBEBEB))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = _selectedNav == i;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedNav = i);
              if (i == 0) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const BerandaAdmin()));
              } else if (i == 1) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const PenggunaAdmin()));
              } else if (i == 2) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const KontenScreen()));
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    isActive
                        ? const Color(0xFFF5A623)
                        : const Color(0xFF9CA3AF),
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(items[i]['iconPath']!,
                      width: 22,
                      height: 22,
                      errorBuilder: (_, __, ___) => Icon(Icons.circle,
                          size: 22,
                          color: isActive
                              ? const Color(0xFFF5A623)
                              : const Color(0xFF9CA3AF))),
                ),
                const SizedBox(height: 4),
                Text(items[i]['label']!,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isActive
                            ? const Color(0xFFF5A623)
                            : const Color(0xFF9CA3AF),
                        fontFamily: 'Poppins')),
              ],
            ),
          );
        }),
      ),
    );
  }
}