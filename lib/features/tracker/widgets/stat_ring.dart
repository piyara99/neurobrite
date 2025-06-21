import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatRing extends StatelessWidget {
  final String label;
  final double value;

  const StatRing({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: value,
                  color: Colors.indigo,
                  radius: 18,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: 100 - value,
                  color: Colors.grey[300],
                  radius: 18,
                  showTitle: false,
                ),
              ],
              centerSpaceRadius: 26,
              sectionsSpace: 0,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${value.toInt()}%",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
