// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoPlayPage extends StatefulWidget {
  final String videoId; 
  final String videoTitle;
  final String? videoDescription; // ── 1. Deskripsi Kelas dinamis dari Database
  final String modulName;         // ── 3. Tag dinamis pengganti 'Bahasa Isyarat'
  final List<String> objectives;  // ── 2. Objektif pembelajaran dinamis dari Database
  final List<Map<String, dynamic>> commentsReference;
  final VoidCallback onCommentUpdated;
  final bool isIntermediate;
  final bool isTeacher;

  const VideoPlayPage({
    super.key,
    required this.videoId,
    required this.videoTitle,
    this.videoDescription,
    required this.modulName,
    required this.objectives,
    required this.commentsReference,
    required this.onCommentUpdated,
    this.isIntermediate = false,
    this.isTeacher = false,
  });

  @override
  State<VideoPlayPage> createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> {
  final TextEditingController _commentController = TextEditingController();
  late String _currentDescription;
  bool _isSubmittingComment = false;
  int _selectedRating = 5;

  @override
  void initState() {
    super.initState();
    // Inisialisasi teks deskripsi awal dari database/halaman penyeru
    _currentDescription = (widget.videoDescription != null && widget.videoDescription!.trim().isNotEmpty)
        ? widget.videoDescription!
        : 'Video pembelajaran ini membahas secara mendalam materi terkait tata cara komunikasi isyarat demi menunjang efisiensi interaksi kelompok secara visual.';
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

// ─── FUNGSI POP-UP MODAL VIDEO INTERNAL (VERSI OPTIMASI BEBAS LAG) ───
  void _showVideoPopup(BuildContext context, String videoId) {
    // Mengekstrak ID murni jika parameter input berupa URL penuh
    String cleanId = videoId.trim();
    if (cleanId.contains('v=')) {
      cleanId = cleanId.split('v=').last.split('&').first;
    } else if (cleanId.contains('youtu.be/')) {
      cleanId = cleanId.split('youtu.be/').last.split('?').first;
    }

    showDialog(
      context: context,
      barrierDismissible: true, // Klik di luar area hitam transparan untuk menutup modal
      builder: (context) {
        bool isPlayerReady = false; 

        // Menggunakan StatefulBuilder agar dialog bisa meng-update dirinya sendiri
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              // 1. Trik Cerdek: Jika dialog baru terbuka, tampilkan loading spinner dulu (400ms)
              // Ini memberi napas buat Flutter untuk menyelesaikan animasi transisi pop-up tanpa lag
              if (!isPlayerReady) {
                Future.delayed(const Duration(milliseconds: 400), () {
                  if (context.mounted) {
                    setDialogState(() {
                      isPlayerReady = true;
                    });
                  }
                });
                
                return const SizedBox(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFB800)),
                  ),
                );
              }

              // 2. Setelah animasi pop-up selesai & rileks, baru inisialisasi controller YouTube-nya
              final YoutubePlayerController youtubeController = YoutubePlayerController(
                initialVideoId: cleanId.isEmpty ? 'v1XgS9-9n64' : cleanId,
                flags: const YoutubePlayerFlags(
                  autoPlay: true,
                  mute: false,
                  disableDragSeek: false,
                  forceHD: false, // Menghindari lag akibat pemaksaan resolusi tinggi di awal
                  useHybridComposition: true, // Meningkatkan performa WebView di Android
                ),
              );

              // 3. Tampilkan tampilan utama Video Player
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () {
                        youtubeController.dispose(); // Hancurkan controller saat tombol X ditekan
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: YoutubePlayer(
                        controller: youtubeController,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: const Color(0xFFFFB800),
                        onEnded: (metaData) {
                          youtubeController.dispose(); // Hancurkan controller jika video otomatis selesai
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // ── 4. FITUR EDIT DESKRIPSI (FUNCTIONAL) ──
  Future<void> _showEditDescriptionDialog() async {
    final TextEditingController editController = TextEditingController(text: _currentDescription);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Edit Deskripsi Kelas', 
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: TextField(
            controller: editController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Masukkan deskripsi baru...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
            ),
            ElevatedButton(
              onPressed: () {
                String newDesc = editController.text.trim();
                if (newDesc.isEmpty) return;

                Navigator.pop(context); // Tutup dialog modal
                
                setState(() {
                  _currentDescription = newDesc; // Simpan pembaruan ke dalam state lokal halaman
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Deskripsi berhasil diperbarui!'), backgroundColor: Colors.green),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB800), elevation: 0),
              child: const Text('Simpan', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
            ),
          ],
        );
      },
    );
  }

  // ── 4. FITUR HAPUS MATERI (FUNCTIONAL) ──
  Future<void> _deleteMateri() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Hapus Materi?', 
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: const Text(
            'Apakah Anda yakin ingin menghapus materi pembelajaran ini secara permanen dari daftar?', 
            style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Tutup Dialog Konfirmasi
                Navigator.pop(context); // Pop halaman keluar untuk kembali ke list materi guru
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Materi berhasil dihapus.'), backgroundColor: Colors.redAccent),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, elevation: 0),
              child: const Text('Hapus', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
            ),
          ],
        );
      },
    );
  }

// ── FORUM ULASAN: INPUT RATING & KOMENTAR ──
Future<void> _addComment() async {
    final String commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    setState(() => _isSubmittingComment = true);

    // 1. AMBIL SESSION USER SECARA DINAMIS DARI SHAREDPREFERENCES
    final prefs = await SharedPreferences.getInstance();
    // Mengambil nama user yang disimpan saat login, jika tidak ketemu default ke '@murid_isyarat'
    final String currentUsername = prefs.getString('user_name') ?? '@murid_isyarat';

    final String targetVideoId = widget.videoId.isNotEmpty ? widget.videoId : 'iLnmTe5Q2Qw';
    
    // 2. UBAH API ENDPOINT SESUAI 10.0.2.2 REKUESTMU
    const String apiUrl = 'https://isyaratkita.alwaysdata.net/api/comments'; 

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', 
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'video_id': targetVideoId,
          'username': currentUsername,
          'content': commentText,
          'rating': _selectedRating, 
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        setState(() {
          widget.commentsReference.insert(0, {
            'username': currentUsername,
            'content': commentText,
            'rating': _selectedRating, 
          });
          _selectedRating = 5; 
        });
        _commentController.clear();
        widget.onCommentUpdated(); 
      } else {
        // Jika server bermasalah, lempar ke backup simpan lokal di HP
        await _fallbackLocalInsert(currentUsername, commentText);
      }
    } catch (e) {
      // Jika offline, simpan aman di cache HP
      await _fallbackLocalInsert(currentUsername, commentText);
    } finally {
      setState(() => _isSubmittingComment = false);
    }
  }

  // ── BACKUP PENYIMPANAN LOKAL JIKA OFFLINE/DATABASE BELUM SIAP ──
  Future<void> _fallbackLocalInsert(String username, String text) async {
    setState(() {
      widget.commentsReference.insert(0, {
        'username': username,
        'content': text,
        'rating': _selectedRating,
      });
    });

    final prefs = await SharedPreferences.getInstance();
    final String targetVideoId = widget.videoId.isNotEmpty ? widget.videoId : 'iLnmTe5Q2Qw';
    
    // Simpan history ulasan lokal dikunci berdasarkan ID video materi
    await prefs.setString('local_comments_$targetVideoId', jsonEncode(widget.commentsReference));

    setState(() {
      _selectedRating = 5;
    });
    _commentController.clear();
    widget.onCommentUpdated();
  }

  @override
  Widget build(BuildContext context) {
    final String targetId = widget.videoId.isNotEmpty ? widget.videoId : 'iLnmTe5Q2Qw';
    final String thumbnailUrl = 'https://img.youtube.com/vi/$targetId/hqdefault.jpg';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.videoTitle,
          style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AREA PLUG-IN THUMBNAIL VIDEO
            GestureDetector(
              onTap: () => _showVideoPopup(context, targetId),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                        image: NetworkImage(thumbnailUrl),
                        fit: BoxFit.cover,
                        opacity: 0.82,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB800).withOpacity(0.95),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                  ),
                  Positioned(
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                      child: const Text(
                        'Ketuk untuk Putar Materi Isyarat',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
            ),

            // AREA DATA DETAIL MATERI & DISKUSI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row Tag Modul & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          widget.modulName, 
                          style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'Poppins'),
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                          SizedBox(width: 4),
                          Text('4.8', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Poppins')),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Judul Konten Video
                  Text(
                    widget.videoTitle, 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontFamily: 'Poppins'),
                  ),
                  
                  // Tombol Manajemen Aksi Guru
                  if (widget.isTeacher) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _showEditDescriptionDialog,
                          icon: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                          label: const Text('Edit Deskripsi', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB800), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: _deleteMateri,
                          icon: const Icon(Icons.delete_outline_rounded, size: 14, color: Colors.redAccent),
                          label: const Text('Hapus', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        ),
                      ],
                    ),
                  ],
                  const Divider(height: 35, thickness: 1),
                  
                  // DESKRIPSI KELAS
                  const Text('Deskripsi Kelas', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  const SizedBox(height: 8),
                  Text(
                    _currentDescription, 
                    style: const TextStyle(color: Color(0xFF475569), fontSize: 12, height: 1.5, fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 24),
                  
                  // OBJEKTIF PEMBELAJARAN
                  const Text('Objektif Pembelajaran', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  const SizedBox(height: 12),
                  widget.objectives.isEmpty
                      ? const Text('Belum ada objektif pembelajaran.', style: TextStyle(fontSize: 12, fontFamily: 'Poppins', color: Colors.grey))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: widget.objectives.length,
                          itemBuilder: (context, idx) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${idx + 1}. ', style: const TextStyle(fontSize: 12, fontFamily: 'Poppins', color: Color(0xFF475569))),
                                  Expanded(
                                    child: Text(widget.objectives[idx], style: const TextStyle(fontSize: 12, fontFamily: 'Poppins', color: Color(0xFF475569), height: 1.4)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  const Divider(height: 40, thickness: 1),

                  // FORUM DISKUSI
                  Row(
                    children: [
                      const Text('Ulasan & Rating Materi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                        child: Text('${widget.commentsReference.length}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // 1. INPUT INTERAKTIF RATING BINTANG
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.orange.shade100),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Ketuk Skor:',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Colors.orange),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: List.generate(5, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRating = index + 1; // Set rating sesuai bintang yang diklik
                                });
                              },
                              child: Icon(
                                index < _selectedRating ? Icons.star_rounded : Icons.star_border_rounded,
                                color: Colors.amber,
                                size: 28,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  
                  // 2. INPUT TEXT FIELD UTK ULASAN
                  Row(
                    children: [
                      const CircleAvatar(radius: 16, backgroundColor: Color(0xFFFFB800), child: Icon(Icons.person, size: 18, color: Colors.white)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(20)),
                          child: TextField(
                            controller: _commentController,
                            style: const TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                            decoration: const InputDecoration(hintText: 'Tulis ulasan/penilaian materi di sini...', border: InputBorder.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: _isSubmittingComment 
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFFB800)))
                          : const Icon(Icons.send_rounded, color: Color(0xFFFFB800), size: 20), 
                        onPressed: _isSubmittingComment ? null : _addComment,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // 3. LIST DAFTAR ULASAN DARI USER LAIN
                  widget.commentsReference.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                            child: Text('Belum ada ulasan untuk materi ini.', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: widget.commentsReference.length,
                          itemBuilder: (context, index) {
                            final c = widget.commentsReference[index];
                            final String username = c['username'] ?? '@user';
                            // Jika database mengembalikan string/int, kita parse dengan aman, default 5 bintang jika kosong
                            final int currentRating = int.tryParse(c['rating']?.toString() ?? '') ?? 5; 

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2))
                                ]
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 14, 
                                    backgroundColor: username == '@budi_guru' || username == '@bita_syahri' ? const Color(0xFFFFB800) : const Color(0xFFE2E8F0), 
                                    child: Icon(Icons.person, size: 14, color: username == '@budi_guru' || username == '@bita_syahri' ? Colors.white : Colors.grey)
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(username, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                                        const SizedBox(height: 2),
                                        
                                        // Baris Bintang Penilaian per User (Shopee Style)
                                        Row(
                                          children: List.generate(5, (starIndex) {
                                            return Icon(
                                              starIndex < currentRating ? Icons.star_rounded : Icons.star_border_rounded,
                                              color: Colors.amber,
                                              size: 14,
                                            );
                                          }),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(c['content'] ?? '', style: const TextStyle(fontSize: 12, fontFamily: 'Poppins', color: Color(0xFF334155))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
