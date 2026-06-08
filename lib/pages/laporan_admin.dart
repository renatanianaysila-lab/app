import 'package:flutter/material.dart';
import 'beranda_admin.dart';
import 'pengguna_admin.dart';
import 'konten_screen.dart'; 
import 'aktivitas_admin.dart';

class LaporanAdmin extends StatefulWidget {
  const LaporanAdmin({super.key});

  @override
  State<LaporanAdmin> createState() => _LaporanAdminState();
}

class _LaporanAdminState extends State<LaporanAdmin> {
  int _selectedTab = 0;       // 0 = Moderasi, 1 = Keuangan
  int _selectedFilter = 0;    // 0 = Semua, 1 = Masuk, 2 = Penarikan
  int _selectedNav = 4;       // bottom nav

  // ─── DATA DUMMY TRANSAKSI ───────────────────────────────
  final List<Map<String, dynamic>> _transaksi = [
    {
      'judul': 'Pembelian Paket Dasar',
      'sub': 'oleh Naysila • 25 Januari 2026',
      'nominal': '+Rp 75.000',
      'status': 'Berhasil',
      'tipe': 'Masuk',
    },
    {
      'judul': 'Pembelian Paket Menengah',
      'sub': 'oleh Andi Pratama • 24 Januari 2026',
      'nominal': '+Rp 125.000',
      'status': 'Berhasil',
      'tipe': 'Masuk',
    },
    {
      'judul': 'Penarikan Saldo',
      'sub': 'ke Bank BCA • 23 Januari 2026',
      'nominal': '-Rp 500.000',
      'status': 'Diproses',
      'tipe': 'Penarikan',
    },
    {
      'judul': 'Pembelian Paket Dasar',
      'sub': 'oleh Siti Nurhaliza • 22 Januari 2026',
      'nominal': '+Rp 75.000',
      'status': 'Berhasil',
      'tipe': 'Masuk',
    },
    {
      'judul': 'Pembelian Paket Lanjutan',
      'sub': 'oleh Budi Santoso • 21 Januari 2026',
      'nominal': '+Rp 175.000',
      'status': 'Berhasil',
      'tipe': 'Masuk',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedFilter == 0) return _transaksi;
    if (_selectedFilter == 1) return _transaksi.where((t) => t['tipe'] == 'Masuk').toList();
    return _transaksi.where((t) => t['tipe'] == 'Penarikan').toList();
  }

  // ─── CHART DATA (pendapatan mingguan) ──────────────────
  final List<Map<String, dynamic>> _chartData = [
    {'hari': 'Sen', 'nilai': 140000.0, 'highlight': false},
    {'hari': 'Sel', 'nilai': 180000.0, 'highlight': false},
    {'hari': 'Rab', 'nilai': 190000.0, 'highlight': false},
    {'hari': 'Kam', 'nilai': 250000.0, 'highlight': false},
    {'hari': 'Jum', 'nilai': 200000.0, 'highlight': false},
    {'hari': 'Sab', 'nilai': 300000.0, 'highlight': true},
    {'hari': 'Min', 'nilai': 220000.0, 'highlight': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabSwitch(),
            const SizedBox(height: 16),
            if (_selectedTab == 1) ...[
              _buildSaldoCard(),
              const SizedBox(height: 16),
              _buildStatRow(),
              const SizedBox(height: 20),
              _buildChartSection(),
              const SizedBox(height: 20),
              _buildRiwayatSection(),
              const SizedBox(height: 20),
              _buildUnduhButton(),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Laporan diperbarui otomatis setiap transaksi berhasil.',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ),
            ] else ...[
              _buildModerasiPlaceholder(),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── APP BAR ───────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black87),
        onPressed: () {},
      ),
      title: const Text(
        'Laporan',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
          onPressed: () {},
        ),
      ],
    );
  }

  // ─── TAB SWITCH (Moderasi / Keuangan) ──────────────────
  Widget _buildTabSwitch() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _tabBtn('Moderasi', 0),
          _tabBtn('Keuangan', 1),
        ],
      ),
    );
  }

  Widget _tabBtn(String label, int idx) {
    final active = _selectedTab == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = idx),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF3D5AFE) : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // ─── SALDO CARD ────────────────────────────────────────
  Widget _buildSaldoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3D5AFE), Color(0xFF5C6BC0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Saldo Tersedia',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 6),
          const Text(
            'Rp 2.450.000',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pendapatan siap ditarik',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF3D5AFE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Tarik Saldo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── STAT ROW (Bulan Ini, Transaksi, Verifikasi) ───────
  Widget _buildStatRow() {
    return Row(
      children: [
        _statCard(Icons.trending_up, 'Bulan Ini', 'Rp 1.2jt', const Color(0xFFE3F2FD), Colors.blue),
        const SizedBox(width: 10),
        _statCard(Icons.receipt_long, 'Transaksi', '48', const Color(0xFFE8F5E9), Colors.green),
        const SizedBox(width: 10),
        _statCard(Icons.access_time, 'Verifikasi', '350rb', const Color(0xFFFFF8E1), Colors.orange),
      ],
    );
  }

  Widget _statCard(IconData icon, String label, String value, Color bgColor, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ─── CHART SECTION ─────────────────────────────────────
  Widget _buildChartSection() {
    const double maxVal = 300000;
    const double chartHeight = 150;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pendapatan Mingguan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Y axis labels
              SizedBox(
                width: 60,
                height: chartHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Rp 300,000', style: TextStyle(fontSize: 9, color: Colors.grey[400])),
                    Text('Rp 200,000', style: TextStyle(fontSize: 9, color: Colors.grey[400])),
                    Text('Rp 100,000', style: TextStyle(fontSize: 9, color: Colors.grey[400])),
                    Text('Rp 0', style: TextStyle(fontSize: 9, color: Colors.grey[400])),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Bars
              Expanded(
                child: SizedBox(
                  height: chartHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _chartData.map((d) {
                      final barH = (d['nilai'] as double) / maxVal * chartHeight;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 22,
                            height: barH,
                            decoration: BoxDecoration(
                              color: d['highlight'] ? const Color(0xFFFFC107) : const Color(0xFF3D5AFE),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(d['hari'], style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── RIWAYAT TRANSAKSI ─────────────────────────────────
  Widget _buildRiwayatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Riwayat Transaksi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        // Filter chips
        Row(
          children: [
            _filterChip('Semua', 0),
            const SizedBox(width: 8),
            _filterChip('Masuk', 1),
            const SizedBox(width: 8),
            _filterChip('Penarikan', 2),
          ],
        ),
        const SizedBox(height: 12),
        // List
        ..._filtered.map((t) => _transaksiCard(t)),
      ],
    );
  }

  Widget _filterChip(String label, int idx) {
    final active = _selectedFilter == idx;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF3D5AFE) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? const Color(0xFF3D5AFE) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _transaksiCard(Map<String, dynamic> t) {
    final isPlus = (t['nominal'] as String).startsWith('+');
    final statusColor = t['status'] == 'Berhasil'
        ? const Color(0xFF43A047)
        : const Color(0xFFFFA726);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t['judul'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  t['sub'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                t['nominal'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isPlus ? const Color(0xFF43A047) : const Color(0xFFE53935),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  t['status'],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── UNDUH BUTTON ──────────────────────────────────────
  Widget _buildUnduhButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.download, color: Color(0xFF3D5AFE)),
        label: const Text(
          'Unduh Laporan',
          style: TextStyle(color: Color(0xFF3D5AFE), fontWeight: FontWeight.bold, fontSize: 15),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF3D5AFE), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ─── MODERASI PLACEHOLDER ──────────────────────────────
  Widget _buildModerasiPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.shield_outlined, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'Laporan Moderasi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 6),
            Text(
              'Fitur laporan moderasi akan segera hadir.',
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ─── BOTTOM NAV ────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Beranda'},
      {'icon': Icons.person_outline, 'label': 'Pengguna'},
      {'icon': Icons.article_outlined, 'label': 'Konten'},
      {'icon': Icons.show_chart, 'label': 'Aktivitas'},
      {'icon': Icons.flag_outlined, 'label': 'Laporan'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = _selectedNav == i;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedNav = i);
              if (i == 0) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BerandaAdmin()));
              } else if (i == 1) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PenggunaAdmin()));
              } else if (i == 2) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const KontenScreen()));
              }
              // i == 3 Aktivitas → tambahkan jika ada
              // i == 4 tetap di sini
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  items[i]['icon'] as IconData,
                  color: active ? const Color(0xFFFF8F00) : Colors.grey[400],
                  size: 24,
                ),
                const SizedBox(height: 2),
                Text(
                  items[i]['label'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    color: active ? const Color(0xFFFF8F00) : Colors.grey[400],
                    fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}