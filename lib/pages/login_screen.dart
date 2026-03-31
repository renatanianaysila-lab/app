import 'package:flutter/material.dart';
import 'forgot_password_page.dart';
import 'home_page.dart';
import 'sign_up_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLogin = true;
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF9AA1AC)),
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
        borderSide: const BorderSide(
          color: Color(0xFF8FB1F3),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (isLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pendaftaran berhasil diproses')),
      );

      setState(() {
        isLogin = true;
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
      });
    }
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
            colors: [
              Color(0xFFDCE6F1),
              Color(0xFFF4EFCF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),

                  Image.asset(
                    'assets/images/logo.png',
                    width: 110,
                    height: 110,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'IsyaratKita',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      color: Color(0xFF273043),
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Belajar Bahasa Isyarat Bersama',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5D6470),
                    ),
                  ),

                  const SizedBox(height: 26),

                  Text(
                    isLogin ? 'Selamat Datang' : 'Daftar Akun',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF273043),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    isLogin
                        ? 'Masuk ke akun Anda untuk melanjutkan\npembelajaran'
                        : 'Buat akun baru untuk memulai',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF5D6470),
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (!isLogin) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nama',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF414A57),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration(
                        hintText: 'Masukkan nama lengkap',
                        prefixIcon: Icons.person_outline,
                      ),
                      validator: (value) {
                        if (!isLogin && (value == null || value.trim().isEmpty)) {
                          return 'Nama wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 22),
                  ],

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF414A57),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration(
                      hintText: 'Masukkan email Anda',
                      prefixIcon: Icons.email_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }
                      if (!value.contains('@')) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 22),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF414A57),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: isPasswordHidden,
                    decoration: _inputDecoration(
                      hintText: 'Masukkan password Anda',
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                        icon: Icon(
                          isPasswordHidden
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF9AA1AC),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password wajib diisi';
                      }
                      if (!isLogin && value.length < 8) {
                        return 'Password minimal 8 karakter';
                      }
                      return null;
                    },
                  ),

                  if (!isLogin) ...[
                    const SizedBox(height: 22),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Konfirmasi Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF414A57),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: isConfirmPasswordHidden,
                      decoration: _inputDecoration(
                        hintText: 'Ulangi password',
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isConfirmPasswordHidden =
                                  !isConfirmPasswordHidden;
                            });
                          },
                          icon: Icon(
                            isConfirmPasswordHidden
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF9AA1AC),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (!isLogin) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password wajib diisi';
                          }
                          if (value != _passwordController.text) {
                            return 'Password tidak sama';
                          }
                        }
                        return null;
                      },
                    ),
                  ],

                  if (isLogin) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Lupa Password?',
                          style: TextStyle(
                            color: Color(0xFF5F8DFF),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.login, color: Colors.white),
                      label: Text(
                        isLogin ? 'Masuk' : 'Daftar',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF5F8DFF), // Ganti dari 0xFFA9C2F5 ke biru ini
  elevation: 6,
  shadowColor: Colors.black26,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(22),
  ),
),
                    ),
                  ),

                  const SizedBox(height: 34),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLogin
                            ? 'Belum punya akun? '
                            : 'Sudah punya akun? ',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5D6470),
                        ),
                      ),
                      TextButton(
  onPressed: () {
    // Navigasi ke file sign_up_page.dart
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpPage(), // Pastikan nama class di file itu SignUpPage
      ),
    );
  },
  child: const Text(
    'Daftar',
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Color(0xFF5F8DFF),
    ),
  ),
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