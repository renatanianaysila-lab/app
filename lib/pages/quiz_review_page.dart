import 'package:flutter/material.dart';

class QuizReviewPage extends StatelessWidget {
  final List<Map<String, dynamic>> quizData;
  final int score;
  final int benar;
  final int salah;
  final int total;

  const QuizReviewPage({
    super.key,
    required this.quizData,
    required this.score,
    required this.benar,
    required this.salah,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> keys = ['A', 'C', 'C', 'D', 'A', 'B', 'A', 'A', 'A', 'A'];
    bool isPassed = score >= 70;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Lihat Jawaban', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade400, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Icon(isPassed ? Icons.emoji_events_rounded : Icons.warning_amber_rounded, size: 54, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(isPassed ? 'Selamat!' : 'Sayang sekali', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(isPassed ? 'Kamu telah menyelesaikan kuis' : 'Kamu dapat mencoba lagi!', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Text('$score%', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text('Skor Akhir', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Review Jawaban', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: quizData.length,
                    itemBuilder: (context, index) {
                      final item = quizData[index];
                      String? userAns = item['selectedAnswer'];
                      String correctAns = keys[index];
                      bool isCorrect = userAns == correctAns;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Pertanyaan ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(isCorrect ? 'Benar' : 'Salah', style: TextStyle(color: isCorrect ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(item['question'], style: const TextStyle(fontSize: 14, color: Colors.black87)),
                            const SizedBox(height: 12),
                            
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Jawaban Anda: ${userAns ?? "Tidak dijawab"}',
                                style: TextStyle(color: isCorrect ? Colors.green.shade900 : Colors.red.shade900, fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (!isCorrect) ...[
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                                child: Text('Jawaban Benar: $correctAns', style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.w600)),
                              ),
                            ]
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: const Text('Kembali ke Beranda', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}