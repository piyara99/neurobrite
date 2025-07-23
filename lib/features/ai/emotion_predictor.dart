import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class EmotionPredictor {
  late Interpreter _interpreter;
  late List<String> _labels;
  late Map<String, int> _vocab;
  final int maxLen = 20;

  Future<void> loadModel() async {
    print('Loading TFLite model...');
    _interpreter = await Interpreter.fromAsset('models/text_emotion.tflite');
    print('Model loaded successfully.');

    print('Loading labels...');
    final labelData = await rootBundle.loadString('assets/models/labels.txt');
    _labels = labelData.split('\n').map((e) => e.trim()).toList();
    print('Labels loaded: $_labels');

    print('Loading vocabulary...');
    final vocabJson = await rootBundle.loadString('assets/models/vocab.json');
    _vocab = Map<String, int>.from(json.decode(vocabJson));
    print('Vocabulary loaded, total words: ${_vocab.length}');
  }

  List<int> _tokenize(String text) {
    List<String> words = text.toLowerCase().split(' ');
    List<int> tokens = words.map((w) => _vocab[w] ?? 0).toList();

    // Padding to maxLen
    if (tokens.length > maxLen) {
      tokens = tokens.sublist(0, maxLen);
    } else {
      tokens = List.filled(maxLen - tokens.length, 0) + tokens;
    }

    return tokens;
  }

  Future<String> predict(String text) async {
    final input = [_tokenize(text)];
    final output = List.filled(
      1 * _labels.length,
      0.0,
    ).reshape([1, _labels.length]);

    _interpreter.run(input, output);

    final result = output[0];
    final maxIndex = result.indexOf(result.reduce((a, b) => a > b ? a : b));

    return _labels[maxIndex];
  }
}
