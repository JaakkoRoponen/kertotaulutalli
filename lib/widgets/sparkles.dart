import 'dart:math';
import 'package:flutter/material.dart';

class Sparkles extends StatefulWidget {
  const Sparkles({super.key});

  @override
  State<Sparkles> createState() => _SparklesState();
}

class _SparklesState extends State<Sparkles>
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

