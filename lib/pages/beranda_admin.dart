import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'pengguna_admin.dart';
import 'konten_screen.dart';
import 'detail_aktivitas_page.dart';
import 'laporan_admin.dart';
import 'aktivitas_admin.dart';

class BerandaAdmin extends StatefulWidget {
  const BerandaAdmin({super.key});

  @override
  State<BerandaAdmin> createState() => _BerandaAdminState();
}

class _BerandaAdminState extends State<BerandaAdmin> {
  int _selectedNav = 0;
  bool _isLoading = true;
  String _errorMessage = '';

  // Variabel penampung data statistik dari API
  String totalPengguna = '0';
  String kontenAktif = '0';
  String materiBelajar = '0';
  String pembelajaran = '0';

  // Variabel penampung data ringkasan aktivitas dari API
  List<dynamic> _aktivitas = [];

  @override
  void initState() {
    super.initState();
    _fetchDashboardData(); // Otomatis tarik data database pas halaman dibuka
  }

  // ─── FUNGSI AMBIL DATA DARI BACKEND LARAVEL ──────────────────────
  Future<void> _fetchDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Menggunakan IP emulator 10.0.2.2 menuju rute dashboard admin
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/admin/dashboard'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          // Petakan data dari database ke variabel UI
          totalPengguna = responseData['total_pengguna']?.toString() ?? '0';
          kontenAktif = responseData['konten_aktif']?.toString() ?? '0';
          materiBelajar = responseData['materi_belajar']?.toString() ?? '0';
          pembelajaran = responseData['pembelajaran']?.toString() ?? '0';
          _aktivitas = responseData['ringkasan_aktivitas'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data. Status: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Koneksi gagal. Pastikan Server Laravel menyala!';
        _isLoading = false;
      });
    }
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFF5A623)))
                  : _errorMessage.isNotEmpty
                      ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red, fontFamily: 'Poppins')))
                      : RefreshIndicator(
                          onRefresh: _fetchDashboardData, // Geser layar ke bawah untuk refresh data database
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Statistik Utama',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF1A1D2E),
                                        fontFamily: 'Poppins')),
                                const SizedBox(height: 12),
                                _buildStatistikGrid(),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    const Text('Ringkasan Aktivitas',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF1A1D2E),
                                            fontFamily: 'Poppins')),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        // Pindah ke halaman aktivitas admin utama
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AktivitasAdmin()));
                                      },
                                      child: const Text('Lihat Semua',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFF5A623),
                                              fontFamily: 'Poppins')),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (_aktivitas.isEmpty)
                                  const Center(child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text('Belum ada aktivitas hari ini.', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
                                  ))
                                else
                                  ..._aktivitas.map((item) => _buildAktivitasItem(item)),
                                const SizedBox(height: 70), // Spasi aman agar tidak mentok tombol melayang
                              ],
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
      
      // ─── TOMBOL MELAYANG SEBAGAI SAKLAR TAMBAH DATA (DESIGN RE-VAMP) ───
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTambahDialog(context),
        backgroundColor: const Color(0xFF3B72FF),
        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
        label: const Text('Tambah Data', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
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
            child: Text('Beranda Admin',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1D2E),
                    fontFamily: 'Poppins')),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF1A1D2E), size: 26),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatistikGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          iconPath: 'assets/images/totalpengguna.png',
          iconBg: const Color(0xFFF5A623),
          value: totalPengguna, // Menggunakan variabel API
          label: 'Total Pengguna',
          change: '+12%',
          changePositive: true,
        ),
        _buildStatCard(
          iconPath: 'assets/images/kontenaktif.png',
          iconBg: const Color(0xFF4CAF7D),
          value: kontenAktif, // Menggunakan variabel API
          label: 'Konten Aktif',
          change: '+8%',
          changePositive: true,
        ),
        _buildStatCard(
          iconPath: 'assets/images/materibelajar.png',
          iconBg: const Color(0xFFF5A623),
          value: materiBelajar, // Menggunakan variabel API
          label: 'Materi Belajar',
          change: '+15%',
          changePositive: true,
        ),
        _buildStatCard(
          iconPath: 'assets/images/pembelajaran.png',
          iconBg: const Color(0xFF4CAF7D),
          value: pembelajaran, // Menggunakan variabel API
          label: 'Pembelajaran',
          change: '+24%',
          changePositive: true,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String iconPath,
    required Color iconBg,
    required String value,
    required String label,
    required String change,
    required bool changePositive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(6),
                child: Image.asset(iconPath, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.bar_chart, color: Colors.white, size: 16)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: changePositive ? const Color(0xFFE8F9F0) : const Color(0xFFFFEEEE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(change, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: changePositive ? const Color(0xFF4CAF7D) : const Color(0xFFE53E3E), fontFamily: 'Poppins')),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF6B7280), fontFamily: 'Poppins')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAktivitasItem(Map<String, dynamic> item) {
    // Pengaturan warna otomatis berdasarkan status dari database
    Color bgIconColor = const Color(0xFFEEF2FF);
    Color txtColor = const Color(0xFF3B72FF);
    IconData defaultIcon = Icons.info;

    if (item['status'] == 'materi') {
      bgIconColor = const Color(0xFFFFF8EC);
      txtColor = const Color(0xFFF5A623);
      defaultIcon = Icons.menu_book_rounded;
    } else if (item['status'] == 'review' || item['status'] == 'laporan') {
      bgIconColor = const Color(0xFFFFEEEE);
      txtColor = const Color(0xFFE53E3E);
      defaultIcon = Icons.warning_amber_rounded;
    }

    return InkWell(
      onTap: () {
        Navigator.push(
  context, 
  MaterialPageRoute(
    builder: (context) => DetailAktivitasPage(
      aktivitasId: item['id'] is int ? item['id'] : int.tryParse(item['id']?.toString() ?? '') ?? 0,
    ),
  ),
);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: bgIconColor, borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(8),
              child: Icon(defaultIcon, color: txtColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title'] ?? 'Aktivitas Tanpa Judul', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
                  const SizedBox(height: 2),
                  Text(item['subtitle'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF), fontFamily: 'Poppins')),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: bgIconColor, borderRadius: BorderRadius.circular(8)),
              child: Text(item['time'] ?? 'Now', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: txtColor, fontFamily: 'Poppins')),
            ),
          ],
        ),
      ),
    );
  }

  void _showTambahDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Tambah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
                  const Spacer(),
                  GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, color: Color(0xFF9CA3AF))),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Pilih yang ingin ditambahkan:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF6B7280), fontFamily: 'Poppins')),
              const SizedBox(height: 16),
              _buildDialogOption(iconPath: 'assets/images/materi.png', label: 'Materi', sublabel: 'Tambah modul atau video', color: const Color(0xFF3B72FF), onTap: () => Navigator.pop(context)),
              const SizedBox(height: 10),
              _buildDialogOption(iconPath: 'assets/images/kategori.png', label: 'Kategori', sublabel: 'Tambah kategori baru', color: const Color(0xFF4CAF7D), onTap: () => Navigator.pop(context)),
              const SizedBox(height: 10),
              _buildDialogOption(iconPath: 'assets/images/guru(2).png', label: 'Guru', sublabel: 'Tambahkan guru baru', color: const Color(0xFFF5A623), onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogOption({required String iconPath, required String label, required String sublabel, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 24),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Poppins')),
                Text(sublabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white70, fontFamily: 'Poppins')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.home_rounded, 'label': 'Beranda'},
      {'icon': Icons.people_alt_rounded, 'label': 'Pengguna'},
      {'icon': Icons.video_collection_rounded, 'label': 'Konten'},
      {'icon': Icons.assessment_rounded, 'label': 'Aktivitas'},
      {'icon': Icons.report_problem_rounded, 'label': 'Laporan'},
    ];

    return Container(
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEBEBEB)))),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = _selectedNav == i;
          final color = isActive ? const Color(0xFFF5A623) : const Color(0xFF9CA3AF);
          return GestureDetector(
            onTap: () {
              setState(() => _selectedNav = i);
              if (i == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => const PenggunaAdmin()));
              if (i == 2) Navigator.push(context, MaterialPageRoute(builder: (_) => const KontenScreen()));
              if (i == 3) Navigator.push(context, MaterialPageRoute(builder: (_) => const AktivitasAdmin()));
              if (i == 4) Navigator.push(context, MaterialPageRoute(builder: (_) => const LaporanAdmin()));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(items[i]['icon'] as IconData, color: color, size: 24),
                const SizedBox(height: 4),
                Text(items[i]['label'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color, fontFamily: 'Poppins')),
              ],
            ),
          );
        }),
      ),
    );
  }
}