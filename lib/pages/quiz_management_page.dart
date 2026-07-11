import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizManagementPage extends StatefulWidget {
  final String quizTitle;
  final int? materiId;
  final String level;

  const QuizManagementPage({
    super.key,
    required this.quizTitle,
    required this.materiId,
    required this.level,
  });

  @override
  State<QuizManagementPage> createState() => _QuizManagementPageState();
}

class _QuizManagementPageState extends State<QuizManagementPage> {
  int currentQuestionIndex = 0;
  bool _isLoading = true;
  List<dynamic> _quizQuestions = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  // ─── 1. AMBIL DATA SOAL DARI LARAVEL (MENGGUNAKAN MATERI_ID) ───
  Future<void> _fetchQuestions() async {
    if (widget.materiId == null) {
      setState(() {
        _errorMessage = 'Materi ID tidak ditemukan untuk kuis ini.';
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('https://isyaratkita.alwaysdata.net/api/quizzes?materi_id=${widget.materiId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _quizQuestions = json.decode(response.body);
          _isLoading = false;
          // Menggeser index mundur ke belakang jika soal aktif barusan dihapus
          if (currentQuestionIndex >= _quizQuestions.length && _quizQuestions.isNotEmpty) {
            currentQuestionIndex = _quizQuestions.length - 1;
          }
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat kuis (Status: ${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal terhubung ke server Laravel.';
        _isLoading = false;
      });
    }
  }

  // ─── 2. POPUP DIALOG UNTUK TAMBAH / EDIT SOAL (GOOGLE FORM STYLE) ───
  void _showQuestionFormDialog({Map<String, dynamic>? existingQuestion}) {
    final isEdit = existingQuestion != null;
    
    final TextEditingController pertanyaanCtrl = TextEditingController(
        text: isEdit ? existingQuestion['question'] : '');
    final TextEditingController opsiACtrl = TextEditingController(
        text: isEdit ? existingQuestion['options']['A'] : '');
    final TextEditingController opsiBCtrl = TextEditingController(
        text: isEdit ? existingQuestion['options']['B'] : '');
    final TextEditingController opsiCCtrl = TextEditingController(
        text: isEdit ? existingQuestion['options']['C'] : '');
    final TextEditingController opsiDCtrl = TextEditingController(
        text: isEdit ? existingQuestion['options']['D'] : '');
        
    String selectedKunci = isEdit ? existingQuestion['jawabanBenar'] : 'A';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                isEdit ? 'Edit Pertanyaan' : 'Tambah Pertanyaan Baru',
                style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: pertanyaanCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Pertanyaan *',
                        labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildOpsiField(opsiACtrl, 'Opsi A *'),
                    const SizedBox(height: 8),
                    _buildOpsiField(opsiBCtrl, 'Opsi B *'),
                    const SizedBox(height: 8),
                    _buildOpsiField(opsiCCtrl, 'Opsi C *'),
                    const SizedBox(height: 8),
                    _buildOpsiField(opsiDCtrl, 'Opsi D *'),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Text('Kunci Jawaban: ', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: selectedKunci,
                          items: ['A', 'B', 'C', 'D'].map((String val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text('Pilihan $val', style: const TextStyle(fontFamily: 'Poppins')),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setDialogState(() => selectedKunci = val);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB800),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    if (pertanyaanCtrl.text.isEmpty || opsiACtrl.text.isEmpty || opsiBCtrl.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pertanyaan dan Opsi jawaban wajib diisi!')),
                      );
                      return;
                    }

                    try {
                      // Menentukan endpoint secara dinamis: jika edit pake PUT, jika baru pake POST
                      final url = isEdit 
                          ? 'https://isyaratkita.alwaysdata.net/api/quizzes/${existingQuestion['id']}' 
                          : 'https://isyaratkita.alwaysdata.net/api/quizzes'; 

                      final response = await (isEdit 
                          ? http.put(Uri.parse(url), headers: {'Content-Type': 'application/json'}, body: json.encode({
                              'pertanyaan': pertanyaanCtrl.text,
                              'opsi_a': opsiACtrl.text,
                              'opsi_b': opsiBCtrl.text,
                              'opsi_c': opsiCCtrl.text,
                              'opsi_d': opsiDCtrl.text,
                              'jawaban_benar': selectedKunci,
                            }))
                          : http.post(Uri.parse(url), headers: {'Content-Type': 'application/json'}, body: json.encode({
                              'materi_id': widget.materiId,
                              'pertanyaan': pertanyaanCtrl.text,
                              'opsi_a': opsiACtrl.text,
                              'opsi_b': opsiBCtrl.text,
                              'opsi_c': opsiCCtrl.text,
                              'opsi_d': opsiDCtrl.text,
                              'jawaban_benar': selectedKunci,
                              'level': widget.level,
                            })));

                      if (response.statusCode == 200 || response.statusCode == 201) {
                        if (mounted) {
                          Navigator.pop(context);
                          _fetchQuestions(); // Otomatis refresh list kuis di UI
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(isEdit ? 'Berhasil memperbarui soal!' : 'Berhasil menambahkan soal baru!')),
                          );
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Gagal memproses ke server (Status: ${response.statusCode})')),
                          );
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Terjadi kesalahan koneksi ke server.')),
                        );
                      }
                    }
                  },
                  child: const Text('Simpan', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildOpsiField(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ─── 3. AKSI HAPUS SOAL ───
  void _deleteQuestion(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('https://isyaratkita.alwaysdata.net/api/quizzes/$id'),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pertanyaan berhasil dihapus!')),
          );
          _fetchQuestions(); // Refresh UI setelah data terhapus dari DB
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus soal (Status: ${response.statusCode})')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Koneksi gagal saat mencoba menghapus data.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // AppBar COPAS PERSIS milik murid
      appBar: AppBar(
        title: Text(
          widget.quizTitle,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Poppins'),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Tombol Tambah Soal Baru diletakkan di Pojok Kanan Atas AppBar Guru
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFFFFB800), size: 26),
            onPressed: () => _showQuestionFormDialog(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFB800)))
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: const TextStyle(fontFamily: 'Poppins', color: Colors.red)))
              : _quizQuestions.isEmpty
                  ? const Center(child: Text('Belum ada soal kuis di modul ini.', style: TextStyle(fontFamily: 'Poppins')))
                  : _buildQuizBody(),
    );
  }
  
  Widget _buildQuizBody() {
    final currentQuestion = _quizQuestions[currentQuestionIndex];
    bool isLastQuestion = currentQuestionIndex == _quizQuestions.length - 1;

    return SafeArea(
      child: Column(
        children: [
          // 1. Nomor Indikator Bulat-Bulat (COPAS PERSIS layout murid)
          Container(
            height: 60,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: _quizQuestions.length,
              itemBuilder: (context, index) {
                bool isCurrent = index == currentQuestionIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentQuestionIndex = index;
                    });
                  },
                  child: Container(
                    width: 36,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isCurrent ? const Color(0xFFFFB800) : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                      border: isCurrent ? Border.all(color: const Color(0xFFFFB800)) : null,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isCurrent ? Colors.white : const Color(0xFF475569),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: 'Poppins'
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // 2. Box Soal Konten Putih Utama
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Baris Tambahan Guru: Tombol EDIT dan DELETE di dalam Soal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_note_rounded, color: Colors.blue, size: 26),
                              onPressed: () => _showQuestionFormDialog(existingQuestion: currentQuestion),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_sweep_rounded, color: Colors.red, size: 24),
                              onPressed: () => _deleteQuestion(currentQuestion['id']),
                            ),
                          ],
                        ),
                        
                        Text(
                          currentQuestion['instruction'] ?? 'Pilihlah salah satu jawaban yang paling tepat!',
                          style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          currentQuestion['question'] ?? '',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. Render List Pilihan Jawaban (A, B, C, D) COPAS PERSIS Style Layout Murid
                  ...['A', 'B', 'C', 'D'].map((key) {
                    String optionText = currentQuestion['options'][key] ?? '';
                    // Karena ini Guru, kunci jawaban langsung otomatis aktif berwarna hijau (di-highlight)
                    bool isCorrectKey = currentQuestion['jawabanBenar'] == key;

                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCorrectKey ? const Color(0xFFF0FDF4) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCorrectKey ? Colors.green : const Color(0xFFE2E8F0),
                          width: isCorrectKey ? 1.5 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 8, offset: const Offset(0, 2))
                        ],
                      ),
                      child: Row(
                        children: [
                          // Lingkaran Abjad Huruf A/B/C/D
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isCorrectKey ? Colors.green : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: isCorrectKey ? Colors.green : const Color(0xFFCBD5E1)),
                            ),
                            child: Center(
                              child: Text(
                                key,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isCorrectKey ? Colors.white : const Color(0xFF475569),
                                  fontFamily: 'Poppins'
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Label Teks Opsi Pilihan
                          Expanded(
                            child: Text(
                              optionText,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isCorrectKey ? FontWeight.bold : FontWeight.w500,
                                color: isCorrectKey ? Colors.green.shade900 : const Color(0xFF334155),
                                fontFamily: 'Poppins'
                              ),
                            ),
                          ),
                          if (isCorrectKey)
                            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // 4. Bar Tombol Navigasi Bawah (COPAS PERSIS layout murid)
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              children: [
                // Tombol Kembali
                if (currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          currentQuestionIndex--;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chevron_left_rounded, color: Color(0xFF475569), size: 18),
                          SizedBox(width: 6),
                          Text('Sebelumnya', style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ),
                if (currentQuestionIndex > 0) const SizedBox(width: 12),

                // Tombol Selanjutnya / Selesai
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!isLastQuestion) {
                        setState(() {
                          currentQuestionIndex++;
                        });
                      } else {
                        Navigator.pop(context); // Menutup jika sudah di soal terakhir
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB800),
                      minimumSize: const Size.fromHeight(50),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLastQuestion ? 'Selesai Tinjau' : 'Selanjutnya',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Poppins'),
                        ),
                        if (!isLastQuestion) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18),
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
