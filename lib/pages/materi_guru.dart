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
  final Map<int, bool> _expanded = {};
  bool _isLoading = true;
  String _errorMessage = '';
  List<dynamic> _apiMateris = [];

  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _cardKeys = List.generate(30, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.initialLevel;
    _fetchMateri();

    if (widget.initialClassName.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _autoExpandAndScroll();
      });
    }
  }

  // ── FETCH DATA DARI API ───────────────────────────────────────────
  Future<void> _fetchMateri() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _expanded.clear();
    });

    try {
      // NOTE: Emulator Android → 10.0.2.2 | Web/iOS Simulator → localhost
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/materi?kategori=$_selectedLevel'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          setState(() {
            _apiMateris = responseData['data'];
            _isLoading = false;
          });

          // Auto-expand setelah data berhasil dimuat
          if (widget.initialClassName.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _autoExpandAndScroll();
            });
          }
        } else {
          setState(() {
            _errorMessage = 'Gagal memuat data dari server.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Server error (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Tidak bisa terhubung ke server.\nPastikan Laravel sudah menyala!';
        _isLoading = false;
      });
    }
  }

  void _switchLevel(String level) {
    setState(() {
      _selectedLevel = level;
      _expanded.clear();
    });
    _fetchMateri();
  }

  // ── AUTO EXPAND & SCROLL KE KATEGORI YANG DIPILIH ────────────────
  void _autoExpandAndScroll() {
    for (int i = 0; i < _apiMateris.length; i++) {
      final judul = (_apiMateris[i]['judul'] ?? '').toString().toLowerCase();
      final dipilih = widget.initialClassName.toLowerCase();

      final kataJudul = judul.split(' ')[0];
      final kataDipilih = dipilih.split(' ')[0];

      if (judul.contains(kataDipilih) || dipilih.contains(kataJudul)) {
        setState(() {
          _expanded[i] = true;
        });

        Future.delayed(const Duration(milliseconds: 350), () {
          if (!mounted) return;
          final ctx = _cardKeys[i].currentContext;
          if (ctx != null) {
            Scrollable.ensureVisible(
              ctx,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              alignment: 0.1,
            );
          }
        });
        break;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ── POPUP TAMBAH MATERI ───────────────────────────────────────────
  void _showAddMateriDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tambah Materi Baru',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Color(0xFF1A1D2E),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close_rounded,
                        size: 20, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDialogField(
                controller: titleController,
                label: 'Judul Materi*',
                hint: 'Masukkan judul materi...',
              ),
              const SizedBox(height: 14),
              _buildDialogField(
                controller: descController,
                label: 'Deskripsi Video',
                hint: 'Masukkan deskripsi...',
                maxLines: 3,
              ),
              const SizedBox(height: 14),
              const Text(
                'Thumbnail',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF1A1D2E),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Buat gambar mini yang menarik perhatian.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFE5E7EB), width: 1.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_to_photos_outlined,
                        size: 24, color: Colors.grey[500]),
                    const SizedBox(height: 4),
                    Text(
                      'Upload File',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    // TODO: POST ke API tambah materi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Materi baru berhasil ditambahkan!',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                        backgroundColor: const Color(0xFFFFB703),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                    _fetchMateri(); // Refresh data
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB703),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Selesai',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── POPUP EDIT MATERI ─────────────────────────────────────────────
  void _showEditDialog(String currentTitle, String type, int apiIndex) {
    final titleController = TextEditingController(text: currentTitle);
    final descController = TextEditingController(
      text: type == 'video'
          ? (_apiMateris[apiIndex]['deskripsi'] ?? '')
          : 'Deskripsi kuis evaluasi ini...',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    type == 'video' ? 'Edit Materi Video' : 'Edit Kuis',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Color(0xFF1A1D2E),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close_rounded,
                        size: 20, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDialogField(
                controller: titleController,
                label: 'Judul*',
                hint: 'Masukkan judul...',
              ),
              const SizedBox(height: 14),
              _buildDialogField(
                controller: descController,
                label: type == 'video' ? 'Deskripsi Video' : 'Deskripsi Kuis',
                hint: 'Masukkan deskripsi...',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    // TODO: PUT ke API update materi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Perubahan berhasil disimpan!',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                        backgroundColor: const Color(0xFF3B72FF),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                    _fetchMateri(); // Refresh data
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B72FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── DIALOG KONFIRMASI HAPUS ───────────────────────────────────────
  void _showDeleteDialog(String judulMateri, int apiIndex) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Hapus Materi?',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Color(0xFF1A1D2E),
          ),
        ),
        content: Text(
          'Kamu yakin ingin menghapus "$judulMateri"?\nTindakan ini tidak bisa dibatalkan.',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              // TODO: DELETE ke API
              // final id = _apiMateris[apiIndex]['id'];
              // await http.delete(Uri.parse('http://10.0.2.2:8000/api/materi/$id'));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '"$judulMateri" berhasil dihapus.',
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  backgroundColor: const Color(0xFFDC2626),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(16),
                ),
              );
              _fetchMateri(); // Refresh data
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── HELPER FIELD DIALOG ───────────────────────────────────────────
  Widget _buildDialogField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Color(0xFF1A1D2E),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: Color(0xFF1A1D2E),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Color(0xFF9CA3AF),
            ),
            filled: true,
            fillColor: const Color(0xFFF7F8FC),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF3B72FF), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildSearchBar(),
            _buildLevelTabs(),
            const SizedBox(height: 4),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF3B72FF),
                        strokeWidth: 2.5,
                      ),
                    )
                  : _errorMessage.isNotEmpty
                      ? _buildErrorView()
                      : _apiMateris.isEmpty
                          ? _buildEmptyView()
                          : SingleChildScrollView(
                              controller: _scrollController,
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Tombol Tambah Materi
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: _showAddMateriDialog,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 9),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFB703),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.add_circle_outline_rounded,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'Tambah Materi Baru',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  const Text(
                                    'Kategori Pembelajaran',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1A1D2E),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // List kategori dari API
                                  ...List.generate(
                                    _apiMateris.length,
                                    (i) => _buildKategoriCard(i),
                                  ),
                                ],
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  // ── TOP BAR ──────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          if (Navigator.canPop(context))
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.only(right: 14),
                child: Icon(Icons.arrow_back_ios_new,
                    size: 20, color: Color(0xFF1A1D2E)),
              ),
            ),
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
          const Icon(Icons.notifications_none,
              size: 26, color: Color(0xFF1A1D2E)),
        ],
      ),
    );
  }

  // ── SEARCH BAR ───────────────────────────────────────────────────
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

  // ── LEVEL TABS ───────────────────────────────────────────────────
  Widget _buildLevelTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          _buildTabChip('Dasar'),
          const SizedBox(width: 10),
          _buildTabChip('Menengah'),
          const SizedBox(width: 10),
          _buildTabChip('Lanjutan'),
        ],
      ),
    );
  }

  Widget _buildTabChip(String level) {
    final isActive = _selectedLevel == level;
    return GestureDetector(
      onTap: () => _switchLevel(level),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF3B72FF)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(24),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B72FF).withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
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

  // ── KATEGORI CARD DARI DATA API ───────────────────────────────────
  Widget _buildKategoriCard(int index) {
    final item = _apiMateris[index];
    final isExpanded = _expanded[index] ?? false;

    // Ambil data dari response API
    final String judul = item['judul'] ?? 'Tanpa Judul';
    final String kategori = item['kategori'] ?? _selectedLevel;
    final String deskripsi = item['deskripsi'] ?? 'Tidak ada deskripsi.';
    final String videoUrl = item['video_url'] ?? '';
    final int siswaCount = item['siswa_count'] ?? 0;
    final int selesaiCount = item['selesai_count'] ?? 0;
    final int soalCount = item['soal_count'] ?? 0;

    // Icon dinamis dari huruf pertama judul
    final String iconText = judul.isNotEmpty ? judul[0].toUpperCase() : 'M';

    // Warna icon berdasarkan level
    final Color iconBg = kategori == 'Dasar'
        ? const Color(0xFFDEEAFF)
        : kategori == 'Menengah'
            ? const Color(0xFFF3E8FF)
            : const Color(0xFFFFE4E1);

    final Color iconColor = kategori == 'Dasar'
        ? const Color(0xFF3B72FF)
        : kategori == 'Menengah'
            ? const Color(0xFF9B59B6)
            : const Color(0xFFE74C3C);

    final Color badgeColor = kategori == 'Dasar'
        ? const Color(0xFF3B72FF)
        : kategori == 'Menengah'
            ? const Color(0xFF9B59B6)
            : const Color(0xFFE74C3C);

    return Container(
      key: _cardKeys[index],
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
        children: [
          // ── HEADER KARTU ──────────────────────────────────
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              setState(() {
                _expanded[index] = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon huruf pertama
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      iconText,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: iconColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Judul & info video
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          judul,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1D2E),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '1 Video',
                              style: const TextStyle(
                                fontSize: 12,
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
                      ],
                    ),
                  ),
                  // Badge level
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      kategori,
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

          // ── ISI EXPAND ────────────────────────────────────
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  // Item Video
                  _buildSubItem(
                    type: 'video',
                    title: judul,
                    subtitle:
                        '$siswaCount Siswa · $selesaiCount Selesai · ${siswaCount - selesaiCount} Belum',
                    apiIndex: index,
                  ),
                  const SizedBox(height: 10),
                  // Item Kuis
                  _buildSubItem(
                    type: 'kuis',
                    title: 'Kuis: $judul',
                    subtitle:
                        '$soalCount Soal di bank · Tampil 10/kuis',
                    apiIndex: index,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── SUB ITEM VIDEO / KUIS ─────────────────────────────────────────
  Widget _buildSubItem({
    required String type,
    required String title,
    required String subtitle,
    required int apiIndex,
  }) {
    final isKuis = type == 'kuis';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color:
            isKuis ? const Color(0xFFFFF4E5) : const Color(0xFFEEF7FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isKuis
                ? Icons.assignment_rounded
                : Icons.play_circle_fill_rounded,
            size: 22,
            color: isKuis
                ? const Color(0xFFFF9F43)
                : const Color(0xFF3B72FF),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1D2E),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildActionBtn(
            label: 'Edit',
            icon: Icons.edit_rounded,
            color: const Color(0xFF3B72FF),
            bgColor: const Color(0xFFEEF2FF),
            onTap: () => _showEditDialog(title, type, apiIndex),
          ),
          const SizedBox(width: 6),
          _buildActionBtn(
            label: 'Hapus',
            icon: Icons.delete_rounded,
            color: const Color(0xFFDC2626),
            bgColor: const Color(0xFFFEE2E2),
            onTap: () => _showDeleteDialog(title, apiIndex),
          ),
        ],
      ),
    );
  }

  // ── TOMBOL AKSI KECIL ─────────────────────────────────────────────
  Widget _buildActionBtn({
    required String label,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── ERROR VIEW ────────────────────────────────────────────────────
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 48, color: Color(0xFF9CA3AF)),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _fetchMateri,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'Coba Lagi',
                style: TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B72FF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── EMPTY VIEW ────────────────────────────────────────────────────
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_rounded,
              size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'Belum ada materi di level $_selectedLevel.',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _showAddMateriDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB703),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_circle_outline_rounded,
                      size: 16, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    'Tambah Materi Pertama',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}