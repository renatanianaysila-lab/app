// ignore_for_file: unused_import

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RiwayatPage extends StatefulWidget {
  final int initialTab;

  const RiwayatPage({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  late int _selectedTab;
  bool _isLoadingPembelian = true;
  List<Map<String, dynamic>> _pembelianData = [];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _loadPembelian();
  }

      Future<void> _loadPembelian() async {
      try {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8000/api/transactions'),
          headers: {'Accept': 'application/json'},
        );

        if (!mounted) return;

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success'] == true && data['data'] != null) {
            final List<dynamic> raw = data['data'];
            setState(() {
              _pembelianData = raw.map((item) {
                final method = item['payment_method'] == 'qris' ? 'QRIS' : 'Kartu';
                return {
                  'paket': 'Paket Premium ($method)',
                  'harga': 'Rp ${item['amount']}',
                  'tanggal': item['created_at'] ?? '-',
                  'status': item['status'] == 'success' ? 'Aktif' : 'Non-Aktif',
                };
              }).toList();
              _isLoadingPembelian = false;
            });
            return;
          }
        }
        setState(() => _isLoadingPembelian = false);
      } catch (e) {
        debugPrint('Error ambil riwayat pembelian: $e');
        if (mounted) setState(() => _isLoadingPembelian = false);
      }
    }

  @override
  Widget build(BuildContext context) {
    final titles = [
      'Riwayat Belajar',
      'Riwayat Kuis',
      'Riwayat Pembelian',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Center(
                child: Text(
                  titles[_selectedTab],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
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
                    _buildTab(0, 'Video', Icons.play_arrow),
                    _buildTab(1, 'Kuis', Icons.quiz),
                    _buildTab(2, 'Pembelian', Icons.shopping_cart),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
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
    );
  }

  Widget _buildTab(int index, String label, IconData icon) {
    final isActive = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
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
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? const Color(0xFF2563EB) : Colors.grey,
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

  Widget _buildVideoList() {
    final videoData = [
      {
        'judul': 'Dasar Bahasa Isyarat - Alfabet A-Z',
        'tanggal': '25 Januari 2024',
        'status': 'Selesai',
      },
      {
        'judul': 'Angka dalam Bahasa Isyarat 1-100',
        'tanggal': '23 Januari 2024',
        'status': 'Sedang Ditonton',
      },
      {
        'judul': 'Ekspresi Sehari-hari',
        'tanggal': '20 Januari 2024',
        'status': 'Selesai',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: videoData.length,
      itemBuilder: (context, index) {
        final item = videoData[index];
        final isSelesai = item['status'] == 'Selesai';

        return _buildHistoryCard(
          icon: Icons.play_circle_outline,
          title: item['judul']!,
          date: item['tanggal']!,
          status: item['status']!,
          statusColor:
              isSelesai ? const Color(0xFF16A34A) : const Color(0xFF2563EB),
          statusBg:
              isSelesai ? const Color(0xFFDCFCE7) : const Color(0xFFDBEAFE),
        );
      },
    );
  }

  Widget _buildKuisList() {
    final kuisData = [
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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: kuisData.length,
      itemBuilder: (context, index) {
        final item = kuisData[index];
        final isLulus = item['status'] == 'Lulus';

        return _buildHistoryCard(
          icon: Icons.quiz,
          title: item['judul']!,
          date: '${item['tanggal']} • Skor ${item['skor']}',
          status: item['status']!,
          statusColor:
              isLulus ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
          statusBg:
              isLulus ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
        );
      },
    );
  }

  Widget _buildPembelianList() {
  if (_isLoadingPembelian) {
    return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
  }

  if (_pembelianData.isEmpty) {
    return const Center(
      child: Text(
        'Belum ada riwayat pembelian.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    itemCount: _pembelianData.length,
    itemBuilder: (context, index) {
      final item = _pembelianData[index];
      final isAktif = item['status'] == 'Aktif';

      return _buildHistoryCard(
        icon: Icons.shopping_cart_outlined,
        title: '${item['paket']} - ${item['harga']}',
        date: item['tanggal']!,
        status: item['status']!,
        statusColor: isAktif ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
        statusBg: isAktif ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
      );
    },
  );
}


  Widget _buildHistoryCard({
    required IconData icon,
    required String title,
    required String date,
    required String status,
    required Color statusColor,
    required Color statusBg,
  }) {
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
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2563EB),
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                _statusBadge(status, statusColor, statusBg),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String label, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
