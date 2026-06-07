import 'dart:ui';
import 'package:flutter/material.dart';
import 'detail_materi_page.dart'; 
import 'tampilan_paket.dart';

class MateriPage extends StatefulWidget {
  const MateriPage({super.key});

  @override
  State<MateriPage> createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  bool isUserPremium = false;
  bool isLevelDasar = true;

final List<Map<String, dynamic>> materiDasar = [
    {
      'title': 'Ekspresi Dasar',
      'subtitle': '3 Video • 2 Kuis',
      'progress': 0.0,                  
      'statusText': 'Belum Mulai',       
      'color': const Color(0xFFE8F5E9),
      'textColor': const Color(0xFF4CAF50),
    },
    {
      'title': 'Huruf & Angka',
      'subtitle': '4 Video • 3 Kuis',
      'progress': 0.0,                  
      'statusText': 'Belum Mulai',      
      'color': const Color(0xFFE3F2FD),
      'textColor': const Color(0xFF2196F3),
    },
    {
      'title': 'Isyarat Tangan',
      'subtitle': '5 Video • 2 Kuis',
      'progress': 0.30, 
      'statusText': '30%',
      'color': const Color(0xFFFFF3E0),
      'textColor': const Color(0xFFFF9800),
    },
    {
      'title': 'Sapaan & Perkenalan',
      'subtitle': '3 Video • 1 Kuis',
      'progress': 0.0,
      'statusText': 'Belum Mulai',
      'color': const Color(0xFFE8F8F5),
      'textColor': const Color(0xFF009688),
    },
    {
      'title': 'Emosi & Perasaan',
      'subtitle': '4 Video • 2 Kuis',
      'progress': 0.0,
      'statusText': 'Belum Mulai',
      'color': const Color(0xFFFCE4EC),
      'textColor': const Color(0xFFE91E63),
    },
  ];
  
  final List<Map<String, dynamic>> materiIntermediate = [
    {
      'title': 'Kalimat Kompleks',
      'subtitle': '5 Video • 3 Kuis',
      'progress': 0.40,
      'statusText': '40%',
      'color': const Color(0xFFF3E5F5), 
      'textColor': const Color(0xFF9C27B0),
    },
    {
      'title': 'Struktur Idiolek',
      'subtitle': '4 Video • 2 Kuis',
      'progress': 0.10,
      'statusText': '10%',
      'color': const Color(0xFFE0F2F1), 
      'textColor': const Color(0xFF00897B),
    },
    {
      'title': 'Bahasa Isyarat Formal',
      'subtitle': '6 Video • 4 Kuis',
      'progress': 0.0,
      'statusText': 'Belum Mulai',
      'color': const Color(0xFFFFFDE7), 
      'textColor': const Color(0xFFFBC02D),
    },
  ];

  double hitungTotalProgress(List<Map<String, dynamic>> materi) {
    if (materi.isEmpty) return 0.0;
    double total = 0;
    for (var item in materi) {
      total += item['progress'];
    }
    return total / materi.length;
  }

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TampilanPaket()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text(
                  'Lihat Paket Premium', 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
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
    List<Map<String, dynamic>> materiAktif = isLevelDasar ? materiDasar : materiIntermediate;
    double progressAktif = hitungTotalProgress(materiAktif);
    int materiSelesaiCount = materiAktif.where((item) => item['progress'] == 1.0).length;

    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: Colors.black87),
        title: const Text(
          'Materi Pembelajaran',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Cari materi pembelajaran...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  icon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Progress Belajar', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    '${isLevelDasar ? "Level Dasar" : "Level Intermediate"} • $materiSelesaiCount/${materiAktif.length} Selesai',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progressAktif,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(progressAktif * 100).toStringAsFixed(0)}% selesai',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isLevelDasar = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isLevelDasar ? Colors.white : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: isLevelDasar ? Border.all(color: Colors.blue.shade100) : null,
                        boxShadow: isLevelDasar ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: isLevelDasar ? Colors.orange : Colors.grey, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Level Dasar',
                            style: TextStyle(
                              color: isLevelDasar ? Colors.blue : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isLevelDasar = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !isLevelDasar ? Colors.white : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: !isLevelDasar ? Border.all(color: Colors.blue.shade100) : null,
                        boxShadow: !isLevelDasar ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.workspace_premium, color: !isLevelDasar ? Colors.orange : Colors.grey, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Intermediate',
                            style: TextStyle(
                              color: !isLevelDasar ? Colors.blue : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemCount: materiAktif.length,
              itemBuilder: (context, index) {
                final materi = materiAktif[index];
                
                final bool isLocked = !isLevelDasar && !isUserPremium;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: materi['color'],
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                child: Center(
                                  child: Icon(Icons.menu_book_rounded, size: 40, color: materi['textColor']),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          materi['title'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(materi['subtitle'], style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (materi['progress'] > 0.0 && materi['progress'] < 1.0)
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 4.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child: LinearProgressIndicator(
                                                value: materi['progress'],
                                                backgroundColor: Colors.grey.shade200,
                                                valueColor: AlwaysStoppedAnimation<Color>(materi['textColor']),
                                                minHeight: 4,
                                              ),
                                            ),
                                          ),
                                        Text(
                                          materi['statusText'],
                                          style: TextStyle(
                                            color: materi['textColor'],
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                if (isLocked) {
                                  _showPremiumOfferDialog();
                                } else {
                                  Navigator.push(
                                    context,
                                    
MaterialPageRoute(
  builder: (context) => DetailMateriPage(
    materiTitle: materi['title'] ?? 'Materi', 
    themeColor: materi['color'] ?? const Color(0xFF2563EB), 
    bgColor: const Color(0xFFF3F4F6), 
  ),
),
                                  );
                                }
                              },
                            ),
                          ),
                        ),

                        if (isLocked)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16), 
                              child: GestureDetector(
                                onTap: _showPremiumOfferDialog,
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0), 
                                  child: Container(
                                    color: Colors.white.withOpacity(0.1), 
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF1E293B), 
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.lock_rounded, 
                                              color: Colors.amber, 
                                              size: 22,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.amber.shade700,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: const Text(
                                              'PREMIUM',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                              ),
                                            ),
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
          ],
        ),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Materi'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Forum'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}