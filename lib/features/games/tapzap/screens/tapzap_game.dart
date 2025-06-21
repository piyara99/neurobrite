import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class TapZapGame extends StatefulWidget {
  const TapZapGame({super.key});

  @override
  State<TapZapGame> createState() => _TapZapGameState();
}

class _TapZapGameState extends State<TapZapGame> {
  bool isWaiting = true;
  bool isActive = false;
  bool isTapped = false;
  DateTime? startTime;
  Duration? reactionTime;
  late Timer _waitTimer;

  void _startGame() {
    setState(() {
      isWaiting = true;
      isActive = false;
      isTapped = false;
      reactionTime = null;
    });

    final delay = Random().nextInt(3000) + 2000; // 2-5 sec
    _waitTimer = Timer(Duration(milliseconds: delay), () {
      setState(() {
        isWaiting = false;
        isActive = true;
        startTime = DateTime.now();
      });
    });
  }

  void _handleTap() {
    if (isWaiting) {
      // tapped too soon
      _waitTimer.cancel();
      setState(() {
        isWaiting = false;
        isTapped = true;
        reactionTime = null;
      });
    } else if (isActive && !isTapped) {
      final endTime = DateTime.now();
      final diff = endTime.difference(startTime!);
      setState(() {
        isTapped = true;
        isActive = false;
        reactionTime = diff;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _waitTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.redAccent;
    return Scaffold(
      appBar: AppBar(title: const Text("TapZap"), backgroundColor: themeColor),
      body: GestureDetector(
        onTap: _handleTap,
        child: Container(
          color:
              isWaiting
                  ? Colors.grey[300]
                  : isActive
                  ? themeColor
                  : Colors.greenAccent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isWaiting)
                  const Text(
                    "Get ready...",
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                if (isActive)
                  const Text(
                    "TAP NOW!",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                if (isTapped && reactionTime != null)
                  Column(
                    children: [
                      const Text(
                        "Your Reaction Time:",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${reactionTime!.inMilliseconds} ms",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                if (isTapped && reactionTime == null)
                  const Text(
                    "Oops! Too early!",
                    style: TextStyle(fontSize: 22, color: Colors.red),
                  ),

                const SizedBox(height: 30),
                if (isTapped)
                  ElevatedButton(
                    onPressed: _startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Text("Try Again"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
