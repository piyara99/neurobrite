import 'package:flutter/material.dart';
import 'package:neurobrite/features/gamification/widgets/xp_progress_bar.dart';
import 'package:neurobrite/features/gamification/widgets/streak_card.dart';
import 'package:neurobrite/features/gamification/widgets/achievement_badge.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int currentXP = 1350;
    final int level = 6;
    final int xpForNextLevel = 1750;
    final int streakDays = 4;

    final List<Achievement> achievements = [
      Achievement(title: '5-Day Streak', icon: Icons.calendar_today),
      Achievement(title: 'First Win', icon: Icons.emoji_events),
      Achievement(title: 'Focus Master', icon: Icons.bolt),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
        backgroundColor: Colors.indigo.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Progress",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 🧪 XP Progress Bar
            XPProgressBar(
              currentXP: currentXP,
              level: level,
              xpForNextLevel: xpForNextLevel,
            ),
            const SizedBox(height: 32),

            // 🔥 Daily Streak
            StreakCard(days: streakDays),
            const SizedBox(height: 32),

            // 🥇 Achievements
            const Text(
              "Achievements",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children:
                  achievements
                      .map(
                        (a) => AchievementBadge(title: a.title, icon: a.icon),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class Achievement {
  final String title;
  final IconData icon;

  Achievement({required this.title, required this.icon});
}
