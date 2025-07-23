import 'package:flutter/material.dart';
import 'package:neurobrite/features/games/screens/games_screen.dart';
import 'package:neurobrite/features/gamification/screens/rewards_screen.dart';
import 'package:neurobrite/features/tracker/screens/performance_tracker_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/brain_circuit/screens/brain_circuit_screen.dart';
import '../features/games/light_grid/screens/light_grid_game.dart';
import '../features/games/tapzap/screens/tapzap_game.dart';
import '../features/games/lexirush/screens/lexirush_game.dart';
import '../features/games/pathfinder/screens/pathfinder_game.dart';
import '../features/games/faceread/screens/faceread_game.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/caregiver/screens/caregiver_screen.dart';
import '../features/ai/emotions_page.dart';

class AppRoutes {
  static const String home = '/';
  static const brainCircuit = '/brain-circuit';
  static const lightGrid = '/light-grid';
  static const tapZap = '/tapzap';
  static const lexiRush = '/lexirush';
  static const pathfinder = '/pathfinder';
  static const faceRead = '/faceread';
  static const tracker = '/tracker';
  static const rewards = '/rewards';
  static const games = '/games';
  static const settings = '/settings';
  static const caregiver = '/caregiver';
  static const emotions = '/emotions';

  static final routes = <String, WidgetBuilder>{
    home: (_) => const HomeScreen(),
    brainCircuit: (_) => const BrainCircuitScreen(),
    lightGrid: (_) => const LightGridGame(),
    tapZap: (_) => const TapZapGame(),
    lexiRush: (_) => const LexiRushGame(),
    pathfinder: (_) => const PathfinderGame(),
    faceRead: (_) => const FaceReadGame(),
    tracker: (_) => const PerformanceTrackerScreen(),
    rewards: (_) => const RewardsScreen(),
    games: (_) => const GamesScreen(),
    settings: (_) => const SettingsScreen(),
    caregiver: (_) => const CaregiverScreen(),
    emotions: (_) => const EmotionsPage(),
  };
}
