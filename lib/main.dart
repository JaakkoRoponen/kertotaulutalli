import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Helper widget for button press animation
class AnimatedPressButton extends StatefulWidget {
  final Widget child;
  const AnimatedPressButton({super.key, required this.child});

  @override
  State<AnimatedPressButton> createState() => _AnimatedPressButtonState();
}

class _AnimatedPressButtonState extends State<AnimatedPressButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}

// Falling stars animation for perfect score
class _FallingStars extends StatefulWidget {
  @override
  State<_FallingStars> createState() => _FallingStarsState();
}

class _FallingStarsState extends State<_FallingStars>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Star> stars = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Create stars
    for (int i = 0; i < 20; i++) {
      stars.add(
        _Star(
          x: random.nextDouble(),
          delay: random.nextDouble(),
          size: 15 + random.nextDouble() * 15,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _StarsPainter(stars, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Star {
  final double x;
  final double delay;
  final double size;

  _Star({required this.x, required this.delay, required this.size});
}

class _StarsPainter extends CustomPainter {
  final List<_Star> stars;
  final double progress;

  _StarsPainter(this.stars, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.amber.shade200;

    for (final star in stars) {
      // Use modulo to create continuous falling effect
      double adjustedProgress = (progress + star.delay) % 1.0;
      final x = star.x * size.width;
      final y = adjustedProgress * size.height;
      canvas.drawCircle(Offset(x, y), star.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(_StarsPainter oldDelegate) => true;
}

// Sparkles animation for good score
class _Sparkles extends StatefulWidget {
  @override
  State<_Sparkles> createState() => _SparklesState();
}

class _SparklesState extends State<_Sparkles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Sparkle> sparkles = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Create sparkles
    for (int i = 0; i < 30; i++) {
      sparkles.add(
        _Sparkle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          delay: random.nextDouble(),
          size: 8 + random.nextDouble() * 8,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _SparklesPainter(sparkles, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Sparkle {
  final double x;
  final double y;
  final double delay;
  final double size;

  _Sparkle({
    required this.x,
    required this.y,
    required this.delay,
    required this.size,
  });
}

class _SparklesPainter extends CustomPainter {
  final List<_Sparkle> sparkles;
  final double progress;

  _SparklesPainter(this.sparkles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final sparkle in sparkles) {
      double adjustedProgress = (progress - sparkle.delay).clamp(0.0, 1.0);
      if (adjustedProgress > 0) {
        final opacity = (1 - (adjustedProgress - 0.5).abs() * 2).clamp(
          0.0,
          1.0,
        );
        final paint = Paint()
          ..color = Colors.amber.shade200.withOpacity(opacity * 0.9)
          ..style = PaintingStyle.fill;

        final x = sparkle.x * size.width;
        final y = sparkle.y * size.height;
        final scale = opacity * sparkle.size;

        canvas.drawCircle(Offset(x, y), scale / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SparklesPainter oldDelegate) => true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kertotaulutalli',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          primary: Colors.brown,
          secondary: Colors.amber,
        ),
        useMaterial3: true,
      ),
      home: const TableSelectionScreen(),
    );
  }
}

enum Difficulty { easy, medium, hard, master }

class TableSelectionScreen extends StatefulWidget {
  const TableSelectionScreen({super.key});

  @override
  State<TableSelectionScreen> createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends State<TableSelectionScreen> {
  Difficulty selectedDifficulty = Difficulty.medium;
  int? selectedTable = 7;

  int getTimerSeconds() {
    switch (selectedDifficulty) {
      case Difficulty.easy:
        return 20;
      case Difficulty.medium:
        return 10;
      case Difficulty.hard:
        return 6;
      case Difficulty.master:
        return 3;
    }
  }

  String getDifficultyName(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 'Käynti';
      case Difficulty.medium:
        return 'Ravi';
      case Difficulty.hard:
        return 'Laukka';
      case Difficulty.master:
        return 'Kiitolaukka';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('🐴 Kertotaulutalli 🐴'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.brown.shade100, Colors.amber.shade50],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🐴 Valitse hevosesi:',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 25),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: List.generate(10, (index) {
                  final number = index + 1;
                  final isSelected = selectedTable == number;
                  return AnimatedPressButton(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedTable = number;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Colors.brown
                            : Colors.brown.shade300,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(24),
                        minimumSize: const Size(80, 80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        '$number',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              const Text(
                '🐎 Vauhti:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: Difficulty.values.map((difficulty) {
                  final isSelected = selectedDifficulty == difficulty;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AnimatedPressButton(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedDifficulty = difficulty;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Colors.brown
                              : Colors.brown.shade300,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '🐎 ${getDifficultyName(difficulty)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              AnimatedPressButton(
                child: ElevatedButton(
                  onPressed: selectedTable == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                table: selectedTable!,
                                timerSeconds: getTimerSeconds(),
                                difficulty: selectedDifficulty,
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '🐴 Ratsasta! 🐴',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final int table;
  final int timerSeconds;
  final Difficulty difficulty;

  const QuizScreen({
    super.key,
    required this.table,
    required this.timerSeconds,
    required this.difficulty,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int score = 0;
  int currentRound = 0;
  int currentMultiplier = 1;
  int correctAnswer = 0;
  int? selectedAnswer;
  List<int> options = [];
  List<int> multiplierOrder = [];
  double timeProgress = 1.0;
  Timer? timer;
  bool showFeedback = false;
  bool wasCorrect = false;
  bool gameFinished = false;
  final Random random = Random();
  static const int totalRounds = 10;
  final AudioPlayer _audioPlayer = AudioPlayer();

  late AnimationController _bounceController;
  late AnimationController _shakeController;
  late AnimationController _pulseController;
  late AnimationController _scoreController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();

    // Bounce animation for correct answer
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _bounceAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.95), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
        );

    // Shake animation for wrong answer
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.linear));

    // Pulse animation for amber border
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Score increment animation
    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scoreAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 1),
      ],
    ).animate(CurvedAnimation(parent: _scoreController, curve: Curves.easeOut));

    // Generate random order of multipliers (1-10)
    multiplierOrder = List.generate(10, (index) => index + 1);
    multiplierOrder.shuffle();

    // Play start sound
    playSound('start.mp3');

    generateQuestion();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _shakeController.dispose();
    _pulseController.dispose();
    _scoreController.dispose();
    _audioPlayer.dispose();
    timer?.cancel();
    super.dispose();
  }

  void generateQuestion() {
    if (currentRound >= totalRounds) {
      setState(() {
        gameFinished = true;
      });
      // Play perfect sound if score is perfect
      if (score == totalRounds) {
        playSound('perfect.mp3');
      }
      return;
    }

    setState(() {
      showFeedback = false;
      selectedAnswer = null;
      currentMultiplier = multiplierOrder[currentRound];
      correctAnswer = widget.table * currentMultiplier;

      // Generate 3 options including the correct answer
      options = [correctAnswer];

      // Add 2 wrong answers
      while (options.length < 3) {
        // Generate nearby wrong answers from the same table
        int wrongMultiplier = random.nextInt(10) + 1;
        int wrongAnswer = widget.table * wrongMultiplier;
        if (!options.contains(wrongAnswer)) {
          options.add(wrongAnswer);
        }
      }

      // Shuffle options
      options.shuffle();

      // Reset and start timer
      timeProgress = 1.0;
      startTimer();
    });
  }

  void startTimer() {
    timer?.cancel();
    final totalDuration = Duration(seconds: widget.timerSeconds);
    const tickDuration = Duration(milliseconds: 50);
    int ticks = 0;
    final totalTicks =
        totalDuration.inMilliseconds ~/ tickDuration.inMilliseconds;

    timer = Timer.periodic(tickDuration, (timer) {
      ticks++;
      setState(() {
        timeProgress = 1.0 - (ticks / totalTicks);
      });

      if (timeProgress <= 0) {
        timer.cancel();
        handleTimeout();
      }
    });
  }

  void handleTimeout() {
    setState(() {
      showFeedback = true;
      wasCorrect = false;
    });

    playSound('wrong.mp3');

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        currentRound++;
        generateQuestion();
      }
    });
  }

  Future<void> playSound(String soundFile, {double volume = 1.0}) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setVolume(volume);
      await _audioPlayer.play(AssetSource('sounds/$soundFile'));
    } catch (e) {
      // Silently handle audio errors
    }
  }

  void handleAnswer(int answer) {
    timer?.cancel();

    setState(() {
      selectedAnswer = answer;
      showFeedback = true;
      wasCorrect = answer == correctAnswer;
      if (wasCorrect) {
        score++;
        _bounceController.forward(from: 0);
        _scoreController.forward(from: 0);
        playSound('correct.mp3');
      } else {
        _shakeController.forward(from: 0);
        playSound('wrong.mp3');
      }
    });

    // Show feedback longer for wrong answers
    final feedbackDuration = wasCorrect
        ? const Duration(seconds: 2)
        : const Duration(seconds: 3);

    Future.delayed(feedbackDuration, () {
      if (mounted) {
        currentRound++;
        generateQuestion();
      }
    });
  }

  String getResultMessage() {
    if (score == totalRounds) {
      return '🐴 Mestariratsu! 🐴';
    } else if (score >= 7) {
      return '🥕 Hyvää laukkaa! 🥕';
    } else {
      return '🌾 Harjoittele käynnissä! 🌾';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (gameFinished) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          title: const Text('🐴 Peli päättyi! 🐴'),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.brown.shade100, Colors.amber.shade50],
            ),
          ),
          child: Stack(
            children: [
              // Background animation based on score
              if (score == totalRounds)
                _FallingStars()
              else if (score >= 7)
                _Sparkles()
              else
                Container(),
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bounce animation for practice more message
                    if (score < 7)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: 0.5 + (value * 0.5),
                            child: child,
                          );
                        },
                        child: Text(
                          getResultMessage(),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      Text(
                        getResultMessage(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 40),
                    Text(
                      'Sait $score / $totalRounds pistettä!',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        '🐴 Takaisin tallille',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    String getDifficultyName() {
      switch (widget.difficulty) {
        case Difficulty.easy:
          return 'Käynti';
        case Difficulty.medium:
          return 'Ravi';
        case Difficulty.hard:
          return 'Laukka';
        case Difficulty.master:
          return 'Kiitolaukka';
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text(
          '🐴 Kertotaulu ${widget.table} - ${getDifficultyName()} 🐴',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Kierros ${currentRound + 1}/$totalRounds',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _scoreAnimation,
                    builder: (context, child) => Transform.scale(
                      scale: _scoreAnimation.value,
                      child: child,
                    ),
                    child: Text(
                      'Pisteet: $score',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.brown.shade100, Colors.amber.shade50],
          ),
        ),
        child: Column(
          children: [
            // Timer progress bar
            LinearProgressIndicator(
              value: timeProgress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                timeProgress > 0.3 ? Colors.green : Colors.red,
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Question
                      Text(
                        '$currentMultiplier × ${widget.table} = ?',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Answer options
                      ...options.map((option) {
                        Color buttonColor = Colors.brown;
                        Color disabledColor = Colors.grey;
                        BorderSide border = const BorderSide(
                          color: Colors.transparent,
                          width: 4,
                        );
                        String symbol = '';

                        if (showFeedback) {
                          if (option == selectedAnswer) {
                            // This is the button the user clicked
                            if (wasCorrect) {
                              buttonColor = Colors.green;
                              disabledColor = Colors.green;
                              symbol = '✓';
                            } else {
                              buttonColor = Colors.red;
                              disabledColor = Colors.red;
                              symbol = '✗';
                            }
                          } else if (option == correctAnswer && !wasCorrect) {
                            // Show the correct answer with amber border if user was wrong
                            border = const BorderSide(
                              color: Colors.amber,
                              width: 4,
                            );
                            symbol = '✓';
                          }
                        }

                        // Determine which animation to use
                        Widget buttonWidget = ElevatedButton(
                          onPressed: showFeedback
                              ? null
                              : () => handleAnswer(option),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: disabledColor,
                            disabledForegroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 24,
                            ),
                            fixedSize: const Size(200, 72),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: border,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Always centered number
                              Center(
                                child: Text(
                                  '$option',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Symbol positioned to the left of center
                              if (symbol.isNotEmpty)
                                Center(
                                  child: Transform.translate(
                                    offset: const Offset(-40, 0),
                                    child: Text(
                                      symbol,
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );

                        // Apply animations based on state
                        if (showFeedback &&
                            option == selectedAnswer &&
                            wasCorrect) {
                          // Bounce animation for correct answer
                          buttonWidget = AnimatedBuilder(
                            animation: _bounceAnimation,
                            builder: (context, child) => Transform.scale(
                              scale: _bounceAnimation.value,
                              child: child,
                            ),
                            child: buttonWidget,
                          );
                        } else if (showFeedback &&
                            option == selectedAnswer &&
                            !wasCorrect) {
                          // Shake animation for wrong answer
                          buttonWidget = AnimatedBuilder(
                            animation: _shakeAnimation,
                            builder: (context, child) => Transform.translate(
                              offset: Offset(_shakeAnimation.value, 0),
                              child: child,
                            ),
                            child: buttonWidget,
                          );
                        } else if (showFeedback &&
                            option == correctAnswer &&
                            !wasCorrect) {
                          // Pulse animation for correct answer (amber border)
                          buttonWidget = AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) => Transform.scale(
                              scale: _pulseAnimation.value,
                              child: child,
                            ),
                            child: buttonWidget,
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: buttonWidget,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
