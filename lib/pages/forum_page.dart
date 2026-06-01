import 'package:flutter/material.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController postController = TextEditingController();
  final TextEditingController replyController = TextEditingController();

  String searchQuery = '';

  final List<Map<String, dynamic>> posts = [
    {
      'username': '@naysila123',
      'time': '2 jam yang lalu',
      'role': 'Murid',
      'content': 'Ada tips biar gak kaku waktu praktik bahasa isyarat?',
      'image': 'https://picsum.photos/seed/spongeboblike/300/180',
      'likes': 3,
      'liked': false,
      'replies': [
        {
          'username': '@budi_guru',
          'time': '1 jam yang lalu',
          'role': 'Guru',
          'content': 'Coba latihan dari kosakata dasar dulu, lalu praktikkan pelan-pelan di depan kaca.',
        },
      ],
    },
    {
      'username': '@nadia_isl',
      'time': '3 hari yang lalu',
      'role': 'Murid',
      'content':
          'Gimana cara menghafal bahasa isyarat untuk percakapan sehari-hari biar lebih cepat paham ya?',
      'image': null,
      'likes': 15,
      'liked': false,
      'replies': [
        {
          'username': '@sasa523',
          'time': '2 hari yang lalu',
          'role': 'Murid',
          'content': 'Aku biasanya nonton video pendek terus ditiru gerakannya.',
        },
        {
          'username': '@budi_guru',
          'time': '2 hari yang lalu',
          'role': 'Guru',
          'content': 'Buat daftar 5 kata per hari. Jangan langsung banyak, nanti otakmu mogok kerja.',
        },
      ],
    },
    {
      'username': '@tifnyhys',
      'time': '12 hari yang lalu',
      'role': 'Murid',
      'content':
          'Boleh minta feedback nggak, gerakan bahasa isyaratku di video ini masih kaku atau sudah oke?',
      'image': 'https://picsum.photos/seed/signlanguage/300/180',
      'likes': 40,
      'liked': false,
      'replies': [
        {
          'username': '@mentor_rani',
          'time': '10 hari yang lalu',
          'role': 'Guru',
          'content': 'Gerakannya sudah cukup jelas. Tinggal ekspresi wajahnya dibuat lebih natural.',
        },
      ],
    },
  ];

  List<Map<String, dynamic>> get filteredPosts {
    if (searchQuery.isEmpty) return posts;

    return posts.where((post) {
      return post['content']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
  }

  void showPostSheet() {
    postController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 18,
            bottom: MediaQuery.of(context).viewInsets.bottom + 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Buat Postingan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: postController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tulis pertanyaanmu...',
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: addPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Posting',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void addPost() {
    if (postController.text.trim().isEmpty) return;

    setState(() {
      posts.insert(0, {
        'username': '@kamu',
        'time': 'Baru saja',
        'role': 'Murid',
        'content': postController.text.trim(),
        'image': null,
        'likes': 0,
        'liked': false,
        'replies': [],
      });
    });

    Navigator.pop(context);
  }

  void showReplySheet(int index) {
    replyController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 18,
            bottom: MediaQuery.of(context).viewInsets.bottom + 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Balas Postingan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: replyController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tulis balasan...',
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => addReply(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Kirim Balasan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void addReply(int index) {
    if (replyController.text.trim().isEmpty) return;

    setState(() {
      posts[index]['replies'].add({
        'username': '@kamu',
        'time': 'Baru saja',
        'role': 'Murid',
        'content': replyController.text.trim(),
      });
    });

    Navigator.pop(context);
  }

  @override
  void dispose() {
    searchController.dispose();
    postController.dispose();
    replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu_rounded, color: Color(0xFF111827)),
        title: const Text(
          'Forum',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_rounded, color: Color(0xFF374151)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showPostSheet,
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: 'Cari pertanyaan...',
                hintStyle: const TextStyle(fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                final post = filteredPosts[index];
                final realIndex = posts.indexOf(post);

                return _buildPostCard(post, realIndex);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserHeader(
            username: post['username'],
            time: post['time'],
            role: post['role'],
          ),
          const SizedBox(height: 10),
          Text(
            post['content'],
            style: const TextStyle(
              fontSize: 13,
              height: 1.35,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111827),
            ),
          ),
          if (post['image'] != null) ...[
            const SizedBox(height: 10),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  post['image'],
                  width: 150,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    post['liked'] = !post['liked'];
                    post['likes'] += post['liked'] ? 1 : -1;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      post['liked']
                          ? Icons.thumb_up
                          : Icons.thumb_up_alt_outlined,
                      size: 15,
                      color: post['liked']
                          ? const Color(0xFF2563EB)
                          : Colors.black,
                    ),
                    const SizedBox(width: 4),
                    Text('${post['likes']}', style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              InkWell(
                onTap: () => showReplySheet(index),
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_rounded, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${post['replies'].length} Balasan',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (post['replies'].isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            ...post['replies'].map<Widget>((reply) {
              return _buildReplyItem(reply);
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildReplyItem(Map<String, dynamic> reply) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 10),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Color(0xFFE5E7EB), width: 2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 12,
            backgroundColor: Color(0xFF374151),
            child: Icon(Icons.person_rounded, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        reply['username'],
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(width: 5),
                      _buildRoleBadge(reply['role']),
                      const SizedBox(width: 5),
                      Text(
                        reply['time'],
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    reply['content'],
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.35,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader({
    required String username,
    required String time,
    required String role,
  }) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 15,
          backgroundColor: Color(0xFF111827),
          child: Icon(Icons.person_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF374151),
              ),
            ),
            Text(
              time,
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
        const Spacer(),
        _buildRoleBadge(role),
      ],
    );
  }

  Widget _buildRoleBadge(String role) {
    final bool isGuru = role == 'Guru';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: isGuru ? const Color(0xFFFEF3C7) : const Color(0xFFDBEAFE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: isGuru ? const Color(0xFFD97706) : const Color(0xFF2563EB),
        ),
      ),
    );
  }
}
