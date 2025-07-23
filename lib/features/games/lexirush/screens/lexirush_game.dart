import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LexiRushGame extends StatefulWidget {
  const LexiRushGame({super.key});

  @override
  State<LexiRushGame> createState() => _LexiRushGameState();
}

class _LexiRushGameState extends State<LexiRushGame>
    with SingleTickerProviderStateMixin {
  // Constants
  static const int gameDurationSeconds = 60;
  static const Duration letterSpawnInterval = Duration(milliseconds: 1500);
  static const double playerWidth = 100.0;
  static const double playerHeight = 30.0;
  static const double letterSize = 50.0;
  static const int pointsPerLetter = 10;

  // Game data
  final List<String> vowels = ['A', 'E', 'I', 'O', 'U'];
  final List<String> consonants = [
    'B',
    'C',
    'D',
    'F',
    'G',
    'H',
    'J',
    'K',
    'L',
    'M',
    'N',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  // Game state
  late List<String> gameLetters;
  final Set<String> enteredWords = {};
  final TextEditingController _controller = TextEditingController();
  late Timer _gameTimer;
  late Timer _letterTimer;
  int _remainingSeconds = gameDurationSeconds;
  int _score = 0;
  String feedback = '';
  int _wordCount = 0;
  int _bestScore = 18;
  String difficulty = 'Medium';
  List<FallingLetter> fallingLetters = [];
  double _playerPosition = 0.5;
  bool _gameStarted = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // Colors
  final Color primaryColor = const Color(0xFF6C5CE7);
  final Color secondaryColor = const Color(0xFF00CEFF);
  final Color backgroundColor = const Color(0xFFF5F6FA);
  final Color textColor = const Color(0xFF2D3436);
  final Color accentColor = const Color(0xFFFD79A8);
  final Color successColor = const Color(0xFF00B894);
  final Color errorColor = const Color(0xFFD63031);

  // Dictionary - expanded with more words
  final Set<String> validWords = {
    // 3-letter words
    'BAT', 'TAB', 'CAB', 'CAT', 'ACT', 'ARC', 'CAR', 'BAR', 'RAT', 'ART',
    'TAR', 'BAG', 'TAG', 'BIG', 'DIG', 'DOG', 'GOD', 'LOG', 'FOG', 'FIG',
    'HAT', 'HOT', 'HIT', 'HUT', 'JET', 'JUG', 'KIT', 'KIN', 'LIT', 'LOT',
    'MAT', 'MAP', 'NAP', 'PAN', 'PEN', 'PIN', 'RAN', 'RUN', 'SUN', 'SIT',
    'TAN', 'TIN', 'WIN', 'WET', 'YET', 'ZIP', 'ZAP', 'VAN', 'CAN', 'FAN',
    'MAN', 'POT', 'TOP', 'MOP', 'COP', 'HOP', 'BED', 'RED', 'FED', 'LED',
    'SAW', 'WAS', 'RAW', 'LAW', 'PAW', 'JAW', 'COW', 'HOW', 'NOW', 'BOW',

    // 4-letter words
    'ABLE', 'BAKE', 'CAKE', 'DARE', 'EARN', 'FAME', 'GAME', 'HAIR', 'ITEM',
    'JAZZ', 'KIND', 'LAME', 'MAZE', 'NEAR', 'OPEN', 'PARK', 'QUIZ', 'RAIN',
    'SAME', 'TAME', 'USER', 'VAIN', 'WAVE', 'XRAY', 'YEAR', 'ZERO', 'BEAT',
    'BEAR', 'CARE', 'DARK', 'EAST', 'FACE', 'GAIN', 'HATE', 'ICEY', 'JUMP',
    'KEEP', 'LION', 'MILD', 'NICE', 'OVEN', 'PURE', 'QUIT', 'RICE', 'SOAP',
    'TIDE', 'UGLY', 'VOID', 'WILD', 'YANK', 'ZEST', 'BIRD', 'COAT', 'DEAF',

    // 5-letter words
    'ABOUT', 'ABOVE', 'ALERT', 'BEACH', 'CRANE', 'DANCE', 'EAGER', 'FAITH',
    'GIANT', 'HONEY', 'IVORY', 'JUMBO', 'KNIFE', 'LIGHT', 'MAGIC', 'NIGHT',
    'OCEAN', 'PEACH', 'QUILT', 'RADIO', 'SALAD', 'TABLE', 'UNITY', 'VALUE',
    'WORLD', 'YOUTH', 'ZEBRA',
  };

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _initializeAnimations();
  }

  void _initializeGame() {
    _generateLetters();
    _loadBestScore();
  }

  void _loadBestScore() {
    // In a real app, load from shared preferences
    _bestScore = 18;
  }

  void _saveBestScore() {
    // In a real app, save to shared preferences
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  void _generateLetters() {
    final rand = Random();
    gameLetters = [
      vowels[rand.nextInt(vowels.length)],
      vowels[rand.nextInt(vowels.length)],
      consonants[rand.nextInt(consonants.length)],
      consonants[rand.nextInt(consonants.length)],
      consonants[rand.nextInt(consonants.length)],
      consonants[rand.nextInt(consonants.length)],
      consonants[rand.nextInt(consonants.length)],
    ];
    gameLetters.shuffle();
  }

  void _startGame() {
    _resetGameState();
    _startTimers();
    setState(() => _gameStarted = true);
  }

  void _resetGameState() {
    setState(() {
      _remainingSeconds = gameDurationSeconds;
      _score = 0;
      _wordCount = 0;
      enteredWords.clear();
      feedback = '';
      fallingLetters.clear();
      _playerPosition = 0.5;
      _generateLetters();
    });
  }

  void _startTimers() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        _endGame();
        return;
      }
      setState(() => _remainingSeconds--);
    });

    _letterTimer = Timer.periodic(letterSpawnInterval, (timer) {
      if (_remainingSeconds <= 0 || !_gameStarted) {
        timer.cancel();
        return;
      }
      _spawnFallingLetter();
    });
  }

  void _spawnFallingLetter() {
    final rand = Random();
    setState(() {
      fallingLetters.add(
        FallingLetter(
          letter:
              rand.nextBool()
                  ? vowels[rand.nextInt(vowels.length)]
                  : consonants[rand.nextInt(consonants.length)],
          left: rand.nextDouble() * 0.8,
          speed: 1.0 + rand.nextDouble() * 2.0,
        ),
      );
    });
  }

  void _endGame() {
    _gameTimer.cancel();
    _letterTimer.cancel();

    if (_score > _bestScore) {
      _bestScore = _score;
      _saveBestScore();
    }

    setState(() {
      _gameStarted = false;
      feedback = 'Game Over! Final Score: $_score';
    });
  }

  void _submitWord() {
    final word = _controller.text.toUpperCase().trim();
    _controller.clear();

    if (!_validateGameState() || !_validateWord(word)) {
      return;
    }

    if (!_validateWordLetters(word)) {
      return;
    }

    _processValidWord(word);
  }

  bool _validateGameState() {
    if (!_gameStarted || _remainingSeconds <= 0) {
      setState(() => feedback = "Game not active");
      return false;
    }
    return true;
  }

  bool _validateWord(String word) {
    if (word.isEmpty) {
      setState(() => feedback = "Please enter a word!");
      return false;
    }

    if (enteredWords.contains(word)) {
      setState(() => feedback = "Word already used!");
      return false;
    }

    if (!validWords.contains(word)) {
      setState(() => feedback = "Invalid word ❌");
      return false;
    }

    return true;
  }

  bool _validateWordLetters(String word) {
    final collectedLetters =
        fallingLetters
            .where((fl) => fl.collected)
            .map((fl) => fl.letter)
            .toList();

    final tempLetters = List<String>.from(collectedLetters);

    for (var letter in word.split('')) {
      if (!tempLetters.remove(letter)) {
        setState(() => feedback = "Missing letter: $letter");
        return false;
      }
    }

    return true;
  }

  void _processValidWord(String word) {
    setState(() {
      enteredWords.add(word);
      _wordCount++;
      _score += word.length * pointsPerLetter;
      feedback = "Nice! +${word.length * pointsPerLetter} points ✅";

      _removeUsedLetters(word);
      _animationController.forward(from: 0.0);
    });
  }

  void _removeUsedLetters(String word) {
    final usedLetters = word.split('');
    for (var letter in usedLetters) {
      final index = fallingLetters.indexWhere(
        (fl) => fl.collected && fl.letter == letter,
      );
      if (index != -1) {
        fallingLetters.removeAt(index);
      }
    }
  }

  void _movePlayer(double delta, double screenWidth) {
    setState(() {
      _playerPosition += delta / (screenWidth - playerWidth);
      _playerPosition = _playerPosition.clamp(0.0, 1.0);
    });
  }

  void _collectLetter(FallingLetter fl) {
    if (!fl.collected) {
      setState(() {
        fl.collected = true;
        feedback = "Collected: ${fl.letter}";
      });
    }
  }

  @override
  void dispose() {
    _gameTimer.cancel();
    _letterTimer.cancel();
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (!_gameStarted) _buildStartScreen(),
                if (_gameStarted) _buildGameScreen(screenSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartScreen() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Text(
                "LexiRush",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Form words using collected letters before time runs out!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: textColor.withOpacity(0.8)),
          ),
          const SizedBox(height: 40),
          _buildInfoCard("Difficulty:", difficulty, Icons.speed),
          const SizedBox(height: 16),
          _buildInfoCard("Best Score:", "$_bestScore words", Icons.star),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _startGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: const Text(
              "Start Game",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameScreen(Size screenSize) {
    return Expanded(
      child: Column(
        children: [
          // Game stats
          _buildStatsPanel(),
          const SizedBox(height: 16),

          // Collected letters and feedback
          _buildFeedbackPanel(),
          const SizedBox(height: 16),

          // Game area
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Falling letters
                ..._buildFallingLetters(),

                // Player catcher
                _buildPlayerCatcher(screenSize.width),
              ],
            ),
          ),

          // Input area
          _buildInputPanel(),
        ],
      ),
    );
  }

  Widget _buildStatsPanel() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.timer, "$_remainingSeconds s"),
          _buildStatItem(Icons.star, "$_score"),
          _buildStatItem(Icons.list, "$_wordCount"),
        ],
      ),
    );
  }

  Widget _buildFeedbackPanel() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Collected: ${fallingLetters.where((fl) => fl.collected).map((fl) => fl.letter).join(' ')}",
            style: TextStyle(
              fontSize: 18,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          feedback,
          style: TextStyle(
            fontSize: 16,
            color: feedback.contains("❌") ? errorColor : successColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFallingLetters() {
    return fallingLetters.map((fl) {
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 100),
        left: fl.left * (MediaQuery.of(context).size.width - letterSize),
        top: fl.top,
        child: GestureDetector(
          onTap: () => _collectLetter(fl),
          child: Container(
            width: letterSize,
            height: letterSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  fl.collected ? primaryColor.withOpacity(0.7) : Colors.white,
              borderRadius: BorderRadius.circular(letterSize / 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: fl.collected ? Colors.white : primaryColor,
                width: 2,
              ),
            ),
            child: Text(
              fl.letter,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: fl.collected ? Colors.white : primaryColor,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildPlayerCatcher(double screenWidth) {
    return Positioned(
      left: _playerPosition * (screenWidth - playerWidth),
      bottom: 20,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          _movePlayer(details.delta.dx, screenWidth);
        },
        child: Container(
          width: playerWidth,
          height: playerHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(playerHeight / 2),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputPanel() {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.characters,
                    onSubmitted: (_) => _submitWord(),
                    style: TextStyle(
                      fontSize: 18,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: "Type a word...",
                      hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
                      filled: true,
                      fillColor: backgroundColor,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color: primaryColor),
                        onPressed: _submitWord,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _generateLetters,
                  backgroundColor: primaryColor,
                  mini: true,
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _endGame,
              style: TextButton.styleFrom(
                foregroundColor: accentColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("END GAME"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: secondaryColor),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.6),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: secondaryColor, size: 20),
        const SizedBox(width: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class FallingLetter {
  final String letter;
  final double left;
  double top = 0;
  final double speed;
  bool collected = false;

  FallingLetter({
    required this.letter,
    required this.left,
    required this.speed,
  });
}
