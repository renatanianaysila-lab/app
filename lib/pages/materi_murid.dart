import 'dart:convert';
import 'package:flutter/material.dart';
import 'video_play_page.dart';
import 'quiz_play_page.dart';
import 'package:http/http.dart' as http;

class MateriMurid extends StatefulWidget {
  final String initialLevel;
  const MateriMurid({super.key, this.initialLevel = 'Beginner'});

  @override
  State<MateriMurid> createState() => _MateriMuridState();
}

class _MateriMuridState extends State<MateriMurid> {
  late String _selectedLevel;
  final Map<int, bool> _expanded = {0: false, 1: false, 2: false, 3: false};
  bool _isLoading = true; // 2. Tambahkan state loading

  // ── DATA BEGINNER (Struktur asli dipertahankan) ──────────────────────
  final List<Map<String, dynamic>> _kategoriBeginner = [
    {
      'icon': 'assets/images/A.png',
      'iconBg': const Color(0xFFDEEAFF),
      'title': 'Abjad A-Z',
      'subtitle': null,
      'videoCount': 1,
      'premium': false,
      'items': [
        {'type': 'video', 'title': 'Dasar Bahasa Isyarat - Alfabet A-Z', 'done': true},
        {'type': 'kuis', 'title': 'Kuis: Abjad A-Z', 'score': '100/100', 'scoreColor': const Color(0xFF4CAF7D)},
      ],
    },
    {
      'icon': 'assets/images/#.png',
      'iconBg': const Color(0xFFDEF7EC),
      'title': 'Angka 1-10',
      'subtitle': null,
      'videoCount': 1,
      'premium': false,
      'items': [
        {'type': 'video', 'title': 'Angka dalam Bahasa Isyarat 1-100', 'done': true},
        {'type': 'kuis', 'title': 'Kuis: Angka 1-10', 'score': '60/100', 'scoreColor': const Color(0xFFE53E3E)}, 
      ],
    },
    {
      'icon': 'assets/images/ekspresi.png',
      'iconBg': const Color(0xFFF3E8FF),
      'title': 'Ekspresi',
      'subtitle': null,
      'videoCount': 5,
      'premium': false,
      'items': [
        {'type': 'video', 'title': 'Ekspresi Sehari-hari - Salam', 'done': true},
        {'type': 'kuis', 'title': 'Kuis: Ekspresi Sehari-hari', 'score': '95/100', 'scoreColor': const Color(0xFF4CAF7D)},
        {'type': 'video', 'title': 'Ekspresi Sehari-hari: Perasaan', 'done': false},
        {'type': 'kuis', 'title': 'Kuis: Ekspresi Perasaan', 'score': null, 'scoreColor': null},
      ],
    },
    {
      'icon': 'assets/images/percakapan.png',
      'iconBg': const Color(0xFFFFF3E0),
      'title': 'Percakapan Dasar',
      'subtitle': null,
      'videoCount': 0,
      'premium': false,
      'items': [], // Akan diisi dinamis dari Laravel
    },
  ];

  // ── DATA INTERMEDIATE (Struktur asli dipertahankan) ────────────────────────
  final List<Map<String, dynamic>> _kategoriIntermediate = [
    {
      'icon': 'assets/images/materi.png',
      'iconBg': const Color(0xFFEEF2FF),
      'title': 'Kosakata Lanjutan',
      'subtitle': 'Transportasi · Pekerjaan · Pendidikan',
      'videoCount': 5,
      'premium': true,
      'items': [],
    },
    {
      'icon': 'assets/images/percakapan.png',
      'iconBg': const Color(0xFFE8F9F0),
      'title': 'Percakapan Sehari-hari',
      'subtitle': '3-5 kalimat per sesi',
      'videoCount': 5,
      'premium': true,
      'items': [],
    },
    {
      'icon': 'assets/images/ekspresi.png',
      'iconBg': const Color(0xFFF3E8FF),
      'title': 'Ekspresi Wajah Lanjutan',
      'subtitle': 'Lanjutan dari Ekspresi Dasar',
      'videoCount': 5,
      'premium': true,
      'items': [],
    },
    {
      'icon': 'assets/images/img.png',
      'iconBg': const Color(0xFFFFF8EC),
      'title': 'Tanya Jawab Interaktif',
      'subtitle': 'Gabungan semua materi Dasar',
      'videoCount': 5,
      'premium': true,
      'items': [],
    },
  ];

  List<Map<String, dynamic>> get _currentKategori =>
      _selectedLevel == 'Beginner' ? _kategoriBeginner : _kategoriIntermediate;

  bool get _isPremiumLevel => _selectedLevel == 'Intermediate';

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.initialLevel;
    _fetchDataMateriLaravel(); 
  }

  
  Future<void> _fetchDataMateriLaravel() async {
    const String url = 'https://luther-nonrepayable-unguiltily.ngrok-free.dev/api/materi';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        List<dynamic> materiDariApi = responseData['data'];

        setState(() {
          
          for (var item in materiDariApi) {
            if (item['kategori'] == 'Percakapan') {
              
              _kategoriBeginner[3]['items'].add({
                'type': 'video',
                'title': item['judul'],
                'done': false,
              });
            }
          }
          
          _kategoriBeginner[3]['videoCount'] = _kategoriBeginner[3]['items'].length;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      
      setState(() => _isLoading = false);
    }
  }

  void _switchLevel(String level) {
    setState(() {
      _selectedLevel = level;
      _expanded.updateAll((key, value) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildSearchBar(),
            _buildLevelTabs(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF3B72FF)))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          if (_isPremiumLevel) ...[
                            _buildPremiumBanner(),
                            const SizedBox(height: 20),
                          ] else
                            const SizedBox(height: 4),
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
                          ...List.generate(_currentKategori.length, (i) {
                            return _buildKategoriCard(i);
                          }),
                          if (!_isPremiumLevel) ...[
                            const SizedBox(height: 8),
                            _buildOverallProgress(),
                          ],
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
          GestureDetector(
            onTap: () => Navigator.pop(context), // Sediakan fungsi back ke halaman BerandaMurid
            child: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF1A1D2E)),
          ),
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
            width: 28, 
            height: 28,
            errorBuilder: (_, __, ___) => const Icon(Icons.notifications_none, size: 28),
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

  // ─── LEVEL TABS ────────────────────────────────────────
  Widget _buildLevelTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          _buildTabChip('Beginner', const Color(0xFF3B72FF)),
          const SizedBox(width: 10),
          _buildTabChip('Intermediate', const Color(0xFF3B72FF)),
        ],
      ),
    );
  }

  Widget _buildTabChip(String level, Color activeColor) {
    final isActive = _selectedLevel == level;
    return GestureDetector(
      onTap: () => _switchLevel(level),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          level,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isActive ? Colors.white : const Color(0xFF6B7280),
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  // ─── PREMIUM BANNER ────────────────────────────────────
  Widget _buildPremiumBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B72FF), Color(0xFF7BA7FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('👑', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Konten Premium',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Upgrade untuk akses semua materi Intermediate',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Text(
                  'Upgrade',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF3B72FF),
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 14, color: Color(0xFF3B72FF)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── OVERALL PROGRESS ──────────────────────────────────
  Widget _buildOverallProgress() {
    final totalKategori = _kategoriBeginner.length;
    final selesai = _kategoriBeginner
        .where((k) => (k['items'] as List)
            .any((i) => i['type'] == 'video' && i['done'] == true))
        .length;
    final percent = totalKategori == 0 ? 0.0 : selesai / totalKategori;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded,
                  color: Color(0xFF3B72FF), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Progress Keseluruhan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1D2E),
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
              Text(
                '${(percent * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF3B72FF),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF3B72FF)),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressStat(
                'Selesai',
                '$selesai Kategori',
                const Color(0xFF4CAF7D),
                const Color(0xFFE8F9F0),
              ),
              _buildProgressStat(
                'Tersisa',
                '${totalKategori - selesai} Kategori',
                const Color(0xFFF5A623),
                const Color(0xFFFFF8EC),
              ),
              _buildProgressStat(
                'Total',
                '$totalKategori Kategori',
                const Color(0xFF3B72FF),
                const Color(0xFFEEF2FF),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(
      String label, String value, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // ─── KATEGORI CARD ─────────────────────────────────────
  Widget _buildKategoriCard(int index) {
    final item = _currentKategori[index];
    final isExpanded = _expanded[index] ?? false;
    final bool isPremium = item['premium'] as bool;
    final String? subtitle = item['subtitle'] as String?;

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
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: isPremium ? null : () {
              setState(() {
                _expanded[index] = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: item['iconBg'] as Color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      item['icon'] as String,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.menu_book_outlined,
                        color: Color(0xFF3B72FF),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1D2E),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${item['videoCount']} Video',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (isPremium) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.lock,
                                  size: 13, color: Color(0xFF9CA3AF)),
                            ] else ...[
                              const SizedBox(width: 4),
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 18,
                                color: const Color(0xFF6B7280),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: isPremium
                          ? const Color(0xFFF5A623)
                          : const Color(0xFF3B72FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isPremium ? 'Premium' : 'Beginner',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isPremium &&
              isExpanded &&
              (item['items'] as List).isNotEmpty) ...[
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: (item['items'] as List).map<Widget>((subItem) {
                  final isDone = subItem['done'] ?? false;
                  final isKuis = subItem['type'] == 'kuis';
                  final score = subItem['score'];
                  final scoreColor = subItem['scoreColor'] as Color?;
                  final hasScore = score != null;

                  // ── WARNA BACKGROUND SUBITEM ──
                  Color bgColor;
                  if (isKuis && hasScore && scoreColor != null) {
                    bgColor = scoreColor.withOpacity(0.1); 
                  } else if (!hasScore && isKuis) {
                    bgColor = const Color(0xFFF3F4F6); 
                  } else if (!isDone && !isKuis) {
                    bgColor = const Color(0xFFF3F4F6); 
                  } else {
                    bgColor = const Color(0xFFDEF7EC); 
                  }

                  return GestureDetector(
                    onTap: () {
                      if (isKuis) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizPlayPage(
                              quizTitle: subItem['title'] as String,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoPlayPage(
                              videoId: 'video_01', 
                              videoTitle: subItem['title'] as String, 
                              commentsReference: const <Map<String, dynamic>>[], 
                              onCommentUpdated: () {
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/iconhijau.png',
                            width: 24,
                            height: 24,
                            color: hasScore || isDone
                                ? (isKuis
                                    ? scoreColor
                                    : const Color(0xFF2D9F6B))
                                : const Color(0xFF9CA3AF),
                          ),
                          const SizedBox(width: 10),
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
                          if (isKuis && hasScore)
                            Text(
                              score as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                color: scoreColor,
                              ),
                            ),
                        ],
                      ),
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
}