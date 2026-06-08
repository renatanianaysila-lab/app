import 'package:flutter/material.dart';
import 'beranda_admin.dart';
import 'pengguna_admin.dart';
import 'konten_screen.dart';
import 'laporan_admin.dart';

class AktivitasAdmin extends StatefulWidget {
  const AktivitasAdmin({super.key});

  @override
  State<AktivitasAdmin> createState() => _AktivitasAdminState();
}

class _AktivitasAdminState extends State<AktivitasAdmin> {
  int _selectedNav = 3;
  int _selectedTab = 0;
  String _search = '';

  final List<String> _tabs = ['Semua', 'Unggah', 'Tinjau', 'Lapor', 'Lainnya'];

  final List<Map<String, dynamic>> _aktivitas = [
    {
      'tipe': 'Unggah',
      'waktu': '5 menit lalu',
      'pesan': 'Naysila mengunggah materi "Huruf A - BISINDO"',
      'icon': Icons.upload_outlined,
      'bgColor': const Color(0xFFE8F5E9),
      'iconColor': const Color(0xFF43A047),
      'badgeColor': const Color(0xFFE8F5E9),
      'badgeText': const Color(0xFF43A047),
    },
    {
      'tipe': 'Kumpul',
      'waktu': '10 menit lalu',
      'pesan': '12 latihan dikumpulkan dan menunggu peninjauan',
      'icon': Icons.list_alt_outlined,
      'bgColor': const Color(0xFFE3F2FD),
      'iconColor': const Color(0xFF1E88E5),
      'badgeColor': const Color(0xFFE3F2FD),
      'badgeText': const Color(0xFF1E88E5),
    },
    {
      'tipe': 'Lapor',
      'waktu': '20 menit lalu',
      'pesan': '2 konten dilaporkan oleh pengguna',
      'icon': Icons.flag_outlined,
      'bgColor': const Color(0xFFFFEBEE),
      'iconColor': const Color(0xFFE53935),
      'badgeColor': const Color(0xFFFFEBEE),
      'badgeText': const Color(0xFFE53935),
    },
    {
      'tipe': 'Tinjau',
      'waktu': '30 menit lalu',
      'pesan': '8 konten sedang dalam proses peninjauan',
      'icon': Icons.remove_red_eye_outlined,
      'bgColor': const Color(0xFFFFF8E1),
      'iconColor': const Color(0xFFFFA000),
      'badgeColor': const Color(0xFFFFF8E1),
      'badgeText': const Color(0xFFFFA000),
    },
    {
      'tipe': 'Lainnya',
      'waktu': '1 jam lalu',
      'pesan': '5 materi telah disetujui oleh admin',
      'icon': Icons.check_outlined,
      'bgColor': const Color(0xFFE8F5E9),
      'iconColor': const Color(0xFF43A047),
      'badgeColor': const Color(0xFFE8F5E9),
      'badgeText': const Color(0xFF43A047),
      'badgeLabel': 'Setuju',
    },
    {
      'tipe': 'Lainnya',
      'waktu': '2 jam lalu',
      'pesan': '2 konten ditolak karena tidak sesuai standar',
      'icon': Icons.close_outlined,
      'bgColor': const Color(0xFFFFEBEE),
      'iconColor': const Color(0xFFE53935),
      'badgeColor': const Color(0xFFFFEBEE),
      'badgeText': const Color(0xFFE53935),
      'badgeLabel': 'Tolak',
    },
    {
      'tipe': 'Unggah',
      'waktu': '3 jam lalu',
      'pesan': 'Andi mengunggah video "Kata Sapaan - BISINDO"',
      'icon': Icons.upload_outlined,
      'bgColor': const Color(0xFFE8F5E9),
      'iconColor': const Color(0xFF43A047),
      'badgeColor': const Color(0xFFE8F5E9),
      'badgeText': const Color(0xFF43A047),
    },
    {
      'tipe': 'Lainnya',
      'waktu': '4 jam lalu',
      'pesan': '15 pengguna baru mendaftar hari ini',
      'icon': Icons.person_add_outlined,
      'bgColor': const Color(0xFFE3F2FD),
      'iconColor': const Color(0xFF1E88E5),
      'badgeColor': const Color(0xFFE3F2FD),
      'badgeText': const Color(0xFF1E88E5),
      'badgeLabel': 'Daftar',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    final tab = _tabs[_selectedTab];
    return _aktivitas.where((a) {
      final matchTab = tab == 'Semua' || a['tipe'] == tab;
      final matchSearch = _search.isEmpty ||
          (a['pesan'] as String).toLowerCase().contains(_search.toLowerCase());
      return matchTab && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        title: const Text(
          'Aktivitas',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ── TAB FILTER ──────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  final active = _selectedTab == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFF3D5AFE).withOpacity(0.08) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: active ? const Color(0xFF3D5AFE) : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        _tabs[i],
                        style: TextStyle(
                          color: active ? const Color(0xFF3D5AFE) : Colors.grey[600],
                          fontWeight: active ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ── SEARCH BAR ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Cari judul materi',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF3D5AFE)),
                ),
              ),
            ),
          ),

          // ── LIST AKTIVITAS ──────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox_outlined, size: 50, color: Colors.grey[300]),
                        const SizedBox(height: 8),
                        Text('Tidak ada aktivitas', style: TextStyle(color: Colors.grey[400])),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) => _aktivitasItem(_filtered[i]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _aktivitasItem(Map<String, dynamic> a) {
    final badgeLabel = a['badgeLabel'] ?? a['tipe'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: a['bgColor'] as Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(a['icon'] as IconData, color: a['iconColor'] as Color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: a['badgeColor'] as Color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badgeLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: a['badgeText'] as Color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      a['waktu'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  a['pesan'],
                  style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                ),
              ],
            ),
          ),
        ],
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
              if (i == 0) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BerandaAdmin()));
              } else if (i == 1) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PenggunaAdmin()));
              } else if (i == 2) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const KontenScreen()));
              } else if (i == 4) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LaporanAdmin()));
              }
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