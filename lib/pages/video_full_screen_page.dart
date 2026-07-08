import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

class VideoFullScreenPage extends StatefulWidget {
  final String courseTitle;
  final bool isIntermediate;

  const VideoFullScreenPage({
    super.key,
    required this.courseTitle,
    this.isIntermediate = false,
  });

  @override
  State<VideoFullScreenPage> createState() => _VideoFullScreenPageState();
}

class _VideoFullScreenPageState extends State<VideoFullScreenPage> {
  bool _isPlaying = true;
  bool _isMuted = false;
  bool _isCcActive = true;
  double _currentSliderValue = 35.0; 

  final String _currentSubtitleText = "[Halo, mari kita pelajari gerakan abjad isyarat ini]";

  @override
  void initState() {
    super.initState();
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: const Color(0xFF0F172A), 
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 16,
                      child: Text(
                        "Memutar Sesi: ${widget.courseTitle}",
                        style: const TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 0.5),
                      ),
                    ),

                    if (_isCcActive && _currentSubtitleText.isNotEmpty)
                      Positioned(
                        bottom: 24,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _currentSubtitleText,
                            style: const TextStyle(
                              color: Colors.amber, 
                              fontSize: 13, 
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.courseTitle,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 15, 
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black87, blurRadius: 4, offset: Offset(1, 1))]
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text('01:15', style: TextStyle(color: Colors.white60, fontSize: 11)),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            activeTrackColor: const Color(0xFF2563EB),
                            inactiveTrackColor: Colors.white24,
                            thumbColor: const Color(0xFF2563EB),
                          ),
                          child: Slider(
                            value: _currentSliderValue,
                            max: 100,
                            onChanged: (value) {
                              setState(() {
                                _currentSliderValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const Text('03:25', style: TextStyle(color: Colors.white60, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPlaying = !_isPlaying;
                              });
                            },
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: Icon(
                              _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _isMuted = !_isMuted;
                              });
                            },
                          ),
                        ],
                      ),
                      
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.subtitles_rounded,
                              color: _isCcActive && _currentSubtitleText.isNotEmpty ? Colors.blue : Colors.white38,
                              size: 20,
                            ),
                            onPressed: () {
                              if (_currentSubtitleText.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Maaf, teks CC (Closed Captions) tidak tersedia untuk materi video ini.'),
                                    backgroundColor: Colors.redAccent,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                setState(() {
                                  _isCcActive = !_isCcActive;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(_isCcActive ? 'Subtitle CC Aktif' : 'Subtitle CC Dimatikan'),
                                    duration: const Duration(milliseconds: 600),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.fullscreen_exit_rounded, color: Colors.white70, size: 24),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
