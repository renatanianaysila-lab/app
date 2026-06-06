import 'package:flutter/material.dart';

class EditProfilGuruPage extends StatefulWidget {
  final String currentNama;
  final String currentEmail;
  final String currentTelepon;
  final String currentKeahlian;
  final String currentDeskripsi;

  const EditProfilGuruPage({
    super.key,
    required this.currentNama,
    required this.currentEmail,
    required this.currentTelepon,
    required this.currentKeahlian,
    required this.currentDeskripsi,
  });

  @override
  State<EditProfilGuruPage> createState() => _EditProfilGuruPageState();
}

class _EditProfilGuruPageState extends State<EditProfilGuruPage> {
  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController teleponController;
  late TextEditingController keahlianController;
  late TextEditingController deskripsiController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.currentNama);
    emailController = TextEditingController(text: widget.currentEmail);
    teleponController = TextEditingController(text: widget.currentTelepon);
    keahlianController = TextEditingController(text: widget.currentKeahlian);
    deskripsiController = TextEditingController(text: widget.currentDeskripsi);
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    teleponController.dispose();
    keahlianController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ubah Profil Saya",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField("Nama Lengkap Guru", namaController, Icons.person),
            const SizedBox(height: 16),
            _buildInputField("Email Aktif", emailController, Icons.email),
            const SizedBox(height: 16),
            _buildInputField("No. Telepon", teleponController, Icons.phone),
            const SizedBox(height: 16),
            _buildInputField("Keahlian Materi", keahlianController, Icons.verified_user_rounded),
            const SizedBox(height: 16),
            _buildInputField("Deskripsi Singkat Pengajar", deskripsiController, Icons.description, maxLines: 4),
            const SizedBox(height: 32),
            
            // Tombol Simpan Perubahan Data
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F80ED),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Kembalikan map data baru ke halaman profil utama saat pop
                  Navigator.pop(context, {
                    'nama': namaController.text,
                    'email': emailController.text,
                    'telepon': teleponController.text,
                    'keahlian': keahlianController.text,
                    'deskripsi': deskripsiController.text,
                  });
                },
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: Colors.blue.shade400),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2F80ED), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}