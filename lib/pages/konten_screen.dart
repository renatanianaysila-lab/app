import 'package:flutter/material.dart';
import 'laporan_admin.dart';
import 'aktivitas_admin.dart';


enum KontenStatus { pending, disetujui, ditolak }

class KontenItem {
  final String judul;
  final String penulis;
  final String level;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final KontenStatus status;

  KontenItem({
    required this.judul,
    required this.penulis,
    required this.level,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.status,
  });
}

class KontenScreen extends StatefulWidget {
  const KontenScreen({super.key});

  @override
  State<KontenScreen> createState() => _KontenScreenState();
}

class _KontenScreenState extends State<KontenScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  final List<KontenItem> _allKonten = [
    KontenItem(
      judul: 'Abjad A-Z: Huruf A',
      penulis: 'Siti Nurhaliza',
      level: 'Dasar',
      icon: Icons.abc,
      iconColor: Colors.white,
      iconBg: const Color(0xFF6C63FF),
      status: KontenStatus.pending,
    ),
    KontenItem(
      judul: 'Abjad A-Z: Huruf A',
      penulis: 'Rahma',
      level: 'Dasar',
      icon: Icons.tag,
      iconColor: Colors.white,
      iconBg: const Color(0xFF4CAF50),
      status: KontenStatus.pending,
    ),
    KontenItem(
      judul: 'Ekspresi:',
      penulis: 'Dika',
      level: 'Dasar',
      icon: Icons.emoji_emotions_outlined,
      iconColor: Colors.white,
      iconBg: const Color(0xFF9C27B0),
      status: KontenStatus.pending,
    ),
    KontenItem(
      judul: 'Percakapan Dasar: Salam Dasar',
      penulis: 'Laura',
      level: 'Dasar',
      icon: Icons.chat_bubble_outline,
      iconColor: Colors.white,
      iconBg: const Color(0xFFFF6B35),
      status: KontenStatus.pending,
    ),
    KontenItem(
      judul: 'Abjad A-Z: Huruf A',
      penulis: 'Siti Nurhaliza',
      level: 'Dasar',
      icon: Icons.abc,
      iconColor: Colors.white,
      iconBg: const Color(0xFF6C63FF),
      status: KontenStatus.disetujui,
    ),
    KontenItem(
      judul: 'Abjad A-Z: Huruf A',
      penulis: 'Rahma',
      level: 'Dasar',
      icon: Icons.tag,
      iconColor: Colors.white,
      iconBg: const Color(0xFF4CAF50),
      status: KontenStatus.disetujui,
    ),
    KontenItem(
      judul: 'Ekspresi:',
      penulis: 'Dika',
      level: 'Dasar',
      icon: Icons.emoji_emotions_outlined,
      iconColor: Colors.white,
      iconBg: const Color(0xFF9C27B0),
      status: KontenStatus.disetujui,
    ),
    KontenItem(
      judul: 'Percakapan Dasar: Salam Dasar',
      penulis: 'Laura',
      level: 'Dasar',
      icon: Icons.chat_bubble_outline,
      iconColor: Colors.white,
      iconBg: const Color(0xFFFF6B35),
      status: KontenStatus.disetujui,
    ),
    KontenItem(
      judul: 'Abjad A-Z: Huruf A',
      penulis: 'Siti Nurhaliza',
      level: 'Dasar',
      icon: Icons.abc,
      iconColor: Colors.white,
      iconBg: const Color(0xFF6C63FF),
      status: KontenStatus.ditolak,
    ),
    KontenItem(
      judul: 'Abjad A-Z: Huruf A',
      penulis: 'Rahma',
      level: 'Dasar',
      icon: Icons.tag,
      iconColor: Colors.white,
      iconBg: const Color(0xFF4CAF50),
      status: KontenStatus.ditolak,
    ),
    KontenItem(
      judul: 'Ekspresi:',
      penulis: 'Dika',
      level: 'Dasar',
      icon: Icons.emoji_emotions_outlined,
      iconColor: Colors.white,
      iconBg: const Color(0xFF9C27B0),
      status: KontenStatus.ditolak,
    ),
    KontenItem(
      judul: 'Percakapan Dasar: Salam Dasar',
      penulis: 'Laura',
      level: 'Dasar',
      icon: Icons.chat_bubble_outline,
      iconColor: Colors.white,
      iconBg: const Color(0xFFFF6B35),
      status: KontenStatus.ditolak,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<KontenItem> _filtered(KontenStatus status) {
    return _allKonten.where((k) {
      final matchStatus = k.status == status;
      final matchSearch = _searchQuery.isEmpty ||
          k.judul.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          k.penulis.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchStatus && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black87),
        title: const Text(
          'Konten',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.black87),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              tabs: [
                _buildTab('Pending', 0, const Color(0xFFFF9800)),
                _buildTab('Disetujui', 1, const Color(0xFF4CAF50)),
                _buildTab('Ditolak', 2, const Color(0xFF6C63FF)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Cari judul materi',
                        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                        prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _filterChip('Guru'),
                const SizedBox(width: 6),
                _filterChip('Filter', icon: Icons.tune),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(KontenStatus.pending),
                _buildList(KontenStatus.disetujui),
                _buildList(KontenStatus.ditolak),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Pengguna'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Konten'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Aktivitas'),
          BottomNavigationBarItem(icon: Icon(Icons.flag_outlined), label: 'Laporan'),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, Color activeColor) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        final isSelected = _tabController.index == index;
        return Tab(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? activeColor.withOpacity(0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? activeColor : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _filterChip(String label, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, size: 14, color: Colors.grey),
          ],
        ],
      ),
    );
  }

  Widget _buildList(KontenStatus status) {
    final items = _filtered(status);
    if (items.isEmpty) {
      return const Center(child: Text('Tidak ada konten', style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (ctx, i) => _KontenCard(item: items[i]),
    );
  }
}

class _KontenCard extends StatelessWidget {
  final KontenItem item;
  const _KontenCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: item.iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(item.icon, color: item.iconColor, size: 22),
        ),
        title: Text(
          item.judul,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          'oleh: ${item.penulis}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            item.level,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}