// File: lib/pages/detail_aktivitas_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Pustaka 13.4 Nay
import 'dart:convert'; // Parsing JSON 13.3 Nay

class DetailAktivitasPage extends StatefulWidget {
  final int aktivitasId; // Menangkap ID dari halaman Beranda

  const DetailAktivitasPage({super.key, required this.aktivitasId});

  @override
  State<DetailAktivitasPage> createState() => _DetailAktivitasPageState();
}

class _DetailAktivitasPageState extends State<DetailAktivitasPage> {
  Map<String, dynamic>? dataDetail;
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchDetailData();
  }

  // Fungsi HTTP GET untuk mengambil detail data (Materi 13.4 & 13.6)
  Future<void> fetchDetailData() async {
    // Sesuaikan IP ini dengan IP laptopmu/XAMPP saat running lokal
    final url = Uri.parse('http://10.0.2.2:8000/api/materi/${widget.aktivitasId}');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responJson = jsonDecode(response.body); // Deserialization JSON
        setState(() {
          dataDetail = responJson['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Gagal memuat data. Code: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Koneksi ke backend Laravel gagal: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Ringkasan Aktivitas", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading State
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: [
                      // 1. HEADER DETAIL
                      Text(
                        dataDetail?['title'] ?? "Nama Materi",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1C24)),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Diunggah oleh: ${dataDetail?['email_guru']}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const Divider(height: 30),

                      // 2. BOX MEDIA PREVIEW (Format Video / Gambar)
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_circle_fill, size: 50, color: Colors.blue),
                              SizedBox(height: 10),
                              Text("Preview Media Pembelajaran (.mp4/.png)"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // 3. FORM / DESKRIPSI FORMAT YANG DIUPLOAD GURU
                      const Text(
                        "Deskripsi / Catatan Guru:",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dataDetail?['deskripsi'] ?? "Tidak ada deskripsi materi.",
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),
                      const SizedBox(height: 25),

                      // 4. INFORMASI LAMPIRAN BERKAS
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.file_present, color: Colors.orange, size: 30),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Format Lampiran Terdeteksi", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("Ukuran File: ${dataDetail?['ukuran_file'] ?? '0 MB'}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}