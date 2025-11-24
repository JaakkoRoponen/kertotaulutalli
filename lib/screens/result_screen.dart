import 'package:flutter/material.dart';

import '../utils/audio_helper.dart';
import '../utils/constants.dart';
import '../widgets/falling_stars.dart';
import '../widgets/sparkles.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final bool soundEnabled;

  const ResultScreen({
    super.key,
    required this.score,
    required this.soundEnabled,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final AudioHelper audioHelper = AudioHelper();

  @override
  void initState() {
    super.initState();
    // Play perfect sound if score is perfect and sound is enabled
    if (widget.soundEnabled && widget.score == GameConstants.totalRounds) {
      audioHelper.playSound('perfect.mp3');
    }
  }

  @override
  void dispose() {
    audioHelper.dispose();
    super.dispose();
  }

  String getResultMessage() {
    if (widget.score == GameConstants.totalRounds) {
      return '🐴 Mestariratsu! 🐴';
    } else if (widget.score >= 7) {
      return '🥕 Hyvää laukkaa! 🥕';
    } else {
      return '🌾 Harjoittele käynnissä! 🌾';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('🐴 Peli päättyi! 🐴'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
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
                if (widget.score == GameConstants.totalRounds)
                  const FallingStars()
                else if (widget.score >= 7)
                  const Sparkles()
                else
                  Container(),
                // Main content
                SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            // Bounce animation for practice more message
                            if (widget.score < 7)
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
                              'Sait ${widget.score} / ${GameConstants.totalRounds} pistettä!',
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
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
