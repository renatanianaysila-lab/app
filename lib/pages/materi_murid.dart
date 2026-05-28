import 'package:flutter/material.dart';

class MateriMurid extends StatefulWidget {
  const MateriMurid({super.key});

  @override
  State<MateriMurid> createState() => _MateriMuridState();
}

class _MateriMuridState extends State<MateriMurid> {
  // Track which kategori sedang di-expand
  final Map<int, bool> _expanded = {
    0: false,
    1: false,
    2: false,
    3: false,
  };

  final List<Map<String, dynamic>> _kategori = [
    {
      'icon': 'assets/images/A.png',
      'iconBg': Color(0xFFDEEAFF),
      'title': 'Abjad A-Z',
      'videoCount': 1,
      'items': [
        {'type': 'video', 'title': 'Dasar Bahasa Isyarat - Alfabet A-Z', 'done': true},
        {'type': 'kuis', 'title': 'Kuis: Abjad A-Z', 'score': '100/100', 'scoreColor': Color(0xFF4CAF7D)},
      ],
    },
    {
      'icon': 'assets/images/#.png',
      'iconBg': Color(0xFFDEF7EC),
      'title': 'Angka 1-10',
      'videoCount': 1,
      'items': [
        {'type': 'video', 'title': 'Angka dalam Bahasa Isyarat 1-100', 'done': true},
        {'type': 'kuis', 'title': 'Kuis: Angka 1-10', 'score': '60/100', 'scoreColor': Color(0xFFE53E3E)},
      ],
    },
    {
      'icon': 'assets/images/ekspresi.png',
      'iconBg': Color(0xFFF3E8FF),
      'title': 'Ekspresi',
      'videoCount': 5,
      'items': [
        {'type': 'video', 'title': 'Ekspresi Sehari-hari - Salam', 'done': true},
        {'type': 'kuis', 'title': 'Kuis: Ekspresi Sehari-hari', 'score': '95/100', 'scoreColor': Color(0xFF4CAF7D)},
        {'type': 'video', 'title': 'Ekspresi Sehari-hari: Perasaan', 'done': true},
        {'type': 'kuis', 'title': 'Kuis: Angka 1-10', 'score': '100/100', 'scoreColor': Color(0xFF4CAF7D)},
        {'type': 'video', 'title': 'Ekspresi Sehari-hari', 'done': true},
        {'type': 'video', 'title': 'Ekspresi Sehari-hari', 'done': true},
        {'type': 'kuis', 'title': 'Kuis: Angka 1-10', 'score': '68/100', 'scoreColor': Color(0xFFE53E3E)},
        {'type': 'kuis', 'title': 'Kuis: Angka 1-10', 'score': '82/100', 'scoreColor': Color(0xFFE53E3E)},
        {'type': 'video', 'title': 'Ekspresi Sehari-hari', 'done': false},
        {'type': 'kuis', 'title': 'Kuis: Angka 1-10', 'score': null, 'scoreColor': null},
      ],
    },
    {
      'icon': 'assets/images/percakapan.png',
      'iconBg': Color(0xFFFFF3E0),
      'title': 'Percakapan Dasar',
      'videoCount': 10,
      'items': [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            _buildTopBar(),

            // SEARCH
            _buildSearchBar(),

            // CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Kategori Pembelajaran',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1D2E),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 14),

                    // KATEGORI LIST
                    ...List.generate(_kategori.length, (i) {
                      return _buildKategoriCard(i);
                    }),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAV
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── TOP BAR ───────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu, size: 24, color: Color(0xFF1A1D2E)),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Materi Pembelajaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1D2E),
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Image.asset(
            'assets/images/lonceng.png',
            width: 26,
            height: 26,
          ),
        ],
      ),
    );
  }

  // ─── SEARCH BAR ────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
            SizedBox(width: 10),
            Text(
              'Cari materi pembelajaran...',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── KATEGORI CARD ─────────────────────────────────────
  Widget _buildKategoriCard(int index) {
    final item = _kategori[index];
    final isExpanded = _expanded[index] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: item['iconBg'] as Color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(item['icon'] as String, fit: BoxFit.contain),
                ),

                const SizedBox(height: 10),

                // Title
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1D2E),
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 4),

                // Video count + dropdown toggle
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _expanded[index] = !isExpanded;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        '${item['videoCount']} Video',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 18,
                        color: const Color(0xFF6B7280),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // DROPDOWN CONTENT
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: (item['items'] as List).map<Widget>((subItem) {
                  final isDone = subItem['done'] ?? false;
                  final isKuis = subItem['type'] == 'kuis';
                  final score = subItem['score'];
                  final scoreColor = subItem['scoreColor'];
                  final hasScore = score != null;

                  // Warna background item
                  Color bgColor;
                  if (!hasScore && isKuis) {
                    bgColor = const Color(0xFFF3F4F6); // belum dikerjakan
                  } else if (!isDone && !isKuis) {
                    bgColor = const Color(0xFFF3F4F6); // video belum ditonton
                  } else {
                    bgColor = const Color(0xFFDEF7EC); // selesai/hijau
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        // Icon video/kuis
                        Image.asset(
                          'assets/images/iconhijau.png',
                          width: 24,
                          height: 24,
                          color: hasScore || isDone
                              ? (isKuis
                                  ? (scoreColor as Color?)
                                  : const Color(0xFF2D9F6B))
                              : const Color(0xFF9CA3AF),
                        ),
                        const SizedBox(width: 10),

                        // Title
                        Expanded(
                          child: Text(
                            subItem['title'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: hasScore || isDone
                                  ? const Color(0xFF1A1D2E)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ),

                        // Score (kuis only)
                        if (isKuis && hasScore)
                          Text(
                            score as String,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              color: scoreColor as Color,
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
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
          _buildNavItem('assets/images/home.png', 'Beranda', false),
          _buildNavItem('assets/images/materinavbar.png', 'Materi', true),
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
    );
  }
}