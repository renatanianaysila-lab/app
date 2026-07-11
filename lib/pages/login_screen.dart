// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // untuk session login
import 'forgot_password_page.dart';
import 'sign_up_page.dart'; 
import 'package:app/pages/role_page.dart'; // Import RolePage buat alur daftar
import 'main_navigation.dart'; // langsung ke Beranda Murid
import 'main_navigation_guru.dart'; // langsung ke Beranda Guru
import 'beranda_admin.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  // Constructor dibuat polosan tanpa mewajibkan lemparan data role dari splash screen
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLogin = true;
  bool isPasswordHidden = true;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF9AA1AC), fontFamily: 'Poppins'),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF9AA1AC)),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF3F3F3),
      contentPadding: const EdgeInsets.symmetric(vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Color(0xFF8FB1F3), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    // ── 1. LOGIKA LOGIN ADMIN BYPASS ──
    if (email == 'admin@gmail.com' && password == '12345678') {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BerandaAdmin()),
      );
      return;
    }

    const String urlLogin = 'http://10.0.2.2:8000/api/login';
    
    try {
      final response = await http.post(
        Uri.parse(urlLogin),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        String role = responseData['role'] ?? 'murid';
        
        if (role == 'admin') {
          await prefs.setString('role', 'admin');
          if (mounted) {
            _showSnackBar('Selamat datang kembali Admin!', Colors.green);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const BerandaAdmin()),
            );
          }
        } else if (role == 'murid') {
          await prefs.setString('role', 'murid');
          await prefs.setString('murid_id', responseData['user']['murid_id'] ?? '');
          await prefs.setString('nama_murid', responseData['user']['nama_murid'] ?? '');
          
          if (mounted) {
            _showSnackBar('Selamat datang kembali, ${responseData['user']['nama_murid']}!', Colors.green);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainNavigation(initialIndex: 0)),
            );
          }
        } else if (role == 'guru') {
          await prefs.setString('role', 'guru');
          await prefs.setString('guru_id', responseData['user']['guru_id'] ?? '');
          await prefs.setString('nama_guru', responseData['user']['nama_guru'] ?? '');
          
          if (mounted) {
            _showSnackBar('Selamat datang kembali Guru, ${responseData['user']['nama_guru']}!', Colors.green);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainNavigationGuru()),
            );
          }
        }
      } else if (response.statusCode == 403) {
        if (mounted) {
          _showSnackBar(responseData['message'] ?? 'Akun Guru Anda belum disetujui oleh Admin.', Colors.orange);
        }
      } else {
        if (mounted) {
          _showSnackBar(responseData['message'] ?? 'Email atau password salah', Colors.red);
        }
      }
    } catch (e) {
      if (mounted) _showSnackBar('Gagal terhubung ke server: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Poppins')), 
        backgroundColor: color
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFDCE6F1), Color(0xFFF4EFCF)],
          ),
        ),
        child: SafeArea(
          child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF5F8DFF)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        Image.asset('assets/images/logo.png', width: 110, height: 110, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 110)),
                        const SizedBox(height: 12),
                        const Text(
                          'IsyaratKita',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            color: Color(0xFF273043),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Belajar Bahasa Isyarat Bersama',
                          style: TextStyle(fontSize: 14, fontFamily: 'Poppins', color: Color(0xFF5D6470)),
                        ),
                        const SizedBox(height: 26),
                        const Text(
                          'Selamat Datang',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF273043),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Masuk ke akun Anda untuk melanjutkan\npembelajaran',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, fontFamily: 'Poppins', height: 1.5, color: Color(0xFF5D6470)),
                        ),
                        const SizedBox(height: 30),
                        
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Email', style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: Color(0xFF414A57))),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                          decoration: _inputDecoration(hintText: 'Masukkan email Anda', prefixIcon: Icons.email_outlined),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email wajib diisi';
                            }
                            final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'Format email tidak valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 22),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Password', style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: Color(0xFF414A57))),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: isPasswordHidden,
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                          decoration: _inputDecoration(
                            hintText: 'Masukkan password Anda',
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => isPasswordHidden = !isPasswordHidden),
                              icon: Icon(
                                isPasswordHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: const Color(0xFF9AA1AC),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Password wajib diisi';
                            if (value.length < 8) return 'Password minimal 8 karakter';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                            ),
                            child: const Text('Lupa Password?', style: TextStyle(color: Color(0xFF5F8DFF), fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton.icon(
                            onPressed: _submit,
                            icon: const Icon(Icons.login, color: Colors.white),
                            label: const Text(
                              'Masuk',
                              style: TextStyle(fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5F8DFF),
                              elevation: 6,
                              shadowColor: Colors.black26,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 34),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Belum punya akun? ',
                              style: TextStyle(fontSize: 14, fontFamily: 'Poppins', color: Color(0xFF5D6470)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const RolePage()),
                                );
                              },
                              child: const Text('Daftar', style: TextStyle(fontFamily: 'Poppins')),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
