import 'package:flutter/material.dart';

class DetailKelasGuru extends StatefulWidget {
  final String className;
  final String classLevel;
  final VoidCallback onBack;

  const DetailKelasGuru({
    super.key, 
    required this.className, 
    required this.classLevel,
    required this.onBack,
  });

  @override
  State<DetailKelasGuru> createState() => _DetailKelasGuruState();
}

class _DetailKelasGuruState extends State<DetailKelasGuru> {
  @override
  Widget build(BuildContext context) {
    // Kita ganti Scaffold dengan Container/Widget biasa agar aman saat menyatu dengan beranda_guru
    return Container(
      color: const Color(0xFFF7F8FC),
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
                    'Materi Yang Anda Ajar',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1D2E),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 12),
                  // List materi versi mengajar Guru
                  _buildMateriItem(
                    icon: widget.className.contains('Abjad') ? 'A' : '1',
                    title: 'Dasar Pengenalan - ${widget.className}',
                    subtitle: 'Video Pembelajaran Isyarat',
                    duration: '05:40',
                    isCompleted: true,
                  ),
                  const SizedBox(height: 12),
                  _buildMateriItem(
                    icon: 'Q',
                    title: 'Kuis Evaluasi - ${widget.className}',
                    subtitle: 'Total 10 Soal Pilihan Ganda',
                    duration: '15 Menit',
                    isCompleted: false,
                    isQuiz: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TOP BAR DENGAN TOMBOL BACK
  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1D2E), size: 20),
            onPressed: widget.onBack, // Aksi kembali ke Beranda utama
          ),
          const SizedBox(width: 8),
          const Text(
            'Detail Kelas Mengajar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1D2E),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // HEADER CARD BIRU MELENGKUNG (Sudah diperbaiki bebas typo)
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF5F8DFF),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5F8DFF).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  widget.classLevel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const Icon(Icons.menu_book_rounded, color: Colors.white70, size: 28),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            widget.className,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 6),
          // Selesai diperbaiki: Memakai warna putih dengan opacity transparan yang aman
          Text(
            'Kelola ruang lingkup materi, lihat statistik keaktifan pengerjaan kuis siswa, dan pelajari materi isyarat.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85), 
              fontSize: 12,
              height: 1.5,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // STATISTIK KHUSUS GURU
  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildSingleStat(Icons.people_alt_rounded, 'Ruang Kelas', 'Aktif'),
        const SizedBox(width: 12),
        _buildSingleStat(Icons.analytics_rounded, 'Kurikulum', '2026/Smt 2'),
      ],
    );
  }

  Widget _buildSingleStat(IconData icon, String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF3B72FF), size: 20),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF1A1D2E), fontWeight: FontWeight.w800, fontFamily: 'Poppins')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ITEM BARIS MATERI ELEGAN
  Widget _buildMateriItem({
    required String icon,
    required String title,
    required String subtitle,
    required String duration,
    required bool isCompleted,
    bool isQuiz = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isQuiz ? const Color(0xFFFFF4E5) : const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              icon,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: isQuiz ? const Color(0xFFFF9F43) : const Color(0xFF3B72FF),
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
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1D2E),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isQuiz ? Icons.assignment_rounded : Icons.play_circle_fill_rounded,
            color: isQuiz ? const Color(0xFFFF9F43) : const Color(0xFF3B72FF),
            size: 24,
          ),
        ],
      ),
    );
  }
}