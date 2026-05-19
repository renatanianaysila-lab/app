import 'package:flutter/material.dart';

class RiwayatPage extends StatefulWidget {
  final int initialTab;
  const RiwayatPage({super.key, this.initialTab = 0});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  // ── DATA ──────────────────────────────────────────────────────────────────

  final List<Map<String, dynamic>> _videoData = [
    {
      'judul': 'Dasar Bahasa Isyarat - Alfabet A-Z',
      'tanggal': '25 Januari 2024',
      'status': 'Selesai',
      'thumbnail': null,
    },
    {
      'judul': 'Angka dalam Bahasa Isyarat 1-100',
      'tanggal': '23 Januari 2024',
      'status': 'Sedang Ditonton',
      'thumbnail': 'assets/images/img.png',
    },
    {
      'judul': 'Ekspresi Sehari-hari',
      'tanggal': '20 Januari 2024',
      'status': 'Selesai',
      'thumbnail': 'assets/images/percakapan.png',
    },
  ];

  final List<Map<String, dynamic>> _kuisData = [
    {
      'judul': 'Dasar Bahasa Isyarat - Alfabet A-Z',
      'tanggal': '25 Januari 2024',
      'status': 'Lulus',
      'skor': '100/100',
    },
    {
      'judul': 'Angka dalam Bahasa Isyarat 1-100',
      'tanggal': '25 Januari 2024',
      'status': 'Lulus',
      'skor': '100/100',
    },
    {
      'judul': 'Ekspresi Sehari-hari',
      'tanggal': '25 Januari 2024',
      'status': 'Tidak Lulus',
      'skor': '65/100',
    },
  ];

  final List<Map<String, dynamic>> _pembelianData = [
    {
      'paket': 'Paket Premium',
      'harga': 'Rp 30.000',
      'tanggal': '1 Desember 2025',
      'metode': 'Transfer Bank',
      'statusBayar': 'Berhasil',
      'statusAktif': 'Non-Aktif',
      'berlakuHingga': '1 Januari 2026',
    },
    {
      'paket': 'Paket Premium',
      'harga': 'Rp 30.000',
      'tanggal': '5 Januari 2026',
      'metode': 'Transfer Bank',
      'statusBayar': 'Berhasil',
      'statusAktif': 'Non-Aktif',
      'berlakuHingga': '5 Februari 2026',
    },
    {
      'paket': 'Paket Premium',
      'harga': 'Rp 30.000',
      'tanggal': '19 Maret 2026',
      'metode': 'Transfer Bank',
      'statusBayar': 'Berhasil',
      'statusAktif': 'Aktif',
      'berlakuHingga': '19 April 2026',
    },
  ];

  // ── BUILD ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final titles = ['Riwayat Belajar', 'Riwayat Kuis', 'Riwayat Pembelian'];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.black87),
                    ),
                  ),
                  Text(
                    titles[_selectedTab],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // ── Tab Selector ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _buildTab(0, 'Video', 'assets/images/videoplay.png', Icons.play_arrow),
                    _buildTab(1, 'Kuis', 'assets/images/kuisriwayat.png', Icons.quiz),
                    _buildTab(2, 'Pembelian', 'assets/images/pembelianriwayat.png', Icons.shopping_cart),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Content ──
            Expanded(
              child: _selectedTab == 0
                  ? _buildVideoList()
                  : _selectedTab == 1
                      ? _buildKuisList()
                      : _buildPembelianList(),
            ),
          ],
        ),
      ),

      // ── Bottom Navbar ──
      bottomNavigationBar: _buildBottomNavbar(context),
    );
  }

  // ── TAB WIDGET ─────────────────────────────────────────────────────────────

  Widget _buildTab(int index, String label, String assetPath, IconData fallback) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                assetPath,
                width: 18,
                height: 18,
                color: isActive ? const Color(0xFF2563EB) : Colors.grey,
                errorBuilder: (_, __, ___) => Icon(
                  fallback,
                  size: 18,
                  color: isActive ? const Color(0xFF2563EB) : Colors.grey,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? const Color(0xFF2563EB) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── VIDEO LIST ─────────────────────────────────────────────────────────────

  Widget _buildVideoList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _videoData.length,
      itemBuilder: (context, i) {
        final item = _videoData[i];
        final isSelesai = item['status'] == 'Selesai';
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: item['thumbnail'] != null
                    ? Image.asset(
                        item['thumbnail'],
                        width: 80,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _thumbPlaceholder(),
                      )
                    : _thumbPlaceholder(),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['judul'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['tanggal'],
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    _statusBadge(
                      isSelesai ? 'Selesai' : 'Sedang Ditonton',
                      isSelesai ? const Color(0xFF16A34A) : const Color(0xFF2563EB),
                      isSelesai ? const Color(0xFFDCFCE7) : const Color(0xFFDBEAFE),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _thumbPlaceholder() {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.play_circle_outline, color: Colors.white54, size: 28),
    );
  }

  // ── KUIS LIST ──────────────────────────────────────────────────────────────

  Widget _buildKuisList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _kuisData.length,
      itemBuilder: (context, i) {
        final item = _kuisData[i];
        final isLulus = item['status'] == 'Lulus';
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Kuis
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  'assets/images/kuisriwayat.png',
                  width: 30,
                  height: 30,
                  color: Colors.white,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.quiz, color: Colors.white, size: 28),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['judul'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['tanggal'],
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _statusBadge(
                          item['status'],
                          isLulus ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                          isLulus ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                        ),
                        const Spacer(),
                        Text(
                          item['skor'],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── PEMBELIAN LIST ─────────────────────────────────────────────────────────

  Widget _buildPembelianList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _pembelianData.length,
      itemBuilder: (context, i) {
        final item = _pembelianData[i];
        final isAktif = item['statusAktif'] == 'Aktif';
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: paket + harga
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['paket'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    item['harga'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Row 2: tanggal
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    item['tanggal'],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Row 3: status Berhasil + Aktif/Non-Aktif
              Row(
                children: [
                  _statusBadge(
                    item['statusBayar'],
                    const Color(0xFF16A34A),
                    const Color(0xFFDCFCE7),
                  ),
                  const SizedBox(width: 8),
                  _statusBadge(
                    item['statusAktif'],
                    isAktif ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                    isAktif ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              const SizedBox(height: 8),
              // Row 4: metode + berlaku hingga
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.credit_card_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        item['metode'],
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Text(
                    'Berakhir: ${item['berlakuHingga']}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ── HELPER ────────────────────────────────────────────────────────────────

  Widget _statusBadge(String label, Color textColor, Color bgColor) {
    final isCheck = label == 'Selesai' || label == 'Lulus' || label == 'Berhasil' || label == 'Aktif';
    final isX = label == 'Tidak Lulus';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCheck)
            Icon(Icons.check_circle, size: 13, color: textColor)
          else if (isX)
            Icon(Icons.cancel, size: 13, color: textColor)
          else if (label == 'Sedang Ditonton')
            Icon(Icons.play_circle_filled, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── BOTTOM NAVBAR ─────────────────────────────────────────────────────────

  Widget _buildBottomNavbar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, 'assets/images/home.png', 'Beranda', Icons.home_outlined, false),
              _navItem(context, 'assets/images/materinavbar.png', 'Materi', Icons.menu_book_outlined, false),
              _navItem(context, 'assets/images/forum.png', 'Forum', Icons.forum_outlined, false),
              _navItem(context, 'assets/images/navbarriwayat.png', 'Riwayat', Icons.history, true),
              _navItem(context, 'assets/images/user.png', 'Profil', Icons.person_outline, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, String asset, String label, IconData fallback, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (!isActive) Navigator.pop(context);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            asset,
            width: 22,
            height: 22,
            color: isActive ? const Color(0xFF2563EB) : Colors.grey,
            errorBuilder: (_, __, ___) => Icon(
              fallback,
              size: 22,
              color: isActive ? const Color(0xFF2563EB) : Colors.grey,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? const Color(0xFF2563EB) : Colors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}