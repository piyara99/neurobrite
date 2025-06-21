import 'package:flutter/material.dart';
import 'dart:math';

class FaceReadGame extends StatefulWidget {
  const FaceReadGame({super.key});

  @override
  State<FaceReadGame> createState() => _FaceReadGameState();
}

class _FaceReadGameState extends State<FaceReadGame> {
  final List<Map<String, dynamic>> emotions = [
    {'emoji': '😃', 'label': 'Happy'},
    {'emoji': '😢', 'label': 'Sad'},
    {'emoji': '😡', 'label': 'Angry'},
    {'emoji': '😱', 'label': 'Surprised'},
    {'emoji': '😐', 'label': 'Neutral'},
  ];

  late Map<String, dynamic> currentEmotion;
  late List<String> options;
  int score = 0;
  String feedback = '';

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  void _nextQuestion() {
    final rand = Random();
    currentEmotion = emotions[rand.nextInt(emotions.length)];
    options = [...emotions.map((e) => e['label'] as String)..shuffle()];
    feedback = '';
  }

  void _checkAnswer(String selected) {
    setState(() {
      if (selected == currentEmotion['label']) {
        score++;
        feedback = 'Correct! ✅';
      } else {
        feedback = 'Oops! It was ${currentEmotion['label']} 😅';
      }
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          _nextQuestion();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.purpleAccent;

    return Scaffold(
      appBar: AppBar(
        title: const Text("FaceRead"),
        backgroundColor: themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text("Score: $score", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            Text(currentEmotion['emoji'], style: const TextStyle(fontSize: 80)),
            const SizedBox(height: 16),
            Text(
              "What emotion is this?",
              style: TextStyle(fontSize: 20, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            ...options.map((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor.withOpacity(0.8),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(option, style: const TextStyle(fontSize: 16)),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            Text(
              feedback,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

extension on Iterable<String> {
  shuffle() {}
}
