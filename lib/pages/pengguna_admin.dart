import 'package:flutter/material.dart';
import 'beranda_admin.dart';
import 'konten_screen.dart';

class PenggunaAdmin extends StatefulWidget {
  const PenggunaAdmin({super.key});

  @override
  State<PenggunaAdmin> createState() => _PenggunaAdminState();
}

class _PenggunaAdminState extends State<PenggunaAdmin> {
  int _selectedTab = 0;
  int _selectedNav = 1;
  String _searchQuery = '';
  String? _filterStatus;

  final List<Map<String, dynamic>> _guru = [
    {'nama': 'Siti Nurhaliza', 'email': 'siti@email.com', 'status': 'Aktif', 'avatar': 'assets/images/img.png'},
    {'nama': 'Ahmad Rizki', 'email': 'ahmad@email.com', 'status': 'Aktif', 'avatar': 'assets/images/img.png'},
    {'nama': 'Dewi Lestari', 'email': 'dewi@email.com', 'status': 'Tidak Aktif', 'avatar': 'assets/images/img.png'},
    {'nama': 'Budi Santoso', 'email': 'budi@email.com', 'status': 'Aktif', 'avatar': 'assets/images/img.png'},
  ];

  final List<Map<String, dynamic>> _siswa = [
    {'nama': 'Siti Nurhaliza', 'email': 'siti@email.com', 'status': 'Aktif', 'avatar': 'assets/images/img.png'},
    {'nama': 'Ahmad Rizki', 'email': 'ahmad@email.com', 'status': 'Aktif', 'avatar': 'assets/images/img.png'},
    {'nama': 'Dewi Lestari', 'email': 'dewi@email.com', 'status': 'Tidak Aktif', 'avatar': 'assets/images/img.png'},
    {'nama': 'Budi Santoso', 'email': 'budi@email.com', 'status': 'Aktif', 'avatar': 'assets/images/img.png'},
  ];

  List<Map<String, dynamic>> get _filteredList {
    final source = _selectedTab == 0 ? _guru : _siswa;
    return source.where((user) {
      final matchSearch = _searchQuery.isEmpty ||
          user['nama'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user['email'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchFilter = _filterStatus == null || user['status'] == _filterStatus;
      return matchSearch && matchFilter;
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
                    const SizedBox(height: 10),
                    _buildFilterRow(),
                    const SizedBox(height: 12),
                    _buildUserList(),
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

  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.menu, size: 24, color: Color(0xFF1A1D2E)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Pengguna',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
          ),
          Image.asset('assets/images/loncengadmin.png',
              width: 26, height: 26,
              errorBuilder: (_, __, ___) => const Icon(Icons.notifications_none, color: Color(0xFF1A1D2E), size: 26)),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(4),
      child: Row(children: [_buildTab(0, 'Guru'), _buildTab(1, 'Siswa')]),
    );
  }

  Widget _buildTab(int index, String label) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() { _selectedTab = index; _filterStatus = null; _searchQuery = ''; }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))]
                : [],
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isActive ? const Color(0xFFF5A623) : const Color(0xFF9CA3AF),
                    fontFamily: 'Poppins')),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: TextField(
        onChanged: (val) => setState(() => _searchQuery = val),
        style: const TextStyle(fontSize: 13, fontFamily: 'Poppins', color: Color(0xFF1A1D2E)),
        decoration: const InputDecoration(
          hintText: 'Cari pengguna',
          hintStyle: TextStyle(fontSize: 13, fontFamily: 'Poppins', color: Color(0xFF9CA3AF)),
          prefixIcon: Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildFilterChip('Status'),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _showFilterDialog(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: Row(
              children: const [
                Text('Filter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B7280), fontFamily: 'Poppins')),
                SizedBox(width: 4),
                Icon(Icons.tune, size: 14, color: Color(0xFF6B7280)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    return GestureDetector(
      onTap: () => _showFilterDialog(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE5E7EB))),
        child: Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B7280), fontFamily: 'Poppins')),
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
            const SizedBox(height: 16),
            _buildFilterOption('Semua', null),
            _buildFilterOption('Aktif', 'Aktif'),
            _buildFilterOption('Tidak Aktif', 'Tidak Aktif'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, String? value) {
    final isSelected = _filterStatus == value;
    return GestureDetector(
      onTap: () { setState(() => _filterStatus = value); Navigator.pop(context); },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF8EC) : const Color(0xFFF7F8FC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? const Color(0xFFF5A623) : const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? const Color(0xFFF5A623) : const Color(0xFF1A1D2E),
                    fontFamily: 'Poppins')),
            const Spacer(),
            if (isSelected) const Icon(Icons.check, color: Color(0xFFF5A623), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    final list = _filteredList;
    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text('Tidak ada pengguna ditemukan',
              style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF), fontFamily: 'Poppins')),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: List.generate(list.length, (i) {
          final isLast = i == list.length - 1;
          return Column(
            children: [
              _buildUserItem(list[i]),
              if (!isLast) const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildUserItem(Map<String, dynamic> user) {
    final isAktif = user['status'] == 'Aktif';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFFE5E7EB),
            backgroundImage: AssetImage(user['avatar'] as String),
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['nama'] as String,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
                const SizedBox(height: 2),
                Text(user['email'] as String,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF), fontFamily: 'Poppins')),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: isAktif ? const Color(0xFFE8F9F0) : const Color(0xFFFFEEEE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(user['status'] as String,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isAktif ? const Color(0xFF4CAF7D) : const Color(0xFFE53E3E),
                    fontFamily: 'Poppins')),
          ),
        ],
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const BerandaAdmin()),
                );
              } else if (i == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const KontenScreen()),
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    isActive ? const Color(0xFFF5A623) : const Color(0xFF9CA3AF),
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(items[i]['iconPath']!,
                      width: 22, height: 22,
                      errorBuilder: (_, __, ___) => Icon(Icons.circle,
                          size: 22,
                          color: isActive ? const Color(0xFFF5A623) : const Color(0xFF9CA3AF))),
                ),
                const SizedBox(height: 4),
                Text(items[i]['label']!,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isActive ? const Color(0xFFF5A623) : const Color(0xFF9CA3AF),
                        fontFamily: 'Poppins')),
              ],
            ),
          );
        }),
      ),
    );
  }
}