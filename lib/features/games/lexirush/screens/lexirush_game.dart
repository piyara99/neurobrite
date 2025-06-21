import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class LexiRushGame extends StatefulWidget {
  const LexiRushGame({super.key});

  @override
  State<LexiRushGame> createState() => _LexiRushGameState();
}

class _LexiRushGameState extends State<LexiRushGame> {
  final List<String> allLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
  late List<String> gameLetters;
  final Set<String> enteredWords = {};
  final TextEditingController _controller = TextEditingController();
  late Timer _timer;
  int _remainingSeconds = 60;
  int _score = 0;
  String feedback = '';

  // Sample dictionary (expand or connect to a real one later)
  final Set<String> validWords = {
    'BAT',
    'TAB',
    'CAB',
    'CAT',
    'ACT',
    'ARC',
    'CAR',
    'BAR',
    'RAT',
    'ART',
    'TAR',
    'BAG',
    'TAG',
    'BIG',
    'DIG',
  };

  @override
  void initState() {
    super.initState();
    _generateLetters();
    _startTimer();
  }

  void _generateLetters() {
    final rand = Random();
    gameLetters = List.generate(7, (_) => allLetters[rand.nextInt(26)]);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) {
          _timer.cancel();
        }
      });
    });
  }

  void _submitWord() {
    final word = _controller.text.toUpperCase();
    _controller.clear();

    if (_remainingSeconds <= 0) return;

    if (enteredWords.contains(word)) {
      setState(() {
        feedback = "You've already used that word!";
      });
      return;
    }

    final isPossible = word
        .split('')
        .every((letter) => gameLetters.contains(letter));
    if (!isPossible || !validWords.contains(word)) {
      setState(() {
        feedback = "Invalid word ❌";
      });
      return;
    }

    setState(() {
      enteredWords.add(word);
      _score += word.length;
      feedback = "Nice! ✅";
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.blueAccent;

    return Scaffold(
      appBar: AppBar(
        title: const Text("LexiRush"),
        backgroundColor: themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              "Form words from these letters:",
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children:
                  gameLetters
                      .map(
                        (letter) => Chip(
                          label: Text(
                            letter,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: themeColor.withOpacity(0.2),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.characters,
              onSubmitted: (_) => _submitWord(),
              decoration: InputDecoration(
                hintText: "Type a word...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _submitWord,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(feedback, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "⏱️ Time: $_remainingSeconds s",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Score: $_score",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              "Your Words:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children:
                    enteredWords
                        .map((word) => ListTile(title: Text(word)))
                        .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
