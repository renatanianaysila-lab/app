import 'package:flutter/material.dart';

class PilihLevelQuizPage extends StatelessWidget {
  final String materiTitle;
  const PilihLevelQuizPage({super.key, required this.materiTitle});

  final List<Map<String, dynamic>> _levels = const [
    {
      'level': 1,
      'title': 'Level 1: Basic',
      'badge': 'EASY',
      'badgeColor': Color(0xFF4CAF7D),
      'soal': 10,
      'durasi': '5m',
      'quote': '"Soal acak dasar untuk pemula"',
      'locked': false,
      'lockReason': null,
      'iconBg': Color(0xFFE8F9F0),
      'iconColor': Color(0xFF4CAF7D),
      'icon': '#',
    },
    {
      'level': 2,
      'title': 'Level 2: Standard',
      'badge': 'MEDIUM',
      'badgeColor': Color(0xFFF5A623),
      'soal': 15,
      'durasi': '8m',
      'quote': null,
      'locked': true,
      'lockReason': 'Selesaikan Level Basic',
      'iconBg': Color(0xFFEEF2FF),
      'iconColor': Color(0xFF3B72FF),
      'icon': 'A',
    },
    {
      'level': 3,
      'title': 'Level 3: Intermediate',
      'badge': 'HARDER',
      'badgeColor': Color(0xFFE53E3E),
      'soal': 20,
      'durasi': '12m',
      'quote': null,
      'locked': true,
      'lockReason': null,
      'iconBg': Color(0xFFF3E8FF),
      'iconColor': Color(0xFF9B59B6),
      'icon': '⚡',
    },
    {
      'level': 4,
      'title': 'Final Assessment',
      'badge': 'CERTIFICATE',
      'badgeColor': Color(0xFF9B59B6),
      'soal': 25,
      'durasi': '15m',
      'quote': null,
      'locked': true,
      'lockReason': 'Ujian Akhir',
      'iconBg': Color(0xFFFFF8EC),
      'iconColor': Color(0xFFF5A623),
      'icon': '🏆',
    },
  ];

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
                    const SizedBox(height: 8),
                    const Text(
                      'Pilih Level Quiz',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1D2E),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pilih level untuk memulai evaluasi',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...List.generate(_levels.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _buildLevelCard(context, _levels[i]),
                      );
                    }),
                    const SizedBox(height: 10),
                    _buildInfoNote(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // ─── NAVBAR DOBEL LAMA SUDAH DIHAPUS BERSIH DI SINI ───
    );
  }

  // ─── TOP BAR ───────────────────────────────────────────
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
              'Quiz $materiTitle',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1D2E),
                fontFamily: 'Poppins',
              ),
            ),
          ),
          // 
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

  // ─── LEVEL CARD ────────────────────────────────────────
  Widget _buildLevelCard(BuildContext context, Map<String, dynamic> level) {
    final bool locked = level['locked'] as bool;
    final String? lockReason = level['lockReason'] as String?;
    final Color iconBg = level['iconBg'] as Color;
    final Color iconColor = level['iconColor'] as Color;
    final Color badgeColor = level['badgeColor'] as Color;
    final String icon = level['icon'] as String;
    final String? quote = level['quote'] as String?;
    final bool isFinal = level['level'] == 4;

    return Container(
      decoration: BoxDecoration(
        color: isFinal
            ? const Color(0xFFFFF8EC)
            : locked
                ? const Color(0xFFF9FAFB)
                : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isFinal
              ? const Color(0xFFF5A623).withOpacity(0.35)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: locked
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: locked ? const Color(0xFFF3F4F6) : iconBg,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  alignment: Alignment.center,
                  child: icon.runes.first > 127
                      ? Text(icon, style: const TextStyle(fontSize: 22))
                      : Text(
                          icon,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: locked ? const Color(0xFF9CA3AF) : iconColor,
                            fontFamily: 'Poppins',
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                // Title + badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            level['title'] as String,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: locked ? const Color(0xFF9CA3AF) : const Color(0xFF1A1D2E),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: locked ? const Color(0xFFE5E7EB) : badgeColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              level['badge'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: locked ? const Color(0xFF9CA3AF) : badgeColor,
                                fontFamily: 'Poppins',
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.quiz_outlined, size: 13, color: Color(0xFF9CA3AF)),
                          const SizedBox(width: 4),
                          Text(
                            '${level['soal']} Soal',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.timer_outlined, size: 13, color: Color(0xFF9CA3AF)),
                          const SizedBox(width: 4),
                          Text(
                            '${level['durasi']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Lock reason
            if (lockReason != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.lock, size: 14, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 6),
                  Text(
                    lockReason,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ],

            // Quote
            if (quote != null) ...[
              const SizedBox(height: 8),
              Text(
                quote,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                  fontFamily: 'Poppins',
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],

            const SizedBox(height: 14),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: locked ? null : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: locked ? const Color(0xFFE5E7EB) : const Color(0xFF3B72FF),
                  foregroundColor: locked ? const Color(0xFF9CA3AF) : Colors.white,
                  disabledBackgroundColor: const Color(0xFFE5E7EB),
                  disabledForegroundColor: const Color(0xFF9CA3AF),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  locked ? 'Terkunci' : 'Mulai Level ${level['level']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── INFO NOTE ─────────────────────────────────────────
  Widget _buildInfoNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: Color(0xFF3B72FF)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Penting: Soal akan diacak otomatis setiap kali quiz dimulai. Pastikan koneksi internet stabil untuk menyimpan progres pencapaian Anda.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3B72FF),
                fontFamily: 'Poppins',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}