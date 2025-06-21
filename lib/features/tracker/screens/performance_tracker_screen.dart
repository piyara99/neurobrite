import 'package:flutter/material.dart';
import 'package:neurobrite/features/tracker/widgets/stat_ring.dart';
import 'package:neurobrite/features/tracker/widgets/progress_chart.dart';

class PerformanceTrackerScreen extends StatelessWidget {
  const PerformanceTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = {'Focus': 72, 'Memory': 88, 'Logic': 64};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Tracker'),
        backgroundColor: Colors.indigo.shade600,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Brain Progress",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Stat Rings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  stats.entries
                      .map(
                        (entry) => StatRing(
                          label: entry.key,
                          value: entry.value.toDouble(),
                        ),
                      )
                      .toList(),
            ),

            const SizedBox(height: 32),
            const Text(
              "Weekly Score Trend",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            const ProgressChart(), // Line chart

            const SizedBox(height: 32),
            const Text(
              "XP Level",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Level 6"),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.76,
                    minHeight: 12,
                    color: Colors.indigo,
                    backgroundColor: Colors.indigo.shade100,
                  ),
                  const SizedBox(height: 8),
                  const Text("XP: 1320 / 1750"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
