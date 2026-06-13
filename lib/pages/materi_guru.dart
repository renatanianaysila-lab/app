import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MateriGuruPage extends StatefulWidget {
  final String initialLevel;
  final String initialClassName;
  final String guruId; // Menyimpan ID guru yang dikirim dari beranda

  const MateriGuruPage({
    super.key,
    this.initialLevel = 'Dasar',
    this.initialClassName = '',
    required this.guruId, 
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

  // 🎯 TEXT EDITING CONTROLLER UNTUK FORM TAMBAH MATERI
  final TextEditingController _modulController = TextEditingController();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _youtubeUrlController = TextEditingController(); // Controller Link YouTube

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.initialLevel;
    _fetchMateri();
  }

  @override
  void dispose() {
    // Clean up controllers to avoid memory leaks
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
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/materis?kategori=$_selectedLevel&guru_id=${widget.guruId}'),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _apiMateris = responseData['data'];
          
          for (var materi in _apiMateris) {
            String namaModul = materi['nama_modul'] ?? 'Modul Umum';
            if (!_groupedModuls.containsKey(namaModul)) {
              _groupedModuls[namaModul] = [];
            }
            _groupedModuls[namaModul]!.add(materi);
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Server merespon dengan kode: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal terhubung ke server. Cek koneksi Laravel!';
        _isLoading = false;
      });
    }
  }

  // 🎯 LOGIKA KIRIM DATA KE API STORE LARAVEL
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
        Uri.parse('http://10.0.2.2:8000/api/materi'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'guru_id': widget.guruId,
          'nama_modul': _modulController.text, // Modul target
          'judul': _judulController.text,
          'deskripsi': _deskripsiController.text,
          'video_url': _youtubeUrlController.text, // Mengirim URL YouTube ke Backend
          'kategori': _selectedLevel, // Otomatis masuk ke level tab yang aktif saat ini
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Bersihkan form textfield setelah berhasil simpan
        _modulController.clear();
        _judulController.clear();
        _deskripsiController.clear();
        _youtubeUrlController.clear();

        Navigator.pop(context); // Tutup dialog
        _fetchMateri(); // Refresh data biar list materi langsung terupdate
        
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
                // 🎯 SEKARANG SUDAH ADA KOLOM INPUT LINK YOUTUBE
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
              onPressed: _simpanMateriBaru, // Menjalankan fungsi simpan terintegrasi API
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
        // ❌ ICON PLUS YANG DOUBLE DI SINI SUDAH DIHAPUS BERSIH
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1D2E)),
          onPressed: () => Navigator.pop(context),
        ),
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
                l == 'Menengah' ? 'Intermediate' : l,
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
                _selectedLevel == 'Menengah' ? 'Intermediate' : _selectedLevel,
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
                children: materiList.map((m) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  leading: const Icon(Icons.play_circle_fill, color: Color(0xFFFFB800), size: 22),
                  title: Text(
                    m['judul'] ?? 'Tanpa Judul',
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  subtitle: m['deskripsi'] != null ? Text(m['deskripsi'], style: const TextStyle(fontFamily: 'Poppins', fontSize: 12)) : null,
                )).toList(),
              ),
            ),
        ],
      ),
    );
  }
}