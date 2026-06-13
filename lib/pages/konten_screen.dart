import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'beranda_admin.dart';
import 'pengguna_admin.dart';
import 'laporan_admin.dart';
import 'aktivitas_admin.dart';

class KontenScreen extends StatefulWidget {
  const KontenScreen({super.key});

  @override
  State<KontenScreen> createState() => _KontenScreenState();
}

class _KontenScreenState extends State<KontenScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> _allKonten = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchKonten();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchKonten() async {
    setState(() { _isLoading = true; _error = ''; });
    try {
      final res = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/admin/konten'),
        headers: {'Accept': 'application/json'},
      );
      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        setState(() {
          _allKonten = List<Map<String, dynamic>>.from(body['data']);
          _isLoading = false;
        });
      } else {
        setState(() { _error = 'Gagal memuat konten. Status: ${res.statusCode}'; _isLoading = false; });
      }
    } catch (e) {
      setState(() { _error = 'Koneksi gagal. Pastikan server Laravel menyala!'; _isLoading = false; });
    }
  }

  List<Map<String, dynamic>> _filtered(String status) {
    return _allKonten.where((k) {
      final matchStatus = (k['status'] ?? '') == status;
      final matchSearch = _searchQuery.isEmpty ||
          (k['judul'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (k['penulis'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
      return matchStatus && matchSearch;
    }).toList();
  }

  // Warna icon berdasarkan field 'warna' dari API
  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xFFF5A623);
    final cleaned = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  // Icon berdasarkan kategori
  IconData _iconFromKategori(String? kategori) {
    switch ((kategori ?? '').toLowerCase()) {
      case 'abjad':   return Icons.abc;
      case 'angka':   return Icons.tag;
      case 'ekspresi': return Icons.emoji_emotions_outlined;
      case 'percakapan': return Icons.chat_bubble_outline;
      default: return Icons.menu_book_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black87),
        title: const Text(
          'Konten',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.black87),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              tabs: [
                _buildTabLabel('Pending', 0, const Color(0xFFFF9800)),
                _buildTabLabel('Disetujui', 1, const Color(0xFF4CAF50)),
                _buildTabLabel('Ditolak', 2, const Color(0xFF6C63FF)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Cari judul materi',
                        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey, fontFamily: 'Poppins'),
                        prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _filterChip('Guru'),
                const SizedBox(width: 6),
                _filterChip('Filter', icon: Icons.tune),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFF5A623)))
                : _error.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_error,
                                style: const TextStyle(color: Colors.red, fontFamily: 'Poppins', fontSize: 13),
                                textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _fetchKonten,
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF5A623)),
                              child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildList('pending'),
                          _buildList('disetujui'),
                          _buildList('ditolak'),
                        ],
                      ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTabLabel(String label, int index, Color activeColor) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        final isSelected = _tabController.index == index;
        return Tab(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? activeColor.withOpacity(0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? activeColor : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _filterChip(String label, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87, fontFamily: 'Poppins')),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, size: 14, color: Colors.grey),
          ],
        ],
      ),
    );
  }

  Widget _buildList(String status) {
    final items = _filtered(status);
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              status == 'pending'
                  ? 'Belum ada konten pending'
                  : status == 'disetujui'
                      ? 'Belum ada konten disetujui'
                      : 'Belum ada konten ditolak',
              style: const TextStyle(color: Colors.grey, fontFamily: 'Poppins', fontSize: 13),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _fetchKonten,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (ctx, i) => _buildKontenCard(items[i]),
      ),
    );
  }

  Widget _buildKontenCard(Map<String, dynamic> item) {
    final warna = _parseColor(item['warna']?.toString());
    final icon = _iconFromKategori(item['kategori']?.toString());
    final level = item['level'] ?? item['kategori'] ?? 'Dasar';
    final penulis = item['penulis'] ?? 'Admin';
    final judul = item['judul'] ?? '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(color: warna, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        title: Text(
          judul,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, fontFamily: 'Poppins'),
        ),
        subtitle: Text(
          'oleh: $penulis',
          style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            level,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
          ),
        ),
      ),
    );
  }

  // ─── BOTTOM NAV ────────────────────────────────────────────────────────────

  Widget _buildBottomNav() {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.home_rounded, 'label': 'Beranda'},
      {'icon': Icons.people_alt_rounded, 'label': 'Pengguna'},
      {'icon': Icons.video_collection_rounded, 'label': 'Konten'},
      {'icon': Icons.assessment_rounded, 'label': 'Aktivitas'},
      {'icon': Icons.report_problem_rounded, 'label': 'Laporan'},
    ];

    const int selectedNav = 2; // Konten = index 2

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEBEBEB))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = selectedNav == i;
          final color = isActive ? const Color(0xFFF5A623) : const Color(0xFF9CA3AF);
          return GestureDetector(
            onTap: () {
              if (i == selectedNav) return;
              if (i == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BerandaAdmin()));
              if (i == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PenggunaAdmin()));
              if (i == 3) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AktivitasAdmin()));
              if (i == 4) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LaporanAdmin()));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(items[i]['icon'] as IconData, color: color, size: 24),
                const SizedBox(height: 4),
                Text(items[i]['label'] as String,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color, fontFamily: 'Poppins')),
              ],
            ),
          );
        }),
      ),
    );
  }
}