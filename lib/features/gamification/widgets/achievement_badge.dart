import 'package:flutter/material.dart';

class AchievementBadge extends StatelessWidget {
  final String title;
  final IconData icon;

  const AchievementBadge({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.purple.shade100,
          child: Icon(icon, size: 30, color: Colors.purple),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
