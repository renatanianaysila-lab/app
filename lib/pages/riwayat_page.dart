import 'package:flutter/material.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  int activeTab = 0; // 0: Video, 1: Kuis, 2: Pembelian

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {},
        ),
        title: Text(
          activeTab == 0 
              ? 'Riwayat Belajar' 
              : activeTab == 1 
                  ? 'Riwayat Kuis' 
                  : 'Riwayat Pembelian',
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // --- TAB CUSTOM SELECTOR ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  _buildTabButton(0, Icons.play_arrow_rounded, 'Video'),
                  _buildTabButton(1, Icons.assignment_turned_in_rounded, 'Kuis'),
                  _buildTabButton(2, Icons.shopping_cart_rounded, 'Pembelian'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // --- LIST CONTENT BARU ---
          Expanded(
            child: IndexedStack(
              index: activeTab,
              children: [
                _buildVideoList(),
                _buildKuisList(),
                _buildPembelianList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, IconData icon, String title) {
    bool isSelected = activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => activeTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2F66E7) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.black54),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. TAB VIDEO CONTENT
  Widget _buildVideoList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        _buildVideoCard('Dasar Bahasa Isyarat - Alfabet A-Z', '25 Januari 2024', 'Selesai', true),
        _buildVideoCard('Angka dalam Bahasa Isyarat 1-100', '23 Januari 2024', 'Sedang Ditonton', false),
        _buildVideoCard('Ekspresi Sehari-hari', '20 Januari 2024', 'Selesai', true),
      ],
    );
  }

  Widget _buildVideoCard(String title, String date, String status, bool isDone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.video_library_rounded, color: Colors.grey[400]),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(date, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDone ? const Color(0xFFE8F8F0) : const Color(0xFFE8F0FE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isDone ? const Color(0xFF27AE60) : const Color(0xFF2F66E7),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // 2. TAB KUIS CONTENT
  Widget _buildKuisList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        _buildKuisCard('Dasar Bahasa Isyarat - Alfabet A-Z', '25 Januari 2024', 'Lulus', '100/100', true),
        _buildKuisCard('Angka dalam Bahasa Isyarat 1-100', '25 Januari 2024', 'Lulus', '100/100', true),
        _buildKuisCard('Ekspresi Sehari-hari', '25 Januari 2024', 'Tidak Lulus', '65/100', false),
      ],
    );
  }

  Widget _buildKuisCard(String title, String date, String status, String score, bool isPass) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.notes_rounded, color: Colors.black87),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(date, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                const SizedBox(height: 6),
                Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPass ? const Color(0xFFE8F8F0) : const Color(0xFFFEECEB),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: isPass ? const Color(0xFF27AE60) : const Color(0xFFEB5757),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(score, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 12)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // 3. TAB PEMBELIAN CONTENT
  Widget _buildPembelianList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        _buildPembelianCard('1 Desember 2025', '1 Januari 2026', false),
        _buildPembelianCard('5 Januari 2026', '5 Februari 2026', false),
        _buildPembelianCard('19 Maret 2026', '19 April 2026', true),
      ],
    );
  }

  Widget _buildPembelianCard(String date, String expDate, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Paket Premium', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const Text('Rp 30.000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey[400]),
              const SizedBox(width: 6),
              Text(date, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: const BoxDecoration(color: Color(0xFFE8F8F0), borderRadius: BorderRadius.all(Radius.circular(6))),
                child: const Text('Berhasil', style: TextStyle(color: Color(0xFF27AE60), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFE8F8F0) : const Color(0xFFFEECEB), 
                  borderRadius: const BorderRadius.all(Radius.circular(6))
                ),
                child: Text(
                  isActive ? 'Aktif' : 'Non-Aktif', 
                  style: TextStyle(color: isActive ? const Color(0xFF27AE60) : const Color(0xFFEB5757), fontSize: 10, fontWeight: FontWeight.bold)
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              Icon(Icons.credit_card, size: 14, color: Colors.grey[400]),
              const SizedBox(width: 6),
              Text('Transfer Bank', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
              const Spacer(),
              Text('Berakhir: $expDate', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }
}