import 'dart:ui'; 
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> materiList = [
  {
    'title': 'Abjad & Angka Dasar',
    'level': 'Beginner',
    'duration': '15 Menit',
    'isPremium': false, 
    'videoCount': 5,
  },
  {
    'title': 'Ekspresi Kecepatan Dasar',
    'level': 'Beginner',
    'duration': '20 Menit',
    'isPremium': false, 
    'videoCount': 4,
  },
  {
    'title': 'Frasa Percakapan Sehari-hari',
    'level': 'Intermediate', 
    'duration': '45 Menit',
    'isPremium': true, 
    'videoCount': 12,
  },
  {
    'title': 'Kosakata Medis & Darurat',
    'level': 'Intermediate', 
    'duration': '60 Menit',
    'isPremium': true, 
    'videoCount': 10,
  },
];

class MateriListPage extends StatefulWidget {
  const MateriListPage({super.key});

  @override
  State<MateriListPage> createState() => _MateriListPageState();
}

class _MateriListPageState extends State<MateriListPage> {
  bool isUserPremium = false; 

  void _showPremiumOfferDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xFFFEF3C7),
              child: Icon(Icons.workspace_premium_rounded, size: 40, color: Colors.amber),
            ),
            const SizedBox(height: 16),
            const Text(
              'Buka Akses Intermediate',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Materi video level Intermediate ke atas hanya tersedia untuk pengguna Premium Aetherna.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => isUserPremium = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Selamat! Akun anda sekarang Premium ✨'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text(
                  'Beli Paket Premium - Rp 49.000', 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Nanti Saja', style: TextStyle(color: Colors.black54)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Materi Bahasa Isyarat', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: materiList.length,
        itemBuilder: (context, index) {
          final materi = materiList[index];
          final bool isLocked = materi['isPremium'] && !isUserPremium;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))
              ],
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: materi['level'] == 'Beginner' ? const Color(0xFFEFF6FF) : const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            materi['level'],
                            style: TextStyle(
                              fontSize: 11, 
                              fontWeight: FontWeight.bold,
                              color: materi['level'] == 'Beginner' ? const Color(0xFF2563EB) : Colors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        Text(
                          materi['title'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(height: 12),
                        
                        Row(
                          children: [
                            const Icon(Icons.video_library_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text('${materi['videoCount']} Video', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(width: 16),
                            const Icon(Icons.access_time, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(materi['duration'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              if (isLocked) {
                                _showPremiumOfferDialog();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Membuka materi: ${materi['title']}')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            child: const Text('Mulai Belajar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ),

                  if (isLocked)
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: _showPremiumOfferDialog, 
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), 
                          child: Container(
                            color: Colors.white.withOpacity(0.3), 
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.lock_rounded, color: Colors.amber, size: 16),
                                    SizedBox(width: 6),
                                    Text(
                                      'Butuh Akses Premium',
                                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}