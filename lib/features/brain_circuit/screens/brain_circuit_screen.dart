import 'package:flutter/material.dart';
import 'package:neurobrite/routes/app_routes.dart';

class BrainCircuitScreen extends StatelessWidget {
  const BrainCircuitScreen({super.key});

  final List<Map<String, dynamic>> _games = const [
    {
      'title': 'Light Grid',
      'description': 'Boost your visual memory',
      'icon': Icons.grid_4x4,
      'color': Colors.amber,
    },
    {
      'title': 'TapZap',
      'description': 'Sharpen your reaction time',
      'icon': Icons.flash_on,
      'color': Colors.redAccent,
    },
    {
      'title': 'LexiRush',
      'description': 'Build quick word associations',
      'icon': Icons.spellcheck,
      'color': Colors.blueAccent,
    },
    {
      'title': 'Pathfinder',
      'description': 'Strengthen your logic skills',
      'icon': Icons.route,
      'color': Colors.green,
    },
    {
      'title': 'FaceRead',
      'description': 'Practice emotion recognition',
      'icon': Icons.emoji_emotions,
      'color': Colors.purpleAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Brain Circuit"),
        backgroundColor: Colors.indigo.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Workout 🧠",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "2 of 5 games completed",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // List of game cards
            Expanded(
              child: ListView.separated(
                itemCount: _games.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final game = _games[index];
                  return _GameCard(
                    title: game['title'],
                    description: game['description'],
                    icon: game['icon'],
                    color: game['color'],
                    onPlay: () {
                      if (game['title'] == 'Light Grid') {
                        Navigator.pushNamed(context, '/light-grid');
                      }
                      if (game['title'] == 'TapZap') {
                        Navigator.pushNamed(context, AppRoutes.tapZap);
                      }
                      if (game['title'] == 'LexiRush') {
                        Navigator.pushNamed(context, AppRoutes.lexiRush);
                      }
                      if (game['title'] == 'Pathfinder') {
                        Navigator.pushNamed(context, AppRoutes.pathfinder);
                      }
                      if (game['title'] == 'FaceRead') {
                        Navigator.pushNamed(context, AppRoutes.faceRead);
                      } else {}
                    },
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

class _GameCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onPlay;

  const _GameCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.3),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onPlay,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Play"),
          ),
        ],
      ),
    );
  }
}
