import 'package:flutter/material.dart';
import 'materi_murid.dart';
import 'riwayat_page.dart';
import 'edit_profilepage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String nama = 'Naysila';
  String email = 'naysila@student.com';
  String noTelp = '+62 812 3456 7890';
  String tanggalLahir = '15 Maret 2005';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildAvatarSection(context),
                    const SizedBox(height: 24),
                    _buildInfoPribadi(context),
                    const SizedBox(height: 20),
                    _buildPaketAktif(),
                    const SizedBox(height: 24),
                    _buildKeluarButton(context),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, size: 22, color: Color(0xFF1A1D2E)),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Profil Saya',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1D2E),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(width: 22),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF3B72FF), width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset('assets/images/user.png', fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    // TODO: ganti foto profil
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B72FF),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            nama,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1D2E),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(
                    nama: nama,
                    email: email,
                    noTelp: noTelp,
                    tanggalLahir: tanggalLahir,
                  ),
                ),
              );
              if (result != null && result is Map<String, String>) {
                setState(() {
                  nama = result['nama'] ?? nama;
                  email = result['email'] ?? email;
                  noTelp = result['noTelp'] ?? noTelp;
                  tanggalLahir = result['tanggalLahir'] ?? tanggalLahir;
                });
              }
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text(
              'Edit Profil',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B72FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPribadi(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Pribadi',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1D2E),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoItem(
                iconPath: 'assets/images/namaprofile.png',
                label: 'Nama Lengkap',
                value: nama,
                isLast: false,
                onTap: () => _showEditDialog(context, 'Nama Lengkap', nama, (val) {
                  setState(() => nama = val);
                }),
              ),
              _buildInfoItem(
                iconPath: 'assets/images/emailprofile.png',
                label: 'Email',
                value: email,
                isLast: false,
                onTap: () => _showEditDialog(context, 'Email', email, (val) {
                  setState(() => email = val);
                }),
              ),
              _buildInfoItem(
                iconPath: 'assets/images/notelpprofile.png',
                label: 'No. Telepon',
                value: noTelp,
                isLast: false,
                onTap: () => _showEditDialog(context, 'No. Telepon', noTelp, (val) {
                  setState(() => noTelp = val);
                }),
              ),
              _buildInfoItem(
                iconPath: 'assets/images/ttlprofile.png',
                label: 'Tanggal Lahir',
                value: tanggalLahir,
                isLast: true,
                onTap: () => _showEditDialog(context, 'Tanggal Lahir', tanggalLahir, (val) {
                  setState(() => tanggalLahir = val);
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(
    BuildContext context,
    String label,
    String currentValue,
    Function(String) onSave,
  ) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Edit $label',
          style: const TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins', fontSize: 16),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(fontFamily: 'Poppins'),
          decoration: InputDecoration(
            hintText: 'Masukkan $label',
            hintStyle: const TextStyle(fontFamily: 'Poppins', color: Color(0xFF9CA3AF)),
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF6B7280))),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSave(controller.text.trim());
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B72FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String iconPath,
    required String label,
    required String value,
    required bool isLast,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.vertical(
            top: isLast == false ? Radius.zero : const Radius.circular(18),
            bottom: isLast ? const Radius.circular(18) : Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(9),
                  child: Image.asset(
                    iconPath,
                    fit: BoxFit.contain,
                    color: const Color(0xFF3B72FF),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9CA3AF),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1D2E),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 70, endIndent: 16, color: Color(0xFFF0F0F0)),
      ],
    );
  }

  Widget _buildPaketAktif() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Paket Aktif',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1D2E),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B72FF), Color(0xFFF5A623)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('👑', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  const Text(
                    'Paket Premium',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Aktif',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildPaketFeature('Akses semua materi pembelajaran'),
              const SizedBox(height: 6),
              _buildPaketFeature('Sertifikat digital'),
              const SizedBox(height: 6),
              _buildPaketFeature('Konsultasi dengan mentor'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Berlaku hingga',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.75),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '15 Maret 2026',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF3B72FF),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Perpanjang',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaketFeature(String text) {
    return Row(
      children: [
        const Icon(Icons.check, color: Colors.white, size: 16),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildKeluarButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: const Text(
                'Keluar dari Akun',
                style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins'),
              ),
              content: const Text(
                'Apakah kamu yakin ingin keluar dari akun?',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF6B7280)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: navigasi ke login
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53E3E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Keluar',
                    style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.logout, color: Color(0xFFE53E3E), size: 18),
        label: const Text(
          'Keluar dari Akun',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFE53E3E)),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFFFE5E5), width: 1.5),
          backgroundColor: const Color(0xFFFFF5F5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEBEBEB))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, 'assets/images/home.png', 'Beranda', false),
          _buildNavItem(context, 'assets/images/materinavbar.png', 'Materi', false),
          _buildNavItem(context, 'assets/images/forum.png', 'Forum', false),
          _buildNavItem(context, 'assets/images/history.png', 'Riwayat', false),
          _buildNavItem(context, 'assets/images/profile.png', 'Profil', true),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, String iconPath, String label, bool isActive) {
    return GestureDetector(
      onTap: isActive
          ? null
          : () {
              if (label == 'Beranda') {
                Navigator.pop(context);
              } else if (label == 'Materi') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MateriMurid(initialLevel: 'Beginner')),
                );
              } else if (label == 'Riwayat') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RiwayatPage()),
                );
              }
            },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: isActive
                ? const EdgeInsets.symmetric(horizontal: 12, vertical: 4)
                : EdgeInsets.zero,
            decoration: isActive
                ? BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(10),
                  )
                : null,
            child: Image.asset(
              iconPath,
              width: 22,
              height: 22,
              color: isActive ? const Color(0xFF3B72FF) : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isActive ? const Color(0xFF3B72FF) : const Color(0xFF6B7280),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}