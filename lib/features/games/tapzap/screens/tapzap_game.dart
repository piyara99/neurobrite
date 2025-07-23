import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class TapZapGame extends StatefulWidget {
  const TapZapGame({super.key});

  @override
  State<TapZapGame> createState() => _TapZapGameState();
}

class Egg {
  double x;
  double y;
  Egg(this.x, this.y);
}

class CrackedEgg {
  double x;
  double y;
  DateTime time;

  CrackedEgg(this.x, this.y) : time = DateTime.now();
}

class _TapZapGameState extends State<TapZapGame> {
  final List<Egg> _eggs = [];
  final List<CrackedEgg> _crackedEggs = [];

  late Timer _spawnTimer;
  late Timer _gameTimer;
  late Timer _countdownTimer;

  double basketX = 0.5;
  int score = 0;
  int _remainingTime = 30; // game lasts 30 seconds

  static const double _basketWidth = 0.25;
  static const Duration _tick = Duration(milliseconds: 50);

  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _eggs.clear();
    _crackedEggs.clear();
    score = 0;
    basketX = 0.5;
    _remainingTime = 30;
    _gameOver = false;

    _spawnTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _spawnEgg(),
    );

    _gameTimer = Timer.periodic(_tick, (_) => _updateGame());

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _remainingTime--;
        if (_remainingTime <= 0) {
          _endGame();
        }
      });
    });
  }

  void _endGame() {
    _spawnTimer.cancel();
    _gameTimer.cancel();
    _countdownTimer.cancel();
    setState(() {
      _gameOver = true;
    });
  }

  void _spawnEgg() {
    final rand = Random();
    setState(() {
      _eggs.add(Egg(rand.nextDouble(), 0));
    });
  }

  void _updateGame() {
    if (!mounted) return;

    setState(() {
      // Move eggs
      for (final egg in _eggs) {
        egg.y += 0.02;
      }

      // Handle caught or missed eggs
      _eggs.removeWhere((egg) {
        if (egg.y >= 0.9) {
          if ((egg.x - basketX).abs() <= _basketWidth / 2) {
            score++;
          } else {
            _crackedEggs.add(CrackedEgg(egg.x, 0.9));
          }
          return true;
        }
        return false;
      });

      // Remove cracked eggs after 2 seconds
      _crackedEggs.removeWhere(
        (crackedEgg) =>
            DateTime.now().difference(crackedEgg.time).inMilliseconds > 2000,
      );
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final width = MediaQuery.of(context).size.width;
    setState(() {
      basketX += details.delta.dx / width;
      basketX = basketX.clamp(0.0, 1.0);
    });
  }

  void _restartGame() {
    _startGame();
  }

  @override
  void dispose() {
    _spawnTimer.cancel();
    _gameTimer.cancel();
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TapZap'),
        backgroundColor: Colors.redAccent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return GestureDetector(
            onPanUpdate: _onPanUpdate,
            child: Stack(
              children: [
                ..._eggs.map(
                  (egg) => Positioned(
                    top: egg.y * height,
                    left: egg.x * width,
                    child: const Text(
                      '\u{1F95A}', // 🥚
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),

                // Show cracked eggs
                ..._crackedEggs.map(
                  (crackedEgg) => Positioned(
                    top: crackedEgg.y * height,
                    left: crackedEgg.x * width,
                    child: const Text(
                      '\u{1F4A5}', // 💥 explosion
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                ),

                // Basket
                Positioned(
                  bottom: 20,
                  left: basketX * width - (width * _basketWidth) / 2,
                  child: Icon(
                    Icons.shopping_basket,
                    size: width * _basketWidth,
                    color: Colors.brown,
                  ),
                ),

                // Score Display
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Score: $score',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                // Timer Display
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Time: $_remainingTime s',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                // Game Over Screen
                if (_gameOver)
                  Center(
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Game Over!',
                            style: TextStyle(fontSize: 32, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Final Score: $score',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _restartGame,
                            child: const Text('Play Again'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
