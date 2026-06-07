import 'package:flutter/material.dart';
import 'video_full_screen_page.dart';

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
  final Map<int, TextEditingController> _replyControllers = {};
  final Map<int, bool> _showReplyInput = {};

  // Controller Edit Teks untuk Guru
  late TextEditingController _titleEditController;
  final TextEditingController _descEditController = TextEditingController(
    text: 'Video pembelajaran ini membahas secara mendalam materi terkait tata cara komunikasi isyarat demi menunjang efisiensi interaksi kelompok secara visual.',
  );

  late TabController _tabController;

  // Data kurikulum tiruan yang bisa di-update nama filenya saat di-upload oleh guru
  late List<Map<String, dynamic>> _curriculumData;

  @override
  void initState() {
    super.initState();
    _titleEditController = TextEditingController(text: widget.videoTitle);
    _tabController = TabController(length: 2, vsync: this);

    // Inisialisasi data kurikulum beserta status upload-nya
    _curriculumData = [
      {
        'part': 'Part 1',
        'title': 'Materi Pendahuluan Utama',
        'duration': '03:25',
        'isUnlocked': true,
        'fileName': null,
      },
      {
        'part': 'Part 2',
        'title': 'Aturan Posisi Isyarat Dasar',
        'duration': '05:12',
        'isUnlocked': !widget.isIntermediate,
        'fileName': null,
      },
    ];
  }

  @override
  void dispose() {
    _commentController.dispose();
    _titleEditController.dispose();
    _descEditController.dispose();
    _tabController.dispose();
    for (var controller in _replyControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;
    setState(() {
      widget.commentsReference.insert(0, {
        'username': 'Pengguna Aktif',
        'content': _commentController.text.trim(),
        'likeCount': 0,
        'isLiked': false,
        'replies': <Map<String, dynamic>>[],
      });
    });
    _commentController.clear();
    widget.onCommentUpdated();
  }

  void _toggleLike(int index) {
    setState(() {
      final comment = widget.commentsReference[index];
      bool isLiked = comment['isLiked'] ?? false;
      int currentLikes = comment['likeCount'] ?? 0;

      if (isLiked) {
        comment['likeCount'] = currentLikes - 1;
        comment['isLiked'] = false;
      } else {
        comment['likeCount'] = currentLikes + 1;
        comment['isLiked'] = true;
      }
    });
    widget.onCommentUpdated();
  }

  void _addReply(int index) {
    final controller = _replyControllers[index];
    if (controller == null || controller.text.trim().isEmpty) return;

    setState(() {
      if (widget.commentsReference[index]['replies'] == null) {
        widget.commentsReference[index]['replies'] = <Map<String, dynamic>>[];
      }
      widget.commentsReference[index]['replies'].add({
        'username': 'Pengguna Aktif',
        'content': controller.text.trim(),
      });
      _showReplyInput[index] = false;
    });
    controller.clear();
    widget.onCommentUpdated();
  }

  void _navigateToPlayer(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoFullScreenPage(
          courseTitle: title,
          isIntermediate: widget.isIntermediate,
        ),
      ),
    );
  }

  // Fungsi Simulasi Upload Video per Item Kurikulum
  void _simulateUploadVideoForPart(int index) {
    setState(() {
      _curriculumData[index]['fileName'] = "Video_${_curriculumData[index]['part']}_New.mp4";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berhasil mengunggah video untuk ${_curriculumData[index]['part']}!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ── BAGIAN PLAYER UTAS (BERSIH TANPA TOMBOL UPLOAD) ────────────────
          Stack(
            children: [
              GestureDetector(
                onTap: () => _navigateToPlayer(_titleEditController.text),
                child: Container(
                  width: double.infinity,
                  height: 240,
                  color: const Color(0xFF0F172A),
                  child: Center(
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2563EB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded, size: 38, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 44,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
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

  // ── LAYOUT ISI TAB 1: DETAIL MATERI ──────────────────────────────────────
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
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Bahasa Isyarat',
                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                  SizedBox(width: 4),
                  Text('4.8', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // KONDISI JIKA GURU: TEXTFIELD INPUT (TIDAK REDUNDAN)
          if (widget.isTeacher) ...[
            const Text('Judul Materi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 6),
            TextField(
              controller: _titleEditController,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Deskripsi Kelas', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 6),
            TextField(
              controller: _descEditController,
              maxLines: null,
              style: const TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.4),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Perubahan Berhasil Disimpan!')),
                  );
                },
                icon: const Icon(Icons.save_rounded, size: 16, color: Colors.white),
                label: const Text('Simpan Pembaruan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ] else ...[
            // KONDISI JIKA SISWA: TEKS STATIS
            Text(
              _titleEditController.text,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), height: 1.2),
            ),
            const SizedBox(height: 14),
            const Text('Deskripsi Kelas', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 8),
            Text(
              _descEditController.text,
              style: const TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.4),
            ),
          ],

          const SizedBox(height: 24),
          Row(
            children: const [
              Icon(Icons.video_collection_outlined, size: 15, color: Colors.grey),
              SizedBox(width: 4),
              Text('12 Kelas', style: TextStyle(color: Colors.grey, fontSize: 12)),
              SizedBox(width: 16),
              Icon(Icons.access_time, size: 15, color: Colors.grey),
              SizedBox(width: 4),
              Text('45 Menit', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFE2E8F0),
                child: Icon(Icons.person, color: Color(0xFF64748B)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Ahmad Shidqi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  SizedBox(height: 2),
                  Text('Senior Tutor IsyaratKita', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),

          // ── SEKSYEN KURIKULUM PEMBELAJARAN ────────────────────────────────
          const Text('Kurikulum Pembelajaran', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 12),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: _curriculumData.length,
            itemBuilder: (context, index) {
              final item = _curriculumData[index];
              return _buildCurriculumCard(index, item);
            },
          ),
          
          if (!widget.isTeacher) const SizedBox(height: 60),
        ],
      ),
    );
  }

  // ── WIDGET ITEM KURIKULUM CUSTOM (DENGAN INTEGRASI UPLOAD UNTUK GURU) ─────
  Widget _buildCurriculumCard(int index, Map<String, dynamic> item) {
    String part = item['part'];
    String title = item['title'];
    String duration = item['duration'];
    bool isUnlocked = item['isUnlocked'];
    String? fileName = item['fileName'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDBEAFE), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(part, style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title, 
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis
                ),
              ),
              Text(duration, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(width: 10),
              // Jika siswa, ada trigger navigasi play / lock icon
              if (!widget.isTeacher)
                GestureDetector(
                  onTap: () {
                    if (isUnlocked) {
                      _navigateToPlayer('$part: $title');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Materi ini terkunci! Silakan beli paket premium.')),
                      );
                    }
                  },
                  child: Icon(
                    isUnlocked ? Icons.play_circle_fill_rounded : Icons.lock_rounded, 
                    size: 18, 
                    color: isUnlocked ? const Color(0xFF2563EB) : Colors.amber,
                  ),
                ),
            ],
          ),
          
          // JIKA USER ADALAH GURU: Munculkan opsi interaktif upload video di bawah nama materi
          if (widget.isTeacher) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: Color(0xFFDBEAFE), thickness: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        fileName != null ? Icons.check_circle_rounded : Icons.video_file_outlined,
                        size: 14,
                        color: fileName != null ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          fileName ?? "Belum ada video tersemat",
                          style: TextStyle(
                            fontSize: 11,
                            color: fileName != null ? Colors.green.shade700 : Colors.black45,
                            fontStyle: fileName != null ? FontStyle.normal : FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _simulateUploadVideoForPart(index),
                  icon: const Icon(Icons.upload_file_rounded, size: 12, color: Colors.white),
                  label: Text(
                    fileName == null ? 'Upload Video' : 'Ganti Video',
                    style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── LAYOUT ISI TAB 2: DISKUSI & KOMENTAR ──────────────────────────────────
  Widget _buildDiscussionTab() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: 'Tulis tanggapan atau pertanyaan...',
                            hintStyle: TextStyle(color: Colors.black38, fontSize: 13),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send_rounded, color: Color(0xFF2563EB), size: 18),
                        onPressed: _addComment,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                widget.commentsReference.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: Text('Belum ada diskusi.', style: TextStyle(color: Colors.grey, fontSize: 12))),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: widget.commentsReference.length,
                        itemBuilder: (context, index) {
                          final c = widget.commentsReference[index];
                          _replyControllers.putIfAbsent(index, () => TextEditingController());
                          _showReplyInput.putIfAbsent(index, () => false);

                          return _buildInteractiveCommentRow(index, c);
                        },
                      ),
              ],
            ),
          ),
        ),
        if (!widget.isTeacher)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isIntermediate ? const Color(0xFFF59E0B) : const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  widget.isIntermediate ? 'Beli Paket Premium' : 'Mulai Belajar Sekarang',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildInteractiveCommentRow(int index, Map<String, dynamic> commentData) {
    bool isLiked = commentData['isLiked'] ?? false;
    int likeCount = commentData['likeCount'] ?? 0;
    List<dynamic> replies = commentData['replies'] ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFFCBD5E1),
            child: Icon(Icons.person, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(commentData['username'] ?? 'User', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 4),
                Text(commentData['content'] ?? '', style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.3)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    InkWell(
                      onTap: () => _toggleLike(index),
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        child: Row(
                          children: [
                            Icon(isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 14, color: isLiked ? Colors.redAccent : Colors.grey),
                            const SizedBox(width: 4),
                            Text('$likeCount', style: TextStyle(fontSize: 11, color: isLiked ? Colors.redAccent : Colors.grey, fontWeight: isLiked ? FontWeight.bold : FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _showReplyInput[index] = !(_showReplyInput[index] ?? false);
                        });
                      },
                      child: const Text('Reply', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                if (replies.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: replies.length,
                      itemBuilder: (context, rIndex) {
                        final reply = replies[rIndex];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            children: [
                              const Icon(Icons.subdirectory_arrow_right_rounded, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text('${reply['username']}: ', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              Expanded(child: Text(reply['content'], style: const TextStyle(fontSize: 11, color: Color(0xFF475569)))),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                if (_showReplyInput[index] ?? false)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _replyControllers[index],
                              maxLines: null,
                              style: const TextStyle(fontSize: 11),
                              decoration: const InputDecoration(hintText: 'Balas diskusi ini...', border: InputBorder.none, isDense: true),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send_rounded, size: 14, color: Colors.blue),
                            onPressed: () => _addReply(index),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}