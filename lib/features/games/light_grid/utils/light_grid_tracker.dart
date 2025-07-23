// lib/features/games/light_grid/utils/light_grid_tracker.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/light_grid_result.dart';

class LightGridTracker {
  static final _db = FirebaseFirestore.instance;
  static final _resultsCollection = _db.collection('light_grid_results');

  static Future<void> saveResult(LightGridResult result) async {
    await _resultsCollection.add(result.toJson());
  }

  static Future<List<LightGridResult>> fetchRecentResults({
    int limit = 10,
  }) async {
    final querySnapshot =
        await _resultsCollection
            .orderBy('timestamp', descending: true)
            .limit(limit)
            .get();

    return querySnapshot.docs
        .map((doc) => LightGridResult.fromJson(doc.data()))
        .toList();
  }
}
