import 'package:flutter/material.dart';
import 'quiz_result_page.dart'; 

class QuizPlayPage extends StatefulWidget {
  final String quizTitle;
  const QuizPlayPage({super.key, required this.quizTitle});

  @override
  State<QuizPlayPage> createState() => _QuizPlayPageState();
}

class _QuizPlayPageState extends State<QuizPlayPage> {
  int currentQuestionIndex = 0; 
  late List<Map<String, dynamic>> activeQuizData; // Menampung data kuis yang aktif sesuai pilihan user

  // 1. DATA KUIS BAGIAN ABJAD
  final List<Map<String, dynamic>> daftarSoalAbjad = [
    {
      'id': 1,
      'question': 'Apa arti dari gerakan bahasa isyarat berikut?',
      'instruction': 'Perhatikan gerakan dengan seksama dan pilih jawaban yang tepat',
      'gambarPath': 'assets/images/a_kuis.png',
      'options': {'A': 'Huruf A', 'B': 'Huruf B', 'C': 'Huruf C', 'D': 'Huruf D'},
      'jawabanBenar': 'A',
      'selectedAnswer': null,
      'isFlagged': false,
    },
    {
      'id': 2,
      'question': 'Perhatikan gerakan tangan ini dengan seksama. Huruf apakah ini?',
      'instruction': 'Perhatikan gerakan dengan seksama dan pilih jawaban yang tepat',
      'gambarPath': 'assets/images/d_kuis.png',
      'options': {'A': 'Huruf E', 'B': 'Huruf D', 'C': 'Huruf F', 'D': 'Huruf G'},
      'jawabanBenar': 'B',
      'selectedAnswer': null,
      'isFlagged': false,
    },
    {
      'id': 3,
      'question': 'Simbol gerakan tangan berikut merepresentasikan huruf...',
      'instruction': 'Perhatikan gerakan dengan seksama dan pilih jawaban yang tepat',
      'gambarPath': 'assets/images/g_kuis.png',
      'options': {'A': 'Huruf H', 'B': 'Huruf I', 'C': 'Huruf G', 'D': 'Huruf J'},
      'jawabanBenar': 'C',
      'selectedAnswer': null,
      'isFlagged': false,
    },
    {
      'id': 4,
      'question': 'Apa arti dari gerakan bahasa isyarat berikut?',
      'instruction': 'Perhatikan gerakan dengan seksama dan pilih jawaban yang tepat',
      'gambarPath': 'assets/images/j_kuis.png',
      'options': {'A': 'Huruf K', 'B': 'Huruf L', 'C': 'Huruf M', 'D': 'Huruf J'},
      'jawabanBenar': 'D',
      'selectedAnswer': null,
      'isFlagged': false,
    },
    {
      'id': 5,
      'question': 'Huruf apakah yang ditunjukkan oleh isyarat tangan di bawah ini?',
      'instruction': 'Perhatikan gerakan dengan seksama dan pilih jawaban yang tepat',
      'gambarPath': 'assets/images/w_kuis.png',
      'options': {'A': 'Huruf W', 'B': 'Huruf V', 'C': 'Huruf U', 'D': 'Huruf X'},
      'jawabanBenar': 'A',
      'selectedAnswer': null,
      'isFlagged': false,
    },
  ];

  // 2. DATA KUIS BAGIAN ANGKA (Sesuai dengan nama file di image_3fab9c.png)
  final List<Map<String, dynamic>> daftarSoalAngka = [
    {
      'id': 1,
      'question': 'Simbol isyarat tangan pada gambar berikut menunjukkan angka...',
      'instruction': 'Perhatikan formasi jari dengan seksama dan tentukan nilainya',
      'gambarPath': 'assets/images/angka1_kuis.jpg', // Format .jpg sesuai tanda logo file
      'options': {'A': 'Angka 1', 'B': 'Angka 2', 'C': 'Angka 0', 'D': 'Angka 5'},
      'jawabanBenar': 'A',
      'selectedAnswer': null,
      'isFlagged': false,
    },
    {
      'id': 2,
      'question': 'Berapakah nilai angka yang direpresentasikan oleh gerakan isyarat ini?',
      'instruction': 'Perhatikan formasi jari dengan seksama dan tentukan nilainya',
      'gambarPath': 'assets/images/angka3_kuis.jpg',
      'options': {'A': 'Angka 2', 'B': 'Angka 4', 'C': 'Angka 3', 'D': 'Angka 1'},
      'jawabanBenar': 'C',
      'selectedAnswer': null,
      'isFlagged': false,
    },
    {
      'id': 3,
      'question': 'Apa arti dari simbol isyarat angka pada gambar berikut?',
      'instruction': 'Perhatikan formasi jari dengan seksama dan tentukan nilainya',
      'gambarPath': 'assets/images/angka5_kuis.jpg',
      'options': {'A': 'Angka 10', 'B': 'Angka 5', 'C': 'Angka 6', 'D': 'Angka 4'},
      'jawabanBenar': 'B',
      'selectedAnswer': null,
      'isFlagged': false,
    },
    {
      'id': 4,
      'question': 'Perhatikan posisi jari ini. Isyarat ini melambangkan bilangan...',
      'instruction': 'Perhatikan formasi jari dengan seksama dan tentukan nilainya',
      'gambarPath': 'assets/images/angka6_kuis.jpg',
      'options': {'A': 'Angka 7', 'B': 'Angka 9', 'C': 'Angka 8', 'D': 'Angka 6'},
      'jawabanBenar': 'D',
      'selectedAnswer': null,
      'isFlagged': false,
    },
    {
      'id': 5,
      'question': 'Simbol isyarat tangan pada gambar berikut menunjukkan angka...',
      'instruction': 'Perhatikan formasi jari dengan seksama dan tentukan nilainya',
      'gambarPath': 'assets/images/angka8_kuis.jpg',
      'options': {'A': 'Angka 8', 'B': 'Angka 7', 'C': 'Angka 9', 'D': 'Angka 10'},
      'jawabanBenar': 'A',
      'selectedAnswer': null,
      'isFlagged': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Logika Otomatis: Jika judul mengandung kata 'Angka', muat list angka. Jika tidak, muat list abjad.
    if (widget.quizTitle.toLowerCase().contains('angka')) {
      activeQuizData = daftarSoalAngka;
    } else {
      activeQuizData = daftarSoalAbjad;
    }
  }

  void _submitQuizConfirmation() {
    int totalAnswered = activeQuizData.where((e) => e['selectedAnswer'] != null).length;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Kumpulkan Jawaban?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Kamu telah menjawab $totalAnswered dari ${activeQuizData.length} soal. Apakah kamu yakin ingin mengakhiri kuis?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScorePage(
                    quizData: activeQuizData,
                    quizTitle: widget.quizTitle,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
            child: const Text('Ya, Kirim', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = activeQuizData[currentQuestionIndex];
    final bool isCurrentFlagged = currentQuestion['isFlagged'] ?? false;
    final bool isLastQuestion = currentQuestionIndex == activeQuizData.length - 1;
    
    int totalSoal = activeQuizData.length;
    int nomorAktif = currentQuestionIndex + 1;
    double progressPercent = nomorAktif / totalSoal;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF1F5F9),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.quizTitle, 
                    style: const TextStyle(color: Color(0xFF1E293B), fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis, 
                  ),
                  const Text(
                    'Bahasa Isyarat Indonesia', 
                    style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500)
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12), 
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Soal $nomorAktif dari $totalSoal', 
                  style: const TextStyle(color: Color(0xFF1E293B), fontSize: 13, fontWeight: FontWeight.bold)
                ),
                Text(
                  '${(progressPercent * 100).toInt()}% selesai', 
                  style: const TextStyle(color: Colors.grey, fontSize: 11)
                ),
              ],
            )
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progressPercent,
            backgroundColor: const Color(0xFFE2E8F0),
            color: const Color(0xFF3B82F6),
            minHeight: 4,
          ),
        ),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.help_outline_rounded, size: 14, color: Color(0xFF2563EB)),
                            const SizedBox(width: 6),
                            Text('Soal $nomorAktif', style: const TextStyle(color: Color(0xFF2563EB), fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            activeQuizData[currentQuestionIndex]['isFlagged'] = !isCurrentFlagged;
                          });
                        },
                        icon: Icon(
                          isCurrentFlagged ? Icons.flag_rounded : Icons.flag_outlined, 
                          color: isCurrentFlagged ? Colors.orange : const Color(0xFF94A3B8),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: const Color(0xFFEEF2F6), borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            color: const Color(0xFFE2E8F0),
                            child: Image.asset(
                              currentQuestion['gambarPath'],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.broken_image_rounded, size: 44, color: Color(0xFF475569)),
                                      SizedBox(height: 4),
                                      Text("Gambar kuis gagal dimuat.", style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 36,
                          child: ElevatedButton.icon(
                            onPressed: () => setState(() {}),
                            icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 16),
                            label: const Text('Refresh Tampilan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(currentQuestion['question'], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), height: 1.3)),
                  const SizedBox(height: 6),
                  Text(currentQuestion['instruction'], style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.2)),
                  const SizedBox(height: 20),

                  ...currentQuestion['options'].entries.map<Widget>((entry) {
                    bool isSelected = currentQuestion['selectedAnswer'] == entry.key;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          activeQuizData[currentQuestionIndex]['selectedAnswer'] = entry.key;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0), 
                            width: isSelected ? 2 : 1
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
                              child: Text(entry.key, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF475569))),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: Text(entry.value, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: const Color(0xFF1E293B)))),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Navigasi Soal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                      Text('$nomorAktif/$totalSoal', style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: totalSoal,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, idx) {
                      bool isCurrent = idx == currentQuestionIndex;
                      bool isAnswered = activeQuizData[idx]['selectedAnswer'] != null;
                      bool isFlagged = activeQuizData[idx]['isFlagged'] ?? false;

                      Color boxColor = Colors.white;
                      Color textColor = const Color(0xFF475569);
                      BoxBorder? finalBorder = Border.all(color: const Color(0xFFE2E8F0));

                      if (isCurrent) {
                        boxColor = const Color(0xFF3B82F6); 
                        textColor = Colors.white;
                        finalBorder = null;
                      } else if (isFlagged) {
                        boxColor = Colors.orange; 
                        textColor = Colors.white;
                        finalBorder = null;
                      } else if (isAnswered) {
                        boxColor = const Color(0xFF10B981);
                        textColor = Colors.white;
                        finalBorder = null;
                      }

                      return InkWell(
                        onTap: () => setState(() => currentQuestionIndex = idx),
                        child: Container(
                          decoration: BoxDecoration(
                            color: boxColor,
                            borderRadius: BorderRadius.circular(8),
                            border: finalBorder,
                          ),
                          child: Center(
                            child: Text(
                              '${idx + 1}',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _LegendItem(color: Color(0xFF10B981), label: 'Selesai'),
                      SizedBox(width: 12),
                      _LegendItem(color: Color(0xFF3B82F6), label: 'Saat ini'),
                      SizedBox(width: 12),
                      _LegendItem(color: Colors.orange, label: 'Ditandai'), 
                      SizedBox(width: 12),
                      _LegendItem(color: Colors.white, label: 'Belum', hasBorder: true),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                if (currentQuestionIndex > 0) ...[
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() => currentQuestionIndex--),
                        icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF1E293B), size: 20),
                        label: const Text('Sebelumnya', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 14)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                
                Expanded(
                  flex: 6,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLastQuestion ? _submitQuizConfirmation : () => setState(() => currentQuestionIndex++),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLastQuestion ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLastQuestion ? 'Kirim Kuis' : 'Selanjutnya',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          if (!isLastQuestion) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool hasBorder;

  const _LegendItem({required this.color, required this.label, this.hasBorder = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: hasBorder ? Border.all(color: const Color(0xFFCBD5E1)) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
      ],
    );
  }
}