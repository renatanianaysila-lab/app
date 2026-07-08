import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl; // Menampung link YouTube secara dinamis
  final String title;    // Menampung judul video secara dinamis

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Otomatis mengubah URL YouTube jenis apapun menjadi ID video yang bisa diputar
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true, // Otomatis putar video saat halaman dibuka
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    // Dipanggil saat keluar halaman agar RAM laptop/HP gak boncos dan tetep adem
    _controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background hitam ala bioskop biar fokus nonton isyarat
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Tombol back jadi putih
        title: Text(
          widget.title, // Judul otomatis berubah sesuai video yang dipilih
          style: const TextStyle(
            color: Colors.white, 
            fontFamily: 'Poppins', 
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // 🔥 Tombol lonceng bulat ukuran 46 pas sesuai desain IsyaratKita kamu!
          Container(
            width: 46,
            height: 46,
            margin: const EdgeInsets.only(right: 16), // Kasih jarak dari pinggir kanan
            decoration: const BoxDecoration(
              color: Color(0xFFEEF2FF), // Warna latar lonceng biru muda transparan
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Image.asset(
                'assets/images/loncengfull.png', 
                width: 22, 
                height: 22,
              ),
              onPressed: () {
                // Aksi tombol lonceng jika diperlukan nanti
              },
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: const Color(0xFF3B72FF), // Loading bar pakai warna tema utama kamu
          progressColors: const ProgressBarColors(
            playedColor: Color(0xFF3B72FF),
            handleColor: Color(0xFF3B72FF),
          ),
        ),
      ),
    );
  }
}
