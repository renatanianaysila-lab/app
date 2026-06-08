import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayPage extends StatefulWidget {
  final String videoId;
  final String videoTitle;
  final List<Map<String, dynamic>> commentsReference;
  final VoidCallback onCommentUpdated;
  final bool isIntermediate;
  final bool isTeacher;

  const VideoPlayPage({
    super.key,
    required this.videoId,
    required this.videoTitle,
    required this.commentsReference,
    required this.onCommentUpdated,
    this.isIntermediate = false,
    this.isTeacher = false,
  });

  @override
  State<VideoPlayPage> createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> with SingleTickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  
  // Controller Utama Pemutar YouTube
  YoutubePlayerController? _youtubeController;
  bool _isLoadingVideo = true;
  String? _fetchedYoutubeUrl;

  late TextEditingController _titleEditController;
  final TextEditingController _descEditController = TextEditingController(
    text: 'Video pembelajaran ini membahas secara mendalam materi terkait tata cara komunikasi isyarat demi menunjang efisiensi interaksi kelompok secara visual.',
  );

  late TabController _tabController;
  late List<Map<String, dynamic>> _curriculumData;

  @override
  void initState() {
    super.initState();
    _titleEditController = TextEditingController(text: widget.videoTitle);
    _tabController = TabController(length: 2, vsync: this);

    _curriculumData = [
      {'part': 'Part 1', 'title': 'Materi Pendahuluan Utama', 'duration': '03:25', 'isUnlocked': true},
      {'part': 'Part 2', 'title': 'Aturan Posisi Isyarat Dasar', 'duration': '05:12', 'isUnlocked': !widget.isIntermediate},
    ];

    // Ambil link video asli dari backend Laravel buatan Naysila
    _fetchVideoFromLaravel();
  }

  // ─── FUNGSI AMBIL DATA DARI BACKEND LARAVEL KAMU ───────────────────────
  Future<void> _fetchVideoFromLaravel() async {
    try {
      // Menembak endpoint Laravel buatanmu (10.0.2.2 untuk emulator)
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/materis/${widget.videoId}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String youtubeUrl = data['youtube_url']; // Mengambil link YouTube dari database

        // Ubah link YouTube menjadi Video ID (ex: "https://youtu.be/xyz" -> "xyz")
        String? extractedId = YoutubePlayer.convertUrlToId(youtubeUrl);

        if (extractedId != null) {
          setState(() {
            _fetchedYoutubeUrl = youtubeUrl;
            _youtubeController = YoutubePlayerController(
              initialVideoId: extractedId,
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
                disableDragSeek: false,
              ),
            );
            _isLoadingVideo = false;
          });
        }
      } else {
        // Jika data di database kamu belum diinput, gunakan fallback video contoh ini agar tidak error
        _setupFallbackVideo();
      }
    } catch (e) {
      // Jika koneksi ke Laravel mati, gunakan fallback agar aplikasi tetap bisa didemokan
      _setupFallbackVideo();
    }
  }

  void _setupFallbackVideo() {
    setState(() {
      _youtubeController = YoutubePlayerController(
        initialVideoId: 'iLnmTe5Q2Qw', // Contoh video YouTube seputar Isyarat
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
      _isLoadingVideo = false;
    });
  }

  @override
  void deactivate() {
    // Memastikan video berhenti jika berpindah halaman
    _youtubeController?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _titleEditController.dispose();
    _descEditController.dispose();
    _tabController.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    final String commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/comments'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'video_id': widget.videoId,
          'username': 'Naysila Renatania',
          'content': commentText,
        }),
      );

      Navigator.pop(context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        setState(() {
          widget.commentsReference.insert(0, {
            'username': 'Naysila Renatania',
            'content': commentText,
            'likeCount': 0,
            'isLiked': false,
            'replies': <Map<String, dynamic>>[],
          });
        });
        _commentController.clear();
        widget.onCommentUpdated();
      }
    } catch (e) {
      Navigator.pop(context);
      // Fallback lokal jika backend dimatikan saat testing
      setState(() {
        widget.commentsReference.insert(0, {
          'username': 'Naysila (Lokal Mode)',
          'content': commentText,
          'likeCount': 0,
          'isLiked': false,
          'replies': <Map<String, dynamic>>[],
        });
      });
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ── BAGIAN UTAMA: PEMUTAR YOUTUBE DINAMIS ─────────────────────────
          Container(
            width: double.infinity,
            height: 240,
            color: Colors.black,
            child: _isLoadingVideo
                ? const Center(child: CircularProgressIndicator(color: Colors.blue))
                : YoutubePlayer(
                    controller: _youtubeController!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.blue,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.blue,
                      handleColor: Colors.blueAccent,
                    ),
                  ),
          ),

          // ── TAB BAR ──────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF2563EB),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF2563EB),
              indicatorWeight: 3,
              tabs: [
                const Tab(text: "Detail Materi"),
                Tab(text: "Diskusi (${widget.commentsReference.length})"),
              ],
            ),
          ),

          // ── ISI VIEW TAB ─────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDetailTab(),
                _buildDiscussionTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(6)),
                child: const Text('Bahasa Isyarat', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
              Row(
                children: const [
                  Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                  SizedBox(width: 4),
                  Text('4.8', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(_titleEditController.text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 14),
          const Text('Deskripsi Kelas', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(_descEditController.text, style: const TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.4)),
          const SizedBox(height: 24),
          const Text('Kurikulum Pembelajaran', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: _curriculumData.length,
            itemBuilder: (context, index) {
              final item = _curriculumData[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Text(item['part'], style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(item['title'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    Text(item['duration'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDiscussionTab() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          style: const TextStyle(fontSize: 13),
                          decoration: const InputDecoration(hintText: 'Tulis tanggapan...', border: InputBorder.none),
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.send_rounded, color: Color(0xFF2563EB), size: 18), onPressed: _addComment),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.commentsReference.length,
                  itemBuilder: (context, index) {
                    final c = widget.commentsReference[index];
                    return ListTile(
                      leading: const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 18)),
                      title: Text(c['username'] ?? 'User', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      subtitle: Text(c['content'] ?? '', style: const TextStyle(fontSize: 12)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}