import 'package:flutter/material.dart';

class PathfinderGame extends StatefulWidget {
  const PathfinderGame({super.key});

  @override
  State<PathfinderGame> createState() => _PathfinderGameState();
}

class _PathfinderGameState extends State<PathfinderGame> {
  final int gridSize = 5;
  late List<List<int>> grid;
  int playerX = 0;
  int playerY = 0;
  int goalX = 4;
  int goalY = 4;
  int moves = 0;

  final Set<String> walls = {
    "0,1", "1,1", "2,3", "3,3", "3,1", "4,2", // Sample wall positions
  };

  @override
  void initState() {
    super.initState();
    _generateGrid();
  }

  void _generateGrid() {
    grid = List.generate(gridSize, (_) => List.filled(gridSize, 0));
  }

  bool _canMoveTo(int x, int y) {
    if (x < 0 || y < 0 || x >= gridSize || y >= gridSize) return false;
    return !walls.contains("$x,$y");
  }

  void _move(int dx, int dy) {
    final newX = playerX + dx;
    final newY = playerY + dy;
    if (_canMoveTo(newX, newY)) {
      setState(() {
        playerX = newX;
        playerY = newY;
        moves++;
      });
      if (playerX == goalX && playerY == goalY) {
        _showWinDialog();
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("You Did It! 🎉"),
            content: Text("You reached the goal in $moves moves."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _restartGame();
                },
                child: const Text("Play Again"),
              ),
            ],
          ),
    );
  }

  void _restartGame() {
    setState(() {
      playerX = 0;
      playerY = 0;
      moves = 0;
    });
  }

  Widget _buildCell(int x, int y) {
    Color color;
    if (x == playerX && y == playerY) {
      color = Colors.indigo;
    } else if (x == goalX && y == goalY) {
      color = Colors.green;
    } else if (walls.contains("$x,$y")) {
      color = Colors.black;
    } else {
      color = Colors.grey[300]!;
    }

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pathfinder"),
        backgroundColor: themeColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text("Moves: $moves", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              itemCount: gridSize * gridSize,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final x = index ~/ gridSize;
                final y = index % gridSize;
                return _buildCell(x, y);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _DirectionButton("←", () => _move(0, -1)),
              Column(
                children: [
                  _DirectionButton("↑", () => _move(-1, 0)),
                  const SizedBox(height: 4),
                  _DirectionButton("↓", () => _move(1, 0)),
                ],
              ),
              _DirectionButton("→", () => _move(0, 1)),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _DirectionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _DirectionButton(this.label, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade400,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }
}
