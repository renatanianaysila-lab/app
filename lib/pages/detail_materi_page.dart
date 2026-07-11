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
      'duration': '5:40 menit',
      'status': 'active',
    },
    {
      'id': 'quiz_2',
      'type': 'Quiz',
      'title': 'Kuis 2: Praktik Gerakan',
      'duration': '5 Soal kuis',
      'status': 'locked',
    },
    {
      'id': 'vid_3',
      'type': 'Video',
      'title': 'Studi Kasus & Dialog',
      'duration': '4:15 menit',
      'status': 'locked',
    },
  ];

  // 📡 FUNGSI API FETCH KOMENTAR
  Future<void> _fetchCommentsForVideo(String videoId) async {
    if (_globalCommentDatabase.containsKey(videoId)) return;

    setState(() => _isLoadingComments = true);
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.9:8000/api/comments?video_id=$videoId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final List<dynamic> listData = decoded['data'];
          setState(() {
            _globalCommentDatabase[videoId] = listData.map((c) => {
              'username': c['username'] ?? '@user',
              'content': c['content'] ?? '',
            }).toList();
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetch comments: $e');
    } finally {
      setState(() => _isLoadingComments = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.materiTitle,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Poppins'),
        ),
        centerTitle: true,
      ),
      body: _isLoadingComments
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFB800)))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: journeyItems.length,
              itemBuilder: (context, index) {
                final item = journeyItems[index];
                bool isLast = index == journeyItems.length - 1;
                return _buildJourneyStep(item, isLast);
              },
            ),
    );
  }

  Widget _buildJourneyStep(Map<String, dynamic> item, bool isLast) {
    bool isActive = item['status'] == 'active';
    bool isDone = item['status'] == 'done';
    bool isLocked = item['status'] == 'locked';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _buildStatusIndicator(item),
            if (!isLast)
              Container(
                width: 2,
                height: 55,
                color: isDone ? widget.themeColor : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Opacity(
            opacity: isLocked ? 0.55 : 1.0,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isActive ? widget.themeColor.withOpacity(0.5) : Colors.grey.shade100,
                  width: isActive ? 1.5 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isActive ? widget.themeColor.withOpacity(0.06) : Colors.black.withOpacity(0.01),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: item['type'] == 'Video' ? const Color(0xFFFFF3E0) : const Color(0xFFE8EAF6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['type'].toString().toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: item['type'] == 'Video' ? Colors.orange.shade800 : Colors.indigo.shade800,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item['duration'],
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87, fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
                  if (!isLocked)
                    Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(Map<String, dynamic> item) {
    final String videoIdKey = item['id'] ?? 'vid_default';

    VoidCallback? handleTapAction;
    if (item['status'] != 'locked') {
      handleTapAction = () async {
        if (item['type'] == 'Quiz') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPlayPage(quizTitle: item['title']),
            ),
          );
        } else {
          await _fetchCommentsForVideo(videoIdKey);
          if (!mounted) return;

          List<Map<String, dynamic>> currentComments = _globalCommentDatabase[videoIdKey] ?? [];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayPage(
                videoId: 'iLnmTe5Q2Qw', 
                videoTitle: item['title'] ?? 'Materi Video',
                videoDescription: 'Tonton video instruksi materi ini sampai selesai untuk membuka kuis berikutnya.',
                
                // ── 🌟 ARGUMEN WAJIB DI SINI ──
                modulName: widget.materiTitle, 
                objectives: List<String>.from([
                  'Memahami poin dasar pengenalan isyarat visual materi.',
                  'Mampu menerapkan gerakan isyarat mandiri secara baik.'
                ]),
                
                commentsReference: currentComments,
                onCommentUpdated: () {
                  setState(() {
                    _globalCommentDatabase[videoIdKey] = currentComments;
                  });
                },
                isTeacher: false,
              ),
            ),
          );
        }
      };
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
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: widget.themeColor, width: 2),
        ),
        child: Center(
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: widget.themeColor, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
