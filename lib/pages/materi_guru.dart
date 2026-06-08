import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MateriGuruPage extends StatefulWidget {
  final String initialLevel;
  final String initialClassName;

  const MateriGuruPage({
    super.key,
    this.initialLevel = 'Dasar',
    this.initialClassName = '',
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

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.initialLevel;
    _fetchMateri();
  }

  Future<void> _fetchMateri() async {
    setState(() {
      _isLoading = true;
      _groupedModuls.clear();
      _errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/materi?kategori=$_selectedLevel'),
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

  void _switchLevel(String level) {
    setState(() { _selectedLevel = level; });
    _fetchMateri();
  }

  // Fungsi popup/dialog untuk tambah materi baru
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
                  decoration: InputDecoration(
                    labelText: 'Nama Modul',
                    hintText: 'Contoh: Modul 1: Abjad A-Z',
                    labelStyle: const TextStyle(fontFamily: 'Poppins'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Judul Video/Materi',
                    hintText: 'Contoh: Isyarat Huruf A',
                    labelStyle: const TextStyle(fontFamily: 'Poppins'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
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
                backgroundColor: const Color(0xFF3B72FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                // TODO: Hubungkan ke API POST Laravel untuk simpan materi
                Navigator.pop(context);
              },
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
        actions: [
          // Tambah tombol aksi juga di top bar biar opsional
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF3B72FF), size: 28),
            onPressed: _showTambahMateriDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      
      // ── TOMBOL TAMBAH MATERI DI POJOK BAWAH ──
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3B72FF),
        onPressed: _showTambahMateriDialog,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar bawaan designmu
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
                ? const Center(child: CircularProgressIndicator(color: Colors.blue))
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
                backgroundColor: isSelected ? const Color(0xFFE2F0D9) : const Color(0xFFE5E7EB),
                foregroundColor: isSelected ? const Color(0xFF2E7D32) : Colors.grey[700],
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
    Color iconColor = Colors.blue;
    Color iconBgColor = const Color(0xFFEEF2FF);

    if (namaModul.contains('Abjad')) {
      iconData = Icons.font_download_outlined;
      iconColor = Colors.blue;
      iconBgColor = const Color(0xFFE0E7FF);
    } else if (namaModul.contains('Angka')) {
      iconData = Icons.tag_rounded;
      iconColor = Colors.green;
      iconBgColor = const Color(0xFFDCFCE7);
    } else if (namaModul.contains('Ekspresi')) {
      iconData = Icons.sentiment_satisfied_alt_outlined;
      iconColor = Colors.purple;
      iconBgColor = const Color(0xFFF3E8FF);
    } else if (namaModul.contains('Percakapan')) {
      iconData = Icons.chat_bubble_outline_rounded;
      iconColor = Colors.orange;
      iconBgColor = const Color(0xFFFFEDD5);
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
                _selectedLevel,
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
                  leading: const Icon(Icons.play_circle_fill, color: Colors.blue, size: 22),
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