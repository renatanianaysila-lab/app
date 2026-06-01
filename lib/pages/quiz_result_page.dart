import 'package:flutter/material.dart';
import 'quiz_review_page.dart'; 

class QuizScorePage extends StatelessWidget {
  final List<Map<String, dynamic>> quizData;
  final String quizTitle;

  const QuizScorePage({super.key, required this.quizData, required this.quizTitle});

  int _getCorrectCount() {
    final List<String> keys = ['A', 'C', 'C', 'D', 'A', 'B', 'A', 'A', 'A', 'A']; 
    int count = 0;
    for (int i = 0; i < quizData.length; i++) {
      if (quizData[i]['selectedAnswer'] == keys[i]) count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    int total = quizData.length;
    int benar = _getCorrectCount();
    int salah = total - benar;
    int score = ((benar / total) * 100).toInt();
    bool isPassed = score >= 70; 

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Hasil Kuis', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isPassed ? [Colors.teal.shade300, Colors.blue.shade500] : [Colors.amber.shade300, Colors.blue.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(isPassed ? Icons.emoji_events_rounded : Icons.warning_amber_rounded, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              isPassed ? 'Selamat!' : 'Sayang sekali',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            Text(
              isPassed ? 'Kamu berhasil menyelesaikan kuis dengan baik' : 'Nilai Anda belum mencapai standar',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)],
              ),
              child: Column(
                children: [
                  Text('$score%', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                  const Text('Skor kamu!', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: benar / total,
                    backgroundColor: const Color(0xFFE2E8F0),
                    color: const Color(0xFF2563EB),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('$benar', 'Benar', Colors.green),
                      _buildStatItem('$salah', 'Salah', Colors.red),
                      _buildStatItem('$total', 'Total', Colors.black87),
                    ],
                  )
                ],
              ),
            ),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizReviewPage(quizData: quizData, score: score, benar: benar, salah: salah, total: total),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Lihat Jawaban', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(backgroundColor: const Color(0xFFF1F5F9), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Bagikan Hasil', style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String val, String label, Color color) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}