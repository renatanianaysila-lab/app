import 'package:flutter/material.dart';

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final _namaController = TextEditingController(text: 'Naysila');
  final _emailController = TextEditingController(text: 'naysila@student.com');
  final _noTelpController = TextEditingController(text: '+62 812 3456 7890');
  final _ttlController = TextEditingController(text: '15 Maret 2005');

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _noTelpController.dispose();
    _ttlController.dispose();
    super.dispose();
  }

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
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildAvatarSection(),
                    const SizedBox(height: 28),
                    _buildFormSection(),
                    const SizedBox(height: 28),
                    _buildSimpanButton(context),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── TOP BAR ───────────────────────────────────────────
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
                'Edit Profil',
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

  // ─── AVATAR SECTION ────────────────────────────────────
  Widget _buildAvatarSection() {
    return Center(
      child: Stack(
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
              child: Image.asset(
                'assets/images/murid.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 50),
              ),
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
    );
  }

  // ─── FORM SECTION ──────────────────────────────────────
  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(18),
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
          _buildTextField(
            controller: _namaController,
            label: 'Nama Lengkap',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _noTelpController,
            label: 'No. Telepon',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _ttlController,
            label: 'Tanggal Lahir',
            icon: Icons.calendar_today_outlined,
            readOnly: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2005, 3, 15),
                firstDate: DateTime(1990),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF3B72FF),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                final months = [
                  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
                  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
                ];
                setState(() {
                  _ttlController.text =
                      '${picked.day} ${months[picked.month - 1]} ${picked.year}';
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1D2E),
            fontFamily: 'Poppins',
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF3B72FF), size: 20),
            filled: true,
            fillColor: const Color(0xFFF7F8FC),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF3B72FF), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ─── SIMPAN BUTTON ─────────────────────────────────────
  Widget _buildSimpanButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Profil berhasil diperbarui!',
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
              ),
              backgroundColor: const Color(0xFF4CAF7D),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B72FF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: const Text(
          'Simpan Perubahan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
