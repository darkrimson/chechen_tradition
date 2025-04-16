import 'package:chechen_tradition/features/education/screens/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../models/education.dart';

class ContentDetailScreen extends StatefulWidget {
  final EducationalContent content;

  const ContentDetailScreen({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  State<ContentDetailScreen> createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends State<ContentDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _showText = false;

  @override
  void initState() {
    super.initState();
    if (widget.content.type == ContentType.audio) {
      _initAudioPlayer();
    }
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _audioPlayer.setAsset(widget.content.audioUrl!);
      _duration = await _audioPlayer.duration ?? Duration.zero;
      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _position = position;
        });
      });
      _audioPlayer.playerStateStream.listen((state) {
        setState(() {
          _isPlaying = state.playing;
        });
      });
    } catch (e) {
      debugPrint('Error initializing audio player: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.content.title),
        actions: [
          if (widget.content.audioUrl != null && widget.content.content != null)
            IconButton(
              icon: Icon(_showText ? Icons.headphones : Icons.article),
              onPressed: () {
                setState(() {
                  _showText = !_showText;
                  if (!_showText && _isPlaying) {
                    _audioPlayer.pause();
                  }
                });
              },
              tooltip: _showText ? 'Слушать аудио' : 'Читать текст',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.content.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_showText && widget.content.audioUrl != null)
                    _buildAudioPlayer(),
                  if (_showText || widget.content.content != null)
                    Text(
                      widget.content.content!,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TestScreen(content: widget.content),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B0000),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Проверить знания',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return Column(
      children: [
        Slider(
          value: _position.inSeconds.toDouble(),
          max: _duration.inSeconds.toDouble(),
          onChanged: (value) {
            _audioPlayer.seek(Duration(seconds: value.toInt()));
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatDuration(_position)),
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                if (_isPlaying) {
                  _audioPlayer.pause();
                } else {
                  _audioPlayer.play();
                }
              },
            ),
            Text(_formatDuration(_duration)),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
