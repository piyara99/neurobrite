import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:neurobrite/features/zen_mode/screens/string_extensions.dart';
import 'dart:async';
import 'dart:math';

class ZenModeScreen extends StatefulWidget {
  const ZenModeScreen({super.key});

  @override
  State<ZenModeScreen> createState() => _ZenModeScreenState();
}

class _ZenModeScreenState extends State<ZenModeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  int remainingSeconds = 180;
  bool isRunning = true;

  final AudioPlayer _player = AudioPlayer();
  String currentSound = 'rain';

  final Map<String, String> soundFiles = {
    'rain': 'assets/sounds/rain.mp3',
    'forest': 'assets/sounds/forest.mp3',
    'ocean': 'assets/sounds/ocean.mp3',
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _startTimer();
    _playSound(currentSound);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isRunning) return;
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          _timer.cancel();
          _player.stop();
        }
      });
    });
  }

  void _playSound(String key) async {
    await _player.stop();
    await _player.play(AssetSource(soundFiles[key]!));
    _player.setReleaseMode(ReleaseMode.loop);
  }

  void _togglePause() {
    setState(() => isRunning = !isRunning);
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.teal;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Zen Mode"),
        backgroundColor: themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              "Take a Deep Breath",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Breathing Circle Animation
            SizedBox(
              height: 160,
              width: 160,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final scale = 1 + 0.3 * sin(_controller.value * 2 * pi);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeColor.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.self_improvement,
                          size: 60,
                          color: themeColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "${(remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(remainingSeconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 32),

            // Ambient Sound Selector
            const Text(
              "Ambient Sounds",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  soundFiles.keys.map((sound) {
                    final isSelected = sound == currentSound;
                    return ElevatedButton.icon(
                      onPressed: () {
                        setState(() => currentSound = sound);
                        _playSound(sound);
                      },
                      icon: Icon(
                        sound == 'rain'
                            ? Icons.water_drop
                            : sound == 'ocean'
                            ? Icons.waves
                            : Icons.park,
                        color: isSelected ? Colors.white : Colors.grey[300],
                      ),
                      label: Text(sound.capitalize()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected
                                ? themeColor
                                : themeColor.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 32),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _togglePause,
                  icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(isRunning ? "Pause" : "Resume"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _player.stop();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text("Exit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
