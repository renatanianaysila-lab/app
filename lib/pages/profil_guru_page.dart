import 'package:flutter/material.dart';
import 'edit_profil_guru_page.dart';

class ProfilGuruPage extends StatefulWidget {
  const ProfilGuruPage({super.key});

  @override
  State<ProfilGuruPage> createState() => _ProfilGuruPageState();
}

class _ProfilGuruPageState extends State<ProfilGuruPage> {
  // Data profil tiruan awal (bisa diedit)
  String nama = "Naysila, S.Pd";
  String email = "naysila@teacher.com";
  String telepon = "+62 812 3456 7890";
  String keahlian = "BISINDO / SIBI";
  String deskripsi = "Saya adalah pengajar bahasa isyarat BISINDO dengan pengalaman 3 tahun, fokus membantu pemula memahami komunikasi dasar sehari-hari.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // ─── BAGIAN FOTO & NAMA UTAMA ─────────────────────────────────────
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.amber],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 55,
                          backgroundColor: Color(0xFFE5E5E5),
                          child: Icon(Icons.person, color: Colors.white, size: 60),
                        ),
                      ),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: const Color(0xFF2F80ED),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    nama,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Guru Bahasa Isyarat (BISINDO)",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  
                  // Tombol Edit Profil menggunakan aset edit_profil
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F80ED),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.edit_square, size: 18),
                    label: const Text("Edit Profil", style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      // Berpindah ke halaman edit sambil membawa data profil saat ini
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilGuruPage(
                            currentNama: nama,
                            currentEmail: email,
                            currentTelepon: telepon,
                            currentKeahlian: keahlian,
                            currentDeskripsi: deskripsi,
                          ),
                        ),
                      );

                      // Jika user menyimpan perubahan data baru
                      if (result != null && result is Map<String, String>) {
                        setState(() {
                          nama = result['nama']!;
                          email = result['email']!;
                          telepon = result['telepon']!;
                          keahlian = result['keahlian']!;
                          deskripsi = result['deskripsi']!;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ─── KARTU INFORMASI PRIBADI ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Informasi Pribadi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 12),
                  const Text("Deskripsi", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    deskripsi,
                    style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  
                  // Baris Nama Lengkap
                  _buildProfileTile(
                    iconData: Icons.person,
                    iconBgColor: const Color(0xFFE8F1FF),
                    iconColor: const Color(0xFF2F80ED),
                    label: "Nama Lengkap",
                    value: nama,
                  ),
                  // Baris Email
                  _buildProfileTile(
                    iconData: Icons.email,
                    iconBgColor: const Color(0xFFE8F1FF),
                    iconColor: const Color(0xFF2F80ED),
                    label: "Email",
                    value: email,
                  ),
                  // Baris No Telepon
                  _buildProfileTile(
                    iconData: Icons.phone,
                    iconBgColor: const Color(0xFFE8F1FF),
                    iconColor: const Color(0xFF2F80ED),
                    label: "No. Telepon",
                    value: telepon,
                  ),
                  // Baris Keahlian
                  _buildProfileTile(
                    iconData: Icons.verified_user_rounded,
                    iconBgColor: const Color(0xFFE8F1FF),
                    iconColor: const Color(0xFF2F80ED),
                    label: "Keahlian",
                    value: keahlian,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── TOMBOL KELUAR AKUN ───────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFFFFEBEB)),
                  backgroundColor: const Color(0xFFFFF5F5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.logout, color: Color(0xFFEB5757), size: 18),
                label: const Text(
                  "Keluar dari Akun",
                  style: TextStyle(color: Color(0xFFEB5757), fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  // Tambahkan fungsi logout atau balik ke RolePage di sini
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData iconData,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(10)),
                child: Icon(iconData, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 2),
                    Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 45),
      ],
    );
  }
}