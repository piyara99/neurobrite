// lib/features/games/light_grid/models/light_grid_result.dart

class LightGridResult {
  final int gridSize;
  final bool correct;
  final int timeTaken; // in milliseconds
  final DateTime timestamp;

  LightGridResult({
    required this.gridSize,
    required this.correct,
    required this.timeTaken,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'gridSize': gridSize,
    'correct': correct,
    'timeTaken': timeTaken,
    'timestamp': timestamp.toIso8601String(),
  };

  factory LightGridResult.fromJson(Map<String, dynamic> json) {
    return LightGridResult(
      gridSize: json['gridSize'],
      correct: json['correct'],
      timeTaken: json['timeTaken'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
