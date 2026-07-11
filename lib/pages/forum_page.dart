import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';

class ForumPage extends StatefulWidget {
  final String currentUsername;
  final String currentRole;

  const ForumPage({
    super.key, 
    this.currentUsername = '',
    this.currentRole = '',
  });

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController postController = TextEditingController();
  final TextEditingController replyController = TextEditingController();

  String searchQuery = '';
  bool isLoading = false;
  String currentPembuatId = ''; 
  String currentUsername = 'Memuat...';
  String currentRole = 'Murid';

  final List<Map<String, dynamic>> posts = [];

  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedFileBytes; 
  String? _selectedFileName;     
  String? _mediaTypeSelected;    

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchForums();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentPembuatId = prefs.getString('murid_id') ?? 
                         prefs.getString('guru_id') ?? 
                         prefs.getString('id_user') ?? 'M0001';

      String rawName = prefs.getString('username') ?? 
                       prefs.getString('name') ?? 
                       prefs.getString('nama') ?? 'User';
      currentUsername = '@${rawName.toLowerCase().replaceAll(' ', '')}';

      String savedRole = prefs.getString('role') ?? 'Murid';
      if (savedRole.toLowerCase() == 'guru') {
        currentRole = 'Guru';
      } else if (savedRole.toLowerCase() == 'admin') {
        currentRole = 'Admin';
      } else {
        currentRole = 'Murid';
      }
    });
  }

  // 1. AMBIL FORUM + DATA KOMENTAR DARI API LARAVEL
  Future<void> fetchForums() async {
    setState(() => isLoading = true);
    try {
      final String url = Uri.base.host == '10.0.2.2'
          ? 'http://10.0.2.2:8000/api/forums'
          : 'http://10.0.2.2:8000/api/forums';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];

        setState(() {
          posts.clear();
          for (var item in data) {
            // Mapping data balasan/replies dari database
            List<dynamic> rawReplies = item['replies'] ?? [];
            List<Map<String, dynamic>> structuredReplies = rawReplies.map((r) => {
              'username': r['pembuat'] ?? '@anonim',
              'role': r['role'] ?? 'Murid',
              'content': r['konten'] ?? '',
              'time': 'Baru saja',
            }).toList();

            posts.add({
              'id': item['id'], // Menyimpan ID Forum untuk aksi Like & Reply
              'username': item['pembuat'] ?? '@anonim', 
              'time': 'Baru saja', 
              'role': item['role'] ?? 'Murid',
              'content': item['konten'] ?? '',
              'media_url': item['media_url'],
              'media_type': item['media_type'] ?? 'none',
              'likes': item['likes_count'] ?? 0,
              'liked': false, // Status lokal penanda apakah user ini sedang klik like
              'replies': structuredReplies,
            });
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetch forums: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> pickMedia(ImageSource source, bool isVideo, StateSetter setSheetState) async {
    try {
      XFile? mediaFile;
      if (kIsWeb) {
        mediaFile = isVideo 
            ? await _picker.pickVideo(source: ImageSource.gallery, maxDuration: const Duration(minutes: 5))
            : await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      } else {
        mediaFile = isVideo ? await _picker.pickVideo(source: source) : await _picker.pickImage(source: source);
      }

      if (mediaFile != null) {
        final bytes = await mediaFile.readAsBytes();
        setSheetState(() {
          _selectedFileBytes = bytes;
          _selectedFileName = mediaFile!.name;
          _mediaTypeSelected = isVideo ? 'video' : 'image';
        });
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error pick media: $e');
    }
  }

  Future<void> addPost() async {
    final textContent = postController.text.trim();
    if (textContent.isEmpty || currentPembuatId.isEmpty) return;

    setState(() => isLoading = true);
    try {
      final String url = Uri.base.host == '10.0.2.2' ? 'http://10.0.2.2:8000/api/forums' : 'http://10.0.2.2:8000/api/forums';
      var request = http.MultipartRequest('POST', Uri.parse(url));
      
      request.fields['pembuat_id'] = currentPembuatId;
      request.fields['role'] = currentRole;
      request.fields['content'] = textContent;

      if (_selectedFileBytes != null && _selectedFileName != null) {
        request.files.add(http.MultipartFile.fromBytes('media', _selectedFileBytes!, filename: _selectedFileName));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        postController.clear();
        _selectedFileBytes = null; _selectedFileName = null; _mediaTypeSelected = null;
        if (mounted) {
          Navigator.pop(context); 
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil membagikan diskusi!')));
        }
        fetchForums(); 
      }
    } catch (e) {
      debugPrint('Error posting: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // BAGIAN 1: API KIRIM BALASAN KE LARAVEL
  Future<void> addReply(int index, int forumId) async {
    final replyText = replyController.text.trim();
    if (replyText.isEmpty || currentPembuatId.isEmpty) return;

    try {
      final String url = Uri.base.host == '10.0.2.2'
          ? 'http://10.0.2.2:8000/api/forums/$forumId/reply'
          : 'http://10.0.2.2:8000/api/forums/$forumId/reply';

      final response = await http.post(
        Uri.parse('https://isyaratkita.alwaysdata.net/api/forums'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'pembuat_id': currentPembuatId,
          'role': currentRole,
          'content': replyText,
        }),
      );

      if (response.statusCode == 201) {
        replyController.clear();
        if (mounted) Navigator.pop(context);
        fetchForums(); // Muat ulang data agar komentar baru masuk tabel muncul
      }
    } catch (e) {
      debugPrint('Error sending reply: $e');
    }
  }

  // BAGIAN 2: API TOGGLE LIKE KE LARAVEL
  Future<void> toggleLike(int index, int forumId) async {
    final bool isCurrentlyLiked = posts[index]['liked'];
    final String action = isCurrentlyLiked ? 'unlike' : 'like';

    // Optimistic UI Update (Biarkan tampilan berubah instan di HP biar responsif)
    setState(() {
      posts[index]['liked'] = !isCurrentlyLiked;
      posts[index]['likes'] = action == 'like' ? posts[index]['likes'] + 1 : max(0, posts[index]['likes'] - 1);
    });

    try {
      final String url = Uri.base.host == '10.0.2.2'
          ? 'http://10.0.2.2:8000/api/forums/$forumId/like'
          : 'http://10.0.2.2:8000/api/forums/$forumId/like';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': action}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          posts[index]['likes'] = data['likes_count']; // Sinkronisasi angka presisi dari server
        });
      }
    } catch (e) {
      debugPrint('Error liking post: $e');
    }
  }

  void showPostSheet() {
    postController.clear();
    _selectedFileBytes = null; _selectedFileName = null; _mediaTypeSelected = null;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 18, bottom: MediaQuery.of(context).viewInsets.bottom + 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Buat Postingan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  TextField(
                    controller: postController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Tanyakan sesuatu, $currentUsername...',
                      border: InputBorder.none, filled: true, fillColor: const Color(0xFFF3F4F6),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_selectedFileName != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8), margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Icon(_mediaTypeSelected == 'video' ? Icons.video_file_rounded : Icons.image_rounded, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_selectedFileName!, maxLines: 1, overflow: TextOverflow.ellipsis)),
                          IconButton(icon: const Icon(Icons.cancel_rounded), onPressed: () => setSheetState(() { _selectedFileName = null; _selectedFileBytes = null; })),
                        ],
                      ),
                    )
                  ],
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.image_rounded, color: Colors.green), onPressed: () => pickMedia(ImageSource.gallery, false, setSheetState)),
                      IconButton(icon: const Icon(Icons.video_camera_back_rounded, color: Colors.redAccent), onPressed: () => pickMedia(ImageSource.gallery, true, setSheetState)),
                      const Text('Tambah Foto/Video', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity, height: 44,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () async { setSheetState(() {}); await addPost(); },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      child: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white)) : const Text('Posting', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showReplySheet(int index, int forumId) {
    replyController.clear();
    final postReplies = posts[index]['replies'] as List<dynamic>;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 18, bottom: MediaQuery.of(context).viewInsets.bottom + 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Komentar & Balasan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              
              // Tampilan List Komentar Hasil Tarikan Database Laravel
              if (postReplies.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: Text('Belum ada balasan. Jadilah yang pertama!', style: TextStyle(color: Colors.grey, fontSize: 12))),
                )
              else
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: postReplies.length,
                    itemBuilder: (ctx, idx) {
                      final rep = postReplies[idx];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(rep['username'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: rep['role'] == 'Guru' ? const Color(0xFFFEF3C7) : const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(10)),
                                  child: Text(rep['role'], style: TextStyle(fontSize: 8, color: rep['role'] == 'Guru' ? const Color(0xFFD97706) : const Color(0xFF2563EB))),
                                )
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(rep['content'], style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              const Divider(),
              TextField(
                controller: replyController,
                decoration: InputDecoration(
                  hintText: 'Balas sebagai $currentUsername...',
                  filled: true, fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity, height: 44,
                child: ElevatedButton(
                  onPressed: () => addReply(index, forumId),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text('Kirim Balasan', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose(); postController.dispose(); replyController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredPosts {
    if (searchQuery.isEmpty) return posts;
    return posts.where((post) => post['content'].toString().toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFF3F4F6),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false, 
          title: const Text(
            'Forum',
            style: TextStyle(
              color: Color(0xFF111827),
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              fontSize: 20,
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: showPostSheet,
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB))))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Cari pertanyaan...', prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      filled: true, fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredPosts.isEmpty
                      ? const Center(child: Text('Belum ada diskusi.', style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          itemCount: filteredPosts.length,
                          itemBuilder: (context, index) {
                            final post = filteredPosts[index];
                            return _buildPostCard(post, index);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, int index) {
    final int forumId = post['id'];
    final bool isLikedCounted = post['liked'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserHeader(username: post['username'], time: post['time'], role: post['role']),
          const SizedBox(height: 10),
          Text(post['content'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          
          if (post['media_url'] != null && post['media_type'] == 'image') ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(post['media_url'], fit: BoxFit.cover, width: double.infinity, height: 200),
            ),
          ] else if (post['media_url'] != null && post['media_type'] == 'video') ...[
            const SizedBox(height: 10),
            _ForumVideoPlayer(videoUrl: post['media_url']),
          ],

          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // ITEM WIDGET LIKES YANG SUDAH AKTIF API BISA DIKLIK 👍
              InkWell(
                onTap: () => toggleLike(index, forumId),
                child: Row(
                  children: [
                    Icon(isLikedCounted ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined, size: 15, color: isLikedCounted ? const Color(0xFF2563EB) : Colors.black),
                    const SizedBox(width: 4),
                    Text('${post['likes']}', style: TextStyle(color: isLikedCounted ? const Color(0xFF2563EB) : Colors.black)),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              // ITEM WIDGET REPLIES YANG SUDAH AKTIF BISA DIKLIK 💬
              InkWell(
                onTap: () => showReplySheet(index, forumId),
                child: Row(children: [const Icon(Icons.chat_bubble_rounded, size: 14), const SizedBox(width: 4), Text('${post['replies'].length} Balasan')]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader({required String username, required String time, required String role}) {
    return Row(
      children: [
        const CircleAvatar(radius: 15, backgroundColor: Color(0xFF111827), child: Icon(Icons.person_rounded, color: Colors.white, size: 18)),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(username, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          Text(time, style: const TextStyle(fontSize: 9, color: Colors.grey)),
        ]),
        const Spacer(),
        _buildRoleBadge(role),
      ],
    );
  }

  Widget _buildRoleBadge(String role) {
    final bool isGuru = role.toLowerCase() == 'guru';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: isGuru ? const Color(0xFFFEF3C7) : const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(20)),
      child: Text(role, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: isGuru ? const Color(0xFFD97706) : const Color(0xFF2563EB))),
    );
  }
}

class _ForumVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const _ForumVideoPlayer({required this.videoUrl});
  @override
  State<_ForumVideoPlayer> createState() => _ForumVideoPlayerState();
}

class _ForumVideoPlayerState extends State<_ForumVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))..initialize().then((_) { setState(() { _isInitialized = true; }); });
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) return const SizedBox(height: 150, child: Center(child: CircularProgressIndicator()));
    return Column(
      children: [
        AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller)),
        VideoProgressIndicator(_controller, allowScrubbing: true),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [IconButton(icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow), onPressed: () => setState(() => _controller.value.isPlaying ? _controller.pause() : _controller.play()))])
      ],
    );
  }
}
