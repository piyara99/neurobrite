import 'package:flutter/material.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  final List<Map<String, dynamic>> games = const [
    {
      'title': 'Light Grid',
      'description': 'Boost your visual memory',
      'icon': Icons.grid_view,
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
      'description': 'Build word skills quickly',
      'icon': Icons.spellcheck,
      'color': Colors.blueAccent,
    },
    {
      'title': 'Pathfinder',
      'description': 'Improve your logic & pathing',
      'icon': Icons.alt_route,
      'color': Colors.green,
    },
    {
      'title': 'FaceRead',
      'description': 'Practice emotion recognition',
      'icon': Icons.face_retouching_natural,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game Library"),
        backgroundColor: Colors.indigo.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          itemCount: games.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final game = games[index];
            return _GameLibraryCard(
              title: game['title'],
              description: game['description'],
              icon: game['icon'],
              color: game['color'],
              onTap: () {
                // 🔁 Routing logic here
                if (game['title'] == 'Light Grid') {
                  Navigator.pushNamed(context, '/light-grid');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${game['title']} is coming soon!')),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class _GameLibraryCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GameLibraryCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      color: color.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
