import 'package:flutter/material.dart';

class CaregiverScreen extends StatelessWidget {
  const CaregiverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.indigo;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Caregiver Panel"),
        backgroundColor: themeColor.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Patient Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _InfoCard(label: "Name", value: "John Doe", icon: Icons.person),
            _InfoCard(label: "Age", value: "67", icon: Icons.cake),
            _InfoCard(
              label: "Condition",
              value: "Post-stroke recovery",
              icon: Icons.healing,
            ),

            const SizedBox(height: 30),
            const Text(
              "Recent Performance",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _StatBox(label: "Focus", value: "74%"),
                _StatBox(label: "Memory", value: "81%"),
                _StatBox(label: "Speed", value: "68%"),
              ],
            ),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Future export logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Performance report exported.")),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text("Export Report"),
              style: ElevatedButton.styleFrom(backgroundColor: themeColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(label),
      subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE3E6EA)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
