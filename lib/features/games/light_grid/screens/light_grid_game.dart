import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class LightGridGame extends StatefulWidget {
  const LightGridGame({super.key});

  @override
  State<LightGridGame> createState() => _LightGridGameState();
}

class _LightGridGameState extends State<LightGridGame> {
  final int gridSize = 9;
  final int patternLength = 4;
  List<int> pattern = [];
  List<int> userInput = [];
  int currentStep = -1;
  bool isShowingPattern = true;
  bool isUserTurn = false;

  @override
  void initState() {
    super.initState();
    _generatePattern();
    _startPatternSequence();
  }

  void _generatePattern() {
    final rand = Random();
    pattern = List.generate(patternLength, (_) => rand.nextInt(gridSize));
  }

  void _startPatternSequence() async {
    setState(() {
      isShowingPattern = true;
      isUserTurn = false;
      currentStep = -1;
      userInput.clear();
    });

    for (int i = 0; i < pattern.length; i++) {
      setState(() {
        currentStep = pattern[i];
      });
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() {
        currentStep = -1;
      });
      await Future.delayed(const Duration(milliseconds: 300));
    }

    setState(() {
      isUserTurn = true;
      isShowingPattern = false;
    });
  }

  void _handleTap(int index) {
    if (!isUserTurn) return;

    setState(() {
      userInput.add(index);
    });

    if (userInput.length == pattern.length) {
      isUserTurn = false;
      bool isCorrect = _validateUserInput();
      _showResultDialog(isCorrect);
    }
  }

  bool _validateUserInput() {
    for (int i = 0; i < pattern.length; i++) {
      if (pattern[i] != userInput[i]) return false;
    }
    return true;
  }

  void _showResultDialog(bool isCorrect) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(isCorrect ? "Well done!" : "Oops!"),
            content: Text(
              isCorrect
                  ? "You remembered the pattern correctly. 🧠"
                  : "Try again to improve your memory!",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _generatePattern();
                  _startPatternSequence();
                },
                child: const Text("Next"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    userInput.clear();
                    isUserTurn = true;
                    isShowingPattern = false;
                    currentStep = -1;
                  });
                },
                child: const Text("Retry"),
              ),
            ],
          ),
    );
  }

  Color _getTileColor(int index) {
    if (currentStep == index && isShowingPattern) return Colors.amber;
    if (userInput.contains(index)) return Colors.green;
    return Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Light Grid"),
        backgroundColor: Colors.indigo.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              isShowingPattern
                  ? "Watch the pattern..."
                  : isUserTurn
                  ? "Now it's your turn!"
                  : "Waiting...",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: gridSize,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _handleTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getTileColor(index),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
