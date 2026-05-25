import 'package:flutter/material.dart';
import 'pilih_level_quiz_page.dart';
import 'video_player_widget.dart'; // 🔥 Import widget player youtube yang baru

class DetailMateriPage extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color iconBg;

  const DetailMateriPage({
    super.key,
    required this.title,
    required this.iconPath,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(),
                    const SizedBox(height: 16),
                    _buildStatsRow(),
                    const SizedBox(height: 24),
                    const Text(
                      'Materi Tersedia',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1D2E),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // ─── TOMBOL PELAJARI (DENGAN LOGIKA VIDEO YOUTUBE) ───
                    _buildMateriItem(
                      icon: 'A',
                      iconBg: const Color(0xFFEEF2FF),
                      iconColor: const Color(0xFF3B72FF),
                      title: 'Pelajari',
                      subtitle: 'Video Pembelajaran Interaktif',
                      locked: false,
                      onTap: () {
  // 1. Tetapkan video default (untuk kategori Abjad A-Z)
  String targetUrl = 'https://youtu.be/Py6Ch1vBvL0?si=_uvNg0de10GJ7Aa5';
  String targetTitle = 'ABJAD JARI BISINDO';

  // 2. Deteksi kata 'Angka' (Bisa membaca Angka 1-10 maupun Angka dalam Bahasa Isyarat 1-100)
  if (title.contains('Angka')) {
    targetUrl = 'https://youtu.be/5UN60jB4eKg?si=IozPkqVxXs36zXE5';
    targetTitle = 'Belajar Bahasa Isyarat BISINDO angka';
  } 
  // 3. Deteksi kata 'Ekspresi'
  else if (title.contains('Ekspresi')) {
    targetUrl = 'https://youtu.be/50oEnzX2GtE?si=aEJO3Y_8jRA7QK37';
    targetTitle = 'Kata "ISTIMEWA" dalan Bahasa Isyarat BISINDO';
  }

  // 4. Buka halaman player bawa data url + judul yang pas
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => VideoPlayerWidget(
        title: targetTitle,
        videoUrl: targetUrl,
      ),
    ),
  );
},
                    ),
                    const SizedBox(height: 10),
                    
                    _buildMateriItem(
                      icon: '#',
                      iconBg: const Color(0xFFE8F9F0),
                      iconColor: const Color(0xFF4CAF7D),
                      title: 'Latihan',
                      subtitle: 'Latihan Interaktif Dasar',
                      locked: false,
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    _buildQuizButton(context),
                    const SizedBox(height: 10),
                    _buildMateriItem(
                      icon: '🏅',
                      iconBg: const Color(0xFFF3F4F6),
                      iconColor: const Color(0xFF9CA3AF),
                      title: 'Badge Pencapaian',
                      subtitle: 'Selesaikan semua level untuk klaim',
                      locked: true,
                      onTap: null,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── TOP BAR (LONCENG 46 BULAT CANTIK) ─────────────────
  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, size: 22, color: Color(0xFF1A1D2E)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1D2E),
                fontFamily: 'Poppins',
              ),
            ),
          ),
          // 🔥 Lonceng bulat ukuran 46 pas presisi
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF2FF),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Image.asset(
                'assets/images/loncengfull.png',
                width: 22,
                height: 22,
              ),
              onPressed: () {},
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  // ─── HEADER CARD ───────────────────────────────────────
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8EC),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF5A623).withOpacity(0.4)),
            ),
            child: const Text(
              '1/4 level selesai',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFFF5A623),
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Belajar $title',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1D2E),
                        fontFamily: 'Poppins',
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title == 'Abjad A-Z'
                          ? 'Pelajari alfabet dasar dalam bahasa isyarat'
                          : title == 'Angka 1-10'
                              ? 'Pelajari angka dasar 1 sampai 10 dalam bahasa isyarat'
                              : 'Pelajari ekspresi wajah dan isyarat sehari-hari',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                        fontFamily: 'Poppins',
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Image.asset(
                'assets/images/tangan isyarat.png',
                width: 70,
                height: 70,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(iconPath, fit: BoxFit.contain),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Progres Belajar',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3B72FF),
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
              const Text(
                '40%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF3B72FF),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.4,
              minHeight: 8,
              backgroundColor: Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B72FF)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── STATS ROW ─────────────────────────────────────────
  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard('80', 'BANK SOAL', const Color(0xFF3B72FF)),
        const SizedBox(width: 10),
        _buildStatCard('4', 'LEVEL QUIZ', const Color(0xFF3B72FF)),
        const SizedBox(width: 10),
        _buildStatCard('20m', 'ESTIMASI', const Color(0xFF3B72FF)),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: color,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9CA3AF),
                fontFamily: 'Poppins',
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── MATERI ITEM BUILDER ───────────────────────────────
  Widget _buildMateriItem({
    required String icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool locked,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: locked ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: locked ? const Color(0xFFF3F4F6) : iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: icon.length == 1 && icon.codeUnitAt(0) > 127
                  ? Text(icon, style: const TextStyle(fontSize: 22))
                  : Text(
                      icon,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: locked ? const Color(0xFF9CA3AF) : iconColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: locked ? const Color(0xFF9CA3AF) : const Color(0xFF1A1D2E),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            if (locked)
              const Text(
                'Terkunci',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                  fontFamily: 'Poppins',
                ),
              )
            else
              const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
          ],
        ),
      ),
    );
  }

  // ─── QUIZ BUTTON ───────────────────────────────────────
  Widget _buildQuizButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PilihLevelQuizPage(materiTitle: title),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF3B72FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mulai Quiz',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    'Uji kemampuan level ini',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }
}