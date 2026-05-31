import 'package:flutter/material.dart';

class BerandaAdmin extends StatefulWidget {
  const BerandaAdmin({super.key});

  @override
  State<BerandaAdmin> createState() => _BerandaAdminState();
}

class _BerandaAdminState extends State<BerandaAdmin> {
  int _selectedNav = 0;

  final List<Map<String, dynamic>> _aktivitas = [
    {
      'iconPath': 'assets/images/materihuruf.png',
      'iconBg': Color(0xFFFFF8EC),
      'title': 'Materi "Huruf A - BISINDO"',
      'subtitle': 'siti@email.com',
      'time': '5m',
      'timeBg': Color(0xFFFFF8EC),
      'timeColor': Color(0xFFF5A623),
    },
    {
      'iconPath': 'assets/images/12latihan.png',
      'iconBg': Color(0xFFEEF2FF),
      'title': '12 Latihan "Huruf A - BISINDO"',
      'subtitle': 'ahmad@email.com',
      'time': '10m',
      'timeBg': Color(0xFFEEF2FF),
      'timeColor': Color(0xFF3B72FF),
    },
    {
      'iconPath': 'assets/images/8konten.png',
      'iconBg': Color(0xFFFFEEEE),
      'title': '8 Konten sedang Direview',
      'subtitle': 'budi@email.com',
      'time': '15m',
      'timeBg': Color(0xFFFFEEEE),
      'timeColor': Color(0xFFE53E3E),
    },
    {
      'iconPath': 'assets/images/5materi.png',
      'iconBg': Color(0xFFE8F9F0),
      'title': '5 Materi Disetujui',
      'subtitle': 'budi@email.com',
      'time': '30m',
      'timeBg': Color(0xFFE8F9F0),
      'timeColor': Color(0xFF4CAF7D),
    },
    {
      'iconPath': 'assets/images/ditolak.png',
      'iconBg': Color(0xFFFFEEEE),
      'title': '2 Konten Ditolak',
      'subtitle': 'budi@email.com',
      'time': '45m',
      'timeBg': Color(0xFFFFEEEE),
      'timeColor': Color(0xFFE53E3E),
    },
    {
      'iconPath': 'assets/images/tindakan.png',
      'iconBg': Color(0xFFFFEEEE),
      'title': '3 Laporan Perlu tindakan',
      'subtitle': 'budi@email.com',
      'time': '1hr',
      'timeBg': Color(0xFFFFEEEE),
      'timeColor': Color(0xFFE53E3E),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActionButtons(context),
                    const SizedBox(height: 20),
                    const Text('Statistik Utama',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
                    const SizedBox(height: 12),
                    _buildStatistikGrid(),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text('Ringkasan Aktivitas',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: const Text('Lihat Semua',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600,
                                  color: Color(0xFFF5A623), fontFamily: 'Poppins')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._aktivitas.map((item) => _buildAktivitasItem(item)),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── TOP BAR ───────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.menu, size: 24, color: Color(0xFF1A1D2E)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Beranda',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
          ),
          Image.asset('assets/images/loncengadmin.png',
              width: 26, height: 26,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.notifications_none, color: Color(0xFF1A1D2E), size: 26)),
        ],
      ),
    );
  }

  // ─── ACTION BUTTONS ────────────────────────────────────
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        _buildActionBtn(
          iconPath: 'assets/images/tambahadmin.png',
          label: 'Tambah',
          onTap: () => _showTambahDialog(context),
        ),
        const SizedBox(width: 10),
        _buildActionBtn(
          iconPath: 'assets/images/tinjauadmin.png',
          label: 'Tinjau',
          onTap: () => _showTinjauDialog(context),
        ),
        const SizedBox(width: 10),
        _buildActionBtn(
          iconPath: 'assets/images/laporadmin.png',
          label: 'Lapor',
          onTap: () => _showLaporDialog(context),
        ),
      ],
    );
  }

  Widget _buildActionBtn({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04),
                  blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, width: 16, height: 16,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.add, size: 16, color: Color(0xFF1A1D2E))),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
            ],
          ),
        ),
      ),
    );
  }

  // ─── STATISTIK GRID ────────────────────────────────────
  Widget _buildStatistikGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          iconPath: 'assets/images/totalpengguna.png',
          iconBg: const Color(0xFFF5A623),
          value: '1,234',
          label: 'Total Pengguna',
          change: '+12%',
          changePositive: true,
        ),
        _buildStatCard(
          iconPath: 'assets/images/kontenaktif.png',
          iconBg: const Color(0xFF4CAF7D),
          value: '456',
          label: 'Konten Aktif',
          change: '+8%',
          changePositive: true,
        ),
        _buildStatCard(
          iconPath: 'assets/images/materibelajar.png',
          iconBg: const Color(0xFFF5A623),
          value: '89',
          label: 'Materi Belajar',
          change: '+15%',
          changePositive: true,
        ),
        _buildStatCard(
          iconPath: 'assets/images/pembelajaran.png',
          iconBg: const Color(0xFF4CAF7D),
          value: '3.2K',
          label: 'Pembelanjaan',
          change: '+24%',
          changePositive: true,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String iconPath,
    required Color iconBg,
    required String value,
    required String label,
    required String change,
    required bool changePositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04),
              blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                    color: iconBg, borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8),
                child: Image.asset(iconPath, fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.bar_chart, color: Colors.white, size: 18)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: changePositive
                      ? const Color(0xFFE8F9F0)
                      : const Color(0xFFFFEEEE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(change,
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700,
                        color: changePositive
                            ? const Color(0xFF4CAF7D)
                            : const Color(0xFFE53E3E),
                        fontFamily: 'Poppins')),
              ),
            ],
          ),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280), fontFamily: 'Poppins')),
        ],
      ),
    );
  }

  // ─── AKTIVITAS ITEM ────────────────────────────────────
  Widget _buildAktivitasItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04),
              blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: item['iconBg'] as Color,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(item['iconPath'] as String,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.info, color: Color(0xFF9CA3AF), size: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'] as String,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
                const SizedBox(height: 2),
                Text(item['subtitle'] as String,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w500,
                        color: Color(0xFF9CA3AF), fontFamily: 'Poppins')),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: item['timeBg'] as Color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(item['time'] as String,
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700,
                    color: item['timeColor'] as Color,
                    fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }

  // ─── POPUP TAMBAH ──────────────────────────────────────
  void _showTambahDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Tambah',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Pilih yang ingin ditambahkan:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280), fontFamily: 'Poppins')),
              const SizedBox(height: 16),
              _buildDialogOption(
                iconPath: 'assets/images/materi.png',
                label: 'Materi',
                sublabel: 'Tambah modul atau video',
                color: const Color(0xFF3B72FF),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              _buildDialogOption(
                iconPath: 'assets/images/kategori.png',
                label: 'Kategori',
                sublabel: 'Tambah kategori baru',
                color: const Color(0xFF4CAF7D),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              _buildDialogOption(
                iconPath: 'assets/images/guru(2).png',
                label: 'Guru',
                sublabel: 'Tambahkan guru',
                color: const Color(0xFFF5A623),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogOption({
    required String iconPath,
    required String label,
    required String sublabel,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Image.asset(iconPath, width: 24, height: 24,
                color: Colors.white,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.add, color: Colors.white, size: 24)),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                        color: Colors.white, fontFamily: 'Poppins')),
                Text(sublabel,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                        color: Colors.white70, fontFamily: 'Poppins')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── POPUP TINJAU ──────────────────────────────────────
  void _showTinjauDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Tinjau',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTinjauItem('Huruf A - BISINDO', 'siti@email.com'),
              _buildTinjauItem('Angka 1-10', 'budi@email.com'),
              _buildTinjauItem('Salam Dasar', 'ahmad@email.com'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text('Lihat Semua',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                          color: Color(0xFF3B72FF), fontFamily: 'Poppins')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTinjauItem(String title, String email) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
                Text(email,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                        color: Color(0xFF9CA3AF), fontFamily: 'Poppins')),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
        ],
      ),
    );
  }

  // ─── POPUP LAPOR ───────────────────────────────────────
  void _showLaporDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Lapor',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildLaporItem('Alfabet A-Z', 'Konten tidak sesuai oleh pengguna'),
              _buildLaporItem('Salam Dasar', 'Video tidak jelas dilaporkan murid'),
              _buildLaporItem('Angka 1-10', 'Materi duplikat'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text('Lihat Semua',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                          color: Color(0xFF3B72FF), fontFamily: 'Poppins')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLaporItem(String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFCCCC)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1D2E), fontFamily: 'Poppins')),
                Text(desc,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                        color: Color(0xFF9CA3AF), fontFamily: 'Poppins')),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
        ],
      ),
    );
  }

  // ─── BOTTOM NAV ────────────────────────────────────────
  Widget _buildBottomNav() {
    final List<Map<String, dynamic>> items = [
      {'iconPath': 'assets/images/berandaadmin.png', 'activeIcon': 'assets/images/Beranda.png', 'label': 'Beranda'},
      {'iconPath': 'assets/images/penggunaadmin.png', 'activeIcon': 'assets/images/Pengguna.png', 'label': 'Pengguna'},
      {'iconPath': 'assets/images/kontenadmin.png', 'activeIcon': 'assets/images/Konten.png', 'label': 'Konten'},
      {'iconPath': 'assets/images/aktifitasadmin.png', 'activeIcon': 'assets/images/Aktifitas.png', 'label': 'Aktivitas'},
      {'iconPath': 'assets/images/laporanadmin.png', 'activeIcon': 'assets/images/Laporan.png', 'label': 'Laporan'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEBEBEB))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = _selectedNav == i;
          final iconPath = isActive
              ? items[i]['activeIcon'] as String
              : items[i]['iconPath'] as String;
          return GestureDetector(
            onTap: () => setState(() => _selectedNav = i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: isActive
                      ? const EdgeInsets.symmetric(horizontal: 12, vertical: 4)
                      : EdgeInsets.zero,
                  decoration: isActive
                      ? BoxDecoration(
                          color: const Color(0xFFFFF8EC),
                          borderRadius: BorderRadius.circular(10))
                      : null,
                  child: Image.asset(iconPath, width: 22, height: 22,
                      color: isActive ? const Color(0xFFF5A623) : const Color(0xFF6B7280),
                      errorBuilder: (_, __, ___) => Icon(Icons.circle,
                          size: 22,
                          color: isActive
                              ? const Color(0xFFF5A623)
                              : const Color(0xFF6B7280))),
                ),
                const SizedBox(height: 4),
                Text(items[i]['label'] as String,
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700,
                        color: isActive
                            ? const Color(0xFFF5A623)
                            : const Color(0xFF6B7280),
                        fontFamily: 'Poppins')),
              ],
            ),
          );
        }),
      ),
    );
  }
}