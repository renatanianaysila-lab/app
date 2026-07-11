import 'dart:convert';
import 'package:flutter/material.dart';
import 'video_play_page.dart';
import 'quiz_play_page.dart';
import 'tampilan_paket.dart';
import 'session.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String? _extractYoutubeId(String url) {
  final patterns = [
    RegExp(r'youtu\.be/([a-zA-Z0-9_-]{6,})'),
    RegExp(r'[?&]v=([a-zA-Z0-9_-]{6,})'),
  ];
  for (final p in patterns) {
    final match = p.firstMatch(url);
    if (match != null) return match.group(1);
  }
  return null;
}

String _mapTabToKategori(String tabLabel) {
  switch (tabLabel) {
    case 'Dasar':
      return 'Dasar';
    case 'Menengah':
      return 'Menengah';
    case 'Lanjutan':
      return 'Susah';
    default:
      return 'Dasar';
  }
}

String _mapKategoriToTab(String kategori) {
  switch (kategori) {
    case 'Dasar':
      return 'Dasar';
    case 'Menengah':
      return 'Menengah';
    case 'Susah':
      return 'Lanjutan';
    default:
      return 'Dasar';
  }
}

class ScoringService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<Map<String, dynamic>?> getQuizScoreByLevel({
    required String userId,
    required String level,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/quiz-scores?user_id=$userId&level=$level'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        }
      }
    } catch (e) {
      debugPrint('Error fetch kuis score: $e');
    }
    return null;
  }
}

class MateriMurid extends StatefulWidget {
  final String initialLevel;
  const MateriMurid({super.key, this.initialLevel = 'Dasar'});

  @override
  State<MateriMurid> createState() => _MateriMuridState();
}

class _MateriMuridState extends State<MateriMurid> {
  late String _selectedLevel;
  Map<int, bool> _expanded = {};
  bool _isLoading = true;
  bool _hasError = false;

  List<Map<String, dynamic>> _kategoriAktif = [];
  String _muridId = '';

  static const List<Map<String, dynamic>> _iconPalette = [
    {'icon': 'assets/images/A.png', 'bg': Color(0xFFDEEAFF)},
    {'icon': 'assets/images/123.png', 'bg': Color(0xFFFFEAD2)},
    {'icon': 'assets/images/smile.png', 'bg': Color(0xFFE2FBE7)},
    {'icon': 'assets/images/chat.png', 'bg': Color(0xFFFCE1E4)},
  ];

  @override
  void initState() {
    super.initState();
    _selectedLevel = _mapKategoriToTab(widget.initialLevel);
    _initData();
  }

  Future<void> _initData() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('murid_id') ?? '';

    if (!mounted) return;

    setState(() {
      _muridId = id;
    });

    _loadDataFromBackend();
  }

  Future<void> _loadDataFromBackend() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    final kategoriDb = _mapTabToKategori(_selectedLevel);

    try {
      final res = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/materis'),
        headers: {'Accept': 'application/json'},
      );

      if (res.statusCode != 200) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return;
      }

      final decoded = jsonDecode(res.body);
      if (decoded['success'] != true) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return;
      }

      final List<dynamic> allMateri = decoded['data'];
      final filtered = allMateri.where((m) => m['kategori'] == kategoriDb).toList();

      final Map<String, List<dynamic>> grouped = {};
      for (final m in filtered) {
        final modul = (m['nama_modul'] as String?) ?? 'Materi Lainnya';
        grouped.putIfAbsent(modul, () => []).add(m);
      }

      final skorLevel = await ScoringService.getQuizScoreByLevel(
        userId: _muridId,
        level: kategoriDb,
      );

      final skorText = (skorLevel != null && skorLevel['skor'] != null)
          ? '${skorLevel['skor']}/100'
          : '-';

      int paletteIndex = 0;
      final List<Map<String, dynamic>> hasil = [];
      grouped.forEach((modulTitle, materiList) {
        final palette = _iconPalette[paletteIndex % _iconPalette.length];
        paletteIndex++;

        final items = <Map<String, dynamic>>[];
        for (final m in materiList) {
          items.add({
            'type': 'video',
            'title': m['judul'] as String? ?? 'Materi',
            'video_url': m['video_url'] as String? ?? '',
            'deskripsi': m['deskripsi'] as String? ?? '',
            'done': false,
          });
        }
        items.add({
          'type': 'kuis',
          'title': 'Kuis: $modulTitle',
          'score': skorText,
          'kuis_id': null,
        });

        hasil.add({
          'icon': palette['icon'],
          'iconBg': palette['bg'],
          'title': modulTitle,
          'subtitle': null,
          'videoCount': materiList.length,
          'items': items,
        });
      });

      setState(() {
        _kategoriAktif = hasil;
        _expanded = {for (int i = 0; i < hasil.length; i++) i: false};
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error load materi: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _switchLevel(String level) {
    setState(() {
      _selectedLevel = level;
    });
    _loadDataFromBackend();
  }

  void _showPremiumOfferDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xFFFEF3C7),
              child: Icon(Icons.workspace_premium_rounded, size: 40, color: Colors.amber),
            ),
            const SizedBox(height: 16),
            Text(
              'Buka Akses Level $_selectedLevel',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Materi video level ini hanya tersedia untuk pengguna Premium.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TampilanPaket()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text('Lihat Paket Premium',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Nanti Saja', style: TextStyle(color: Colors.black54)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> kategoriAktif = _kategoriAktif;
    final bool isLocked = _selectedLevel != 'Dasar' && !AppSession.isPremium;

    debugPrint('CEK STATUS PREMIUM: ${AppSession.isPremium}');

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Materi Pembelajaran',
          style: TextStyle(
            color: Color(0xFF1A1D2E),
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari materi pembelajaran...',
                    hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Poppins', fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            // TABS LEVEL SAKLAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: ['Dasar', 'Menengah', 'Lanjutan'].map((level) {
                  final isSelected = _selectedLevel == level;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? const Color(0xFF3B72FF) : const Color(0xFFE5E7EB),
                        foregroundColor: isSelected ? Colors.white : Colors.grey[700],
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      onPressed: () => _switchLevel(level),
                      child: Text(
                        level,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins', fontSize: 13),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // BANNER KONTEN PREMIUM (muncul kalau level ini terkunci)
            if (isLocked)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white24,
                        child: Text('👑', style: TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Konten Premium',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Upgrade untuk akses semua materi $_selectedLevel',
                              style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TampilanPaket()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Upgrade →', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                      ),
                    ],
                  ),
                ),
              ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Kategori Pembelajaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1D2E),
                  fontFamily: 'Poppins',
                ),
              ),
            ),

            // LIST ELEMEN UTAMA
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFB800)))
                  : _hasError
                      ? _buildErrorState()
                      : kategoriAktif.isEmpty
                          ? const Center(
                              child: Text(
                                'Belum ada materi untuk level ini.',
                                style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: kategoriAktif.length,
                              itemBuilder: (context, index) {
                                return _buildKategoriCard(kategoriAktif[index], index, isLocked);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 40, color: Color(0xFF9CA3AF)),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat materi dari server.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadDataFromBackend,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB800)),
              child: const Text('Coba Lagi', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKategoriCard(Map<String, dynamic> kategori, int index, bool isLocked) {
    bool isExpanded = _expanded[index] ?? false;
    List<Map<String, dynamic>> subItems = kategori['items'] as List<Map<String, dynamic>>;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: kategori['iconBg'] as Color,
              child: Image.asset(
                kategori['icon'] as String,
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.class_outlined, color: Color(0xFFFFB800));
                },
              ),
            ),
            title: Text(
              kategori['title'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                fontSize: 15,
                color: Color(0xFF1A1D2E),
              ),
            ),
            subtitle: Row(
              children: [
                Text(
                  '${kategori['videoCount']} Video',
                  style: const TextStyle(color: Colors.grey, fontFamily: 'Poppins', fontSize: 13),
                ),
                const SizedBox(width: 4),
                if (isLocked)
                  const Icon(Icons.lock, size: 14, color: Colors.grey)
                else
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 16,
                    color: Colors.grey,
                  ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isLocked ? const Color(0xFFF5A623) : const Color(0xFF0F9668),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isLocked ? 'Premium' : 'Gratis',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            onTap: () {
              if (isLocked) {
                _showPremiumOfferDialog();
              } else {
                setState(() {
                  _expanded[index] = !isExpanded;
                });
              }
            },
          ),
          if (isExpanded && !isLocked) ...[
            Container(
              color: const Color(0xFFFAFAFC),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: subItems.map((subItem) {
                  bool isKuis = subItem['type'] == 'kuis';
                  dynamic score = subItem['score'];
                  bool hasScore = isKuis && score != null && score != '-';
                  bool isDone = !isKuis && (subItem['done'] == true);

                  Color scoreColor = Colors.grey;
                  if (hasScore) {
                    int numericScore = int.tryParse(score.toString().split('/').first) ?? 0;
                    scoreColor = numericScore >= 75 ? const Color(0xFF2D9F6B) : const Color(0xFFEF4444);
                  }

                  return InkWell(
                    onTap: () {
                      if (isKuis) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizPlayPage(
                              quizTitle: subItem['title'] as String,
                            ),
                          ),
                        ).then((_) => _loadDataFromBackend());
                      } else {
                        final videoId = _extractYoutubeId(subItem['video_url'] as String? ?? '') ?? '';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayPage(
                              videoId: videoId,
                              videoTitle: subItem['title'] as String,
                              videoDescription: subItem['deskripsi'] as String? ??
                                  'Selamat datang di kelas materi visual.',
                              modulName: kategori['title'] as String,
                              objectives: List<String>.from([
                                'Memahami bentuk instruksi visual materi secara mendalam.',
                                'Mampu mempraktikkan gerakan isyarat secara mandiri dengan presisi.'
                              ]),
                              isTeacher: false,
                              commentsReference: [],
                              onCommentUpdated: () {},
                            ),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            isKuis ? Icons.assignment_outlined : Icons.play_circle_fill,
                            size: 20,
                            color: isKuis
                                ? (hasScore ? const Color(0xFFFFB800) : const Color(0xFF9CA3AF))
                                : const Color(0xFFFFB800),
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
