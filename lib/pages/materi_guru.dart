// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'video_play_page.dart';
import 'quiz_management_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MateriGuruPage extends StatefulWidget {
  final String initialLevel;
  final String initialClassName;
  final String guruId;
  final bool isFromHome;
  final VoidCallback? onBackToHome;

  const MateriGuruPage({
    super.key,
    this.initialLevel = 'Dasar',
    this.initialClassName = '',
    required this.guruId,
    this.isFromHome = false,
    this.onBackToHome,
  });

  @override
  State<MateriGuruPage> createState() => _MateriGuruPageState();
}

class _MateriGuruPageState extends State<MateriGuruPage> {
  late String _selectedLevel;
  final Map<String, bool> _modulExpanded = {}; 
  bool _isLoading = true;
  String _errorMessage = '';
  
  List<dynamic> _apiMateris = [];
  Map<String, List<dynamic>> _groupedModuls = {};

  // TEXT EDITING CONTROLLER
  final TextEditingController _modulController = TextEditingController();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _youtubeUrlController = TextEditingController(); 
  
  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.initialLevel;
    _fetchMateri();
  }

  @override
  void dispose() {
    _modulController.dispose();
    _judulController.dispose();
    _deskripsiController.dispose();
    _youtubeUrlController.dispose();
    super.dispose();
  }

  Future<void> _fetchMateri() async {
  setState(() {
    _isLoading = true;
    _groupedModuls.clear();
    _errorMessage = '';
  });

  try {
    // 1. Menggunakan 10.0.2.2 jika di emulator Android, atau 10.0.2.2 jika di Chrome/Web
    final String url = 'https://isyaratkita.alwaysdata.net/api/materis?kategori=$_selectedLevel&guru_id=${widget.guruId}';
    
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      
      // 2. Tambahkan pengecekan apakah 'data' ada dan berbentuk list
      final List<dynamic> dataMateri = responseData['data'] is List ? responseData['data'] : [];
      
      setState(() {
        _apiMateris = dataMateri;
        
        // 3. Grouping ulang ke dalam map
        for (var materi in _apiMateris) {
          String namaModul = materi['nama_modul']?.toString() ?? 'Modul Umum';
          if (!_groupedModuls.containsKey(namaModul)) {
            _groupedModuls[namaModul] = [];
          }
          _groupedModuls[namaModul]!.add(materi);
        }
        
        // 4. Jika data kosong setelah difetch, beri pesan informatif
        if (_groupedModuls.isEmpty) {
          _errorMessage = 'Belum ada materi untuk kategori $_selectedLevel';
        }
        
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = 'Server merespon: ${response.statusCode}';
        _isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'Gagal terhubung: $e';
      _isLoading = false;
    });
  }
}

  Future<void> _simpanMateriBaru() async {
    if (_modulController.text.trim().isEmpty || 
        _judulController.text.trim().isEmpty || 
        _youtubeUrlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form bertanda (*) wajib diisi!')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://isyaratkita.alwaysdata.net/api/materi'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'guru_id': widget.guruId,
          'nama_modul': _modulController.text,
          'judul': _judulController.text,
          'deskripsi': _deskripsiController.text,
          'video_url': _youtubeUrlController.text,
          'kategori': _selectedLevel,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _modulController.clear();
        _judulController.clear();
        _deskripsiController.clear();
        _youtubeUrlController.clear();

        Navigator.pop(context); 
        _fetchMateri(); 
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Materi baru berhasil ditambahkan!')),
        );
      } else {
        print("Gagal menyimpan: ${response.body}");
      }
    } catch (e) {
      print("Eror POST Materi: $e");
    }
  }

  void _switchLevel(String level) {
    setState(() { _selectedLevel = level; });
    _fetchMateri();
  }

  void _showTambahMateriDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Tambah Materi Baru', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _modulController,
                  decoration: InputDecoration(
                    labelText: 'Nama Modul *',
                    hintText: 'Contoh: Modul 1: Abjad A-Z',
                    labelStyle: const TextStyle(fontFamily: 'Poppins'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _judulController,
                  decoration: InputDecoration(
                    labelText: 'Judul Video/Materi *',
                    hintText: 'Contoh: Isyarat Huruf A',
                    labelStyle: const TextStyle(fontFamily: 'Poppins'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _youtubeUrlController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: 'Link Video YouTube *',
                    hintText: 'https://www.youtube.com/watch?v=...',
                    prefixIcon: const Icon(Icons.video_library, color: Colors.red),
                    labelStyle: const TextStyle(fontFamily: 'Poppins'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFFB800), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _deskripsiController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    labelStyle: const TextStyle(fontFamily: 'Poppins'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB800),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _simpanMateriBaru,
              child: const Text('Simpan', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: widget.isFromHome 
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1D2E)),
              onPressed: () => Navigator.pop(context),
            )
          : null, 
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFB800),
        onPressed: _showTambahMateriDialog,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            _buildLevelTabs(),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFB800)))
                : _errorMessage.isNotEmpty
                  ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red, fontFamily: 'Poppins')))
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: _groupedModuls.entries.map((entry) {
                        return _buildModulCard(entry.key, entry.value);
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: ['Dasar', 'Menengah', 'Lanjutan'].map((l) {
          final isSelected = _selectedLevel == l;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? const Color(0xFFFEF3C7) : const Color(0xFFE5E7EB),
                foregroundColor: isSelected ? const Color(0xFF000000) : Colors.grey[700],
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () => _switchLevel(l),
              child: Text(
                l == 'Menengah' ? 'Menengah' : l,
                style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins', fontSize: 13),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildModulCard(String namaModul, List<dynamic> materiList) {
    final isExpanded = _modulExpanded[namaModul] ?? false;
    
    IconData iconData = Icons.class_outlined;
    Color iconColor = const Color(0xFFFFB800);
    Color iconBgColor = const Color(0xFFFEF3C7);

    if (namaModul.contains('Abjad')) {
      iconData = Icons.font_download_outlined;
    } else if (namaModul.contains('Angka')) {
      iconData = Icons.tag_rounded;
    } else if (namaModul.contains('Ekspresi')) {
      iconData = Icons.sentiment_satisfied_alt_outlined;
    } else if (namaModul.contains('Percakapan')) {
      iconData = Icons.chat_bubble_outline_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: iconBgColor,
              child: Icon(iconData, color: iconColor, size: 24),
            ),
            title: Text(
              namaModul, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins', fontSize: 15, color: Color(0xFF1A1D2E)),
            ),
            subtitle: Row(
              children: [
                Text('${materiList.length} Video', style: const TextStyle(color: Colors.grey, fontFamily: 'Poppins', fontSize: 13)),
                const SizedBox(width: 4),
                Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0F9668),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _selectedLevel == 'Menengah' ? 'Menengah' : _selectedLevel,
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
              ),
            ),
            onTap: () => setState(() => _modulExpanded[namaModul] = !isExpanded),
          ),
          
if (isExpanded)
            Container(
              color: const Color(0xFFFAFAFC),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  // 1. Me-render semua daftar video materi Guru
                  ...materiList.map((m) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                      leading: const Icon(Icons.play_circle_fill, color: Color(0xFFFFB800), size: 22),
                      title: Text(
                        m['judul'] ?? 'Tanpa Judul',
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        String videoUrl = m['video_url'] ?? ''; 
                        String? convertedId = YoutubePlayer.convertUrlToId(videoUrl);

                        if (convertedId != null && convertedId.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayPage(
                                videoId: convertedId,
                                videoTitle: m['judul'] ?? 'Detail Video',
                                videoDescription: m['deskripsi'], 
                                modulName: namaModul, 
                                objectives: List<String>.from(m['objectives'] ?? [
                                  'Memahami instruksi visual materi terkait dengan baik.',
                                  'Menerapkan teknik gerakan isyarat secara mandiri dan presisi.'
                                ]),
                                isTeacher: true,
                                commentsReference: const [], 
                                onCommentUpdated: () => _fetchMateri(),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Link video YouTube materi ini tidak valid!')),
                          );
                        }
                      },
                    );
                  }).toList(),

                  // 🔥 2. MENU TAMBAHAN: Tombol Kelola Bank Soal Kuis Guru (Google Form Style)
                  const Divider(height: 1, indent: 24, endIndent: 24, color: Color(0xFFE5E7EB)),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                    leading: const Icon(Icons.assignment_rounded, color: Color(0xFFFFB800), size: 22),
                    title: Text(
                      'Kelola Kuis - $namaModul',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Color(0xFF1F2937)),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF9CA3AF)),
                    onTap: () {
                      // Ambil ID dari materi pertama di modul ini sebagai relasi database kuis
                      int? materiId = materiList.isNotEmpty ? materiList[0]['id'] : null;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizManagementPage(
                            quizTitle: 'Kuis $namaModul',
                            materiId: materiId,
                            level: _selectedLevel,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
