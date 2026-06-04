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
  late String _selectedLevel;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set filter awal otomatis sesuai level kelas dari Beranda (Dasar / Menengah)
    _selectedLevel = widget.classLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ─── TOP HEADER BAR (Sesuai image_5dd078.png) ───
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1D2E), size: 20),
                onPressed: widget.onBack, // Kembali ke Beranda Utama
              ),
              const Expanded(
                child: Text(
                  'Materi Pembelajaran (Guru)',
                  style: TextStyle(
                    color: Color(0xFF1A1D2E),
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Poppins',
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // ─── SEARCH BAR ───
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.toLowerCase();
                });
              },
              decoration: const InputDecoration(
                hintText: 'Cari materi pembelajaran...',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontFamily: 'Poppins', fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Color(0xFF9CA3AF)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),

        // ─── TAB FILTER LEVEL REVISI (Dasar, Menengah, Lanjutan) ───
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildLevelTab('Dasar'),
              const SizedBox(width: 8),
              _buildLevelTab('Menengah'),
              const SizedBox(width: 8),
              _buildLevelTab('Lanjutan'),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ─── AREA DAFTAR MATERI SEPERTI DI GAMBAR image_5dd078.png ───
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // Hanya tampilkan data jika Tab Level yang dipilih COCOK dengan level kelas tersebut
              if (_selectedLevel == widget.classLevel) ...[
                _buildMateriCardDynamic(),
              ] else ...[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Text(
                      'Tidak ada materi kelas "${widget.className}" di tingkat $_selectedLevel.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLevelTab(String levelName) {
    final bool isActive = _selectedLevel == levelName;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLevel = levelName;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF3B72FF) : const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            levelName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13, 
              fontWeight: FontWeight.w800, 
              color: isActive ? Colors.white : const Color(0xFF3B72FF), 
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMateriCardDynamic() {
    if (_searchQuery.isNotEmpty && !widget.className.toLowerCase().contains(_searchQuery)) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('#', style: TextStyle(fontSize: 20, color: Color(0xFFFFB703), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.className, 
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A1D2E), fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 2),
                      const Row(
                        children: [
                          Text('1 Video', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF), fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                          SizedBox(width: 6),
                          Icon(Icons.keyboard_arrow_up_rounded, size: 16, color: Color(0xFF9CA3AF)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Badge indikator level dinamis sesuai data kelasnya
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.classLevel, 
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF3B72FF), fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEBEBEB)),
          _buildSubMateriRow(Icons.play_circle_fill_rounded, 'Dasar Pengenalan Isyarat - ${widget.className}', const Color(0xFF3B72FF)),
          _buildSubMateriRow(Icons.assignment_turned_in_rounded, 'Kuis Evaluasi - ${widget.className}', const Color(0xFF00C48C)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSubMateriRow(IconData iconData, String text, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(iconData, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text, 
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A1D2E), fontFamily: 'Poppins'),
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }
}