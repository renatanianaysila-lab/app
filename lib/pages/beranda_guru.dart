import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'materi_guru.dart';

class BerandaGuruMain extends StatefulWidget {
  const BerandaGuruMain({super.key});

  @override
  State<BerandaGuruMain> createState() => _BerandaGuruMainState();
}

class _BerandaGuruMainState extends State<BerandaGuruMain> {
  // ── STATE DATA API BERANDA ───────────────────────────────────────
  bool _isLoading = true;
  String _namaGuru = '';
  int _jumlahSiswa = 0;
  int _jumlahKelas = 0;
  double _ratingGuru = 0.0;
  int _jumlahUlasan = 0;
  List<dynamic> _kelasList = [];

  // 🎯 KUNCI UTAMA: Variabel untuk menyimpan halaman aktif di dalam tab Beranda
  Widget? _subPage;

  @override
  void initState() {
    super.initState();
    _fetchBerandaData();
  }

  Future<void> _fetchBerandaData() async {
  setState(() => _isLoading = true);
  try {
    final resProfil = await http.get(
      Uri.parse('http://naysila.kesug.com/api/guru/profil?guru_id=G0001'),
    );
    
    print("STATUS CODE: ${resProfil.statusCode}"); 
    print("RESPONSE: ${resProfil.body}");      
    
    if (resProfil.statusCode == 200) {
      final data = jsonDecode(resProfil.body)['data'];
      setState(() {
        _namaGuru = data['nama_guru'] ?? 'Nama Guru';
        _jumlahSiswa = data['jumlah_siswa'] ?? 0;
        _jumlahKelas = data['jumlah_kelas'] ?? 0;
        _ratingGuru = (data['rating'] ?? 0.0).toDouble();
        _kelasList = data['kelas'] ?? [];
        _isLoading = false;
      });
    } else {
      print("GAGAL: status ${resProfil.statusCode}"); // 🔍 Tambah ini
      setState(() => _isLoading = false);
    }
  } catch (e) {
    print("Eror Beranda: $e"); // Ini sudah ada
    setState(() => _isLoading = false);
  }
}
  
  @override
  Widget build(BuildContext context) {
    // 🎯 JIKA _subPage TIDAK NULL, TAMPILKAN HALAMAN MATERI LANGSUNG DI SINI
    if (_subPage != null) {
      return _subPage!;
    }

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F8FC),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFFB800), 
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFFFB800),
          onRefresh: _fetchBerandaData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                        fontFamily: 'Poppins'),
                  ),
                ),
                const SizedBox(height: 12),
                _buildKelasListHorizontal(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── TOP BAR ──────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFFEF3C7), 
            child: Icon(Icons.person_outline, color: Color(0xFFFFB800), size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${_namaGuru.isNotEmpty ? _namaGuru : 'Guru'} 👋',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1D2E),
                      fontFamily: 'Poppins'),
                ),
                const Text(
                  'Kelola kelas dan pantau progres yuk!',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                      fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12)),
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Color(0xFFFFB800)),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  // ── SUMMARY CARDS ────────────────────────────────────────────────
  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSingleSummaryCard(
              Icons.people_alt,
              '$_jumlahSiswa Siswa',
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildSingleSummaryCard(
              Icons.menu_book_rounded,
              '$_jumlahKelas Kelas',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleSummaryCard(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFFFB800), size: 22),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1D2E),
                  fontFamily: 'Poppins')),
        ],
      ),
    );
  }

  // ── RATING BOX ───────────────────────────────────────────────────
  Widget _buildRatingBox() {
    final int bintangPenuh = _ratingGuru.floor();
    final bool adaSetengah = (_ratingGuru - bintangPenuh) >= 0.5;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Ulasan Guru',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1D2E),
                    fontFamily: 'Poppins')),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              if (i < bintangPenuh) {
                return const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 36);
              } else if (i == bintangPenuh && adaSetengah) {
                return const Icon(Icons.star_half_rounded, color: Color(0xFFFFC107), size: 36);
              } else {
                return const Icon(Icons.star_outline_rounded, color: Color(0xFFD1D5DB), size: 36);
              }
            }),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFFFA100), size: 14),
              const SizedBox(width: 4),
              Text(
                '${_ratingGuru.toStringAsFixed(1)}  ($_jumlahUlasan ulasan)',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFA100),
                    fontFamily: 'Poppins'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFEF3C7),
              foregroundColor: const Color(0xFFFFB800),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Lihat Detail Ulasan',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins')),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios_rounded, size: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── KELAS LIST HORIZONTAL ────────────────────────────────────────
  Widget _buildKelasListHorizontal() {
    if (_kelasList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Belum ada kelas yang diajar.',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF9CA3AF)),
        ),
      );
    }

    const Color warnaKuning = Color(0xFFFFB800);
    const Color warnaBgKuningSoft = Color(0xFFFEF3C7);

    return SizedBox(
      height: 260,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: _kelasList.length,
        itemBuilder: (context, index) {
          final kelas = _kelasList[index];
          final String title = kelas['nama_kelas'] ?? kelas['title'] ?? '';
          final String level = kelas['kategori'] ?? kelas['level'] ?? 'Dasar';
          final int siswa = kelas['jumlah_siswa'] ?? 0;
          final int kapasitas = kelas['kapasitas'] ?? 45;

          return Container(
            width: 180,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 95,
                  decoration: BoxDecoration(
                    color: warnaBgKuningSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.class_outlined,
                      color: warnaKuning,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1D2E),
                      fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 2),
                Text(
                  '${level == 'Menengah' ? 'Intermediate' : level} | $siswa/$kapasitas',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                      fontFamily: 'Poppins'),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // 🎯 LANGSUNG NYAMBUNG DI TEMPAT: Mengisi _subPage dengan widget MateriGuruPage
                      setState(() {
                        _subPage = MateriGuruPage(
                          initialLevel: level,
                          initialClassName: title,
                          guruId: 'G0001',
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: warnaKuning,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Lihat Detail',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Poppins')),
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