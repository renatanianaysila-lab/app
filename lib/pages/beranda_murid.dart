import 'dart:convert';
import 'package:flutter/material.dart';
import 'materi_murid.dart';
import 'package:http/http.dart' as http; // 1. Tambahkan import http

class BerandaMurid extends StatefulWidget {
  final void Function(String level)? onOpenMateri;

  const BerandaMurid({
    super.key,
    this.onOpenMateri,
  });

  @override
  State<BerandaMurid> createState() => _BerandaMuridState();
}

class _BerandaMuridState extends State<BerandaMurid> {
  bool _isLoading = true;
  
  // List levels sekarang dibuat dinamis agar bisa menampung update jumlah topik dari Laravel
  final List<Map<String, dynamic>> _levelsData = [
    {
      'number': 1,
      'title': 'Beginner',
      'subtitle': 'Level Dasar',
      'materi': 0, // Akan di-update dari API
      'soal': 120,
      'progress': 0.75,
      'locked': false,
      'color': const Color(0xFF3B72FF),
      'bgColor': const Color(0xFFEEF2FF),
    },
    {
      'number': 2,
      'title': 'Intermediate',
      'subtitle': 'Level Menengah',
      'materi': 0, // Akan di-update dari API
      'soal': 180,
      'progress': 0.45,
      'locked': false,
      'color': const Color(0xFF4CAF7D),
      'bgColor': const Color(0xFFE8F9F0),
    },
    {
      'number': 3,
      'title': 'Advanced',
      'subtitle': 'Level Lanjutan',
      'materi': 0, // Akan di-update dari API
      'soal': 240,
      'progress': 0.0,
      'locked': true,
      'color': const Color(0xFF9B59B6),
      'bgColor': const Color(0xFFF5EEFF),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadMateriCount();
  }

  // 2. Fungsi untuk mengambil data materi dari Laravel
  Future<void> _loadMateriCount() async {
    const String url = 'https://luther-nonrepayable-unguiltily.ngrok-free.dev/api/materi';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        List<dynamic> materiFromApi = responseData['data'];

        // Menghitung jumlah topik per kategori dari backend Laravel
        int beginnerCount = materiFromApi.where((m) => m['kategori'] == 'Abjad' || m['kategori'] == 'Angka').length;
        int intermediateCount = materiFromApi.where((m) => m['kategori'] == 'Percakapan').length;

        setState(() {
          _levelsData[0]['materi'] = beginnerCount > 0 ? beginnerCount : 12; // fallback ke data UTS kelompokmu jika API kosong
          _levelsData[1]['materi'] = intermediateCount > 0 ? intermediateCount : 18;
          _levelsData[2]['materi'] = 24; 
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      // Jika server offline, tetap pakai data mock agar UI kelompokmu tidak eror/kosong saat demo
      setState(() => _isLoading = false);
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
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF3B72FF)))
                  : RefreshIndicator(
                      onRefresh: _loadMateriCount,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _buildHeroBanner(),
                            const SizedBox(height: 16),
                            _buildCTAButton(context),
                            const SizedBox(height: 24),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Level Pembelajaran',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1A1D2E),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ..._levelsData.map((level) => Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: _buildLevelCard(context, level),
                                )),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar dikosongkan agar otomatis mengikuti Navbar Utama proyek kelompok
    );
  }

  // ─── TOP BAR ───────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              'assets/images/user.png',
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_circle, size: 44),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, Naysila 👋',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1D2E),
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  'Selamat datang di IsyaratKita',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              icon: Image.asset(
                'assets/images/lonceng.png',
                width: 28,
                height: 28,
              ),
              onPressed: () {},
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  // ─── HERO BANNER ───────────────────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B72FF), Color(0xFF7BA7FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Mulai perjalanan belajar bahasa isyarat dan jadikan komunikasi lebih inklusif.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.45,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              'assets/images/tangan isyarat.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.back_hand, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ─── CTA BUTTON ────────────────────────────────────────
  Widget _buildCTAButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (widget.onOpenMateri != null) {
              widget.onOpenMateri!('Beginner');
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MateriMurid(initialLevel: 'Beginner'),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B72FF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Mulai Belajar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }

  // ─── LEVEL CARD ────────────────────────────────────────
  Widget _buildLevelCard(BuildContext context, Map<String, dynamic> level) {
    final bool locked = level['locked'] as bool;
    final double progress = level['progress'] as double;
    final Color color = level['color'] as Color;
    final Color bgColor = level['bgColor'] as Color;
    final int progressPercent = (progress * 100).toInt();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${level['number']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: color,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level['title'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1D2E),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    level['subtitle'],
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                locked ? Icons.lock : Icons.lock_open,
                color: locked ? const Color(0xFF6B7280) : color,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEBEBEB)),
          const SizedBox(height: 14),

          Row(
            children: [
              _buildStat(
                iconPath: 'assets/images/materi.png',
                label: 'Materi',
                value: '${level['materi']} Topik',
                color: color,
              ),
              const SizedBox(width: 24),
              _buildStat(
                iconPath: 'assets/images/materinavbar.png',
                label: 'Bank Soal',
                value: '${level['soal']} Soal',
                color: color,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
              Text(
                '$progressPercent%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: color,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFEBEBEB),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: locked
                  ? null
                  : () {
                      final selectedLevel = level['title'] as String;

                      if (widget.onOpenMateri != null) {
                        widget.onOpenMateri!(selectedLevel);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MateriMurid(
                              initialLevel: selectedLevel,
                            ),
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: locked ? const Color(0xFFEBEBEB) : color,
                foregroundColor: locked ? const Color(0xFF6B7280) : Colors.white,
                disabledBackgroundColor: const Color(0xFFEBEBEB),
                disabledForegroundColor: const Color(0xFF6B7280),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    locked ? 'Terkunci' : 'Mulai Belajar',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  if (!locked) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward, size: 16),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required String iconPath,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Image.asset(
          iconPath, 
          width: 16, 
          height: 16, 
          color: color,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.menu_book, size: 16, color: color),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1D2E),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ],
    );
  }
}