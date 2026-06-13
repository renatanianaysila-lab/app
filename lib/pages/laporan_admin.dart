import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  int _selectedTab = 0;
  int _selectedFilter = 0;
  int _selectedNav = 4;

  bool _isLoading = true;
  String? _errorMsg;

  List<Map<String, dynamic>> _transaksi = [];
  Map<String, dynamic> _summary = {};

  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  @override
  void initState() {
    super.initState();
    _fetchLaporan();
  }

  Future<void> _fetchLaporan() async {
    setState(() { _isLoading = true; _errorMsg = null; });
    try {
      final res = await http.get(Uri.parse('$_baseUrl/admin/laporan'));
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        setState(() {
          _transaksi = List<Map<String, dynamic>>.from(json['transaksi'] ?? []);
          _summary = Map<String, dynamic>.from(json['summary'] ?? {});
          _isLoading = false;
        });
      } else {
        setState(() { _errorMsg = 'Gagal memuat laporan (${res.statusCode})'; _isLoading = false; });
      }
    } catch (e) {
      setState(() { _errorMsg = 'Tidak dapat terhubung ke server'; _isLoading = false; });
    }
  }

  List<Map<String, dynamic>> get _filtered {
    if (_selectedFilter == 0) return _transaksi;
    final tipe = _selectedFilter == 1 ? 'Masuk' : 'Penarikan';
    return _transaksi.where((t) => t['tipe'] == tipe).toList();
  }

  // Chart data dari summary weekly (fallback ke kosong jika tidak ada)
  List<Map<String, dynamic>> get _chartData {
    final List<dynamic> weekly = _summary['mingguan'] ?? [];
    if (weekly.isNotEmpty) {
      return weekly.map<Map<String, dynamic>>((d) => {
        'hari': d['hari'] ?? '',
        'nilai': (d['nilai'] ?? 0).toDouble(),
        'highlight': d['highlight'] ?? false,
      }).toList();
    }
    // fallback kosong
    return ['Sen','Sel','Rab','Kam','Jum','Sab','Min']
        .map((h) => {'hari': h, 'nilai': 0.0, 'highlight': false})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF3D5AFE)))
          : _errorMsg != null
              ? _buildError()
              : RefreshIndicator(
                  onRefresh: _fetchLaporan,
                  color: const Color(0xFF3D5AFE),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off, size: 50, color: Colors.grey[300]),
          const SizedBox(height: 8),
          Text(_errorMsg!, style: TextStyle(color: Colors.grey[500])),
          const SizedBox(height: 12),
          TextButton(onPressed: _fetchLaporan, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }

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
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTabSwitch() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(children: [_tabBtn('Moderasi', 0), _tabBtn('Keuangan', 1)]),
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

  Widget _buildSaldoCard() {
    final saldo = _summary['saldo'] ?? 'Rp 0';
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
          const Text('Saldo Tersedia', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            saldo,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text('Pendapatan siap ditarik', style: TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF3D5AFE),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Tarik Saldo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow() {
    final bulanIni = _summary['bulan_ini'] ?? 'Rp 0';
    final jumlahTransaksi = _summary['jumlah_transaksi']?.toString() ?? '0';
    final menunggu = _summary['menunggu'] ?? 'Rp 0';
    return Row(
      children: [
        _statCard(Icons.trending_up, 'Bulan Ini', bulanIni, const Color(0xFFE3F2FD), Colors.blue),
        const SizedBox(width: 10),
        _statCard(Icons.receipt_long, 'Transaksi', jumlahTransaksi, const Color(0xFFE8F5E9), Colors.green),
        const SizedBox(width: 10),
        _statCard(Icons.access_time, 'Verifikasi', menunggu, const Color(0xFFFFF8E1), Colors.orange),
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
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

  Widget _buildChartSection() {
    final data = _chartData;
    final maxVal = data.map((d) => d['nilai'] as double).fold(0.0, (a, b) => a > b ? a : b);
    final maxDisplay = maxVal > 0 ? maxVal : 300000.0;
    const double chartHeight = 150;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pendapatan Mingguan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 60,
                height: chartHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_formatRupiah(maxDisplay), style: TextStyle(fontSize: 9, color: Colors.grey[400])),
                    Text(_formatRupiah(maxDisplay * 0.66), style: TextStyle(fontSize: 9, color: Colors.grey[400])),
                    Text(_formatRupiah(maxDisplay * 0.33), style: TextStyle(fontSize: 9, color: Colors.grey[400])),
                    Text('Rp 0', style: TextStyle(fontSize: 9, color: Colors.grey[400])),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: chartHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: data.map((d) {
                      final barH = maxDisplay > 0
                          ? ((d['nilai'] as double) / maxDisplay * chartHeight).clamp(4.0, chartHeight)
                          : 4.0;
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

  String _formatRupiah(double value) {
    if (value >= 1000000) return 'Rp ${(value / 1000000).toStringAsFixed(1)}jt';
    if (value >= 1000) return 'Rp ${(value / 1000).toStringAsFixed(0)}rb';
    return 'Rp ${value.toStringAsFixed(0)}';
  }

  Widget _buildRiwayatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Riwayat Transaksi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
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
        if (_filtered.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Tidak ada transaksi', style: TextStyle(color: Colors.grey[400])),
            ),
          )
        else
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
          border: Border.all(color: active ? const Color(0xFF3D5AFE) : Colors.grey.shade300),
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
    final nominal = t['nominal'] ?? '';
    final isPlus = nominal.toString().startsWith('+');
    final statusColor = t['status'] == 'Berhasil'
        ? const Color(0xFF43A047)
        : const Color(0xFFFFA726);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t['judul'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(t['sub'] ?? '', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                nominal,
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
                  t['status'] ?? '',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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

  Widget _buildModerasiPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.shield_outlined, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text('Laporan Moderasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 6),
            Text('Fitur laporan moderasi akan segera hadir.', style: TextStyle(color: Colors.grey[400], fontSize: 13), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

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
              if (i == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BerandaAdmin()));
              else if (i == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PenggunaAdmin()));
              else if (i == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const KontenScreen()));
              else if (i == 3) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AktivitasAdmin()));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(items[i]['icon'] as IconData,
                    color: active ? const Color(0xFFFF8F00) : Colors.grey[400], size: 24),
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