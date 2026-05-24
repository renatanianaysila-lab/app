import 'package:flutter/material.dart';
import 'materi_murid.dart';

class BerandaMurid extends StatelessWidget {
  const BerandaMurid({super.key});

  final List<Map<String, dynamic>> levels = const [
    {
      'number': 1,
      'title': 'Beginner',
      'subtitle': 'Level Dasar',
      'materi': 12,
      'soal': 120,
      'progress': 0.75,
      'locked': false,
      'color': Color(0xFF3B72FF),
      'bgColor': Color(0xFFEEF2FF),
    },
    {
      'number': 2,
      'title': 'Intermediate',
      'subtitle': 'Level Menengah',
      'materi': 18,
      'soal': 180,
      'progress': 0.45,
      'locked': false,
      'color': Color(0xFF4CAF7D),
      'bgColor': Color(0xFFE8F9F0),
    },
    {
      'number': 3,
      'title': 'Advanced',
      'subtitle': 'Level Lanjutan',
      'materi': 24,
      'soal': 240,
      'progress': 0.0,
      'locked': true,
      'color': Color(0xFF9B59B6),
      'bgColor': Color(0xFFF5EEFF),
    },
  ];

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
                    ...levels.map((level) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _buildLevelCard(context, level),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
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
              'assets/images/user.png',
              fit: BoxFit.contain,
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MateriMurid(initialLevel: 'Beginner')),
            );
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
          // Header row
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

          // Stats row
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

          // Progress bar
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

          // Mulai Belajar button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: locked
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MateriMurid(
                            initialLevel: level['title'] as String,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: locked ? const Color(0xFFEBEBEB) : color,
                foregroundColor:
                    locked ? const Color(0xFF6B7280) : Colors.white,
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

  // ─── BOTTOM NAV ────────────────────────────────────────
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEBEBEB))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('assets/images/home.png', 'Beranda', true, null),
          _buildNavItem('assets/images/materinavbar.png', 'Materi', false, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MateriMurid(initialLevel: 'Beginner')),
            );
          }),
          _buildNavItem('assets/images/forum.png', 'Forum', false, null),
          _buildNavItem('assets/images/history.png', 'Riwayat', false, null),
          _buildNavItem('assets/images/profile.png', 'Profil', false, null),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      String iconPath, String label, bool isActive, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: isActive
                ? const EdgeInsets.symmetric(horizontal: 12, vertical: 4)
                : EdgeInsets.zero,
            decoration: isActive
                ? BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(10),
                  )
                : null,
            child: Image.asset(
              iconPath,
              width: 22,
              height: 22,
              color: isActive
                  ? const Color(0xFF3B72FF)
                  : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isActive
                  ? const Color(0xFF3B72FF)
                  : const Color(0xFF6B7280),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}