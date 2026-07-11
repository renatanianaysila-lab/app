import 'dart:convert';
import 'dart:typed_data'; // Wajib untuk menangani bytes gambar di web
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profil_guru_page.dart';
import 'role_page.dart';

class ProfilGuruPage extends StatefulWidget {
  const ProfilGuruPage({super.key});

  @override
  State<ProfilGuruPage> createState() => _ProfilGuruPageState();
}

class _ProfilGuruPageState extends State<ProfilGuruPage> {
  // State data profil
  String nama = "Memuat...";
  String email = "Memuat...";
  String telepon = "-";
  String keahlian = "-";
  String deskripsi = "Memuat data profil dari server...";
  String? fotoUrl; 
  
  bool _isLoading = true;
  String currentGuruId = ""; 

  final ImagePicker _picker = ImagePicker();
  Uint8List? _localWebImageBytes; // Menyimpan cache gambar untuk preview instan di laptop/web

  @override
  void initState() {
    super.initState();
    _loadAndFetchProfile();
  }

  // ─── AMBIL DATA ID DARI SESSION LOGIN & PANGGIL API ───
  Future<void> _loadAndFetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Otomatis membaca guru_id yang disimpan saat login, jika kosong pakai fallback G0001
      currentGuruId = prefs.getString('guru_id') ?? prefs.getString('id_user') ?? 'G0001';
    });
    _fetchProfilGuru();
  }

  String _getApiUrl() {
    final String baseUrl = Uri.base.host == '10.0.2.2' ? 'https://isyaratkita.alwaysdata.net' : 'https://isyaratkita.alwaysdata.net';
    return '$baseUrl/api/guru/profile/$currentGuruId';
  }

  // ─── 1. FETCH DATA PROFIL GURU (GET) ───────────────────────────
  Future<void> _fetchProfilGuru() async {
    if (currentGuruId.isEmpty) return;
    try {
      final response = await http.get(
        Uri.parse(_getApiUrl()),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          nama = data['nama_guru'] ?? data['name'] ?? "Nama Tidak Diatur";
          email = data['email_guru'] ?? data['email'] ?? "Email Tidak Diatur";
          telepon = data['phone'] ?? "-";
          keahlian = data['skills'] ?? data['sertifikasi'] ?? "-";
          deskripsi = data['description'] ?? "Belum ada deskripsi profil.";
          fotoUrl = data['foto_profil_guru']; // Sesuai kolom database guru (1).sql
          _isLoading = false;
        });
      } else {
        debugPrint('Gagal mengambil data profil. Code: ${response.statusCode}');
        _useFallbackData();
      }
    } catch (e) {
      debugPrint('Error fetch profil: $e');
      _useFallbackData();
    }
  }

  Future<void> _useFallbackData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String savedName = prefs.getString('username') ?? prefs.getString('name') ?? prefs.getString('nama') ?? "Guru Isyarat";
      nama = savedName;
      email = prefs.getString('email') ?? "guru@gmail.com";
      telepon = "+62 812-3456-7890";
      keahlian = "BISINDO / SIBI";
      deskripsi = "Saya adalah pengajar bahasa isyarat aktif di IsyaratKita.";
      _isLoading = false;
    });
  }

  // ─── 2. FITUR UPLOAD FOTO PROFIL (POST MULTIPART) ──────────────────
  Future<void> _uploadFotoProfil() async {
    try {
      // Buka file explorer di laptop atau galeri di HP
      final XFile? imageFile = kIsWeb
          ? await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80)
          : await _picker.pickImage(source: ImageSource.gallery);

      if (imageFile == null) return; 

      final bytes = await imageFile.readAsBytes();

      // Pasang preview lokal biar di browser web laptop langsung berubah tanpa ketahan CORS
      setState(() {
        _isLoading = true;
        if (kIsWeb) {
          _localWebImageBytes = bytes; 
        }
      });
      
      final String baseUrl = Uri.base.host == '10.0.2.2' ? 'https://isyaratkita.alwaysdata.net' : 'https://isyaratkita.alwaysdata.net';
      final String uploadUrl = '$baseUrl/api/guru/profile/$currentGuruId/upload-avatar';
      
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      
      request.files.add(http.MultipartFile.fromBytes(
        'foto_profil_guru', // Nama field disamakan dengan field database kamu
        bytes,
        filename: imageFile.name,
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto profil berhasil diubah!'), backgroundColor: Colors.green),
          );
        }
        _fetchProfilGuru(); // Sinkronisasi ulang data terbaru dari backend
      } else {
        debugPrint('Gagal upload foto. Code: ${response.statusCode}');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error upload foto profil: $e');
      setState(() => _isLoading = false);
    }
  }

  // ─── 3. FITUR UPDATE DATA TEKS PROFIL (PUT) ────────────────────────
  Future<void> _updateProfilGuru(Map<String, String> updatedData) async {
    setState(() => _isLoading = true);
    try {
      final response = await http.put(
        Uri.parse(_getApiUrl()),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': updatedData['nama'],
          'email': updatedData['email'],
          'phone': updatedData['telepon'],
          'skills': updatedData['keahlian'],
          'description': updatedData['deskripsi'],
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Colors.green),
          );
        }
        _fetchProfilGuru(); 
      } else {
        debugPrint('Gagal update database. Status: ${response.statusCode}');
        _updateLocalState(updatedData);
      }
    } catch (e) {
      debugPrint('Error update profil: $e');
      _updateLocalState(updatedData);
    }
  }

  void _updateLocalState(Map<String, String> updatedData) {
    setState(() {
      nama = updatedData['nama']!;
      email = updatedData['email']!;
      telepon = updatedData['telepon']!;
      keahlian = updatedData['keahlian']!;
      deskripsi = updatedData['deskripsi']!;
      _isLoading = false;
    });
  }

  // ─── 4. PROSES KELUAR / HAPUS SESSION ─────────────────────────────
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Bersihkan semua sisa data akun lama
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const RolePage()), 
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF2F80ED)))
        : RefreshIndicator(
            onRefresh: _fetchProfilGuru, 
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
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
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: const Color(0xFFE5E5E5),
                                // Logika aman render preview gambar di Web/Laptop & HP Fisik
                                backgroundImage: kIsWeb && _localWebImageBytes != null
                                    ? MemoryImage(_localWebImageBytes!)
                                    : (fotoUrl != null ? NetworkImage(fotoUrl!) : null) as ImageProvider?,
                                child: (fotoUrl == null && _localWebImageBytes == null)
                                    ? const Icon(Icons.person, color: Colors.white, size: 60)
                                    : null,
                              ),
                            ),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: const Color(0xFF2F80ED),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                                onPressed: _uploadFotoProfil, // Fungsi ganti avatar aktif 📸
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

                            if (result != null && result is Map<String, String>) {
                              _updateProfilGuru(result); 
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

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
                        
                        _buildProfileTile(
                          iconData: Icons.person,
                          iconBgColor: const Color(0xFFE8F1FF),
                          iconColor: const Color(0xFF2F80ED),
                          label: "Nama Lengkap",
                          value: nama,
                        ),
                        _buildProfileTile(
                          iconData: Icons.email,
                          iconBgColor: const Color(0xFFE8F1FF),
                          iconColor: const Color(0xFF2F80ED),
                          label: "Email",
                          value: email,
                        ),
                        _buildProfileTile(
                          iconData: Icons.phone,
                          iconBgColor: const Color(0xFFE8F1FF),
                          iconColor: const Color(0xFF2F80ED),
                          label: "No. Telepon",
                          value: telepon,
                        ),
                        _buildProfileTile(
                          iconData: Icons.verified_user_rounded,
                          iconBgColor: const Color(0xFFE8F1FF),
                          iconColor: const Color(0xFF2F80ED),
                          label: "Keahlian / Sertifikasi",
                          value: keahlian,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

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
                      onPressed: _logout, 
                    ),
                  ),
                ],
              ),
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
