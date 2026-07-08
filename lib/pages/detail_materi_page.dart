import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'video_play_page.dart';
import 'quiz_play_page.dart'; 

class DetailMateriPage extends StatefulWidget {
  final String materiTitle;
  final Color themeColor;
  final Color bgColor;

  const DetailMateriPage({
    super.key,
    required this.materiTitle,
    required this.themeColor,
    required this.bgColor,
  });

  @override
  State<DetailMateriPage> createState() => _DetailMateriPageState();
}

class _DetailMateriPageState extends State<DetailMateriPage> {
  // Database lokal penampung komentar dinamis hasil fetch API
  final Map<String, List<Map<String, dynamic>>> _globalCommentDatabase = {};
  bool _isLoadingComments = false;

  final List<Map<String, dynamic>> journeyItems = [
    {
      'id': 'vid_1',
      'type': 'Video',
      'title': 'Pengenalan',
      'duration': '3:25 menit',
      'status': 'done',
    },
    {
      'id': 'quiz_1',
      'type': 'Quiz',
      'title': 'Kuis 1: Pemahaman Teori',
      'duration': '10/10 PASSED',
      'status': 'done',
    },
    {
      'id': 'vid_2',
      'type': 'Video',
      'title': 'Gerakan Isyarat Utama',
      'duration': '4:25 menit',
      'status': 'done',
    },
    {
      'id': 'quiz_2',
      'type': 'Quiz',
      'title': 'Kuis 2: Evaluasi Kecepatan',
      'duration': '4/10 FAILED (Coba Lagi)', 
      'status': 'failed',
    },
    {
      'id': 'vid_3',
      'type': 'Video',
      'title': 'Variasi dan Aturan Posisi',
      'duration': '5:12 menit',
      'status': 'active',
    },
    {
      'id': 'vid_4',
      'type': 'Video',
      'title': 'Praktik Kalimat Sederhana',
      'duration': '7:25 menit',
      'status': 'locked',
    },
  ];

  // ─── FUNGSI AMBIL DATA DISKUSI DARI DATABASE MYSQL (GET API) ───────
  Future<void> fetchCommentsFromDatabase(String videoId) async {
    setState(() => _isLoadingComments = true);
    
    try {
      // Menembak API Laravel untuk mengambil daftar komentar diskusi sesuai ID Video
      final response = await http.get(
        Uri.parse('https://isyaratkita.alwaysdata.net/api/videos/$videoId/comments'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataFromServer = jsonDecode(response.body);
        
        setState(() {
          _globalCommentDatabase[videoId] = dataFromServer.map((item) {
            return {
              'username': item['username'] ?? '@anonim',
              'content': item['content'] ?? '',
              'likeCount': item['likes_count'] ?? 0,
              'isLiked': false,
              'replies': <Map<String, dynamic>>[],
            };
          }).toList();
        });
      } else {
        throw Exception();
      }
    } catch (e) {
      // Jika koneksi Laravel mati/gagal, kita gunakan data fallback cadangan agar aplikasi tidak crash
      _globalCommentDatabase.putIfAbsent(videoId, () => [
        {
          'username': 'Naysila Renatania',
          'content': 'Penjelasannya gampang dimengerti kak! Gerakan tangannya jelas bgt.',
          'likeCount': 12,
          'isLiked': false,
          'replies': <Map<String, dynamic>>[],
        },
        {
          'username': 'Aurel Zalsabilla',
          'content': 'Keren bgt transisinya, ngebantu buat dicoba bareng temen kelompok.',
          'likeCount': 8,
          'isLiked': false,
          'replies': <Map<String, dynamic>>[],
        },
      ]);
    } finally {
      setState(() => _isLoadingComments = false);
    }
  }

  void navigateToVideo(Map<String, dynamic> item, String fullTitle) async {
    final String videoId = item['id'].toString();
    
    // Ambil data diskusi asli dari MySQL terlebih dahulu sebelum membuka halaman video
    await fetchCommentsFromDatabase(videoId);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayPage(
          videoId: videoId,
          videoTitle: fullTitle,
          commentsReference: _globalCommentDatabase[videoId]!,
          onCommentUpdated: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  void navigateToQuiz(String fullTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPlayPage(
          quizTitle: fullTitle, 
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color darkerOmbreColor = Color.alphaBlend(
      Colors.black.withOpacity(0.25),
      widget.themeColor,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoadingComments 
      ? const Center(child: CircularProgressIndicator()) // Efek loading sinkronisasi database
      : CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              elevation: 0,
              backgroundColor: widget.themeColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [widget.themeColor, darkerOmbreColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                        child: const Text('IsyaratKita Academy', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.materiTitle, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      const Text('Unit Pembelajaran Active', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Progress Belajar', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          Text(widget.materiTitle == 'Ekspresi Dasar' ? '100% Selesai' : '50% Selesai', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: widget.materiTitle == 'Ekspresi Dasar' ? 1.0 : 0.5,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Text('Milestone Pembelajaran', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: journeyItems.length,
                      itemBuilder: (context, index) {
                        final item = journeyItems[index];
                        int nomorUrut = index + 1;
                        String fullTitle = "${item['title']} ${widget.materiTitle}";

                        Color durationColor = Colors.black45;
                        if (item['status'] == 'failed') {
                          durationColor = const Color(0xFFE53935);
                        } else if (item['status'] == 'done' && item['type'] == 'Quiz') {
                          durationColor = const Color(0xFF4CAF50);
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 30,
                                child: Text('$nomorUrut', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: item['status'] == 'locked' ? Colors.black12 : Colors.black26)),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fullTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: item['status'] == 'locked' ? Colors.black38 : Colors.black87),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('${item['type']}  •  ${item['duration']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: durationColor)),
                                    const SizedBox(height: 12),
                                    Container(height: 1, color: Colors.grey.shade100),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              _buildActionIcon(context, item, fullTitle, widget.themeColor, widget.bgColor),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildActionIcon(BuildContext context, Map<String, dynamic> item, String fullTitle, Color activeColor, Color softBgColor) {
    void handleTapAction() {
      if (item['type'] == 'Quiz') {
        navigateToQuiz(fullTitle);
      } else {
        navigateToVideo(item, fullTitle);
      }
    }

    if (item['status'] == 'done') {
      return GestureDetector(
        onTap: handleTapAction,
        child: Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
          child: const Center(child: Icon(Icons.check_rounded, color: Color(0xFF4CAF50), size: 18)),
        ),
      );
    }

    if (item['status'] == 'failed') {
      return GestureDetector(
        onTap: handleTapAction,
        child: Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(color: Color(0xFFFFEBEE), shape: BoxShape.circle),
          child: const Center(child: Icon(Icons.close_rounded, color: Color(0xFFE53935), size: 18)),
        ),
      );
    }

    if (item['status'] == 'locked') {
      return Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle),
        child: Center(child: Icon(Icons.lock_outline_rounded, color: Colors.grey.shade300, size: 16)),
      );
    }

    return GestureDetector(
      onTap: handleTapAction,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: softBgColor, shape: BoxShape.circle),
        child: Center(
          child: Icon(item['type'] == 'Quiz' ? Icons.star_rounded : Icons.play_arrow_rounded, color: activeColor, size: 18),
        ),
      ),
    );
  }
}
