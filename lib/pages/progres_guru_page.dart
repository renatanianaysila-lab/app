import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProgresGuruPage extends StatefulWidget {
  const ProgresGuruPage({super.key});

  @override
  State<ProgresGuruPage> createState() => _ProgresGuruPageState();
}

class _ProgresGuruPageState extends State<ProgresGuruPage> {
  String selectedKelas = 'Mudah';
  
  // ── 1. VARIABEL BARU UNTUK MENAMPUNG DATA DATABASE ──
  List<dynamic> studentsData = [];
  bool isLoading = true;
  Map<String, bool> expandedStudents = {};

  @override
  void initState() {
    super.initState();
    _fetchProgresSiswa(); // Jalankan penarikan data pas halaman dibuka
  }

  // ── 2. FUNGSI UNTUK MENGAMBIL DATA DARI LARAVEL ──
  Future<void> _fetchProgresSiswa() async {
    setState(() => isLoading = true);
    try {
      // Sesuaikan IP dengan Wi-Fi laptopmu ya!
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/guru/progres?kelas=$selectedKelas'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          studentsData = jsonResponse['data'];
          
          // Set default expand untuk murid pertama agar terbuka otomatis jika ada data
          expandedStudents.clear();
          if (studentsData.isNotEmpty) {
            expandedStudents[studentsData[0]['nama']] = true;
          }
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetch progres: $e");
      setState(() => isLoading = false);
    }
  }

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
      body: isLoading 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFB703)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kelas",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  
                  // Dropdown Kelas Tetap Milikmu, Ditambahkan Fungsi Pemicu API Pas Diubah
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                      value: selectedKelas,
                      isExpanded: true,
                      // Diubah sesuai kategori asli di file materis.sql kamu! 🎯
                      items: <String>['Mudah', 'Sedang', 'Susah'] 
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(fontSize: 13)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedKelas = newValue;
                          });
                          _fetchProgresSiswa(); // Panggil fungsi API otomatis pas diganti kategori kelasnya
                        }
                      },
                    ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  const Text(
                    "Daftar Siswa",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),

                  // ── 3. LOOPING DYNAMIC DATA DARI DATABASE SINKRON DENGAN CARD DESAINMU ──
                  studentsData.isEmpty
                      ? const Center(child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text("Belum ada siswa di kelas ini.", style: TextStyle(color: Colors.grey)),
                        ))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: studentsData.length,
                          itemBuilder: (context, index) {
                            final student = studentsData[index];
                            final String studentName = student['nama'];
                            final String overallProgress = student['overall_progress'];
                            final List<dynamic> details = student['details'];
                            final bool isExpanded = expandedStudents[studentName] ?? false;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    leading: const CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Color(0xFFF3F4F6),
                                      child: Icon(Icons.person, color: Color(0xFF9CA3AF)),
                                    ),
                                    title: Text(
                                      studentName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        children: [
                                          const Text("Progres: ", style: TextStyle(fontSize: 12, color: Colors.black45)),
                                          Text(
                                            overallProgress,
                                            style: const TextStyle(fontSize: 12, color: Color(0xFFFFB703), fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: Icon(
                                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                      color: Colors.black54,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        expandedStudents[studentName] = !isExpanded;
                                      });
                                    },
                                  ),
                                  if (isExpanded)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                      child: Column(
                                        children: [
                                          const Divider(height: 1),
                                          const SizedBox(height: 12),
                                          
                                          // Looping item detail (Nonton Video / Kuis) sesuai database
                                          _buildProgressItem(
                                            title: details[0]['title'],
                                            status: details[0]['status'],
                                            percentage: details[0]['percentage'],
                                            iconData: Icons.play_circle_fill,
                                            iconColor: const Color(0xFFFFB703),
                                            customBgColor: const Color(0xFFFFFBEB),
                                          ),
                                          _buildProgressItem(
                                            title: details[1]['title'],
                                            status: details[1]['status'],
                                            percentage: details[1]['percentage'],
                                            scoreText: details[1]['score'],
                                            iconData: Icons.assignment_turned_in,
                                            iconColor: const Color(0xFF10B981),
                                            customBgColor: const Color(0xFFECFDF5),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }

  // Widget _buildProgressItem Tetap Menggunakan Desain Cantik Aslimu 100%
  Widget _buildProgressItem({
    required String title,
    required String status,
    required String percentage,
    required IconData iconData,
    required Color iconColor,
    Color? customBgColor,
    String? scoreText,
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
          ),
        ],
      ),
    );
  }
}