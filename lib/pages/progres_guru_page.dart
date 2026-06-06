import 'package:flutter/material.dart';

class ProgresGuruPage extends StatefulWidget {
  const ProgresGuruPage({super.key});

  @override
  State<ProgresGuruPage> createState() => _ProgresGuruPageState();
}

class _ProgresGuruPageState extends State<ProgresGuruPage> {
  String selectedKelas = 'Angka 1-10';
  Map<String, bool> expandedStudents = {'Sarah Johnson': true, 'Willian Afton': false};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const Icon(Icons.menu, color: Colors.black87),
        title: const Text(
          "Progres Pembelajaran",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const Text(
              "Kelas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildClassTab("Angka 1-10"),
                const SizedBox(width: 10),
                _buildClassTab("Ekspresi Sehari-hari"),
              ],
            ),
            const SizedBox(height: 24),

            
            Text(
              selectedKelas,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(children: [Icon(Icons.people, color: Colors.black54), SizedBox(width: 6), Text("32 Siswa", style: TextStyle(fontWeight: FontWeight.w600))]),
                  Row(children: [Icon(Icons.videocam, color: Colors.black54), SizedBox(width: 6), Text("2 Video", style: TextStyle(fontWeight: FontWeight.w600))]),
                  Row(children: [Icon(Icons.assignment, color: Colors.black54), SizedBox(width: 6), Text("2 Kuis", style: TextStyle(fontWeight: FontWeight.w600))]),
                ],
              ),
            ),
            const SizedBox(height: 24),

            
            const Text(
              "Progress per Siswa",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "Cari siswa...",
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),

            
            _buildStudentCard(
              name: "Sarah Johnson",
              id: "STD-2024-01",
              kelas: "Kelas 10A",
              videoProgress: "85%",
              quizScore: "92%",
              totalMateriDone: 4,
              totalMateriAll: 5,
              totalKuisDone: 4,
              totalKuisAll: 5,
              showDetails: expandedStudents['Sarah Johnson'] ?? false,
            ),
            const SizedBox(height: 16),
            _buildStudentCard(
              name: "Willian Afton",
              id: "STD-2024-001",
              kelas: "Kelas 10A",
              videoProgress: "85%",
              quizScore: "62%",
              totalMateriDone: 3,
              totalMateriAll: 5,
              totalKuisDone: 2,
              totalKuisAll: 5,
              showDetails: expandedStudents['Willian Afton'] ?? false,
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildClassTab(String title) {
    bool isSelected = selectedKelas == title;
    return InkWell(
      onTap: () => setState(() => selectedKelas = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF9E6) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFFF4C542) : Colors.grey.shade200),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFFD4A373) : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  
  Widget _buildStudentCard({
    required String name,
    required String id,
    required String kelas,
    required String videoProgress,
    required String quizScore,
    required int totalMateriDone,
    required int totalMateriAll,
    required int totalKuisDone,
    required int totalKuisAll,
    required bool showDetails,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFE5E5E5),
                  child: Icon(Icons.person, color: Colors.white, size: 35), 
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("ID: $id", style: const TextStyle(fontSize: 12, color: Colors.black45)),
                      Text(kelas, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFEDF4FF), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Video Progress", style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(videoProgress, style: const TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFE8F8F0), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Quiz Score", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(quizScore, style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          
          InkWell(
            onTap: () {
              setState(() {
                expandedStudents[name] = !showDetails;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text("Lihat Detail", style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                  Icon(showDetails ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.grey.shade600),
                ],
              ),
            ),
          ),

          
          if (showDetails) ...[
            const Divider(height: 1),
            Container(
              color: const Color(0xFFFAFAFA),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Progress", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  _buildLinearProgressRow("Total materi", totalMateriDone, totalMateriAll, Colors.blue),
                  const SizedBox(height: 12),
                  _buildLinearProgressRow("Telah mengerjakan kuis", totalKuisDone, totalKuisAll, Colors.green),
                  
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Video Progress", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("5 videos", style: TextStyle(color: Colors.black45, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  
                  _buildSubItemRow(imagePath: "assets/images/materi_abjad.png", title: "Materi Abjad A-Z", status: "Selesai", percentage: "100%", isDone: true, iconData: Icons.check_circle, iconColor: Colors.green),
                  _buildSubItemRow(imagePath: "assets/images/materi_ekspresi.png", title: "Materi Ekspresi", status: "Dikerjakan", percentage: "60%", isDone: false, iconData: Icons.play_circle_fill, iconColor: Colors.blue),
                  _buildSubItemRow(imagePath: "assets/images/materi_angka.png", title: "Materi Angka", status: "Belum Ditonton", percentage: "0%", isDone: false, iconData: Icons.lock, iconColor: Colors.grey),
                  
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                      ),
                      onPressed: () {},
                      child: const Text("Lihat Semua Video", style: TextStyle(color: Colors.blue)),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Quiz Results", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("12 quizzes", style: TextStyle(color: Colors.black45, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildSubItemRow(imagePath: "assets/images/quiz_abjad.png", title: "Quiz Abjad A-Z", status: "Selesai 2 hari yang lalu", percentage: "95%", scoreText: "19/20", isDone: true, iconData: Icons.emoji_events, iconColor: Colors.green, customBgColor: const Color(0xFFE8F8F0)),
                  _buildSubItemRow(imagePath: "assets/images/quiz_ekspresi.png", title: "Quiz Ekspresi", status: "Dikerjakan 5 hari yang lalu", percentage: "88%", scoreText: "22/25", isDone: false, iconData: Icons.star, iconColor: Colors.blue, customBgColor: const Color(0xFFEDF4FF)),
                  _buildSubItemRow(imagePath: "assets/images/quiz_angka.png", title: "Quiz Angka", status: "Belum Dikerjakan", percentage: "0%", isDone: false, iconData: Icons.lock, iconColor: Colors.grey),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }

  
  Widget _buildLinearProgressRow(String label, int done, int total, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
            Text("$done/$total", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: done / total,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  
  Widget _buildSubItemRow({
    required String imagePath,
    required String title,
    required String status,
    required String percentage,
    String? scoreText,
    required bool isDone,
    required IconData iconData,
    required Color iconColor,
    Color? customBgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: customBgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(status, style: const TextStyle(color: Colors.black38, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(percentage, style: TextStyle(color: iconColor, fontWeight: FontWeight.bold, fontSize: 13)),
              if (scoreText != null)
                Text(scoreText, style: const TextStyle(color: Colors.black45, fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }
}