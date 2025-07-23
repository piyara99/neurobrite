import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool voiceNavEnabled = true;
  double fontSize = 16;

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.indigo;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: themeColor.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Personalization",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 🌗 Theme toggle
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: isDarkMode,
              onChanged: (value) {
                setState(() => isDarkMode = value);
              },
              secondary: const Icon(Icons.dark_mode),
            ),

            // 🔈 Voice navigation
            SwitchListTile(
              title: const Text("Voice Navigation"),
              value: voiceNavEnabled,
              onChanged: (value) {
                setState(() => voiceNavEnabled = value);
              },
              secondary: const Icon(Icons.record_voice_over),
            ),

            const SizedBox(height: 24),
            const Text(
              "Accessibility",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 🔠 Font Size Slider
            ListTile(
              title: const Text("Font Size"),
              subtitle: Slider(
                min: 12,
                max: 24,
                value: fontSize,
                onChanged: (value) {
                  setState(() => fontSize = value);
                },
              ),
              trailing: Text("${fontSize.toInt()}px"),
            ),
            const SizedBox(height: 12),

            // 🔁 Reset Button
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isDarkMode = false;
                  voiceNavEnabled = true;
                  fontSize = 16;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Reset to Default"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
