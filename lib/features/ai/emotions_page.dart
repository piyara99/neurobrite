import 'package:flutter/material.dart';
import 'emotion_predictor.dart';

class EmotionsPage extends StatefulWidget {
  const EmotionsPage({Key? key}) : super(key: key);

  @override
  _EmotionsPageState createState() => _EmotionsPageState();
}

class _EmotionsPageState extends State<EmotionsPage> {
  final EmotionPredictor _predictor = EmotionPredictor();
  bool _modelLoaded = false;
  String _prediction = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    await _predictor.loadModel();
    setState(() {
      _modelLoaded = true;
    });
  }

  Future<void> _predictEmotion() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final result = await _predictor.predict(text);
    setState(() {
      _prediction = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emotion Predictor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            !_modelLoaded
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Enter text',
                        border: OutlineInputBorder(),
                      ),
                      minLines: 3,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _predictEmotion,
                      child: const Text('Predict Emotion'),
                    ),
                    const SizedBox(height: 24),
                    if (_prediction.isNotEmpty)
                      Text(
                        'Predicted Emotion: $_prediction',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
      ),
    );
  }
}
