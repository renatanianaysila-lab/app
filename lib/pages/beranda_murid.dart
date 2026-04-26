import 'package:flutter/material.dart';

class BerandaMurid extends StatelessWidget {
  const BerandaMurid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            _buildTopBar(),

            // SCROLL CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // HERO BANNER
                    _buildHeroBanner(),

                    const SizedBox(height: 16),

                    // MULAI BELAJAR BUTTON
                    _buildCTAButton(),

                    const SizedBox(height: 20),

                    // MATERI SECTION TITLE
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Materi untuk Pemula',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1A1D2E),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // MATERI LIST
                    _buildMateriCard(
                      iconPath: 'assets/images/A.png',
                      iconBg: const Color(0xFFEEF2FF),
                      title: 'Abjad A–Z',
                      subtitle: 'Pelajari huruf abjad\ndalam bahasa isyarat',
                      btnColor: const Color(0xFF3B72FF),
                    ),
                    const SizedBox(height: 12),
                    _buildMateriCard(
                      iconPath: 'assets/images/#.png',
                      iconBg: const Color(0xFFE8F9F0),
                      title: 'Angka 1–10',
                      subtitle: 'Pelajari angka dasar\ndalam bahasa isyarat',
                      btnColor: const Color(0xFF4CAF7D),
                    ),
                    const SizedBox(height: 12),
                    _buildMateriCard(
                      iconPath: 'assets/images/ekspresi.png',
                      iconBg: const Color(0xFFFFF8EC),
                      title: 'Ekspresi Dasar',
                      subtitle: 'Pelajari ekspresi dan\nemosi dasar',
                      btnColor: const Color(0xFFF5A623),
                    ),
                    const SizedBox(height: 12),
                    _buildMateriCard(
                      iconPath: 'assets/images/percakapan.png',
                      iconBg: const Color(0xFFF5EEFF),
                      title: 'Percakapan Dasar',
                      subtitle: 'Pelajari percakapan\nsehari-hari',
                      btnColor: const Color(0xFF9B59B6),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── TOP BAR ───────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Avatar
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

          // Greeting
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

          // Notif button
          Container(
  width: 70,
  height: 70,
  decoration: BoxDecoration(
    color: const Color(0xFFEEF2FF),
    borderRadius: BorderRadius.circular(50),
  ),
  child: IconButton(
    icon: Image.asset(
      'assets/images/lonceng.png',
      width: 50,
      height: 50,
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
          // Text
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

          // Hand icon
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
            ),
          ),
        ],
      ),
    );
  }

  // ─── CTA BUTTON ────────────────────────────────────────
  Widget _buildCTAButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
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

  // ─── MATERI CARD ───────────────────────────────────────
  Widget _buildMateriCard({
    required String iconPath,
    required Color iconBg,
    required String title,
    required String subtitle,
    required Color btnColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset(iconPath, fit: BoxFit.contain),
          ),
          const SizedBox(width: 14),

          // Title & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1D2E),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                    fontFamily: 'Poppins',
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Mulai button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Mulai',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── BOTTOM NAV ────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEBEBEB))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('assets/images/home.png', 'Beranda', true),
          _buildNavItem('assets/images/materi.png', 'Materi', false),
          _buildNavItem('assets/images/forum.png', 'Forum', false),
          _buildNavItem('assets/images/history.png', 'Riwayat', false),
          _buildNavItem('assets/images/profile.png', 'Profil', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, bool isActive) {
    return Column(
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
            color: isActive ? const Color(0xFF3B72FF) : const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isActive ? const Color(0xFF3B72FF) : const Color(0xFF6B7280),
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}