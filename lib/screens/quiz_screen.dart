import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/audio_helper.dart';
import '../utils/constants.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final int table;
  final Difficulty difficulty;
  final bool soundEnabled;

  const QuizScreen({
    super.key,
    required this.table,
    required this.difficulty,
    required this.soundEnabled,
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
  int correctAnswerCount = 0;
  final Random random = Random();
  final AudioHelper audioHelper = AudioHelper();

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

    // Play start sound if enabled
    if (widget.soundEnabled) {
      audioHelper.playSound('start.mp3');
    }

    generateQuestion();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _shakeController.dispose();
    _pulseController.dispose();
    _scoreController.dispose();
    audioHelper.dispose();
    timer?.cancel();
    super.dispose();
  }

  void generateQuestion() {
    if (currentRound >= GameConstants.totalRounds) {
      setState(() {
        gameFinished = true;
      });
      // Navigate to result screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultScreen(score: score, soundEnabled: widget.soundEnabled),
        ),
      );
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
    final timerSeconds = GameConstants.getTimerSeconds(widget.difficulty);
    final totalDuration = Duration(seconds: timerSeconds);
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

    audioHelper.playSound('wrong.mp3');

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        currentRound++;
        generateQuestion();
      }
    });
  }

  void handleAnswer(int answer) {
    timer?.cancel();

    setState(() {
      selectedAnswer = answer;
      showFeedback = true;
      wasCorrect = answer == correctAnswer;
      if (wasCorrect) {
        score++;
        correctAnswerCount++;
        _bounceController.forward(from: 0);
        _scoreController.forward(from: 0);
        // Only play sound on the first correct answer
        if (widget.soundEnabled && correctAnswerCount == 1) {
          audioHelper.playSound('correct.mp3');
        }
      } else {
        _shakeController.forward(from: 0);
        if (widget.soundEnabled) {
          audioHelper.playSound('wrong.mp3');
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text(
          '🐴 Kertotaulu ${widget.table} - ${GameConstants.getDifficultyName(widget.difficulty)} 🐴',
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
                    'Kierros ${currentRound + 1}/${GameConstants.totalRounds}',
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
                child: SizedBox(
                  width: double.infinity,
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
                          IconData? symbolIcon;

                          if (showFeedback) {
                            if (option == selectedAnswer) {
                              // This is the button the user clicked
                              if (wasCorrect) {
                                buttonColor = Colors.green;
                                disabledColor = Colors.green;
                                symbolIcon = Icons.check;
                              } else {
                                buttonColor = Colors.red;
                                disabledColor = Colors.red;
                                symbolIcon = Icons.close;
                              }
                            } else if (option == correctAnswer && !wasCorrect) {
                              // Show the correct answer with amber border if user was wrong
                              border = const BorderSide(
                                color: Colors.amber,
                                width: 4,
                              );
                              symbolIcon = Icons.check;
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
                                if (symbolIcon != null)
                                  Center(
                                    child: Transform.translate(
                                      offset: const Offset(-40, 0),
                                      child: Icon(
                                        symbolIcon,
                                        size: 32,
                                        color: Colors.white,
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
            ),
          ],
        ),
      ),
    );
  }
}
