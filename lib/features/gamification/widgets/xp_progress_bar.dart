import 'package:flutter/material.dart';

class XPProgressBar extends StatelessWidget {
  final int currentXP;
  final int level;
  final int xpForNextLevel;

  const XPProgressBar({
    super.key,
    required this.currentXP,
    required this.level,
    required this.xpForNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    double percent = currentXP / xpForNextLevel;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Level $level"),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percent,
            minHeight: 12,
            backgroundColor: Colors.indigo.shade100,
            color: Colors.indigo,
          ),
          const SizedBox(height: 8),
          Text("XP: $currentXP / $xpForNextLevel"),
        ],
      ),
    );
  }
}
