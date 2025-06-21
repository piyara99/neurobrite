import 'package:flutter/material.dart';

class StreakCard extends StatelessWidget {
  final int days;

  const StreakCard({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.orange,
            size: 36,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Daily Streak",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text("$days day${days > 1 ? 's' : ''} in a row! 🔥"),
            ],
          ),
        ],
      ),
    );
  }
}
